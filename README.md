# README

# 🚀 I'm using Arch now (by the way)...

These are my personal dotfiles for my latest journey into the world of Arch Linux. This setup is a fresh start, built with modern tools for a clean, modular, and repeatable environment.

At the beginning of this year, I tried Omakub and when that was too opinionated, I even tried ricing my own custom [Hyprland](https://hypr.land/) setup but got bogged down and retreated back to Pop!_OS (Cosmic). When I heard about DHH's **[Omarchy](https://github.com/basecamp/omarchy)** project, I knew I had to give it a try. This configuration is heavily inspired by the principles of digital sovereignty and self-reliance championed by DHH and the Linux crowd, but I also see it as a design exercise. As a product designer, I'm constantly working within fairly narrow product constraints. What could be more liberating than building your own, bespoke digital environment? I'm mostly just having fun on an old 2015 Macbook Pro, trying to own my own setup and understand how it works... and then I'll get to ricing again.

## ✨ The Philosophy

I've been managing my dotfiles for years with the the "bare repository and alias method" popularized on this [Hacker News thread](https://news.ycombinator.com/item?id=11070797). It worked, mostly.

Since I'm venturing into the uncharted waters of Arch, I thought I'd try something new (to me) and Stow seemed the obvious choice. This configuration strives to respect the **XDG Base Directory Specification**, keeping `~` clean by favoring `~/.config`.

The core principles are:
*   **Modular:** Each program's configuration is a self-contained "package" (e.g., `zsh`, `tmux`).
*   **Declarative:** The directory structure *is* the documentation. Stow handles the linking.
*   **Reproducible:** Setting up a new machine should be as simple as cloning this repo and running a few commands.

## ⚡ Quick Start on a New Machine

Here's how to get this config up and running from scratch.

### 1. Prerequisites
First, install the core tools required to manage and use these dotfiles.

```bash
sudo pacman -S stow git
```

### 2. Clone the Repository
Clone this repository into a dedicated `Projects` directory.

```bash
git clone https://github.com/cfsanderson/arch-dotfiles.git ~/Projects/arch-dotfiles
```

### 3. Stow the Packages
Navigate into the repository. From here, you will "stow" each package. Use the `-t $HOME` flag to tell Stow that the target for our symlinks is our home directory.

```bash
cd ~/Projects/arch-dotfiles

# Stow the shell package (for .zshenv)
stow -t $HOME shell

# Stow the Zsh package (for .zshrc, .zprofile, etc.)
stow -t $HOME zsh

# Stow the Tmux package
stow -t $HOME tmux

# ...and so on for any new packages!
```

## 📦 What's Inside?

This repository currently manages the configuration for:

*   **`zsh`**: The Z-Shell, configured with Oh My Zsh, the `agnoster` theme, and a suite of useful plugins.
*   **`tmux`**: The best terminal multiplexer, managed with TPM (Tmux Plugin Manager).
*   **`shell`**: Base shell configuration, primarily the crucial `~/.zshenv` file that makes the XDG setup work.
*   **`git`**: A simple `.gitignore` to keep this repository clean.

---
*This workshop is always under construction.*
```
