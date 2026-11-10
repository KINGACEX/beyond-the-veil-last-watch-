# BTV Development Checkpoint 20 — Wildlife, Weather and Graphics Validation Labs 2026-11-10

**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Code commit tested:** `b5cd3bc537eebbc34df4be1db23e706c383dacb3`  
**Status:** FOUR ENGINEERING MILESTONES IMPLEMENTED; GODOT 4.7.2 CI PASSED

## Milestone 1 — Wildlife LOD validation lab

**COMPLETED**
- Added `scenes/wildlife_validation_lab.tscn` and its controller.
- Builds ten neutral proxy markers across near, mid, far and off-screen tiers.
- Uses the deterministic, fair per-tier update scheduler at a bounded test cadence.
- Telemetry reports scheduled workload and tier counts; bright/dim proxy markers distinguish scheduled/deferred work.
- Added `tests/wildlife_validation_lab_test.gd` and CI coverage.

**BOUNDARY:** These are workload proxies, not animal models. No species placement, animal navigation, production spawning, Ember changes or wildlife interaction systems are connected.

## Milestone 2 — Local weather-zone validation lab

**COMPLETED**
- Added `scenes/weather_validation_lab.tscn` and its controller.
- Added base, forest and coastal normalized weather test profiles.
- The two local zones genuinely overlap; sample points at forest, overlap and coastal positions demonstrate weighted profile composition.
- Keys 1/2/3 select the sample position.
- Added `tests/weather_validation_lab_test.gd` and CI coverage.

**BOUNDARY:** No production rain, wind, fog, particle, audio or time-of-day effects are connected. The lab validates normalized profile composition, not final weather visuals.

## Milestone 3 — Optics, material and shadow comparison

**COMPLETED**
- Extended the isolated optics validation lab with a shadow receiver, shadow-casting reference and non-shadow reference.
- Added matte, metallic and glass-like material samples.
- Enabled the controlled directional shadow for the lab.
- Expanded scene acceptance tests and CI coverage.

**BOUNDARY:** This is a visual test station, not evidence of mobile shadow performance or physically accurate glass/refraction rendering. Godot renderer choice remains undecided.

## Milestone 4 — Neutral five-zone graphics benchmark

**COMPLETED — STRUCTURAL GREYBOX**
- Added `scenes/neutral_graphics_benchmark.tscn`.
- Built material, lighting, vegetation, neutral character and settlement blockout zones.
- Added twelve vegetation proxy groups and three neutral NPC placeholders.
- Added a six-waypoint, five-segment route connecting the test areas.
- Implemented working debug controls: 1 shadows, 2 fog, 3 foliage visibility, 4 NPC placeholder visibility.
- Added telemetry and `tests/neutral_graphics_benchmark_test.gd`.

Detailed status: [BTV Neutral Graphics Benchmark — Implementation Status 001](../../engineering/BTV_NEUTRAL_GRAPHICS_BENCHMARK_IMPLEMENTATION_STATUS_001.md).

**BOUNDARY:** The scene is not yet a full benchmark acceptance pass. Fixed camera-route timing, live frame-time/memory telemetry, renderer/scale variants, visual captures and physical-device profiling remain outstanding.

## Verification

**PASS:** [Godot 4.7.2 CI run #42794875510](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42794875510), tested code commit `b5cd3bc537eebbc34df4be1db23e706c383dacb3`. The workflow completed successfully, including the existing regression tests and the new wildlife validation lab, weather validation lab, optics material/shadow stations and neutral graphics benchmark tests.

The prior run #42794302374 failed because the weather lab scene referenced a subresource before its declaration. The issue was corrected and the final code commit passed the full workflow. No unresolved failure is being represented as a pass.

## Repository routing note

Two weather-lab corrective commits were initially written to `main` because the branch argument was omitted from those two calls. The same corrected file contents were then committed to this development branch and validated here. No merge or rollback was performed. The accidental main-branch commits are limited to the weather lab script and scene; they do not include the wildlife lab, optics changes or graphics benchmark. The separate recovery branch `btv/environment-validation-recovery-001` was created from the then-current main commit for traceability and has not been merged.

## Remaining blockers

1. Add fixed camera-route playback and benchmark timing.
2. Add frame-time sampling and benchmark metadata capture.
3. Extend material/shadow/LOD comparison cases.
4. Obtain physical Android hardware for export/install, touch, renderer, memory, frame-time and thermal validation.
5. Complete movement Gate C human feel review before Ridgeview blockout.

No release, merge, paid service, external dependency, production-region integration or canon change was performed.
