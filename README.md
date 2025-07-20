# "I use Arch now (by the way)..."

At the beginning of this year, I tried Omakub and when that was too opinionated, I even tried ricing my own custom [Hyprland](https://hypr.land/) setup but got bogged down and retreated back to Pop!_OS (Cosmic). When I heard about DHH's **[Omarchy](https://github.com/basecamp/omarchy)** project, I knew I had to give it a try. This configuration is heavily inspired by the principles of digital sovereignty and self-reliance championed by DHH and the Linux crowd, but I also see it as a design exercise. As a product designer, I'm constantly working within fairly narrow product constraints. What could be more liberating than building your own, bespoke digital environment??! I'm mostly just having fun on an old 2015 Macbook Pro, trying to own my own setup and understand how it works.

This repository will serve both as my personal dotfiles and a self-contained toolkit for bootstrapping a new machine from a minimal Arch install to a fully configured Hyprland desktop based on Omarchy. While Omarchy was a great gateway drug for Arch, I immediately set about customizing to my tastes - removing/replacing apps, refining with my personal theme, etc. - so much that it just made sense to "start fresh". Here are some highlights:

- Using my fork of [Kickstart.nvim](https://github.com/cfsanderson/kickstart-cfs.nvim) for Neovim config instead of Lazy.vim
- Using my fork of [Sainnhe's Gruvbox Material](https://github.com/cfsanderson/cfs-gruvbox-material) for theming - no theme switching options like Omarchy.
- [Ghostty](https://ghostty.org/) terminal instead of [Alacritty](https://alacritty.org/)
- [Brave](https://brave.com/) browser instead of Chromium
- swapped caps lock and escape keys
- changed out or removed several web apps (ongoing process)

This configuration is managed by **GNU `stow`** and a declarative package list, creating a reproducible and version-controlled environment. Each application's configuration is a self-contained `stow` package.

Phases 0-3 should be hardware agnostic while Phase 4 is more specific to issues that I ran into while setting this up on my 2015 MacBook Pro.

## ⚡ Fresh Installation Workflow

This guide is a complete, end-to-end process, starting from a blank machine.

### Phase 0: Preparation

1.  **Download the Arch ISO:** Get the latest official image from the [Arch Linux download page](https://archlinux.org/download/).
2.  **Create a Bootable USB:** Use a tool like [Balena Etcher](https://www.balena.io/etcher/) or `dd` to flash the ISO to a USB drive.
3.  **Boot from USB:** Start the computer from the USB drive. You will land at a command-line prompt.
4.  **Connect to the Internet:** The live environment needs an internet connection to run the installer.
    *   **Ethernet:** Plug in the cable. It should connect automatically.
    *   **Wi-Fi:** Run `iwctl`, then `station wlan0 scan`, then `station wlan0 connect "Your-WiFi-Name"`.

---

### Phase 1: The `archinstall` Script

Use the official `archinstall` script to perform a guided, reliable installation.

1.  **Launch the Installer:** At the command prompt, simply type:
    ```bash
    archinstall
    ```
2.  **Follow the Menu:** Navigate the menu using the arrow keys and `Enter`. Configure the following options as specified. Most other options can be left at their default values.

    *   **`Disk configuration`**:
        *   Select the main drive for your installation.
        *   Choose the option to **"Wipe the selected drive and use a best-effort default partition layout."**
        *   For `Filesystem`, select **`btrfs`**.
        *   When asked `Would you like to use disk encryption?`, choose **Yes**. Enter a strong password you will not forget.

    *   **`Profile`**:
        *   `Type`: Select **`Desktop`**.
        *   `Desktop Environment`: Select **`Hyprland`**.
        *   `Graphics Driver`: Select the appropriate driver (**`Intel`** for 2015 MacBook Pro).

    *   **`User account` -> `Add a user`**:
        *   Enter your desired username (e.g., `darthvader`).
        *   Enter and confirm your password.
        *   When asked `Should darthvader be a superuser (sudo)?`, choose **Yes**.

    *   **`Additional packages`**:
        *   This is an important step. Enter a space-separated list of the essential tools needed to bootstrap your dotfiles. A good list is:
        ```
        git stow neovim
        ```

    *   **`Network configuration`**:
        *   Choose **`Copy ISO network configuration to installation`**. This is the easiest option to ensure you have internet on your first real boot.

3.  **Install:**
    *   Select the **`Install`** option from the main menu.
    *   Confirm you are ready. The script will now partition the drive, install Arch Linux, and configure the base system.
    *   When it's finished, it will ask if you want to `chroot` into the new installation. Choose **No**.
    *   Finally, type `reboot` at the prompt and remove the USB drive.

---

### Phase 2: First Boot & AUR Helper Setup

After rebooting, you will be in a minimal Hyprland session. The first task is to install `yay`, the AUR helper.

1.  **Open a Terminal:** Press `SUPER + Return`.
2.  **Install `yay`:**
    ```bash
    # Install the necessary tools to build packages
    sudo pacman -S --needed base-devel

    # Clone the yay repository
    git clone https://aur.archlinux.org/yay-bin.git
    
    # Enter the directory and build/install it
    cd yay-bin
    makepkg -si
    ```
    *Why `yay-bin`? It uses a pre-compiled binary, making the first AUR installation much faster.*

---

### Phase 3: Deploy Your Custom Environment

This is where the dotfiles repository takes over.

1.  **Clone Arch-Dotfiles Repository:**
    ```bash
    git clone --recurse-submodules https://github.com/cfsanderson/arch-dotfiles.git ~/Projects/arch-dotfiles
    ```
    The `--recurse-submodules` flag is important as my fork of Kickstart.nvim is included and managed via stow.

2.  **Run the Automated Install Script:**
    This script will install all your packages from your lists and stow all your dotfiles.
    ```bash
    cd ~/Projects/arch-dotfiles
    ./install.sh
    ```

---

### Phase 4: Manual System Configuration (CRITICAL)

The following steps require `sudo` and modify system files in `/etc`. They must be done manually after the main install script.

**a) Fix Wi-Fi Backend (Use `iwd`):**
```bash
# Install required firmware
sudo pacman -S linux-firmware-broadcom

# Create the config file to tell NetworkManager to use iwd
sudo nvim /etc/NetworkManager/conf.d/wifi_backend.conf
```
*Paste the following into the file:*
```ini
[device]
wifi.backend=iwd
```
*Enable the service:*
```bash
sudo systemctl enable --now iwd.service
```

**b) Fix Thunderbolt Ethernet Driver (Pre-load `tg3`):**
```bash
# Edit the mkinitcpio config
sudo nvim /etc/mkinitcpio.conf
```
*Find the `MODULES=` line and add `tg3` to it. For example:*
`MODULES=(btrfs tg3)`

**c) Fix Keyboard Backlight Permissions:**
```bash
# Add your user to the 'input' group to allow brightnessctl to work
sudo usermod -aG input caleb
```

### Phase 5: Finalize and Reboot

1.  **Rebuild the Boot Environment:** This applies your `mkinitcpio.conf` changes.
    ```bash
    sudo mkinitcpio -P
    ```
2.  **Final Reboot:**
    ```bash
    sudo shutdown -r now
    ```

After this final reboot, the system should be ready to roll, a personalized, minimal, stable, and fully-configured Arch + Hyprland desktop environment.

