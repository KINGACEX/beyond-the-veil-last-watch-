# BTV M1 — Camera-Relative Movement and Desktop Mouse-Look

**Status:** IMPLEMENTED ON ISOLATED FEATURE BRANCH; HEADLESS CI PASS; MANUAL DESKTOP AND ANDROID VERIFICATION PENDING  
**Date:** 8 November 2026  
**Engineering branch:** `btv/camera-relative-mouselook-001`  
**Base:** `btv/test-first-contracts-001` at `023855507523bd1bcf9ece8840fc33ceba61506b`  
**Head commit:** `de2cb1d29f81a011ddb5319e6c32d95ac3418e45`  
**CI:** [GitHub Actions run 42499393434](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42499393434)

## Scope

Implement the M1 camera/input foundation from the cross-platform input brief only. Preserve the existing keyboard movement actions, proximity interaction contract, touch scaffold, NLI and mission systems. Do not add a virtual joystick, mobile camera-look surface, responsive menus or gameplay/story systems.

## Changes

- `scripts/player_controller.gd`
  - Movement direction now derives from the active camera pivot's horizontal forward/right basis.
  - Ground movement is flattened to the horizontal plane and normalized, preventing a diagonal speed advantage.
  - Camera pitch does not introduce vertical movement.
  - Desktop mouse-look updates yaw and pitch; pitch is clamped to the exported `min_pitch_degrees` and `max_pitch_degrees` values.
  - Left-click requests mouse capture; Escape releases it; application focus loss returns the pointer to visible mode.
  - Camera yaw is tracked independently from the player body's smoothed facing rotation. This is necessary because the existing camera pivot is a child of the player; without compensation, rotating the player would rotate the camera heading and distort camera-relative movement.
- `tests/player_camera_input_test.gd`
  - Adds tests for default and rotated camera-forward movement, camera-heading independence from player-body rotation, diagonal normalization, pitch flattening, zero input, mouse-look yaw/pitch, and pitch limits.
  - Desktop pointer-capture/focus tests are intentionally skipped under the headless display server; they require a real desktop window.
- `.github/workflows/godot-validation.yml`
  - Adds this feature branch to push validation.
  - Adds the camera input test script to the Godot CI sequence.

## Verification

**CONFIRMED — run 42499393434, Godot 4.7.2:**
- Headless editor import/project parsing passed.
- NLI smoke tests passed.
- NLI handoff/source-registry contract tests passed.
- Mission data validator tests passed.
- Core interaction acceptance tests passed.
- Player camera input tests passed.
- 10-frame headless main-scene launch passed.

The camera input log explicitly reports `PLAYER_CAMERA_INPUT_TESTS: PASS`. It also reports that desktop pointer capture/focus tests were skipped because the runner has no desktop window.

A preceding attempt, run [42499333486](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42499333486), failed only in those OS pointer-capture assertions: a headless runner cannot establish a real captured desktop pointer. The test was corrected to skip those OS-dependent assertions in headless CI; no product code was changed to hide a gameplay test failure.

## Not verified / remaining work

- Actual desktop mouse capture, cursor visibility, Escape release and focus-loss behaviour in a windowed Godot runtime.
- Manual camera feel, sensitivity suitability and movement feel.
- Android export/install and physical-device behaviour.
- Mobile camera-look surface, multitouch finger tracking and virtual analog movement joystick. These are M2 work and were deliberately not included.
- Camera collision, safe-area layout and performance on the target phone.
- Full manual gameplay or vertical-slice functionality.

## Decision boundary

This is an isolated implementation branch, not a merge or release. It has not been merged into `btv/test-first-contracts-001` or `main`. Keep creator review as the merge gate. No new dependency, paid asset, paid service, canon or story content was added.
