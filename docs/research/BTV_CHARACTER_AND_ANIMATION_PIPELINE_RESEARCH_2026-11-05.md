# BTV CHARACTER AND ANIMATION PIPELINE RESEARCH
**Date:** 5 November 2026  
**Status:** PRACTITIONER CASE STUDY + OFFICIAL GODOT DOCUMENTATION  
**Project:** Beyond the Veil: The Last Watch  
**Scope:** Character creation, rigging, animation authoring, animation import and real-time responsiveness.

## 1. Primary case study: Blender Studio DOGWALK

Sources:
- Blender Conference 2025, “Making of DOGWALK”: https://www.youtube.com/watch?v=cbFwv-7HJlw
- Blender Studio, “Playable Stop Motion in Godot”: https://studio.blender.org/blog/playable-stop-motion-in-godot/
- Blender Studio, “Our Workflow with Blender and Godot”: https://studio.blender.org/blog/our-workflow-with-blender-and-godot/
- Godot Showcase: https://godotengine.org/article/godot-showcase-dogwalk/

DOGWALK was a small, stylized game made with Blender and Godot. The Blender Conference presentation describes a four-month production period and a compact team with overlapping responsibilities. Its stated purpose included validating an open-source Blender-to-Godot production pipeline. It was deliberately scoped as a micro-game, not a large open-world RPG.

### 1.1 Animation style was a production and design decision
DOGWALK used a stepped, low-frame-rate animation style—often 12 frames per second and sometimes 8—while keeping player control and game logic responsive in real time. The developer explains that this required separating:
- player/gameplay variables that must update immediately;
- visual animation elements that can update in stepped intervals.

The article warns that low-frame-rate visuals and responsive control can conflict if the entire character transform or input response is delayed. The production solution is to keep control/gameplay responsiveness real-time while deliberately stepping only selected visual animation behaviour.

**BTV relevance:** This is an example of style serving production scope, not a style recommendation for BTV. BTV's intended visual direction is not changed by this case study.

### 1.2 Rigging and animation are not one generic task
The DOGWALK production talk lists separate sections for character creation, animation style, 3D animation challenges and pipeline technicalities. Blender Studio also links separate articles on animation authoring and character rigging. This reinforces the need to treat:
- model and topology;
- rig and deformation;
- animation authoring;
- export/import;
- in-engine animation state control;
- runtime movement and responsiveness;
as related but distinct pipeline stages.

### 1.3 Four-month scope discipline
Khronos' technical postmortem describes DOGWALK as a four-month micro-game with intentionally limited mechanics and style-led presentation. The developers note that previous projects sometimes overscoped; for DOGWALK, finishing within the time constraint was itself a design constraint. This is a valuable production lesson: choose a small scope that can validate the pipeline, rather than building a large amount of content before the workflow is proven.

## 2. Godot 4.7 animation architecture

Official Godot documentation distinguishes these responsibilities:

- **AnimationPlayer:** stores and plays animation tracks.
- **AnimationLibrary:** groups named animations for use by AnimationPlayer.
- **AnimationTree:** controls advanced transitions and blending using animations from an AnimationPlayer.
- **Skeleton3D / SkeletonProfile:** support skeletal animation and retargeting workflows.

Official documentation:
- Animation overview: https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html
- AnimationTree: https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html
- AnimationPlayer: https://docs.godotengine.org/en/stable/classes/class_animationplayer.html
- AnimationLibrary: https://docs.godotengine.org/en/stable/classes/class_animationlibrary.html
- 3D skeleton retargeting: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html
- Animation track types: https://docs.godotengine.org/en/stable/tutorials/animation/animation_track_types.html

### 2.1 Retargeting is not automatic quality assurance
Godot provides retargeting tools, but rigs can differ in bone names, rest poses, bone orientation, hierarchy, proportions and root motion. A retargeted animation may import and play while still producing poor deformation or foot sliding. Therefore, successful import is not the same as acceptable animation.

## 3. Proposed BTV character pipeline

This is **PROPOSED**, not approved character canon or art direction.

### Stage A — Character specification
Before modelling or rigging:
- identify the approved character source and visual baseline;
- record body proportions and silhouette constraints from the approved reference;
- define the character's gameplay role and movement set;
- list required equipment/clothing layers and deformation concerns;
- record which animations must be shared and which are character-specific;
- define target-platform and performance constraints.

### Stage B — Model validation
- test scale, orientation, pivot/origin and silhouette;
- inspect topology in deformation-critical areas;
- separate materials and meshes only where they serve a clear production need;
- test a neutral pose and simple movement before adding detail.

### Stage C — Rig validation
- document skeleton hierarchy and bone naming;
- confirm rest pose and bone orientation;
- test deformation at shoulders, elbows, hips, knees, neck and hands;
- define root-motion policy explicitly;
- test attachment points for equipment only after the character source is approved.

### Stage D — Animation authoring
Start with a minimal set needed to prove the character:
- idle;
- walk;
- run;
- start/stop transitions;
- turn/rotate;
- interaction reach;
- one safe, non-combat context animation.

The actual BTV set must be derived from approved gameplay requirements. This list is only a pipeline test proposal.

### Stage E — Export/import
- use a repeatable glTF export preset;
- ensure each action has a stable name;
- verify animation clips remain separate;
- check skeleton, rest pose, root motion, materials and scale after import;
- repeat import after a source edit to check stability.

### Stage F — In-engine state control
- use AnimationPlayer for the authored animation data;
- evaluate AnimationTree for blending/state transitions when the minimal set demonstrates a need;
- keep gameplay movement and input response independent from cosmetic animation update rate;
- ensure interrupted animations return to a valid state;
- define what happens if an animation is missing or a transition is invalid.

### Stage G — Performance and QA
- profile a representative character in a representative scene;
- test multiple visible instances only when a real use case exists;
- measure CPU, GPU, memory and animation cost on the target device;
- test locomotion at varied frame rates;
- inspect foot contact, sliding, clipping, hand/prop alignment and transition pops.

## 4. Companion-character implications

Ember's companion behaviour has additional requirements and must not be treated as simply another humanoid controller:
- four-legged locomotion and turning require different animation coverage;
- movement must remain readable at a distance and across varied terrain;
- animation state should reflect the actual movement/task state, not imply omniscient knowledge;
- the companion's fallible perception/sensitivity limits must remain respected;
- animation cannot imply that Ember speaks for God or receives guaranteed divine instructions;
- companion animation and AI must fail safely when a path, target or animation is unavailable.

No Ember model, rig, animation or behaviour is changed or approved by this research.

## 5. Failure modes and acceptance checks

| Failure mode | Likely cause | Acceptance check |
|---|---|---|
| Wrong body proportions after import | Scale or transform mismatch | Compare known measurements and silhouette in Blender/Godot |
| Twisted or collapsed joints | Rest pose, bone orientation or weight issues | Deformation pose review across key joints |
| Animation clips merge | Export/action/NLA configuration | Verify each expected named clip exists separately |
| Foot sliding | Root-motion and locomotion speed mismatch | Compare root displacement and foot contact during movement |
| Character moves sluggishly | Gameplay transform tied to stepped animation | Input-to-motion responsiveness test |
| Animation transition pops | Incompatible poses or state transitions | Test all required transition pairs |
| Missing equipment attachment | Skeleton/attachment naming or hierarchy mismatch | Attachment point contract test |
| Animation missing after reimport | Export settings or importer mismatch | Clean reimport and named-clip comparison |
| Companion animation misrepresents behaviour | Animation state disconnected from AI state | State-to-animation consistency test |
| Performance collapse with multiple characters | Excessive bones, tracks, materials or update frequency | Profile a representative scene on target device |

## 6. BTV-specific boundaries
- Asher's age and visual-reference conflict remains unresolved; this research does not choose an appearance.
- Existing Asher GLB source remains unmodified and is not automatically approved as final.
- Ember's Foundation #11 lineage/origin canon is preserved; no new physical design is inferred.
- Do not copy DOGWALK's stop-motion/paper-craft style into BTV.
- Do not use animation or visual effects to create spiritual scoring, prayer buffs or a controllable Holy Spirit mechanic.
- No new asset, rig, plugin or paid tool is authorized.

## 7. Research quality and limitations
- Blender Studio's sources are first-hand developer accounts and official project documentation, strong for that particular pipeline.
- DOGWALK's art style, team, timeline and scope are very different from BTV. It is useful for pipeline principles and scope control, not for estimating BTV's production duration.
- Godot docs describe engine capabilities, not the quality of a specific character rig.
- The character rigging article and complete asset archive may require a Blender Studio membership; no paid access was used.
- Further cross-studio comparison is still required before final recommendations.

## 8. Research references
- Blender Conference 2025 — Making of DOGWALK: https://www.youtube.com/watch?v=cbFwv-7HJlw
- Blender Studio — Playable Stop Motion in Godot: https://studio.blender.org/blog/playable-stop-motion-in-godot/
- Blender Studio — DOGWALK: https://studio.blender.org/projects/dogwalk/
- Khronos — Project Dogwalk: Stress-Testing Blender-to-Godot Interoperability with glTF: https://www.khronos.org/blog/project-dogwalk-stress-testing-blender-to-godot-interoperability-with-gltf
- Godot 4.7 animation and retargeting documentation (links above).

## 9. Next research
- Compare additional character animation pipelines beyond DOGWALK.
- Study locomotion blend spaces, root motion and animation state machines in Godot 4.7.
- Research companion AI state design and animation synchronisation at a high level.
- Write a neutral test-character asset acceptance specification before importing any BTV character.
