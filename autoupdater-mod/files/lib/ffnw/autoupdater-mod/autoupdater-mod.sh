#!/bin/sh

cleanup () {
	rm -rf /usr/lib/micron.d/autoupdater-mod
	rm -rf /lib/ffnw/autoupdater-mod
	}

find /usr/sbin/ -name "autoupdater"
if [ $? -eq 0 ]; then
	mv /lib/ffnw/autoupdater-mod/autoupdater /usr/sbin/autoupdater
	mv /lib/ffnw/autoupdater-mod/autoupdater-cron /usr/lib/micron.d/autoupdater
	cleanup
else
	cleanup
fi

