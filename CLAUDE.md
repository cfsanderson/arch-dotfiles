# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Arch Linux dotfiles repository that provides a complete Hyprland desktop environment setup. It's inspired by DHH's Omarchy project but customized with personal preferences. The repository uses GNU Stow for dotfile management and includes an automated installation script.

## Key Commands

### Installation and Setup
- `./install.sh` - Main installation script that installs packages, plugins, and stows all dotfiles
- `archpack` - Alias to rebuild package lists (updates packages-official.txt and packages-aur.txt)
- `stowr` - Alias to re-stow all dotfiles: `cd ~/Projects/arch-dotfiles/ && stow -R -t $HOME */`

### Package Management
- Package lists are stored in `packages/packages-official.txt` (pacman) and `packages/packages-aur.txt` (AUR/yay)
- Use `pacman -S --needed --noconfirm - < packages/packages-official.txt` to install official packages
- Use `yay -S --needed --noconfirm - < packages/packages-aur.txt` to install AUR packages

### Configuration Shortcuts (via aliases)
- `confhypr` - Edit Hyprland configs: `cd hyprland/.config/hypr/ && nvim .`
- `confnv` - Edit Neovim config: `cd nvim/.config/nvim/ && nvim init.lua`
- `conftmux` - Edit Tmux config: `cd tmux/.config/tmux/ && nvim .`
- `confghostty` - Edit Ghostty terminal config: `cd ghostty/.config/ghostty/ && nvim config`
- `confalias` - Edit shell aliases: `cd zsh/.config/zsh/oh-my-zsh/custom/ && nvim aliases.zsh`
- `confzsh` - Edit Zsh main config: `cd ~/.config/zsh/ && nvim .zshrc`

## Architecture

### Dotfile Organization
The repository uses GNU Stow's directory structure where each top-level directory represents a package:
- `hyprland/` - Window manager configuration (modular config split across multiple files)
- `nvim/` - Neovim configuration (fork of Kickstart.nvim)
- `zsh/` - Shell configuration with Oh My Zsh
- `ghostty/` - Terminal emulator configuration
- `waybar/` - Status bar configuration
- `wofi/` - Application launcher configuration
- `tmux/` - Terminal multiplexer configuration
- `mako/` - Notification daemon configuration
- `btop/` - System monitor configuration
- `fastfetch/` - System info display configuration
- `packages/` - Package lists for reproducible installs
- `etc/` - System-level configurations (requires manual copying to /etc/)
- `wallpapers/` - Desktop wallpapers

### Hyprland Configuration Structure
Hyprland config is modularized across multiple files in `hyprland/.config/hypr/`:
- `hyprland.conf` - Main config file that sources all others
- `monitors.conf` - Machine-specific monitor configuration (must be created manually)
- `autostart.conf` - Applications to start with Hyprland
- `bindings.conf` - Keyboard shortcuts and bindings
- `envs.conf` - Environment variables
- `input.conf` - Input device configuration
- `looknfeel.conf` - Appearance and animation settings
- `windows.conf` - Window rules and workspace settings
- `theme.conf` - Color scheme and theming
- `scripts/` - Helper scripts (e.g., launch-wofi.sh)

### Key Applications
- **Window Manager**: Hyprland (Wayland compositor)
- **Terminal**: Ghostty (replaces Alacritty from Omarchy)
- **Shell**: Zsh with Oh My Zsh
- **Browser**: Zen Browser (configured for Wayland)
- **Editor**: Neovim (Kickstart.nvim fork)
- **Launcher**: Wofi
- **Bar**: Waybar
- **File Manager**: Nautilus
- **Notifications**: Mako

### Theme
Uses a custom fork of Sainnhe's Gruvbox Material theme for consistent theming across applications.

## Critical Setup Requirements

1. **Monitor Configuration**: Before stowing configs, create `~/.config/hypr/monitors.conf` with machine-specific monitor settings. Use `hyprctl monitors` to find monitor names.

2. **Manual System Configuration**: After running `install.sh`, system-level configs in `etc/` must be manually copied to `/etc/` with sudo privileges.

3. **Shell Change**: The install script will change the default shell to Zsh if not already set.

## Development Workflow

When modifying this dotfiles setup:
1. Make changes to files in the appropriate package directory
2. Test changes by re-stowing: `stowr`
3. Update package lists when adding new software: `archpack`
4. The Neovim config includes a CLAUDE.md specific to that configuration

## Notes

- This setup is hardware-specific to a 2015 MacBook Pro but Phases 0-3 of installation should be hardware agnostic
- The repository includes submodules (use `git clone --recurse-submodules` when cloning)
- Wi-Fi connection after install: use `nmtui` for first-time connection
- Package management uses both pacman (official) and yay (AUR) package managers