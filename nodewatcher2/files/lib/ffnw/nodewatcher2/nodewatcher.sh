#!/bin/sh
#OUTPUT_DATA_FILE="$(uci get nodewatcher2.@script[0].data_file)"

hostname="$(cat /proc/sys/kernel/hostname)"
times_up="$(sed -r 's/([0-9.]+) ([0-9.]+)/\1/' /proc/uptime)"
times_idle="$(sed -r 's/([0-9.]+) ([0-9.]+)/\2/' /proc/uptime)"

position_lon="$(uci get gluon-node-info.@location[0].longitude)"
position_lat="$(uci get gluon-node-info.@location[0].latitude)"
clientcount="$(($(batctl tl|wc -l) - 3))"
model="$(grep -E '^machine' /proc/cpuinfo|sed -r 's/machine[[:space:]]*:[[:space:]]*(.*)/\1/')"
mac="$(ifconfig |grep bat0|sed -r 's/.*HWaddr ([0-9A-F:]*)[[:space:]]*/\1/'|tr '[ABCDEF]' '[abcdef]')"

memory_total="$(grep -E "^MemTotal:" /proc/meminfo|sed -r 's/.*:[[:space:]]+([0-9]+) kB/\1/')"
memory_free="$(grep -E "^MemFree:" /proc/meminfo|sed -r 's/.*:[[:space:]]+([0-9]+) kB/\1/')"
memory_cache="$(grep -E "^Cached:" /proc/meminfo|sed -r 's/.*:[[:space:]]+([0-9]+) kB/\1/')"
memory_buffer="$(grep -E "^Buffers:" /proc/meminfo|sed -r 's/.*:[[:space:]]+([0-9]+) kB/\1/')"

set -- $(sed -r "s/[0-9.]+ [0-9.]+ ([0-9.]+) ([0-9]+)\/([0-9]+) [0-9]+/\1 \2 \3/" /proc/loadavg)
processes_total=$3
processes_runnable=$2
processes_loadavg=$1

software_firmware="$(cat /lib/gluon/release)"
software_kernel="$(uname -r)"
software_mesh="B.A.T.M.A.N. $(cat /sys/module/batman_adv/version)"
software_vpn="$(fastd -v)"

software_autoupdate_enabled="$(uci get autoupdater.settings.enabled 2>/dev/null)"
software_autoupdate_branch="$(uci get autoupdater.settings.branch 2>/dev/null)"



ifc=0
for filename in `grep 'up\|unknown' /sys/class/net/*/operstate`; do
	ifpath=${filename%/operstate*}
	iface=${ifpath#/sys/class/net/}
	if [ "$iface" = "lo" ]; then
		continue
	fi
	eval interface${ifc}_name="\"$iface\""

	local addrs="$(ip addr show dev ${iface})"
	eval interface${ifc}_mtu=$(echo \"$addrs\" | grep -E "mtu"|sed -r "s/.* mtu ([0-9]+) .*/\1/")
	eval interface${ifc}_mac=$(echo \"$addrs\" | grep -E "link/ether"|sed -r "s/.* link\/ether ([0-9a-f:]+) .*/\1/")

	eval "interface${ifc}_traffic_rx=\"$(cat $ifpath/statistics/rx_bytes)\""
	eval "interface${ifc}_traffic_tx=\"$(cat $ifpath/statistics/tx_bytes)\""
#	echo -e $addrs | grep -E 'inet '|sed -r 's/.* inet ([0-9.]+)(\/[0-9]+)? .*/\1/'
  	eval "interface${ifc}_ipv4=\"$(echo -e \"$addrs\" | grep -E 'inet '|sed -r 's/.* inet ([0-9.]+)(\/[0-9]+)? .*/\1/')\""
#	eval "echo \"ip: \$interface${ifc}_ipv4\""
	local ipv6_adresses=$(echo "$addrs" | grep -E 'inet6 ' |sed -r 's/[[:space:]]*inet6 (([0-9a-f:]+)(\/[0-9]*)?) .*/\2/')
	local ipc=0
#	echo $ipv6_adresses
	for ip in $ipv6_adresses ;do
		echo "--"$ip
		eval "interface${ifc}_ipv6_${ipc}=\"$ip\""
		ipc=$(($ipc+1)) 
	done
	eval "interface${ifc}_ipv6count=$ipc"
	

	if [ "$iface" != "bat0" ] ; then
		local tmp=$(cat "/sys/class/net/$iface/batman_adv/iface_status")
		if [ "$tmp" != "not in use" ] ; then
			eval interface${ifc}_meshstatus=\"$tmp\"
		fi
	fi
	

	local iwi="$(iwinfo ${iface} info 2>/dev/null)"
	if [ "$iwi" != "" ] ; then
		eval "interface${ifc}_txpower=\"\$(echo \"${iwi}\"|grep 'Tx-Power'|sed -r 's/[[:space:]]+Tx-Power:[[:space:]]+([0-9]+).*/\1/')\""
		eval "interface${ifc}_channel=\"\$(echo \"${iwi}\"|grep 'Channel: '|sed -r 's/.*Channel:[[:space:]]+([0-9]+).*/\1/')\""
		eval "interface${ifc}_linkquality=\"\$(echo \"${iwi}\"|grep 'Link Quality: '|sed -r 's/.*Link Quality:[[:space:]]+(([0-9]+|unknown)\/[0-9]+).*/\1/')\"" 
	fi
	ifc=$(($ifc+1))
done

orc=0
origs="$(batctl o|sed -r 's/([0-9a-f:]+)[[:space:]]+([0-9.]+)s[[:space:]]+\([[:space:]]*([0-9]{1,3})\)[[:space:]]+([0-9a-f:]+)[[:space:]]+\[[[:space:]]*(.+)\]:.*/\1 \2 \3 \4 \5/;tx;d;:x')"

OIFS="$IFS"
NIFS=$'\n'
IFS="${NIFS}"
#echo "$origs"
for orig in $origs ; do
	IFS="${OIFS}"
	set -- $orig
	eval "originator${orc}_mac=\"$1\""
	eval "originator${orc}_linkquality=\"$3\""
	eval "originator${orc}_lastseen=\"$2\""
	eval "originator${orc}_nexthop=\"$4\""
	eval "originator${orc}_interface=\"$5\""

 	if eval "[ \"\${originator${orc}_mac}\" != \"\${originator${orc}_nexthop}\" -o \"\${originator${orc}_interface}\" == \"mesh-vpn\" ]"
	then
	#	eval "echo \"\$originator${orc}_mac  --    \$originator${orc}_nexthop\"" 
	#	echo "skipped"
		continue
	fi
	orc=$(($orc+1))
	IFS="${NIFS}"
done
IFS="${OIFS}"

gwc=0
gws="$(batctl gwl|sed -r 's/^[[:space:]]+([a-f0-9:].*)/false \1/ ; s/^=>(.*)/true \1/ ; s/(true|false)[[:space:]]+([0-9a-f:]+)[[:space:]]+\([[:space:]]*([0-9]+)\)[[:space:]]+[a-f0-9:]+[[:space:]]+\[[[:space:]]*(.+)\]:[[:space:]]+([0-9.\/]+).*$/\1 \2 \3 \4 \5/;tx;d;:x')" 
#echo "$gws"
IFS="${NIFS}"
for gw in $gws ; do
	IFS=${OIFS} 
#	gw="$(echo "$gw"|sed -r 's/^[[:space:]]+(.*)/false \1/ ; s/^=>(.*)/true \1/ ; s/(true|false)[[:space:]]+([0-9a-f:]+)[[:space:]]+\([[:space:]]*([0-9]+)\)[[:space:]]+[a-f0-9:]+[[:space:]]+\[[[:space:]]*(.+)\]:[[:space:]]+([0-9.\/]+).*$/\1 \2 \3 \4 \5/;tx;d;:x')" 
#	echo "$gw"
	set -- $gw
#	echo "sel: $1"	
	eval "gateway${gwc}_mac=\"$2\""
	eval "gateway${gwc}_selected=\"$1\""
	eval "gateway${gwc}_linkquality=\"$3\""
	eval "gateway${gwc}_class=\"$5\""
	eval "gateway${gwc}_interface=\"$4\""

	gwc=$(($gwc+1))
	IFS=${NIFS}  
done
IFS=${OIFS}  

#################################output to xml
out="<?xml version='1.0' ?>\n"
out=$out"<data>\n"
out=$out"\t<hostname>"$hostname"</hostname>\n"
out=$out"\t<times>\n\t\t<up>$times_up</up>\n\t\t<idle>"$times_idle"</idle>\n\t</times>\n"
out=$out"\t<model>"$model"</model>\n"
out=$out"\t<mac>"$mac"</mac>\n"
if [ $(uci get gluon-node-info.@location[0].share_location) = "1" ] ; then
	out=$out"\t<position>\n"
	out=$out"\t\t<lon>"$position_lon"</lon>\n"
	out=$out"\t\t<lat>"$position_lon"</lat>\n"
	out=$out"\t</position>\n"
fi
out=$out"\t<memory>\n"
out=$out"\t\t<total>"$memory_total"</total>\n"
out=$out"\t\t<free>"$memory_free"</free>\n" 
out=$out"\t\t<buffer>"$memory_buffer"</buffer>\n" 
out=$out"\t\t<cache>"$memory_cache"</cache>\n" 
out=$out"\t</memory>\n"
out=$out"\t<processes>\n"
out=$out"\t\t<runnable>$processes_runnable</runnable>\n"
out=$out"\t\t<total>$processes_total</total>\n"
out=$out"\t\t<loadavg>$processes_loadavg</loadavg>\n"  
out=$out"\t</processes>\n"
out=$out"\t<software>\n"
out=$out"\t\t<firmware>"$software_firmware"</firmware>\n"
out=$out"\t\t<kernel>"$software_kernel"</kernel>\n"
out=$out"\t\t<mesh>"$software_mesh"</mesh>\n"
out=$out"\t\t<vpn>"$software_vpn"</vpn>\n" 
if [ "$software_autoupdate_enabled" = "1" ] ; then
	out="$out\t\t<autoupdate_branch>$software_autoupdate_branch</autoupdate_branch>\n"
#	out="$out\t\t\t<enabled>$software_autoupdate_enabled</enabled>\n"
#	out="$out\t\t\t<branch>$software_autoupdate_branch</branch>\n"  
#	out="$out\t\t</autoupdate>\n"
fi
out=$out"\t</software>\n" 
out=$out"\t<interfaces>\n"

for i in $(seq 0 $(($ifc-1))) ; do
	out=$out"\t\t<interface>\n"
	eval "out=\"\${out}\t\t\t<name>\${interface${i}_name}</name>\n\""

	eval "out=\"\${out}\t\t\t<mtu>\${interface${i}_mtu}</mtu>\n\""
	eval "out=\"\${out}\t\t\t<mac>\${interface${i}_mac}</mac>\n\""
	out="$out\t\t\t<traffic>\n"
	eval "out=\"\${out}\t\t\t\t<rx>\${interface${i}_traffic_rx}</rx>\n\""
	eval "out=\"\${out}\t\t\t\t<tx>\${interface${i}_traffic_tx}</tx>\n\"" 
	out=$out"\t\t\t</traffic>\n"

        eval "local meshstatus=\${interface${i}_meshstatus}"
        if [ "$meshstatus" != "" ] ; then
                                                                   



		eval "out=\"\${out}\t\t\t<meshstatus>\${interface${i}_meshstatus}</meshstatus>\n\""
	fi

	eval "local ipv4=\"\${interface${i}_ipv4}\"" 
#	echo "ip4: $ipv4"
	if [ "$ipv4" != "" ]; then
		out=$out"\t\t\t<ipv4>$ipv4</ipv4>\n" 
	fi


	eval "ic=\${interface${i}_ipv6count}"

	if [ "$ic" != "0" ] ; then
	        for ip in $(seq 0 $(($ic-1))) ; do
        	       	eval "out=\"$out\t\t\t<ipv6>\${interface${i}_ipv6_${ip}}</ipv6>\n\""                                                                                                       
#        	       	echo "hi$ip"
			#eval interface${ifc}_ipv6_$ip=$ip                                                                             
        	done    
	fi
	
	eval "local txp=\"\${interface${i}_txpower}\""
	eval "local ch=\"\${interface${i}_channel}\""
#	if [ "$txp" != "" ]
	if eval "[ \"\${interface${i}_txpower}\" != \"\"  ]"
	then
		out="$out\t\t\t<txpower>$txp</txpower>\n"      
		out="$out\t\t\t<channel>$ch</channel>\n"      
		eval "out=\"$out\t\t\t<linkquality>\${interface${i}_linkquality}</linkquality>\n\""
	fi	

	out=$out"\t\t</interface>\n"
done
out="$out\t</interfaces>\n"

if [ "$orc" != "0" ] ; then
	out="$out\t<originators>\n"
	for i in $(seq 0 $(($orc-1))) ; do 
		out="$out\t\t<originator>\n"
		eval "out=\"$out\t\t\t<mac>\${originator${i}_mac}</mac>\n\"" 
		eval "out=\"$out\t\t\t<linkquality>\${originator${i}_linkquality}</linkquality>\n\""
		eval "out=\"$out\t\t\t<lastseen>\${originator${i}_lastseen}</lastseen>\n\""
		eval "out=\"$out\t\t\t<interface>\${originator${i}_interface}</interface>\n\""

		out="$out\t\t</originator>\n"
	done
	out="$out\t</originators>\n"
fi

if [ "$gwc" != "0" ] ; then
	out="$out\t<gateways>\n"
	for g in $(seq 0 $(($gwc-1))) ; do
		out="$out\t\t<gateway>\n"
		eval "out=\"$out\t\t\t<mac>\${gateway${g}_mac}</mac>\n\""


		eval "out=\"$out\t\t\t<selected>\${gateway${g}_selected}</selected>\n\""
		eval "out=\"$out\t\t\t<linkquality>\${gateway${g}_linkquality}</linkquality>\n\""
eval "out=\"$out\t\t\t<interface>\${gateway${g}_interface}</interface>\n\""
		eval "out=\"$out\t\t\t<class>\${gateway${g}_class}</class>\n\""
		out="$out\t\t</gateway>\n"
 		
	done
	out="$out\t</gateways>\n"
fi

out="$out</data>"


echo -e "$out" > "/tmp/node2data.xml"
