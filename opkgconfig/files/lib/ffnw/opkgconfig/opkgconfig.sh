#!/bin/sh

cleanup () {
	rm -rf /lib/gluon/cron/opkgconfig
	rm -rf /lib/ffnw/opkgconfig
	}

if [ -e /etc/config/fastdreg ]; then
	rm /etc/config/fastdreg
fi

grep -Fxvf /etc/opkg.conf /lib/ffnw/opkgconfig/opkg.conf > /dev/null
if [ $? -eq 0 ]; then
	mv /lib/ffnw/opkgconfig/opkg.conf /etc/opkg.conf
	cleanup
else
	cleanup
fi

