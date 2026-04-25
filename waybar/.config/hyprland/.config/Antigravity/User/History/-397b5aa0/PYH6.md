# VeloraOS Rice — Full Build Context
> Hand this to any AI (Antigravity, GPT, Gemini etc) to continue the work.
> Written by the project owner. Do not deviate from decisions already made.

---

## Who Are You Building For

- **User:** CSE student, cybersecurity specialization, Velammal Engineering College Chennai
- **GitHub:** zagot-byte
- **Daily driver:** Arch Linux + Hyprland + RTX 4050 6GB
- **Use case:** CTF solving, dev work (multiple active projects), cybersecurity club teaching, daily driver
- **Communication style:** Fast, casual, abbreviated. Don't over-explain. Be direct.
- **Learning style:** Hands-on, first principles. Prefers control over automation.

---

## What Is This

**VeloraOS** is a custom Arch Linux rice being built as:
1. A clean installable distro/dotfiles setup for fresh Arch installs
2. A personal daily driver optimized for hacking + dev
3. Content for a YouTube channel (saneAspect — someone else's channel the user watches for ricing knowledge, NOT the user's own channel)

The rice is **heavily inspired by end-4/dots-hyprland** (https://github.com/end-4/dots-hyprland) but stripped of bloat and rebranded with a new theme.

---

## Theme — LOCKED

**Dark mode: Kanagawa Dragon** ✅ FULLY LOCKED — original palette, zero modifications

Exact hex values (do NOT change):
- Base: `#181616`
- Surface: `#1d1c19`
- Overlay: `#282727`
- Muted: `#625e5a`
- Subtle: `#9e9b93`
- Text: `#c5c9c5`
- Red accent: `#c4746e` ← primary Velora accent, chosen after extensive comparison
- Gold: `#c4b28a`
- Green: `#8a9a7b`
- Teal: `#8ea4a2`
- Blue: `#7fb4ca`
- Background: `#181616`
- Surface: `#1d1c19`
- Overlay: `#282727`
- Muted: `#625e5a`
- Subtle: `#9e9b93`
- Text: `#c5c9c5`
- Love (red): `#c4746e`
- Gold: `#c4b28a`
- Green: `#8a9a7b`
- Teal: `#8ea4a2`
- Blue: `#7fb4ca`
- Iris (purple-ish): `#a292a3` — use sparingly
- **Primary accent: red (`#c4746e`)** — ties into VeloraOS brand identity (Velora = red)

**Light mode: White + Red**
- Clean white base
- Red accents matching `#c4746e` or slightly more saturated
- These two themes are INDEPENDENT — do not try to make them match or relate

**Font:** JetBrains Mono Nerd Font — used everywhere (terminal, bar, launcher, Quickshell)

**NO purple dominance anywhere.** Purple = AI slop aesthetic. Avoid.

---

## Full Stack — LOCKED

Every item below is confirmed. Do not suggest replacements unless asked.

| Component | Tool |
|---|---|
| Compositor | Hyprland |
| Bar | Waybar (Kanagawa Dragon themed) |
| Launcher + Action Center | Quickshell (QML) |
| Terminal | Kitty |
| Shell | Fish |
| Multiplexer | Tmux (riced with kanagawa.tmux) |
| Notifications | Dunst |
| Wallpaper daemon | swww |
| Lock screen | Hyprlock |
| Idle daemon | hypridle |
| Clipboard daemon | cliphist + wl-copy |
| File manager | Dolphin |
| Screenshot | grim + slurp |
| Network | NetworkManager (nmcli backend) |
| Bluetooth | blueman |
| Audio | PipeWire + WirePlumber |
| Calculator (in launcher) | libqalculate (qalc binary) |
| Credential storage | gnome-keyring |
| GTK theming | nwg-look |
| Qt theming | qt5ct + qt6ct |
| Browser | Brave |
| Virtual monitor | wayvnc + hypr_mon_guard (from end-4) |
| AUR helper | yay |

---

## Key Features — LOCKED

### 1. Fish Prompt (HERO PIECE)
Steal directly from end-4/dots-hyprland Fish config.
- Shows current path
- Timer/duration bar that shows while typing
- Collapses/disappears cleanly on Enter (transient prompt)
- This is the signature terminal moment for VeloraOS content

### 2. Quickshell Action Center Sidebar
- Slides in from the RIGHT on `Super+Right`
- Contains: big clock, calendar, music player widget, wifi/bluetooth toggles, system stats
- Wifi/BT toggles call `nmcli` commands (NOT iwd — end-4's iwd was laggy)
- Built in QML, Kanagawa Dragon colors

### 3. Quickshell Launcher
- Replaces Rofi for app launching
- Integrated calculator via `qalc` (libqalculate)
- Integrated clipboard picker (pipes `cliphist list`)
- Command runner mode
- All in one Quickshell popup, end-4 style

### 4. Rofi (kept for specific modes)
- rofi-calc mode
- run mode
- Styled in Kanagawa Dragon

### 5. Google Lens Script (`lens.sh`)
```bash
#!/bin/bash
TMPFILE=$(mktemp /tmp/screenshot-XXXXXX.png)
grim -g "$(slurp)" "$TMPFILE"
URL=$(curl -s -F "file=@$TMPFILE" https://0x0.st)
xdg-open "https://lens.google.com/uploadbyurl?url=$URL"
rm "$TMPFILE"
```
Bind to `Super+Shift+S`

### 6. Clipboard to stdout
```bash
<command> | wl-copy
```
Used as fish abbreviation:
```fish
# Usage: nmap -sV target | clip
```
Simple, just wl-copy piped from any command.

### 7. Tmux Rice
- Use `rebelot/kanagawa.tmux` or community Kanagawa Dragon tmux theme
- Status bar with: git branch, battery, time, session name
- All colors match Kanagawa Dragon palette

### 8. Keybind Cheatsheet Overlay
- `Super+/` opens a Quickshell overlay showing all keybinds
- Same concept as end-4's cheatsheet
- Ships with installer

### 9. Performance Tricks (from end-4)
- Blur DISABLED on all app windows globally
- Blur ONLY on Quickshell layer shell surfaces
- Shadows disabled on tiled windows, only on floating
- `allow_tearing = true` + `immediate` windowrule for games/wine/steam apps
- These go in `hyprland/rules.conf`

---

## Keybindings (draft, finalize during build)

| Keybind | Action |
|---|---|
| `Super` | Quickshell launcher |
| `Super+Enter` | Kitty terminal |
| `Super+/` | Keybind cheatsheet overlay |
| `Super+V` | Clipboard picker (Quickshell) |
| `Super+S` | Screenshot region (grim+slurp) |
| `Super+Shift+S` | Google Lens screenshot |
| `Super+E` | Dolphin file manager |
| `Super+Tab` | Workspace overview |
| `Super+Right` | Action center sidebar |
| `Super+Q` | Close window |
| `Super+1-9` | Switch workspace |
| `Super+Shift+1-9` | Move window to workspace |
| Standard tiling | Same as end-4 |

---

## Installer Script Structure

```
velora-rice/
├── install.sh              # main entry point
├── packages/
│   ├── base.txt            # core rice packages
│   ├── security.txt        # CTF + hacking tools
│   ├── dev.txt             # development tools
│   └── gaming.txt          # steam, lutris, wine, dxvk
├── configs/
│   ├── hypr/
│   ├── waybar/
│   ├── quickshell/
│   ├── kitty/
│   ├── fish/
│   ├── tmux/
│   ├── dunst/
│   └── hyprlock/
└── scripts/
    ├── symlink.sh          # copies configs to ~/.config/
    ├── services.sh         # enables systemd services
    ├── lens.sh             # google lens screenshot
    └── fonts.sh            # installs JetBrains Mono NF
```

### Installer flags:
```bash
./install.sh              # base rice only
./install.sh --security   # + CTF/hacking tools
./install.sh --dev        # + dev tools
./install.sh --gaming     # + gaming stack
./install.sh --full       # everything
```

### Tool list:
> **NOTE FOR AI:** The user has an existing tool list in their GitHub repo (zagot-byte). 
> Before writing the packages lists, ask the user to paste the contents of their 
> existing installer's package list. Do NOT assume or generate a generic list.
> They also have a VeloraOS installer that is "pretty good but not too good" — 
> ask for that too and merge the best of both.

Known tools to include:
- Security: nmap, gobuster, john, hydra, wireshark, burpsuite (AUR), ghidra (AUR), binwalk, sleuthkit, pwntools, pycryptodome, python-pillow
- Dev: git, python, pip, nodejs, npm, rust, cargo, neovim
- Gaming: steam, lutris, wine, dxvk-bin (AUR), vkd3d-proton-bin (AUR), lib32-nvidia-utils

---

## What To Steal Directly From end-4/dots-hyprland

These are NOT to be reimplemented from scratch. Copy and adapt:

1. **Fish prompt** — `dots/.config/fish/` — the transient prompt with timer bar
2. **File picker** — end-4's custom file/directory picker script
3. **Smart shell features** — whatever fish functions/abbreviations he ships
4. **Hyprland rules.conf** — window rules, performance rules, tiling rules
5. **Quickshell action center structure** — adapt to Kanagawa Dragon, remove AI/matugen deps
6. **Workspace overview** — the Super+Tab drag-and-drop overview

Reference: https://github.com/end-4/dots-hyprland
Docs: https://end-4.github.io/dots-hyprland-wiki/en/

---

## What NOT To Include (Explicitly Stripped)

- ❌ matugen (dynamic Material You color generation) — replaced with static Kanagawa Dragon
- ❌ AGS (old widget system) — use Quickshell only
- ❌ AI features (Gemini, Ollama integration)
- ❌ Circle to Search
- ❌ Screen translation / tesseract OCR
- ❌ plasma-changeicons
- ❌ Virtual monitor system (wayvnc, hypr_mon_guard)
- ❌ iwd (replaced with NetworkManager)
- ❌ Warp terminal (using Kitty)
- ❌ Python venv for Quickshell (keep it simple)
- ❌ Thunar (replaced with Dolphin)
- ❌ Waybar (bar is Waybar, but Quickshell handles launcher/sidebar)
- ❌ Zen browser (sticking with Brave)

---

## Dual Boot Context

- User has 50GB allocated for this fresh Arch install
- Existing partitions: one Arch (end-4 rice), one Arch (gaming/testing), now adding third for VeloraOS
- Use GRUB as bootloader (already present)
- Install Arch manually or via archinstall — user's choice
- After base Arch install, run `./install.sh --full` from velora-rice repo

---

## Build Order (Recommended)

1. Fresh Arch base install on the 50GB partition
2. yay (AUR helper) — install first, everything else depends on it
3. Hyprland + core packages
4. Kitty + Fish — steal end-4 prompt, apply Kanagawa Dragon colors
5. Tmux — apply kanagawa.tmux theme
6. Waybar — Kanagawa Dragon styled
7. Quickshell — action center + launcher
8. Hyprlock + hypridle + swww — lock/idle/wallpaper
9. Dunst — notifications in Kanagawa Dragon
10. Dolphin + nwg-look + qt5ct/qt6ct — file manager + GTK/Qt theming
11. Scripts — lens.sh, services.sh, symlinks
12. Installer script — package it all up
13. Keybind cheatsheet overlay in Quickshell
14. Polish pass — gaps, borders, animations, blur rules

---

## Repo Structure for VeloraOS Rice

The user already has: https://github.com/Zagot-byte/hypr-rice
This will be updated/replaced with the new Velora rice configs.
Existing repo has: hypr/, waybar/, kitty/, fish/, dunst/, rofi/, wallpaper/, Thunar/

---

## Notes for the AI Helping With This

- User is technical but prefers you explain briefly before generating code
- Don't generate entire configs in one shot — do it piece by piece, component by component
- Always ask before assuming package names (AUR vs pacman)
- User's hardware: RTX 4050 6GB — Nvidia explicit sync is working, no driver issues
- When writing Fish config: use Fish syntax not bash
- When writing QML for Quickshell: reference end-4's actual QML structure
- The user will provide their exact tool list from GitHub before you write package lists
- Static colors only — no dynamic theming, no matugen, no wallpaper-based color generation
- Keep configs modular — separate files per concern, not one monolithic config
- User communicates casually and fast — match that energy, don't be formal

---

## Additional Features (Added After Initial Lock)

### Workspace Profiles
- One keybind switches entire workspace layout
- **CTF mode** — terminal split (Kitty+Tmux) + browser + notes side by side
- **Dev mode** — editor + terminal + browser
- **Chill mode** — clean single window
- Implemented as a Fish function calling `hyprctl dispatch` commands

### Yazi
- Terminal file manager, keyboard-driven
- Keep Dolphin for GUI use
- Yazi for inside-terminal navigation
- Kanagawa Dragon theme via Yazi's built-in theming
- Keybind: open Yazi in current directory from terminal

### Hyprpicker
- Pick any color from screen → copies hex to clipboard instantly
- Useful for DotArt and any design/dev work
- Bind to `Super+Shift+C` or similar

### Wlogout
- Styled logout/shutdown/reboot/lock screen
- End-4 uses it — has a Kanagawa Dragon themed config
- Shows on `Super+Shift+E`
- Ships with installer

### Pipes.sh — Idle/Lock Animation
- NOT a 24/7 camera thing 😭
- Two options (pick one during build):
  1. **Pre-lock idle** — after X mins inactivity, fullscreen Kitty runs pipes.sh, THEN Hyprlock kicks in
  2. **Hyprlock background** — pipes.sh renders as the lock screen background instead of static wallpaper
- Option 2 is cleaner for content/screenshots
- Install: `pipes.sh` from AUR (`pipes-rs` is a Rust rewrite, faster)