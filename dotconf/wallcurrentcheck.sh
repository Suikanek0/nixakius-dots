#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPERS_DIR="$SCRIPT_DIR/wallpapers"
DEST="$WALLPAPERS_DIR/current_wallpaper"

WALLPAPER=$(
    awww query 2>/dev/null |
    sed -n 's/.*image: //p' |
    head -n 1
)

if [[ -n "$WALLPAPER" && -f "$WALLPAPER" ]]; then
    rm -f "$DEST"
    cp "$WALLPAPER" "$DEST"
    
    echo "Successfully copied $(basename "$WALLPAPER") to $DEST"
else
    echo "Could not detect the current wallpaper." >&2
    exit 1
fi
