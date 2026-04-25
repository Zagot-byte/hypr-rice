#!/usr/bin/env bash
# ── Keybind Cheatsheet ───────────────────────────────
cat << 'EOF' | rofi -dmenu -p "Keybinds" -i
SUPER + T          → Terminal
SUPER + W          → Browser
SUPER + E          → File Manager
SUPER + R          → App Launcher
SUPER + Q          → Kill Window
SUPER + V          → Clipboard History
SUPER + M          → Exit Hyprland
SUPER + Space      → Float Window
SUPER + J          → Toggle Split
SUPER + S          → Scratchpad
SUPER + /          → This Cheatsheet
SUPER + SHIFT + S  → Screenshot to Clipboard
SUPER + SHIFT + A  → Screenshot to Google Lens
Print              → Fullscreen Screenshot
SUPER + Print      → Area Screenshot Save
SUPER + 1-9        → Switch Workspace
SUPER + SHIFT+1-9  → Send Window Silent
SUPER + ALT+1-9    → Move and Follow
SUPER + SHIFT + R  → Reload Config
EOF
