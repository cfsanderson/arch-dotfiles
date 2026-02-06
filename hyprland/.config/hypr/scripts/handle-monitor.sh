#!/bin/bash
# Dynamic workspace-to-monitor assignment for Hyprland
#
# When only the laptop (eDP-1) is connected: all workspaces 1-10 on laptop
# When external monitor (HDMI-A-1) is plugged in: 1-5 on laptop, 6-10 on external
#
# Usage:
#   handle-monitor.sh listen       - Background listener for monitor hotplug events
#   handle-monitor.sh arrange      - One-shot workspace arrangement
#   handle-monitor.sh switch N     - Switch to workspace N on its assigned monitor
#   handle-monitor.sh movetoworkspace N - Move active window to workspace N on its assigned monitor

set -euo pipefail

LAPTOP="eDP-1"
EXTERNAL="HDMI-A-1"
LAPTOP_WORKSPACES=(1 2 3 4 5)
EXTERNAL_WORKSPACES=(6 7 8 9 10)

# Throttle: ignore rapid-fire events within this window (seconds)
THROTTLE_SECONDS=3
LAST_RUN=0

has_external() {
    hyprctl monitors -j | jq -e ".[] | select(.name == \"$EXTERNAL\")" > /dev/null 2>&1
}

# Get the monitor a workspace should live on
target_monitor() {
    local ws=$1
    if has_external && [[ $ws -ge 6 ]]; then
        echo "$EXTERNAL"
    else
        echo "$LAPTOP"
    fi
}

arrange_workspaces() {
    local monitors
    monitors=$(hyprctl monitors -j)

    # Save active workspace per monitor to restore after rearranging
    local active_workspaces
    active_workspaces=$(echo "$monitors" | jq -r '.[] | "\(.name):\(.activeWorkspace.id)"')

    local external_present
    external_present=$(echo "$monitors" | jq -r "[.[] | select(.name == \"$EXTERNAL\")] | length")

    if [[ "$external_present" -ge 1 ]]; then
        # Dual monitor: 1-5 on laptop, 6-10 on external
        for ws in "${LAPTOP_WORKSPACES[@]}"; do
            hyprctl keyword workspace "$ws, monitor:$LAPTOP, default:true" > /dev/null 2>&1
            hyprctl dispatch moveworkspacetomonitor "$ws $LAPTOP" > /dev/null 2>&1
        done
        for ws in "${EXTERNAL_WORKSPACES[@]}"; do
            hyprctl keyword workspace "$ws, monitor:$EXTERNAL, default:true" > /dev/null 2>&1
            hyprctl dispatch moveworkspacetomonitor "$ws $EXTERNAL" > /dev/null 2>&1
        done
    else
        # Single monitor: all workspaces on laptop
        for ws in "${LAPTOP_WORKSPACES[@]}" "${EXTERNAL_WORKSPACES[@]}"; do
            hyprctl keyword workspace "$ws, monitor:$LAPTOP, default:true" > /dev/null 2>&1
            hyprctl dispatch moveworkspacetomonitor "$ws $LAPTOP" > /dev/null 2>&1
        done
    fi

    # Restore previously active workspaces
    while IFS= read -r line; do
        local mon_name=${line%%:*}
        local ws_id=${line##*:}
        if echo "$monitors" | jq -e ".[] | select(.name == \"$mon_name\")" > /dev/null 2>&1; then
            hyprctl dispatch workspace "$ws_id" > /dev/null 2>&1
        fi
    done <<< "$active_workspaces"
}

# Switch to a workspace on its assigned monitor (used by keybindings)
switch_workspace() {
    local ws=$1
    local mon
    mon=$(target_monitor "$ws")
    hyprctl --batch "dispatch focusmonitor $mon; dispatch workspace $ws" > /dev/null 2>&1
}

# Move active window to workspace on its assigned monitor (used by keybindings)
move_to_workspace() {
    local ws=$1
    local mon
    mon=$(target_monitor "$ws")
    # Move workspace to correct monitor first (if it exists elsewhere), then move window
    hyprctl dispatch movetoworkspace "$ws" > /dev/null 2>&1
}

listen() {
    local socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

    socat -u "UNIX-CONNECT:$socket" - | while IFS= read -r line; do
        case "$line" in
            monitoradded*|monitorremoved*)
                local now
                now=$(date +%s)
                if (( now - LAST_RUN >= THROTTLE_SECONDS )); then
                    LAST_RUN=$now
                    sleep 1
                    arrange_workspaces
                fi
                ;;
        esac
    done
}

case "${1:-}" in
    arrange) arrange_workspaces ;;
    listen) listen ;;
    switch) switch_workspace "${2:?workspace number required}" ;;
    movetoworkspace) move_to_workspace "${2:?workspace number required}" ;;
    *)
        echo "Usage: $0 [arrange|listen|switch N|movetoworkspace N]"
        exit 1
        ;;
esac
