# BTV Development Checkpoint 25 — Real Sensor Overlap Acceptance

Date: 2026-11-10  
Branch: `btv/controls-hardening-prototype-layout-plan-001`  
Implementation commit: `0735905d002661022903a38674df58732a0be1ab`  
Validation workflow: [GitHub Actions run #42816149465](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42816149465)

## Status

**COMPLETED — CI PASS (47/47 steps).**

The exploration acceptance suite now verifies a genuine physics-driven Area3D overlap path in addition to the existing observation-loop tests that directly exercised sensor callbacks.

## Change

File: `tests/exploration_prototype_test.gd`

Added a temporary, isolated `BTVExplorationObservation` acceptance probe with collision layer 2 and a SphereShape3D. The test places it within the player's real InteractionSensor, advances physics frames, and verifies:

1. The player's physics sensor registers the overlapping observation in its nearby-interactable collection.
2. The controller's normal nearest-interactable selection and `_try_interact()` path returns the probe's authored observation text.
3. Removing the probe from the scene clears it from the nearby-interactable collection.

The probe is intentionally not connected to the exploration journal, so the test does not alter the four authored field-note count or save data.

## Validation

- GitHub Actions workflow: `BTV Godot Validation`
- Run: `42816149465`
- Implementation SHA: `0735905d002661022903a38674df58732a0be1ab`
- Result: **47/47 steps successful; zero failed steps.**
- Existing camera-input suite remains green, including camera-yaw-relative direction, independent player-body turning, diagonal normalization and pitch-flattened movement.

## Scope and limitations

- This is headless CI acceptance, not physical Android-device validation.
- It verifies Area3D overlap, registration, selection and exit cleanup; it does not establish final interaction feel, mobile touch usability, or production UI.
- No canon, character abilities, currencies, progression, combat, or wildlife behaviour were changed.
- No merge to the default branch, release, paid service, or public announcement was performed.

## Next engineering priorities

1. Add a scene-level physical movement acceptance test that rotates the camera and verifies the player's actual displacement follows camera heading, not only the direction helper.
2. Add collision-edge and obstacle-navigation acceptance for the playable clearing, with repeatable start positions and measurable outcomes.
3. Profile geometry/material/light budgets using real Android hardware when available; headless CI cannot establish device frame pacing, memory or thermal performance.
4. Integrate one small, reversible lighting/weather presentation experiment only after the navigation baseline is stable.
