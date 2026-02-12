# Hierarch - Claude Code Project Instructions

## What This Is

Hierarch plays StarCraft II Protoss voice lines on Claude Code lifecycle events (hooks). Built on the [hooks system](https://code.claude.com/docs/en/hooks) created by Boris Cherny ([@bcherny](https://github.com/bcherny)), the creator of Claude Code.

## Quick Start (Run This for the User)

### 1. Check Prerequisites

```bash
command -v mpv && echo "mpv installed" || echo "MISSING: mpv"
```

If missing:
- **Linux/WSL:** `sudo apt install mpv`
- **macOS:** `brew install mpv`

For local playback mode, also need `ffmpeg` and `curl`.

Do NOT run sudo yourself. The user must run it.

### 2. Run the Installer

```bash
bash install.sh
```

The installer prompts for three choices:

**Sound mode:**
1. **All units** (default) — full SC2 multiplayer roster, 9 units, 80 voice lines
2. **Probe only** — subtle chirps, non-distracting

**Playback:**
1. **Stream** (default) — plays .ogg directly from StarCraft Wiki URLs. No downloads needed.
2. **Local** — downloads ~80 sounds, converts to .mp3 via ffmpeg. Works offline.

**Hook scope** (per Claude Code docs on [hook locations](https://code.claude.com/docs/en/hooks#hook-locations)):
1. **Global** (default) — `~/.claude/settings.json` — sounds in every session
2. **Project** — `.claude/settings.json` — sounds only in this project (committable)
3. **Project-local** — `.claude/settings.local.json` — same but gitignored

**Auto-detection:** The player checks for local mp3 files first. If found, plays locally. If not, streams from web. No config file needed — just install and go.

### 3. Verify

```bash
cat ~/.claude/sc2-mode                # "probe" or "all"
grep play-sc2 ~/.claude/settings.json # hook entries (or check project settings)
```

Tell the user to restart Claude Code.

## How It Works

1. Claude Code hooks call `play-sc2.sh <event>` on lifecycle events
2. Script reads mode from `~/.claude/sc2-mode`
3. Checks for local mp3s at `~/.claude/sounds/{mode}/{event}/` — if found, plays locally
4. Otherwise reads URL manifest at `{repo}/sounds/{mode}/{event}.txt`, picks random URL, streams via mpv

All hooks use `"async": true` so sounds never block Claude.

### Important: Don't Move This Repo (Stream Mode)

The player reads `~/.claude/sc2-hierarch-path` to find URL manifests. If you move the repo, re-run `bash install.sh`.

## Modes

| Mode | What It Does |
|------|-------------|
| `probe` | Probe chirps only. Subtle beeps and boops. |
| `all` | Full SC2 multiplayer roster. 9 units, 80 voice lines. |

Switch: `~/.claude/sc2-toggle.sh [probe|all]`

## Sound Manifests (Stream Mode)

URL manifests at `sounds/{mode}/{event}.txt` — one URL per line, pointing to .ogg files on StarCraft Wiki. To add or change sounds, edit these files.

## Units (SC2 Multiplayer Only)

Probe, Zealot, Stalker, Dark Templar, Adept, Immortal, Carrier, Void Ray, Oracle.

No SC1, campaign, or co-op units.

## Hook Event Mapping

| Event | Folder | Theme |
|-------|--------|-------|
| `SessionStart` | `start` | Unit coming online, greeting |
| `UserPromptSubmit` | `prompt` | Acknowledging orders, ready |
| `Stop` | `done` | Task complete, awaiting command |
| `PreCompact` | `compact` | Danger, distress, memory loss |

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
| Sound too loud/quiet | Edit volume in `~/.claude/play-sc2.sh` (default: 70) |
| Stream fails | Check internet; or switch to local: reinstall with option 2 |
