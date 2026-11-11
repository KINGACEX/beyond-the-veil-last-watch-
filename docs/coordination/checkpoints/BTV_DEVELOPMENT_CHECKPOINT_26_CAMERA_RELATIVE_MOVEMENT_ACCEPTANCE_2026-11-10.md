# BTV Development Checkpoint 26 — Camera-Relative Scene Movement

Date: 2026-11-10  
Branch: `btv/controls-hardening-prototype-layout-plan-001`  
Implementation commit: `18c92e403a1eb6ab7c296bccb976799c42407bb0`  
Validation workflow: [GitHub Actions run #42816472052](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42816472052)

## Status

**COMPLETED — CI PASS (47/47 steps).**

The playable exploration acceptance suite now checks actual player displacement after rotating the camera, in addition to the existing unit-level camera-direction tests.

## Change

File: `tests/exploration_prototype_test.gd`

Added a deterministic physics acceptance case that:

1. Records the player's starting position in the open clearing.
2. Rotates the camera heading by 90 degrees through the same public look-input path used by desktop and touch.
3. Holds forward movement for 45 physics frames and then releases it.
4. Waits for braking and measures world-space displacement.
5. Verifies the player moved along the camera-relative axis (world negative X), with negligible world-Z drift, and remained grounded.
6. Restores the camera heading and player start position before the existing movement/jump test continues.

## Validation

- GitHub Actions workflow: `BTV Godot Validation`
- Run: `42816472052`
- Implementation SHA: `18c92e403a1eb6ab7c296bccb976799c42407bb0`
- Result: **47/47 steps successful; zero failed steps.**
- The same run also passed the real sensor-overlap acceptance test introduced in Checkpoint 25.

## Scope and limitations

- This is repeatable headless physics acceptance, not a visual or physical Android-device test.
- It validates camera-relative movement direction and grounded displacement in the current clearing; it does not approve final movement feel, camera tuning, traversal abilities, or device performance.
- No canon, character abilities, currencies, progression, combat, or wildlife behaviour were changed.
- No merge to the default branch, release, paid service, or public announcement was performed.

## Next engineering priorities

1. Add collision-edge and obstacle-navigation acceptance with controlled route fixtures and measurable stopping/deflection outcomes.
2. Audit the playable greybox's collision and visual geometry for accidental gaps, inaccessible landmarks and ambiguous navigation.
3. Begin a small, reversible lighting/weather presentation experiment after navigation acceptance is stable.
4. Reserve Android export, touch usability, sustained frame pacing, memory and thermal validation for real-device QA.
