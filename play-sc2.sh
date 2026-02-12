#!/bin/bash
# Play a random SC2 Protoss sound for a Claude Code hook event
# Auto-detects: if local mp3s exist, plays them. Otherwise streams from web.
# Usage: play-sc2.sh <event>
# Events: start, prompt, done, compact

EVENT="$1"
MODE_FILE="$HOME/.claude/sc2-mode"
PATH_FILE="$HOME/.claude/sc2-hierarch-path"

# Read mode (default: all)
if [ -f "$MODE_FILE" ]; then
  MODE=$(cat "$MODE_FILE")
else
  MODE="all"
fi

# Check for local mp3s first
SOUND_DIR="$HOME/.claude/sounds/$MODE/$EVENT"
if [ -d "$SOUND_DIR" ]; then
  FILES=("$SOUND_DIR"/*.mp3)
  if [ ${#FILES[@]} -gt 0 ] && [ -f "${FILES[0]}" ]; then
    mpv --no-video --really-quiet --volume=70 "${FILES[$RANDOM % ${#FILES[@]}]}" &
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
mpv --no-video --really-quiet --volume=70 "${URLS[$RANDOM % ${#URLS[@]}]}" &
