#!/bin/bash

# Check if Spotify is running
if ! pgrep -x "spotify" > /dev/null; then
    echo "󰝚 Spotify Offline"
    exit 0
fi

# Check if playerctl can find spotify
if ! playerctl --player=spotify status > /dev/null 2>&1; then
    echo "󰝚 Spotify Not Playing"
    exit 0
fi

# Get current status
STATUS=$(playerctl --player=spotify status 2>/dev/null)

# Define icons
PLAY_ICON="󰐊"
PAUSE_ICON="󰏤"
PREV_ICON="󰒮"
NEXT_ICON="󰒭"

# Output the controls based on status
case $STATUS in
    "Playing")
        echo "${PREV_ICON} ${PAUSE_ICON} ${NEXT_ICON}"
        ;;
    "Paused")
        echo "${PREV_ICON} ${PLAY_ICON} ${NEXT_ICON}"
        ;;
    *)
        echo "${PREV_ICON} ${PLAY_ICON} ${NEXT_ICON}"
        ;;
esac
