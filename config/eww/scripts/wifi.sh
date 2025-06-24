#!/usr/bin/env sh

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

subscribe() {
	cat /sys/class/net/wlan0/operstate
	rfkill event | while read -r line; do
		case "$line" in
			*"type 1 op 2 soft 1"*)
				echo "down"
				;;
			*"type 1 op 2 soft 0"*)
				echo "up"
				;;
		esac
	done
}

toggle() {
	#TODO: check if iwctl device wlan0 set-property Powered off/on should be used instead
	rfkill toggle wlan
}

case $1 in
	"subscribe")
		subscribe
		;;
	"toggle")
		toggle
		;;
esac
