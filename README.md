# Hypr-Rice

Hypr-Rice is a collection of configurations and setups tailored for [Hyprland](https://hyprland.org/), providing users with a beautiful and functional desktop experience. This repository contains everything you need to install, customize, and use Hyprland effectively.

## Installation Instructions

Follow these steps to install the necessary components for using Hyprland and this configuration:

1. **System Requirements**:
   - Ensure your system is running Arch Linux or a compatible distribution.
   - Install necessary dependencies:
     ```bash
     sudo pacman -S hyprland wayland wlogout
     ```

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/Zagot-byte/hypr-rice.git
   cd hypr-rice
   ```

3. **Copy Configuration Files**:
   Replace your existing Hyprland configurations with the ones from this repository.
   ```bash
   cp -r .config/hypr/* ~/.config/hypr/
   ```

4. **Install Fonts**:
   If your configurations require specific fonts, make sure to install them as described in the `fonts/` directory.

## Hyprland Configuration

The Hyprland configuration files are located in the `.config/hypr/` directory. Key files include:

- `hyprland.conf`: The main configuration file where most settings are defined.
- `autostart.conf`: A list of applications to be launched with Hyprland.
  
Make sure to review and adjust these files according to your preferences.

## Customization Guide

To customize your Hyprland experience, you can modify the following:

- **Themes**: Change the themes by updating the theme settings in `hyprland.conf`. Check the `themes/` directory for available themes.
- **Keybindings**: Modify keybindings in the `hyprland.conf` file to suit your workflow.
- **Appearance**: Adjust the appearance settings such as wallpaper and opacity in the configuration files.

## File Structure

Here’s an overview of the main file structure:

```
hypr-rice/
├── .config/
│   └── hypr/
│       ├── hyprland.conf
│       ├── autostart.conf
│       └── themes/
├── fonts/
│   └── [list of required fonts]
└── README.md
```

## Usage Instructions

After installation, simply log in to Hyprland from your display manager. You can start customizing your desktop:

- Use the Super/Windows key along with configured shortcuts to manage windows and launch applications.
- Modify configurations live, save, and reload Hyprland settings using the command `hyprctl reload`.

For any issues, refer to the Troubleshooting section in the wiki or open an issue in the repository!

## Contributing

Feel free to contribute! Please submit a pull request or raise issues for enhancements.