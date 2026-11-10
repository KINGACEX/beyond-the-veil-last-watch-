# BTV Development Checkpoint 10 — Movement Response and Collision Baseline

**Date:** 2026-11-09  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Checkpoint type:** Neutral lab tuning / movement and collision verification  
**Status:** Latest automated turn/braking and collision suite passes; Gate C remains open for broader feel review

## 1. Movement response implementation

The player controller now uses a horizontal target-velocity approach with `Vector3.move_toward` rather than instantly assigning full horizontal velocity.

Initial candidate parameters:
- Maximum horizontal speed: 4.0 m/s (existing controller setting).
- Ground acceleration: 16.0 m/s².
- Ground braking: 22.0 m/s².

These are **initial tuning hypotheses**, not final approved feel values. They imply approximately 0.25 seconds to reach full speed and 0.18 seconds to brake from full speed in a straight-line simplified test model.

The lab telemetry exposes the acceleration and braking values.

## 2. Automated response tests

Test:
- `tests/movement_physics_lab_motion_test.gd`

Verified by the latest passing CI run:
- Acceleration is progressive, not an instant jump to full speed.
- Sustained input reaches the configured speed cap.
- Releasing input produces a measurable braking phase.
- Braking returns horizontal velocity to zero without persistent drift.
- Diagonal movement does not exceed the configured speed cap.
- Character turning responds progressively rather than snapping instantly.
- Turning converges toward the requested heading.
- Braking stop distance remains within the test's 0.25–0.42 m acceptance envelope.

These are automated candidate-profile checks, not a declaration that the profile is final or universally comfortable.

## 3. Collision and terrain probes

Test:
- `tests/movement_physics_lab_collision_test.gd`

Verified:
- The front wall blocks the player and reports wall contact.
- The 1.4 m doorway can be traversed without lateral displacement.
- The narrow parallel-wall corridor can be traversed without lateral displacement.
- The gentle and steeper ramps maintain floor contact while the player gains height.
- The high step blocks traversal without an unapproved vertical snap.
- SpringArm3D camera arm retracts from 5.00 m in open space to 3.44 m at the dedicated obstruction station, then retains nonzero clearance.

Measured headless camera diagnostics:
- Open space: 5.00 m.
- Obstructed station: 3.44 m.

The corridor and ramp tests initially failed. The corridor test duration was too short for the intended distance, and the ramp entry surface was too high above the ground. Both defects were corrected while retaining the assertions.

## 4. CI evidence

**PASS:** Latest Godot 4.7.2 workflow completed all 25 steps successfully, including project import/parsing, existing input and touch-control suites, neutral-lab acceptance, motion tests, collision tests, and a 10-frame launch of the neutral movement/physics lab.

- Tested commit: `8104273bf53acb7e80d0d7cedef96ad43efb9335`
- Run: [#42667216009](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42667216009)
- The earlier run [#42666930745](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42666930745) was cancelled and is not treated as a failed validation.

The successful run proves the automated headless checks and lab scene launch on the recorded commit. It does not prove physical Android performance, touch ergonomics, safe-area behaviour, visual camera quality, or final human-perceived movement quality.

## 5. Gate status

| Gate | Status | Evidence / remaining work |
|---|---|---|
| A — automated input correctness | **PASS (automated scope)** | Latest 25-step pipeline |
| B — preliminary viewport geometry | **PASS (automated scope only)** | Automated viewport checks; physical safe areas and thumb reach remain open |
| C — game feel and physics | **IN PROGRESS** | Candidate acceleration, braking, turning, stop-distance, wall, doorway, corridor, ramp, high-step and camera-obstruction checks pass; human feel review and broader edge cases remain |
| D — physical Android | **BLOCKED** | Exact target device, export preset and physical-device validation not established |

Ridgeview remains held until Gate C is formally accepted. The visual-production phase has not started.

## 6. Next work

1. Review the movement profile against a wider set of repeatable routes and frame-step conditions.
2. Add and inspect cornering, diagonal-to-stop, slope transition, step/ledge and camera-pitch edge cases where they expose meaningful gaps.
3. Audit touch sensitivity and camera smoothing without assuming headless tests can certify ergonomics.
4. Preserve assertions when fixing defects; do not weaken tests to obtain a pass.
5. Keep the neutral lab greybox until Gate C is accepted.
6. Identify the exact Android target device and establish a reviewed export preset before physical input, safe-area and performance claims.
7. Begin Ridgeview blockout only after Gate C has a recorded acceptance decision.

## 7. Change-control record

No merge, release, signing setup, package-ID decision, paid service, public announcement, or destructive action was performed. The branch remains isolated. PR #6 remains draft and unmerged.


## 8. Regression extension — direction reversal and diagonal braking

A source review identified two untested transitions in the candidate movement profile. The motion suite now additionally checks:
- Direction reversal while moving: existing momentum decreases progressively rather than snapping immediately; sustained reverse input reaches the same configured speed cap.
- Diagonal release: both horizontal velocity components return to zero, and total stop distance remains within a bounded test envelope.

**PASS:** Godot 4.7.2 CI run [#42712465318](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42712465318), tested commit `f27f85b165c9a25b6c9fbcf480f1aab684fece2a`. All workflow steps succeeded, including project import, 19 contract/regression suites, the expanded motion suite, collision probes and 10-frame neutral-lab launch.

This extends automated response coverage only. It does not establish final human-perceived feel, physical Android ergonomics or device performance. Gate C remains open for review and broader testing; Gate D remains blocked pending device/export validation.


## Follow-up evidence — 2026-11-10

- Added a diagonal corner-wall sliding regression to `tests/movement_physics_lab_collision_test.gd`.
- The probe approaches the neutral L-shaped wall corner diagonally and checks that the player does not penetrate the front wall, slides along the wall within the adjoining corner bounds, and reports wall contact.
- Godot 4.7.2 CI run [#42776065025](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42776065025) passed, including the expanded motion suite, collision suite, and 10-frame neutral-lab launch.
- This remains automated headless evidence. It does not certify visual camera quality, subjective control feel, or Android device performance. Gate C remains open for human feel review and remaining edge-case assessment; Gate D remains blocked pending Android export/device QA.
