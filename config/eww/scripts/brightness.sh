#!/usr/bin/env sh

get_brightness() {
	brightnessctl i | grep -oP '\(\K[^%\)]+'
}

set_brightness() {
	if [ "$1" -gt "100" ]; then
		exit 1;
	elif [ "$1" -lt "0" ]; then
		exit 1;
	fi
	brightnessctl set "$1%"
}

subscribe() {
	get_brightness
	while (inotifywait -e modify /sys/class/backlight/?*/brightness -qq); do
		get_brightness
	done
}

case $1 in
	"subscribe")
		subscribe
		;;
	"set")
		set_brightness "$2"
		;;
	"get")
		get_brightness
		;;
esac
