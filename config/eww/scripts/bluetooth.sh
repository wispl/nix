#!/usr/bin/env sh

# dbus-monitor implementation, issue is --profile does not display payload
# while using it without --profile splits the payload across lines
#
# interface="org.freedesktop.DBus.Properties"
# path="/org/bluez/hci0"
# member="PropertiesChanged"
#
# dbus-monitor --system --profile "type='signal',interface='${interface}',path='${path}',member='${member}'" |
# while read -r line; do
# 	echo "$line"
# done

# this is probably not a good idea, should use dbus api in an non-shell language
subscribe() {
	bluetoothctl show | grep PowerState | awk '{print $2}'
	while true; do
		line=$(busctl wait org.bluez /org/bluez/hci0 org.freedesktop.DBus.Properties PropertiesChanged)
		case "$line" in
			*" \"PowerState\" s \"on-disabling\""*)
				echo "off"
				;;
			*" \"PowerState\" s \"off-enabling\""*)
				echo "on"
				;;
		esac
	done
}

power_on() {
	bluetoothctl power on
}

power_off() {
	bluetoothctl power off
}

case $1 in
	"subscribe")
		subscribe
		;;
	"power_on")
		power_on
		;;
	"power_off")
		power_off
		;;
esac
