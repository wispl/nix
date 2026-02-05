#!/usr/bin/env bash

set_profile() {
	case "$1" in
		power-saver|balanced|performance)
			notify-send "Power Profile Daemon" "Profile is now in '$1' mode."
			tlpctl set "$1"
			;;
		*)
			;;
	esac
}

# Just cat it because powerprofilesctl takes a while
subscribe() {
	cat /sys/firmware/acpi/platform_profile

	interface="org.freedesktop.DBus.Properties"
	path="/org/freedesktop/UPower/PowerProfiles"
	member="PropertiesChanged"
	while read -r line; do
		case "$line" in
			*"$path"*)
				cat /sys/firmware/acpi/platform_profile
				;;
			*)
				;;
		esac
	done < <(dbus-monitor --system --profile "type='signal',interface='${interface}',path='${path}',member='${member}'")
}

case $1 in
	"subscribe")
		subscribe
		;;
	"set")
		set_profile "$2"
		;;
esac
