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

### [1.3.0] - 2026-02-12

#### Changed
- Moved `play-sc2.sh`, `sc2-toggle.sh`, `download-sounds.sh` into `scripts/`
- Moved `logo.svg` into `assets/`
- Updated `install.sh` path references for new structure
- Clean repo root: only entry points (`install.sh`, `preview.html`) and docs remain

---

### [1.2.2] - 2026-02-12

#### Fixed
- Quoted `$VOLUME` in mpv `--volume` argument
- Added `--` separator before mpv file/URL arguments to prevent option injection

---

### [1.2.1] - 2026-02-12

#### Added
- Mode whitelist validation in player script (`probe`/`all` only)
- Volume range validation in player and toggle scripts (integer, 0-100)
- URL domain validation — streaming only allows `static.wikia.nocookie.net`

#### Changed
- `install.sh` Python hook injection uses `sys.argv` instead of shell string interpolation
- Script permissions tightened from 755 to 744
- Expanded `.gitignore` to cover `.env`, downloaded sounds, user config files, keys, backups

---

### [1.2.0] - 2026-02-12

#### Added
- Volume config file (`~/.claude/sc2-volume`) — adjust volume without editing scripts
- Volume commands via toggle script: `sc2-toggle.sh volume [0-100]`

#### Changed
- Default playback volume lowered from 70% to 50%
- Player script reads volume from `~/.claude/sc2-volume` instead of hardcoded value

---

### [1.1.1] - 2026-02-09

#### Added
- Mode selection prompt in installer (choose all units or probe-only at install time)

---

### [1.1.0] - 2026-02-09

#### Added
- Streaming playback: sounds play directly from StarCraft Wiki URLs, no downloads required
- Interactive installer with prompts for playback method and hook scope
- Project-scoped hook support (global, project, project-local)
- Auto-detection: plays local mp3s if present, otherwise streams from web
- `.claude/CLAUDE.md` project instructions for Claude Code

#### Changed
- Default playback is now streaming (was download-only)
- Installer handles all configuration interactively

#### Removed
- ROADMAP.md (unnecessary for a utility project)

---

### [1.0.1] - 2026-02-08

#### Added
- SVG pylon logo
- Credits section: Boris Cherny (Claude Code creator), rubenflamshepherd (starcraft-claude), Delba Oliveira, StarCraft Wiki
- Expanded legal section with Blizzard/Activision/Microsoft IP notice

---

### [1.0.0] - 2026-02-08

#### Added
- Initial release
- 80 curated SC2 Protoss sounds across 4 hook events
- Two modes: `probe` (chirps only) and `all` (full Protoss roster)
- Download script: fetches .ogg from StarCraft Wiki, converts to .mp3 via ffmpeg
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
