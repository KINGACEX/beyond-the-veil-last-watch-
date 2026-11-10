# BTV Development Checkpoint 12 — Traversal Dash and Detection Research

**Date:** 2026-11-10  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Code commit:** `e67c991e3e9438211ef26013a1e4ae78561dc4f8`  
**CI:** [Godot 4.7.2 run #42779166032 — PASS](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42779166032)

## 1. Completed implementation

A traversal-only dash prototype has been added to the existing player controller.

- Configurable dash speed, duration and cooldown.
- Direction comes from current camera-relative movement input; with no directional input, the character dashes forward relative to the camera.
- Horizontal dash movement is applied through the existing CharacterBody3D physics path.
- Wall contact cancels the remaining dash and clears horizontal dash velocity.
- Dash completion clears horizontal dash velocity to avoid unintended post-burst coasting.
- Dash is traversal-only: no damage, attack, stun, enemy targeting or combat effect.
- Keyboard Shift and a separate touch action trigger the same latched input path.
- Added a dedicated Android Dash button.
- The look gesture region now excludes the Jump, Dash and Interact button hit areas, preventing action-button taps from also becoming camera-look touches.

## 2. Automated verification

Workflow #42779166032 passed on the code commit listed above.

Successful steps include:
- Godot 4.7.2 install/version check and project import/editor parsing.
- Existing NLI, mission, interaction, camera, touch-input and movement regression suites.
- Existing movement collision and neutral-lab launch checks.
- Existing grounded jump and bounded double-jump tests.
- New traversal dash tests.

New dash test assertions:
1. Fresh dash input produces measurable displacement.
2. Dash remains active during its configured burst window.
3. Horizontal dash velocity is cleared when the burst ends.
4. Front-wall collision prevents passing through the barrier.
5. Wall contact cancels the remaining dash.

CI evidence is automated/headless only. No physical Android playtest or final feel approval is implied.

## 3. Research findings and implementation direction

### Character movement
Keep `CharacterBody3D` in grounded motion mode as the single authoritative player body. Use `move_and_slide()` in `_physics_process()`; retain floor/wall/ceiling classification and use the collision information returned by the physics step. Do not move the player by writing its transform to bypass collision.

Official reference: https://docs.godotengine.org/en/4.7/classes/class_characterbody3d.html

### Climbable-surface identification
Use explicitly authored climbable surfaces, preferably through a dedicated physics layer and/or a `btv_climbable` group. A wall is not climbable merely because it is vertical. The first prototype should have a clear entry condition: wall probe hits a tagged surface, surface normal is sufficiently vertical, player is close enough, and climb input is active.

### Ledge detection and mantle
Use a small set of purposeful physics queries:
1. A lower forward ray confirms the wall face.
2. An upper forward ray checks that the character's head/upper capsule region is not blocked at the candidate ledge.
3. A downward ray beyond the wall identifies the top surface and its height/normal.
4. A capsule-sized overlap/shape query validates the proposed standing destination.
5. Only after all checks pass should the mantle state begin.

Prefer cheap ray queries for candidate discovery. Run a capsule/shape clearance query only after a plausible ledge is found. This avoids running expensive shape queries continuously. Use collision masks, exclude the player RID, and reject surfaces outside the authored climbable set.

Relevant official references:
- RayCast3D: https://docs.godotengine.org/en/4.7/classes/class_raycast3d.html
- ShapeCast3D: https://docs.godotengine.org/en/4.7/classes/class_shapecast3d.html
- PhysicsDirectSpaceState3D: https://docs.godotengine.org/en/4.7/classes/class_physicsdirectspacestate3d.html
- PhysicsShapeQueryParameters3D: https://docs.godotengine.org/en/4.7/classes/class_physicsshapequeryparameters3d.html

### Mobile input
Continue using named InputMap actions and independent touch actions. The touch overlay must retain finger ownership, cancellation on pause/focus loss, and exclusive action-button hit regions. Add tests specifically proving that tapping Jump/Dash does not initiate camera-look tracking.

Official references:
- Godot 4.7 input examples: https://docs.godotengine.org/en/4.7/tutorials/inputs/input_examples.html
- Godot 4.7 InputEventScreenTouch: https://docs.godotengine.org/en/4.7/classes/class_inputeventscreentouch.html

## 4. Recommended architecture before wall mechanics

Do not keep adding independent booleans for every new ability. Introduce a small explicit traversal state model before implementing wall climb and mantle:

- GROUNDED
- AIRBORNE
- DASHING
- WALL_CLIMBING
- LEDGE_HANGING
- MANTLING

Transitions must be explicit, with one state owning vertical and horizontal movement at a time. Define interruption/exit rules for jump, drop, wall loss, ceiling obstruction, landing, pause/resume and invalid destination. The state model should not override the established input adapter or camera ownership.

## 5. Next work

1. Add a traversal-specific neutral test course with measured platforms, tagged climbable wall surfaces, overhangs, ledges and landing clearance zones.
2. Add touch-look exclusion regression checks for Jump and Dash hit regions.
3. Refactor movement into explicit states while preserving all passing controller/input tests.
4. Implement wall-climb detection only for tagged surfaces.
5. Implement ledge candidate discovery and destination clearance checks.
6. Add mantle as a short, collision-checked state transition.
7. Test corners, overhangs, low ceilings, wall termination, narrow platforms, interrupted inputs, camera obstruction and Android touch cancellation.
8. Re-run the full Godot 4.7.2 workflow after each meaningful change.

## 6. Boundaries and gates

- No combat or weapon systems are part of traversal development.
- Double jump and dash remain physics prototypes until their final gameplay/canon fit is reviewed.
- Wall climb and mantle remain neutral-lab experiments until automated collision and transition tests pass.
- Ridgeview blockout remains held until Gate C is formally accepted.
- Android readiness remains blocked pending export and physical-device QA.
- No merge, release, paid service or public announcement is authorised by this checkpoint.
