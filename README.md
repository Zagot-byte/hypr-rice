# VeloraOS Rice

A custom Arch Linux + Hyprland rice built around the **Kanagawa Dragon** color palette. Heavily inspired by [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) and [ilyamiro/imperative-dots](https://github.com/ilyamiro/imperative-dots), stripped of bloat and rebranded with a static theme.

## Features

- **Hyprland** compositor with smooth workspace slide animations
- **Quickshell** (QML) for launcher, action center, settings, music, network, battery, monitors, calendar, clipboard, and workspace overview
- **Waybar** vertical pill on the left, Kanagawa Dragon themed
- **Kitty** terminal with JetBrains Mono Nerd Font
- **Fish** shell with custom theme + Starship transient prompt
- **Tmux** with Kanagawa Dragon status bar
- **Hyprlock** lock screen
- **Hypridle** smart idle daemon
- **Yazi** terminal file manager themed
- Custom workspace overview with slanted card animation

## Stack

| Component | Tool |
|---|---|
| Compositor | Hyprland |
| Bar | Waybar |
| Launcher / Sidebars | Quickshell (QML) |
| Terminal | Kitty |
| Shell | Fish + Starship |
| Multiplexer | Tmux |
| Notifications | Quickshell (built-in) |
| Wallpaper daemon | swww |
| Lock | Hyprlock |
| Idle | Hypridle |
| Clipboard | cliphist + wl-copy |
| File manager | Dolphin (GUI) + Yazi (TUI) |
| Screenshot | grim + slurp |
| Network | NetworkManager |
| Audio | PipeWire + WirePlumber |
| Color picker | hyprpicker |

## Theme — Kanagawa Dragon

Static palette, no dynamic theming. Hex values:

| Role | Hex |
|---|---|
| Base | `#181616` |
| Surface | `#1d1c19` |
| Overlay | `#282727` |
| Text | `#c5c9c5` |
| Red | `#c4746e` |
| Gold | `#c4b28a` |
| Green | `#8a9a7b` |
| Teal | `#8ea4a2` |
| Blue | `#7fb4ca` |

Primary accent: **teal** `#8ea4a2`.

## Install

```bash
git clone https://github.com/Zagot-byte/hypr-rice ~/hypr-rice
cd ~/hypr-rice
./install.sh --full
```

### Flags

- `./install.sh` — base rice only
- `./install.sh --security` — adds CTF/hacking tools
- `./install.sh --dev` — adds dev tools
- `./install.sh --gaming` — adds Steam, Lutris, Wine, DXVK
- `./install.sh --full` — everything

## Keybinds

| Bind | Action |
|---|---|
| `Super` | Quickshell launcher |
| `Super+Tab` | Workspace overview |
| `Super+V` | Clipboard history |
| `Super+N` | Settings panel |
| `Super+/` | Guide / cheatsheet |
| `Super+Alt+M` | Music popup |
| `Super+Shift+S` | Screenshot region |
| `Super+Shift+A` | Google Lens search |
| `Super+Shift+C` | Color picker |
| `Super+1-9` | Switch workspace |
| `Super+Alt+1-9` | Move window to workspace (silent) |
| `Super+Q` | Close window |
| `Super+L` | Lock screen |

Full keybinds in `hyprland/conf/keybinds.conf`.

## Credits

Massive thanks to:

- [end-4](https://github.com/end-4) for `dots-hyprland` — the gold standard for Hyprland ricing
- [ilyamiro](https://github.com/ilyamiro) for `imperative-dots` — the Quickshell QML components powering the launcher, sidebars, and widgets
- [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) for the Kanagawa Dragon palette
- The [Hyprland](https://hyprland.org/) and [Quickshell](https://quickshell.outfoxxed.me/) communities

## License

MIT — see [LICENSE](LICENSE)

---

Built by [zagot-byte](https://github.com/zagot-byte)
