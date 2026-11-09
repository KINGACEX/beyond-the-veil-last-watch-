# BTV XH-003 — Independent Input-Source Composition

**Status:** IMPLEMENTED — GODOT 4.7.2 HEADLESS VERIFIED — ANDROID QA PENDING, NOT MERGED  
**Date:** 2026-11-09  
**Branch:** `btv/xh-003-input-source-composition-spec-001`  
**Base:** `btv/agent-minimax-xh-002` at `34c5af7089efa83a151fbaa79e44a070d1bf21c5`  
**Purpose:** Remove the remaining shared-InputMap-action conflict between keyboard and touchscreen input.

## Source and safety boundary

This branch starts from the exact public GitHub XH-002 head SHA above. It is an isolated GitHub proposal branch; it does not establish that this branch is the creator's canonical working copy and does not inspect, reset, or modify MiniMax's private `/workspace/btv`. Before implementation is transferred to another workspace, compare that workspace's HEAD, status, remotes, and uncommitted changes. Preserve any divergent or uncommitted work.

This specification preceded implementation. The approved implementation is on the isolated XH-003 branch. The existing Godot validation workflow was updated only to include this branch and its expanded test inventory. No credential, permission, export, signing, package identifier, merge, or release action was performed.

## Confirmed defect in the base

- `scripts/touch_controls.gd` binds the touch buttons to the keyboard-facing actions `move_forward`, `move_back`, `move_left`, `move_right`, and `interact`.
- The analog joystick calls `Input.action_press/release` on those same movement actions.
- `scripts/player_controller.gd` obtains movement from one `Input.get_vector("move_left", "move_right", "move_forward", "move_back")` call.
- Godot exposes one action state per action name. Two independent input sources writing the same action do not provide a reliable additive composition contract. XH-002's ownership-strength heuristic helps prevent some cleanup from releasing another source's action, but it does not merge simultaneous input sources.

## Implemented change (headless verified; device QA pending)

### 1. Give touchscreen controls their own actions

Add these entries under `[input]` in `project.godot`, with no physical input events:

- `touch_move_forward`
- `touch_move_back`
- `touch_move_left`
- `touch_move_right`
- `touch_interact`

Use a zero InputMap deadzone for the touch actions because the touch adapter already owns analog deadzone/rescaling. Keep existing keyboard actions and their physical bindings unchanged.

### 2. Migrate every touch writer

In `scripts/touch_controls.gd`:

- Bind the four touch buttons to the corresponding `touch_move_*` actions.
- Bind the touch Interact button to `touch_interact`.
- Make the joystick write only `touch_move_*` actions.
- Ensure focus loss, Android pause, finger release, and `_exit_tree()` clean up only the touch namespace.
- Remove the old shared-action ownership heuristic only after confirming there are no remaining touch writes to keyboard actions.
- Do not change the HUD layout, camera sensitivity, visual assets, or gamepad support in this task.

### 3. Compose once in the player

Replace the single movement read with a small, testable composition method:

```gdscript
func _get_composed_movement_input() -> Vector2:
    var keyboard := Input.get_vector(
        "move_left", "move_right",
        "move_forward", "move_back"
    )
    var touchscreen := Input.get_vector(
        "touch_move_left", "touch_move_right",
        "touch_move_forward", "touch_move_back"
    )
    return (keyboard + touchscreen).limit_length(1.0)
```

The physics loop should consume this composed vector once. Keep camera-relative movement and diagonal speed limiting unchanged.

Interact treats keyboard `interact` and touch `touch_interact` as one logical control. A combined-input latch ensures a second source joining an already-held press does not create another interaction edge. The latch resets only after both sources are released.

## Required regression tests

Add a dedicated headless composition/coexistence suite. Tests must use the real player composition path, not only inspect action strengths.

| Case | Required result |
|---|---|
| Keyboard only | Existing movement is unchanged |
| Touch only | Touch movement works through the player |
| Keyboard + touch, same direction | Contributions combine, capped at unit magnitude |
| Keyboard + touch, different directions | Resulting vector is the normalized/capped sum |
| Keyboard released first | Touch movement continues |
| Touch released first | Keyboard movement continues |
| Both released | Movement returns to zero |
| Touch pause/focus cleanup | Touch state clears; keyboard state remains |
| Touch overlay teardown | Touch state clears; keyboard state remains |
| Keyboard Interact | One interaction press |
| Touch Interact | One interaction press |
| Both Interact sources | No duplicate interaction in one physics/input edge |
| Second source joins while first remains held | No second interaction edge |
| Both sources released, then pressed again | A fresh interaction edge is accepted |
| Player respawn/replacement | Touch controls resolve the new player for look; movement composition remains functional |

Also retain and run all existing suites. Add explicit assertions for both release orders; testing only one release order is insufficient.

## Verification protocol

The automated verification completed on the current implementation:

1. Parse/import check: `godot --headless --editor --path . --quit`.
2. All 14 test suites, individually, with successful job exit statuses.
3. Main-scene launch: `godot --headless --path . --quit-after 10`.

**Recorded result:** GitHub Actions run [#42653466596](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42653466596) on commit `2ab0b87fcf4791905d2c338fdc459547fd6bc6ec` used Godot `4.7.2.stable.official.ed1daf0bf`; project import, all 14 test suites, and the 10-frame headless main-scene launch passed. This latest run includes the combined Interact latch, its regression coverage, and the updated specification. The workflow includes the XH-003 branch and all 14 suites.

**Still outstanding outside the automated run:**
4. Review `git status --short` after tests and account for generated artifacts.
5. Complete the final diff review against the XH-002 base; confirm there are no unrelated canon, art, narrative, export, or dependency changes.
6. Complete the independent implementation and test-quality review, including the requested 30-point score.

Headless tests do not establish physical Android multitouch, safe-area correctness, thumb reach, latency, orientation behavior, performance, or export readiness. Those remain separate device QA gates.

## Acceptance and governance

- Target: all current suites plus the new regression suite pass on Godot 4.7.2.
- Review every changed line and test; do not award the prior 27/30 rubric score without evidence.
- Keep any resulting PR in draft.
- Do not merge, publish a build, configure signing, choose the Android application ID, or broaden token permissions without separate creator approval. The CI workflow update is limited to the approved XH-003 branch trigger and test-suite additions.
- If the private MiniMax workspace differs from this GitHub base, stop before transfer and reconcile rather than resetting or overwriting either copy.

## Checkpoint outcome

The isolated branch contains the source implementation and regression tests. The XH-003 headless acceptance gate passed on Godot 4.7.2, including the corrected combined Interact edge behaviour. The latest successful run is #42653466596 on commit `2ab0b87fcf4791905d2c338fdc459547fd6bc6ec`. Physical Android QA and reconciliation with the private MiniMax workspace remain outstanding. PR #6 remains draft and unmerged.
