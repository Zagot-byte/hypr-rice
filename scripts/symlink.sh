#!/usr/bin/env bash
# Symlink all configs to ~/.config/
# Run from repo root

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CFG="$HOME/.config"

link() {
    local src="$REPO/$1"
    local dst="$CFG/$2"
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "  linked $dst"
}

echo "Symlinking VeloraOS configs..."

link hyprland          hypr
link waybar            waybar
link kitty             kitty
link fish              fish
link tmux/tmux.conf    tmux/tmux.conf
link dunst             dunst
link rofi              rofi
link quickshell        quickshell
link yazi              yazi
link wlogout           wlogout

echo "Done."
