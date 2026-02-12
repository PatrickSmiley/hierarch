#!/bin/bash
# Toggle SC2 sound mode between "probe" and "all"
# Usage: sc2-toggle.sh [probe|all]

MODE_FILE="$HOME/.claude/sc2-mode"
CURRENT=$(cat "$MODE_FILE" 2>/dev/null || echo "all")

if [ -n "$1" ]; then
  # Set specific mode
  NEW="$1"
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
