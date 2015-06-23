#!/bin/sh

cleanup () {
	rm -rf /lib/gluon/cron/ffnw-banner
	rm -rf /lib/ffnw/banner
	}

	grep -Fxvf /etc/banner /lib/ffnw/banner/banner > /dev/null
if [ $? -eq 0 ]; then
	mv /lib/ffnw/banner/banner /etc/banner
	cleanup
else
	cleanup
fi

