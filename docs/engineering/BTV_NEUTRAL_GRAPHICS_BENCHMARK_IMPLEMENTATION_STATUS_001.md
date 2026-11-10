# BTV Neutral Graphics Benchmark — Implementation Status 001

**Date:** 10 November 2026  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Status:** STRUCTURAL GREYBOX IMPLEMENTATION; FULL BENCHMARK ACCEPTANCE NOT YET MET  
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

The scene is not yet a complete performance benchmark or production-quality graphics demonstration.

- No fixed route timings/dwell protocol or automated camera traversal.
- No renderer switch; renderer choice remains device-dependent and intentionally undecided.
- No viewport/render-scale control.
- No live frame-time, memory, CPU/GPU or thermal telemetry.
- No representative production vegetation, rigged animation, final materials or authored assets.
- No complete LOD/HLOD transition suite or shadow-distance/resolution variants.
- No visual comparison captures or defect log from a physical device.
- No Android export/install or sustained 15-minute device run.

Do not report FPS, memory, thermal performance or Android readiness from this greybox scene or from headless CI.

## 6. Next engineering sequence

1. Add camera-route playback and repeatable benchmark timing.
2. Add measured frame-time sampling and exportable run metadata, keeping unavailable metrics explicitly unavailable.
3. Extend shadow/LOD/fog comparison variants without hard-coding device caps.
4. Profile on a named physical Android device before selecting renderer or quality defaults.
5. Complete manual visual review and update the acceptance contract only with evidence.

## 7. Boundaries

The benchmark contains no Asher, Ember, Covenant, production region, mission, combat, enemy or weapon content. It is not a new canon location. No paid asset, external dependency, release, merge or production-region integration is included.
