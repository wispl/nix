#!/usr/bin/env sh

json() {
	state=$(mpc status %state%)
	name=$(mpc current -f "%title%")

	file=$(mpc current -f "%file%")
	cover="${XDG_MUSIC_DIR}/${file%/*}/cover.jpg"
	if [ ! -f "$cover" ]; then
		cover=""
	fi
	printf '{"art": "%s", "state": "%s", "name": "%s"}\n' "$cover" "$state" "$name"
}

subscribe() {
	json
	mpc idleloop "player" | while read -r; do
		json
	done
}

next() {
	mpc next
}

toggle() {
	mpc toggle
}

prev() {
	mpc prev
}

case $1 in
	"initial")
		json
		;;
	"subscribe")
		subscribe
		;;
	"next")
		next
		;;
	"toggle")
		toggle
		;;
	"prev")
		prev
		;;
	*)
		echo ""
		;;
esac
