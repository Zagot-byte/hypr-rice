#!/usr/bin/env bash
# ── Wallpaper Selector ───────────────────────────────
WALLPAPER_DIR="$HOME/.config/hypr/wallpaper"

# Pick with rofi
selected=$(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" \) | \
    rofi -dmenu -p "Wallpaper" \
         -show-icons \
         -display-columns 1)

[[ -z "$selected" ]] && exit 0

swww img "$selected" \
    --transition-type fade \
    --transition-duration 1
