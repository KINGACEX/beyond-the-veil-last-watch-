# BTV Neutral Graphics Benchmark — Implementation Status 001

**Updated:** 11 November 2026  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Status:** REPEATABLE SOFTWARE BENCHMARK IMPLEMENTED; PHYSICAL-DEVICE ACCEPTANCE BLOCKED  
**Engine validation:** Godot 4.7.2 headless CI

## 1. Implemented structure

The benchmark is a separate, canon-neutral scene at `scenes/neutral_graphics_benchmark.tscn`. It contains five test areas:

1. **Material bay:** skin-like, fabric-like, painted-metal, stone, wood and glass-like material samples.
2. **Lighting bay:** one directional sun, two non-shadowed local lights and controlled receiver geometry.
3. **Vegetation lane:** twelve repeated trunk/canopy proxy groups.
4. **Character pad:** a simple neutral capsule mannequin with a separate head placeholder.
5. **Settlement blockout:** courtyard/interior walls and three neutral NPC placeholder capsules.

A connected route is marked by six waypoints and five visible greybox route segments. The scene has a dedicated camera, procedural sky/ambient environment, a directional light and a HUD reporting the active test state.

## 2. Functional debug controls

| Key | Control | Actual effect |
|---|---|---|
| 1 | Shadows | Toggles the benchmark directional light's shadow casting |
| 2 | Fog | Toggles the Environment fog setting |
| 3 | Foliage | Toggles visibility of all twelve foliage proxy groups |
| 4 | NPC placeholders | Toggles visibility of the three placeholder NPC groups |

These are real state changes, not decorative labels. The test suite invokes the controls and checks the resulting state.

## 3. Supporting isolated labs

- **Wildlife LOD lab:** ten neutral proxy agents across near/mid/far/off-screen groups. The deterministic scheduler highlights the bounded workload selected each tick. No animal models, navigation, production spawning or species placements are connected.
- **Weather-zone lab:** base, forest and coastal normalized profiles. Three sample positions demonstrate local profile influence and a true overlap blend. Keys 1/2/3 move the sample point.
- **Optics lab:** reflection/refraction/TIR ray demonstrations plus matte, metallic and glass-like samples, a shadow receiver, a shadow-casting reference and a non-shadow reference.

## 4. Automated verification

**PASS:** [Godot 4.7.2 CI run #42794875510](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42794875510), tested code commit `b5cd3bc537eebbc34df4be1db23e706c383dacb3`. The complete workflow passed, including all new wildlife, weather, optics and neutral graphics benchmark tests and the existing regression suite.

Structural tests verify the presence of the five benchmark zones, route segments, twelve foliage proxies, three NPC placeholders, telemetry and functional toggles.

## 5. Remaining acceptance gaps

The 11 November follow-up closes the software-side route, warm-up/dwell, run export and supported scene-profile gaps. The benchmark remains a structural greybox and is not a production-quality graphics demonstration.

- No physical-device visual captures or defect log.
- No device-specific CPU profiler, GPU timestamps/utilization, process/GPU memory, thermal or power telemetry.
- No physical Android export/install and sustained 15-minute device run.
- No production vegetation, final materials, rigged characters or production wildlife assets.
- No complete production LOD/HLOD, shadow-distance or shadow-resolution acceptance.
- Renderer choice and target-device resource caps remain deliberately undecided.

Do not report FPS/performance acceptance, memory, thermal behaviour or Android readiness from headless CI or from the current frame-delta data.

## 6. Next engineering sequence

1. Run the documented procedure on a named physical Android device and retain JSON exports.
2. Collect device-profiler evidence for CPU execution, GPU timing/utilization, memory, thermal state and power separately.
3. Capture the six fixed viewpoints at equivalent exposure and record visual/LOD/shadow defects.
4. Repeat each comparison configuration and preserve run-to-run variance.
5. Select renderer and production quality defaults only after target-device evidence and an explicit decision record.

## 7. Boundaries

The benchmark contains no Asher, Ember, Covenant, production region, mission, combat, enemy or weapon content. It is not a new canon location. No paid asset, external dependency, release, merge or production-region integration is included.


## 8. Follow-up implementation — 10 November 2026

**Code HEAD:** `920364cb18c41da089ad97cb3156b46a172f7236`  
**Validation:** [Godot 4.7.2 CI run #42801417895](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42801417895) — PASS.

Two repeatability/measurement improvements are now implemented:

- `scripts/benchmark_metrics.gd` provides deterministic frame-time summaries: sample count, arithmetic mean, median, nearest-rank p95, maximum and count above a configurable stutter threshold. Invalid, negative, non-finite or empty samples are rejected.
- `scripts/neutral_graphics_benchmark.gd` keeps a bounded rolling window of up to 3,600 frame-delta samples and exposes the summary API. This is CPU frame-delta sampling only; it is not GPU timing, memory telemetry, thermal data or a substitute for a platform profiler.
- The benchmark now has a fixed six-viewpoint camera route. Key 5 starts the route; key 6 stops it. Each segment uses a fixed two-second interpolation. This supports repeatable camera viewpoints, but it is not yet a full benchmark capture protocol with dwell points, warm-up/cold-run controls or automated screenshot capture.
- CI now runs `tests/benchmark_metrics_test.gd` and extends the graphics benchmark test to cover bounded sampling, summary availability, route start/stop and route completion.

**Remaining acceptance gaps:** device-specific profiler integration; memory/CPU/GPU/thermal observations; render-scale and supported quality variants; fixed dwell points and repeatable run metadata export; visual captures and defect log; physical Android export/install and sustained profiling. Renderer choice remains deliberately undecided.


## 9. Follow-up implementation — 11 November 2026

**Starting HEAD:** `3e6cc1670e1ebfe3e2cf109951d947a49e7f9d05`  
**Implementation commit:** `eae2422881f1561f15292ac46594f7c492959055`  
**Godot validation:** [run #42999606927](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42999606927) — PASS on Godot 4.7.2. The complete workflow, all contract/regression test steps and both scene-launch steps succeeded.

### Repeatable benchmark protocol

- Six fixed camera dwell points; 5-second warm-up at viewpoint 0; 1-second transit between points; 3-second dwell at each point; 28 seconds total.
- Frame-delta sampling occurs only during dwell windows. Warm-up and camera transit intervals are excluded.
- JSON metadata schema v3 records build/scene/asset identifiers when supplied, engine/platform/device context, scene quality profile, render scale, protocol, route points, frame-time summary and explicit telemetry availability.
- Completed runs export to `user://benchmark_runs/`; export is refused before a completed run.
- Supported render scales: `1.00`, `0.85`, `0.70`.
- Supported benchmark-scene profiles: `reference`, `reduced`, `minimal`. These apply only to benchmark shadows/fog/foliage/NPC proxies; they are not project-wide or renderer-wide game quality presets. Individual toggles mark the state as `custom`.
- Controls: `Q` cycles scene profiles; `9` cycles render scale; `0` restores native scale; `7` starts an acceptance run; `8` exports a completed run. Keys `1`–`4` remain individual scene toggles.

### Telemetry boundary

The only collected measurement is the Godot `Node._process(delta)` main-loop frame interval in milliseconds. It is not CPU execution time or utilization. GPU frame time/utilization, process memory, GPU memory, device RAM telemetry, thermal state and power draw remain explicitly unavailable in the exported record. Device identity fields supplied through environment variables are descriptive metadata, not sensor measurements.

### Wildlife visual and evidence validation

- The isolated visual lab now includes generic fur-tuft, feather-layer and scale-plate surface details, eased bounded locomotion/idle cycles, presentation-only woodland/perch/rocky habitats and near/mid/far/off visual-detail reduction.
- The species-profile validator rejects non-finite confidence values and requires non-empty evidence context when fossil evidence is attached to a non-deep-time profile.
- Ecology input guards reject non-finite habitat measurements, weights, thresholds and simulation distances safely.
- No species is assigned to a placeholder, no habitat prop is treated as occurrence evidence, and no production wildlife or Ember canon is changed.

### Verification

The full Godot 4.7.2 workflow passed on implementation commit `eae2422881f1561f15292ac46594f7c492959055`, including the wildlife visual prototype, wildlife ecology, species schema, visual LOD, benchmark, metrics, existing input/control, movement, optics, weather and exploration regression suites.

Physical-device visual/performance acceptance remains blocked. This implementation does not claim Android frame rate, GPU performance, memory use, thermal stability or production readiness.
