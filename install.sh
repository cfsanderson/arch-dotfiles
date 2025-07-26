#!/bin/bash
#
# Arch Linux Bootstrap Script
# This script installs all packages, plugins, and dotfiles.
#

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Starting Arch Linux Setup ---"

# --- 1. Install Packages from Lists ---
echo "-> Installing official packages from packages-official.txt..."
sudo pacman -S --needed --noconfirm - < packages/packages-official.txt

echo "-> Installing AUR packages from packages-aur.txt..."
yay -S --needed --noconfirm - < packages/packages-aur.txt


# --- 2. Install Oh My Zsh Custom Plugins ---
echo "-> Installing custom Oh My Zsh plugins..."
# The destination needs to be the live directory, not the stowed one
ZSH_CUSTOM="$HOME/.config/zsh/oh-my-zsh/custom"

# Check if the directories exist before cloning
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM}/plugins/zsh-completions"
fi

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi


# --- 3. Stow All Dotfiles ---
echo "-> Stowing all dotfiles..."
# Run stow from a subshell to avoid changing the script's current directory
(cd ~/Projects/arch-dotfiles/ && stow -R -t $HOME */)


# --- 4. Set Zsh as Default Shell ---
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "-> Changing default shell to Zsh..."
  chsh -s $(which zsh)
else
  echo "-> Shell is already Zsh."
fi


echo ""
echo "--- Automated Setup Complete! ---"
echo "Please review the README.md for required MANUAL system configurations."
echo "A reboot is required to apply all changes."

