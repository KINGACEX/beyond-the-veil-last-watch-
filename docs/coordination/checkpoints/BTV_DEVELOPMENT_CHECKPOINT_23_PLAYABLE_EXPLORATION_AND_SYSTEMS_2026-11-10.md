# BTV Development Checkpoint 23 — Playable Exploration, Journal, Benchmark and Wildlife Presentation

**Date:** 10 November 2026  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Verified baseline before final journal-HUD refresh:** `c64e3f2b3a4dd3d483d546db2490785fef5e5003`  
**Godot CI:** [Run #42805268157](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42805268157) — **PASS**, 47 successful steps on the exact baseline commit above.

## 1. Playable exploration greybox — IMPLEMENTED

The project startup scene now points to `scenes/exploration_prototype.tscn`.

New files:
- `scenes/exploration_prototype.tscn`
- `scripts/exploration_prototype.gd`
- `scripts/exploration_observation.gd`
- `tests/exploration_prototype_test.gd`

The scene composes the existing third-person player controller and Android touch controls into a small navigable environment. The greybox contains:
- A broad collision ground and readable path layout.
- A visual-only pond landmark.
- A collision-backed rock shelf, stepped rise and short ramp.
- Low-density procedural tree proxies and boulder props.
- Four field-observation points.
- Control guidance, interaction feedback and a journal counter.

The existing player movement, camera, jump, bounded double-jump, dash and interaction contracts are reused; no new player ability is approved by this checkpoint. The scene is a functional greybox, not a finished region or production art pass.

## 2. Persistent exploration journal — IMPLEMENTED

New files:
- `scripts/exploration_journal.gd`
- `tests/exploration_journal_test.gd`

Field-note discoveries are recorded once by stable ID and saved locally to `user://btv_exploration_journal.cfg`. The HUD reports recorded observations against the four authored points. The journal has no currency, inventory, reward, faith or mission-progression effects.

The player controller now emits an `interaction_completed(message)` signal after a successful interaction so the world UI can display feedback without duplicating the interaction call.

## 3. Graphics benchmark acceptance protocol — IMPLEMENTED, device telemetry still limited

The neutral benchmark now supports:
- A five-second warm-up phase.
- A fixed six-viewpoint capture sequence.
- A one-second viewpoint transition and three-second dwell at each viewpoint.
- Frame-interval sampling only during dwell windows.
- JSON metadata export to `user://benchmark_runs/` (keyboard 7 starts a run; 8 exports completed metadata).

Metadata records the project and engine version, platform, viewport dimensions, benchmark settings, protocol timings, viewpoints, sample count and summary. It explicitly labels measurements as Godot process-delta frame intervals.

**Not measured:** isolated GPU time, memory use, thermal state, power draw or device-specific performance. These require appropriate profiler access and physical-device runs. The six-viewpoint route is a repeatable greybox protocol, not yet a full quality-tier/render-scale comparison suite.

## 4. Wildlife visual presentation LOD — PROTOTYPE IMPLEMENTED

New files:
- `scripts/wildlife_visual_lod.gd`
- `tests/wildlife_visual_lod_test.gd`

The generic mammal, bird and reptile forms now use a presentation LOD helper independent from the existing wildlife simulation scheduler:
- Near: full greybox geometry.
- Mid: full current placeholder geometry.
- Far: hide small limb, tail, wing and beak detail.
- Off: hide the specimen root.

Prototype distance boundaries are 18 m, 45 m and 90 m, refreshed at 0.25-second intervals in the lab. These are engineering test defaults, not tuned production values. No real species are assigned. Geometry, materials and animation remain primitive placeholders; no skeletal locomotion or habitat-authentic models have been produced.

## 5. Validation

The baseline CI run #42805268157 passed 47 steps, including:
- Existing player, touch, traversal, optics, wind, weather, ecology and schema suites.
- Wildlife visual prototype and visual LOD tests.
- Benchmark run-state, dwell, metadata and JSON-export tests.
- Playable exploration scene acceptance and ten-frame headless launch.
- Local journal persistence tests.

A subsequent small change refreshes the exploration HUD counter immediately after a discovery; its latest commit is `11de5fbc24dbbdfa6b401968159ac6822d46c20a`. A fresh CI run is required before treating that latest HEAD as verified.

## 6. Canon and scope boundaries

- No changes to Asher Vance, Ember, Covenant, church, prayer, Communion or theological canon.
- No unsupported wildlife species placement, fossil co-occurrence or palaeo-era mixing.
- No hunting, attacks, injury, capture, combat or weapon systems.
- No paid assets, new external dependencies, main-branch merge, release or publication.
- Renderer choice remains open pending Android device comparison.
- Physical Android installation, touch usability, sustained frame pacing, memory and thermal acceptance remain unverified.

## 7. Next engineering priorities

1. Validate the latest HUD change and keep the branch green.
2. Add a small automated exploration route test covering movement, camera, jump/dash and all four field-note interactions.
3. Replace primitive environment props with modular, reusable environment assets only after a mobile budget is measured.
4. Add a species-authentic wildlife prototype only after selecting a candidate with verified taxonomy, range, habitat and reference material.
5. Add capture comparison across supported renderer/quality configurations after the Android export and device profiling path is available.
6. Keep the exploration scene as the prototype entry point while maintaining the neutral movement and graphics labs as separate acceptance scenes.

**Status:** A first playable exploration greybox is now the project startup scene. It supports movement, camera control, touch controls, non-violent field-note interaction and local journal persistence. Production art, species-authentic wildlife, final game systems and Android device acceptance remain unfinished.
