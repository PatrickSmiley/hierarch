#!/bin/bash
# Hierarch - SC2 Protoss Sound Hooks for Claude Code
# Interactive installer

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo ""
echo "  ⬡  Hierarch - SC2 Protoss Sound Hooks"
echo "     You must construct additional prompts."
echo ""

# Check prerequisites
if ! command -v mpv &>/dev/null; then
  echo "ERROR: mpv is required but not installed."
  echo "  Linux/WSL: sudo apt install mpv"
  echo "  macOS:     brew install mpv"
  exit 1
fi

# --- Prompt 1: Sound mode ---
echo "Which sound mode?"
echo ""
echo "  [1] All units (default)"
echo "      Full SC2 multiplayer Protoss roster. 9 units, 80 voice lines."
echo ""
echo "  [2] Probe only"
echo "      Just Probe chirps. Subtle, non-distracting beeps and boops."
echo ""
read -p "Choose [1/2]: " MODE_CHOICE
MODE_CHOICE="${MODE_CHOICE:-1}"

if [ "$MODE_CHOICE" = "2" ]; then
  SC2_MODE="probe"
else
  SC2_MODE="all"
fi

echo ""

# --- Prompt 2: Playback ---
echo "How should sounds play?"
echo ""
echo "  [1] Stream from web (default)"
echo "      No downloads. Requires internet while using Claude."
echo ""
echo "  [2] Download locally"
echo "      Downloads ~80 sounds. Works offline. Requires ffmpeg + curl."
echo ""
read -p "Choose [1/2]: " PLAYBACK_CHOICE
PLAYBACK_CHOICE="${PLAYBACK_CHOICE:-1}"

if [ "$PLAYBACK_CHOICE" = "2" ]; then
  DOWNLOAD_LOCAL=true
  for cmd in ffmpeg curl; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "ERROR: $cmd is required for local playback."
      echo "  Linux/WSL: sudo apt install $cmd"
      echo "  macOS:     brew install $cmd"
      exit 1
    fi
  done
else
  DOWNLOAD_LOCAL=false
fi

echo ""

# --- Prompt 3: Hook scope ---
echo "Where should hooks be installed?"
echo ""
echo "  [1] Global (default)"
echo "      Sounds play in every Claude Code session."
echo "      Writes to: ~/.claude/settings.json"
echo ""
echo "  [2] This project only"
echo "      Sounds only play when working in this directory."
echo "      Writes to: .claude/settings.json (committable)"
echo ""
echo "  [3] This project only (private)"
echo "      Same as above but gitignored."
echo "      Writes to: .claude/settings.local.json"
echo ""
read -p "Choose [1/2/3]: " SCOPE_CHOICE
SCOPE_CHOICE="${SCOPE_CHOICE:-1}"

case "$SCOPE_CHOICE" in
  2)
    SETTINGS="$(pwd)/.claude/settings.json"
    mkdir -p "$(pwd)/.claude"
    SCOPE_DESC="project (.claude/settings.json)"
    ;;
  3)
    SETTINGS="$(pwd)/.claude/settings.local.json"
    mkdir -p "$(pwd)/.claude"
    SCOPE_DESC="project-local (.claude/settings.local.json)"
    ;;
  *)
    SETTINGS="$CLAUDE_DIR/settings.json"
    SCOPE_DESC="global (~/.claude/settings.json)"
    ;;
esac

echo ""
echo "=== Installing ==="
echo "  Mode: $SC2_MODE"
echo "  Playback: $([ "$DOWNLOAD_LOCAL" = true ] && echo "local" || echo "stream")"
echo "  Hooks: $SCOPE_DESC"
echo ""

# --- Step 1: Install scripts ---
echo "[1/4] Installing scripts..."
mkdir -p "$CLAUDE_DIR"

cp "$SCRIPT_DIR/play-sc2.sh" "$CLAUDE_DIR/play-sc2.sh"
cp "$SCRIPT_DIR/sc2-toggle.sh" "$CLAUDE_DIR/sc2-toggle.sh"
chmod +x "$CLAUDE_DIR/play-sc2.sh" "$CLAUDE_DIR/sc2-toggle.sh"

# Save repo path (for streaming fallback)
echo "$SCRIPT_DIR" > "$CLAUDE_DIR/sc2-hierarch-path"

# Set mode
echo "$SC2_MODE" > "$CLAUDE_DIR/sc2-mode"

# --- Step 2: Download sounds if local ---
echo ""
if [ "$DOWNLOAD_LOCAL" = true ]; then
  echo "[2/4] Downloading and converting sounds..."
  bash "$SCRIPT_DIR/download-sounds.sh"
else
  echo "[2/4] Skipping download (streaming mode)"
  echo "  Sounds will stream from StarCraft Wiki when played."
fi

# --- Step 3: Configure hooks ---
echo ""
echo "[3/4] Configuring hooks..."
echo "  Target: $SCOPE_DESC"

# Backup existing settings
if [ -f "$SETTINGS" ]; then
  cp "$SETTINGS" "${SETTINGS}.backup"
  echo "  Backed up existing settings"
fi

if [ -f "$SETTINGS" ]; then
  if grep -q "play-sc2.sh" "$SETTINGS" 2>/dev/null; then
    echo "  Hooks already configured, skipping"
  else
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
print('  Hooks added')
"
    else
      echo "  WARNING: python3 not found. Please manually add hooks."
      echo "  See README.md for hook configuration."
    fi
  fi
else
  mkdir -p "$(dirname "$SETTINGS")"
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
  echo "  Created new settings with hooks"
fi

# --- Step 4: Verify ---
echo ""
echo "[4/4] Verifying..."
echo "  Player: $CLAUDE_DIR/play-sc2.sh"
echo "  Toggle: $CLAUDE_DIR/sc2-toggle.sh"
echo "  Mode: $SC2_MODE"

if [ "$DOWNLOAD_LOCAL" = true ]; then
  SOUND_COUNT=$(find "$CLAUDE_DIR/sounds" -name "*.mp3" 2>/dev/null | wc -l)
  echo "  Local sounds: $SOUND_COUNT mp3 files"
else
  echo "  Streaming from: StarCraft Wiki"
fi

echo "  Hooks: $SCOPE_DESC"

echo ""
echo "=== Done! ==="
echo ""
echo "Restart Claude Code. You should hear a Protoss unit greet you."
echo ""
echo "Switch modes anytime:"
echo "  ~/.claude/sc2-toggle.sh probe   # Probe chirps only"
echo "  ~/.claude/sc2-toggle.sh all     # Full Protoss roster"
echo ""
