#!/usr/bin/env sh

capacity=$(cat /sys/class/power_supply/BAT0/capacity)
charging=$(cat /sys/class/power_supply/BAT0/status)

echo "{\"capacity\":$capacity,\"status\":\"$charging\"}"
