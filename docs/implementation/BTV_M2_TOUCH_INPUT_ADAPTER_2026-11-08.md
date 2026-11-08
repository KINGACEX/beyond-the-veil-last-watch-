# BTV M2 — Integrated Mobile Touch Controls

**Status:** IMPLEMENTED IN ISOLATED FEATURE BRANCH; HEADLESS CI PASS; PHYSICAL ANDROID QA PENDING  
**Date:** 8 November 2026  
**Feature branch:** `btv/mobile-touch-input-adapter-001`  
**Base:** `btv/camera-relative-mouselook-001` at `de2cb1d29f81a011ddb5319e6c32d95ac3418e45`  
**Head commit:** `3484672809ad95e4e36591e7ca7d49d5f61dfd5e`  
**CI:** [GitHub Actions run 42500466981](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42500466981)

## Purpose

Integrate an analog movement surface and independent camera-look surface while retaining the existing directional pad as a fallback. Movement, look and Interact must not steal one another's touch ownership.

## Changes

- `scripts/touch_input_adapter.gd`
  - Tracks one movement finger and one independent look finger.
  - Rejects negative finger IDs, duplicate ownership and attempts by one finger to own both controls.
  - Converts joystick displacement into a normalized unit-circle vector with a configurable radius and deadzone.
  - Returns incremental look deltas.
  - Ignores unrelated finger events without changing the authoritative movement vector.
  - Supports matching release and cancel-all cleanup.
- `scripts/touch_controls.gd`
  - Routes screen-touch and screen-drag events by finger ID.
  - Feeds analog strengths into the same four movement InputMap actions used by the keyboard.
  - Sends look deltas to the player camera.
  - Excludes the Interact button rectangle from camera-look tracking.
  - Releases actions and finger ownership on touch release, application focus loss and scene teardown.
  - Resizes the overlay to the active viewport and responds to viewport-size changes.
  - Exposes `use_analog_touch_controls`; setting it to false restores the legacy directional pad.
- `scenes/touch_controls.tscn`
  - Adds a left-side circular joystick and knob.
  - Adds a transparent right-side camera-look region.
  - Retains the existing Interact button and legacy directional pad.
- `scripts/player_controller.gd`
  - Registers the player in the `btv_player` group for camera-look routing.
- Tests:
  - `tests/touch_input_adapter_test.gd` covers finger ownership, deadzone, clamping, independent fingers, release and cancellation.
  - `tests/touch_controls_integration_test.gd` covers movement action strengths, simultaneous movement/look, Interact-area exclusion, focus loss, scene teardown and legacy fallback.
- `.github/workflows/godot-validation.yml`
  - Runs both adapter and integrated touch-control suites.

## Verification

**CONFIRMED — Godot 4.7.2 run 42500466981:**
- Headless editor import/project parsing passed.
- NLI smoke and handoff/source-registry contract tests passed.
- Mission data validator tests passed.
- Core interaction acceptance tests passed.
- Camera input tests passed.
- Touch input adapter tests passed.
- Touch controls integration tests passed with `TOUCH_CONTROLS_INTEGRATION_TESTS: PASS`.
- 10-frame headless main-scene launch passed.

The integration suite verifies independent movement and look fingers, movement release, focus-loss cleanup, scene-teardown cleanup, Interact-area exclusion and the ability to restore the legacy directional pad.

## Verification boundary

**Not yet verified on a physical Android device:** touch latency, thumb reach, actual multitouch hardware behaviour, portrait/landscape changes, safe-area insets, UI scale/readability, camera sensitivity, frame pacing and device performance. Headless synthetic input tests do not establish these properties.

The analog layout is enabled by default on touchscreen devices. The old directional pad remains in the scene and can be restored by setting `use_analog_touch_controls = false`. Do not remove that fallback until physical-device review is complete.

## Decision boundary

This is an isolated, unmerged feature branch. No release, merge, store upload, paid asset, external dependency, story/canon change or mission content was added. The next gate is manual Android device validation and any required responsive/safe-area adjustments.
