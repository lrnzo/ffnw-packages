#!/bin/sh

#Get the configuration from the uci configuration file
#If it does not exists, then get it from a normal bash file with variables.
if [ -f /etc/config/geolocator ];then
	SCRIPT_NIN_QUALITY=`uci get geolocator.@script[0].min_quality`
	SCRIPT_IMPROBABILITY=`uci get geolocator.@script[0].improbability`
else
	. `dirname $0`/geolocator_config
fi

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

Ceck_geocoordinate() {
	if echo $1 | grep -E "^[+-]?[0-9]+(\.[0-9]+)?$" >> /dev/null
	then
		if echo $1 | grep "$SCRIPT_IMPROBABILITY" >> /dev/null
		then
			return 1
		fi
	else
		return 1
	fi
	return 0
}

Get_gluon_share_location() {
	SHARE_LOCATION=`uci get gluon-node-info.@location[0].share_location`
	GLUON_LAT=`uci get gluon-node-info.@location[0].latitude`
	GLUON_LON=`uci get gluon-node-info.@location[0].longitude`
	if [ $SHARE_LOCATION -eq 1 ]; then
		Ceck_geocoordinate $GLUON_LAT
		if [ $? -eq 1 ]; then
			return 1
		fi
		Ceck_geocoordinate $GLUON_LON
		if [ $? -eq 1 ]; then
			return 1
		fi
	else
		return 1
	fi
	return 0
}

Get_geolocation_info
if [ $? -eq 0 ]; then
	Get_gluon_share_location
	if [ $? -eq 1 ]; then
		echo "location wird geändert"
	else
		echo "location wird nich geändert"
	fi
	echo $LAT
	echo $LON
	echo $QUALITY
	echo "----------"
else
	echo "lwtrace doesn't gif a location";
fi;
echo $SCRIPT_NIN_QUALITY
exit 0
