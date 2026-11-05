# BTV GAME DEVELOPMENT PRACTICE RESEARCH — PHASE 1
**Date:** 5 November 2026  
**Status:** PARTIAL RESEARCH — not a final industry survey or approved BTV specification  
**Project:** Beyond the Veil: The Last Watch  
**Research method:** Consensus academic synthesis, GDC developer material, practitioner production guides, official Godot documentation, current industry reports, and web research.  
**Scope note:** “Scene” is treated in two separate senses: (1) Godot's technical scene/node architecture and (2) authored playable/cinematic scenes in the game.

## 1. Executive findings

The strongest cross-source production principle is to validate the player experience and production pipeline before scaling content. The evidence does not support building a large world, detailed assets, or many narrative scenes before the core loop, level flow, and content-production process are demonstrated.

For BTV, the research points toward a controlled sequence:
1. Lock a small, testable feature question.
2. Prototype it cheaply and independently.
3. Validate the intended player experience with a playable blockout.
4. Integrate one representative end-to-end vertical slice.
5. Measure how long and how reliably the second comparable content unit can be produced.
6. Scale only after the workflow, quality bar, and technical budget are understood.

This is a proposed production approach, not a change to the BTV canon or approved scope.

## 2. Production lifecycle: prototypes are not vertical slices

### Academic evidence
The Consensus synthesis reviewed research on small-team development, level design, project management, prototyping and player agency. It reports:
- A 2023 small-team game-development lifecycle proposal uses four macro-stages: pre-production, production, testing and release, with agile/sprint-like iteration inside production and testing.
- A 2025 survey study of digital-games project management reports Scrum and Kanban as common methods, with design documents, prototypes and Kanban boards used as coordination artifacts.
- A 2022 study of a game accelerator found that rapid prototype output did not guarantee released games; its case study recorded 42 prototypes by week six and no releases by the one-year deadline. This is a bounded case, not a universal failure rate.
- Research on level design describes it as interdisciplinary, relying on coordination among design, narrative, art, audio and tools.

### Practitioner production guidance
Rami Ismail's production guide distinguishes:
- **Prototype:** answer whether a mechanic, visual idea, or game premise should be developed. It can be rough, isolated and disposable.
- **Vertical slice:** test whether the team can produce the game at the intended quality and through a repeatable pipeline.
- **Production:** repeat the validated pipeline.
The guide also outlines Alpha (feature complete), Beta (content complete), Release Candidate and Release as separate milestones.

Source: https://ltpf.ramiismail.com/prototypes-and-vertical-slice/

### Implication for BTV
Do not confuse “a feature works in isolation” with “the project can reliably produce it at final quality.” BTV's recovered Vertical Slice v1.0 is the narrative/experience target; the engineering vertical slice must also validate the actual Godot scene, art, audio, UI, save/load, test and device workflow. Keep the two meanings explicit in status reports.

## 3. How developers construct playable levels and scenes

A GDC workshop by Naughty Dog designer David Shaver and NYU professor Robert Yang explains a production pattern:
1. Establish the level's context and constraints: environment type, time of day, story location, available character abilities, and intended gameplay/narrative beats.
2. Build a rough blockmesh/greybox of the whole level to understand scale and pacing.
3. Stub in gameplay and narrative beats early.
4. Let other people play the rough version; observe where they become confused or take unexpected routes.
5. Iterate the layout.
6. Hand the more stable layout to the art team.
7. Continue playtesting with final art because artistic changes can alter readability and flow.

The talk emphasises that blockmesh can include simple colour and lighting, not just unshaded geometry. It also covers affordances, landmarks, entrances, gates, leading lines, texture breadcrumbs, lighting, and atmosphere as tools for natural navigation and player comprehension.

Primary source: GDC, “Level Design Workshop: Blockmesh and Lighting Tips” (2018), transcript and video:
https://www.youtube.com/watch?v=09r1B9cVEQY

### Practical scene-building pipeline
For BTV, each mission area should move through these distinct passes:
- **Brief:** player purpose, story beat, boundaries, time/weather, required mechanics, intended mood, accessibility/readability constraints, target device budget.
- **Layout:** route, spaces, sightlines, landmarks, entrances/exits, safe/recovery areas, optional spaces and boundaries.
- **Greybox:** simple geometry and placeholder props; test scale, traversal, timing and navigation.
- **Beat pass:** place objectives, discoveries, character moments, interactive objects and narrative transitions in the playable layout.
- **Playtest:** observe first-time players; record confusion, missed cues, accidental routes, pacing problems and interaction failures.
- **Environment art pass:** modular architecture, terrain, props, materials, foliage, decals and set dressing; preserve the validated gameplay.
- **Lighting/atmosphere pass:** establish focal points, mood, depth and route readability; test on target hardware and at typical mobile viewing conditions.
- **Audio pass:** ambience, location identity, important feedback and transitions.
- **Integration/QA pass:** verify interactions, navigation, performance, save/reload and all intended routes.
- **Polish:** only after the previous gates pass.

This is a proposed workflow synthesized from the GDC talk, practitioner guide and academic findings; it is not a rigid universal sequence.

## 4. Level design versus environment art

The Level Design Book distinguishes:
- **Functional level design:** shaping player behaviour through layouts, blockouts, playtests, route/encounter balance and spatial structure.
- **Environment art:** creating or assembling modules, props, materials, textures, set dressing and lighting to refine the level's visual appearance while preserving core function.

It notes that larger studios often separate these responsibilities, while small teams must share responsibilities and communicate more directly.

Sources:
- https://book.leveldesignbook.com/introduction
- https://book.leveldesignbook.com/process/env-art

### BTV implication
The same person may perform several roles, but the work should still be separated into explicit passes. Avoid decorating a level before its route and gameplay are validated. Environment art is not merely decoration: it should reinforce navigation, setting, mood and story while never obscuring interactable objects or essential information.

## 5. Two meanings of “scene” in Godot

### A. Technical scene architecture
Godot's official documentation defines a scene as a tree of nodes that can be saved and instantiated in other scenes. A project is composed from reusable scenes.

Godot's scene-organization guidance recommends that scenes be as self-contained and loosely coupled as possible. When a child scene needs outside context, the parent should provide that dependency through an explicit interface (for example, a signal, method, callable, object reference or path), rather than the child assuming a specific external tree structure.

Sources:
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/nodes_and_scenes.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html

### BTV design implication
Potential scene boundaries to evaluate (not yet approved architecture):
- player character;
- companion character;
- reusable interactable;
- NPC;
- mission area/region;
- UI panels;
- dialogue/cinematic sequence;
- audio/ambience zone;
- mission-specific objective/evidence actor.

Each reusable scene should define what it owns, what data it needs, what signals it emits, what it can request from its parent, and what happens when dependencies are missing or destroyed. Avoid global singletons becoming hidden dependencies for every feature.

### B. Authored playable/cinematic scenes
A dramatic scene is not just a camera angle or a cutscene. It is a coordinated sequence of player context, staging, character performance, environment, lighting, sound, timing, transitions and control handoff.

Current research located developer talks on game cinematics and environment production, but this first phase has not yet completed a full comparative review of cinematic pipelines, camera systems, motion capture, dialogue staging or real-time versus pre-rendered sequences. These remain open research tasks.

## 6. Character animation pipeline in Godot

Godot's AnimationTree documentation states:
- AnimationPlayer stores/plays the animation tracks.
- AnimationTree controls advanced transitions and blending using animations from the linked AnimationPlayer.
- Imported 3D scenes can contain an AnimationPlayer; a wrapper/player scene can instance the imported character and add an AnimationTree that references it.
- Blend spaces and state-machine-style animation graphs support blended movement states and transitions.

Source: https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html

### BTV implication
Do not build a large bespoke animation framework before validating the imported character rig and a small representative animation set. First test import scale, skeleton mapping, retargeting needs, animation naming, looping, root-motion policy, transition quality and actual runtime cost. Character and companion animation pipelines should be separately validated; do not assume the same rig, movement logic or animation requirements.

## 7. 3D performance and scene visibility

Godot's official occlusion-culling guidance:
- Occlusion culling can prevent hidden geometry from being rendered.
- It is most useful in indoor/closed layouts with walls and many smaller rooms.
- It can be combined with mesh LOD and visibility ranges/HLOD.
- It has setup and CPU costs; it may not be worthwhile in scenes with few useful occlusion opportunities.
- Godot notes that occlusion culling can have particularly useful benefits with the Mobile renderer because that renderer does not use the same depth prepass as Forward+.

Source: https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html

The Godot feature list describes the Mobile renderer as having fewer features but being suited to mobile and desktop, with a different rendering backend and limits that should be considered during scene design.

Source: https://docs.godotengine.org/en/stable/about/list_of_features.html

### BTV implication
Design level geometry and asset density with visibility in mind, but do not blindly enable every optimisation. Profile representative scenes. Enclosed interiors may benefit from occlusion culling; broad outdoor Ridgeview-style spaces may need different tactics, such as sensible view distances, LOD/HLOD, simplified distant detail and controlled foliage density. Measure rather than assume.

## 8. Android export is not Android readiness

Godot's Android export documentation currently specifies a Java/Android SDK toolchain and signing/export configuration. It lists OpenJDK 17 as the recommended JDK and gives SDK/NDK package requirements for the current stable documentation. This is a build-tool requirement, not proof that a game performs acceptably on a particular phone.

Source: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

### BTV implication
Keep the previously agreed platform gate: identify the actual target device and operating constraints before renderer selection, export validation or performance claims. A successful export does not prove acceptable frame time, thermal behaviour, memory use, input feel or stability on the target phone.

## 9. Industry trends: 2026 reports

### Unity 2026 Game Development Report
The report draws on a Cint survey of 300 developers conducted 16 September–3 October 2025, plus Unity ecosystem data. It reports:
- 52% said their studio is focusing on smaller, more manageable projects.
- 48% became more selective about which prototypes to pursue.
- 26% increased low-fidelity prototyping.
- 17% shortened prototyping to reduce upfront cost/risk.
- 46% said prototyping typically takes 1–3 months; 21% said under a month.
- AI use varied by task; coding assistance was the most commonly reported use in the report's sample.

Source: https://unity.com/resources/gaming-report

Limitations: Unity-sponsored research; only 300 survey respondents; the survey is not a census of all developers and should not be treated as Godot-specific. Use the findings as directional context, not as fixed production deadlines.

### GDC 2026 State of the Game Industry
GDC reports responses from more than 2,300 game-industry professionals. Its public summary reports engine, platform and AI-use trends and notes that AI use differs significantly by role and type of employer.

Source: https://gdconf.com/article/gdc-2026-state-of-the-game-industry-reveals-impact-of-layoffs-generative-ai-and-more/

Limitations: responses span different roles and company types; do not apply overall percentages to a tiny independent project without checking the relevant respondent subset.

## 10. Initial research-based recommendations for BTV

These are **PROPOSED**, not approved canon or architecture:
1. Keep the first playable scope narrow and testable.
2. Separate disposable prototypes from production-quality vertical-slice work.
3. Validate one representative environment from brief to greybox to art/audio/QA before scaling regions.
4. Treat level design and environment art as distinct passes even when the same developer performs both.
5. Use natural navigation cues—landmarks, sightlines, lighting, colour, texture and audio—without relying exclusively on HUD arrows.
6. Keep Godot scenes self-contained and loosely coupled; define explicit contracts at scene boundaries.
7. Validate the actual imported character rig and animation pipeline before expanding character content.
8. Profile scenes on the actual target device; do not optimise by folklore or desktop-only measurements.
9. Use source-of-truth documents and acceptance tests to control scope and prevent features from drifting away from the approved vertical slice.
10. Treat all research conclusions as provisional until triangulated with multiple primary sources and tested against BTV's real constraints.

## 11. Research gaps — not yet complete
- Full comparative analysis of production pipelines at indie, AA and AAA scale.
- Current 2025–2026 developer postmortems and GDC talks, including production lessons from small-team 3D RPGs.
- Detailed cinematic workflow: storyboards, previs, blocking, camera language, dialogue scenes, animation, audio, transitions and runtime constraints.
- Environment art workflow details: concept/reference, modular kits, trim sheets, materials, foliage, terrain, set dressing, lighting, asset budgets and integration.
- Character pipeline: modelling, topology, UVs, rigging, retargeting, facial animation, locomotion and companion performance.
- Mission scripting, dialogue systems, save/load, data-driven content, state management and automated tests.
- Audio implementation, spatial audio, mixing, adaptive ambience and feedback.
- UI/UX, touch interaction, accessibility and readability at mobile screen sizes.
- Godot renderer trade-offs and mobile profiling on a known target device.
- Independent cross-check of all Consensus paper claims and source quality.
- A final evidence-to-BTV traceability matrix with risks, loophole checks, acceptance tests and implementation priorities.

## 12. Research sources index
### Academic synthesis
- Consensus full report archived separately: `docs/research/academic/CONSENSUS_GAME_PRODUCTION_RESEARCH_2026-11-05.md`
- Thread: https://consensus.app/search/research-brief-for-beyond-the-veil-the-last-watch-/tWJBRgl1RDCoKJqFlG2WEw/

### Developer and practitioner sources
- GDC Blockmesh and Lighting Tips (2018): https://www.youtube.com/watch?v=09r1B9cVEQY
- Rami Ismail, Prototypes & Vertical Slice: https://ltpf.ramiismail.com/prototypes-and-vertical-slice/
- The Level Design Book, introduction: https://book.leveldesignbook.com/introduction
- The Level Design Book, environment art: https://book.leveldesignbook.com/process/env-art
- GDC Vault: https://gdcvault.com/

### Official technical documentation
- Godot Nodes and Scenes: https://docs.godotengine.org/en/stable/getting_started/step_by_step/nodes_and_scenes.html
- Godot Scene Organization: https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- Godot Signals: https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
- Godot AnimationTree: https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html
- Godot Occlusion Culling: https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html
- Godot Feature List: https://docs.godotengine.org/en/stable/about/list_of_features.html
- Godot Android Export: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

### Industry reports
- Unity 2026 Game Development Report: https://unity.com/resources/gaming-report
- GDC 2026 State of the Game Industry: https://gdconf.com/article/gdc-2026-state-of-the-game-industry-reveals-impact-of-layoffs-generative-ai-and-more/

## 13. Status
This is **Phase 1** of a larger research programme. It is not exhaustive, it does not certify BTV's technical architecture, and it does not authorize changes to canon or scope. Continue research before final recommendations.
