#!/usr/bin/env bash

subscribe() {
	# TODO: add urgent, currently niri event-stream does not seem to report this?
	urgent=""
	focused=$(echo "$line" | jq ".WorkspaceActivated.id")
	windows=$(niri msg --json windows | jq --argjson id "$focused" 'map(select(.workspace_id==$id))')
	count=$(echo "$windows" | jq length)
	layout=$(echo "$windows" | jq 'any(.[]; .is_floating)')
	occupied=$(niri msg --json windows | jq -c '[.[] | .workspace_id] | unique')
	while read -r line; do
		case "$line" in
			*"WorkspaceActivated"*)
				focused=$(echo "$line" | jq ".WorkspaceActivated.id")
				windows=$(niri msg --json windows | jq --argjson id "$focused" 'map(select(.workspace_id==$id))')
				count=$(echo "$windows" | jq length)
				layout=$(echo "$windows" | jq 'any(.[]; .is_floating)')
				echo "{\"focused\":$focused,\"count\":$count,\"layout\":$layout,\"occupied\":$occupied}"
				;;
			*"WorkspaceUrgencyChanged"*)
				echo "{\"focused\":$focused,\"count\":$count,\"layout\":$layout,\"occupied\":$occupied}"
				;;
			*"WindowOpenedOrChanged"*)
				occupied=$(niri msg --json windows | jq -c '[.[] | .workspace_id] | unique')
				layout=$(echo "$windows" | jq 'any(.[]; .is_floating)')
				echo "{\"focused\":$focused,\"count\":$count,\"layout\":$layout,\"occupied\":$occupied}"
				;;
			*"WindowClosed"*)
				occupied=$(niri msg --json windows | jq -c '[.[] | .workspace_id] | unique')
				layout=$(echo "$windows" | jq 'any(.[]; .is_floating)')
				echo "{\"focused\":$focused,\"count\":$count,\"layout\":$layout,\"occupied\":$occupied}"
				;;
		esac
	done < <(niri msg --json event-stream)
}

subscribe
