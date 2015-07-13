#!/bin/sh

AUTO_LOCATION=`uci get gluon-node-info.@location[0].auto_location`
if [ $AUTO_LOCATION -eq 0 ]; then
	exit 0
fi

PID_PART="/var/run/geolocator.pid"
TIME_STAMP="/tmp/geolocator_timestamp"

if [ -f $PID_PART ]; then
	echo "The geolocator is still running"
	exit 0
else
	touch $PID_PART
fi

Clean_pid() {
	if [ -f $PID_PART ]; then
		rm $PID_PART
	fi
	exit 0
}

# Get localization interval
INTERVAL=`uci get gluon-node-info.@location[0].refresh_interval`

# get position
Get_geolocation_info() {
	LWTRACE=`lwtrace -t 2> /dev/null`
	echo $LWTRACE | grep "Scan completed : Your location:" >> /dev/null
	if [ $? -eq "0" ]; then
		last_val="";
		for x in $LWTRACE
		do
			if [ $x == '(lat)' ]; then
				LAT=$last_val;
			fi
			if [ $x == '(lon)' ]; then
				LON=$last_val;
			fi
			if [ $x == '%' ]; then
				QUALITY=$last_val;
			fi
			last_val=$x;
		done
		return 0
	else
		echo "lwtrace doesn't gif a location";
		return 1
	fi
}

#check if interval over or not exist
if [ ! -f $TIME_STAMP ] || [ $(( `date +%s` - `cat $TIME_STAMP` )) -gt $(( $INTERVAL * 60 )) ]; then
	Get_geolocation_info
	if [ $? -eq 1 ]; then
		Clean_pid
	fi
	#ceck if static location true or not
	STATIC_LOCATION=`uci get gluon-node-info.@location[0].static_location`
	if [ $STATIC_LOCATION -eq 0 ]; then
		SHARE_LOCATION=`uci get gluon-node-info.@location[0].share_location`
		if [ $SHARE_LOCATION -eq 0 ] then
			$(uci set gluon-node-info.@location[0].share_location=1)
		fi
		$(uci set gluon-node-info.@location[0].latitude=$LAT)
		$(uci set gluon-node-info.@location[0].longitude=$LON)
		`uci commit gluon-node-info`
	fi
	date +%s > $TIME_STAMP
fi
Clean_pid
