# BTV ANDROID GRAPHICS AND DEVICE BENCHMARK RESEARCH — 2026-11-06

**Status:** RESEARCH REVIEWED; IMPLEMENTATION GATES PROPOSED  
**Scope:** Godot 4.7.2 renderer evaluation, Android sustained performance, asset optimization and device test strategy.  
**Constraint:** No exact minimum/test Android device has been specified. This research does not select a renderer or certify hardware.

## Executive findings

1. Keep the Godot renderer undecided until a real target Android device and representative scene are available.
2. Treat Mobile as the first renderer candidate for Android, not as a guaranteed winner. Compare it with Compatibility when device/API support requires it and Forward+ only where the intended hardware and visual requirements justify the test.
3. Godot's 3D optimization guidance supports mesh LOD, visibility-range/HLOD, MultiMesh for repeated geometry and baked lighting where dynamic lighting is unnecessary. These are candidate techniques, not blanket rules; profile each in BTV scenes.
4. Android performance must be measured over sustained play. Thermal throttling, frame pacing, memory pressure and touch-to-display latency can make short editor or desktop tests misleading.
5. Define representative device tiers and test across more than one hardware class before claiming Android support. Android's own guidance recommends device-tier coverage and extended sessions (15+ minutes) when evaluating thermal adaptation.
6. Do not invent fixed triangle, texture, draw-call or memory budgets before the target hardware and representative assets are measured.

## Godot 4.7 renderer evidence

The Godot 4.7 rendering architecture documentation describes:
- **Forward+:** clustered lighting, generally suited to desktop; the documentation notes it is substantially less efficient on mobile.
- **Mobile:** a forward renderer designed for mobile GPU constraints. Its trade-offs include reduced default HDR precision and feature limitations compared with Forward+.
- **Compatibility:** a separate rendering path whose suitability depends on the project's graphics API and target-device support needs.

Important Mobile renderer constraints described in the 4.7 architecture documentation:
- Mobile uses a traditional single-pass lighting approach.
- The documented per-mesh limits are 8 OmniLights and 8 SpotLights affecting a mesh, plus camera-view limits.
- Some post-processing features such as glow and depth of field are not efficient in the Mobile renderer due to tile/subpass constraints.
- Enabling HDR 2D in Mobile can increase bandwidth use and reduce performance.

**BTV implication:** avoid building the visual identity around a single expensive post-process effect. Establish atmosphere through composition, material work, authored lighting and carefully profiled effects. Verify the exact renderer behaviour against the pinned Godot 4.7.2 build.

Source: Godot 4.7, Internal rendering architecture  
https://docs.godotengine.org/en/4.7/engine_details/architecture/internal_rendering_architecture.html

## Godot 3D optimization evidence

Godot's optimization documentation identifies:
- Automatic mesh LOD and manual visibility ranges/HLOD as distance-based detail controls.
- MultiMesh for repeated identical geometry such as grass, particles and flocks.
- Baked lighting as a potentially strong mobile optimization, with the trade-off that it is not dynamic.
- Real-time lights and shadows, especially multiple shadow-casting lights and global illumination, can be expensive on lower-power mobile hardware.

The Godot 4.7 LOD documentation notes that automatic mesh LOD is generated for supported imported 3D scenes, including glTF and Blender scene imports, but can introduce visual issues, especially on skinned meshes. Therefore skinned characters require visual review after LOD generation.

**BTV implication:** use automatic LOD as a starting point for static environment assets; explicitly inspect character LODs and use manual HLOD/visibility ranges for region-scale composition. Test foliage batching and overdraw rather than assuming MultiMesh alone solves all vegetation cost.

Sources:
- https://docs.godotengine.org/en/4.7/tutorials/performance/optimizing_3d_performance.html
- https://docs.godotengine.org/en/4.7/tutorials/3d/mesh_lod.html

## Android sustained-performance evidence

Android Developers' game optimization documentation identifies:
- CPU/GPU load and thermal throttling as causes of slow frames.
- Frame pacing and VSync alignment as important to smoothness.
- Touch-to-display latency can be affected by an overfilled frame buffer.
- Long sessions can expose memory pressure and performance deterioration.
- Android GPU Inspector, Perfetto/system tracing, Android Performance Tuner, ADPF and memory tools can help diagnose bottlenecks.

Android's ADPF best-practice guidance recommends defining device tiers, testing across high-, mid- and low-end devices, validating thermal response and including extended play sessions (15+ minutes).

**BTV implication:** a short successful launch is not a performance pass. Benchmark cold start and sustained play, record frame-time distribution, thermal state, memory and input responsiveness, and compare quality tiers under repeatable conditions.

Sources:
- https://developer.android.com/games/optimize
- https://developer.android.com/games/optimize/overview
- https://developer.android.com/games/optimize/adpf/best-practices-adpf?hl=en
- https://developer.android.com/games/optimize/adpf/thermal
- https://developer.android.com/games/tools

## Recommended BTV benchmark matrix

### Device tiers
Do not name specific phone models until the creator identifies available devices and the minimum intended support class.

| Tier | Purpose | Required evidence |
|---|---|---|
| Minimum target Android | Establish minimum supported experience | Sustained frame time, memory, thermal stability, input response, export/install |
| Mainstream Android | Validate intended default quality | Same metrics plus representative region/character scenes |
| Higher-end Android | Measure quality headroom | High tier and effect scalability |
| PC comparison | Validate later scalable presentation | Renderer/quality comparison; not a substitute for Android testing |

At least one physical device is required to begin meaningful Android benchmarking. A second device in a different hardware class is strongly preferred before setting broad support claims.

### Representative scenes
1. **Material/lighting test:** neutral props, skin/fabric/stone material swatches, one directional light, selected local lights, fog and tone mapping.
2. **Vegetation test:** terrain, repeated grass/shrub/tree meshes, LOD transitions, shadow variants and camera traversal.
3. **Character test:** neutral humanoid model, skeleton, animation blending, camera distance and facial readability.
4. **Settlement test:** modular architecture, several NPC placeholders, indoor/outdoor transition, occlusion and navigation.
5. **Atmosphere test:** dawn/day/evening variants, weather/fog, particles and post-processing with effects toggled individually.
6. **Transition test:** enter/exit region, load/unload content, observe memory and frame-time spikes.

Do not use unfinished Asher or Ember assets as neutral benchmark placeholders. Ember's species and final visual identity remain unresolved.

### Measurement protocol
For each device/renderer/quality-tier combination:
1. Record device model, SoC/GPU, RAM, Android version, graphics API, display resolution and refresh rate.
2. Record exact Godot 4.7.2 build, project commit, renderer, scene revision, resolution scale and quality settings.
3. Run a cold-start test.
4. Run a repeatable traversal and camera path in each representative scene.
5. Run a sustained session of at least 15 minutes; extend if thermal/frame-time trends have not stabilized.
6. Capture frame-time distribution, average/median and high-percentile values, stutter events, CPU/GPU bottleneck evidence where available, memory, thermal state and touch-to-display response.
7. Repeat runs to check variance; document ambient conditions and device power mode where possible.
8. Record defects and compare visual output at equivalent camera positions.

### Decision rule
Choose the renderer and default quality tier that deliver the best stable, readable BTV presentation on the declared minimum device—not the most impressive screenshot on a high-end desktop. Keep high settings as optional tiers where measured hardware supports them.

## Known limitations and non-decisions

- No target Android device or minimum hardware tier has been named.
- The current project configuration intentionally leaves the renderer undecided.
- No representative production asset set or benchmark scene is implemented.
- No physical-device export/install or sustained performance results are available.
- No fixed triangle, texture, memory, draw-call or NPC-count budget is approved.
- No Android-specific native plugin or paid profiling tool is approved or required by this research.

## Next safe milestone

Write and review a **Neutral Graphics Benchmark Scene Acceptance Contract** before creating the scene. The contract should define exact test objects, camera path, effect toggles, expected visual checks, telemetry fields, pass/fail thresholds and evidence storage. Then create the neutral scene and run CI/import checks. Physical-device performance gates remain blocked until a target phone is identified and available.

## Sources and version notes

All engine-specific claims above are grounded in Godot 4.7 documentation, matching the project's pinned CI version. Android platform guidance is taken from Android Developers' game optimization documentation. Re-check documentation when upgrading engine or Android target SDK.
