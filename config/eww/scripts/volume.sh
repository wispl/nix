#!/usr/bin/env bash

# TODO: convert from polling into deflisten
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
echo "${vol:8}"



