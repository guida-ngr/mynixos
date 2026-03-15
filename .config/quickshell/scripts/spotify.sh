#!/bin/sh
STATUS=$(playerctl -p spotify status 2>/dev/null)

if [ -z "$STATUS" ]; then
    echo '{"playing": false}'
    exit 0
fi

ARTIST=$(playerctl -p spotify metadata artist | sed 's/"/\\"/g')
TITLE=$(playerctl -p spotify metadata title | sed 's/"/\\"/g')
LENGTH=$(playerctl -p spotify metadata mpris:length 2>/dev/null)
[ -z "$LENGTH" ] && LENGTH=0

echo "{\"playing\": true, \"status\": \"$STATUS\", \"artist\": \"$ARTIST\", \"title\": \"$TITLE\", \"length\": $LENGTH}"
