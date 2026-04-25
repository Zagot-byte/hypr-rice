# VeloraOS Rice — Build Instructions for Antigravity

> This document provides step-by-step instructions to build the complete VeloraOS rice.
> The user (zagot-byte) is working on a fresh Arch install dedicated to ricing.
> Existing repo cloned at: `/home/claude/hypr-rice`

---

## Current State

The user has an existing rice with:
- Rose x Grey color scheme (needs replacement with Kanagawa Dragon)
- Modular Hyprland config structure (good, keep this)
- Waybar, Kitty, Fish, Dunst, Rofi already configured
- Missing: Tmux, Quickshell, Yazi, Hyprpicker, Wlogout, workspace profiles

**Existing structure:**
```
hypr-rice/
├── conf/                    # Hyprland modular configs
│   ├── animations.conf
│   ├── autostart.conf
│   ├── colors.conf         # ← REPLACE with Kanagawa
│   ├── decoration.conf
│   ├── general.conf
│   ├── input.conf
│   ├── keybinds.conf       # ← UPDATE keybinds
│   ├── monitors.conf
│   ├── variables.conf
│   └── windowrules.conf
├── hypr/
│   ├── hyprland.conf       # Main config (sources conf/)
│   ├── hypridle.conf
│   └── hyprlock.conf
├── waybar/
├── kitty/
├── fish/
├── dunst/
├── rofi/
└── wallpaper/
```

---

## Goal: Well-Defined Tree Structure

The final structure should be:

```
velora-rice/
├── hyprland/
│   ├── hyprland.conf              # Main entry point
│   ├── conf/
│   │   ├── colors.conf            # Kanagawa Dragon palette
│   │   ├── keybinds.conf          # All keybinds
│   │   ├── monitors.conf
│   │   ├── general.conf           # General settings
│   │   ├── decoration.conf        # Blur, shadows, borders
│   │   ├── animations.conf
│   │   ├── windowrules.conf       # Performance rules from end-4
│   │   ├── input.conf
│   │   ├── autostart.conf
│   │   └── variables.conf
│   ├── hypridle.conf
│   └── hyprlock.conf
├── waybar/
│   ├── config.jsonc               # Waybar config
│   └── style.css                  # Kanagawa Dragon styled
├── quickshell/                    # NEW
│   ├── launcher.qml               # App launcher
│   ├── sidebar.qml                # Action center
│   └── shared/
│       └── colors.qml             # Kanagawa colors for QML
├── kitty/
│   ├── kitty.conf                 # Main config
│   └── kanagawa-dragon.conf       # Theme include
├── fish/
│   ├── config.fish                # Main config
│   ├── conf.d/
│   │   ├── kanagawa.fish          # Color definitions
│   │   └── aliases.fish           # User aliases/abbrs
│   └── functions/
│       ├── workspace_ctf.fish     # CTF workspace profile
│       ├── workspace_dev.fish     # Dev workspace profile
│       └── fish_prompt.fish       # end-4 style transient prompt
├── tmux/                          # NEW
│   └── tmux.conf                  # Kanagawa Dragon themed
├── dunst/
│   └── dunstrc                    # Kanagawa Dragon styled
├── rofi/
│   ├── config.rasi
│   └── kanagawa-dragon.rasi       # Theme
├── yazi/                          # NEW
│   └── theme.toml                 # Kanagawa colors
├── wlogout/                       # NEW
│   ├── layout
│   └── style.css                  # Kanagawa styled
├── scripts/
│   ├── lens.sh                    # Google Lens screenshot
│   ├── workspace-ctf.sh           # CTF workspace setup
│   └── workspace-dev.sh           # Dev workspace setup
└── install.sh                     # Main installer
```

---

## Task 1: Replace Colors with Kanagawa Dragon

**File:** `hyprland/conf/colors.conf`

Already created at `/home/claude/hypr-rice/conf/kanagawa-colors.conf`. 

**Action:**
1. Copy that file content to `colors.conf`
2. Update all theme files (Waybar, Kitty, Dunst, Rofi) to use these exact hex values

**Kanagawa Dragon Palette (DO NOT MODIFY):**
```
Base:     #181616
Surface:  #1d1c19
Overlay:  #282727
Muted:    #625e5a
Subtle:   #9e9b93
Text:     #c5c9c5
Red:      #c4746e  ← Primary Velora accent
Gold:     #c4b28a
Green:    #8a9a7b
Teal:     #8ea4a2
Blue:     #7fb4ca
```

---

## Task 2: Update Keybinds

Reference the keybind plan from `VELORA_RICE_CONTEXT.md`:

```
Super            → Quickshell launcher
Super+Enter      → Kitty
Super+/          → Keybind cheatsheet (Quickshell overlay)
Super+V          → Clipboard picker (cliphist via Quickshell)
Super+S          → Screenshot region (grim + slurp)
Super+Shift+S    → Google Lens screenshot (lens.sh)
Super+E          → Dolphin
Super+Tab        → Workspace overview
Super+Right      → Quickshell action center sidebar
Super+Q          → Close window
Super+1-9        → Switch workspace
Super+Shift+1-9  → Move window to workspace
Super+Shift+C    → Hyprpicker (color picker)
Super+Shift+E    → Wlogout
```

Plus standard tiling binds (copy from end-4 structure).

**Action:** Update `/home/claude/hypr-rice/conf/keybinds.conf` with these.

---

## Task 3: Steal From end-4

Clone end-4's repo and extract these specific files:

```bash
git clone https://github.com/end-4/dots-hyprland /tmp/end4
```

**What to steal:**
1. **Fish prompt** — `/tmp/end4/.config/fish/functions/fish_prompt.fish`
   - The transient prompt with timer bar
   - Adapt colors to Kanagawa Dragon

2. **Window rules** — `/tmp/end4/.config/hypr/hyprland/rules.conf`
   - Blur disabled on windows, only on layers
   - Shadows disabled on tiled windows
   - `allow_tearing = true` + `immediate` rules for games

3. **File picker** — any custom file/directory picker scripts they have

**Action:** Extract these, adapt to Kanagawa Dragon, place in appropriate folders.

---

## Task 4: Create Missing Components

### Tmux (`tmux/tmux.conf`)

Use Kanagawa Dragon colors. Key features:
- Status bar with git branch, time, session name
- Kanagawa Dragon color palette
- Mouse support enabled
- Vi mode keys

### Yazi (`yazi/theme.toml`)

Kanagawa Dragon theme for Yazi file manager.

### Wlogout (`wlogout/`)

Styled logout/shutdown/reboot screen with Kanagawa Dragon colors.
Icons for: logout, shutdown, reboot, lock, suspend.

### Hyprpicker

Just needs to be in the install script as a package.

### Workspace Profile Scripts (`scripts/`)

**workspace-ctf.sh:**
```bash
#!/bin/bash
# CTF workspace layout
# Terminal split + browser + notes
hyprctl dispatch workspace 1
hyprctl dispatch exec kitty --session ~/.config/kitty/sessions/ctf.conf
hyprctl dispatch exec brave
```

**workspace-dev.sh:**
```bash
#!/bin/bash
# Dev workspace layout
# Terminal + browser side by side
hyprctl dispatch workspace 2
hyprctl dispatch exec kitty
hyprctl dispatch exec brave
```

---

## Task 5: Quickshell Components

This is the most complex piece. Quickshell uses QML.

### Structure:
```
quickshell/
├── launcher.qml       # App launcher (replaces Rofi for apps)
├── sidebar.qml        # Action center with clock, calendar, toggles
├── cheatsheet.qml     # Keybind overlay (Super+/)
└── shared/
    └── colors.qml     # Kanagawa Dragon colors as QML properties
```

### `shared/colors.qml`:
```qml
pragma Singleton
import QtQuick

QtObject {
    readonly property color base: "#181616"
    readonly property color surface: "#1d1c19"
    readonly property color overlay: "#282727"
    readonly property color text: "#c5c9c5"
    readonly property color red: "#c4746e"
    readonly property color gold: "#c4b28a"
    readonly property color green: "#8a9a7b"
    readonly property color teal: "#8ea4a2"
    readonly property color blue: "#7fb4ca"
}
```

For the actual launcher/sidebar QML — reference end-4's Quickshell structure but simplify.
DO NOT copy AGS code. Use only Quickshell QML patterns.

---

## Task 6: Update Existing Configs to Kanagawa

### Waybar (`waybar/style.css`)

Replace all Rose x Grey colors with Kanagawa Dragon.

Example:
```css
* {
    font-family: "JetBrains Mono Nerd Font";
    font-size: 13px;
}

window#waybar {
    background-color: #1d1c19;
    color: #c5c9c5;
    border-bottom: 2px solid #c4746e;
}

#workspaces button.active {
    background-color: #282727;
    color: #c4746e;
}

/* ... etc */
```

### Kitty (`kitty/kanagawa-dragon.conf`)

```conf
# Kanagawa Dragon theme for Kitty

foreground #c5c9c5
background #181616
selection_foreground #c5c9c5
selection_background #282727

# Cursor
cursor #c5c9c5
cursor_text_color #181616

# Black
color0  #181616
color8  #625e5a

# Red
color1  #c4746e
color9  #c4746e

# Green
color2  #8a9a7b
color10 #8a9a7b

# Yellow/Gold
color3  #c4b28a
color11 #c4b28a

# Blue
color4  #7fb4ca
color12 #7fb4ca

# Magenta (use teal)
color5  #8ea4a2
color13 #8ea4a2

# Cyan (use teal)
color6  #8ea4a2
color14 #8ea4a2

# White
color7  #c5c9c5
color15 #c5c9c5
```

Then in `kitty.conf`: `include kanagawa-dragon.conf`

### Dunst (`dunst/dunstrc`)

Update colors section:
```ini
[global]
    font = JetBrains Mono Nerd Font 11
    frame_color = "#c4746e"
    separator_color = "#282727"

[urgency_low]
    background = "#1d1c19"
    foreground = "#c5c9c5"
    frame_color = "#8a9a7b"

[urgency_normal]
    background = "#1d1c19"
    foreground = "#c5c9c5"
    frame_color = "#c4746e"

[urgency_critical]
    background = "#1d1c19"
    foreground = "#c5c9c5"
    frame_color = "#c4746e"
```

### Rofi (`rofi/kanagawa-dragon.rasi`)

Create a Kanagawa Dragon theme file for Rofi.

---

## Task 7: Install Script

Update/create `install.sh` that:

1. **Checks dependencies**
   ```bash
   # Required packages
   PKGS=(
       hyprland waybar kitty fish tmux dunst rofi
       swww hyprlock hypridle cliphist wl-clipboard
       grim slurp dolphin pipewire wireplumber
       networkmanager blueman gnome-keyring
       nwg-look qt5ct qt6ct
       libqalculate yazi hyprpicker wlogout
       ttf-jetbrains-mono-nerd
   )
   ```

2. **Symlinks configs to ~/.config/**
   ```bash
   ln -sf $(pwd)/hyprland ~/.config/hypr
   ln -sf $(pwd)/waybar ~/.config/waybar
   ln -sf $(pwd)/kitty ~/.config/kitty
   # ... etc
   ```

3. **Enables services**
   ```bash
   systemctl --user enable pipewire pipewire-pulse wireplumber
   ```

4. **Sets Fish as default shell**
   ```bash
   chsh -s $(which fish)
   ```

---

## Priority Order for Antigravity

Build in this order:

1. ✅ **Colors** — Replace Rose x Grey with Kanagawa Dragon across all configs
2. **Hyprland** — Update keybinds, steal window rules from end-4
3. **Kitty + Fish** — Theme + steal end-4's transient prompt
4. **Waybar** — Restyle to Kanagawa Dragon
5. **Tmux** — Create config with Kanagawa theme
6. **Dunst + Rofi** — Update colors
7. **Quickshell** — Launcher + Sidebar (this is the big one)
8. **Scripts** — lens.sh, workspace profiles
9. **Yazi + Wlogout** — Config + theme
10. **Install script** — Tie it all together

---

## Notes for Antigravity

- **DO NOT change the Kanagawa Dragon hex values.** They are final.
- Use the modular structure — each component in its own folder.
- Keep configs readable with comments.
- Test each component before moving to the next.
- The user prefers concise, direct communication — no over-explaining.
- Reference `VELORA_RICE_CONTEXT.md` for full context on decisions already made.

---

## Current Files Available

- `/home/claude/hypr-rice/` — existing rice repo (cloned)
- `/mnt/user-data/outputs/VELORA_RICE_CONTEXT.md` — full project context
- `/home/claude/hypr-rice/conf/kanagawa-colors.conf` — Kanagawa Dragon palette (already created)

---

Start with Task 1 (colors) and work through the priority order. The user will provide feedback and direction as you build.