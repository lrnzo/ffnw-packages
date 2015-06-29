#!/bin/sh

#Get the configuration from the uci configuration file
#If it does not exists, then get it from a normal bash file with variables.
if [ -f /etc/config/geolocator ];then
	SCRIPT_NIN_QUALITY=`uci get geolocator.@script[0].min_quality`
	SCRIPT_NUM_LENGTH=`uci get geolocator.@script[0].geo_num_length`
	SCRIPT_IMPROBABILITY=`uci get geolocator.@script[0].improbability`
	SCRIPT_MOBILE=`uci get geolocator.@script[0].mobile`
	SCRIPT_PIDPART=`uci get geolocator.@script[0].pidpart`
else
	. `dirname $0`/geolocator_config
fi

if [ -f $SCRIPT_PIDPART ]; then
	echo "The geolocator is still running"
	exit 0
else
	touch $SCRIPT_PIDPART
fi

Clean_pid() {
	if [ -f $SCRIPT_PIDPART ]; then
		rm $SCRIPT_PIDPART
	fi
	exit 0
}

Get_geolocation_info() {
	LWTRACE=`lwtrace -t 2> /dev/null`
	echo $LWTRACE | grep "Scan completed : Your location:" >> /dev/null
	if [ $? -eq "0" ]; then
		last_arr_val="";
		for x in $LWTRACE
		do
			if [ $x == '(lat)' ]; then
				LAT=$last_arr_val;
			fi
			if [ $x == '(lon)' ]; then
				LON=$last_arr_val;
			fi
			if [ $x == '%' ]; then
				QUALITY=$last_arr_val;
			fi
			last_arr_val=$x;
		done
		return 0
	else
		return 1
	fi
}

#Ceck_geocoordinate() {
#	if echo $1 | grep -E "^[+-]?[0-9]+(\.[0-9]+)?$" >> /dev/null
#	then
#		if echo $1 | grep -v -E "^[0-9]+(\.[0-9]*(0{3}|1{3}|2{3}|3{3}|4{3}|5{3}|6{3}|7{3}|8{3}|9{3})[0-9]*)?$" >> /dev/null
#		then
#			return 1
#		fi
#	else
#		return 1
#	fi
#	return 0
#}

Get_gluon_share_location() {
	# 1 holt sich eine neue Position 0 nicht
	SHARE_LOCATION=`uci get gluon-node-info.@location[0].share_location`
	if [ $SHARE_LOCATION -eq 1 ]; then
		echo "Schare location 1"
		GLUON_LAT=`uci get gluon-node-info.@location[0].latitude`
		GLUON_LON=`uci get gluon-node-info.@location[0].longitude`
		# 1. Prüfe auf reine zahlen && die zahlenlänge
		if echo $GLUON_LAT | grep -E "^[0-9]+(\.[0-9]+)?$" >> /dev/null
		then
			echo "Es sind nur zahlen"
			if ! [ ${#GLUON_LAT} < $SCRIPT_NUM_LENGTH ]; then
				echo "geo ist größer als mindes geo"
				# 2. Prüfe warscheinlichkeit
				if echo $GLUON_LAT | grep -E "^[0-9]+(\.[0-9]*(0{${SCRIPT_IMPROBABILITY}}|1{${SCRIPT_IMPROBABILITY}}|2{${SCRIPT_IMPROBABILITY}}|3{${SCRIPT_IMPROBABILITY}}|4{${SCRIPT_IMPROBABILITY}}|5{${SCRIPT_IMPROBABILITY}}|6{${SCRIPT_IMPROBABILITY}}|7{${SCRIPT_IMPROBABILITY}}|8{${SCRIPT_IMPROBABILITY}}|9{${SCRIPT_IMPROBABILITY}})[0-9]*)?$" >> /dev/null
				then
					echo "es sind keine x gleichen zahlen beinhaltend"
					return 0
				fi
			fi
		fi
#		Ceck_geocoordinate $GLUON_LAT
	fi
	return 1
}

# Hol sich die geo position durch die Triangulation
#Get_geolocation_info
#if [ $? -eq 0 ]; then
	Get_gluon_share_location
	echo $?
#	if [ $? -eq 1 ]; then
#		echo "location wird geändert"
#	else
#		echo "location wird nich geändert"
#	fi
#	echo $LAT
#	echo $LON
#	echo $QUALITY
#	echo "----------"
#else
#	echo "lwtrace doesn't gif a location";
#fi;
#echo $SCRIPT_NIN_QUALITY
Clean_pid
