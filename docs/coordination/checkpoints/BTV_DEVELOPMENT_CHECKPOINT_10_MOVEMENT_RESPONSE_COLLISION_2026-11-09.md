# BTV Development Checkpoint 10 — Movement Response and Collision Baseline

**Date:** 2026-11-09  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Checkpoint type:** Neutral lab tuning / movement and collision verification  
**Status:** Initial response and collision probes pass; Gate C remains open

## 1. Movement response implementation

The player controller now uses a horizontal target-velocity approach with `Vector3.move_toward` rather than instantly assigning full horizontal velocity.

Initial candidate parameters:
- Maximum horizontal speed: 4.0 m/s (existing controller setting).
- Ground acceleration: 16.0 m/s².
- Ground braking: 22.0 m/s².

These are **initial tuning hypotheses**, not final approved feel values. They imply approximately 0.25 seconds to reach full speed and 0.18 seconds to brake from full speed in a straight line under the simplified test model.

The lab telemetry now exposes the acceleration and braking values.

## 2. Automated response tests

New test:
- `tests/movement_physics_lab_motion_test.gd`

It verifies:
- Acceleration is progressive, not an instant jump to full speed.
- Sustained input reaches the configured speed cap.
- Releasing input produces a measurable braking phase.
- Braking returns horizontal velocity to zero without persistent drift.
- Diagonal movement does not exceed the configured speed cap.

## 3. Collision and terrain probes

New test:
- `tests/movement_physics_lab_collision_test.gd`

Verified:
- The front wall blocks the player and reports wall contact.
- The 1.4 m doorway can be traversed without lateral displacement.
- The narrow parallel-wall corridor can be traversed without lateral displacement.
- The gentle and steeper ramps maintain floor contact while the player gains height.
- The high step blocks traversal without an unapproved vertical snap.
- SpringArm3D camera arm retracts from 5.00 m in open space to 3.44 m at the dedicated obstruction station, then retains a nonzero clearance.

Measured headless diagnostics:
- Corridor traversal ended at approximately `(8.05, 0.0, 2.47)` with forward velocity `(0, 0, -4)`.
- Gentle-ramp traversal ended at approximately `(-15.0, 0.61, -7.93)`, remained grounded, and retained forward velocity `(0, 0, -4)`.

The corridor and ramp test initially failed. The test duration was too short for the corridor distance, and the ramp entry surface was too high above the ground. Both issues were corrected; the assertions were retained.

## 4. CI evidence

**PASS:** 19-suite Godot 4.7.2 validation, including the motion suite, extended collision probes, and a 10-frame main-scene launch.

- Tested commit: `c49e0af37bc82f3864575b28f82e1358066ae441`
- Run: [#42666739053](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42666739053)

The pass proves the automated headless tests and lab scene launch. It does not prove physical Android performance, touch ergonomics, safe-area behaviour or final human-perceived movement quality.

## 5. Gate status

| Gate | Status | Evidence / remaining work |
|---|---|---|
| A — automated input correctness | **PASS (automated scope)** | 19-suite pipeline |
| B — preliminary viewport geometry | **PASS (automated scope only)** | Five viewports; physical safe areas and thumb reach remain open |
| C — game feel and physics | **IN PROGRESS** | Progressive acceleration/braking, wall, doorway, corridor and gentle-ramp probes pass; turning, stop distance, steep ramps, steps, camera obstruction and broader collision cases remain |
| D — physical Android | **BLOCKED** | Target phone and exported-device validation not yet established |

Ridgeview remains blocked until Gate C passes. The visual-production phase has not started.

## 6. Next work

1. Measure turning response and stop distance using repeatable routes.
2. Test the steeper ramp and all step heights; record actual floor state and collision response.
3. Validate camera obstruction and pitch/sensitivity behaviour around the lab obstacles.
4. Compare candidate acceleration/braking profiles only through measured tests; do not tune by intuition alone.
5. Continue to preserve the existing greybox-only visual state.
6. Identify the target Android device before physical input, safe-area and performance claims.
7. Begin Ridgeview blockout only after Gate C has a recorded pass.

## 7. Change-control record

No merge, release, signing setup, package-ID decision, paid service, public announcement, or destructive action was performed. The branch remains isolated. PR #6 remains draft and unmerged.
