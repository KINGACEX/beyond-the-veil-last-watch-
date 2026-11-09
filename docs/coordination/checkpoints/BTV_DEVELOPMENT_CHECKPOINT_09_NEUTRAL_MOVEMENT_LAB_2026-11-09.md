# BTV Development Checkpoint 09 — Neutral Movement and Physics Laboratory

**Date:** 2026-11-09  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Checkpoint type:** First gameplay construction / controls hardening  
**Status:** Lab constructed and CI-verified; Gate C tuning remains open

## 1. Verified milestone

The first actual gameplay construction is now the neutral movement and physics laboratory. It is the default main scene and remains a functional greybox test environment, not a story location or visual-production milestone.

Files added:
- `scenes/movement_physics_lab.tscn`
- `scripts/movement_physics_lab.gd`
- `tests/movement_physics_lab_acceptance_test.gd`

The lab currently provides:
- Flat movement lane with distance markers.
- Two ramps at different inclinations.
- Three step-height test blocks.
- Isolated wall, corner, doorway and narrow corridor.
- Camera-obstruction test wall.
- Runtime telemetry for horizontal speed, velocity, composed input, grounded state/floor angle and camera pitch.

The lab uses the existing player controller and touch-control overlay. No new supernatural ability, power, prayer mechanic, Scripture resource, faith meter or spiritual progression system was introduced.

## 2. Control correction

Source audit identified a content-scale sensitivity risk in touch camera input. The old path derived look delta from successive viewport positions. Godot 4.7 recommends `InputEventScreenDrag.screen_relative` for touch aiming because it is unscaled across viewport stretch modes.

The branch now:
- Uses `event.screen_relative` for touch camera look.
- Routes the delta through the adapter's look-finger ownership check.
- Updates integration, lifecycle, reconciliation and viewport tests to provide explicit screen-space deltas.
- Adds an adapter regression test for owner-checked screen deltas.

The four movement InputMap actions in `project.godot` were also inspected and confirmed to have a 0.0 deadzone; the custom 0.12 radial deadzone remains in the joystick adapter.

## 3. Validation evidence

**PASS:** Godot 4.7.2 full workflow, all 17 test suites, project import, and 10-frame launch of the neutral movement lab.

- Tested commit: `0aec6a9343a29772782d34d87c0060e13893f1b3`
- Run: [#42665594447](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42665594447)

Earlier failed runs were not hidden:
- Run #42665076671 exposed an integration test still using the old synthetic touch-drag event shape.
- Run #42665200529 exposed lifecycle probes still using the old event shape.
- Run #42665299709 exposed a reconciliation probe still using the old event shape.
- The test fixtures were updated to populate `screen_relative`; the later complete run passed.

The CI pass verifies the automated project tests and headless scene launch. It does not prove physical Android ergonomics, safe areas, GPU performance or satisfying movement feel.

## 4. Gate status

| Gate | Status | Evidence / remaining work |
|---|---|---|
| A — automated input correctness | **PASS (automated scope)** | 17-suite pipeline passed on tested commit |
| B — preliminary viewport geometry | **PASS (automated scope only)** | Five viewport sizes tested; physical safe-area and thumb-reach validation remain open |
| C — movement and game feel | **IN PROGRESS** | Lab exists; acceleration, braking, turning, collision, slope, step and camera measurements not yet accepted |
| D — physical Android validation | **BLOCKED** | Exact target phone and exported device build not yet validated |

Ridgeview blockout remains held until Gate C passes. Android-ready claims remain held until Gate D passes.

## 5. Current engineering observations

- The player currently assigns horizontal velocity directly from the target movement vector. Acceleration and braking curves have not yet been authored.
- The lab is designed to measure that baseline before selecting final values.
- No final acceleration, deceleration, stop-distance, slope, step or camera sensitivity values are approved.
- The renderer remains undecided pending target-device/GPU research and a representative benchmark.
- The existing basic greybox playable scene has not received cinematic visual production.

## 6. Next actions

1. Add repeatable movement/physics baseline tests in the lab.
2. Record current instantaneous acceleration and stop behaviour before changing it.
3. Compare candidate acceleration/deceleration response profiles using fixed test routes.
4. Validate wall/corner/doorway collision, ramps, steps and camera obstruction.
5. Tune one parameter group at a time; keep tests and telemetry.
6. Re-run the complete Godot 4.7.2 workflow after each meaningful change.
7. Do not begin Ridgeview blockout until Gate C has a recorded pass.
8. Identify the target Android phone before renderer and safe-area decisions.

## 7. Change-control record

No merge, release, signing setup, package-ID decision, paid service, public announcement, or destructive action was performed. The branch remains isolated. PR #6 remains draft and unmerged.
