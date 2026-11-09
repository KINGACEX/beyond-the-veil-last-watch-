# BTV Development Checkpoint 08 — Control Hardening and Prototype Layout Plan

**Date:** 2026-11-09  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Base:** `btv/xh-003-input-source-composition-spec-001`  
**Status:** CONTROL HARDENING IN PROGRESS · LAYOUT PLAN DOCUMENTED · PLAYABLE LAYOUT NOT STARTED

## 1. Scope of this checkpoint

This phase follows XH-003 without merging or replacing its draft PR. It establishes a formal control-readiness gate, prepares the prototype layout plan, adds a real viewport-path concurrent multitouch regression suite, and extends CI to cover the new suite.

## 2. Confirmed implementation and verification

- Added `tests/touch_controls_multitouch_viewport_test.gd`.
- The suite delivers InputEventScreenTouch and InputEventScreenDrag through the actual SceneTree viewport input path.
- It exercises three concurrent fingers: joystick movement, camera look, and the Interact GUI button.
- It verifies that releasing one finger does not cancel another control owner.
- It verifies focus-loss cancellation clears active touch movement, Interact and finger ownership.
- Added the new suite to `.github/workflows/godot-validation.yml`.
- Added this branch to the workflow's push-trigger list.
- Expanded CI from 14 to 15 test suites.
- Added `docs/engineering/BTV_CONTROL_READINESS_GATE_001.md`.
- Added `docs/engineering/BTV_PROTOTYPE_LAYOUT_AND_FEEL_PLAN_001.md`.
- Updated `docs/engineering/BTV_GODOT_CI_RUNBOOK.md` to describe the 15-suite pipeline.

**Successful Godot 4.7.2 run:** [#42654969493](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42654969493)  
**Tested commit:** `0403e35feadd057e2ca02feefeac1a0575b7c847`  
**Result:** import/script parsing passed; all 15 suites passed; main scene launched headlessly for 10 frames; workflow completed successfully.

The follow-up documentation commits update the gate/runbook to record the 15-suite result. They do not change gameplay source or tests. Their own final commit should be checked by CI before describing the current branch head as fully validated.

## 3. Control readiness decision

The controls are **not declared perfect or Android-ready**.

Automated evidence now covers:
- keyboard/touch movement composition and both release orders;
- analog deadzone and rescaling;
- separate movement/look finger ownership;
- viewport-delivered movement, camera look and GUI Interact with three concurrent fingers;
- independent release behaviour;
- focus loss, pause, teardown and lifecycle recovery;
- viewport resizing in tested desktop/headless dimensions;
- keyboard/mouse compatibility paths.

Remaining gates:
1. Physical Android multitouch and ergonomic testing.
2. Real display-cutout/system-bar safe-area testing.
3. Minimum device identification and renderer/device compatibility.
4. Camera sensitivity and movement-feel tuning on device.
5. A controlled neutral movement/physics lab with acceleration, deceleration, slopes, steps and collision response.
6. External peer review and final working-tree/generated-artifact audit.

## 4. Prototype layout plan

The layout plan is documented but **not yet implemented**. Implementation is deliberately held until control readiness Gates A–C pass.

Planned order:
1. Neutral movement/camera/physics lab.
2. Ridgeview approach and perimeter.
3. Ridgeview settlement and resident interaction spaces.
4. Outlying camp and non-graphic evidence route.
5. Logos Rhema Temple as a separate living-world scene.
6. Covenant vehicle travel, Scout Report, evidence synthesis and final report.

The plan preserves the locked vertical slice, character identities, church/Communion boundaries, Ridgeview content boundaries and approved Ember abilities/commands. It does not invent new supernatural powers, combat rules, enemy identities or canon.

## 5. Governance

- No merge, release, Android export/signing, package ID decision, credential change, permission expansion, paid service or MiniMax private-workspace modification occurred.
- No PR was opened for this phase.
- Keep XH-003 PR #6 draft and unmerged.
- Keep this control-hardening branch isolated until the new test and follow-up documentation have been reviewed.
- The playable prototype layout begins only after the control readiness gates are evidenced as passed. The layout plan is preparatory documentation, not a claim that the level has been built.

## 6. Next actions

1. Confirm the latest branch CI run after documentation follow-ups.
2. Review the new viewport multitouch test and any failure logs.
3. Add safe-area-aware layout tests and define a device test checklist.
4. Identify the minimum Android device when available.
5. Complete the neutral movement/physics lab.
6. Only then start the Ridgeview greybox layout and later the Logos Rhema scene.
