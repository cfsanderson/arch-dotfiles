#!/bin/bash
# Dynamic workspace-to-monitor assignment for Hyprland
#
# When only the laptop (eDP-1) is connected: all workspaces 1-10 on laptop
# When external monitor (HDMI-A-1) is plugged in: 1-5 on laptop, 6-10 on external
#
# Usage:
#   handle-monitor.sh listen   - Background listener for monitor hotplug events
#   handle-monitor.sh arrange  - One-shot workspace arrangement

set -euo pipefail

LAPTOP="eDP-1"
EXTERNAL="HDMI-A-1"
LAPTOP_WORKSPACES=(1 2 3 4 5)
EXTERNAL_WORKSPACES=(6 7 8 9 10)

# Throttle: ignore rapid-fire events within this window (seconds)
THROTTLE_SECONDS=3
LAST_RUN=0

arrange_workspaces() {
    local monitors
    monitors=$(hyprctl monitors -j)

    local monitor_count
    monitor_count=$(echo "$monitors" | jq 'length')

    # Save active workspace per monitor to restore after rearranging
    local active_workspaces
    active_workspaces=$(echo "$monitors" | jq -r '.[] | "\(.name):\(.activeWorkspace.id)"')

    local has_external
    has_external=$(echo "$monitors" | jq -r "[.[] | select(.name == \"$EXTERNAL\")] | length")

    if [[ "$has_external" -ge 1 ]]; then
        # Dual monitor: 1-5 on laptop, 6-10 on external
        for ws in "${LAPTOP_WORKSPACES[@]}"; do
            hyprctl keyword workspace "$ws, monitor:$LAPTOP" > /dev/null 2>&1
            hyprctl dispatch moveworkspacetomonitor "$ws $LAPTOP" > /dev/null 2>&1
        done
        for ws in "${EXTERNAL_WORKSPACES[@]}"; do
            hyprctl keyword workspace "$ws, monitor:$EXTERNAL" > /dev/null 2>&1
            hyprctl dispatch moveworkspacetomonitor "$ws $EXTERNAL" > /dev/null 2>&1
        done
    else
        # Single monitor: all workspaces on laptop
        for ws in "${LAPTOP_WORKSPACES[@]}" "${EXTERNAL_WORKSPACES[@]}"; do
            hyprctl keyword workspace "$ws, monitor:$LAPTOP" > /dev/null 2>&1
            hyprctl dispatch moveworkspacetomonitor "$ws $LAPTOP" > /dev/null 2>&1
        done
    fi

    # Restore previously active workspaces
    while IFS= read -r line; do
        local mon_name=${line%%:*}
        local ws_id=${line##*:}
        # Only restore if that monitor still exists
        if echo "$monitors" | jq -e ".[] | select(.name == \"$mon_name\")" > /dev/null 2>&1; then
            hyprctl dispatch workspace "$ws_id" > /dev/null 2>&1
        fi
    done <<< "$active_workspaces"
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
                    # Small delay to let Hyprland finish setting up the monitor
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
    *)
        echo "Usage: $0 [arrange|listen]"
        exit 1
        ;;
esac
