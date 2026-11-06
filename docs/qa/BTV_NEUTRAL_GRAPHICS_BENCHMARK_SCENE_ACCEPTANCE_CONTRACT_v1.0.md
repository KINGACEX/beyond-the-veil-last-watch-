# BTV NEUTRAL GRAPHICS BENCHMARK SCENE — ACCEPTANCE CONTRACT v1.0

**Date:** 6 November 2026  
**Status:** PROPOSED — CONTRACT BEFORE IMPLEMENTATION  
**Engine:** Godot 4.7.2 baseline  
**Purpose:** Define a reproducible, canon-neutral test scene for graphics, import and performance evaluation.

## 1. Scope and exclusions

This is a technical benchmark scene, not a game level, mission, vertical slice or canonical BTV location.

It must not contain:
- Asher, Ember or any production character design;
- unresolved Ember species/appearance assumptions;
- Covenant story content, named NPCs or approved mission locations;
- combat, weapons, enemies, Veil mechanics or new narrative canon;
- paid assets, runtime services or unapproved dependencies.

Use neutral placeholder geometry and a clearly labelled neutral humanoid mannequin only.

## 2. Scene composition

Create one compact test map with five connected test zones:
1. **Material bay:** neutral cubes/spheres/planes displaying skin-like, fabric-like, painted metal, stone, wood, glass and foliage test materials. These are shader/material samples, not character assets.
2. **Lighting bay:** one directional light, a small controlled set of local lights, static/baked and dynamic comparison areas, shadow on/off comparison.
3. **Vegetation lane:** repeated neutral tree/shrub/grass meshes with near/mid/far LOD and visibility-range checks.
4. **Character pad:** neutral humanoid mannequin with a simple skeleton and a small animation test set (idle, walk, run, turn). No final facial identity or costume.
5. **Settlement blockout:** simple modular walls, doorway, courtyard, interior/exterior transition and several neutral NPC placeholders to test occlusion, draw cost and camera visibility.

Include an unobstructed route connecting all five zones for repeatable traversal.

## 3. Camera and traversal

- Use a fixed, documented third-person camera baseline matching the current prototype's camera conventions.
- Provide a repeatable route with fixed waypoints and approximate dwell times.
- Include one slow pan, one full turn, one near/far view of vegetation and one interior/exterior transition.
- Keep camera sensitivity and movement speed fixed for benchmark runs.
- Do not add a first-person implementation solely for this benchmark.

## 4. Controlled graphics toggles

Expose debug-only toggles or documented project variants for:
- renderer (only options supported by the actual Godot 4.7.2 build and device);
- viewport/render scale;
- shadow quality and shadow distance;
- fog;
- glow/other post effects individually;
- foliage density;
- LOD/HLOD visibility ranges;
- baked/static versus selected dynamic lighting;
- NPC placeholder count.

A toggle must genuinely affect the intended feature and report its active state. Do not create fake toggles or expose unsupported settings as functional.

## 5. Required telemetry and test record

Each run must record:
- project commit and Godot version;
- renderer and graphics API;
- device model, SoC/GPU, RAM and Android version (or PC hardware/OS);
- viewport and display resolution, refresh rate, render scale and quality tier;
- scene revision and asset-set revision;
- test duration and traversal variant;
- frame-time samples or a reproducible profiler capture;
- average, median and high-percentile frame times;
- stutter/hitch count and observed locations;
- memory observations and peak if available;
- CPU/GPU bottleneck evidence if available;
- thermal state and any throttling during Android runs;
- input-to-display observations for physical touch runs;
- visual defects, LOD pop, shadow instability, material errors and missing assets;
- PASS / FAIL / BLOCKED / NOT RUN with evidence path.

Do not claim FPS, memory or thermal results from screenshots alone.

## 6. Test protocol

1. Confirm the scene and asset revision.
2. Launch a cold run and verify no import/runtime errors.
3. Traverse all five zones using the fixed route.
4. Repeat with each relevant graphics toggle changed one at a time.
5. Run a sustained Android session of at least 15 minutes for thermal and stability observation.
6. Repeat key runs to identify variance.
7. Compare equivalent camera positions and exposure when judging visual quality.
8. Record all results; never average away severe hitching or thermal degradation.
9. Re-run import and headless project validation after scene changes.

## 7. Acceptance criteria

### Structural
- Scene opens and runs in the pinned Godot version.
- All five zones and traversal route are present.
- No production/canon character or narrative content is introduced.
- Every debug toggle is functional or explicitly marked unsupported.
- Test record contains all applicable environment and revision metadata.

### Visual
- Materials are distinguishable under representative lighting.
- Characters/mannequin remain readable at near and gameplay distances.
- LOD transitions do not create unacceptable silhouette or shadow defects.
- Fog and post effects do not hide the test route or key objects.
- Lighting comparisons use equivalent camera positions.

### Performance
- No universal FPS pass threshold is assigned before minimum target hardware is named.
- Record frame-time distribution and sustained behaviour.
- After hardware selection, apply the project-approved target frame-time objectives and device-specific pass/fail thresholds.
- No renderer is declared selected from editor/desktop-only evidence.

### Platform
- Desktop/headless pass does not satisfy Android acceptance.
- Android acceptance requires physical-device export/install and sustained test evidence.
- Device tier and minimum supported hardware must be explicitly named.

## 8. Out-of-scope until separately approved

- Production character modelling or final Asher/Ember rigs.
- World streaming implementation.
- Large NPC simulation or persistent world state.
- Android thermal-adaptation integration or native plugins.
- Fixed polygon, texture, draw-call, memory or NPC budgets.
- Final renderer selection and release device certification.

## 9. Required evidence artifacts

Store:
- scene screenshots from fixed camera positions;
- import and runtime logs;
- benchmark metadata and frame-time captures;
- device details and thermal observations;
- visual defect log;
- comparison summary and explicit decision record.

## 10. Decision rule

The benchmark exists to inform decisions, not to justify a predetermined renderer. Choose the simplest supported pipeline that meets BTV's approved cinematic semi-realism direction on the declared minimum Android device with stable sustained performance. If evidence is missing, mark the result BLOCKED rather than guessing.
