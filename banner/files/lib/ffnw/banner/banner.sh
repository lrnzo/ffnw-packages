#!/bin/sh

cleanup () {
	rm -rf /usr/lib/micron.d/ffnw-banner
	rm -rf /lib/ffnw/banner
	}

	grep -Fxvf /etc/banner /lib/ffnw/banner/banner > /dev/null
if [ $? -eq 0 ]; then
	mv /lib/ffnw/banner/banner /etc/banner
	cleanup
else
	cleanup
fi

