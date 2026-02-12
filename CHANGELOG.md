# Changelog

All notable changes to Hierarch will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Scope

This changelog tracks **hook configuration and sound curation changes**:

| Track | Examples |
|-------|----------|
| Sound curation | New units, reassigned lines, removed sounds |
| Hook events | New events, changed event mappings |
| Scripts | Player, toggle, download, install |
| Modes | New modes, mode behavior changes |
| Compatibility | OS support, player backends |

**Not tracked:** Personal preferences, session notes.

---

### [1.2.2] - 2026-02-12

#### Fixed
- Quoted `$VOLUME` in mpv arguments
- Added `--` separator before mpv file/URL arguments

---

### [1.2.1] - 2026-02-12

#### Added
- URL domain validation for streaming
- Input validation for mode and volume

#### Changed
- `install.sh` Python hook injection uses `sys.argv` instead of shell string interpolation
- Script permissions tightened from 755 to 744
- Expanded `.gitignore`

---

### [1.2.0] - 2026-02-12

#### Added
- Volume config file (`~/.claude/sc2-volume`)
- Volume commands via toggle script: `sc2-toggle.sh volume [0-100]`

#### Changed
- Default playback volume lowered from 70% to 50%
- Player script reads volume from config file instead of hardcoded value

---

### [1.1.1] - 2026-02-09

#### Added
- Mode selection prompt in installer (probe vs all)

---

### [1.1.0] - 2026-02-09

#### Added
- Streaming playback: sounds play directly from StarCraft Wiki URLs, no downloads required
- Interactive installer: playback method and hook scope prompts
- Project-scoped hook support (global, project, project-local)
- Auto-detection: plays local mp3s if present, otherwise streams from web
- `.claude/CLAUDE.md` project instructions for Claude Code
- URL manifest files for streaming mode (`sounds/{mode}/{event}.txt`)

#### Changed
- Default playback is now streaming (was download-only)
- Installer handles all configuration interactively

---

### [1.0.1] - 2026-02-09

#### Added
- SVG pylon logo
- Full credits: Boris Cherny, rubenflamshepherd, Delba Oliveira, StarCraft Wiki
- Expanded legal section with Blizzard/Activision/Microsoft IP notice
- Fandom and Blizzard EULA links

#### Removed
- ROADMAP.md

---

### [1.0.0] - 2026-02-08

#### Added
- Initial release
- 80 curated SC2 Protoss sounds across 4 hook events
- Two modes: `probe` (chirps only) and `all` (full SC2 multiplayer roster)
- Download script: fetches .ogg from StarCraft wiki, converts to .mp3 via ffmpeg
- Player script: picks random sound from active mode, plays via mpv
- Toggle script: switch between probe and all modes
- Install script: sets up directories, downloads sounds, configures Claude Code hooks
- Preview HTML: browser-based sound audition page
- SC2 multiplayer units only (no SC1, campaign, or co-op units)
- Units: Probe, Zealot, Stalker, Dark Templar, Adept, Immortal, Carrier, Void Ray, Oracle

#### Hook mapping
- **SessionStart**: Coming online, greeting, awakening
- **UserPromptSubmit**: Acknowledged, taking orders, ready
- **Stop**: Task complete, idle, awaiting next command
- **PreCompact**: Memory loss, danger, resetting
