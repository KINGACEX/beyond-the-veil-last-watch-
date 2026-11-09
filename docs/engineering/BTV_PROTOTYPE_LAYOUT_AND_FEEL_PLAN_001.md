# BTV Prototype Layout and Feel Plan 001

**Status:** DESIGN PLAN — IMPLEMENTATION HELD UNTIL CONTROL READINESS GATES PASS  
**Engine baseline:** Godot 4.7.2  
**Platform order:** Android first; PC scalability later  
**Visual direction:** Cinematic semi-realism, staged through a measurable greybox-to-presentable pipeline  
**Authority:** BTV Master Canon, specialist Bibles and the locked Vertical Slice Specification

## 1. Purpose

Define the first playable prototype layout and its implementation order without silently expanding BTV canon. This plan prepares the next phase; it does not claim that production visuals, physics, combat, powers or Android performance already exist.

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

## 10. Implementation order and gates

1. Pass the Control Readiness Gates A–C; record physical Android Gate D as blocked until a device is available.
2. Build Block 0 movement/camera lab and add physics/camera regression tests.
3. Run Godot 4.7.2 CI after every meaningful code change.
4. Implement Block 1 and validate navigation, observation and interaction.
5. Implement Blocks 2 and 3 as a small investigation route.
6. Integrate Ember's limited slice abilities and commands with clear tests and canon review.
7. Implement Logos Rhema and the contextual service/Communion sequence.
8. Add vehicle travel, Scout Report, evidence synthesis and final report.
9. Add presentable art only after the greybox loop is stable.
10. Profile on the named Android device before raising visual complexity.

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
