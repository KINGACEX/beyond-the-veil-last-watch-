# BTV — XH-003: Same-Action Input Composition and CI Evidence

**Status: PROPOSED — reproduction and architecture proposal only. Nothing implemented, nothing committed.**
**Date:** 2026-11-09
**Agent:** MiniMax Code / Mavis (session 460954906607848)
**Subject branch:** `btv/agent-minimax-xh-002` @ `34c5af7089efa83a151fbaa79e44a070d1bf21c5`
**Base branch:** `btv/mobile-touch-input-adapter-001` @ `3484672809ad95e4e36591e7ca7d49d5f61dfd5e`
**Engine:** Godot 4.7.2.stable.official.ed1daf0bf, headless
**Awaiting:** explicit creator approval before any implementation.

> No repository file was modified. The reproduction was run in a scratch copy of the published tree at
> `/workspace/.audit/probe` (extracted with `git archive`, no `.git`), so the repository working tree
> stayed clean. PR #4 was not merged, the default branch was not touched, no workflow, permission or
> credential was modified, no Android export configuration or application ID was created.

---

## 1. Root cause

### 1.1 The mechanism

Godot's `InputMap` stores **one state per action** — a single `pressed` flag and a single `strength`
value, shared by every source bound to that action. XH-002's ownership table tries to infer "is this
action still mine?" by comparing the strength the overlay applied against the strength the engine
currently reports (`scripts/touch_controls.gd:159-166`):

```gdscript
func _release_owned_action(action_name: StringName) -> void:
	if not _owned_actions.has(action_name):
		return
	var owned_strength: float = _owned_actions[action_name]
	_owned_actions.erase(action_name)
	if absf(Input.get_action_strength(action_name) - owned_strength) <= 0.01:
		Input.action_release(action_name)
```

**That comparison cannot distinguish "the action carries the strength I set" from "another source
happens to be holding the same strength".** When the keyboard is held, the action's effective strength
is exactly `1.0`; when the joystick is at full deflection, the overlay's owned strength is also exactly
`1.0`. The check therefore concludes "still mine" and **releases the action, cancelling the keyboard's
hold**. The same value collision occurs in reverse: the key-*release* event zeroes the action outright
(`pressed=false, strength=0`), discarding the joystick's contribution.

### 1.2 Reproduction evidence — LOCAL, scratch copy, Godot 4.7.2 headless

Physical W key held (real `InputEventKey`), joystick dragged forward, then the joystick released:

| joystick deflection | overlay's owned strength | engine effective strength (W held) | forward movement survives the joystick release? |
|---|---|---|---|
| 20 px | 0.188 | 1.000 | **yes** |
| 40 px | 0.513 | 1.000 | **yes** |
| 60 px | 0.838 | 1.000 | **yes** |
| 63 px | 0.886 | 1.000 | **yes** |
| **70 px (full deflection)** | **1.000** | **1.000** | **NO — movement stops** |
| 100 px | 1.000 | 1.000 | **NO — movement stops** |
| 140 px | 1.000 | 1.000 | **NO — movement stops** |

The failure begins exactly where the joystick reaches full deflection — i.e. **the normal case**, not an
edge case. Below full deflection the strengths differ, the comparison fails, and the overlay correctly
declines to release. At full deflection the two strengths collide and the keyboard is cancelled.

### 1.3 The acceptance test named in the task — LOCAL result

`tests/xh003_same_action_composition_test.gd` (draft, scratch copy only) implements the specified
sequence. Result: **4 of 12 assertions FAIL on the current branch.**

```
[Order A] keyboard held, joystick released first
PASS  A1: the physical W key holds move_forward
PASS  A2: the joystick also drives move_forward
FAIL  A4: releasing the joystick does not stop forward movement while W is held
FAIL  A4: forward movement keeps a non-zero strength while W is held
PASS  A6: forward movement stops after W is released
PASS  A6: forward movement strength reaches zero after W is released

[Order B] joystick held, keyboard released first
PASS  B1: the joystick drives move_forward
PASS  B2: the physical W key joins the held action
FAIL  B4: releasing W does not stop forward movement while the joystick is still held
FAIL  B4: the joystick's forward contribution survives the key release
PASS  B6: forward movement stops once the joystick is lifted

XH003_SAME_ACTION_COMPOSITION_TESTS: FAIL (4 failures)
```

**Order A fails at the joystick's full deflection** (the drag helper moves the stick past the radius,
so the owned strength is 1.0). **Order B fails for the complementary reason**: releasing the key zeroes
the action, and the joystick's contribution is only re-asserted on the next drag event, so movement
stops while the finger is still down.

### 1.4 The same defect reaches the `interact` action — LOCAL

`interact` is shared between the touch Interact button and the keyboard E key. With E held, pressing and
releasing the touch button:

```
E held           -> interact pressed=true  strength=1.000
+ touch button   -> interact pressed=true  strength=1.000
touch released   -> interact pressed=false strength=0.000   <-- E should still be held
RESULT: KEYBOARD E WAS CANCELLED BY THE TOUCH BUTTON
```

### 1.5 Why the existing XH-002 coexistence suite did not catch this

`tests/touch_controls_coexistence_test.gd` (8 assertions) asserts that releasing the joystick does not
cancel a held `move_forward`. It does not exercise the defect for two reasons:

1. it holds the keyboard with a **synthetic `Input.action_press()`**, not a physical key event, so the
   engine's strength for that action is the manually-set value rather than a device-driven one;
2. it drives the joystick toward **`move_right`**, a *different* action from the one the keyboard holds,
   so the two sources never contend for the same slot.

The suite therefore proves "touch cleanup does not cancel *another* action" and says nothing about two
sources contending for the *same* action — the case the task names.

### 1.6 Root cause, in one sentence

**XH-002 solved interference by inferring ownership from an action value that Godot does not partition
by source; the inference is unsound whenever another source holds the same strength (the keyboard's
`1.0` equals the joystick's full deflection), and the shared single-slot action model makes additive
simultaneous contribution impossible in principle.**

---

## 2. Proposed architecture (for approval — not implemented)

### 2.1 The requirement

Movement intent must be the sum of **independent** sources, each with its own channel:

| Source | Today | Proposed |
|---|---|---|
| Keyboard | `move_*` actions (W/A/S/D + arrows) | unchanged — `move_*` |
| Touch joystick | **shares** `move_*` via `Input.action_press` | **own** actions `touch_move_*` |
| Gamepad | **no binding exists anywhere in the project** | **own** actions `gamepad_move_*` when a pad is bound |

The player controller then receives one composed vector instead of reading a single shared channel.

### 2.2 The proposal (minimal)

**a. Give each source its own action set.** Add to `project.godot [input]`:

```
touch_move_forward={ "deadzone": 0.0, "events": [] }
touch_move_back={ "deadzone": 0.0, "events": [] }
touch_move_left={ "deadzone": 0.0, "events": [] }
touch_move_right={ "deadzone": 0.0, "events": [] }
```

`deadzone: 0.0` mirrors the existing rationale: the analog curve is produced once, by
`scripts/touch_input_adapter.gd`, and must not be re-processed by `Input.get_vector()`
(verified LOCAL: with deadzone 0.0, `get_vector` returns the raw strength — 0.100 in, 0.100 out).

**b. The touch overlay writes only to `touch_move_*`.** In `scripts/touch_controls.gd`, `_apply_movement_vector()`
and `_set_action_strength()` switch to the `touch_` namespace. The overlay's release path then releases
only `touch_move_*`, which **no keyboard can be bound to** — the interference is structurally impossible
rather than heuristically avoided.

**c. Delete the ownership heuristic.** `_owned_actions`, `_release_owned_action()` and the strength
comparison are removed. Release becomes unconditional on `touch_move_*` — safe by construction. The
`_owned_actions` dictionary, the `absf(...) <= 0.01` comparison and the "still carries the strength this
overlay set" comment all disappear.

**d. The player controller composes once.** In `scripts/player_controller.gd`:

```gdscript
func _physics_process(delta: float) -> void:
	_sync_camera_yaw()
	var input_vector := _compose_movement_intent()
	var move_direction := _get_camera_relative_move_direction(input_vector)
	...

## Sums the independent input sources into one movement intent.
## Each source owns its own action set, so no source can overwrite another.
func _compose_movement_intent() -> Vector2:
	var keyboard := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var touch := Input.get_vector("touch_move_left", "touch_move_right", "touch_move_forward", "touch_move_back")
	return (keyboard + touch).limit_length(1.0)
```

`limit_length(1.0)` prevents a diagonal speed boost (keyboard 1.0 + joystick 1.0 would otherwise reach
1.41). It is the same clamp `_get_camera_relative_move_direction()` already applies to the 3D direction.

**e. `interact` gets the same treatment.** The touch Interact button moves to `touch_interact`; the
player accepts `interact` **or** `touch_interact` (`Input.is_action_pressed("interact") or
Input.is_action_pressed("touch_interact")`). Without this, §1.4 remains a live defect.

**f. Gamepad.** No gamepad binding exists today. When one is wanted, add `gamepad_move_*` actions with
`JoypadMotion` events and a third term in `_compose_movement_intent()`. Deliberately **not** added in
XH-003: no pad is bound, no device exists to validate it, and adding an unvalidated axis path is
speculative.

### 2.3 Why this and not the alternatives

| Option | Verdict |
|---|---|
| **A. Separate action sets + compose in the player (proposed)** | **Recommended.** ~30 lines changed across 3 files, no new classes, removes the unsound inference entirely, and gamepad support falls out as one more term. |
| B. A source-registration object (`BTVMovementIntent`) where each source pushes a vector | More flexible for exotic sources, but adds a class, a push/poll contract and a second source of truth for movement. Not justified by the current source count. Reconsider if more than three source types appear. |
| C. Keep one action set and track the keyboard's contribution inside the overlay | Rejected: it re-implements Godot's input system, cannot observe the true keyboard/gamepad state, and still cannot express additive contribution. |
| D. Raise the ownership tolerance or compare a timestamp | Rejected: it hides the collision instead of removing it; the failure would reappear at other strengths. |

### 2.4 Files that would change, if approved

| File | Change |
|---|---|
| `project.godot` | add 4 `touch_move_*` actions (+ optionally `touch_interact`) |
| `scripts/touch_controls.gd` | write to `touch_move_*`; **delete** `_owned_actions` / `_release_owned_action` / the strength comparison; `touch_interact` for the button |
| `scripts/player_controller.gd` | add `_compose_movement_intent()`; use it in `_physics_process`; accept `touch_interact` |
| `tests/xh003_same_action_composition_test.gd` | **new** — the acceptance test above, adapted to the new namespaces |
| `tests/touch_controls_coexistence_test.gd` | extend to the same-action case with a real key event (it currently uses a synthetic press and a different action) |
| `tests/touch_controls_composition_test.gd` | adapt the action names it asserts on |
| `docs/implementation/BTV_XH-003_*.md` | new implementation note (AGENTS.md requires one per meaningful system) |

No changes to: canon, scenes, export configuration, application identifier, workflow permissions,
repository permissions, credentials.

---

## 3. Authoritative test inventory

### 3.1 The 13 published suites — executed independently on `34c5af7`

| # | Suite | Origin | Assertions executed | Result | In CI workflow? |
|---|---|---|---|---|---|
| 1 | `nli_smoke_test` | pre-existing (M2) | 50 | PASS | yes |
| 2 | `nli_contract_test` | pre-existing (M2) | 41 | PASS | yes |
| 3 | `mission_data_validator_test` | pre-existing (M2) | 22 | PASS | yes |
| 4 | `core_interaction_acceptance_test` | pre-existing (M2) | 24 | PASS | yes |
| 5 | `player_camera_input_test` | pre-existing (M2) | 15 | PASS | yes |
| 6 | `touch_input_adapter_test` | pre-existing (M2) | 31 | PASS | yes |
| 7 | `touch_controls_integration_test` | pre-existing, **modified** by XH-002 | 17 | PASS | yes |
| 8 | `touch_controls_lifecycle_test` | **new** (`8553804`) | 5 | PASS | **no** |
| 9 | `touch_controls_composition_test` | **new** (`8553804`) | 13 | PASS | **no** |
| 10 | `touch_controls_coexistence_test` | **new** (`8553804`) | 8 | PASS | **no** |
| 11 | `touch_controls_resize_test` | **new** (`8553804`) | 10 | PASS | **no** |
| 12 | `touch_controls_input_path_test` | **new** (`8553804`) | 6 | PASS | **no** |
| 13 | `touch_controls_reconciliation_test` | **new** (`34c5af7`) | 9 | PASS | **no** |
| | **Total** | | **251 assertions** | **13/13 PASS** | 7 of 13 in CI |

Plus the main scene, 10-frame headless launch: **PASS**.

### 3.2 Reconciling "12/12" and "13/13"

Both figures were accurate at the moment they were written. The difference is one commit.

| Figure | Where it appears | Basis | When written |
|---|---|---|---|
| **12/12** | PR #4 body; implementation report `BTV_XH-002_TOUCH_INPUT_HARDENING_2026-11-08.md` | the 7 pre-existing suites + the 5 suites added by the **first** XH-002 commit `8553804` | 20:29–21:50 UTC |
| **13/13** | Issue #3 comment; evidence pack `README.md`; `BTV_GITHUB_MCP_VERIFICATION_2026-11-08.md` | the same 12 **plus** `touch_controls_reconciliation_test.gd`, added by the **second** commit `34c5af7` | 21:54–22:11 UTC |

Sequence: commit `8553804` (20:29) → PR #4 opened (21:50, body says 12/12) → commit `34c5af7` (21:54,
adds the reconciliation suite for the Issue #3 HIGH-1/MEDIUM-2 request) → Issue #3 comment posted (22:11,
says 13/13).

**13/13 is current. The PR body and the implementation report are stale** — both still say 12/12 because
neither was refreshed after `34c5af7`. The same documents also understate the assertion totals
(they state 37 for the five new suites; the executed count is 42, and 51 across all six).

**Authoritative figure: 13 suites, 251 assertions, 13/13 PASS, 0 CI runs on this branch.**

### 3.3 Exact commands

```bash
# from a clean checkout of btv/agent-minimax-xh-002
godot --headless --editor --path . --quit                 # import + parse check

for suite in nli_smoke_test nli_contract_test mission_data_validator_test \
              core_interaction_acceptance_test player_camera_input_test \
              touch_input_adapter_test touch_controls_integration_test \
              touch_controls_lifecycle_test touch_controls_composition_test \
              touch_controls_coexistence_test touch_controls_resize_test \
              touch_controls_input_path_test touch_controls_reconciliation_test; do
  godot --headless --path . --script "res://tests/${suite}.gd" || echo "FAIL ${suite}"
done

godot --headless --path . --quit-after 10                # main scene, 10 frames
```

Engine used: `/workspace/.tools/godot` = `4.7.2.stable.official.ed1daf0bf`.

---

## 4. CI correction proposal — precise changes, not applied

### 4.1 The gap

`.github/workflows/godot-validation.yml` **exists on `btv/agent-minimax-xh-002`** (inherited from the base
branch) but:
- `on.push.branches` lists only `btv/bootstrap-prototype-001`, `btv/test-first-contracts-001`,
  `btv/camera-relative-mouselook-001`, `btv/mobile-touch-input-adapter-001` → **the XH-002 branch never
  triggers it**;
- it runs **7** suites; the **6** XH-002 suites are absent;
- therefore the branch has **0 CI runs** and **0 independently-runner-verified** test results.

### 4.2 Option 0 — zero workflow changes (recommended first step)

The workflow already declares `on: workflow_dispatch:`. Dispatching the existing workflow on the branch
needs **no file edit at all**:

```
POST /repos/KINGACEX/beyond-the-veil-last-watch-/actions/workflows/godot-validation.yml/dispatches
{"ref": "btv/agent-minimax-xh-002"}
```

That runs the 7 existing suites on the branch and produces CI evidence in minutes. It requires a token
with `actions:write` and **your approval** (it is a write action). It would **not** run the 6 new suites.

### 4.3 Option 1 — the workflow edit (precise diff)

Preserve every existing step, `permissions:` block (`contents: read`) and trigger. Two edits only:

```diff
--- a/.github/workflows/godot-validation.yml
+++ b/.github/workflows/godot-validation.yml
@@ -7,6 +7,7 @@ on:
       - btv/test-first-contracts-001
       - btv/camera-relative-mouselook-001
       - btv/mobile-touch-input-adapter-001
+      - btv/agent-minimax-xh-002
   workflow_dispatch:
 
   permissions:
@@ -59,5 +60,35 @@ jobs:
       - name: Run touch controls integration tests
         run: godot --headless --path . --script res://tests/touch_controls_integration_test.gd
 
+      - name: Run touch controls lifecycle tests
+        run: godot --headless --path . --script res://tests/touch_controls_lifecycle_test.gd
+
+      - name: Run touch controls composition tests
+        run: godot --headless --path . --script res://tests/touch_controls_composition_test.gd
+
+      - name: Run touch controls coexistence tests
+        run: godot --headless --path . --script res://tests/touch_controls_coexistence_test.gd
+
+      - name: Run touch controls resize tests
+        run: godot --headless --path . --script res://tests/touch_controls_resize_test.gd
+
+      - name: Run touch controls input path tests
+        run: godot --headless --path . --script res://tests/touch_controls_input_path_test.gd
+
+      - name: Run touch controls reconciliation tests
+        run: godot --headless --path . --script res://tests/touch_controls_reconciliation_test.gd
+
       - name: Launch main scene for 10 frames
         run: godot --headless --path . --quit-after 10
```

Six suite steps — the sixth (`reconciliation`) was missing from the earlier patch that was never applied.
Nothing else changes: no new permissions, no new credentials, no new triggers beyond the one branch,
every pre-existing step preserved verbatim.

**How to apply:** the token in use cannot write to `.github/workflows/` (GitHub refuses PAT writes to
workflow paths without the `workflow` scope). Apply it either (a) with a token that has the `workflow`
scope, or (b) by pasting the diff in the GitHub web editor — creator-only, browser action.

### 4.4 CI results

**None for this branch.** `btv/agent-minimax-xh-002` → **0 runs**; `btv/agent-minimax-xh-002-evidence` →
0 runs. The last CI evidence in the repository is *"BTV Godot Validation #253, completed/success,
sha 3484672, branch btv/mobile-touch-input-adapter-001"* — i.e. the **base** branch, not XH-002.

---

## 5. New acceptance tests (proposed, drafted, not committed)

| File | Status | Purpose |
|---|---|---|
| `tests/xh003_same_action_composition_test.gd` | **drafted in scratch copy** — 12 assertions, currently **4 failing** against the unfixed branch | the task's sequence (Order A) plus the reverse order (Order B), using a real `InputEventKey` |
| `tests/xh003_interact_probe.gd` | diagnostic, scratch only | proves the same defect reaches the shared `interact` action |
| `tests/xh003_diagnostic.gd` | diagnostic, scratch only | the deflection → owned-strength → outcome table in §1.2 |

The acceptance test is written in the repository's existing style (`extends SceneTree`, `_check()` helper,
`PASS:`/`FAIL:` lines, exit code 1 on failure) so it can be committed unchanged once the architecture
lands — at which point the two `A4`/`B4` assertions should pass.

---

## 6. Remaining Android limitations

These are **unchanged** by XH-003 and still block Android readiness:

1. **No safe-area insets** (XH-001 HIGH-2) — `grep` for safe-area/notch across the branch returns nothing;
   the HUD is laid out in fixed pixels.
2. **Resolution-dependent look sensitivity** (XH-001 HIGH-3) — `look_sensitivity_degrees_per_pixel = 0.12`,
   i.e. per screen pixel, so the same swipe turns the camera differently at different resolutions.
3. **No Android export pipeline** — no `export_presets.cfg`, no application identifier, no signing, and CI
   installs no export templates (`include-templates: false`).
4. **No physical-device or emulator evidence** — every result in this document is headless and synthetic.
   Multitouch, latency, thumb reach, orientation change, frame pacing and thermal behaviour are unverified.
5. **No CI evidence for XH-002/XH-003** — 0 runs on the branch (§4.4).
6. **`.uid` files untracked** — 26 scripts, 0 `.uid` files committed; `.gitignore` does not exclude them, so
   every checkout is a dirty tree.
7. **Gamepad is hypothetical** — no binding exists anywhere in the project; the proposal's `gamepad_move_*`
   term is deliberately not included.

---

## 7. Requested decisions

1. **Approve the architecture in §2 (Option A) for implementation?** It changes `project.godot`,
   `scripts/touch_controls.gd` and `scripts/player_controller.gd`, and adds the acceptance test.
2. **Approve the `interact` treatment (e in §2.2)?** Without it the shared-action defect survives on the
   Interact button.
3. **Approve the CI path** — Option 0 (dispatch, no file edit) or Option 1 (workflow edit, needs `workflow`
   scope or your web-editor paste)?
4. **Confirm scope boundary** — XH-003 stays out of HIGH-2/HIGH-3 (visual brief required), the Android
   export pipeline, and any gamepad binding.

---

*Reproduction and proposal only. No implementation, no repository change, no merge, no workflow edit, no
credential or permission change. The credential value does not appear in this document.*
