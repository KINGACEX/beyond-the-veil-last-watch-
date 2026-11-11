# BTV Development Checkpoint 11 — First Traversal Code

**Date:** 2026-11-10  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Checkpoint commit:** `2367ea3551ae154a2d72fbc942b7834f65d1bf76`  
**CI:** [Run #42777872484 — PASS](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42777872484)

## Status

**COMPLETED:** first traversal gameplay code is now present in the Godot project.  
**PASS:** Godot 4.7.2 import, existing regression suites, new jump tests, and neutral lab scene launch.  
**NOT CERTIFIED:** human game feel, physical Android ergonomics/performance, or final story/canon suitability of double jump.

## Implemented

- Ground jump with configurable `jump_velocity`.
- One bounded mid-air jump by default (`max_jumps = 2`).
- Keyboard Space action.
- Dedicated Android touch Jump button, routed through the isolated `touch_jump` action.
- Combined keyboard/touch press-latch handling to avoid duplicate jump edges.
- Automated regression test verifies grounded take-off, second mid-air impulse, and rejection of a third jump.

## Files changed

- `scripts/player_controller.gd`
- `project.godot`
- `scenes/touch_controls.tscn`
- `scripts/touch_controls.gd`
- `tests/traversal_jump_test.gd` (new)
- `.github/workflows/godot-validation.yml`

## Verification

The first run (`42777743636`) correctly exposed two failing assertions in the new jump test. The combined jump input was changed to a press-latched model, matching the controller's established multi-source interaction approach.

The corrected run `42777872484` completed successfully. The traversal jump test passed:
- player begins grounded;
- grounded input produces upward velocity;
- one mid-air input produces a second upward impulse;
- additional mid-air input cannot trigger a third jump.

The existing movement motion, collision, touch input, interaction, camera and scene-launch checks also passed in the same workflow.

## Next engineering sequence

1. Add a dedicated traversal test course with measured low/high platforms and tagged climbable test surfaces.
2. Prototype a short, traversal-only dash with collision-safe stopping.
3. Implement explicit climbable-surface detection and controlled wall-climb states.
4. Implement ledge detection, clearance validation and mantle transitions.
5. Add vaulting and wall-jump only after the preceding traversal states are stable.
6. Add pairwise transition, interruption, ceiling, corner, camera and touch-cancellation tests.
7. Keep all new abilities in the neutral lab until automated and human feel gates pass.

## Boundaries

- No combat or weapon systems are included in this workstream.
- Double jump is a physics prototype; it is not yet canon-approved as a permanent Asher ability.
- No Ridgeview integration until traversal and movement acceptance.
- No Android-ready claim until export and physical-device QA.
- No merge, release, paid service or public announcement is authorised by this checkpoint.
