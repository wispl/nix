#!/usr/bin/env sh

# TODO: needs new release of mako for deflisten
busctl -j --user call org.freedesktop.Notifications /fr/emersion/Mako fr.emersion.Mako ListHistory

