I am not happy with `sway` and would like to return to a full hyprland setup. I have a friend who said he had success on an M-series Macbook Pro running Asahi and Fedora 32 by doing...

```
sudo dnf copr remove solopasha/hyprland

sudo dnf copr enable sdegler/hyprland

sudo dnf update --refresh
```

He also said:
>"If you need to force an update after changing out the copr repos `sudo dnf upgrade --best --allowerasing`. I had to then FORCE the hyprland 0.53 installation by doing: `sudo dnf install hyprland --best --allowerasing`"


I took these suggestions and had a conversation with Claude and came up with the following plan. Check it for correctness against my actual current system. If it seems reasonable, then help me implement the change. The rest of this document is the output of the conversation with Claude...


# Hyprland Upgrade Plan for Asahi Linux (M1 MacBook Pro)

## Context
- Currently running Hyprland 0.45.2 (debug build) on Asahi Linux (Fedora Remix 42)
- Using swaylock/swayidle as workarounds because hypridle/hyprlock weren't working
- Friend successfully got hypridle/hyprlock working on M-series Mac using `sdegler/hyprland` COPR
- Goal: Upgrade to Hyprland 0.53 and switch to native hypridle/hyprlock

## Current State
```bash
# Hyprland version check shows:
Hyprland 0.45.2 built from branch at commit 12f9a0d0b93f691d4d9923716557154d74777b0a
Date: Tue Nov 19 21:47:18 2024
Tag: v0.45.2, commits: 5451
built against aquamarine 0.5.0
flags set: debug

# Sway packages currently installed:
swaybg-1.2.1-3.fc42.aarch64
swayidle-1.8.0-7.fc42.aarch64
swaylock-effects-1.6.11-0.fc39.aarch64

# No hypr packages showing in dnf list (installed via other method)
```

## Dotfiles Info
- Repo: https://github.com/cfsanderson/arch-dotfiles
- Current branch: `asahi-m1-macbook`
- Hyprland configs: `hyprland/.config/hypr/`
- **Correction**: autostart.conf is currently running `swayidle`/`swaylock` (the `hypridle` line is commented out)

## Migration Plan

### Phase 1: Safety Setup
```bash
# 1. Enable SSH as safety net
sudo systemctl enable --now sshd

# 2. Find the MacBook's IP address for SSH from another machine
ip addr show | grep 'inet '

# 3. From ANOTHER machine on the same network, test SSH access:
#    ssh caleb@<macbook-ip-address>
#    (confirm you can log in before proceeding)

# 4. Verify you can access TTY (test now, don't just assume)
# Press Ctrl+Alt+F3 to switch to TTY3
# Press Ctrl+Alt+F2 to get back to GUI
```

### Phase 2: Switch COPR Repos
```bash
# 1. Check if solopasha repo exists (might not)
sudo dnf copr list

# 2. Remove old repo if it exists
sudo dnf copr remove solopasha/hyprland

# 3. Add ARM64-optimized repo
sudo dnf copr enable sdegler/hyprland

# 4. Refresh package cache
sudo dnf update --refresh
```

### Phase 3: Install/Upgrade Hyprland Stack
```bash
# Install all hyprland components at once
sudo dnf install hyprland hypridle hyprlock --best --allowerasing

# Verify what got installed
dnf list installed | grep hypr

# Expected: Should show hyprland 0.53.x, hypridle, hyprlock
```

### Phase 4: Update Dotfiles

These config changes swap sway references for hyprland-native equivalents. Make these
changes in the dotfiles repo (`~/Projects/arch-dotfiles/`), then re-stow with `stowr`.

#### autostart.conf
- **Remove** the swayidle line (line 21):
  ```
  exec-once = swayidle -w timeout 300 ...
  ```
- **Uncomment** the hypridle line (line 24):
  ```
  exec-once = hypridle & fcitx5
  ```
  (mako & waybar are already started on line 2, so keep them separate)

#### bindings.conf
- **Change** `Super+ESC` from `swaylock` to `hyprlock` (line 36):
  ```
  bind = SUPER, ESCAPE, exec, hyprlock
  ```

#### envs.conf
- **Re-enable** the `ecosystem` block (available in 0.53+):
  ```
  ecosystem {
    no_update_news = true
  }
  ```

#### hyprland.conf
- **Remove duplicate** `monitors.conf` source — it's sourced on both line 4 and line 17.
  Remove line 4 (`source = ~/.config/hypr/monitors.conf`) since line 17 uses `$HOME`.

#### Optional: check if hyprpicker is available
- After upgrade, run `dnf list available | grep hyprpicker`
- If available, uncomment the color picker binding in bindings.conf (line 121)

### Phase 5: Test Without Reboot
```bash
# 1. Kill any sway processes still running
pkill swayidle
pkill swaylock

# 2. Reload Hyprland config (picks up dotfile changes)
hyprctl reload

# Or restart Hyprland session (log out/in via Super+Alt+Escape then log back in)
```

### Phase 6: Verify hypridle/hyprlock Work
```bash
# 1. Check hypridle is running
pgrep -a hypridle

# 2. Test hyprlock manually
hyprlock
# Should lock screen - unlock to verify it works

# 3. Check hyprland version
hyprctl version
# Should show 0.53.x
```

### Phase 7: Clean Up (Only After Confirming Everything Works)
```bash
# Remove sway packages
sudo dnf remove swaybg swayidle swaylock-effects

# Verify removal
rpm -qa | grep sway
# Should return nothing
```

## Dotfiles Audit — Sway References to Address

These are all the sway references found in the current dotfiles:

| File | Line | Current | Change to |
|------|------|---------|-----------|
| `autostart.conf` | 21 | `swayidle -w timeout 300 ...` | Remove (replace with hypridle) |
| `autostart.conf` | 24 | `# exec-once = hypridle & fcitx5` | Uncomment |
| `bindings.conf` | 36 | `exec, swaylock` | `exec, hyprlock` |
| `bindings.conf` | 26 | `swaybg-next` script | Keep or update if wallpaper tool changes |
| `hyprland.conf` | 4 | duplicate `monitors.conf` source | Remove (already sourced on line 17) |
| `envs.conf` | 27-30 | `ecosystem` block commented out | Uncomment for 0.53+ |

## Config Files Ready to Go

### hypridle.conf
`hyprland/.config/hypr/hypridle.conf` — fully configured, no changes needed

### hyprlock.conf
`hyprland/.config/hypr/hyprlock.conf` — fully configured with Gruvbox theme, no changes needed

## Rollback Plan (If Things Break)
```bash
# 1. Access via TTY (Ctrl+Alt+F3) or SSH

# 2. Remove problematic packages
sudo dnf remove hyprland hypridle hyprlock

# 3. Reinstall sway alternatives
sudo dnf install swaybg swayidle swaylock-effects

# 4. Reboot
sudo reboot
```

## Questions to Answer Before Proceeding
1. ✅ Dotfiles backed up (confirmed)
2. ⏳ Can you switch to TTY successfully? (test before starting)
3. ⏳ SSH enabled and tested from another device?
4. ⏳ Current COPR repos listed (run `sudo dnf copr list`)

## Expected Outcome
- Hyprland 0.53.x running (release build, not debug)
- hypridle managing idle/lock (no more swayidle)
- hyprlock as screen locker (no more swaylock)
- All sway packages removed
- Dotfiles updated: no sway references in active config lines
- `ecosystem {}` block re-enabled
- Duplicate `monitors.conf` source cleaned up

---

## Actual Upgrade Log (2026-01-30)

### Phases 1-2: Completed Successfully
- SSH enabled, TTY tested, COPR repo switched from none → `sdegler/hyprland`
- No `solopasha/hyprland` repo existed to remove

### Phase 3: Partially Completed
- **Hyprland 0.53.3 installed successfully** via `sudo dnf install hyprland-0.53.3-1.fc42.aarch64 --best --allowerasing`
  - Required installing `muParser` first (missing dependency)
  - Could not install all three packages at once — had to install hyprland alone first
  - Pulled in: aquamarine 0.10.0, hyprcursor 0.1.13, hyprlang 0.6.8, hyprutils 0.11.0, hyprgraphics, hyprtoolkit, hyprwire, uwsm, hyprland-guiutils, hyprland-uwsm
- **hypridle/hyprlock from COPR: FAILED** — the COPR packages were built against `libhyprutils.so.9` but the COPR ships hyprutils 0.11.0 which provides `libhyprutils.so.10`. This is a packaging bug in the COPR.
- Fedora base repos do not have hypridle or hyprlock at all.

### Build From Source Attempt: FAILED
- Attempted to build hypridle and hyprlock from source
- Installed build deps: cmake, gcc-c++, wayland-devel, wayland-protocols-devel, pango-devel, cairo-devel, libdrm-devel, mesa-libEGL-devel, sdbus-cpp-devel, pugixml-devel, hyprlang-devel, hyprutils-devel, hyprland-protocols-devel
- Built and installed `hyprwayland-scanner` from source (not packaged for aarch64)
- **hypridle build failed**: All versions (including v0.1.7) require sdbus-c++ 2.x API (`ServiceName`, `InterfaceName`, `registerMethod`, `addVTable`, etc.) but Fedora 42 ships sdbus-c++ 1.5.0
- Same issue would affect hyprlock

### Root Cause
The sdbus-c++ 1.x → 2.x API change is a breaking change. All hypridle/hyprlock releases use 2.x APIs. Fedora 42 ships 1.5.0. Building sdbus-c++ 2.x from source risks breaking system packages that depend on 1.x (systemd, NetworkManager, bluetooth, etc.).

### Current State (2026-01-30)
- **Hyprland 0.53.3**: Running (release build, upgraded from 0.45.2 debug)
- **hypridle/hyprlock**: NOT installed — blocked by sdbus-c++ version mismatch
- **swayidle/swaylock-effects**: Still in use as idle/lock managers (working fine)
- **Dotfile changes**: NOT yet applied (Phase 4 not started since hypridle/hyprlock unavailable)
- **ecosystem {} block**: Can be re-enabled (available in 0.53+)
- **Duplicate monitors.conf**: Can still be cleaned up

### Recommended Next Steps
1. **Now**: Apply partial dotfile changes that don't depend on hypridle/hyprlock:
   - Re-enable `ecosystem {}` block in envs.conf
   - Remove duplicate `monitors.conf` source in hyprland.conf
2. **Keep**: swayidle/swaylock as idle/lock (they work, no functional loss)
3. **Revisit**: hypridle/hyprlock when Fedora ships sdbus-c++ 2.x (likely Fedora 43) or when the COPR maintainer fixes the package builds
4. **Cleanup**: Remove `~/Projects/hypridle/` and `~/Projects/hyprwayland-scanner/` build directories

### Packages Built From Source (installed to /usr)
- `hyprwayland-scanner` — installed to `/usr/bin/hyprwayland-scanner`
  - Can be removed later: `sudo rm /usr/bin/hyprwayland-scanner /usr/lib64/pkgconfig/hyprwayland-scanner.pc /usr/lib64/cmake/hyprwayland-scanner/hyprwayland-scanner-config*.cmake`
