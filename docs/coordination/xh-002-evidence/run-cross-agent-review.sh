#!/usr/bin/env bash
# ============================================================================
# BTV — run the real cross-agent exchange with Claude and ChatGPT.
#
#   bash run-cross-agent-review.sh            # both
#   bash run-cross-agent-review.sh claude     # Claude only
#   bash run-cross-agent-review.sh codex      # ChatGPT (Codex) only
#
# Requires both CLIs to be signed in:
#   claude auth login      # Anthropic account / Claude subscription
#   codex login --device-auth   # ChatGPT account
#
# Output: /workspace/xh-001/agent-replies/
# ============================================================================
set -uo pipefail

BRIDGE="/workspace/xh-001"
REPO="$BRIDGE/review-clone"
OUT_DIR="$BRIDGE/agent-replies"
MODEL="${BTV_CLAUDE_MODEL:-claude-sonnet-5-5}"
TARGET="${1:-both}"

mkdir -p "$OUT_DIR"

CLAUDE_PROMPT="You are the Visual Director for the BTV game project (Godot 4.7, GDScript, Android-first).

Read these sources in the repository at $REPO (branch btv/agent-minimax-xh-002):
  docs/agents/CLAUDE_VISUAL_DIRECTOR_CHARTER_v1.0.md
  docs/agents/BTV_AGENT_TASK_AND_HANDOFF_PROTOCOL_v1.0.md
  docs/visual/BTV_VISUAL_PRODUCTION_QUALITY_STANDARD_v1.0.md
  docs/source-of-truth/visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.1_Consistency_Lock.md
  scenes/touch_controls.tscn
  scripts/touch_controls.gd
  docs/implementation/BTV_XH-002_TOUCH_INPUT_HARDENING_2026-11-08.md

Context from the XH-001 implementation review (MiniMax Code), for you to check or challenge:
- The HUD is laid out in fixed pixels: the joystick is a 200x200 panel 24px from the bottom-left corner and
  the Interact button is 140x88 at 24px from the bottom-right corner. There is no safe-area inset handling
  anywhere in the codebase.
- The camera-look surface covers the entire right half of the viewport, and the Interact button sits inside
  it; the exclusion is a rectangle test against the button's fixed offsets.
- Look sensitivity is per screen pixel (0.12 degrees per pixel), so the same physical thumb swipe rotates the
  camera differently on screens with different pixel densities. Movement is density-independent.

Your task (visual and usability only):
1. Review joystick, camera-look region and Interact-button placement against the visual bible and the HUD
   consistency lock. Cite the exact document sections you rely on.
2. Assess thumb reach, accidental touches, visual hierarchy, opacity and contrast, safe areas and orientation
   changes, using the current source.
3. Produce a responsive HUD layout specification with measurable criteria, clearly labelled PROPOSED
   (do not present it as approved canon).
4. List the screenshot and device evidence you need before you would approve the layout.

Rules: do not invent Asher/Ember visuals, do not change canon, do not generate assets, do not claim to have
inspected a live build, and do not spend credits. You have not seen a physical device screenshot.

Return the review as plain markdown."

CODEX_PROMPT="You are ChatGPT, the Lead Coordinator for the BTV game project. Verify an implementation
independently against the shared source of truth and report evidence-based findings.

Repository: $REPO (branch btv/agent-minimax-xh-002, base btv/mobile-touch-input-adapter-001 at 3484672809ad95e4e36591e7ca7d49d5f61dfd5e).

Read:
  docs/agents/CHATGPT_LEAD_COORDINATOR_CHARTER_v1.0.md
  docs/agents/BTV_AGENT_TASK_AND_HANDOFF_PROTOCOL_v1.0.md
  docs/implementation/BTV_XH-002_TOUCH_INPUT_HARDENING_2026-11-08.md
  scripts/touch_controls.gd, scripts/player_controller.gd, project.godot
  tests/touch_controls_lifecycle_test.gd, tests/touch_controls_composition_test.gd,
  tests/touch_controls_coexistence_test.gd, tests/touch_controls_resize_test.gd,
  tests/touch_controls_input_path_test.gd, tests/touch_controls_integration_test.gd

Task:
1. Verify the XH-002 commit against the XH-001 findings it claims to close: HIGH-1 (player lookup),
   MEDIUM-1 (double deadzone), MEDIUM-2 (action ownership), MEDIUM-3 (Android pause),
   MEDIUM-4 (hidden overlay), LOW-1 (typed look call). For each, state CLOSED / PARTIALLY CLOSED /
   NOT CLOSED with the file and line that proves it.
2. Check whether the new tests actually prove the behaviour they claim, and identify any test that would
   still pass if the fix were reverted.
3. Identify any regression risk the branch introduces, especially in the change to project.godot deadzones
   and in the modified existing integration suite.
4. Confirm the Android export blocker status from source: export presets, CI export job, export templates.
   Do not propose or select an application identifier.
5. State whether XH-002 should be accepted as-is, accepted with changes, or rejected, and list the
   next bounded engineering task.

Rules: work only from the sources and exact commit references; do not modify files; do not merge, publish
or spend credits. Distinguish CONFIRMED, PROPOSED, OPEN, BLOCKED and UNKNOWN, and do not claim Android
readiness from headless CI. Return the report as plain markdown."

run_claude() {
  if ! command -v claude >/dev/null 2>&1; then echo "!! claude CLI missing"; return 1; fi
  # `claude auth status` exits non-zero when logged out, so capture the output
  # and inspect it directly. A `| grep -q` pipeline is not safe here: grep
  # exits on the first match, the writer takes SIGPIPE, and `set -o pipefail`
  # then turns a successful match into a failed pipeline.
  CLAUDE_STATUS="$(claude auth status 2>/dev/null)"
  if [[ "$CLAUDE_STATUS" != *'"loggedIn": true'* ]]; then
    echo "!! claude not signed in — run: claude auth login"; return 1
  fi
  echo "=== Claude ($MODEL) reviewing the HUD ==="
  claude -p --model "$MODEL" "$CLAUDE_PROMPT" 2>&1 | tee "$OUT_DIR/claude-visual-review.md"
  echo "--> $OUT_DIR/claude-visual-review.md"
}

run_codex() {
  if ! command -v codex >/dev/null 2>&1; then echo "!! codex CLI missing"; return 1; fi
  # Gate on a POSITIVE signal. `codex login status` does not always print
  # "Not logged in" — under contention with a concurrent login it can print
  # "Error loading config: ..." instead — so checking for the negative string
  # lets an unauthenticated run through. "Logged in" is capitalised, so it
  # cannot match "Not logged in".
  CODEX_STATUS="$(codex login status 2>&1)"
  if [[ "$CODEX_STATUS" != *"Logged in"* ]]; then
    echo "!! codex not signed in — run: codex login --device-auth"
    echo "   status: $(printf '%s' "$CODEX_STATUS" | head -1)"
    return 1
  fi
  echo "=== ChatGPT (Codex) verifying XH-002 ==="
  cd "$REPO" || return 1
  printf '%s' "$CODEX_PROMPT" | codex exec - 2>&1 | tee "$OUT_DIR/codex-implementation-review.md"
  echo "--> $OUT_DIR/codex-implementation-review.md"
}

case "$TARGET" in
  claude) run_claude ;;
  codex)  run_codex ;;
  both)   run_claude; echo; run_codex ;;
  *)      echo "usage: $0 [claude|codex|both]"; exit 2 ;;
esac
