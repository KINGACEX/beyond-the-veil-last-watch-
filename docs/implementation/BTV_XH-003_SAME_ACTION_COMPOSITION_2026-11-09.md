# BTV XH-003 — Same-Action Input Composition

**Status:** IMPLEMENTED ON AN ISOLATED BRANCH — HEADLESS PASS; CI AND DEVICE VALIDATION PENDING
**Date:** 2026-11-09
**Branch:** `btv/agent-minimax-xh-003`
**Base:** `btv/agent-minimax-xh-002` at `34c5af7089efa83a151fbaa79e44a070d1bf21c5`
**Origin:** XH-001 MEDIUM-2 finding, XH-002 audit addendum (2026-11-09), creator approval on Issue #3
**Status against the shared protocol:** APPROVED TO IMPLEMENT AND OPEN A DRAFT PR — not merged, not released.

## Problem

XH-002 stopped touch cleanup from cancelling an action another source was holding, but it inferred
ownership by comparing **action strength**, and Godot keeps **one state per action**. Two sources bound
to the same action therefore overwrite one another:

- The keyboard's strength is exactly `1.0`; the joystick at full deflection is also exactly `1.0`. When
  both drove the same action, the ownership check concluded "still mine" and released it — **cancelling
  the keyboard's hold**.
- The mirror case: releasing the key zeroes the action and the joystick's contribution was dropped until
  the next drag event.

Measured on the XH-002 branch (Godot 4.7.2 headless, scratch copy of the published tree):

| joystick deflection | overlay's owned strength | engine effective strength (W held) | forward movement survives the joystick release? |
|---|---|---|---|
| 20 / 40 / 60 / 63 px | 0.188 / 0.513 / 0.838 / 0.886 | 1.000 | yes |
| **70 px (full deflection)** / 100 / 140 px | **1.000** | 1.000 | **no — movement stops** |

The failure begins exactly where the joystick reaches full deflection: the ordinary case, not an edge case.

## Approach — source-separated action namespaces

Each input source owns its own actions, and the player controller composes them once.

- **Keyboard** keeps `move_forward` / `move_back` / `move_left` / `move_right` / `interact` — unchanged.
- **Touch** drives new `touch_move_forward` / `touch_move_back` / `touch_move_left` /
  `touch_move_right` / `touch_interact`. They are declared in `project.godot` with `"events": []` and
  `"deadzone": 0.0`, driven by `Input.action_press()` / `Input.action_release()` from the overlay.
- **The player controller** sums the two channels once and clamps the result to unit length:

```gdscript
func _compose_movement_intent() -> Vector2:
	var keyboard := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_back")
	var touch := Input.get_vector(&"touch_move_left", &"touch_move_right", &"touch_move_forward", &"touch_move_back")
	return (keyboard + touch).limit_length(1.0)
```

- **Interact** is accepted from either source: `Input.is_action_just_pressed("interact") or
  Input.is_action_just_pressed("touch_interact")`.

Because no keyboard is bound to a `touch_*` action, a touch release **cannot** clear a keyboard hold, and
a keyboard press **cannot** mask the joystick's analog strength. The interference is removed structurally
rather than heuristically avoided.

### The ownership heuristic is deleted

`_owned_actions`, `_release_owned_action()` and the `absf(get_action_strength(...) - owned_strength)
<= 0.01` comparison are gone from `scripts/touch_controls.gd`. The strength-based inference was the
defect; keeping a variant of it would keep the defect.

### No gamepad

No gamepad is bound anywhere in the project and no device exists to validate an axis path, so no
`gamepad_move_*` actions were declared. A future gamepad source adds its own namespace and its own term
in the composition — one line, once there is a requirement and a test path.

## Changes

| File | Change |
|---|---|
| `project.godot` | Added the `touch_move_*` and `touch_interact` actions with a comment explaining the namespace split and the zero-deadzone rule |
| `scripts/touch_controls.gd` | The overlay drives the `touch_*` namespace only; the ownership heuristic and the strength comparison are deleted; the legacy button pad keeps a simple per-action guard |
| `scripts/player_controller.gd` | Added `_compose_movement_intent()`; `_physics_process` uses it; Interact accepts either source |
| `tests/xh003_same_action_composition_test.gd` | **New** — 22 assertions (below) |
| `tests/touch_controls_coexistence_test.gd` | Switched from synthetic `Input.action_press()` to real `InputEventKey` events; asserts focus loss clears the touch action *and* leaves the keyboard action alone |
| `tests/touch_controls_composition_test.gd` | The player-vector helper now composes keyboard + touch, matching the controller |
| `tests/touch_controls_input_path_test.gd` | Asserts the `touch_*` actions driven through real viewport routing |
| `tests/touch_controls_integration_test.gd` | Asserts the `touch_*` namespace |
| `tests/core_interaction_acceptance_test.gd` | The touch-button case now asserts the touch-owned action and that the shared keyboard action is never fed by the touch |

## New regression suite — `tests/xh003_same_action_composition_test.gd` (22 assertions)

| Case | What it pins |
|---|---|
| Order A — keyboard released first | the touch contribution keeps moving, and the composed intent still points forward |
| Order B — touch released first | the keyboard-held action survives the joystick release |
| Both released | no action held, composed intent returns to zero |
| Two sources on one axis | the composed intent never exceeds unit length |
| Interact | the keyboard `interact` and the touch `touch_interact` are independent; releasing either does not cancel the other |
| Focus loss | the touch action is cleared, the keyboard action is untouched |
| Teardown | the overlay leaving the tree clears only touch state |

The suite reads the composition from the **real player controller**
(`player.call("_compose_movement_intent")`) rather than repeating the formula, so it pins the shipped code
path. It uses real `InputEventKey` events, not synthetic action presses.

## Verification

Command, per suite:

```bash
godot --headless --editor --path . --quit
godot --headless --path . --script res://tests/<suite>.gd
godot --headless --path . --quit-after 10
```

Engine: `/workspace/.tools/godot` = `4.7.2.stable.official.ed1daf0bf`, headless.

**14/14 suites PASS, 276 assertions executed, 0 failures** — up from 13 suites / 251 assertions on the
XH-002 branch. The main scene launches for 10 frames without error.

| Suite | Assertions | Result |
|---|---|---|
| `nli_smoke_test` | 50 | PASS |
| `nli_contract_test` | 41 | PASS |
| `touch_input_adapter_test` | 31 | PASS |
| `core_interaction_acceptance_test` | 25 | PASS |
| `mission_data_validator_test` | 22 | PASS |
| `xh003_same_action_composition_test` | 22 | PASS (new) |
| `touch_controls_integration_test` | 17 | PASS |
| `player_camera_input_test` | 15 | PASS |
| `touch_controls_composition_test` | 13 | PASS |
| `touch_controls_coexistence_test` | 10 | PASS |
| `touch_controls_resize_test` | 10 | PASS |
| `touch_controls_reconciliation_test` | 9 | PASS |
| `touch_controls_input_path_test` | 6 | PASS |
| `touch_controls_lifecycle_test` | 5 | PASS |
| main scene, 10 frames | — | PASS |

**Not verified:** no CI run on this branch (see below), no emulator, no physical device, no Android
export. A passing headless suite is not physical Android validation.

## CI state

**No CI run exists for this branch.** `.github/workflows/godot-validation.yml` exists on the branch but
does not trigger there — its `on.push.branches` list does not contain `btv/agent-minimax-xh-003` — and it
runs only the seven pre-existing suites, not the touch suites. Two remedies, neither applied here:

1. **No file edit:** dispatch the existing workflow on the branch
   (`POST /repos/KINGACEX/beyond-the-veil-last-watch-/actions/workflows/godot-validation.yml/dispatches`
   with `{"ref": "btv/agent-minimax-xh-003"}`). It runs the seven pre-existing suites on the branch.
   Requires a token with `actions:write` and creator approval.
2. **Permanent fix:** add the branch to `on.push.branches` and add the touch suite steps. GitHub refuses
   PAT writes under `.github/workflows/` without the `workflow` scope, so this needs either that scope or
   a paste into the web editor.

The workflow's existing steps, `permissions:` block and trigger list are unchanged by this branch.

## Known limitations

- **The camera still inherits the look pitch** (pre-existing, not introduced here): `apply_look_delta()`
  rotates `_camera_pivot.rotation.x`, and the `SpringArm3D` hangs off that same pivot, so a steep
  down-look swings the camera above the player. Measured: pitch −15° → camera y = 2.64 m; pitch −70°
  (the clamp limit) → camera y = 6.05 m, z = 1.71 m. Untested and unaddressed here; it is a separate
  bounded task.
- **HIGH-2 (no safe-area insets)** and **HIGH-3 (per-pixel look sensitivity)** remain open — visual
  decisions for the Visual Director.
- **No physical-device or emulator evidence** for multitouch, latency, thumb reach, orientation change,
  frame pacing or thermal behaviour.
- **`.uid` files are still untracked** (the repository tracks none of them, and `.gitignore` does not
  exclude them, so every checkout is a dirty tree).
- **A gamepad source is not implemented** — deliberately.

## Next actions

1. Creator reviews this branch and the draft PR.
2. CI evidence: dispatch the existing workflow on this branch, then update the workflow permanently.
3. Claude's independent review of the input architecture and the Android HUD/interaction usability.
4. Separate bounded task for the camera pitch handling, HIGH-2 and HIGH-3.
5. Android export configuration — creator selects the application identifier first.

---

*Headless verification only. No merge, no release, no Android export, no application identifier, no
workflow, permission or credential change, no canon change.*
