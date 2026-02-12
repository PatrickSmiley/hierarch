<p align="center">
  <img src="logo.svg" alt="Hierarch" width="160" />
</p>

<h1 align="center">Hierarch</h1>

<p align="center">
  <em>StarCraft II Protoss voice lines as Claude Code hook notifications.</em>
  <br />
  <strong>You must construct additional prompts.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.1-00aaff" alt="version" />
  <img src="https://img.shields.io/badge/race-protoss-00ccff" alt="protoss" />
  <img src="https://img.shields.io/badge/units-9-44ddff" alt="units" />
  <img src="https://img.shields.io/badge/sounds-80-88eeff" alt="sounds" />
</p>

---

Hear Protoss units react to your Claude Code workflow. A Zealot acknowledges your prompt. A Carrier announces task completion. An Immortal greets you when a session starts. A Probe chirps happily throughout.

## Features

- **4 hook events**: SessionStart, UserPromptSubmit, Stop, PreCompact
- **2 modes**: Probe-only (subtle chirps) or full Protoss roster
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
git clone https://github.com/PatrickSmiley/hierarch.git
cd hierarch
bash install.sh
```

The install script will:
1. Download 80 sound clips from the StarCraft Wiki
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

- [Claude Code](https://code.claude.com) CLI
- `ffmpeg` (for converting .ogg downloads to .mp3)
- `mpv` (for playing sounds)
- Linux, WSL, or macOS

## Credits & Acknowledgments

This project was inspired by and builds upon the work of others:

- **[Boris Cherny](https://x.com/bcherny)** ([@bcherny](https://github.com/bcherny)) -- Creator of [Claude Code](https://code.claude.com). The [hooks system](https://code.claude.com/docs/en/hooks) he built is what makes this project possible.

- **[starcraft-claude](https://github.com/rubenflamshepherd/starcraft-claude)** by [@rubenflamshepherd](https://github.com/rubenflamshepherd) -- The original StarCraft sound hooks project for Claude Code. Provides a full Node.js web UI for browsing, previewing, and downloading sounds across all three races (Protoss, Terran, Zerg). This project wouldn't exist without it.

- **[Delba Oliveira](https://x.com/delba_oliveira)** ([@delba_oliveira](https://x.com/delba_oliveira)) -- Staff Developer Advocate at Vercel, whose [post about Claude Code hooks](https://x.com/delba_oliveira/status/2020515010985005255) kicked off the idea.

- **[StarCraft Wiki](https://starcraft.fandom.com/wiki/StarCraft_II_unit_quotations/Protoss)** on Fandom -- Community-maintained wiki where all unit quotation audio files are hosted.

## Legal

### This Repository (Scripts & Configuration)

MIT License. See [LICENSE](LICENSE) for full text.

### StarCraft II Audio Content

**All StarCraft II audio, voice lines, character names, unit names, and related game assets are the intellectual property of Blizzard Entertainment, Inc., a subsidiary of Activision Blizzard King (Microsoft).**

- StarCraft, StarCraft II, Protoss, and all related names, logos, and imagery are **trademarks or registered trademarks** of Blizzard Entertainment, Inc.
- This repository contains **no audio files**. Sound clips are downloaded by the user from the [StarCraft Wiki on Fandom](https://starcraft.fandom.com/) during installation.
- Audio files on the StarCraft Wiki are community-uploaded game extracts hosted on Fandom's infrastructure under their [Terms of Use](https://www.fandom.com/terms-of-use) and [Licensing Policy](https://www.fandom.com/licensing).
- Use of StarCraft II game content may be subject to Blizzard's [End User License Agreement](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement).

**This is an unofficial fan project for personal use. It is not affiliated with, endorsed by, or sponsored by Blizzard Entertainment, Activision Blizzard, Microsoft, or Fandom.**

---

<p align="center">
  <em>My life for Aiur.</em>
</p>
