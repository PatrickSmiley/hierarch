#!/bin/bash
# Play a random SC2 Protoss sound for a Claude Code hook event
# Auto-detects: if local mp3s exist, plays them. Otherwise streams from web.
# Usage: play-sc2.sh <event>
# Events: start, prompt, done, compact

EVENT="$1"
MODE_FILE="$HOME/.claude/sc2-mode"
PATH_FILE="$HOME/.claude/sc2-hierarch-path"
VOL_FILE="$HOME/.claude/sc2-volume"
ALLOWED_DOMAIN="static.wikia.nocookie.net"

# Read mode (default: all) — validate against whitelist
if [ -f "$MODE_FILE" ]; then
  MODE=$(cat "$MODE_FILE")
else
  MODE="all"
fi
case "$MODE" in
  probe|all) ;;
  *) MODE="all" ;;
esac

# Read volume (default: 50, range: 0-100) — validate as integer
if [ -f "$VOL_FILE" ]; then
  VOLUME=$(cat "$VOL_FILE")
else
  VOLUME=50
fi
if ! [ "$VOLUME" -eq "$VOLUME" ] 2>/dev/null; then VOLUME=50; fi
if [ "$VOLUME" -lt 0 ]; then VOLUME=0; fi
if [ "$VOLUME" -gt 100 ]; then VOLUME=100; fi

# Check for local mp3s first
SOUND_DIR="$HOME/.claude/sounds/$MODE/$EVENT"
if [ -d "$SOUND_DIR" ]; then
  FILES=("$SOUND_DIR"/*.mp3)
  if [ ${#FILES[@]} -gt 0 ] && [ -f "${FILES[0]}" ]; then
    mpv --no-video --really-quiet --volume="$VOLUME" -- "${FILES[$RANDOM % ${#FILES[@]}]}" &
    exit 0
  fi
fi

# No local files — stream from URL manifest
if [ ! -f "$PATH_FILE" ]; then exit 0; fi
REPO_DIR=$(cat "$PATH_FILE")
MANIFEST="$REPO_DIR/sounds/$MODE/$EVENT.txt"
if [ ! -f "$MANIFEST" ]; then exit 0; fi
mapfile -t URLS < "$MANIFEST"
if [ ${#URLS[@]} -eq 0 ]; then exit 0; fi

# Pick a random URL and validate domain before playing
URL="${URLS[$RANDOM % ${#URLS[@]}]}"
if [[ "$URL" == https://"$ALLOWED_DOMAIN"/* ]]; then
  mpv --no-video --really-quiet --volume="$VOLUME" -- "$URL" &
fi
