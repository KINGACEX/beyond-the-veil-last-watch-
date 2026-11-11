# BTV XH-002 — Touch Input Lifecycle and Analog-Composition Hardening

**Status:** IMPLEMENTED ON ISOLATED FEATURE BRANCH — HEADLESS PASS, PHYSICAL ANDROID QA STILL PENDING
**Date:** 2026-11-08
**Branch:** `btv/agent-minimax-xh-002`
**Base:** `btv/mobile-touch-input-adapter-001` at `3484672809ad95e4e36591e7ca7d49d5f61dfd5e`
**Origin:** XH-001 review findings (MiniMax Code, Implementation Agent)
**Status against the shared protocol:** PROPOSED → IN PROGRESS. This branch is **not merged** and **not pushed**.

## Why this task exists

XH-001 was a review task. It confirmed the M2 touch implementation works on Godot 4.7.2 headless and
reproduced CI run 42500466981 locally, but it also confirmed four defects that block Android readiness and
three that weaken the test evidence. This task fixes the four defects and adds the missing test coverage.

Fixed here (XH-001 IDs):
- **HIGH-1** camera look silently dies when the player arrives late or is replaced.
- **MEDIUM-1** the authored joystick deadzone was not the effective one; the analog curve was applied twice.
- **MEDIUM-2** touch release and focus loss cancelled actions held by another input source.
- **MEDIUM-3** Android backgrounding (`NOTIFICATION_APPLICATION_PAUSED`) was not handled.
- **MEDIUM-4** a hidden overlay still consumed touches and drove the player.
- **LOW-1** the look delta was sent through an untyped `call()` to a private method.

Deliberately **not** fixed here — they need Claude's visual brief and creator decisions:
**HIGH-2** (fixed-pixel HUD, no safe-area insets) and **HIGH-3** (resolution-dependent look sensitivity).
Both are visual/layout decisions, not mechanical fixes, and both are listed in the XH-002 task as deferred.

## Changes

### `scripts/touch_controls.gd`
- **Player resolution is now re-evaluated.** `_resolve_player()` returns the cached player while it is
  valid and otherwise re-queries the `btv_player` group. It is called in `_ready()` and before every look
  delta, so a player that spawns after the HUD — or is replaced on respawn — is picked up automatically.
  (XH-001 HIGH-1)
- **Analog composition is single-sourced.** The adapter's deadzone and rescale now produce the final
  action strength; the InputMap deadzone no longer re-processes it. (XH-001 MEDIUM-1)
- **Action ownership.** `_owned_actions` records the strength this overlay applied to each action. An
  action is released only when it still carries that strength, so a keyboard or gamepad holding the same
  action is never cancelled by touch cleanup. `_release_all_actions()` releases only owned actions.
  (XH-001 MEDIUM-2)
- **Android backgrounding.** `NOTIFICATION_APPLICATION_PAUSED` is handled alongside
  `NOTIFICATION_APPLICATION_FOCUS_OUT`. (XH-001 MEDIUM-3)
- **A hidden overlay no longer consumes input.** `_input()` returns early when the overlay is not
  visible. (XH-001 MEDIUM-4)
- **Typed look call.** `_player.call("_apply_look_delta", …)` became `_player.apply_look_delta(…)`.
  (XH-001 LOW-1)

### `scripts/player_controller.gd`
- `apply_look_delta()` is now the public look entry point shared by the mouse path and the touch HUD.
  `_apply_look_delta()` remains as a compatibility alias so the existing M1 camera suite is unaffected.

### `project.godot`
- The four movement actions now declare `"deadzone": 0.0`. The analog curve is produced once, by the
  touch adapter; a second deadzone applied by `Input.get_vector()` compressed the low end of the joystick
  range and made the authored deadzone unreachable. Keyboard input is digital (strength exactly 1.0), so
  keyboard movement is unchanged.

### `.github/workflows/godot-validation.yml`
- The five new suites run in CI, and the branch is added to the push trigger list.

### `tests/touch_controls_integration_test.gd` (modified)
- The suite now makes the overlay visible. Previously it drove the HUD **while it was hidden** — an
  artefact of headless CI reporting no touchscreen. That is the state in which XH-001 MEDIUM-4 hid, so the
  old suite could not have caught it. No assertions were weakened or removed.

## New test suites

| Suite | Covers | Assertions |
|---|---|---|
| `tests/touch_controls_lifecycle_test.gd` | player arrives after the HUD; player replaced | 4 |
| `tests/touch_controls_composition_test.gd` | action strength equals player input; deadzone; full deflection; diagonal | 12 |
| `tests/touch_controls_coexistence_test.gd` | keyboard-held actions survive touch release, focus loss and teardown | 7 |
| `tests/touch_controls_resize_test.gd` | overlay tracks the viewport; joystick stays usable at 2400×1080 and 1080×2400 | 9 |
| `tests/touch_controls_input_path_test.gd` | events delivered through `root.push_input()`; hidden overlay does not drive the player | 5 |

The input-path suite is the important one: the pre-existing suites call the overlay's `_input` handler
directly, which bypasses viewport routing, GUI dispatch and `set_input_as_handled()`. The new suite pushes
real events through the viewport instead.

## Verification

**Godot 4.7.2 stable (`4.7.2.stable.official.ed1daf0bf`), headless, run locally:**

| Suite | Result |
|---|---|
| `nli_smoke_test.gd` | PASS |
| `nli_contract_test.gd` | PASS |
| `mission_data_validator_test.gd` | PASS |
| `core_interaction_acceptance_test.gd` | PASS |
| `player_camera_input_test.gd` | PASS |
| `touch_input_adapter_test.gd` | PASS |
| `touch_controls_integration_test.gd` | PASS (updated, see above) |
| `touch_controls_lifecycle_test.gd` | PASS (new) |
| `touch_controls_composition_test.gd` | PASS (new) |
| `touch_controls_coexistence_test.gd` | PASS (new) |
| `touch_controls_resize_test.gd` | PASS (new) |
| `touch_controls_input_path_test.gd` | PASS (new) |
| main scene, 10 frames | PASS |

12/12 suites pass, plus the 10-frame main-scene launch. Exact commands:

```bash
godot --headless --editor --path . --quit
godot --headless --path . --script res://tests/<suite>.gd
godot --headless --path . --quit-after 10
```

**Not yet verified:** physical Android multitouch, latency, thumb reach, safe-area insets, orientation
change, UI scale and readability, camera sensitivity, frame pacing, memory and thermal behaviour, and an
actual Android export. Headless synthetic input tests cannot establish any of these.

## Known limitations of this change

- **HIGH-2 and HIGH-3 remain open.** The HUD is still laid out in fixed pixels with no safe-area insets,
  and look sensitivity is still expressed per screen pixel. Both are visual decisions that need Claude's
  brief and a creator device decision.
- **Action ownership is a heuristic.** Godot keeps a single state per action, so when a keyboard and the
  joystick drive the *same* action at the same time the last writer wins. The ownership table prevents
  touch cleanup from cancelling another source's action; it cannot merge two simultaneous sources of one
  action. A dedicated input source that the player controller sums would be the architectural fix.
- **The Android export pipeline is still not configured.** No `export_presets.cfg`, no application
  identifier, no signing, no export job. The identifier remains a creator decision and was not chosen here.
- **`.uid` files are still untracked.** Godot 4.7 generates one per script and the repository tracks none
  of them, so every checkout produces untracked files. Recommended follow-up, outside this task's scope.

## Recommended next step

1. Creator and ChatGPT review this branch against the XH-001 findings it claims to close.
2. Claude (Visual Director) supplies the HUD/safe-area/sensitivity brief so HIGH-2 and HIGH-3 can be
   addressed in a separate, bounded task.
3. Creator selects the Android application identifier, after which a debug export job can be configured
   (export templates first — CI currently installs none).
