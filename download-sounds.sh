#!/bin/bash
# Download SC2 Protoss sounds for Claude Code hooks
# Sources from StarCraft wiki, converts .ogg -> .mp3 via ffmpeg

SOUNDS_DIR="$HOME/.claude/sounds"
FAILED=0
SUCCESS=0

download() {
  local mode="$1"   # probe or all
  local event="$2"  # start, prompt, done, compact
  local name="$3"   # filename (no extension)
  local url="$4"

  local dir="$SOUNDS_DIR/$mode/$event"
  local outfile="$dir/${name}.mp3"

  if [ -f "$outfile" ]; then
    echo "  SKIP $mode/$event/${name}.mp3 (exists)"
    return 0
  fi

  local tmpfile="/tmp/sc2_${name}.ogg"

  # Download
  if ! curl -sL -o "$tmpfile" "$url" 2>/dev/null; then
    echo "  FAIL download: $name"
    FAILED=$((FAILED + 1))
    return 1
  fi

  # Check if we actually got audio (not an HTML error page)
  local size=$(stat -c%s "$tmpfile" 2>/dev/null || echo 0)
  if [ "$size" -lt 1000 ]; then
    echo "  FAIL too small ($size bytes): $name"
    rm -f "$tmpfile"
    FAILED=$((FAILED + 1))
    return 1
  fi

  # Convert to mp3
  if ! ffmpeg -y -i "$tmpfile" -codec:a libmp3lame -b:a 192k "$outfile" 2>/dev/null; then
    echo "  FAIL convert: $name"
    rm -f "$tmpfile"
    FAILED=$((FAILED + 1))
    return 1
  fi

  rm -f "$tmpfile"
  echo "  OK   $mode/$event/${name}.mp3"
  SUCCESS=$((SUCCESS + 1))
}

# Helper: download for both probe and all modes
probe_and_all() { download "probe" "$@"; download "all" "$@"; }
all_only() { download "all" "$@"; }

echo "=== SessionStart ==="

# Probe sounds for start
probe_and_all "start" "probe_trained1" "https://static.wikia.nocookie.net/starcraft/images/3/35/Probe_Ready0.ogg/revision/latest?cb=20211026192405"
probe_and_all "start" "probe_trained2" "https://static.wikia.nocookie.net/starcraft/images/8/85/Probe_Ready1.ogg/revision/latest?cb=20211026192406"

# All SC2 unit start sounds
all_only "start" "carrier_arrived" "https://static.wikia.nocookie.net/starcraft/images/3/32/Carrier_Ready00.ogg/revision/latest?cb=20211013142125"
all_only "start" "zealot_mylife" "https://static.wikia.nocookie.net/starcraft/images/0/08/Zealot_Ready00.ogg/revision/latest?cb=20211026183404"
all_only "start" "immortal_return" "https://static.wikia.nocookie.net/starcraft/images/8/84/Immortal_Ready00.ogg/revision/latest?cb=20211021130855"
all_only "start" "voidray_prismatic" "https://static.wikia.nocookie.net/starcraft/images/b/bf/VoidRay_Ready00.ogg/revision/latest?cb=20211022182637"
all_only "start" "stalker_shadows" "https://static.wikia.nocookie.net/starcraft/images/c/c3/Stalker_Ready00.ogg/revision/latest?cb=20211021141905"
all_only "start" "dt_from_shadows" "https://static.wikia.nocookie.net/starcraft/images/6/62/DarkTemplar_Ready00.ogg/revision/latest?cb=20211013145624"
all_only "start" "oracle_perceiving" "https://static.wikia.nocookie.net/starcraft/images/f/fa/ZVO_ProtossOracle_ProtossFlyingCaster_006.ogg/revision/latest?cb=20211021144720"
all_only "start" "oracle_strings" "https://static.wikia.nocookie.net/starcraft/images/c/c3/ZVO_ProtossOracle_ProtossFlyingCaster_005.ogg/revision/latest?cb=20211021144717"
all_only "start" "immortal_heed" "https://static.wikia.nocookie.net/starcraft/images/d/d7/Immortal_What00.ogg/revision/latest?cb=20211021130857"
all_only "start" "oracle_guidance" "https://static.wikia.nocookie.net/starcraft/images/7/7e/ZVO_ProtossOracle_ProtossFlyingCaster_007.ogg/revision/latest?cb=20211021144722"
all_only "start" "oracle_aid" "https://static.wikia.nocookie.net/starcraft/images/a/ab/ZVO_ProtossOracle_ProtossFlyingCaster_008.ogg/revision/latest?cb=20211021144724"
all_only "start" "stalker_skills" "https://static.wikia.nocookie.net/starcraft/images/a/af/Stalker_What02.ogg/revision/latest?cb=20211021141912"
all_only "start" "dt_service" "https://static.wikia.nocookie.net/starcraft/images/7/7c/DarkTemplar_What04.ogg/revision/latest?cb=20211013145629"

echo ""
echo "=== UserPromptSubmit ==="

# Probe sounds for prompt
probe_and_all "prompt" "probe_selected1" "https://static.wikia.nocookie.net/starcraft/images/a/ae/Probe_What0.ogg/revision/latest?cb=20211026192407"
probe_and_all "prompt" "probe_selected2" "https://static.wikia.nocookie.net/starcraft/images/4/4a/Probe_What1.ogg/revision/latest?cb=20211026192408"
probe_and_all "prompt" "probe_confirm1" "https://static.wikia.nocookie.net/starcraft/images/c/ce/Probe_Yes0.ogg/revision/latest?cb=20211026192409"
probe_and_all "prompt" "probe_confirm2" "https://static.wikia.nocookie.net/starcraft/images/c/ce/Probe_Yes1.ogg/revision/latest?cb=20211026192410"

# All SC2 unit prompt sounds
all_only "prompt" "adept_done" "https://static.wikia.nocookie.net/starcraft/images/5/58/Adept_Yes01.ogg/revision/latest?cb=20211012014820"
all_only "prompt" "stalker_asyousay" "https://static.wikia.nocookie.net/starcraft/images/b/b9/Stalker_Yes01.ogg/revision/latest?cb=20211021141920"
all_only "prompt" "stalker_verywell" "https://static.wikia.nocookie.net/starcraft/images/d/d9/Stalker_Yes00.ogg/revision/latest?cb=20211021141919"
all_only "prompt" "stalker_bidding" "https://static.wikia.nocookie.net/starcraft/images/a/ae/Stalker_What04.ogg/revision/latest?cb=20211021141916"
all_only "prompt" "stalker_intriguing" "https://static.wikia.nocookie.net/starcraft/images/2/27/Stalker_Yes02.ogg/revision/latest?cb=20211021141922"
all_only "prompt" "dt_comply" "https://static.wikia.nocookie.net/starcraft/images/a/a4/DarkTemplar_Yes00.ogg/revision/latest?cb=20211013145634"
all_only "prompt" "dt_void" "https://static.wikia.nocookie.net/starcraft/images/4/4b/DarkTemplar_Yes01.ogg/revision/latest?cb=20211013145635"
all_only "prompt" "dt_clever" "https://static.wikia.nocookie.net/starcraft/images/9/9d/DarkTemplar_Yes02.ogg/revision/latest?cb=20211013145636"
all_only "prompt" "dt_askofus" "https://static.wikia.nocookie.net/starcraft/images/9/93/DarkTemplar_What06.ogg/revision/latest?cb=20211013145632"
all_only "prompt" "zealot_byyourwill" "https://static.wikia.nocookie.net/starcraft/images/3/38/Zealot_Yes02.ogg/revision/latest?cb=20211026183413"
all_only "prompt" "zealot_honor" "https://static.wikia.nocookie.net/starcraft/images/6/64/Zealot_Yes00.ogg/revision/latest?cb=20211026183411"
all_only "prompt" "zealot_artanis" "https://static.wikia.nocookie.net/starcraft/images/0/05/Zealot_Yes05.ogg/revision/latest?cb=20211026183415"
all_only "prompt" "immortal_destined" "https://static.wikia.nocookie.net/starcraft/images/8/80/Immortal_Yes00.ogg/revision/latest?cb=20211021130907"
all_only "prompt" "immortal_march" "https://static.wikia.nocookie.net/starcraft/images/7/73/Immortal_Yes05.ogg/revision/latest?cb=20211021130913"
all_only "prompt" "voidray_done" "https://static.wikia.nocookie.net/starcraft/images/d/d9/VoidRay_Yes01.ogg/revision/latest?cb=20211022182645"
all_only "prompt" "voidray_calibrating" "https://static.wikia.nocookie.net/starcraft/images/c/c8/VoidRay_Yes00.ogg/revision/latest?cb=20211022182644"
all_only "prompt" "oracle_begin" "https://static.wikia.nocookie.net/starcraft/images/8/81/ZVO_ProtossOracle_ProtossFlyingCaster_010.ogg/revision/latest?cb=20211021144727"
all_only "prompt" "oracle_isee" "https://static.wikia.nocookie.net/starcraft/images/4/4a/ZVO_ProtossOracle_ProtossFlyingCaster_014.ogg/revision/latest?cb=20211021144732"
all_only "prompt" "carrier_proceed" "https://static.wikia.nocookie.net/starcraft/images/1/1a/Carrier_What01.ogg/revision/latest?cb=20211013142127"
all_only "prompt" "carrier_agreed" "https://static.wikia.nocookie.net/starcraft/images/b/bd/Carrier_Yes04.ogg/revision/latest?cb=20211013142139"
all_only "prompt" "carrier_victory" "https://static.wikia.nocookie.net/starcraft/images/f/f1/Carrier_Yes02.ogg/revision/latest?cb=20211013142136"
all_only "prompt" "carrier_ready" "https://static.wikia.nocookie.net/starcraft/images/4/46/Carrier_What05.ogg/revision/latest?cb=20211013142132"

echo ""
echo "=== Stop (Task Done) ==="

# Probe sounds for done
probe_and_all "done" "probe_selected3" "https://static.wikia.nocookie.net/starcraft/images/c/c5/Probe_What2.ogg/revision/latest?cb=20211026192408"
probe_and_all "done" "probe_confirm3" "https://static.wikia.nocookie.net/starcraft/images/5/59/Probe_Yes2.ogg/revision/latest?cb=20211026192411"
probe_and_all "done" "probe_confirm4" "https://static.wikia.nocookie.net/starcraft/images/8/83/Probe_Yes3.ogg/revision/latest?cb=20211026192412"

# All SC2 unit done sounds
all_only "done" "carrier_battlewon" "https://static.wikia.nocookie.net/starcraft/images/0/0b/Carrier_Yes07.ogg/revision/latest?cb=20211013142143"
all_only "done" "carrier_awaiting" "https://static.wikia.nocookie.net/starcraft/images/5/5a/Carrier_What03.ogg/revision/latest?cb=20211013142130"
all_only "done" "carrier_victoryawaits" "https://static.wikia.nocookie.net/starcraft/images/c/c6/Carrier_What00.ogg/revision/latest?cb=20211013142126"
all_only "done" "voidray_charged" "https://static.wikia.nocookie.net/starcraft/images/7/78/VoidRay_What00.ogg/revision/latest?cb=20211022182639"
all_only "done" "voidray_systemsfull" "https://static.wikia.nocookie.net/starcraft/images/f/f9/VoidRay_Yes06.ogg/revision/latest?cb=20211022182651"
all_only "done" "voidray_fullpower" "https://static.wikia.nocookie.net/starcraft/images/e/e3/VoidRay_What03.ogg/revision/latest?cb=20211022182642"
all_only "done" "immortal_duty" "https://static.wikia.nocookie.net/starcraft/images/0/02/Immortal_What04.ogg/revision/latest?cb=20211021130902"
all_only "done" "immortal_glory" "https://static.wikia.nocookie.net/starcraft/images/b/bc/Immortal_What03.ogg/revision/latest?cb=20211021130901"
all_only "done" "zealot_commandme" "https://static.wikia.nocookie.net/starcraft/images/7/73/Zealot_What02.ogg/revision/latest?cb=20211026183407"
all_only "done" "zealot_meditation" "https://static.wikia.nocookie.net/starcraft/images/b/b4/Zealot_What00.ogg/revision/latest?cb=20211026183405"
all_only "done" "oracle_threads" "https://static.wikia.nocookie.net/starcraft/images/b/b4/ZVO_ProtossOracle_ProtossFlyingCaster_009.ogg/revision/latest?cb=20211021144725"
all_only "done" "dt_twilight" "https://static.wikia.nocookie.net/starcraft/images/c/c8/DarkTemplar_What00.ogg/revision/latest?cb=20211013145625"

echo ""
echo "=== PreCompact (Memory Wipe) ==="

# Probe sounds for compact
probe_and_all "compact" "probe_death" "https://static.wikia.nocookie.net/starcraft/images/2/23/Probe_Death0.ogg/revision/latest?cb=20211026192403"
probe_and_all "compact" "probe_annoyed1" "https://static.wikia.nocookie.net/starcraft/images/1/1e/Probe_Pissed0.ogg/revision/latest?cb=20211026192403"
probe_and_all "compact" "probe_annoyed2" "https://static.wikia.nocookie.net/starcraft/images/b/ba/Probe_Pissed1.ogg/revision/latest?cb=20211026192404"

# All SC2 unit compact sounds
all_only "compact" "oracle_omen" "https://static.wikia.nocookie.net/starcraft/images/2/21/ZVO_ProtossOracle_ProtossFlyingCaster_011.ogg/revision/latest?cb=20211021144728"
all_only "compact" "oracle_window" "https://static.wikia.nocookie.net/starcraft/images/4/4a/ZVO_ProtossOracle_ProtossFlyingCaster_012.ogg/revision/latest?cb=20211021144730"
all_only "compact" "stalker_void" "https://static.wikia.nocookie.net/starcraft/images/9/90/Stalker_What00.ogg/revision/latest?cb=20211021141908"
all_only "compact" "dt_fear" "https://static.wikia.nocookie.net/starcraft/images/1/17/DarkTemplar_What01.ogg/revision/latest?cb=20211013150436"
all_only "compact" "dt_darkness" "https://static.wikia.nocookie.net/starcraft/images/0/0c/DarkTemplar_What02.ogg/revision/latest?cb=20211013145627"
all_only "compact" "zealot_cannothold" "https://static.wikia.nocookie.net/starcraft/images/5/56/Zealot_Help00.ogg/revision/latest?cb=20211026184128"
all_only "compact" "voidray_channel" "https://static.wikia.nocookie.net/starcraft/images/2/24/VoidRay_What04.ogg/revision/latest?cb=20211022182644"
all_only "compact" "immortal_closes" "https://static.wikia.nocookie.net/starcraft/images/3/30/Immortal_Help00.ogg/revision/latest?cb=20211021130840"
all_only "compact" "carrier_peril" "https://static.wikia.nocookie.net/starcraft/images/6/68/Carrier_Help00.ogg/revision/latest?cb=20211013142114"

echo ""
echo "=== DONE ==="
echo "Success: $SUCCESS | Failed: $FAILED"
echo ""
echo "Files:"
find "$SOUNDS_DIR" -name "*.mp3" | wc -l
echo "mp3 files total"
