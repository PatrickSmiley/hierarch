#!/bin/bash
# Toggle SC2 sound mode or adjust volume
# Usage: sc2-toggle.sh [probe|all]           - switch sound mode
#        sc2-toggle.sh volume [0-100]        - set volume level
#        sc2-toggle.sh volume                - show current volume

MODE_FILE="$HOME/.claude/sc2-mode"
VOL_FILE="$HOME/.claude/sc2-volume"

if [ "$1" = "volume" ]; then
  CURRENT_VOL=$(cat "$VOL_FILE" 2>/dev/null || echo "50")
  if [ -n "$2" ]; then
    # Validate as integer
    if ! [ "$2" -eq "$2" ] 2>/dev/null; then
      echo "Error: volume must be a number (0-100)"
      exit 1
    fi
    # Clamp to 0-100
    NEW_VOL="$2"
    if [ "$NEW_VOL" -lt 0 ]; then NEW_VOL=0; fi
    if [ "$NEW_VOL" -gt 100 ]; then NEW_VOL=100; fi
    echo "$NEW_VOL" > "$VOL_FILE"
    echo "SC2 volume: ${NEW_VOL}% (was: ${CURRENT_VOL}%)"
  else
    echo "SC2 volume: ${CURRENT_VOL}%"
  fi
  exit 0
fi

# Mode toggle — validate against whitelist
CURRENT=$(cat "$MODE_FILE" 2>/dev/null || echo "all")

if [ -n "$1" ]; then
  case "$1" in
    probe|all) NEW="$1" ;;
    *) echo "Error: mode must be 'probe' or 'all'"; exit 1 ;;
  esac
else
  # Toggle
  if [ "$CURRENT" = "all" ]; then
    NEW="probe"
  else
    NEW="all"
  fi
fi

echo "$NEW" > "$MODE_FILE"
echo "SC2 sounds: $NEW mode (was: $CURRENT)"
echo "  probe = Probe chirps only"
echo "  all   = Full SC2 Protoss roster"
