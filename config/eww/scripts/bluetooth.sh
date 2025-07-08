#!/usr/bin/env bash

# this is probably not a good idea, should use dbus api in an non-shell language
subscribe() {
	bluetoothctl show | grep PowerState | awk '{print $2}'

	interface="org.freedesktop.DBus.Properties"
	path="/org/bluez/hci0"
	member="PropertiesChanged"
	while read -r line; do
		echo "$line"
		bluetoothctl show | grep PowerState | awk '{print $2}'
	done < <(dbus-monitor --system --profile "type='signal',interface='${interface}',path='${path}',member='${member}'")
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

	# bluetoothctl show | grep PowerState | awk '{print $2}'
	#
	# interface="org.freedesktop.DBus.Properties"
	# path="/org/bluez/hci0"
	# member="PropertiesChanged"
	# while read -r line; do
	# 	bluetoothctl show | grep PowerState | awk '{print $2}'
	# done < <(dbus-monitor --system --profile "type='signal',interface='${interface}',path='${path}',member='${member}'")
	#
