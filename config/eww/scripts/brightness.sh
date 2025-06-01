#!/usr/bin/env bash

# TODO: convert from polling into deflisten
brightnessctl i | grep -oP '\(\K[^%\)]+'


