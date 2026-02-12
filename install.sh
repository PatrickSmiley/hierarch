#!/bin/bash
# SC2 Protoss Sound Hooks - Installer for Claude Code
# Downloads sounds, installs scripts, configures hooks

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

echo "=== SC2 Protoss Sound Hooks - Installer ==="
echo ""

# Check prerequisites
for cmd in ffmpeg mpv curl; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: $cmd is required but not installed."
    echo "  Linux/WSL: sudo apt install $cmd"
    echo "  macOS:     brew install $cmd"
    exit 1
  fi
done

echo "[1/4] Downloading and converting sounds..."
bash "$SCRIPT_DIR/download-sounds.sh"

echo ""
echo "[2/4] Installing scripts..."
cp "$SCRIPT_DIR/play-sc2.sh" "$CLAUDE_DIR/play-sc2.sh"
cp "$SCRIPT_DIR/sc2-toggle.sh" "$CLAUDE_DIR/sc2-toggle.sh"
chmod +x "$CLAUDE_DIR/play-sc2.sh" "$CLAUDE_DIR/sc2-toggle.sh"

# Set default mode
if [ ! -f "$CLAUDE_DIR/sc2-mode" ]; then
  echo "all" > "$CLAUDE_DIR/sc2-mode"
  echo "  Default mode: all (full Protoss roster)"
else
  echo "  Keeping existing mode: $(cat "$CLAUDE_DIR/sc2-mode")"
fi

echo ""
echo "[3/4] Configuring Claude Code hooks..."

# Backup existing settings
if [ -f "$SETTINGS" ]; then
  cp "$SETTINGS" "${SETTINGS}.backup"
  echo "  Backed up existing settings to settings.json.backup"
fi

# Read existing settings and merge hooks
if [ -f "$SETTINGS" ]; then
  # Check if hooks already exist
  if grep -q "play-sc2.sh" "$SETTINGS" 2>/dev/null; then
    echo "  Hooks already configured, skipping"
  else
    # Use python/node to merge JSON if available, otherwise warn
    if command -v python3 &>/dev/null; then
      python3 -c "
import json
with open('$SETTINGS') as f:
    settings = json.load(f)
hooks = {
    'SessionStart': [{'hooks': [{'type': 'command', 'command': 'bash ~/.claude/play-sc2.sh start', 'async': True}]}],
    'UserPromptSubmit': [{'hooks': [{'type': 'command', 'command': 'bash ~/.claude/play-sc2.sh prompt', 'async': True}]}],
    'Stop': [{'hooks': [{'type': 'command', 'command': 'bash ~/.claude/play-sc2.sh done', 'async': True}]}],
    'PreCompact': [{'hooks': [{'type': 'command', 'command': 'bash ~/.claude/play-sc2.sh compact', 'async': True}]}]
}
if 'hooks' not in settings:
    settings['hooks'] = {}
for event, config in hooks.items():
    existing = settings['hooks'].get(event, [])
    has_sc2 = any('play-sc2' in str(e) for e in existing)
    if not has_sc2:
        settings['hooks'][event] = existing + config
with open('$SETTINGS', 'w') as f:
    json.dump(settings, f, indent=2)
print('  Hooks added to existing settings')
"
    else
      echo "  WARNING: python3 not found. Please manually add hooks to $SETTINGS"
      echo "  See README.md for hook configuration"
    fi
  fi
else
  # No existing settings, create fresh
  cat > "$SETTINGS" << 'SETTINGS_EOF'
{
  "hooks": {
    "SessionStart": [{"hooks": [{"type": "command", "command": "bash ~/.claude/play-sc2.sh start", "async": true}]}],
    "UserPromptSubmit": [{"hooks": [{"type": "command", "command": "bash ~/.claude/play-sc2.sh prompt", "async": true}]}],
    "Stop": [{"hooks": [{"type": "command", "command": "bash ~/.claude/play-sc2.sh done", "async": true}]}],
    "PreCompact": [{"hooks": [{"type": "command", "command": "bash ~/.claude/play-sc2.sh compact", "async": true}]}]
  }
}
SETTINGS_EOF
  echo "  Created new settings.json with hooks"
fi

echo ""
echo "[4/4] Verifying..."
SOUND_COUNT=$(find "$CLAUDE_DIR/sounds" -name "*.mp3" 2>/dev/null | wc -l)
echo "  Sounds installed: $SOUND_COUNT mp3 files"
echo "  Player script: $CLAUDE_DIR/play-sc2.sh"
echo "  Toggle script: $CLAUDE_DIR/sc2-toggle.sh"
echo "  Current mode: $(cat "$CLAUDE_DIR/sc2-mode" 2>/dev/null || echo 'all')"

echo ""
echo "=== Installation complete! ==="
echo ""
echo "Sounds will play automatically in Claude Code."
echo "Toggle modes: ~/.claude/sc2-toggle.sh [probe|all]"
echo ""
