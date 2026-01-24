#!/bin/bash
# SDDM Wallpaper Randomizer
# Randomly selects a wallpaper from the gruvbox collection for the SDDM login screen
# Install to: /usr/local/bin/sddm-wallpaper-randomizer.sh

WALLPAPER_DIR="/home/caleb/Projects/arch-dotfiles/wallpapers/Pictures/Wallpapers"
DEST="/usr/share/backgrounds/sddm-background"

# Pick a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)

# Copy with correct extension
EXT="${WALLPAPER##*.}"
cp "$WALLPAPER" "${DEST}.${EXT}"

# Update SDDM config with correct path
sed -i "s|background=.*|background=${DEST}.${EXT}|" /etc/sddm.conf.d/theme.conf
