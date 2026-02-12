# Hierarch - Claude Code Project Instructions

## What This Is

StarCraft II Protoss voice lines as Claude Code hook notifications. Bash scripts + HTML preview, no framework. Built on the [hooks system](https://code.claude.com/docs/en/hooks) created by Boris Cherny ([@bcherny](https://github.com/bcherny)), the creator of Claude Code.

## Architecture
- **install.sh** — Interactive installer. Handles everything: mode, playback, hook scope. Just run `bash install.sh` and it prompts the user.
- **scripts/play-sc2.sh** — Reads mode from `~/.claude/sc2-mode`, picks random sound, plays via mpv
- **scripts/sc2-toggle.sh** — Switches between `probe` and `all` modes, volume control
- **scripts/download-sounds.sh** — Fetches .ogg from StarCraft Wiki, converts to .mp3 (only used if user picks local playback)
- **preview.html** — Browser-based sound audition (streams .ogg from wiki URLs)
- **assets/logo.svg** — Project logo
- **sounds/{mode}/{event}.txt** — URL manifests for streaming mode (one URL per line)

## Install

The only prerequisite is `mpv`. Check it, then run the installer — it handles everything interactively:

```bash
command -v mpv && echo "mpv installed" || echo "MISSING: sudo apt install mpv"
bash install.sh
```

Do NOT run sudo yourself. The user must run it.

Tell the user to restart Claude Code after install.

## How It Works

1. Claude Code hooks call `play-sc2.sh <event>` on lifecycle events
2. Script reads mode from `~/.claude/sc2-mode`
3. Checks for local mp3s at `~/.claude/sounds/{mode}/{event}/` — if found, plays locally
4. Otherwise reads URL manifest at `{repo}/sounds/{mode}/{event}.txt`, picks random URL, streams via mpv

All hooks use `"async": true` so sounds never block Claude.

### Important: Don't Move This Repo (Stream Mode)

The player reads `~/.claude/sc2-hierarch-path` to find URL manifests. If you move the repo, re-run `bash install.sh`.

## Sound Curation Rules

- **SC2 multiplayer Protoss units ONLY** — No SC1, campaign, or co-op units
- **Current roster:** Probe, Zealot, Stalker, Dark Templar, Adept, Immortal, Carrier, Void Ray, Oracle

### Hook Event Mapping

| Event | Folder | Theme |
|-------|--------|-------|
| `SessionStart` | `start` | Unit coming online, greeting |
| `UserPromptSubmit` | `prompt` | Acknowledging orders, ready |
| `Stop` | `done` | Task complete, awaiting command |
| `PreCompact` | `compact` | Danger, distress, memory loss |

## Two Modes

| Mode | What It Does |
|------|-------------|
| `probe` | Probe chirps only. Subtle beeps and boops. |
| `all` | All Protoss sounds. 9 units, 80 voice lines. |

Switch: `~/.claude/sc2-toggle.sh [probe|all]`

## Key Constraints
- Audio is streamed by default. No files downloaded unless user picks local playback.
- All audio is Blizzard IP — repo contains scripts only, no audio committed
- No Node.js, no build step, no dependencies beyond mpv
- Hooks use `async: true` so sounds never block Claude

## Uninstall

```bash
rm ~/.claude/play-sc2.sh ~/.claude/sc2-toggle.sh ~/.claude/sc2-mode ~/.claude/sc2-hierarch-path
rm -rf ~/.claude/sounds  # if local mode was used
```

Then remove hook entries from settings (search for "play-sc2").

## Troubleshooting

| Problem | Fix |
|---------|-----|
| No sound | Check `mpv` installed: `command -v mpv` |
| "No such file" errors | Re-run `bash install.sh` (repo path changed) |
| Wrong mode | Check: `cat ~/.claude/sc2-mode` |
| Hooks not firing | Check settings for "play-sc2" entries |
| Adjust volume | `~/.claude/sc2-toggle.sh volume [0-100]` (default: 50) |
| Stream fails | Check internet; or reinstall with local playback option |
