# BTV Prototype — Implementation Status

**Engineering reference branch:** `btv/test-first-contracts-001`  
**Separate camera/input feature branch:** `btv/camera-relative-mouselook-001` (unmerged)  
**Separate mobile input adapter branch:** `btv/mobile-touch-input-adapter-001` (unmerged; adapter only)  
**Prototype origin:** `btv/bootstrap-prototype-001`  
**Status:** HEADLESS CI PASSED; visual/runtime and Android device validation remain pending.  
**Latest verified successful camera/input feature run at this document revision:** [42499393434](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42499393434), commit `de2cb1d29f81a011ddb5319e6c32d95ac3418e45` on `btv/camera-relative-mouselook-001`. The strict-type PR #2 run `42497741908` also passed on its separate feature branch.

## 1. Implemented source

### Bootstrap / interaction foundation
- Godot project configuration and main greybox scene.
- CharacterBody3D capsule placeholder, collision, third-person camera and proximity sensor.
- Keyboard movement actions and E interaction action.
- Reusable BTVInteractable Area3D contract.
- Initial Android touch overlay feeding the same InputMap actions as keyboard.
- Nearest eligible interactable selection, stable authored-ID tie-break, disabled/freed/duplicate-ID exclusion.
- Touch release on button-up, application focus loss and overlay teardown.

### Camera/input M1 — isolated feature branch
- Camera-relative horizontal movement and diagonal normalization.
- Mouse-look yaw/pitch logic with pitch limits.
- Camera yaw remains independent of player-body facing rotation.
- Desktop pointer capture/release handling is implemented in source; actual pointer capture is not exercised by headless CI.
- New camera input tests pass in run 42499393434.
- Mobile camera-look surface, virtual joystick UI integration and physical Android verification remain open.
- Independent touch movement/look finger-state adapter is implemented and tested on `btv/mobile-touch-input-adapter-001`; it is not yet connected to the running touch HUD.

### NLI
- Deterministic phrase parser and typed intent validation.
- Authored NPC knowledge records with source provenance and per-NPC scope.
- Unknown-answer, conflict and evidence-marked dialogue handling.
- Request gate and structured orchestration service.
- Service reports validation; it does not claim companion actor acceptance or execution.
- Source records include identity, type, title, location, hash/version field, authority/review status and permitted scopes.
- Unresolved, unapproved and out-of-scope sources are rejected.

## 2. Automated test coverage

The current CI workflow runs:
1. Godot 4.7.2 version check.
2. Headless editor import and project parsing.
3. NLI smoke tests.
4. NLI handoff/source-registry contract tests.
5. Core interaction acceptance tests.
6. Ten-frame main-scene launch.

The interaction test file is `tests/core_interaction_acceptance_test.gd`. The acceptance matrix is `docs/qa/CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md`. The latest regression additions cover temporary disable/re-enable and normalized ID handling.

The automated suite currently covers:
- no-target safe no-op;
- one eligible target invoked once;
- nearest target selection;
- target exit;
- freed target;
- disabled target;
- duplicate authored IDs excluded;
- stable tie-break;
- duplicate enter notification idempotence;
- moving-target selection recalculation;
- non-interactable Area3D exclusion;
- touch press/release through shared actions;
- focus-loss release;
- touch teardown release;
- disabled target can be re-enabled while still in sensor range;
- whitespace-padded interaction IDs are normalized;
- IDs equal after whitespace normalization are rejected as duplicates;
- case-only ID tie uses deterministic secondary lexical ordering.

The acceptance matrix has 28 cases. At run `42497741908`, 15 cases had direct automated coverage and 2 were partial; the remaining 11 were not automated. Consult the matrix for exact case mapping. The workflow's overall success does not pass unimplemented cases.

## 3. NLI lifecycle still incomplete

**Implemented:** validation and source resolution; NLI does not claim actor acceptance.

**Still open:**
- real companion adapter and actor-owned handoff acknowledgement;
- actor-owned accepted/rejected/executing/executed/cancelled/expired/failed transitions;
- expiry/timeout and stale callback handling;
- pause/quit/reload persistence;
- cancellation after execution starts;
- persistent source-registry lifecycle;
- cryptographic hash verification and source-version invalidation.

Do not mark NLI lifecycle complete.

## 4. Deliberate constraints

- No renderer selected; compare options on the actual target Android device.
- Capsule is a placeholder, not Asher's final model.
- Touch overlay source exists, but layout, safe areas, scaling and multitouch remain unverified on a physical device.
- No combat, enemies, Veil rules, Ember behaviour, faith systems, mission content or narrative content has been introduced into the prototype.
- No paid assets, paid services or external runtime dependencies have been added.
- The recovered vertical slice specification remains a design target; the playable vertical slice is not implemented.

## 5. Verification boundary

**CONFIRMED — run 42497741908:** completed successfully on Godot 4.7.2. It includes headless editor import/project parsing, NLI smoke tests, NLI handoff/source-registry contract tests, mission validator tests, core interaction acceptance tests and a 10-frame main-scene launch. The interaction suite prints `CORE_INTERACTION_ACCEPTANCE_TESTS: PASS`; this verifies only the automated cases listed in the matrix.

Not verified:
1. Editor visual inspection.
2. Manual movement, camera and interaction feel.
3. Physical touch input and multitouch.
4. Android export and APK installation.
5. Renderer comparison on target device.
6. Frame time, memory, thermal behaviour and sustained stability.
7. Save/load and full vertical-slice behaviour.

A successful headless run is not Android readiness.

## 6. Next engineering gate

1. Complete remaining interaction acceptance cases where a stable test seam exists.
2. Design and test the NLI companion adapter/lifecycle without claiming actor state prematurely.
3. Keep Ridgeview data contracts aligned with the recovered Vertical Slice v1.0.
4. Prototype a neutral Blender-to-Godot test asset only after writing its acceptance contract; do not use Asher or Ember as the test asset.
5. Defer renderer selection and Android export until the target device is identified and tested.

All changes remain on the isolated engineering branch. Do not merge to main, change canon or introduce paid dependencies without explicit approval.
