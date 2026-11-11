# BTV GAME DEVELOPMENT RESEARCH — GODOT POSTMORTEM MILESTONE
**Session ID:** 2026-11-05_1243Z_BTV_GAMEDEV_RESEARCH  
**Date:** 5 November 2026  
**Work window covered:** 12:43:09–12:47:46 UTC (4 minutes 37 seconds)  
**Status:** INTERIM MILESTONE — added a real-world Godot 3D solo-developer postmortem  
**Project:** Beyond the Veil: The Last Watch  
**Branch:** `btv/test-first-contracts-001`  
**Latest commit created in this window:** `bd82d72dbc250ae85b457adc0fda4d79259dee30`

## 1. User intent and constraints
User requested comprehensive research into how games are made: production, scenes, environments, characters, technical systems and other disciplines. Use Consensus, current web research, developer talks/postmortems and sources beyond Scholar. User asked for a Perplexity plugin.
Constraints:
- Godot 4.x, Android-first, later PC scalability.
- Prefer free/low-cost research and tools; no paid API credentials, keys, subscriptions, purchases or credits without explicit approval.
- Research findings are not approved BTV canon or architecture.
- Separate academic evidence, practitioner accounts, official documentation, industry surveys and BTV proposals.
- Do not claim implementation, tests, builds, platform readiness or device performance without evidence.
- Keep game-related discussion to safe high-level production, design, UX and QA; do not provide real-world weapon-use or attack-replication details.

## 2. Completed research in this window

### A. Consensus academic synthesis
- Research thread completed.
- Agent trace: 90,423 records retrieved, 130 eligible, 20 included; 20 papers read (abstracts and PDFs).
- Exact report archived with citations:
  `docs/research/academic/CONSENSUS_GAME_PRODUCTION_RESEARCH_2026-11-05.md`
- Commit: `39713df30181bf70699073b717e3cf53c6cb3285`
- Thread: https://consensus.app/search/research-brief-for-beyond-the-veil-the-last-watch-/tWJBRgl1RDCoKJqFlG2WEw/

### B. Industry and developer workflow research
- Unity 2026 Game Development Report reviewed (survey of 300 developers, 16 Sep–3 Oct 2025 plus Unity ecosystem data).
- GDC 2026 State of the Game Industry summary reviewed (more than 2,300 industry professionals).
- GDC Blockmesh and Lighting Tips (2018) transcript reviewed: context/constraints → blockmesh → gameplay/story beats → playtest → iterate → art handoff → continue testing with art.
- Rami Ismail's prototype/vertical-slice distinction reviewed.
- The Level Design Book reviewed for level design versus environment art.
- Phase 1 report:
  `docs/research/BTV_GAME_DEVELOPMENT_PRACTICE_RESEARCH_PHASE_1_2026-11-05.md`
- Commit: `066500eabc821ecf6d713f5ddd9bb55e90791fde`

### C. Cinematic environment research
- GDC 2017 Naughty Dog case study “Cinematic Environment Production for Uncharted 4” reviewed with public transcript.
- Key lessons: environments contribute to story; composition, character spacing, shape/line language, framing, lighting and props influence how a scene is understood.
- Talk's workflow: assignment/concept → blockmesh and animation → previs/advanced blocking → lighting/assets → integration/polish.
- Chapter:
  `docs/research/BTV_CINEMATIC_AND_NARRATIVE_ENVIRONMENT_RESEARCH_2026-11-05.md`
- Commit: `b0214a3e28e7d5dd5909cf94dad4b4ab3418ed67`

### D. Godot technical documentation
Reviewed nodes/scenes, scene organization, signals, AnimationTree, occlusion culling, LOD/HLOD, profiler, Android export and renderer documentation. Main findings recorded in Phase 1 report:
- Build reusable scene trees from self-contained, loosely coupled components.
- AnimationPlayer stores animation tracks; AnimationTree handles blending/transitions.
- Occlusion culling/LOD must be selected by geometry and measured performance.
- Android export success is not target-device readiness.

### E. Godot 3D solo-developer postmortem
- Reviewed Pantopie Studio's first-person 3D game postmortem “Releasing a 3D game with Godot Engine”:
  https://pantopie.studio/releasing-a-3d-game-with-godot-engine/
- Author reports using Godot 4.3/4.4 and being mostly solo.
- Reported friction: C# setup/compile/launch/profiling workflow, direct Blender `.blend` imports, editor crashes, scene/project integrity problems, 3D editor selection/gizmo workflow, performance optimisation and audio feature gaps.
- Author reports Git version control protected against project data loss; author moved toward glTF export and planned GDScript for the next project.
- Important limitation: this is one first-person account, not a controlled study; several issues may have changed in later engine versions.
- Dedicated report:
  `docs/research/BTV_GODOT_3D_SMALL_TEAM_POSTMORTEM_RESEARCH_2026-11-05.md`
- Commit: `bd82d72dbc250ae85b457adc0fda4d79259dee30`

### F. Godot version verification
Official sources show:
- Godot 4.7 stable released 18 June 2026.
- Godot 4.7.1 stable released 14 July 2026.
- Godot 4.7.2 stable released 18 August 2026.
- Godot 4.8 beta 2 released 29 October 2026.
As of this checkpoint, 4.7.2 is the current stable release; 4.8 is beta. This does NOT approve pinning or migrating BTV. Inspect the actual project, plugins, imports and CI before deciding.
Sources:
- https://godotengine.org/download/archive/
- https://docs.godotengine.org/en/stable/about/release_policy.html
- https://godotengine.org/article/maintenance-release-godot-4-7-2/
- https://github.com/godotengine/godot/releases

### G. Perplexity plugin investigation
- ChatGPT plugin directory search for Perplexity returned no matching plugin.
- Perplexity API platform is a separate integration requiring credentials and may incur costs.
- No API key or paid integration created.
- Firecrawl is already connected and is being used for fresh web search and page extraction; it is not a Perplexity connector.

## 3. Provisional findings
1. Keep disposable prototypes distinct from vertical-slice production validation.
2. Greybox and playtest before expensive environment art.
3. Continue testing after art, lighting and audio because those passes can alter readability.
4. Treat cinematic staging as a system: story beat, actor blocking, camera, environment, lighting, animation, audio and control handoff.
5. Use reusable, self-contained Godot scenes with explicit dependencies.
6. Keep version control from the beginning; do not rely on editor undo/history as the only recovery path.
7. Test asset import/export and language workflow early with a small representative project.
8. Profile and optimise using actual target-device evidence.
9. 4.7.2 is current stable, but engine version selection remains unapproved/unpinned.
These are proposed research conclusions, not BTV canon or approved architecture.

## 4. Not completed
- [ ] Compare several small-team 3D game postmortems, not only one.
- [ ] Review current 2024–2026 indie RPG production case studies.
- [ ] Character art, rigging, retargeting, animation and companion pipeline.
- [ ] Modular environment asset workflow and Blender-to-Godot validation.
- [ ] Dialogue, mission scripting, save/load, data-driven content and automated QA.
- [ ] Audio production, spatial audio and adaptive ambience.
- [ ] UI/UX, touch interaction, accessibility and mobile readability.
- [ ] Godot renderer trade-offs and target-device profiling after device is verified.
- [ ] Independent validation of Consensus paper quality and claims.
- [ ] Final evidence-to-BTV traceability matrix with risks, loophole checks and acceptance tests.
- [ ] Current branch head/latest CI not checked during this research work window.
- [ ] No BTV code, game scene, art asset, animation, audio or build was implemented.

## 5. Artifacts
- Phase 1 research report:
  https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/test-first-contracts-001/docs/research/BTV_GAME_DEVELOPMENT_PRACTICE_RESEARCH_PHASE_1_2026-11-05.md
- Consensus report:
  https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/test-first-contracts-001/docs/research/academic/CONSENSUS_GAME_PRODUCTION_RESEARCH_2026-11-05.md
- Cinematic environment chapter:
  https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/test-first-contracts-001/docs/research/BTV_CINEMATIC_AND_NARRATIVE_ENVIRONMENT_RESEARCH_2026-11-05.md
- Godot 3D postmortem:
  https://github.com/KINGACEX/beyond-the-veil-last-watch-/blob/btv/test-first-contracts-001/docs/research/BTV_GODOT_3D_SMALL_TEAM_POSTMORTEM_RESEARCH_2026-11-05.md
- Branch:
  https://github.com/KINGACEX/beyond-the-veil-last-watch-/tree/btv/test-first-contracts-001

## 6. Next actions
1. Find and compare additional Godot/indie 3D production case studies and postmortems.
2. Research Blender-to-Godot asset pipeline against official docs and independent studio workflows.
3. Research character rigging/animation and companion behaviour pipelines.
4. Research UI, audio, save/load and QA systems.
5. Build a traceability matrix: production practice → source/evidence → BTV fit → failure modes/loopholes → acceptance test → status.
6. Before any engineering, verify branch head and latest CI; no code changes are authorized by this research alone.
7. Create another checkpoint at the next substantial milestone and a final one at research completion.

## 7. Exact resume point
Continue with additional small-team/indie 3D production case studies and character/asset pipelines. Do not repeat the completed Consensus synthesis, Unity/GDC reports, initial Godot docs, Uncharted 4 cinematic case study or Trigger of Time postmortem unless newer evidence materially changes them.

## 8. Reconciliation checklist
- [ ] Verify current branch and CI before coding.
- [ ] Preserve academic citation markers.
- [ ] Distinguish single-developer experience from general engine behaviour.
- [ ] Keep 4.7.2 as a candidate baseline only; no migration/pinning decision yet.
- [ ] No unapproved canon or architecture changes.
- [ ] No paid Perplexity API integration.
- [ ] No Android readiness claim without target-device testing.
