# BTV Development Checkpoint 24 — Exploration Playability Acceptance

**Date:** 10 November 2026  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Verified HEAD before this documentation commit:** `d8bd9f28169522adf24b43fe58fda3b003510efd`  
**Godot CI:** [Run #42807419213](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42807419213) — **PASS**, 47/47 successful steps on exact HEAD above.  
**Previous gameplay-test CI:** [Run #42807265050](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42807265050) — **PASS**, 47/47 steps on commit `151721142320bac3bb9aae5ec5beae3bb54c9062`.

## 1. Playable scene acceptance — EXTENDED

The exploration prototype acceptance suite now exercises the scene's core loop rather than only checking node presence.

Coverage includes:
- Player controller, touch-control layer, HUD, environment, ground collision and greybox landmarks.
- Four authored field-note points, each with a stable unique ID and visible marker.
- Independent selection of each field-note target in the test fixture.
- Field-note text delivered to the interaction HUD.
- Journal unique-count increments, local save reporting and live HUD refresh.
- Duplicate interaction leaves the unique observation count unchanged.
- Physics-driven movement input creates measurable player displacement in the playable scene.
- Releasing movement returns horizontal velocity to rest within the test.
- Player remains grounded after the movement segment.
- Jump input produces upward velocity and the player returns to the ground.

The test fixture now removes each simulated sensor-enter event after its observation check. This prevents prior test targets remaining in the proximity list and shadowing later targets. The player receives additional physics frames to settle before movement acceptance.

## 2. HUD readability correction — IMPLEMENTED

The status HUD refresh after a field-note discovery now uses actual newline separators for its desktop, mobile and journal guidance. This fixes a literal escaped-sequence display in the post-discovery status text.

## 3. Validation evidence

- Commit `c1bbfcd432bdb1875953c0482ee8e56f3bdef79d`: four-point journal and duplicate-recording coverage passed CI run #42806386381 (47/47).
- Commit `151721142320bac3bb9aae5ec5beae3bb54c9062`: test-fixture isolation and ground-settle correction passed CI run #42807265050 (47/47).
- Commit `d8bd9f28169522adf24b43fe58fda3b003510efd`: HUD line-break correction passed CI run #42807419213 (47/47).

An intermediate test revision exposed fixture contamination: previously simulated observation targets remained in the controller's proximity list. That revision failed the exploration acceptance test; the fixture was corrected and the subsequent full CI run passed. The failed revision is retained in history and is not represented as a passing build.

## 4. Scope and limitations

- This is still a primitive greybox, not a production environment or art pass.
- Movement acceptance is a short physics-driven test segment, not a complete authored route, obstacle course or traversal certification.
- Jump is tested in the playable scene; double-jump and dash remain covered by their separate existing contract suites.
- No Android APK export, installation, physical touchscreen test, sustained frame pacing, memory, thermal or power test has been completed.
- No species-authentic wildlife, production animation, full weather/lighting integration, mission progression or finished narrative content is included in this increment.
- No canon changes, combat, weapons, hunting, capture, paid assets, merge, release or publication.

## 5. Next engineering priorities

1. Add a camera and navigation acceptance path within the playable exploration scene, including camera-relative direction and obstacle/collision behaviour.
2. Add an observation interaction test driven through the actual sensor overlap path, not only direct test callbacks.
3. Begin modular environment asset work with measurable mobile geometry/material budgets.
4. Integrate wind, weather and lighting in the exploration scene in small independently testable stages.
5. Select a single wildlife candidate only after taxonomy, range, habitat and visual reference evidence are checked.
6. Establish Android export and physical-device acceptance when an appropriate device/test workflow is available.

**Status:** The playable greybox now has CI-verified movement, braking, grounded jump/landing, four independently testable field notes and persistent journal feedback. This advances prototype readiness but does not constitute Android device acceptance or a production-game milestone.
