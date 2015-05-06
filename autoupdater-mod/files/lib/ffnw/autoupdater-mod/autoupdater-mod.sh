#!/bin/sh

cleanup () {
	rm -rf /lib/gluon/cron/autoupdater-mod
	rm -rf /lib/ffnw/autoupdater-mod
	}

find /usr/sbin/ -name "autoupdater"
if [ $? -eq 0 ]; then
	mv /lib/ffnw/autoupdater-mod/autoupdater /usr/sbin/autoupdater
	cleanup
else
	cleanup
fi

