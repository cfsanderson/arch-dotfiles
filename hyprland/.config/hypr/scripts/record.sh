#!/bin/bash
# Screen recording toggle using wf-recorder
# Usage: record.sh [region|output]
# - If already recording: stops and saves
# - If not recording: starts (region uses slurp for area selection)

RECORDINGS_DIR="$HOME/Videos/Recordings"
PIDFILE="/tmp/wf-recorder.pid"

is_recording() {
    local pid
    pid=$(cat "$PIDFILE" 2>/dev/null) || return 1
    kill -0 "$pid" 2>/dev/null
}

stop_recording() {
    local pid
    pid=$(cat "$PIDFILE" 2>/dev/null) || return
    kill -SIGINT "$pid" 2>/dev/null
    wait "$pid" 2>/dev/null
    rm -f "$PIDFILE"
    notify-send "Recording stopped" "Saved to $RECORDINGS_DIR" -t 3000
}

mkdir -p "$RECORDINGS_DIR"

# Toggle: stop if already recording
if is_recording; then
    stop_recording
    exit 0
fi

FILENAME="$RECORDINGS_DIR/recording_$(date +%Y%m%d_%H%M%S).mp4"

case "${1:-region}" in
    region)
        GEOMETRY=$(slurp) || exit 1
        wf-recorder -g "$GEOMETRY" -f "$FILENAME" &
        echo $! > "$PIDFILE"
        notify-send "Recording" "Recording region — press Super+Alt+R to stop" -t 3000
        ;;
    output)
        wf-recorder -f "$FILENAME" &
        echo $! > "$PIDFILE"
        notify-send "Recording" "Recording full screen — press Super+Alt+Shift+R to stop" -t 3000
        ;;
    *)
        echo "Usage: $0 [region|output]"
        exit 1
        ;;
esac
