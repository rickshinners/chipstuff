#!/bin/bash

## Check for root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

## Install i2c-tools
command -v i2cdetect >/dev/null 2>&1 || { apt-get install i2c-tools -y; }

wget -O /usr/local/bin/gpio.sh http://fordsfords.github.io/gpio_sh/gpio.sh
service blink stop
wget -O /usr/local/bin/blink.sh http://fordsfords.github.io/blink/blink.sh
chmod +x /usr/local/bin/blink.sh
wget -O /etc/systemd/system/blink.service http://fordsfords.github.io/blink/blink.service
systemctl enable /etc/systemd/system/blink.service

if [[ ! -f /usr/local/etc/blink.cfg ]]; then
	wget -O /usr/local/etc/blink.cfg http://fordsfords.github.io/blink/blink.cfg
fi

service blink start
