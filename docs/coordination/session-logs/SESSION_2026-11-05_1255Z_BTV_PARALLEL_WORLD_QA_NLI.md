# BTV PARALLEL RESEARCH + ENGINEERING CHECKPOINT — WORLD, QA AND NLI
**Session ID:** 2026-11-05_1255Z_BTV_PARALLEL_CONTINUATION  
**Date:** 5 November 2026  
**Work window:** 12:55:53–12:59:50 UTC (3 minutes 57 seconds)  
**Status:** INTERIM MILESTONE — world/environment, navigation, save/QA research added; second NLI request-gate defect fixed and CI passed  
**Project:** Beyond the Veil: The Last Watch  
**Branch:** `btv/test-first-contracts-001`  
**Branch head at checkpoint:** `82741fb965596fa5e7ef0fb5feb7606c0b2f625d`

## 1. User intent and constraints
User asked to continue research and GitHub engineering simultaneously. Both workstreams continued in parallel.
- Research: professional world/environment construction, navigation/region boundaries, save/load, automated gameplay testing and QA.
- GitHub: continued test-first inspection of the NLI request lifecycle and updated implementation/research documentation.

Carry forward:
- No merge to main; all changes remain isolated on `btv/test-first-contracts-001`.
- Research conclusions are proposals, not BTV canon or approved architecture.
- Preserve source documents and existing implementation.
- Free/low-cost tools first; no paid API, asset, subscription or key.
- No Android readiness claim without physical-device evidence.
- Headless CI is not visual/manual/device validation.
- Continue automatic checkpointing at substantial milestones.

## 2. Research completed in this window

### A. World construction and environment art
Created:
`docs/research/BTV_WORLD_CONSTRUCTION_AND_ENVIRONMENT_ART_RESEARCH_2026-11-05.md`

Evidence reviewed:
- GDC 2024 “Diablo IV: The Art of Open World Sanctuary” official session listing and speaker-associated slides.
- GDC 2023 “Building a Next Gen World with a Small Environment Team” official session abstract.
- Jobye Karmaker's public “Approaching Modular Vegetation in Games” talk/transcript.
- Previously reviewed GDC blockmesh workshop and Level Design Book.

Key provisional findings:
- World art progresses through blockout, presentable and shippable phases; art changes require renewed traversal/readability tests.
- Open-world production distinguishes points of interest from wilderness/interstitial spaces.
- Navigation boundaries, road-to-wilderness material transitions and landmarks should be readable.
- Vegetation is not one generic asset category; trees, gameplay shrubs and ground foliage have different visual, navigation and performance roles.
- The Karmaker case describes one dedicated vegetation artist working across five open-world levels under a 12-month constraint; this is a bounded case, not a production estimate for BTV.
- GDC Callisto Protocol talk page identifies modularity, materials, scan data and marketplace use as topics, but the full presentation was not accessed.

### B. Godot 4.7 world navigation and region boundaries
Created:
`docs/research/BTV_GODOT_WORLD_NAVIGATION_AND_REGION_BOUNDARY_RESEARCH_2026-11-05.md`

Reviewed official Godot 4.7 docs for NavigationServer3D, NavigationRegion3D, NavigationAgent3D, navmesh baking and region connections.
Key findings:
- Navigation maps contain regions; regions can be enabled/disabled and connected by edge proximity.
- Baking can run in a background thread, but source-geometry parsing can still be a runtime cost.
- Simplified collision/navigation geometry is preferable to parsing every decorative visual mesh.
- Overlapping regions and unnecessary forced immediate map updates can create correctness/performance problems.
- BTV world-streaming and navigation partitioning architecture remains undecided.

### C. Save/load, automated testing and QA
Created:
`docs/research/BTV_SAVE_LOAD_AUTOMATED_TESTING_AND_QA_RESEARCH_2026-11-05.md`

Reviewed:
- Official Godot 4.7 Saving Games tutorial.
- GDC 2015 “The Vertical Slice Challenge” session description.
- Rare's “Automated Testing of Gameplay Features in Sea of Thieves” public GDC talk.
- RETO MOTO's “A QA Perspective on Live Game Production” public GDC talk.

Key findings:
- Persistent state should be explicitly identified; do not serialize arbitrary runtime scene-tree state.
- Save schemas need identity, versioning, validation, migration and recovery rules.
- ConfigFile is for configuration, not a substitute for a full game-state design.
- Automated tests help catch interaction regressions in complex systems; test fixtures must reproduce conditions that can trigger the defect.
- QA requirements evolve from prototype validation to vertical-slice proof, content regression, release and platform validation.
- BTV save format, slots and auto-save policy remain unapproved and unimplemented.

## 3. GitHub engineering completed

### A. Interaction regression follow-up
Previous work in the ongoing parallel workstream remains confirmed:
- Temporarily disabled interactables are retained in the nearby set so they can become eligible again without leaving/re-entering range.
- Interaction IDs are normalized consistently using whitespace trimming.
- IDs equal after whitespace normalization are rejected as duplicates.
- Case-only ID comparison receives deterministic exact-string secondary ordering.

Tests:
- disabled target re-enabled in range;
- whitespace-padded ID normalization;
- normalized duplicate IDs;
- case-only ID deterministic tie-break.

Acceptance matrix now has 28 cases; INT-025–INT-028 added.

Successful CI evidence:
- Run `42031487569` on commit `85ba8e7dcff22b33a1b62ad6214b98e7aaa92539` passed the interaction acceptance suite, including INT-028.
- Run `42031646069` on commit `67b799558b4a7690275dfb383b3a23e7cb8599cc` also passed the full configured workflow.

### B. NLI request-gate defect — test first
Inspected:
- `scripts/nli/nli_service.gd`
- `scripts/nli/nli_knowledge_base.gd`
- `scripts/nli/nli_request_gate.gd`
- `tests/nli_contract_test.gd`

Found inconsistency:
- `begin_request`, `complete_request` and `cancel_request` trimmed request IDs.
- `is_pending`, `is_completed` and `is_cancelled` did not.
- Equivalent IDs with surrounding whitespace therefore behaved inconsistently across state-changing and read-only methods.

Regression tests added first:
- pending lookup normalizes ID;
- completed lookup normalizes ID;
- cancelled lookup normalizes ID.

Initial test-first CI run `42031539741` failed on exactly those three state-query assertions while begin/complete/cancel operations passed.

Correction:
- all three read-only query methods now apply `strip_edges()`.
- Fix commit: `67b799558b4a7690275dfb383b3a23e7cb8599cc`.
- CI run `42031646069` passed on that commit.

This does not complete NLI companion actor lifecycle, persistence, timeout/expiry, stale callbacks or cryptographic source-hash verification.

## 4. CI and repository state
- Current branch head: `82741fb965596fa5e7ef0fb5feb7606c0b2f625d`.
- Previous latest successful code/test run: `42031646069` on `67b799558b4a7690275dfb383b3a23e7cb8599cc`.
- Research-only commit `3cf8161c4cad7a825ec3074346ca2b35b87224d5` passed CI run `42031765833`.
- README update commit `60c90bfa8080b6e09e343ae2523906936200754c` had run `42031814183` in progress at checkpoint time.
- Status-document update commit `81b1116c73b62feaa3e1ff27cb05b6e340888667` had a run cancelled by a subsequent push.
- Latest NLI contract documentation commit `82741fb965596fa5e7ef0fb5feb7606c0b2f625d` may have a new run not yet visible. Poll the latest Actions run before reporting current-head CI.
- No merge to main.
- No Android export, editor visual inspection, touch device testing or physical-device performance test.

## 5. Documentation updated
- Root README includes world construction, navigation and save/QA research links.
- `docs/implementation/BOOTSTRAP_STATUS.md` updated for 28 interaction cases and NLI request-state lookup normalization.
- `docs/implementation/NLI_003_HANDOFF_AND_SOURCE_REGISTRY_CONTRACT.md` now records the request-ID regression, fix and CI evidence.
- All changes remain on the isolated branch.

## 6. Not completed / open
- [ ] Poll CI for current branch head `82741fb965596fa5e7ef0fb5feb7606c0b2f625d`.
- [ ] Continue research into mission scripting, dialogue systems, UI/UX, touch accessibility, audio and cinematic integration.
- [ ] Build a research-to-BTV traceability matrix: practice → evidence → BTV fit → loopholes/failure modes → acceptance tests → status.
- [ ] Complete remaining interaction matrix cases only where their contracts are sufficiently defined.
- [ ] NLI companion adapter and actor-owned lifecycle remain incomplete.
- [ ] Source-registry persistence, hash verification and version invalidation remain incomplete.
- [ ] Ridgeview mission content has not been implemented.
- [ ] No neutral Blender/Godot test asset has been created/imported.
- [ ] No save/load system has been implemented.
- [ ] No new game scene, environment art, character rig or animation has been implemented.
- [ ] No Android export/device validation.
- [ ] No merge to main.

## 7. Exact resume point
Continue with two parallel workstreams:
1. **Research:** use the saved world-construction, navigation and save/QA chapters as completed baselines. Continue with mission scripting, dialogue, UI/accessibility, audio and cinematic systems. Prefer primary developer talks and Godot 4.7 official docs; mark paywalled/abstract-only sources clearly.
2. **GitHub:** poll current head CI first. Then continue test-first NLI lifecycle review, especially adapter ownership, duplicate/stale callbacks, cancellation, timeout/expiry and persistence. Do not mark actor acceptance or execution until the companion actor explicitly owns those states.

## 8. Reconciliation checklist
- [ ] Reverify current branch head and latest CI.
- [ ] Keep tests and acceptance matrix synchronized.
- [ ] Preserve all research source limitations.
- [ ] No canon or architecture changes from research alone.
- [ ] No paid integrations/assets/services.
- [ ] No Android readiness claims without target-device tests.
- [ ] No merge to main without explicit approval.
