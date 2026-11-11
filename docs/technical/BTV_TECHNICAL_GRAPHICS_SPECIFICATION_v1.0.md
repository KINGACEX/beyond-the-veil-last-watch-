# BTV TECHNICAL GRAPHICS SPECIFICATION v1.0
**Project:** Beyond the Veil: The Last Watch  
**Date:** 6 November 2026  
**Status:** APPROVED PLATFORM INTENT; TECHNICAL VALUES ARE PROVISIONAL UNTIL DEVICE TESTING  
**Engine baseline:** Godot 4.7.2 in current CI; verify project configuration before changing engine or renderer.

## 1. Purpose

This document converts BTV's approved visual direction into an implementation and validation plan for the Godot project.

**Approved intent**
- Cinematic semi-realism.
- Semi-realistic, expressive 3D characters.
- Semi-open interconnected regions with living settlements.
- Cinematic atmosphere, hybrid camera and hybrid animation.
- Quality-led visual ambition, Android-first and PC later.
- Scalable settings for different device capabilities.

**Not established:** final renderer, target Android device, minimum hardware, frame-rate guarantee, memory ceiling, final asset budgets, production character assets or Android readiness.

A value labelled **TARGET** is a planning objective. A value labelled **MEASURED** requires recorded test evidence. Never report a target as achieved.

## 2. Current verified baseline and boundaries

Repository documentation records:
- Godot 4.7.2 is installed by CI for headless validation.
- Current project includes a greybox main scene, capsule player placeholder, third-person camera, proximity sensor and initial touch overlay.
- No final Asher or Ember model, production environment, combat system, final renderer selection or full vertical slice is implemented.
- Android export/install, physical touch/safe-area validation, renderer comparison, sustained frame-time, memory and thermal behaviour remain unverified.
- The target Android device has not been identified.

This specification does not change the engine, renderer, scripting language, architecture or platform scope.

## 3. Rendering strategy

### 3.1 Renderer decision gate
Do not select a renderer from desktop screenshots or feature lists alone.

Compare the renderer options supported by the pinned Godot 4.7.2 project on the named target Android device:
- **Mobile:** primary candidate for broad mobile compatibility and performance.
- **Forward+:** comparison candidate for visual features and performance on capable devices; do not assume it is viable on the minimum Android target.
- **Compatibility:** evaluate only if required by the actual device/graphics API support matrix or a deliberate compatibility target.

Record for each test:
- exact Godot version and renderer;
- device model, SoC/GPU, RAM, Android version and graphics API;
- project commit and scene/asset test-set version;
- resolution, viewport scale, quality settings and thermal state;
- frame-time distribution, GPU/CPU time where available, memory, battery/thermal behaviour and visual defects.

Select the renderer only after testing representative character, vegetation, indoor, outdoor, fog/weather and lighting scenes. Keep renderer-specific features behind a documented support boundary.

### 3.2 Rendering principles
- Prefer the simplest rendering method that meets the approved visual result.
- Use baked/static lighting where dynamic lighting is not necessary.
- Reserve real-time lights and shadows for visible gameplay or narrative value.
- Avoid full-screen effects that provide little perceptible benefit.
- Test transparent materials, foliage, particles and overlapping effects for overdraw.
- Use mipmaps and appropriate texture compression/import settings.
- Use LOD and visibility ranges based on camera distance and measured benefit.
- Use occlusion culling only where scene geometry and camera paths make it beneficial.
- Use MultiMesh for repeated compatible meshes when profiling shows a benefit.
- Do not add rendering plugins or paid middleware without explicit approval.

## 4. Graphics scalability tiers

These are proposed quality profiles, not device certification labels.

| Tier | Intended device class | Visual intent | Typical controls |
|---|---|---|---|
| Low | Minimum supported Android device, once defined | Stable readability and core atmosphere | Lower render scale, simplified shadows, reduced foliage/particles, shorter visibility ranges, reduced material complexity |
| Balanced | Mainstream supported Android devices | Intended baseline BTV presentation | Moderate shadows, representative foliage density, selected post effects, medium render scale |
| High | Capable Android devices | Higher detail and atmosphere | Higher render scale, richer foliage, improved shadow quality and selected additional effects |
| PC | Supported desktop hardware | Scalable high-quality presentation | Higher render scale, shadow/LOD distances, texture quality and selected effects based on measured hardware |

Rules:
- Graphics tier must not change mission logic, evidence, NPC knowledge, companion capabilities or story outcomes.
- Reduced effects must preserve gameplay readability and important visual cues.
- Expose settings only where the project can actually honour them.
- Automatically selecting a tier is a future option; do not implement speculative device detection before the device matrix exists.
- A setting must have a documented owner, default, supported range and test.

## 5. Performance targets and budgets

### 5.1 Frame-time objectives
Use frame-time as the primary metric:
- 30 FPS corresponds to approximately 33.3 ms per frame.
- 60 FPS corresponds to approximately 16.7 ms per frame.

**PROPOSED TARGET:** first prove a stable 30 FPS presentation on the eventual minimum supported Android device in representative gameplay scenes; then pursue 60 FPS on higher tiers where hardware permits. These are targets, not guarantees or current results.

Measure sustained sessions, not only short launches. Record average, median and high-percentile frame times, stutter events, thermal state and throttling. Report scene, camera, visible character count, effects, resolution and test duration with each result.

### 5.2 Budget policy
Do not invent fixed polygon counts, draw-call ceilings, texture sizes, memory limits or simultaneous-light limits before representative assets and target hardware exist.

For each asset class, record:
- triangle/vertex count and LOD levels;
- material and surface count;
- texture dimensions, formats and total resident texture memory;
- skeleton bone count and animation clip footprint;
- shadow casting and transparency use;
- collision and navigation contribution;
- per-instance and scene-level memory/performance observations.

Create measured budgets after a neutral representative test asset and a representative scene pass on target hardware. Budgets must include headroom for mission content, UI, audio and streaming.

### 5.3 Thermal and memory stability
- Test cold start and sustained play.
- Watch for progressive frame-time degradation and thermal throttling.
- Record peak and steady-state memory.
- Test region transitions and scene changes for spikes/leaks.
- Do not claim battery efficiency without measured device evidence.
- Define crash/recovery expectations before release QA.

## 6. Character and animation pipeline

### 6.1 Authoring and interchange
Proposed pipeline:
1. Author source models, rigs and animations in Blender.
2. Export approved game assets through glTF 2.0 (.glb where appropriate).
3. Import into the pinned Godot version.
4. Validate hierarchy, scale, origin, materials, skeleton, rest pose and clip names.
5. Assemble reusable character scenes in Godot.
6. Keep gameplay state and movement logic separate from cosmetic animation.

The research baseline favours a controlled export boundary. Direct .blend import is not the production publishing contract for the initial pipeline.

### 6.2 Godot animation roles
- AnimationPlayer stores and plays authored animation clips.
- AnimationTree may be introduced for blending and state transitions when the representative character requires it.
- Skeleton3D and retargeting tools must be validated with the actual rigs; successful import is not proof of deformation quality.
- Gameplay movement and input must remain responsive independently of animation update choices.

### 6.3 Acceptance set
For a neutral humanoid test asset, validate idle, walk, run, start/stop, turn, interaction reach, listen and safe context animation. This neutral asset must not be Asher or Ember.

For Ember, create a separate animal rig/locomotion test only after species and visual reference are approved. Do not infer species or model details.

## 7. Environment and region rendering

- Build a representative neutral test region before production environment content.
- Keep blockout geometry, gameplay collision, navigation geometry and final art logically separable.
- Use modular terrain, architecture and vegetation families.
- Use LOD/visibility ranges for large environments; verify transitions from actual gameplay cameras.
- Avoid unnecessary unique materials and excessive transparent foliage.
- Use explicit region boundaries and loading/streaming design only after world-navigation architecture is approved.
- Preserve readable landmarks, paths, points of interest and safe routes at lower graphics tiers.
- Re-run navigation, collision, visibility and accessibility checks after art changes.

## 8. Camera, display and UI

- Third-person is the current default baseline; first-person is an approved option where a gameplay use case is defined.
- Test camera clipping, near-plane issues, FOV, sensitivity, motion and companion visibility.
- Android UI must account for display cutouts, safe areas, aspect ratios, touch target size and scaling.
- Text and subtitles require adjustable size and strong contrast.
- Critical information must not depend only on colour, audio or visual effects.
- Test landscape orientation and any other orientation only if explicitly supported by the project design.
- Do not claim controller support until input mapping and device tests confirm it.

## 9. Audio and effects integration

- Keep ambience, dialogue, music, UI and effects on separable audio buses where practical.
- Spatial audio and occlusion should be introduced only when a tested scene benefits from them.
- Keep dialogue intelligible over ambience and music.
- Effects must communicate approved gameplay or narrative meaning.
- No audio/visual system may create spiritual scoring, transactional prayer, purchasable divine favour, or mechanics that contradict BTV canon.
- Avoid adding paid audio middleware without approval.

## 10. Asset acceptance contract

Each imported asset must pass:
1. **Identity:** stable unique asset ID and descriptive name.
2. **Provenance:** creator/source and license/permission recorded.
3. **Technical:** scale, axis, pivot, hierarchy and dependencies correct.
4. **Visual:** materials and textures match approved reference under representative lighting.
5. **Animation:** required clips, skeleton and deformation pass where applicable.
6. **Gameplay:** collision, navigation, interaction and visibility assumptions are explicit.
7. **Performance:** measured cost recorded on representative hardware.
8. **Reimport:** clean import and repeat import after source change produce expected results.
9. **Review:** owner and review status recorded.

Do not accept an asset solely because the editor imports it without errors.

## 11. Validation plan and gates

### Gate 0 — Hardware identification (BLOCKED)
Record the intended minimum Android device and a higher-capability comparison device if available:
- manufacturer/model;
- chipset/SoC and GPU;
- RAM and storage;
- Android version and graphics API;
- display resolution/refresh rate;
- available test access.

No renderer or device-performance approval before this gate.

### Gate 1 — Neutral asset pipeline
Create one neutral static prop, one neutral humanoid test asset and one small material/lighting test scene. Verify Blender → glTF → Godot import/reimport and provenance. Do not use Asher or Ember as test assets.

### Gate 2 — Renderer comparison
Run the same representative scenes/settings across candidate renderers on the target device. Compare visual quality, frame time, memory, thermal behaviour and compatibility. Record trade-offs and choose deliberately.

### Gate 3 — Representative vertical environment
Build a small non-canon test environment with terrain, vegetation, architecture, fog, one character and a small number of NPC placeholders. Validate visual direction and performance before expanding production content.

### Gate 4 — Character/animation integration
Use approved character references only. Validate model, rig, animation, camera and gameplay response in a controlled scene.

### Gate 5 — Android readiness
Requires physical-device export and installation, touch/safe-area checks, sustained performance, memory/thermal/stability testing and documented results. Headless CI does not satisfy this gate.

### Gate 6 — PC scalability
After Android baseline is measured, validate higher settings on a named desktop test machine. PC quality increases must not break gameplay parity or asset provenance.

## 12. Test record template

For every graphics/performance test, record:
- date and tester;
- repository commit;
- Godot version and renderer;
- device/OS/GPU/RAM;
- scene and asset-set version;
- graphics tier and resolution;
- test duration and thermal state;
- frame-time summary and stutter observations;
- memory observations;
- visual defects and gameplay readability;
- result: PASS / FAIL / BLOCKED / NOT RUN;
- evidence link or log location.

## 13. Current status and unresolved decisions

| Item | Status |
|---|---|
| Cinematic semi-realism visual direction | APPROVED DESIGN |
| Android-first, PC-later intent | APPROVED DESIGN |
| Godot 4.7.2 CI baseline | CONFIRMED in repository documentation |
| Project renderer | UNKNOWN / BLOCKED pending device test |
| Target Android device | BLOCKED / not identified |
| Minimum supported hardware | UNKNOWN |
| 30 FPS minimum-device objective | PROPOSED TARGET, not measured |
| 60 FPS higher-tier objective | PROPOSED TARGET, not measured |
| Fixed asset budgets | UNKNOWN pending representative scene/device profiling |
| Production Asher/Ember assets | NOT IMPLEMENTED / require approved references |
| Android export and sustained QA | NOT RUN / BLOCKED |

## 14. Source documents

- `docs/implementation/BOOTSTRAP_STATUS.md`
- `docs/research/BTV_BLENDER_GODOT_ASSET_PIPELINE_RESEARCH_2026-11-05.md`
- `docs/research/BTV_CHARACTER_AND_ANIMATION_PIPELINE_RESEARCH_2026-11-05.md`
- `docs/research/BTV_WORLD_CONSTRUCTION_AND_ENVIRONMENT_ART_RESEARCH_2026-11-05.md`
- `docs/research/BTV_GODOT_3D_SMALL_TEAM_POSTMORTEM_RESEARCH_2026-11-05.md`
- `docs/coordination/BTV_RESEARCH_TO_DESIGN_TRACEABILITY_MATRIX_2026-11-06.md`
- Official Godot documentation: https://docs.godotengine.org/en/stable/

---
**Governance note:** This document records approved intent and proposed technical gates. It does not select a renderer, certify a device, change canon, approve paid dependencies or claim production visuals are implemented.

## 15. Research update and benchmark contract

The following research has been reviewed against Godot 4.7 documentation and Android Developers guidance:
- `docs/research/BTV_ANDROID_GRAPHICS_AND_DEVICE_BENCHMARK_RESEARCH_2026-11-06.md`
- `docs/qa/BTV_NEUTRAL_GRAPHICS_BENCHMARK_SCENE_ACCEPTANCE_CONTRACT_v1.0.md`

Key implementation implications:
- Mobile renderer is the first Android candidate, not a preselected result. Godot 4.7 documents Forward+ as substantially less efficient on mobile; Mobile is designed around mobile GPU constraints but has feature and HDR trade-offs.
- Mobile's documented lighting limits and post-processing trade-offs mean the art direction must not depend on expensive glow/depth-of-field effects or many overlapping shadowed local lights.
- Godot mesh LOD, visibility ranges/HLOD, MultiMesh and baked lighting are candidate optimization techniques. Validate skinned-character LOD visually and measure vegetation overdraw.
- Android tests must include sustained sessions, thermal state, frame pacing, memory and touch response. Android's current game guidance recommends testing across device tiers and extended sessions of 15+ minutes for thermal evaluation.
- The project must not set fixed geometry or memory budgets before the target device and representative asset scene are measured.

The neutral benchmark scene now has a separate acceptance contract. It defines five zones (materials, lighting, vegetation, neutral character, settlement blockout), fixed camera traversal, debug controls, telemetry, test procedure and acceptance gates. It deliberately excludes production Asher/Ember assets and canon content.

### Research source links
- Godot 4.7 rendering architecture: https://docs.godotengine.org/en/4.7/engine_details/architecture/internal_rendering_architecture.html
- Godot 4.7 3D optimization: https://docs.godotengine.org/en/4.7/tutorials/performance/optimizing_3d_performance.html
- Godot 4.7 mesh LOD: https://docs.godotengine.org/en/4.7/tutorials/3d/mesh_lod.html
- Android game optimization: https://developer.android.com/games/optimize
- Android ADPF best practices: https://developer.android.com/games/optimize/adpf/best-practices-adpf?hl=en
- Android game optimization tools: https://developer.android.com/games/tools

**No renderer is selected by this research update.** Device identification and physical-device testing remain blocking prerequisites.
