# BTV GAME DEVELOPMENT RESEARCH — MILESTONE CHECKPOINT
**Session ID:** 2026-11-05_1243Z_BTV_GAMEDEV_RESEARCH  
**Date:** 5 November 2026  
**Work window covered:** 12:43:09–12:45:51 UTC (2 minutes 42 seconds)  
**Status:** INTERIM MILESTONE — Phase 1 research synthesized; broader research remains open  
**Project:** Beyond the Veil: The Last Watch  
**Branch:** `btv/test-first-contracts-001`  
**Last commit created in this work window:** `066500eabc821ecf6d713f5ddd9bb55e90791fde`  
**Prior commit created in this work window:** `39713df30181bf70699073b717e3cf53c6cb3285`

## 1. User intent and constraints
User asked for an extensive research programme on how games are developed, including production methods, game scenes, environments and the broader game-development process. Use Consensus and research sources beyond Scholar, including current online research. User requested a Perplexity plugin for fresh research.
Constraints carried forward:
- BTV uses Godot 4.x, Android-first, with later PC scalability.
- Prefer free/low-cost sources and tools; no paid API, subscription, credits, purchase or key creation without explicit approval.
- Preserve BTV canon and existing work. Research conclusions remain proposed until explicitly approved.
- Keep evidence types distinct: academic research, official technical docs, developer talks/postmortems, industry surveys, and BTV recommendations.
- No unsupported claims of implementation, tests, device readiness or production readiness.
- Keep discussion of fictional gameplay at high-level design/UX/production level; no real-world weapon-use or attack-replication details.

## 2. Completed in this work window

### A. Continuity protocol
- Read the existing `docs/coordination/SESSION_CONTINUITY_PROTOCOL.md` before continuing.
- Confirmed it requires durable checkpoints at meaningful milestones and exact timestamps.

### B. Consensus academic research
- Dispatched one broad research brief at 12:43:09 UTC.
- Consensus completed with status `idle`.
- Its agent trace reports 90,423 records retrieved, 130 eligible and 20 included in analysis; it read 20 papers (abstracts and PDFs).
- Research topics include small-team production lifecycle, prototypes, level design, environment design, player agency, mission design, character-driven storytelling, and production management.
- Full Consensus document was archived byte-for-byte with citation markers preserved:
  `docs/research/academic/CONSENSUS_GAME_PRODUCTION_RESEARCH_2026-11-05.md`
- Consensus thread: https://consensus.app/search/research-brief-for-beyond-the-veil-the-last-watch-/tWJBRgl1RDCoKJqFlG2WEw/
- Archive commit: `39713df30181bf70699073b717e3cf53c6cb3285`

### C. Industry and practitioner research
- Reviewed the Unity 2026 Game Development Report. It uses a survey of 300 developers collected 16 Sep–3 Oct 2025 plus Unity ecosystem data. It reports a trend toward smaller scopes and more selective/low-fidelity prototyping. Its sample and Unity sponsorship must be considered when applying results.
- Reviewed the GDC 2026 State of the Game Industry public summary, based on more than 2,300 industry professionals.
- Scraped the GDC “Level Design Workshop: Blockmesh and Lighting Tips” (2018), including transcript. It documents context/constraints, rough blockmesh, early gameplay and narrative beats, informal playtesting, iterative layout, art handoff, and continued testing with final art. It covers player affordances, landmarks, entrances, leading lines, texture breadcrumbs, lighting and atmosphere.
- Reviewed Rami Ismail's practitioner guide distinguishing prototypes (should we make this?) from vertical slices (can we reliably produce it?).
- Reviewed The Level Design Book's distinction between functional level design and environment art, including modular asset libraries and art passes.
- Created a Phase 1 synthesis:
  `docs/research/BTV_GAME_DEVELOPMENT_PRACTICE_RESEARCH_PHASE_1_2026-11-05.md`
- Report commit: `066500eabc821ecf6d713f5ddd9bb55e90791fde`

### D. Godot technical research
Reviewed current stable Godot documentation:
- Nodes and Scenes: scenes are reusable trees of nodes.
- Scene Organization: scenes should be self-contained/loosely coupled; dependencies should be explicit rather than relying on brittle external tree assumptions.
- Signals: event-driven communication between nodes.
- AnimationTree: AnimationPlayer stores animation tracks; AnimationTree controls blending/transitions.
- Occlusion culling: useful where geometry meaningfully hides other geometry, especially indoor/closed layouts; can combine with LOD/HLOD but has setup/CPU trade-offs.
- Android export: export setup requirements are not evidence of target-device performance/readiness.
The Phase 1 report contains exact URLs and implications.

### E. Perplexity plugin investigation
- Searched the ChatGPT plugin directory for Perplexity; no matching installable plugin was returned.
- Perplexity's official API platform offers search and agent APIs, but this is a separate API integration, not an installed ChatGPT plugin; it would require credentials and may incur costs.
- No key, integration or paid service was created.
- Firecrawl is already installed and can be used for web search and page extraction. It is a useful research source, not a Perplexity connection.

## 3. Main findings (provisional)
1. Separate disposable prototypes from vertical-slice production validation.
2. Validate the whole level in blockmesh/greybox before expensive art passes.
3. Continue playtesting after art, lighting and audio because visual polish can change readability and flow.
4. Separate functional level design from environment-art tasks, even when one person performs both.
5. Godot scenes should be reusable and loosely coupled, with explicit interfaces/dependencies.
6. Validate character import and animation workflow on a small representative set before scaling content.
7. Optimise based on profiling and target-device tests, not assumptions.
These are research-based proposals, not approved BTV canon or architecture.

## 4. Not completed / open research
- [ ] Comprehensive comparison of production pipelines across indie, AA and AAA.
- [ ] 2025–2026 small-team RPG postmortems and GDC talks.
- [ ] Detailed cinematic scene pipeline: previs, camera, blocking, dialogue, animation, audio, transitions, real-time versus pre-rendered.
- [ ] Environment-art production: concept/reference, modular kits, materials, terrain, foliage, props, set dressing, lighting and integration.
- [ ] Character production: modelling, rigging, retargeting, facial performance, locomotion and companion behaviour.
- [ ] Mission scripting, dialogue, save/load, data-driven content, state management and automated tests.
- [ ] Audio production, spatial audio, ambience and adaptive feedback.
- [ ] UI/UX, touch input, accessibility and mobile readability.
- [ ] Godot renderer trade-offs and device profiling after the actual target device is identified.
- [ ] Independent validation of Consensus citations and strength of evidence.
- [ ] Full evidence-to-BTV traceability matrix with risks, acceptance tests, loophole checks and priority.
- [ ] Latest CI for the current branch head not checked during this research work window.

## 5. Artifacts and links
- Phase 1 research report:
  https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/test-first-contracts-001/docs/research/BTV_GAME_DEVELOPMENT_PRACTICE_RESEARCH_PHASE_1_2026-11-05.md
- Consensus report:
  https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/test-first-contracts-001/docs/research/academic/CONSENSUS_GAME_PRODUCTION_RESEARCH_2026-11-05.md
- Consensus thread:
  https://consensus.app/search/research-brief-for-beyond-the-veil-the-last-watch-/tWJBRgl1RDCoKJqFlG2WEw/
- Branch:
  https://github.com/KINGACEX/beyond-the-veil-last-watch-/tree/btv/test-first-contracts-001

## 6. Tests and verification
- Research document archive: create-file calls returned commit SHAs.
- Consensus document: copied from the completed thread's document field; length 28,108 characters; citation markers retained.
- No code or game scene changes made.
- No automated tests or CI run in this research work window.
- No Android build, export, device or performance test run.

## 7. Next actions — ordered
1. Continue primary-source research on cinematic scenes, animation, environment-art production and small-team RPG postmortems.
2. Inspect full GDC/industry source material rather than relying only on snippets; extract actionable methods and caveats.
3. Cross-check academic claims and classify source strength.
4. Expand the research report into topic-specific chapters with references and BTV relevance.
5. Build a traceability matrix: practice → evidence/source → BTV relevance → risk/loophole → acceptance test → status.
6. Reverify current branch head and CI before any code work.
7. Create another checkpoint after the next meaningful research milestone and a final checkpoint when the research phase is complete.

## 8. Exact resume point
Continue from Phase 1. Do not repeat the completed Consensus search or initial Unity/GDC/Godot research. Next, investigate the detailed production of cinematic/dialogue scenes and environment-art workflows, then small-team RPG postmortems. Keep technical Godot scenes distinct from authored narrative/cinematic scenes.

## 9. Reconciliation checklist
- [ ] Verify branch head and latest CI before coding or making test claims.
- [ ] Preserve Consensus report and inline citation markers.
- [ ] Cross-check sources and distinguish evidence from practitioner opinion.
- [ ] Keep recommendations marked proposed until user approval.
- [ ] No canon or architecture change without authority.
- [ ] No paid API/key/purchase without explicit approval.
- [ ] No target-device readiness claim until the device is verified and tested.
