#!/usr/bin/env bash

# this is probably not a good idea, should use dbus api in an non-shell language
subscribe() {
	bluetoothctl show | grep PowerState | awk '{print $2}'

	# Bluetoothctl changes multiple properties when we are powering and off
	# the adapter, which sends multiple messages to dbus-monitor. It is not
	# a good idea to call bluetoothctl show multiple times a second so
	# we instead search for off-enabling and on-disabling specifically.
	# This sadly means we can't not use --profile for dbus-monitor...
	interface="org.freedesktop.DBus.Properties"
	path="/org/bluez/hci0"
	member="PropertiesChanged"
	while read -r line; do
		case "$line" in
			*"off-enabling"*)
				echo "on"
				;;
			*"on-disabling"*)
				echo "off"
				;;
			*)
				;;
		esac
	done < <(dbus-monitor --system "type='signal',interface='${interface}',path='${path}',member='${member}'")
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
