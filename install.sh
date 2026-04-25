#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
#   VeloraOS Rice Installer
#   github.com/Zagot-byte/hypr-rice
# ──────────────────────────────────────────────────────────────────────────

set -e

# ─── Colors ──────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
TEAL='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Flags ───────────────────────────────────────────────────────────────
INSTALL_SECURITY=0
INSTALL_DEV=0
INSTALL_GAMING=0
RESET=0

for arg in "$@"; do
    case $arg in
        --security) INSTALL_SECURITY=1 ;;
        --dev)      INSTALL_DEV=1 ;;
        --gaming)   INSTALL_GAMING=1 ;;
        --full)     INSTALL_SECURITY=1; INSTALL_DEV=1; INSTALL_GAMING=1 ;;
        --reset)    RESET=1 ;;
        --help|-h)
            echo "Usage: ./install.sh [--security] [--dev] [--gaming] [--full] [--reset]"
            echo "  No flags    → base rice only"
            echo "  --security  → CTF and hacking tools"
            echo "  --dev       → dev tools"
            echo "  --gaming    → Steam, Lutris, Wine, DXVK"
            echo "  --full      → everything"
            echo "  --reset     → ignore previous checkpoint, start fresh"
            exit 0
            ;;
    esac
done

# ─── Helpers ─────────────────────────────────────────────────────────────
log()     { echo -e "${TEAL}[*]${NC} $1"; }
ok()      { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
err()     { echo -e "${RED}[✗]${NC} $1"; exit 1; }
section() { echo -e "\n${BOLD}${TEAL}━━ $1 ━━${NC}\n"; }

confirm() {
    read -p "$(echo -e "${YELLOW}[?]${NC} $1 [y/N] ")" -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# ─── Banner ──────────────────────────────────────────────────────────────
clear
echo -e "${TEAL}"
cat <<'EOF'
                      ░██                                
                      ░██                                
░██    ░██  ░███████  ░██  ░███████  ░██░████  ░██████   
░██    ░██ ░██    ░██ ░██ ░██    ░██ ░███           ░██  
 ░██  ░██  ░█████████ ░██ ░██    ░██ ░██       ░███████  
  ░██░██   ░██        ░██ ░██    ░██ ░██      ░██   ░██  
   ░███     ░███████  ░██  ░███████  ░██       ░█████░██ 
EOF
echo -e "${NC}"
echo -e "  ${BOLD}Hyprland + Kanagawa Dragon Rice${NC}"
echo -e "  github.com/Zagot-byte/hypr-rice\n"

# ─── Checkpoint System ───────────────────────────────────────────────────
CHECKPOINT_FILE="$HOME/.cache/velora-install.checkpoint"
mkdir -p "$(dirname "$CHECKPOINT_FILE")"

checkpoint_save()  { echo "$1" > "$CHECKPOINT_FILE"; }
checkpoint_load()  { [[ -f "$CHECKPOINT_FILE" ]] && cat "$CHECKPOINT_FILE" || echo "0"; }
checkpoint_clear() { rm -f "$CHECKPOINT_FILE"; }
skip_until() {
    local target=$1
    local current=$(checkpoint_load)
    [[ "$current" -ge "$target" ]] && return 0
    return 1
}

if [[ $RESET -eq 1 ]]; then
    checkpoint_clear
    log "Checkpoint reset, starting fresh"
fi

LAST_STEP=$(checkpoint_load)
if [[ "$LAST_STEP" -gt 0 ]]; then
    warn "Previous installation was interrupted at step $LAST_STEP"
    if confirm "Resume from where it left off?"; then
        log "Resuming from step $LAST_STEP..."
    else
        checkpoint_clear
        LAST_STEP=0
    fi
fi

# ─── Pre-flight checks ───────────────────────────────────────────────────
if ! skip_until 1; then
    section "Pre-flight checks"

    if [[ $EUID -eq 0 ]]; then
        err "Don't run this as root. The script will use sudo when needed."
    fi
    if ! command -v pacman &>/dev/null; then
        err "This installer is for Arch Linux only."
    fi
    if ! ping -c 1 -W 2 archlinux.org &>/dev/null; then
        err "No internet connection. Connect to the internet and try again."
    fi
    ok "System checks passed"
    checkpoint_save 1
fi

# ─── Confirmation ────────────────────────────────────────────────────────
if ! skip_until 2; then
    section "What will be installed"

    echo "  Base rice (always)"
    echo "    Hyprland, Waybar, Quickshell, Kitty, Fish, Tmux, Yazi, hyprlock"
    [[ $INSTALL_SECURITY -eq 1 ]] && echo -e "  ${GREEN}+${NC} Security tools (CTF, pentesting)"
    [[ $INSTALL_DEV -eq 1 ]]      && echo -e "  ${GREEN}+${NC} Dev tools (git, node, rust, python)"
    [[ $INSTALL_GAMING -eq 1 ]]   && echo -e "  ${GREEN}+${NC} Gaming stack (Steam, Lutris, Wine, DXVK)"
    echo

    if ! confirm "Continue with installation?"; then
        log "Cancelled."
        exit 0
    fi
    checkpoint_save 2
fi

# ─── Backup ──────────────────────────────────────────────────────────────
if ! skip_until 3; then
    section "Backing up existing configs"

    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    for dir in hypr waybar kitty fish tmux quickshell yazi wlogout; do
        if [[ -d "$HOME/.config/$dir" ]]; then
            cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
            log "Backed up ~/.config/$dir"
        fi
    done
    ok "Existing configs backed up to $BACKUP_DIR"
    echo "$BACKUP_DIR" > "$HOME/.cache/velora-backup-path"
    checkpoint_save 3
fi

# ─── Update keyring ──────────────────────────────────────────────────────
if ! skip_until 4; then
    section "Updating Arch keyring"
    sudo pacman -Sy --noconfirm archlinux-keyring || warn "Keyring update failed, continuing"
    ok "Keyring up to date"
    checkpoint_save 4
fi

# ─── Install yay ─────────────────────────────────────────────────────────
if ! skip_until 5; then
    section "Setting up AUR helper"

    if ! command -v yay &>/dev/null; then
        log "Installing yay..."
        sudo pacman -S --needed --noconfirm git base-devel
        tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
        (cd "$tmpdir/yay" && makepkg -si --noconfirm)
        rm -rf "$tmpdir"
        ok "yay installed"
    else
        ok "yay already installed"
    fi
    checkpoint_save 5
fi

# ─── Base packages ───────────────────────────────────────────────────────
if ! skip_until 6; then
    section "Installing base rice packages"

    BASE_PACMAN=(
        hyprland hyprlock hypridle hyprpicker
        waybar kitty fish starship tmux
        qt6-base qt6-declarative qt6-svg qt6-wayland
        networkmanager network-manager-applet bluez bluez-utils blueman
        pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol
        grim slurp wl-clipboard cliphist
        swww brightnessctl playerctl
        polkit-kde-agent
        nwg-look qt5ct qt6ct kvantum
        dolphin yazi
        ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
        libqalculate
        btop fastfetch
        micro neovim
        xdg-desktop-portal-hyprland xdg-user-dirs
        inotify-tools jq
        gnome-keyring
    )

    BASE_AUR=(
        quickshell-git
        wlogout
    )

    log "Installing pacman packages (this may take a while)..."
    sudo pacman -S --needed --noconfirm "${BASE_PACMAN[@]}"

    log "Installing AUR packages..."
    yay -S --needed --noconfirm "${BASE_AUR[@]}"

    ok "Base packages installed"
    checkpoint_save 6
fi

# ─── Optional: Security ──────────────────────────────────────────────────
if [[ $INSTALL_SECURITY -eq 1 ]] && ! skip_until 7; then
    section "Installing security/CTF tools"

    SEC_PACMAN=(
        nmap wireshark-qt john hydra
        sleuthkit binwalk gdb radare2
        python python-pip python-pillow
        gnu-netcat openssh
    )
    SEC_AUR=(
        gobuster
        burpsuite
        ghidra
    )

    sudo pacman -S --needed --noconfirm "${SEC_PACMAN[@]}"
    yay -S --needed --noconfirm "${SEC_AUR[@]}" || warn "Some AUR security tools failed"

    pip install --break-system-packages pwntools pycryptodome 2>/dev/null || warn "pip pwntools install skipped"

    ok "Security tools installed"
    checkpoint_save 7
fi

# ─── Optional: Dev ───────────────────────────────────────────────────────
if [[ $INSTALL_DEV -eq 1 ]] && ! skip_until 8; then
    section "Installing dev tools"

    DEV_PACMAN=(
        git nodejs npm python python-pip
        rust cargo go
        docker docker-compose
        gcc make cmake
        ripgrep fd bat eza fzf zoxide
    )

    sudo pacman -S --needed --noconfirm "${DEV_PACMAN[@]}"
    sudo systemctl enable docker || warn "docker enable failed"

    ok "Dev tools installed"
    checkpoint_save 8
fi

# ─── Optional: Gaming ────────────────────────────────────────────────────
if [[ $INSTALL_GAMING -eq 1 ]] && ! skip_until 9; then
    section "Installing gaming stack"

    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        log "Enabling multilib..."
        sudo sed -i '/^#\[multilib\]/,/^#Include/{s/^#//}' /etc/pacman.conf
        sudo pacman -Sy
    fi

    GAMING_PACMAN=(
        steam lutris wine winetricks
        lib32-nvidia-utils lib32-mesa
        gamemode lib32-gamemode
    )
    GAMING_AUR=(
        dxvk-bin
        vkd3d-proton-bin
    )

    sudo pacman -S --needed --noconfirm "${GAMING_PACMAN[@]}"
    yay -S --needed --noconfirm "${GAMING_AUR[@]}"

    ok "Gaming stack installed"
    checkpoint_save 9
fi

# ─── Deploy configs ──────────────────────────────────────────────────────
if ! skip_until 10; then
    section "Deploying VeloraOS configs"

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    mkdir -p "$HOME/.config"

    declare -A CONFIGS=(
        [hyprland]="hypr"
        [waybar]="waybar"
        [kitty]="kitty"
        [fish]="fish"
        [tmux]="tmux"
        [quickshell]="quickshell/velora"
        [yazi]="yazi"
        [wlogout]="wlogout"
    )

    for src in "${!CONFIGS[@]}"; do
        dest="${CONFIGS[$src]}"
        if [[ -d "$SCRIPT_DIR/$src" ]]; then
            mkdir -p "$HOME/.config/$dest"
            cp -r "$SCRIPT_DIR/$src/"* "$HOME/.config/$dest/"
            ok "Deployed $src → ~/.config/$dest"
        fi
    done

    find "$HOME/.config/hypr/scripts" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null
    find "$HOME/.config/quickshell/velora" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null

    checkpoint_save 10
fi

# ─── Services ────────────────────────────────────────────────────────────
if ! skip_until 11; then
    section "Enabling services"

    sudo systemctl enable NetworkManager 2>/dev/null && ok "NetworkManager enabled"
    sudo systemctl enable bluetooth 2>/dev/null && ok "Bluetooth enabled"

    checkpoint_save 11
fi

# ─── Set fish as default shell ───────────────────────────────────────────
if ! skip_until 12; then
    if [[ "$SHELL" != *"fish"* ]]; then
        if confirm "Set fish as default shell?"; then
            chsh -s /usr/bin/fish
            ok "Fish set as default shell (takes effect on next login)"
        fi
    fi
    checkpoint_save 12
fi

# ─── Done ────────────────────────────────────────────────────────────────
section "Installation complete!"

BACKUP_DIR=$(cat "$HOME/.cache/velora-backup-path" 2>/dev/null || echo "no backup")

echo -e "  ${GREEN}✓${NC} VeloraOS rice is installed"
echo
echo -e "  ${BOLD}Next steps:${NC}"
echo -e "    1. Reboot or log out and log back in"
echo -e "    2. Choose Hyprland from your display manager"
echo -e "    3. Press ${TEAL}Super${NC} to open the launcher"
echo -e "    4. Press ${TEAL}Super+/${NC} for the keybind cheatsheet"
echo
echo -e "  Backup of old configs: ${YELLOW}$BACKUP_DIR${NC}"
echo -e "  Issues? Report at: ${TEAL}github.com/Zagot-byte/hypr-rice/issues${NC}"
echo

checkpoint_clear
