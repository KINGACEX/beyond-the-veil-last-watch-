# BTV Next Execution Plan

**As of:** 2026-11-08  
**Branch:** `btv/project-history-and-lore-bridge-001`  
**Purpose:** Establish an evidence-led order for the next development work. This plan is not a claim that the listed tasks are already implemented.

## Operating rules

- Creator remains final authority for canon, scope and consequential actions.
- Inspect the latest branch and source documents before changing code.
- Keep work on isolated feature branches.
- One bounded task per change; test it; record exact evidence.
- Do not use paid services or credits without explicit approval.
- No deletions, security changes, merges, releases or publication without explicit approval.
- Do not promote generated proposals to canon or implementation status.

## Priority 0 — Preserve and orient

**Goal:** Maintain a reliable project baseline.

1. Keep `btv/test-first-contracts-001` as the current engineering reference unless a newer verified branch supersedes it.
2. Use this documentation branch for cross-platform records and Lore Bridge safety work.
3. Compare current CI status and commit SHA before every implementation task.
4. Keep the recovered source-of-truth index and merged Vertical Slice Specification as the design authority.
5. Record branch, commit, changed paths and test output in the activity log.

**Exit criteria:** Every contributor can identify the authoritative branch, relevant source documents and current test baseline without guessing.

## Priority 1 — Safe shared knowledge bridge

**Goal:** Make MiniMax's Lore Bridge safe to evaluate before connecting it to any real assistant configuration.

1. Review the exact source and tests for LRB-001 through LRB-008.
2. Prepare a v1.1 change specification; do not patch the original ZIP in place.
3. Create a disposable test fixture with synthetic BTV-only sample data.
4. Test non-destructive rebuild, backup/restore, registration merge and failure rollback.
5. Implement privacy allowlisting and sensitive-data exclusions before indexing.
6. Add source status, authority, scope, provenance and conflict metadata.
7. Replace keyword-only gap claims with evidence-tier outputs.
8. Test the MCP server in an isolated environment.
9. Verify MiniMax Code, Claude Code and Claude mobile as separate client targets.
10. Only after passing the above, prepare user-controlled connection instructions.

**Exit criteria:** A clean disposable test demonstrates safe rebuild, safe config handling, privacy filtering, source-linked retrieval and accurate evidence labels. No real client configuration is touched during the test.

## Priority 2 — One real cross-platform handoff

**Goal:** Prove the multi-agent system works as a process, not merely as documentation.

1. Select one low-risk task that does not alter canon or gameplay.
2. ChatGPT issues a task brief with exact source paths and acceptance criteria.
3. Claude returns a visual-only deliverable or critique.
4. MiniMax Code reviews or implements a separate bounded technical task only after approval.
5. ChatGPT checks traceability and reports discrepancies.
6. Creator accepts or rejects the deliverables.
7. Record agent identity, platform, branch, commit, output, tests and creator decision.

**Exit criteria:** At least one handoff is completed by each participating platform, with evidence and no accidental permission escalation. Do not claim connection until the client itself confirms it.

## Priority 3 — Engineering contract completion

**Goal:** Advance the existing Godot foundation without introducing unapproved story systems.

Recommended sequence:
1. Inspect current CI and remaining core-interaction matrix cases.
2. Complete only stable, testable interaction cases.
3. Design the NLI actor adapter and lifecycle contract.
4. Add tests for actor-owned acknowledgement, rejection, execution, cancellation, expiry and stale callbacks.
5. Define pause, quit, reload and persistence semantics before implementing persistence.
6. Verify source-registry lifecycle, hash recheck and source-version invalidation.
7. Add a neutral, canon-free test asset only after its import/scale/material/collision acceptance contract exists.

**Exit criteria:** Each lifecycle state is owned by the correct component and proven by tests; the system never claims an action was executed from validation alone.

## Priority 4 — Vertical slice content integration

**Goal:** Turn the controlling design into a playable slice only after the relevant systems exist.

1. Re-read the merged Vertical Slice Specification and Ridgeview case sources.
2. Build a revelation/evidence matrix: observation, source, what it proves, what it does not prove, uncertainty and resulting choices.
3. Create typed data for the opening sequence without changing the locked story.
4. Integrate dialogue and investigation only through validated data contracts.
5. Add the Logos Rhema sequence and Scout Report only after scene, interaction, NPC and save boundaries are ready.
6. Build Ridgeview after evidence collection, NPC state and final-report contracts are testable.
7. Test outcomes and persistence against the creator-approved slice.

**Exit criteria:** A player can complete the intended opening-to-Ridgeview loop and the final report reflects actual observed outcomes. Until then, describe the slice as a design target.

## Priority 5 — Android verification

**Goal:** Establish actual device feasibility.

1. Identify the target Android device and record OS, RAM, GPU and screen dimensions.
2. Export and install a minimal build.
3. Test safe areas, scaling, touch input, multitouch, camera, movement and interaction.
4. Measure frame time, memory and thermal behaviour over a sustained session.
5. Compare renderer options on the device; do not select based only on desktop or CI.
6. Record results and decide minimum/target quality tiers.

**Exit criteria:** A reproducible device report exists. Headless CI alone is insufficient.

## Priority 6 — Visual production and trailer

**Goal:** Keep visual development aligned to canon and cost limits.

1. Obtain creator-approved Asher and Ember references before depicting them as canonical.
2. Require visual briefs, provenance and acceptance checks before assets enter the game.
3. Review the existing Screel render manually; do not generate or upscale while credits are unavailable.
4. Label the current cut as illustrative still-image material, not gameplay footage.
5. Do not upload or publish until the creator approves the final media and metadata.
6. Revisit Descript only when a no-cost, feasible editing path is confirmed.

**Exit criteria:** Approved references, asset provenance, playback review and creator sign-off are recorded.

## Current blockers

- Lore Bridge has high-severity destructive rebuild/config and privacy risks; it is unexecuted.
- External Claude/MiniMax MCP connections are not verified.
- Physical Android target and device validation are unknown.
- The full vertical slice is not implemented.
- Trailer render requires human playback review; current Screel credit balance was zero at last audit.
- No public trailer or Shorts have been approved for release.

## Definition of done for any task

A task is complete only when its owner supplies:
- exact task ID and scope;
- source branch and commit;
- changed paths;
- implementation or deliverable summary;
- test command and actual result;
- known limitations;
- cost/credit impact;
- status of creator approval.

A plan, generated draft, static code match or successful headless launch must not be reported as a completed gameplay feature.


## Execution update — 2026-11-08

**Completed on this documentation branch:** Priority 4, item 2, the Ridgeview revelation/evidence matrix has been drafted and source-traced at `docs/story/BTV_RIDGEVIEW_REVELATION_AND_EVIDENCE_MATRIX_v0.1.md`.

**Next bounded work:** Inspect the current neutral mission-data validator, claim/evidence interfaces and existing tests on the engineering branch. Do not author Ridgeview dialogue or mission content yet. First determine whether the validator can safely express source IDs, evidence references, claim labels, and unresolved states without embedding canon in code. Any code work must remain isolated, test-first and neutral until creator approval of the matrix.

**Current status:** Matrix drafted; implementation not started; no story dialogue or new canon authored.


## Engineering execution update — strict registry types

A separate engineering branch `btv/mission-validator-strict-types-001` now contains test-first strict-type checks for registry namespaces, IDs and required reference fields. Draft PR #2 targets `btv/test-first-contracts-001`: https://github.com/KINGACEX/beyond-the-veil-last-watch-/pull/2.

GitHub Actions run `42497741908` was observed in progress while installing Godot 4.7.2. Await the full result before describing the change as tested. Do not merge the draft PR without creator review. If CI fails, inspect the failing step/logs, make the smallest correction on the same feature branch, and rerun.


### Strict-type PR verification update

**CONFIRMED:** Draft PR #2 workflow run `42497741908` completed successfully on Godot 4.7.2. The mission data validator suite reports `MISSION_DATA_VALIDATOR_TESTS: PASS`, and NLI smoke, NLI contract, core interaction acceptance and the 10-frame main-scene launch also passed. The change is still in a draft PR and has not been merged. Keep creator review as the merge gate.



## Engineering review update — interaction matrix, 8 November 2026

**COMPLETED — inspection and evidence accounting:** The controller, touch overlay, main scene, core interaction test suite, acceptance matrix and cross-platform input brief were reviewed against the successful Godot 4.7.2 run [42497741908](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42497741908). The matrix now records 15 automated cases, 2 partial cases and 11 not yet automated. Headless CI is not treated as device or manual verification.

**CONFIRMED source gaps:** camera-relative movement and mouse-look are not implemented in the current player controller. The touch overlay is a four-direction-button scaffold plus Interact; it is not a complete mobile control scheme. Scene transition/re-entry, pause/UI input context, unavailable-target handling, multitouch, multiple-shape deduplication and player/self-sensor exclusion remain untested or unimplemented.

**Next bounded task:** on a fresh isolated engineering branch from the latest verified base, implement only camera-relative movement and desktop mouse-look, preserving current keyboard actions and interaction. Add focused logic tests for camera-relative direction, diagonal normalization and pitch limits where practical. Do not combine this with a virtual joystick, mobile camera-look surface, responsive menus or gameplay features. Verify Godot 4.7.2 CI and report manual/device limitations explicitly.



## M1 implementation update — 8 November 2026

**CONFIRMED COMPLETED:** Camera-relative horizontal movement and desktop mouse-look logic are implemented on `btv/camera-relative-mouselook-001`, head `de2cb1d29f81a011ddb5319e6c32d95ac3418e45`. Godot 4.7.2 run [42499393434](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42499393434) passed the full configured headless validation workflow, including the new camera input tests.

**LIMITATIONS:** Actual desktop pointer capture is not verified because the CI runner is headless. Android camera-look, virtual joystick, multitouch, physical-device feel/performance and manual editor/runtime review remain unverified. The implementation branch remains isolated and unmerged.

**Next bounded workstream:** M2 mobile control surface. First design a small testable input adapter for independent movement-finger and look-finger tracking, touch cancellation, focus loss and teardown. Preserve the current directional buttons until the joystick/look surface passes automated tests and device review. Do not claim Android readiness from CI.
