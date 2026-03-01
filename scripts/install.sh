#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║         Hypr-Config — Rose x Grey Hyprland Rice                 ║
# ║         Installer Script — by Zagot                             ║
# ╚══════════════════════════════════════════════════════════════════╝

# ─── Colors (matching your palette) ──────────────────────────────────────────
C_RESET='\e[0m'
C_BOLD='\e[1m'
C_DIM='\e[2m'
C_BORDER='\e[38;2;170;12;20m'      # #aa0c14
C_ACTIVE='\e[38;2;229;91;91m'      # #e55b5b
C_TEXT='\e[38;2;224;224;224m'      # #e0e0e0
C_GREEN='\e[38;2;80;200;90m'
C_DIM_COLOR='\e[38;2;100;100;100m'

info_print ()    { echo -e "${C_BOLD}${C_ACTIVE}  ●  ${C_TEXT}$1${C_RESET}"; }
ok_print ()      { echo -e "${C_BOLD}${C_GREEN}  ✔  ${C_TEXT}$1${C_RESET}"; }
error_print ()   { echo -e "${C_BOLD}${C_ACTIVE}  ✖  ${C_TEXT}$1${C_RESET}"; }
section_print () { echo -e "\n${C_BORDER}${C_BOLD}  ══  $1  ══${C_RESET}\n"; }

# ─── Banner ───────────────────────────────────────────────────────────────────
draw_banner () {
    clear
    echo -e "${C_BORDER}${C_BOLD}"
    echo "  ╔══════════════════════════════════════════════════════════╗"
    echo "  ║                                                          ║"
    echo "  ║        ██╗  ██╗██╗   ██╗██████╗ ██████╗                ║"
    echo "  ║        ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗               ║"
    echo "  ║        ███████║ ╚████╔╝ ██████╔╝██████╔╝               ║"
    echo "  ║        ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗               ║"
    echo "  ║        ██║  ██║   ██║   ██║      ██║  ██║               ║"
    echo "  ║        ╚═╝  ╚═╝   ╚═╝   ╚═╝      ╚═╝  ╚═╝               ║"
    echo "  ║                                                          ║"
    echo "  ║          Rose x Grey — Hyprland Rice Installer          ║"
    echo "  ║                     by Zagot                            ║"
    echo "  ║                                                          ║"
    echo "  ╚══════════════════════════════════════════════════════════╝"
    echo -e "${C_RESET}"
    echo -e "${C_DIM_COLOR}${C_DIM}  Arch Linux · Hyprland · Waybar · Kitty · Rofi · Dunst${C_RESET}\n"
}

# ─── Dependency Check ─────────────────────────────────────────────────────────
check_deps () {
    section_print "Checking Dependencies"

    local missing=()

    # Check yay
    if ! command -v yay &>/dev/null; then
        error_print "yay not found — install yay first"
        exit 1
    fi
    ok_print "yay found"

    # Check if running on Arch
    if ! command -v pacman &>/dev/null; then
        error_print "This script is for Arch Linux only"
        exit 1
    fi
    ok_print "Arch Linux confirmed"
}

# ─── Package Installation ─────────────────────────────────────────────────────
install_packages () {
    section_print "Installing Packages"

    # Core Hyprland
    local core=(
        hyprland
        hyprlock
        hyprpaper
        xdg-desktop-portal-hyprland
    )

    # Bar & Notifications
    local bar=(
        waybar
        dunst
        swww
    )

    # Terminal & Apps
    local apps=(
        kitty
        thunar
        rofi-wayland
        brightnessctl
        playerctl
        wireplumber
    )

    # Fonts & Themes
    local theming=(
        ttf-jetbrains-mono-nerd
        papirus-icon-theme
        bibata-cursor-theme-bin
    )

    # Utils
    local utils=(
        grim
        slurp
        wl-clipboard
        python-pillow
    )

    info_print "Installing core Hyprland packages..."
    yay -S --needed --noconfirm "${core[@]}" || error_print "Some core packages failed"

    info_print "Installing bar and notification packages..."
    yay -S --needed --noconfirm "${bar[@]}" || error_print "Some bar packages failed"

    info_print "Installing apps..."
    yay -S --needed --noconfirm "${apps[@]}" || error_print "Some app packages failed"

    info_print "Installing fonts and themes..."
    yay -S --needed --noconfirm "${theming[@]}" || error_print "Some theming packages failed"

    info_print "Installing utilities..."
    yay -S --needed --noconfirm "${utils[@]}" || error_print "Some utils failed"

    ok_print "All packages installed"
}

# ─── Backup Existing Config ───────────────────────────────────────────────────
backup_existing () {
    section_print "Backing Up Existing Configs"

    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$HOME/.config/hypr-backup-$timestamp"

    if [[ -d "$HOME/.config/hypr" ]]; then
        info_print "Found existing hypr config — backing up to $backup_dir"
        cp -r "$HOME/.config/hypr" "$backup_dir"
        ok_print "Backed up to $backup_dir"
    else
        info_print "No existing hypr config found — skipping backup"
    fi
}

# ─── Copy Configs ─────────────────────────────────────────────────────────────
copy_configs () {
    section_print "Installing Hypr-Config"

    local src
    src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local dest="$HOME/.config/hypr"

    info_print "Copying configs to $dest"
    mkdir -p "$dest"

    # Copy everything except .git
    rsync -av --exclude='.git' --exclude='install.sh' --exclude='README.md' \
        "$src/" "$dest/" &>/dev/null

    ok_print "Configs installed to $dest"
}

# ─── Generate Wallpaper ───────────────────────────────────────────────────────
gen_wallpaper () {
    section_print "Generating Wallpaper"

    if command -v python3 &>/dev/null && python3 -c "import PIL" &>/dev/null; then
        info_print "Generating rose x grey wallpaper..."
        python3 "$HOME/.config/hypr/scripts/wallpaper_gen.py" && \
            ok_print "Wallpaper generated" || \
            error_print "Wallpaper generation failed — set one manually"
    else
        error_print "python-pillow not found — skipping wallpaper generation"
        info_print "Drop a wallpaper manually at ~/.config/hypr/wallpaper/wallpaper.png"
    fi
}

# ─── Done ─────────────────────────────────────────────────────────────────────
finish () {
    echo ""
    echo -e "${C_BORDER}${C_BOLD}"
    echo "  ╔══════════════════════════════════════════════════════════╗"
    echo "  ║                                                          ║"
    echo "  ║                  Rice Installed ✔                       ║"
    echo "  ║                                                          ║"
    echo "  ║   Launch:  HYPRLAND_CONFIG=~/.config/hypr/hyprland.conf ║"
    echo "  ║             Hyprland                                     ║"
    echo "  ║                                                          ║"
    echo "  ║   Or set it as your default and relogin.                ║"
    echo "  ║                                                          ║"
    echo "  ╚══════════════════════════════════════════════════════════╝"
    echo -e "${C_RESET}"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main () {
    draw_banner
    check_deps
    install_packages
    backup_existing
    copy_configs
    gen_wallpaper
    finish
}

main "$@"
