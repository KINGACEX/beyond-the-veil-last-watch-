# BTV Prototype Layout and Feel Plan 001

**Status:** DESIGN PLAN — CURRENT PLAYABLE SCENE IS BASIC GREYBOX; VISUAL PRODUCTION NOT STARTED; GAMEPLAY CONSTRUCTION HELD UNTIL CONTROL RELIABILITY IS DEMONSTRATED  
**Engine baseline:** Godot 4.7.2  
**Platform order:** Android first; PC scalability later  
**Visual direction:** Cinematic semi-realism, staged through a measurable greybox-to-presentable pipeline  
**Authority:** BTV Master Canon, specialist Bibles and the locked Vertical Slice Specification

## 0. Mandatory research and planning gate

This plan is governed by the standing [BTV Research, Planning and Execution Governance Standard](../coordination/BTV_RESEARCH_PLANNING_AND_EXECUTION_GOVERNANCE_v1.0.md). The initial [Controls, Physics and Android Research Deep Dive](../research/BTV_CONTROLS_PHYSICS_ANDROID_RESEARCH_DEEP_DIVE_001_2026-11-09.md) records the first source audit, official Godot/Android findings, touch-camera correction and neutral-lab research decisions. Before any further block or system below is implemented, complete the applicable research sweep, deep dives, alternatives analysis, resource plan, risk register, work breakdown, approval check and verification plan. The current layout sequence is a proposed direction, not permission to skip that work. In particular, renderer selection, target hardware, art pipeline, physics values and ability mechanics require evidence-led investigation before commitment.

## 1. Purpose

Define the first playable prototype layout and its implementation order without silently expanding BTV canon. The existing playable scene is still a basic greybox. The visual-production phase has not started. This plan is a forward sequence, not a claim that cinematic visuals, refined physics, animation, abilities, HUD or Android performance already exist.

The first playable experience must prove the approved Ridgeview vertical slice: ordinary life before danger, a credible investigation, uncertain evidence, consequential choices, and faith expressed through character and story rather than a gameplay resource.

## 2. Non-negotiable design constraints

- Asher Vance is human, presented as 18, the sole playable protagonist and a Watcher Agent/Specialist. His movement and physical abilities remain grounded.
- Logos Rhema Temple is a fictional church and never a Covenant base. The congregation does not know Asher's Covenant affiliation.
- Communion is contextual and has no gameplay buffs, stats, currency, XP or progression.
- Prayer, Scripture, the Holy Spirit and faith are never power meters, consumables, spells, combat resources or reward currencies.
- The Ridgeview threat is not named or visually identified. The slice remains non-graphic; no gore or graphic remains.
- Ember is an intelligent animal companion, not a weapon or automatic clue solver. Its five approved abilities and seven commands must respect their established limits.
- The five Ridgeview response options remain Speak/Preach, Investigate, Rescue, Defend and Withdraw. None awards XP or morality points.
- No new character identity, Ember species, supernatural rule, divine manifestation, enemy design or mission outcome is invented in implementation.
- The named reference games inform high-level craft study only. No copied characters, environments, UI, effects, music or protected assets.

## 3. Prototype sequence and scene map

The full slice is modular. Build and validate one small block at a time.

### Block 0 — Neutral movement and camera lab (first implementation after controls gate)
A canon-neutral test space containing:
- flat ground, marked distances, ramps and stairs;
- a few walls, corners, doorways and collision obstacles;
- a neutral mannequin with no Asher identity;
- camera distance/height markers and a fixed test route;
- a small interaction target;
- debug readouts for velocity, grounded state, camera pitch and input vector.

Purpose: tune movement, collision, turning, camera and touch response without level art hiding defects.

### Block 1 — Ridgeview approach and perimeter
A compact outdoor blockout:
- access road and screened arrival pull-off;
- readable approach route with a few alternate sightlines;
- watched perimeter and abandoned belongings;
- parked work vehicle and visible toolkit;
- a clear transition from road to settlement edge.

The layout must support careful observation, environmental storytelling and retreat. It must not reveal the full threat or turn the approach into a combat arena.

### Block 2 — Ridgeview settlement
A small, coherent settlement blockout:
- central shared space;
- several occupied structures with distinct entrances and sightlines;
- a route to speak with residents;
- an outlying route toward the camp;
- space for Wren's private conversation;
- Dorian Pike's location and a non-forced approach;
- clear return paths and safe navigation.

Civilian life and individual routines must be more visible than combat staging. Do not place children in Ridgeview.

### Block 3 — Outlying camp and evidence route
A restrained, non-graphic investigation space:
- gradual environmental quiet and unreliable equipment cues;
- physical evidence with readable provenance;
- a route to follow the repairman's trail;
- clear spatial threshold for the authored Psalm 23 moment, triggered by story state rather than a button;
- an exit/retreat route.

Do not add gore, remains, named enemy entities, or a complete explanation of the mystery.

### Block 4 — Logos Rhema Temple (separate scene and later integration)
A warm, ordinary, fictional community environment:
- exterior arrival and fellowship area;
- worship/service interior with clear sightlines and seating;
- CommunionContextZone with appropriate contextual interaction;
- quiet side porch/grounds for Ember's Hold position;
- private post-service Covenant alert delivery, only after service completion.

No Covenant base appearance, secret insignia in public view, or alert interruption during worship/Communion. Service attendance must not be turned into a checklist or reward loop.

### Block 5 — Travel, report and transition layer
A restrained Covenant field vehicle journey with guided route, free camera, ambient radio contact, a screened pull-off, and weakening Covenant Link near the ridge. Scout Report and final report are interfaces over evidence data, not arbitrary quest-marker screens.

## 4. Visual production stages

### Stage A — Functional greybox
- primitive geometry, correct scale and collision;
- route, navigation, sightlines, cover and interaction distances;
- readable light/dark values;
- placeholder UI and touch controls;
- no production character or environment assets.

Acceptance: the entire intended path can be played and understood without art dressing.

### Stage B — Presentable blockout
- original regional palette and material families;
- modular building and terrain language;
- controlled lighting and atmospheric depth;
- vegetation silhouettes and landmarks;
- placeholder character scale and animation;
- clear visual hierarchy for evidence and interactables.

Acceptance: a reviewer can understand location, mood, routes and points of interest, while gameplay remains readable on the target display.

### Stage C — Production candidate
Only after target hardware and renderer are selected:
- approved Asher and Ember assets;
- reviewed rigs and animation;
- production material/lighting pass;
- measured foliage, shadows, particles, LOD and texture budgets;
- optimized Android quality tiers.

No production asset is accepted without provenance, license, import, visual, gameplay and performance review.

## 5. Movement feel and physics workstream

Tune in this order, one variable group at a time:
1. Input response and joystick curve.
2. Horizontal acceleration/deceleration and maximum speed.
3. Rotation response and stopping behaviour.
4. Gravity, floor contact and slopes.
5. Step/ledge handling and collision stability.
6. Camera follow, collision, smoothing and pitch.
7. Animation blending and foot contact.
8. Environmental feedback: footsteps, surface response, dust and subtle camera/audio cues.

Use deterministic test routes and record values. Avoid adding inertia that makes touch controls feel delayed. Do not introduce parkour, wall-running, double-jump, supernatural dash or other unapproved traversal abilities.

## 6. Camera and presentation

Third-person remains the default. It should:
- keep Asher and nearby interactables readable;
- preserve Ember visibility when relevant;
- avoid clipping through walls and terrain;
- allow a controlled look range without abrupt snaps;
- return smoothly after interaction/dialogue;
- support sensitivity adjustment and reduced camera motion.

First-person is a later, purpose-specific option, not a requirement for the first playable prototype.

## 7. Ability and companion framework

### Asher
Asher's established Watcher toolkit is grounded in trained observation and judgment:
- careful observation;
- evidence assessment;
- threat read based on visible behaviour;
- cross-checking sources.

These are information and interaction systems, not supernatural vision, mind reading or guaranteed answers. Self-defence is limited to the approved slice's light combat context. The full combat model remains reserved.

### Ember
Use only the five already-approved abilities and seven commands. The prototype may build a data-driven command/ability interface and animation hooks, but must preserve the established limits:
- Veil Sight: fallible fixation/avoidance cues, not clue highlighting.
- Guardian Instinct: warning posture/interposition, not automatic attack.
- Veil Energy: behaviour changes near influenced places, not a weapon/resource meter.
- Tracking Sense: follows a trail, does not explain it.
- Spirit Guidance: rare authored calm/hesitation, never a substitute for the Holy Spirit or direct navigation.

Commands: Attack, Protect, Scout, Track, Retrieve, Hold and Regroup. "Stay" remains legacy wording for Hold. Do not add new commands without approval.

### Ability UI and feedback
- Contextual and minimal; show command availability only when useful.
- Use posture, gaze, sound and restrained visual cues before floating icons.
- Show uncertainty when Ember's perception may be wrong.
- No cooldown, energy bar or collectible progression for spiritual concepts.
- Any numeric cooldown/resource design is **UNKNOWN / RESERVED** unless already explicitly specified in a source-of-truth document.

## 8. Graphics and audio direction

- Cinematic semi-realism through silhouette, composition, materials, lighting and animation—not brute-force polygon count.
- Android-first renderer and quality settings remain undecided until target-device comparison.
- Prefer baked/static lighting where suitable; reserve dynamic effects for meaningful use.
- Keep ordinary locations credible and inhabited.
- Veil atmosphere is restrained and legible: missing wildlife, muffled ambience and unreliable devices are story cues, not a constant spectacle.
- Audio must have non-audio alternatives for essential cues. Do not make loudness or sensory overload the only warning.
- No renderer, FPS, memory, thermal or battery claim without measured device evidence.

## 9. HUD and touch layout direction

The HUD must be minimal and contextual:
- left lower region: movement joystick;
- right region: camera look surface;
- context-sensitive Interact near the right thumb zone but outside the look gesture's ownership region;
- Ember command affordances appear only when companion control is relevant;
- evidence tools appear during investigation, not during ordinary traversal;
- report/evidence-board UI is opened intentionally and does not permanently cover the world.

Exact positions, hit areas, safe-area offsets, portrait/landscape policy and iconography remain **PROPOSED** until physical-device ergonomic testing. Do not simply scale a desktop HUD down to phone size.

## 10. Current milestone status

- **COMPLETED — initial lab construction:** `scenes/movement_physics_lab.tscn`, `scripts/movement_physics_lab.gd` and `tests/movement_physics_lab_acceptance_test.gd` are implemented. The lab contains neutral greybox test geometry and live telemetry.
- **PASS — CI:** 19 Godot 4.7.2 suites and a 10-frame launch of the lab passed on commit `c49e0af37bc82f3864575b28f82e1358066ae441`, run [#42666739053](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42666739053). This includes camera spring-arm obstruction testing (5.00 m open / 3.44 m obstructed).
- **IN PROGRESS — Gate C:** provisional acceleration/braking candidates are implemented and tested (16 m/s² and 22 m/s²). Wall blocking, doorway/corridor clearance and gentle-ramp floor contact pass headless probes. Provisional turning-response and measured stop-distance assertions have been added; their latest CI run is pending. Final feel, camera sensitivity/smoothing, physical-device ergonomics and broader edge cases remain open.
- **BLOCKED — Ridgeview:** no Ridgeview blockout construction until Gate C passes.
- **BLOCKED — Android-ready claim:** physical-device Gate D remains untested; target phone and export validation are not yet established.
- **NOT STARTED — visual production:** no cinematic lighting, production materials, character art or environmental atmosphere has been introduced. The lab remains intentionally greybox.

## 10. Controlling implementation sequence and gates

The following order governs the prototype. It separates the first actual gameplay construction from later visual and system-production phases.

### Gate 0 — Demonstrate reliable controls before world construction
1. Pass the automated input-correctness checks (Gate A) and preliminary viewport-geometry checks (the automated portion of Gate B) on the exact candidate commit.
2. Review CI logs, input ownership, lifecycle behaviour, geometry assertions and known limitations.
3. Record physical Android validation (Gate D) as BLOCKED until the target device is available; do not call the controls Android-ready without it.
4. Permit only the neutral test laboratory after these prerequisites. Ridgeview world construction remains blocked until the lab proves Gate C.

### Milestone 1 — First actual gameplay construction: neutral movement and physics laboratory
1. Build Block 0 as the first actual gameplay construction after Gate A and preliminary viewport geometry pass.
2. Use neutral geometry and a neutral mannequin; this is a test laboratory, not a story level.
3. Establish reproducible movement, collision, camera and interaction baselines.
4. Add regression tests and record tuning values. Validate acceleration/deceleration, slopes, steps, corners, stopping, camera obstruction and touch response.
5. The lab is where Gate C is measured and accepted; do not require Gate C to pass before the lab exists.
6. The lab must be useful for measuring defects, not merely a decorative showcase.

### Milestone 2 — Ridgeview greybox blockout
**Entry condition:** Gate C has passed with recorded lab measurements and no critical control blocker.
1. Build Block 1, then the minimum connected portions of Blocks 2 and 3 needed for the investigation route.
2. Validate scale, navigation, sightlines, resident approach, evidence placement, retreat routes and player comprehension.
3. Keep geometry and assets functional and low-cost. No production art is implied by a successful blockout.
4. Preserve the non-graphic investigation and all approved story/canon boundaries.

### Milestone 3 — Cinematic lighting, materials and environmental atmosphere
1. Complete the renderer, target-device, GPU, memory and frame-time research before selecting the production direction.
2. Create a representative benchmark area before applying expensive effects to the full blockout.
3. Develop original lighting, material families, environmental atmosphere and regional art direction.
4. Measure each quality tier on the intended Android hardware; do not make unsupported FPS, thermal or battery claims.

### Milestone 4 — Responsive movement, collisions and camera feel
1. Refine acceleration/deceleration, turning, slopes, steps, collision stability, camera follow and sensitivity against the lab and Ridgeview blockout.
2. Verify touch latency and accessibility on the target device when available.
3. Keep Asher's movement grounded and consistent with his established human identity.

### Milestone 5 — Character animation and environmental interaction
1. Integrate approved character rigs and animation states only after the movement model is stable.
2. Add interaction feedback, foot contact, doors, objects and environmental responses.
3. Check readability, animation transitions, performance and input interruption.

### Milestone 6 — Ember's established abilities and commands
1. Implement only the five canon-approved abilities and seven commands.
2. Research and test companion state logic, player comprehension, animation cues, uncertainty, accessibility and edge cases.
3. Ember must assist without automatically solving clues or attacking without player direction.
4. Do not add cooldowns, spiritual resource meters, new abilities or commands without explicit canon approval.

### Milestone 7 — Asher's Watcher investigation toolkit
1. Implement grounded observation, evidence assessment, visible-behaviour threat reads and source cross-checking.
2. Preserve uncertainty; tools must not provide supernatural vision, mind-reading or guaranteed answers.
3. Validate evidence provenance, interaction states and investigation flow.

### Milestone 8 — Contextual HUD and ability interfaces
1. Design interfaces around the proven mobile controls and actual player tasks.
2. Keep traversal HUD minimal; surface Ember commands and investigation tools only when contextually useful.
3. Validate safe areas, thumb reach, text scaling, contrast, hand occlusion and readability on the target device.
4. Do not convert prayer, Scripture, the Holy Spirit or faith into UI meters, consumables, spells, cooldowns or rewards.

### Milestone 9 — Playable Ridgeview investigation
1. Connect the approach, settlement, outlying camp and evidence route into the intended playable slice.
2. Integrate the approved five response options and the evidence/report flow.
3. Add Logos Rhema Temple as its separately scoped scene and connect the travel/report transition only when the relevant preceding systems pass.
4. Conduct full regression, canon review, performance testing and target-device playtesting.

Godot 4.7.2 CI must run after every meaningful code change. Each milestone requires its own acceptance criteria, research record, checkpoint and review before the next dependent phase begins.

## 11. Definition of a playable prototype milestone

The first milestone is accepted only when:
- a player can complete the intended greybox route without control blockers;
- movement, camera, collision and Interact behave consistently;
- the Ridgeview route supports observation, conversation, evidence and retreat;
- Ember assists without solving the mission;
- the response choices remain meaningful and non-transactional;
- the visual hierarchy is readable on the intended device;
- all automated Godot tests pass;
- known device-specific limitations are reported honestly.

The prototype is not called production-ready, Android-ready or visually final at this milestone.
