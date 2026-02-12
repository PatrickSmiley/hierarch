#!/bin/bash
# Play a random SC2 Protoss sound for a Claude Code hook event
# Usage: play-sc2.sh <event>
# Events: start, prompt, done, compact

EVENT="$1"
MODE_FILE="$HOME/.claude/sc2-mode"

# Read mode (default: all)
if [ -f "$MODE_FILE" ]; then
  MODE=$(cat "$MODE_FILE")
else
  MODE="all"
fi

SOUND_DIR="$HOME/.claude/sounds/$MODE/$EVENT"

if [ ! -d "$SOUND_DIR" ]; then
  exit 0
fi

# Pick a random mp3
FILES=("$SOUND_DIR"/*.mp3)
if [ ${#FILES[@]} -eq 0 ]; then
  exit 0
fi

RANDOM_FILE="${FILES[$RANDOM % ${#FILES[@]}]}"

# Play via mpv (no video, no terminal output, quick)
mpv --no-video --really-quiet --volume=70 "$RANDOM_FILE" &
