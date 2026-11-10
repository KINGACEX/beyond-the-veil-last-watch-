# BTV Development Checkpoint 14 — Optics Validation and Weather Research — 2026-11-10

**Branch:** btv/controls-hardening-prototype-layout-plan-001  
**Optics validation commit:** 9197219382d046547c5495e7344bf2e5f9c59480  
**Godot version:** 4.7.2  
**Status:** Optics solver and validation scene automated checks passed; wind/weather research documented; no production lighting or weather integration approved.

## 1. Completed — optics validation

Added:
- scripts/optics_solver.gd — deterministic vector reflection, Snell-law refraction, total internal reflection and critical-angle calculation.
- tests/optics_solver_test.gd — reflection, refraction, TIR, critical-angle, normal-incidence and invalid-index checks.
- scripts/optics_validation_lab.gd and scenes/optics_validation_lab.tscn — separate 3D ray-path validation scene.
- tests/optics_validation_lab_test.gd — scene structure and generated ray example checks.
- CI workflow steps for both new test suites.

**PASS:** [Godot 4.7.2 CI run #42781103405](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42781103405), tested commit 9197219382d046547c5495e7344bf2e5f9c59480. Existing regression tests, traversal jump/dash, optics solver, optics lab scene and neutral movement lab launch passed.

This verifies automated calculations and scene instantiation only. Rendered visual quality, lighting quality, Android export and physical-device performance remain unverified.

## 2. Completed — wind and weather research

Research document:
[ BTV Wind, Weather and Atmospheric Systems Research 001 ](../../engineering/BTV_WIND_WEATHER_AND_ATMOSPHERIC_SYSTEMS_RESEARCH_001.md)

Key findings:
- Godot Area3D wind currently affects SoftBody3D only; ordinary physics bodies need a separately designed, opt-in wind-force adapter.
- GPUParticles3D, ParticleProcessMaterial turbulence/attractor interaction and vector-field attractors can support coherent wind-driven rain, leaves and dust presentation.
- Height-field particle collision is available for outdoor terrain but adds update/resolution cost; most rain should not need world collision.
- Depth and height fog, sky materials and restrained particle mist form the mobile baseline. Volumetric fog remains optional because it is Forward+-only, not a Mobile/Compatibility baseline feature.
- Wind should be sampled from a deterministic vector field with bounded gusts and smooth zone blending. Use relative air velocity and a capped drag approximation for explicitly opted-in props.
- The player is excluded from wind forces by default. Weather must not unexpectedly alter movement/traversal controls or obscure route and interaction readability.
- Weather state, time-of-day and presentation effects should be separate. Weather profiles and transitions should be deterministic and testable.

No weather system, storm event, climate profile, environmental penalty or production-world weather has been implemented or canon-approved.

## 3. Next engineering sequence

1. Return to outstanding traversal work: add a measured traversal course and explicit traversal-state design before wall-climb/mantle implementation.
2. Add touch/look and traversal transition regression tests before expanding mechanics.
3. Build a pure deterministic wind-field math module and tests as a separate workstream.
4. Add weather profile blending and a separate validation lab.
5. Add visual weather effects only after the math/state tests pass; profile on actual Android hardware before production integration.

## 4. Open gates

- Renderer choice remains undecided pending Android device comparison.
- Physical Android QA remains blocked until the target device and export route are validated.
- Human movement feel review remains open.
- Ridgeview integration remains gated on traversal, camera, touch and interaction acceptance.
- No merge to main, release, paid commitment or major canon change was performed.
