#!/usr/bin/env bash

get_volume() {
	# this gives a reuslt in the form Volume: 0.11 [MUTED]
	wp=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
	vol="${wp#Volume: }"
	case "$wp" in
		*"MUTED"*)
			echo "{\"vol\":${vol%" [MUTED]"},\"muted\":true}"
			;;
		*)
			echo "{\"vol\":${vol},\"muted\":false}"
			;;
	esac
}

set_volume() {
	if [ "$1" -gt "100" ]; then
		exit 1;
	elif [ "$1" -lt "0" ]; then
		exit 1;
	fi
	wpctl get-volume @DEFAULT_AUDIO_SINK@ "$1%"
}

subscribe() {
	# these get us something along the lines of "id ##"
	wp=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | head -n 1)
	wp="${wp%,*}"
	# strip leading id
	id="${wp#id }"

	# pw-mon does not output as many lines as pw-cli -m
	while read -r line; do
		case "$line" in
			*$id*)
				get_volume
				;;
		esac
	done < <(pw-mon -oa)
}


case $1 in
	"subscribe")
		subscribe
		;;
	"set")
		set_volume "$2"
		;;
	"get")
		get_volume
		;;
esac
