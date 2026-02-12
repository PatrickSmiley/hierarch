# SC2 Protoss Sounds for Claude Code

Play StarCraft II Protoss unit voice lines as Claude Code hook notifications. Hear a Zealot acknowledge your prompt, a Carrier announce task completion, or an Immortal greet you when a session starts.

## Features

- **4 hook events**: SessionStart, UserPromptSubmit, Stop, PreCompact
- **2 modes**: Probe-only (subtle chirps) or full SC2 multiplayer roster
- **80 curated sounds** from 9 Protoss units
- **SC2 multiplayer units only** -- no SC1, campaign, or co-op units
- **Random selection** -- different sound each time

## Units

Probe, Zealot, Stalker, Dark Templar, Adept, Immortal, Carrier, Void Ray, Oracle

## Quick Install

```bash
# Prerequisites
sudo apt install ffmpeg mpv    # Linux/WSL
# or
brew install ffmpeg mpv        # macOS

# Install
git clone https://github.com/yourusername/hierarch.git
cd hierarch
bash install.sh
```

The install script will:
1. Download 80 sound clips from the StarCraft wiki
2. Convert .ogg to .mp3 via ffmpeg
3. Copy scripts to `~/.claude/`
4. Configure hooks in `~/.claude/settings.json`

## Usage

Sounds play automatically on Claude Code lifecycle events. No action needed.

### Switch modes

```bash
~/.claude/sc2-toggle.sh probe   # Probe chirps only (subtle)
~/.claude/sc2-toggle.sh all     # Full Protoss roster
~/.claude/sc2-toggle.sh         # Toggle between them
```

Or just tell Claude: "switch to probe" / "switch to all"

### Preview sounds

Open `preview.html` in a browser to audition all sounds before installing.

## Hook Mapping

| Hook | Theme | What plays |
|------|-------|------------|
| **SessionStart** | Coming online | "Carrier has arrived!", "Prismatic core online.", Probe trained chirps |
| **UserPromptSubmit** | Acknowledged | "It shall be done.", "By your will!", "I will comply.", Probe selected chirps |
| **Stop** | Task complete | "The battle is won.", "Command me.", "Systems at full.", Probe confirm chirps |
| **PreCompact** | Memory loss | "We cannot hold!", "An omen?", "Our window is short.", Probe death sound |

## File Structure

```
~/.claude/
├── settings.json          # Hook configuration (auto-configured)
├── play-sc2.sh           # Player script
├── sc2-toggle.sh         # Mode toggle
├── sc2-mode              # Current mode (probe/all)
└── sounds/
    ├── probe/            # Probe-only sounds
    │   ├── start/
    │   ├── prompt/
    │   ├── done/
    │   └── compact/
    └── all/              # Full roster sounds
        ├── start/
        ├── prompt/
        ├── done/
        └── compact/
```

## Requirements

- [Claude Code](https://claude.ai/claude-code) CLI
- `ffmpeg` (for converting .ogg downloads to .mp3)
- `mpv` (for playing sounds)
- Linux, WSL, or macOS

## Credits

- Sound files sourced from [StarCraft Wiki](https://starcraft.fandom.com/) (Blizzard Entertainment)
- Inspired by [starcraft-claude](https://github.com/rubenflamshepherd/starcraft-claude) by rubenflamshepherd

## License

MIT (scripts and configuration only). StarCraft II audio is property of Blizzard Entertainment.
