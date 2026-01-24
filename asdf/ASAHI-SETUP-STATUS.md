# Asahi Linux (Fedora KDE Remix) Setup Status

**Machine:** M1 MacBook Pro (ARM64/aarch64)
**OS:** Asahi Linux - Fedora KDE Remix
**Last Updated:** 2026-01-22

---

## Completed Tasks

### Hyprland Config Fixes
- [x] Fixed `~/.config/hypr/envs.conf` - removed `ecosystem { no_update_news = true }` block (not supported in Hyprland 0.45.x on Fedora)
- [x] Fixed `~/.config/hypr/envs.conf` - changed `GDK_SCALE=2` to `GDK_SCALE=1` (Hyprland handles scaling at 1.5x)
- [x] Fixed `~/.config/mako/config` - removed inline comments (not supported by mako)

### Waybar Config Updates
- [x] Changed `ghostty -e` to `kitty -e` (ghostty not available on ARM64)
- [x] Changed `blueberry` to `blueman-manager` (blueberry not in Fedora repos)
- [x] Changed `dropbox-cli status` to `maestral status` (Dropbox doesn't support Linux ARM64)

### Autostart Updates
- [x] Added `exec-once = maestral start` to `~/.config/hypr/autostart.conf`

### Installed Packages (via dnf)
- [x] pavucontrol - PulseAudio volume control
- [x] pamixer - CLI audio control
- [x] NetworkManager-tui - nmtui network manager
- [x] blueman - Bluetooth manager
- [x] python3-pip, pipx

### Installed via pipx
- [x] maestral 1.9.6 - Open-source Dropbox client for ARM64

### Apps Installed (2026-01-22)
- [x] **Obsidian** - via Flatpak (`flatpak install flathub md.obsidian.Obsidian`)
- [x] **Signal Desktop** - via unofficial ARM64 Flatpak from signalflatpak.github.io
- [x] **1Password** - via official ARM64 tarball, installed to `/opt/1Password/`
- [x] **swaylock-effects** - via COPR (trs-sod/swaylock-effects)

### Screen Lock/Idle (2026-01-22)
- [x] Configured swayidle in autostart.conf (5min lock, 5.5min DPMS off)
- [x] Created `~/.config/swaylock/config` with Gruvbox theme
- [x] Tested: DPMS, suspend, wake all working

### Desktop Integration (2026-01-22)
- [x] Symlinked flatpak .desktop files to `~/.local/share/applications/`
- [x] Symlinked flatpak icons to `~/.local/share/icons/hicolor/`
- [x] Created `~/keyboard-shortcuts.md` with Hyprland shortcuts
- [x] Set Electron scaling for Obsidian/Signal (1.75x)

---

## Pending Tasks

### Maestral/Dropbox Setup
- [ ] Run `maestral auth link` to authenticate with Dropbox (auth flow issues, deferred)

### Utilities Not Available on Fedora ARM64

| Keybinding | Tool | Status |
|------------|------|--------|
| SUPER SHIFT S/W/F | hyprshot | ✅ Using grim + slurp scripts |
| SUPER SHIFT C | hyprpicker | ❌ Need alternative |
| CTRL SUPER V | clipse | ❌ Need alternative |
| SUPER slash | 1password | ✅ Installed |
| SUPER S | signal-desktop | ✅ Installed (flatpak) |
| SUPER O | obsidian | ✅ Installed (flatpak) |

### Remaining Config Tasks
- [ ] Find/install color picker alternative to `hyprpicker`
- [ ] Find/install clipboard manager alternative to `clipse`
- [ ] Configure lid close to suspend (systemd-logind)

---

## Working Services

| Service | Status | Notes |
|---------|--------|-------|
| Hyprland | Running | v0.45.2 |
| Waybar | Running | Config updated for Fedora |
| Mako | Running | Notifications working |
| swaybg | Running | Wallpaper set |
| lxpolkit | Running | Polkit agent |
| Kitty | Working | Primary terminal |
| Zen Browser | Working | Installed at /usr/local/bin |

---

## System Info

```
Hyprland Version: 0.45.2
Display: eDP-1 @ 3024x1890 (scale 1.5x)
Architecture: aarch64
```

---

## Files Modified

- `~/.config/hypr/envs.conf`
- `~/.config/hypr/autostart.conf`
- `~/.config/mako/config`
- `~/.config/waybar/config`

---

## Reference: Arch Dotfiles Location

Original Arch Linux configs: `~/Projects/arch-dotfiles/`

Key differences between Arch and Fedora/Asahi:
1. Ghostty not available on ARM64 - using Kitty
2. Dropbox client not available on ARM64 - using Maestral
3. Hyprland 0.45.x lacks `ecosystem` config block
4. Some Hyprland utilities (hyprshot, hyprpicker) not packaged for Fedora
5. blueberry replaced with blueman
