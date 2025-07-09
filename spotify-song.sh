#!/bin/bash

# Check if Spotify is running
if ! pgrep -x "spotify" > /dev/null; then
    echo "󰝚 Offline"
    exit 0
fi

# Check if playerctl can find spotify
if ! playerctl --player=spotify status > /dev/null 2>&1; then
    echo "󰝚 Not Playing"
    exit 0
fi

# Get current status
STATUS=$(playerctl --player=spotify status 2>/dev/null)

# If not playing, show paused or stopped status
if [ "$STATUS" != "Playing" ]; then
    echo "󰝚 $STATUS"
    exit 0
fi

# Get song information
ARTIST=$(playerctl --player=spotify metadata artist 2>/dev/null)
TITLE=$(playerctl --player=spotify metadata title 2>/dev/null)

# If we have both artist and title, display them
if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
    echo "󰝚 $TITLE"
else
    echo "󰝚 Unknown"
fi
