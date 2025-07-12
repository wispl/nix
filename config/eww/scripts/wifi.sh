#!/usr/bin/env bash

# TODO: move to custom script
# connect() {
# 	networks=$(iwctl known-networks list)
# 	# remove escape sequences
# 	cleaned=$(sed -e $'s/\x1b\[[0-9;]*m//g' <<< "$networks")
# 	# get ssids
# 	filtered=$(awk 'NR>4 {print $1}' FS="   " OFS="   " <<< "$cleaned")
#
# 	ssid=$(echo "$filtered" | fuzzel -p "Connect: " -d)
# 	# strip the two leading spaces
# 	iwctl station wlan0 connect "${ssid:2}"
# }

ssid() {
	ssid=$(iwctl station wlan0 show | grep "Connected network")
	ssid=${ssid##*Connected network}

	# trim leading and ending whitespace, from:
	# https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
	ssid="${ssid#"${ssid%%[![:space:]]*}"}"
	ssid="${ssid%"${ssid##*[![:space:]]}"}"

	echo "$ssid"
}

get_network_state() {
	case "$1" in
		*" DOWN "*)
			echo "{\"state\":\"down\",\"ssid\":\"offline\"}"
			;;
		*" UP "*)
			echo "{\"state\":\"up\",\"ssid\":\"$(ssid)\"}"
			;;
	esac
}

events() {
	get_network_state "$(ip link show wlan0)"
	while read -r line; do
		get_network_state "$line"
	done < <(ip monitor link dev wlan0)
}

oper_events() {
	cat /sys/class/net/wlan0/operstate
	while read -r line; do
		case "$line" in
			*"type 1 op 2 soft 1"*)
				echo "down"
				;;
			*"type 1 op 2 soft 0"*)
				echo "up"
				;;
		esac
	done < <(rfkill event)
}

toggle() {
	#TODO: check if iwctl device wlan0 set-property Powered off/on should be used instead
	rfkill toggle wlan
}

case $1 in
	"oper_events")
		oper_events
		;;
	"events")
		events
		;;
	"toggle")
		toggle
		;;
esac
