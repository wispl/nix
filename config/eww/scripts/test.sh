#!/usr/bin/env sh


riverstream -t 5 | while read -r line; do
	echo "$line"
done
