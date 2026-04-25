#!/usr/bin/env bash
# ── Random Wallpaper from minimalistic-wallpaper API ─
WALLPAPER_DIR="$HOME/.config/hypr/wallpaper"
mkdir -p "$WALLPAPER_DIR"

out="$WALLPAPER_DIR/random-$(date +%s).jpg"
curl -sL "https://minimalistic-wallpaper.demolab.com/?random=$RANDOM" -o "$out"
swww img "$out" --transition-type fade --transition-duration 1
notify-send "Wallpaper" "New random wallpaper set"
