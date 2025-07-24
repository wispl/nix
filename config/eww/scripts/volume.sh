#!/usr/bin/env bash

get_id() {
	re="update: id:[0-9]+ key:'default.audio.sink' value:'\{\"name\":\"([A-Za-z0-9_.-]+)"
	pw-metadata | while read -r line; do
		if [[ $line =~ $re ]]; then
			name="${BASH_REMATCH[1]}"
			pw-dump | jq --arg name "$name" '.[] | select(.info.props."node.name"==$name).info.props."device.id"'
		fi
	done
}

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
	wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1%"
}

subscribe() {
	id=$(get_id)
	id=$(get_id)
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
