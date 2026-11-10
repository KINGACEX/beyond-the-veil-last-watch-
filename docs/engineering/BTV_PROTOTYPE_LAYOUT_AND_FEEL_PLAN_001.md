# BTV Prototype Layout and Feel Plan 001

**Status:** NEUTRAL MOVEMENT/PHYSICS LAB BUILT; LATEST AUTOMATED VALIDATION PASSED; GATE C STILL OPEN FOR FINAL FEEL REVIEW; RIDGEVIEW BLOCKOUT HELD  
**Engine baseline:** Godot 4.7.2  
**Platform order:** Android first; PC scalability later  
**Visual direction:** Cinematic semi-realism, staged through a measurable greybox-to-presentable pipeline  
**Authority:** BTV Master Canon, specialist Bibles and the locked Vertical Slice Specification

## 0. Mandatory research and planning gate

This plan is governed by the standing [BTV Research, Planning and Execution Governance Standard](../coordination/BTV_RESEARCH_PLANNING_AND_EXECUTION_GOVERNANCE_v1.0.md). The initial [Controls, Physics and Android Research Deep Dive](../research/BTV_CONTROLS_PHYSICS_ANDROID_RESEARCH_DEEP_DIVE_001_2026-11-09.md) records the first source audit, official Godot/Android findings, touch-camera correction and neutral-lab research decisions. Before any further block or system below is implemented, complete the applicable research sweep, deep dives, alternatives analysis, resource plan, risk register, work breakdown, approval check and verification plan. The current layout sequence is a proposed direction, not permission to skip that work. Renderer selection, target hardware, art pipeline and physics values require evidence-led investigation before commitment.

## 1. Purpose

Define the first playable prototype layout and its implementation order without silently expanding BTV canon. The neutral movement/physics laboratory is built and is the current test scene. Visual production has not started. Ridgeview construction remains held until the controls and movement-feel gate is accepted.

The core playable experience must prove the approved Ridgeview vertical slice: ordinary life before danger, a credible investigation, uncertain evidence, consequential choices, and faith expressed through character and story rather than a gameplay resource.

## 2. Non-negotiable design constraints

- **Core vertical slice:** Asher Vance is the sole playable character in the initial Ridgeview slice. He is presented as 18, a Watcher Agent/Specialist, and remains physically grounded.
- **Post-stability expansion:** additional approved key characters may become playable in a later update. This is a planned feature direction, not part of the initial prototype or core-release acceptance. See [Post-Stability Updates and Playable Character Expansion](../roadmap/BTV_POST_STABILITY_UPDATES_AND_PLAYABLE_CHARACTERS_001.md).
- Logos Rhema Temple is a fictional church and never a Covenant base. The congregation does not know Asher's Covenant affiliation.
- Communion is contextual and has no gameplay buffs, stats, currency, XP or progression.
- Prayer, Scripture, the Holy Spirit and faith are never power meters, consumables, spells, combat resources or reward currencies.
- The Ridgeview threat is not named or visually identified. The slice remains non-graphic.
- Ember is an intelligent animal companion, not a weapon or automatic clue solver. Its five approved abilities and seven commands must respect their established limits.
- The five Ridgeview response options remain Speak/Preach, Investigate, Rescue, Defend and Withdraw. None awards XP or morality points.
- No new character identity, Ember species, supernatural rule, divine manifestation, enemy design or mission outcome is invented in implementation.
- The named reference games inform high-level craft study only. No copied characters, environments, UI, effects, music or protected assets.

## 3. Prototype sequence and scene map

The full slice is modular. Build and validate one small block at a time.

### Block 0 — Neutral movement and camera lab (built; Gate C under evaluation)

The lab contains:
- flat movement lane and marked distances;
- gentle and steeper ramps;
- steps and a high-step obstacle;
- wall, doorway and corridor;
- dedicated camera-obstruction station;
- HUD telemetry for speed, grounded state, input, floor angle and camera pitch.

Purpose: tune movement, collision, turning, camera and touch response without level art hiding defects.

### Block 1 — Ridgeview approach and perimeter

A compact outdoor blockout:
- access road and screened arrival pull-off;
- readable approach route with alternate sightlines;
- watched perimeter and abandoned belongings;
- parked work vehicle and visible toolkit;
- clear transition from road to settlement edge.

The layout must support careful observation, environmental storytelling and retreat. It must not reveal the full threat or become a combat arena.

### Block 2 — Ridgeview settlement

A small, coherent settlement blockout:
- central shared space;
- several occupied structures with distinct entrances and sightlines;
- route to speak with residents;
- outlying route toward the camp;
- space for Wren's private conversation;
- Dorian Pike's location and a non-forced approach;
- clear return paths and safe navigation.

Civilian life and individual routines must be more visible than combat staging. Do not place children in Ridgeview.

### Block 3 — Outlying camp and evidence route

A restrained, non-graphic investigation space:
- gradual environmental quiet and unreliable equipment cues;
- physical evidence with readable provenance;
- route to follow the repairman's trail;
- clear spatial threshold for the authored Psalm 23 moment, triggered by story state rather than a button;
- exit/retreat route.

Do not add gore, remains, named enemy entities, or a complete explanation of the mystery.

### Block 4 — Logos Rhema Temple (separate scene and later integration)

A warm, ordinary, fictional community environment:
- exterior arrival and fellowship area;
- worship/service interior with clear sightlines and seating;
- CommunionContextZone with appropriate contextual interaction;
- quiet side porch/grounds for Ember's Hold position;
- private post-service Covenant alert delivery, only after service completion.

No Covenant base appearance, secret insignia in public view, or alert interruption during worship/Communion. Service attendance must not become a checklist or reward loop.

### Block 5 — Travel, report and transition layer

A restrained Covenant field vehicle journey with guided route, free camera, ambient radio contact, a screened pull-off, and weakening Covenant Link near the ridge. Scout Report and final report are interfaces over evidence data, not arbitrary quest-marker screens.

## 4. Visual production stages

### Stage A — Functional greybox
- primitive geometry, correct scale and collision;
- route, navigation, sightlines, cover and interaction distances;
- readable light/dark values;
- placeholder UI and touch controls;
- no production character or environment assets.

Acceptance: the intended path can be played and understood without art dressing.

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

Use deterministic test routes and record values. Avoid adding inertia that makes touch controls feel delayed. **USER-APPROVED DIRECTION:** expand the movement workstream to evaluate a traversal ability set: jump, double jump, short traversal dash, climbable-surface wall climb, wall scaling/mantling, ledge grab, vault and wall jump. These are approved for design research and neutral-lab prototyping, not yet accepted as final character abilities. Dash is traversal-only in this scope, not a combat mechanic. Wall climb applies only to explicitly authored climbable surfaces; wall scaling means pulling over an edge and is distinct from climbing vertically. Double jump and any movement that exceeds Asher's established grounded-human capability require a separate canon/fiction explanation and approval before story integration. Do not implement combat or weapon systems as part of this workstream.

### 5.1 Traversal ability evaluation and acceptance

Prototype each mechanic independently before combining them. Initial evaluation order:
1. Jump tuning: take-off consistency, variable-height input, air steering, landing and coyote-time decision.
2. Double-jump experiment: second impulse, reset rules, animation readability and a clear distinction from the first jump. Keep it isolated behind a test toggle until its in-world justification is approved.
3. Traversal dash: brief directional displacement with predictable start/end, collision-safe stopping, input buffering policy and recovery. No damage, attack, stun or enemy-targeting behaviour.
4. Wall climb: only tagged climbable materials/surfaces, clear entry/exit conditions, stamina-free initial test, camera clearance and safe drop/exit behaviour.
5. Wall scaling/mantle: detect an eligible top edge, validate landing clearance, then move the character over the obstacle without clipping or teleport-like snapping.
6. Ledge grab: explicit eligible ledges, stable hanging pose, clear climb-up/drop choices and reliable input cancellation.
7. Vault: low-obstacle traversal with clearance checks and no forced movement into hazards.
8. Wall jump: controlled push-off from a valid wall contact, with deterministic direction and no repeated infinite bouncing.

For every mechanic, record the state diagram, input mapping, tuning parameters, collision rules, animation requirements, camera behaviour, accessibility options, Android touch layout, failure cases and regression tests. Test single mechanics first, then pairwise combinations (for example jump-to-mantle, dash-to-landing and wall-climb-to-wall-scale). Verify no input conflict with camera look, interaction or companion commands. Include edge cases for ceilings, overhangs, corners, narrow ledges, moving platforms if later approved, slopes, low ceilings, interrupted input, pause/resume and touch cancellation.

**Acceptance gates:** (a) deterministic automated physics/collision tests pass; (b) no clipping, unintended launch, stuck state or unrecoverable traversal state; (c) touch controls remain discoverable and do not overload the right-thumb camera region; (d) the camera maintains readable framing; (e) measured movement remains consistent across supported frame rates; (f) human feel review passes; (g) any canon-sensitive ability receives separate approval before story integration. Until these gates pass, abilities remain experimental and Ridgeview integration is held.

## 6. Camera and presentation

Third-person remains the default. It should:
- keep the active character and nearby interactables readable;
- preserve Ember visibility when relevant;
- avoid clipping through walls and terrain;
- allow a controlled look range without abrupt snaps;
- return smoothly after interaction/dialogue;
- support sensitivity adjustment and reduced camera motion.

First-person is a later, purpose-specific option, not a requirement for the first playable prototype. Multi-character camera framing will be assessed in the post-stability feature study.

## 7. Ability and companion framework

### Asher

Asher's established Watcher toolkit is grounded in trained observation and judgment:
- careful observation;
- evidence assessment;
- threat read based on visible behaviour;
- cross-checking sources.

These are information and interaction systems, not supernatural vision, mind reading or guaranteed answers. Do not expand combat systems as part of the movement/physics workstream.

### Ember

Use only the five already-approved abilities and seven commands. Preserve the established limits:
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
- Any numeric cooldown/resource design is **UNKNOWN / RESERVED** unless explicitly specified in a source-of-truth document.

## 8. Graphics and audio direction

- Cinematic semi-realism through silhouette, composition, materials, lighting and animation—not brute-force polygon count.
- Android-first renderer and quality settings remain undecided until target-device comparison.
- Prefer baked/static lighting where suitable; reserve dynamic effects for meaningful use.
- Keep ordinary locations credible and inhabited.
- Veil atmosphere is restrained and legible: missing wildlife, muffled ambience and unreliable devices are story cues, not constant spectacle.
- Audio must have non-audio alternatives for essential cues. Do not make loudness or sensory overload the only warning.
- No renderer, FPS, memory, thermal or battery claim without measured device evidence.

## 9. HUD and touch layout direction

The HUD must be minimal and contextual:
- left lower region: movement joystick;
- right region: camera look surface;
- context-sensitive Interact near the right thumb zone but outside the look gesture's ownership region;
- Ember command affordances appear only when companion control is relevant;
- evidence tools appear during investigation, not ordinary traversal;
- report/evidence-board UI is opened intentionally and does not permanently cover the world.

Exact positions, hit areas, safe-area offsets, portrait/landscape policy and iconography remain **PROPOSED** until physical-device ergonomic testing. Do not simply scale a desktop HUD down to phone size.

## 10. Current milestone status

- **COMPLETED — neutral lab construction:** lab scene, controller telemetry and acceptance/motion/collision test files are implemented.
- **PASS — latest CI:** all 25 workflow steps passed on commit `8104273bf53acb7e80d0d7cedef96ad43efb9335`, run [#42667216009](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42667216009). This includes the latest progressive-turning and braking-stop-distance assertions, collision probes and a 10-frame lab launch.
- **IN PROGRESS — Gate C:** automated candidate-profile checks pass. Final human-perceived feel, camera tuning, additional edge cases and device ergonomics remain open.
- **BLOCKED — Ridgeview:** no Ridgeview blockout construction until Gate C passes.
- **BLOCKED — Android-ready claim:** physical-device Gate D remains untested; exact target device and export validation are not established.
- **NOT STARTED — visual production:** no production lighting, materials, character art or environmental atmosphere has been introduced. The lab remains intentionally greybox.

## 11. Controlling implementation sequence and gates

### Gate 0 — Demonstrate reliable controls
1. Pass automated input correctness and preliminary viewport geometry checks on the exact candidate commit.
2. Review CI logs, input ownership, lifecycle behaviour, geometry assertions and known limitations.
3. Record physical Android validation as BLOCKED until the target device is available.
4. Permit the neutral lab after prerequisites. Ridgeview remains held until the lab proves Gate C.

### Milestone 1 — Neutral movement and physics laboratory
1. Maintain the neutral test laboratory as the source of reproducible movement, collision, camera and interaction measurements.
2. Validate acceleration/deceleration, slopes, steps, corners, stopping, camera obstruction and touch response.
3. Record candidate tuning values and regression tests.
4. The lab is where Gate C is measured and accepted; it is not a decorative showcase.

### Milestone 2 — Ridgeview greybox blockout
**Entry condition:** Gate C has passed with recorded measurements and no critical control blocker.
1. Build the approach, then minimum connected settlement and camp portions needed for the investigation route.
2. Validate scale, navigation, sightlines, resident approach, evidence placement, retreat routes and player comprehension.
3. Keep geometry and assets functional and low-cost. No production art is implied by a successful blockout.
4. Preserve the non-graphic investigation and approved story/canon boundaries.

### Milestone 3 — Cinematic lighting, materials and environmental atmosphere
1. Complete renderer, target-device, GPU, memory and frame-time research before selecting the production direction.
2. Create a representative benchmark area before applying expensive effects to the full blockout.
3. Develop original lighting, material families, environmental atmosphere and regional art direction.
4. Measure each quality tier on intended Android hardware; do not make unsupported FPS, thermal or battery claims.

### Milestone 4 — Responsive movement, collisions and camera feel
Refine movement and camera against the lab and Ridgeview blockout, then verify touch latency and accessibility on the target device. Keep Asher's movement grounded and consistent with his established human identity.

### Milestone 5 — Character animation and environmental interaction
Integrate approved rigs and animation states after the movement model is stable. Add interaction feedback, foot contact, doors, objects and environmental responses. Check readability, animation transitions, performance and input interruption.

### Milestone 6 — Ember's established abilities and commands
Implement only the five canon-approved abilities and seven commands. Research and test companion state logic, player comprehension, animation cues, uncertainty, accessibility and edge cases. Do not add cooldowns, spiritual resource meters, new abilities or commands without explicit canon approval.

### Milestone 7 — Asher's Watcher investigation toolkit
Implement grounded observation, evidence assessment, visible-behaviour reads and source cross-checking. Preserve uncertainty and evidence provenance.

### Milestone 8 — Contextual HUD and interfaces
Design interfaces around proven mobile controls and actual player tasks. Validate safe areas, thumb reach, text scaling, contrast, hand occlusion and readability on the target device.

### Milestone 9 — Playable Ridgeview investigation
Connect the approach, settlement, outlying camp and evidence route. Integrate approved response options and evidence/report flow. Add the separate church scene and travel/report transition only when preceding systems pass. Conduct full regression, canon review, performance testing and target-device playtesting.

### Milestone 10 — Core release hardening and stability
Complete content, regression, accessibility, save/load, performance, device compatibility, crash recovery, privacy/security and release-readiness reviews. A stable core release requires an explicit acceptance record; a passing CI run alone is insufficient.

### Milestone 11 — Post-stability updates
After the core game is complete and its stability gate is accepted, use the separate post-stability roadmap to scope additional content. The first recorded candidate is optional play as a small selection of existing key characters other than Asher. This must not delay or destabilize the core release.

Godot 4.7.2 CI must run after every meaningful code change. Each milestone requires applicable research, acceptance criteria, a checkpoint and review before dependent work begins.

## 12. Definition of a playable prototype milestone

The initial milestone is accepted only when:
- the intended greybox route can be completed without control blockers;
- movement, camera, collision and interaction behave consistently;
- the Ridgeview route supports observation, conversation, evidence and retreat;
- Ember assists without automatically solving the mission;
- response choices remain meaningful and non-transactional;
- visual hierarchy is readable on the intended device;
- automated Godot tests pass;
- known device-specific limitations are reported honestly.

The prototype is not called production-ready, Android-ready or visually final at this milestone.


## 13. Latest automated movement regression evidence

The motion suite now includes progressive turning and convergence, moving direction reversal, and diagonal braking in addition to acceleration, straight-line braking, stop distance and diagonal speed cap.

**PASS:** [Godot 4.7.2 CI run #42712465318](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42712465318), tested commit `f27f85b165c9a25b6c9fbcf480f1aab684fece2a`. All 19 contract/regression suites, collision probes and the neutral-lab scene launch passed.

Gate C remains open: the new automated checks improve coverage but do not replace human playtesting or broader visual camera evaluation. Gate D remains blocked until an exact Android target device and export path are validated.


## 14. First traversal implementation checkpoint — 2026-11-10

**COMPLETED:** first gameplay traversal code now exists. The player controller supports a configurable grounded jump and one bounded mid-air jump by default. Keyboard Space and a dedicated Android touch Jump button feed the same press-latched input path.

**PASS:** Godot 4.7.2 workflow [#42777872484](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42777872484), tested code commit `2367ea3551ae154a2d72fbc942b7834f65d1bf76`. Existing input, touch, interaction, movement and collision suites passed; the new traversal jump test passed its grounded take-off, second-jump and third-jump rejection assertions. The neutral lab also launched successfully.

Checkpoint record: [BTV Development Checkpoint 11 — First Traversal Code](../coordination/checkpoints/BTV_DEVELOPMENT_CHECKPOINT_11_FIRST_TRAVERSAL_CODE_2026-11-10.md).

**NEXT:** build measured traversal test geometry; implement and validate traversal-only dash, tagged wall climb, ledge detection and mantle, then vault and wall-jump experiments. These remain lab-only until transition, collision, camera, touch and human-feel gates pass. Double jump remains a physics prototype pending separate canon approval for permanent Asher integration. Physical Android QA remains blocked.


## 15. Traversal dash implementation and detection research — 2026-11-10

**COMPLETED:** a traversal-only dash prototype now exists with configurable speed/duration/cooldown, camera-relative direction, collision cancellation and clean end-of-burst velocity handling. Keyboard Shift and a dedicated Android touch action are connected. Action-button hit areas for Jump, Dash and Interact are excluded from camera-look gesture acquisition.

**PASS:** [Godot 4.7.2 CI run #42779166032](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42779166032), code commit `e67c991e3e9438211ef26013a1e4ae78561dc4f8`. Existing regression suites, jump tests, new dash displacement/duration/wall-collision tests and lab launch passed.

Research and implementation record: [BTV Development Checkpoint 12 — Traversal Dash and Detection Research](../coordination/checkpoints/BTV_DEVELOPMENT_CHECKPOINT_12_TRAVERSAL_DASH_AND_RESEARCH_2026-11-10.md).

**RESEARCH DECISION FOR WALL MECHANICS:** only explicitly tagged surfaces are climbable. Candidate ledges require lower wall-face detection, upper clearance detection, a downward top-surface query and capsule-sized destination clearance before mantle starts. Use cheap ray queries to discover candidates and shape/overlap checks only to validate candidate destinations. Build explicit traversal states before implementing wall climb and mantle so only one movement mode owns velocity at a time.

**NEXT:** add the traversal test course; add touch-look/action-button regression tests; introduce explicit traversal states; then prototype tagged wall climb and collision-checked mantle. All remain neutral-lab only until tests and human feel review pass. Ridgeview and physical Android readiness remain gated.


## 16. Lighting, optics and in-game effects research — 2026-11-10

**COMPLETED:** researched Godot 4.7 renderer capabilities and the underlying optical principles for reflection, diffuse scattering, refraction, total internal reflection, dispersion, absorption/transmission, atmospheric scattering and indirect bounced light.

Research record: [BTV Lighting, Optics and In-Game Visual Effects Research 001](BTV_LIGHTING_OPTICS_AND_IN_GAME_EFFECTS_RESEARCH_001.md).

**Key engineering decisions:**
- Do not lock Mobile versus Compatibility until a real Android export is profiled on the target device. Mobile requires modern RenderingDevice/Vulkan-class hardware; Compatibility has wider older-device support.
- For the Android baseline, prioritize baked LightmapGI for static world bounce and selective ReflectionProbes; avoid depending on Forward+-only VoxelGI, SDFGI, SSIL, SSR or volumetric fog.
- Use PBR roughness/metallic response for material appearance. Emission alone does not guarantee surrounding geometry is illuminated.
- Use screen-space refraction sparingly: it is transparent/screen-space and has sorting, off-screen and overlapping-transparent limitations.
- Keep optical puzzle correctness in deterministic ray math, not in the shader or visible beam. Implement reflection, Snell-law refraction and total internal reflection as a separate testable solver.
- Add prism dispersion and water/glass visuals only after ray-solver correctness; use restrained approximations and renderer-safe fallbacks.

**NEXT:** create a Lighting Validation Lab with matte/glossy samples, mirror, glass, prism, water, emissive surface, blockers and fog. Add deterministic tests for reflection, refraction and total internal reflection before any Ridgeview lighting pass. The final art direction and target renderer remain unconfirmed.


## 17. Optics validation and wind/weather research — 2026-11-10

**COMPLETED:** a deterministic optics solver now implements vector reflection, Snell-law refraction, total internal reflection and critical-angle calculation. A separate 3D optics validation scene draws example ray paths. The solver and scene have automated test suites in the Godot workflow.

**PASS:** [Godot 4.7.2 CI run #42781103405](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42781103405), tested commit 9197219382d046547c5495e7344bf2e5f9c59480. Existing regression suites, traversal jump/dash, both optics test suites and neutral movement lab launch passed.

**COMPLETED:** wind, gusts, turbulence, drag, rain, clouds, fog, sky, particle systems, mobile renderer limits and a proposed data-driven weather architecture have been researched.

Research records:
- [BTV Wind, Weather and Atmospheric Systems Research 001](BTV_WIND_WEATHER_AND_ATMOSPHERIC_SYSTEMS_RESEARCH_001.md)
- [BTV Development Checkpoint 14 — Optics Validation and Weather Research](../coordination/checkpoints/BTV_DEVELOPMENT_CHECKPOINT_14_OPTICS_AND_WEATHER_RESEARCH_2026-11-10.md)

**Key engineering decisions:**
- Godot Area3D wind is not a universal rigid-body force; its built-in wind currently affects SoftBody3D only. Use a deterministic BTV wind-field service for explicitly opted-in lightweight objects.
- Keep the player excluded from wind forces by default. Wind and weather must not unexpectedly change core traversal controls.
- Use shader-driven vegetation, bounded GPU particles and depth/height fog for the mobile baseline. Keep volumetric fog and expensive particle collision optional.
- Separate weather state, time-of-day and presentation. Use seeded gusts and smooth local zone blending.
- Keep weather effects from obscuring route readability, interaction targets or deterministic optical puzzle logic.

**NEXT:** resume the unfinished traversal work with a measured traversal course and explicit traversal-state architecture. Build the wind-field math module only after the traversal course/state work has a verified checkpoint. All weather remains research/proposed, not production-integrated or canon-approved.


## 18. Traversal fixtures and wind-field math — 2026-11-10

**COMPLETED:** the neutral movement lab now includes explicitly tagged short/tall traversal test surfaces and an untagged negative-test wall. The acceptance suite verifies group and metadata tagging.

**PASS:** [Godot 4.7.2 CI run #42781407203](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42781407203), tested commit 738cd4d57837e48b68706367a7ae8763c076ac2d. The full suite passed, including the updated movement-lab acceptance assertions.

These remain greybox measurement fixtures only; no wall traversal behavior or production integration was added.

**COMPLETED — IMPLEMENTATION, VALIDATION PENDING:** added scripts/wind_field.gd with deterministic wind-vector blending, bounded gust calculation and capped quadratic drag for explicitly opted-in game props. Added tests/wind_field_test.gd and a Godot CI step.

Latest validation: [Godot 4.7.2 CI run #42781545131](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42781545131), commit 4e524beb8e60e572635b2c6cd191db76687feac8. The run was still in progress when this plan entry was written; no pass/fail claim is made yet.

Checkpoint: [BTV Development Checkpoint 15 — Traversal Fixtures and Wind Math](../coordination/checkpoints/BTV_DEVELOPMENT_CHECKPOINT_15_TRAVERSAL_FIXTURES_AND_WIND_MATH_2026-11-10.md).

**NEXT:** verify wind-field CI; then add deterministic weather-profile blending and tests. Build a separate weather validation scene after state validation. Keep wind force out of the player controller by default, and keep weather effects from compromising movement, visibility, interaction or puzzle readability.
