# BTV PARALLEL RESEARCH + GITHUB ENGINEERING CHECKPOINT
**Session ID:** 2026-11-05_1248Z_BTV_PARALLEL_RESEARCH_ENGINEERING  
**Date:** 5 November 2026  
**Work window:** Start time not captured at initiation; first verified artifact in this work period is 12:48:00 UTC. Checkpoint timestamp: 12:55:53 UTC.  
**Status:** INTERIM MILESTONE — research and engineering progressed concurrently  
**Project:** Beyond the Veil: The Last Watch  
**Active branch:** `btv/test-first-contracts-001`  
**Verified branch head at checkpoint creation:** `ddf23c185e95d704413ab275443fa922b2fcee99`

## 1. User intent and constraints
User asked whether research and GitHub work could continue simultaneously. Confirmed and executed two coordinated workstreams:
- Research: current developer/industry evidence, academic sources, Blender/Godot production workflows, character/animation and technical docs.
- GitHub: inspect current state, update repository documentation, review interaction contracts, add regression tests, fix confirmed defects.

Carry-forward constraints:
- Preserve BTV canon and existing work.
- All research recommendations remain PROPOSED until explicitly approved.
- Keep work on the isolated feature/research branch; no merge to main.
- No destructive, paid, public, deployment or security-sensitive action without approval.
- Free/low-cost first; no Perplexity API key or paid service.
- Do not claim Android readiness or unperformed manual/device testing.
- Maintain test-first workflow; distinguish CI headless checks from visual/runtime/device validation.

## 2. GitHub state verification
- Active branch exists: `btv/test-first-contracts-001`.
- Branch head at checkpoint creation: `ddf23c185e95d704413ab275443fa922b2fcee99`.
- The current branch tree contains the project, tests, docs, research and source-of-truth files.
- No merge to `main` was performed.
- Root README and implementation status document were reconciled with the current isolated branch and recent research.
- Latest successful comprehensive CI evidence in this work period: run `42031119379`, commit `7583d424f0140181e7d170e323d2a5377f9ded5e`.
- Run 42031119379 passed: Godot 4.7.2 install/version, editor import/project parsing, NLI smoke tests, NLI handoff/source-registry tests, core interaction acceptance tests and 10-frame main-scene launch.
- A later docs-only head commit `ddf23c185e95d704413ab275443fa922b2fcee99` has a new CI run `42031261816` pending at checkpoint time. Poll before describing latest branch head CI as passed.
- Earlier run 42030879176 failed intentionally after test-first regression cases were added; it exposed the defects described below. This failure is not the latest successful code validation.

## 3. Engineering work completed

### 3.1 Interaction selector defect discovery — test first
The original selector had two defects:
1. When a nearby interactable was temporarily disabled, selection discarded it from the nearby list. Re-enabling it while still inside the sensor range did not restore eligibility because no new enter event occurred.
2. IDs were counted after trimming whitespace but looked up later using the untrimmed raw ID. A valid ID with leading/trailing spaces was therefore excluded.

### 3.2 Regression tests added
Updated `tests/core_interaction_acceptance_test.gd` with:
- `_test_disabled_target_can_be_reenabled_in_range`
- `_test_whitespace_padded_interaction_id_is_normalized`
- `_test_ids_equal_after_whitespace_normalization_are_duplicates`

The first two tests failed on the pre-fix implementation in run `42030879176`, confirming the defects. The third was added after the correction to cover normalized duplicate identity.

### 3.3 Selector correction
Updated `scripts/player_controller.gd`:
- Retains valid, in-tree nearby interactables even when temporarily disabled.
- Prunes invalid, queued-for-deletion and out-of-tree references.
- Uses one whitespace-normalization helper for ID counting and lookup.
- Rejects IDs that collide after whitespace normalization.
- Uses a deterministic secondary lexical tie-break when case-insensitive ordering considers two IDs equal.

Fix commit: `240ce725c6621f48fb4ccb3d3ee9479daf57db24`.

### 3.4 Verification
Run `42031119379` on commit `7583d424f0140181e7d170e323d2a5377f9ded5e` passed all workflow steps, including the interaction acceptance test step with all three regression cases. This is headless CI only.

Acceptance matrix extended to 27 cases, adding INT-025 through INT-027:
- temporary disable/re-enable while still in range;
- whitespace-padded ID normalization;
- normalized duplicate IDs rejected.

Files:
- `tests/core_interaction_acceptance_test.gd`
- `scripts/player_controller.gd`
- `docs/qa/CORE_INTERACTION_003_EDGE_CASE_ACCEPTANCE_MATRIX.md`
- `docs/implementation/BOOTSTRAP_STATUS.md`
- `README.md`

No Android, visual editor, manual touch or physical-device test was run.

## 4. Research completed in parallel

### 4.1 Blender Studio DOGWALK asset pipeline
Reviewed the primary practitioner article by Blender Studio Technical Director Simon Thommes and cross-checked with Khronos and Godot 4.7 docs.
Findings:
- Blender Studio used a small team of eight and a four-month micro-game to validate Blender/Godot/glTF interoperability.
- glTF acted as an explicit publishing boundary between working Blender files and game-ready exports.
- Collection exports allowed one source file to publish multiple separate assets.
- The pipeline separated asset data from instance references and rebuilt nested instances on the Godot side.
- Custom Blender export and Godot import tooling carried metadata.
- Reported problems included central asset-index merge conflicts, duplicate IDs, material identity collisions and import-order-dependent material settings.
- BTV proposal: start with one neutral test asset and a simple explicit glTF export/import workflow; do not build a custom asset index or plugin before a demonstrated need.

Research file:
`docs/research/BTV_BLENDER_GODOT_ASSET_PIPELINE_RESEARCH_2026-11-05.md`
Commit: `a8e59911c5ecf7a2a036596302e315414697ef87`

Primary sources:
- https://studio.blender.org/blog/our-workflow-with-blender-and-godot/
- https://www.khronos.org/blog/project-dogwalk-stress-testing-blender-to-godot-interoperability-with-gltf
- https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html

### 4.2 Character and animation pipeline
Reviewed Blender Conference 2025 “Making of DOGWALK”, Blender Studio's playable stop-motion article, and Godot 4.7 animation documentation.
Findings:
- DOGWALK's stepped animation style was a scope/art-direction decision, not a universal recommendation.
- Player input and gameplay transforms remained responsive while selected visual animation could be stepped.
- Godot AnimationPlayer stores animation tracks; AnimationTree controls transitions/blending.
- Godot retargeting requires attention to bone names, Bone Rest transforms, BoneMap/SkeletonProfile and non-bone accessory tracks.
- Import success does not prove deformation or animation quality.

Research file:
`docs/research/BTV_CHARACTER_AND_ANIMATION_PIPELINE_RESEARCH_2026-11-05.md`
Commit: `2b89c54b5e148c1cf312deb59d425111c7e0f075`

### 4.3 Rigging and game-animation case study
Reviewed Blender Studio articles on DOGWALK character rigging and game animation.
Findings:
- Layout rigs were built early and reused as the basis for production rigs, with explicit trade-offs from early design constraints.
- Runtime-specific helper bones and camera-facing features were considered separately from animator controls.
- Game animation differs from film animation because player actions can occur in unpredictable order and from arbitrary camera angles; loops and transitions must respond in real time.
- BTV should validate rig/export/import, locomotion, camera-angle readability and animation interruption before scaling character content.

Research file:
`docs/research/BTV_CHARACTER_RIGGING_AND_GAME_ANIMATION_CASE_STUDY_2026-11-05.md`
Commit: `622718a0ac1bb82c480bb388aac5ba4a7ddef072`

Primary sources:
- https://studio.blender.org/blog/character-rigging-for-project-dogwalk/
- https://studio.blender.org/blog/animations-for-dogwalk/
- https://studio.blender.org/blog/playable-stop-motion-in-godot/
- https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html
- https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html

## 5. Perplexity integration status
No matching Perplexity plugin was available in the ChatGPT plugin directory. Perplexity API integration would require credentials and may incur cost. No key or paid integration was created. Firecrawl, Consensus and direct web research remain the current research stack.

## 6. Repository documentation updates
- Root README now identifies `btv/test-first-contracts-001` as the active isolated engineering/research branch, links the research documents and describes the headless verification boundary.
- `docs/implementation/BOOTSTRAP_STATUS.md` now reflects the current test coverage and known remaining NLI lifecycle work.
- README and status docs updated in commits `f7f65f3f8a2452d0870e619e2d588d959683be8e` and `ddf23c185e95d704413ab275443fa922b2fcee99`.

## 7. Not completed / open
- [ ] Poll CI run `42031261816` for current branch head.
- [ ] Continue research across more small-team/indie/AA/AAA production case studies.
- [ ] Research world-building, modular environments, terrain, foliage, mission scripting, save/load, UI, audio and mobile QA.
- [ ] Complete broader character pipeline research beyond DOGWALK.
- [ ] Build a research-to-BTV traceability matrix: practice → evidence → BTV fit → failure modes/loopholes → acceptance test → status.
- [ ] Continue remaining interaction matrix cases only where the current contract is sufficiently defined.
- [ ] NLI companion adapter and actor-owned lifecycle remain incomplete.
- [ ] Ridgeview mission content has not been implemented.
- [ ] No neutral test asset has been created or imported.
- [ ] No BTV visual/cinematic scene, character rig or animation has been implemented.
- [ ] No Android export/device validation.
- [ ] No merge to main.

## 8. Exact resume point
Resume with two parallel workstreams:
1. Research: continue from Blender Studio DOGWALK production evidence into world/environment art and game-world construction; then mission scripting, UI, audio and QA. Use primary sources and current Godot 4.7 documentation where possible.
2. GitHub: first poll run `42031261816`. Reverify branch head and CI. Then continue test-first review of remaining interaction acceptance cases and NLI lifecycle; inspect each contract before implementation. Keep all work on `btv/test-first-contracts-001`.

## 9. Reconciliation checklist
- [ ] Current branch head still `ddf23c185e95d704413ab275443fa922b2fcee99` or record any newer head.
- [ ] Current head CI status verified before claims.
- [ ] Confirm run 42031119379 remains the latest successful code/test run.
- [ ] Preserve all research sources and caveats.
- [ ] Keep research conclusions proposed, not canon.
- [ ] No merge, destructive operation, paid integration or Android readiness claim.
