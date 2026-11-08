# BTV M2 — Independent Touch Input Adapter

**Status:** ADAPTER IMPLEMENTED; HEADLESS CI PASS; NOT YET CONNECTED TO THE MOBILE HUD  
**Date:** 8 November 2026  
**Feature branch:** `btv/mobile-touch-input-adapter-001`  
**Base:** `btv/camera-relative-mouselook-001` at `de2cb1d29f81a011ddb5319e6c32d95ac3418e45`  
**Head commit:** `9151e92f87a4e7971d3f44138fae1ec4c78ae0a3`  
**CI:** [GitHub Actions run 42499779484](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42499779484)

## Purpose

Build a small, testable input-state layer before changing the visible Android controls. It assigns one touch finger to movement and a different touch finger to camera look, so a movement gesture cannot also rotate the camera.

## Changes

- `scripts/touch_input_adapter.gd`
  - Tracks one movement finger and one independent look finger.
  - Rejects negative finger IDs, duplicate ownership and attempts by one finger to own both controls.
  - Converts joystick displacement into a normalized unit-circle vector with a configurable radius and deadzone.
  - Rescales movement outside the deadzone.
  - Returns incremental look deltas from the look finger.
  - Ignores unrelated finger updates without changing the authoritative movement vector.
  - Releases matching finger ownership and clears both controls on cancellation.
- `tests/touch_input_adapter_test.gd`
  - Covers invalid IDs, joystick centre, horizontal movement, unit-circle clamping, deadzone, finger isolation, incremental look deltas, same-finger rejection, matching release, simultaneous independent fingers and cancel-all cleanup.
- `.github/workflows/godot-validation.yml`
  - Adds the adapter test suite to the feature-branch CI workflow.

## Verification

**CONFIRMED — Godot 4.7.2 run 42499779484:**
- Headless editor import/project parsing passed.
- NLI smoke and handoff/source-registry tests passed.
- Mission data validator tests passed.
- Core interaction acceptance tests passed.
- Camera input tests passed.
- Touch input adapter tests passed with `TOUCH_INPUT_ADAPTER_TESTS: PASS`.
- 10-frame main-scene launch passed.

## Boundaries

This is an input-state adapter, not a finished mobile control scheme. It is not connected to `touch_controls.gd`, no joystick or camera-look surface has been drawn, no movement actions are being driven by this adapter in the running scene, and no physical Android touch test has occurred.

The current four-button touch overlay remains unchanged. Preserve it until the integrated joystick/look controls pass automated tests and physical-device review.

## Next bounded step

Integrate the adapter into a separate touch-control UI layer:
1. Add a left-side virtual joystick that feeds the shared movement actions with analog strengths.
2. Add a right-side camera-look surface that forwards incremental deltas to the player camera.
3. Keep the Interact action separate and ensure it cannot steal either active finger.
4. Release all movement actions and finger ownership on touch-up, cancellation, focus loss and scene teardown.
5. Test movement + look simultaneously, wrong-finger events, cancellation and UI overlap.
6. Keep the old directional buttons available as a fallback until the integrated surface is reviewed on the actual Android device.

No game canon, story, mission data, combat, external dependency or paid asset was added. The branch remains isolated and unmerged.
