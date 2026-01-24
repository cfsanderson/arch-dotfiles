#!/bin/bash
# Screenshot script using grim + slurp
# Usage: screenshot.sh [region|window|output]

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOTS_DIR"

FILENAME="$SCREENSHOTS_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

case "$1" in
    region)
        grim -g "$(slurp)" - | tee "$FILENAME" | wl-copy
        ;;
    window)
        # Get active window geometry from hyprctl
        GEOMETRY=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$GEOMETRY" - | tee "$FILENAME" | wl-copy
        ;;
    output)
        grim - | tee "$FILENAME" | wl-copy
        ;;
    *)
        echo "Usage: $0 [region|window|output]"
        exit 1
        ;;
esac

notify-send "Screenshot saved" "$FILENAME" -i "$FILENAME" -t 3000
