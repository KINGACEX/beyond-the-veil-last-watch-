# BTV Development Checkpoint 27 — Benchmark Repeatability and Wildlife Visual Refinement

**Date:** 11 November 2026  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Starting HEAD inspected:** `3e6cc1670e1ebfe3e2cf109951d947a49e7f9d05`  
**Implementation commit:** `eae2422881f1561f15292ac46594f7c492959055`  
**Godot 4.7.2 validation:** [GitHub Actions run #42999606927](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42999606927) — **PASS**.

## CONFIRMED — repository and baseline

- The requested branch existed and its live HEAD was `3e6cc1670e1ebfe3e2cf109951d947a49e7f9d05`.
- Inspected the branch commit diff, Checkpoint 21, Checkpoint 22, benchmark controller/tests/metrics, wildlife schema/ecology/visual LOD/prototype controller/tests, and the Godot 4.7.2 workflow.
- The baseline HEAD already contained a six-point acceptance-run state machine, a 5-second warm-up, 1-second transit, 3-second dwell, schema-v2 metadata export and render-scale presets. This session completed and hardened those existing structures rather than treating them as absent.
- Baseline Godot validation on the requested HEAD passed in [run #42994499551](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42994499551). The paired Android emulator workflow later failed during screenshot retrieval after the app process was still alive; this was not physical-device evidence.

## COMPLETED — benchmark acceptance

- Added explicit benchmark-scene quality profiles: `reference`, `reduced`, `minimal`. Individual feature toggles switch the recorded profile to `custom`.
- Preserved supported 3D render-scale choices `1.00`, `0.85`, `0.70`; unsupported values remain rejected.
- Advanced metadata to schema v3 with a profile/render-scale comparison key, supported settings, repeatability requirements, warm-up location, dwell-only sampling policy and explicit telemetry definitions.
- Strengthened run-state inspection and deterministic tests for exact camera dwell positions, excluded warm-up/transit intervals, repeat-run reset/sequence, profile changes, unsupported profile rejection and JSON export round-trip.
- Tightened the telemetry contract: observed `Node._process(delta)` frame intervals are not CPU execution time/utilization. GPU timing/utilization, process/GPU memory, device RAM telemetry, thermal state and power remain unavailable.
- Added the operator runbook at `docs/qa/BTV_NEUTRAL_GRAPHICS_BENCHMARK_RUN_PROCEDURE_v1.0.md`.

## COMPLETED — wildlife visual and evidence validation

- Refined the isolated mammal/bird/reptile placeholders with 4 fur tufts, 4 feather-layer elements and 10 scale plates. These are generic geometric surface cues, not species-authentic assets.
- Smoothed the deterministic outbound/return locomotion interpolation and retained idle windows.
- Extended near/mid/far/off visual LOD so fine surface detail is removed at distance independently of the ecology simulation scheduler.
- Strengthened species-profile validation for non-finite reconstruction confidence and non-empty evidence context when fossil evidence is mixed into a non-deep-time record.
- Added safe finite-value guards for habitat fit, viability thresholds, normalized needs/rates, simulation delta and distance-tier inputs.
- Preserved habitat presentation-only metadata, no species assignments, modern/historical/deep-time separation and uncertainty/source requirements.

## Verification

The Godot 4.7.2 validation run for implementation commit `eae2422881f1561f15292ac46594f7c492959055` passed all workflow steps:
- project import/editor parse;
- NLI, mission, interaction and player/touch-control contract suites;
- movement, traversal and optics suites;
- wildlife ecology, scheduler, validation lab, visual prototype, visual LOD and species schema suites;
- graphics benchmark, benchmark metrics, weather and quality-budget suites;
- exploration and vertical-slice acceptance tests;
- both headless scene-launch checks.

The Android workflow is a separate smoke test and does not substitute for a physical-device run. Its latest outcome must be checked independently before reporting it.

## UNKNOWN

- Physical Android frame-time distribution and sustained behaviour.
- CPU execution/utilization, GPU timing/utilization, memory, thermal state, throttling and power.
- Visual quality under real Android display scaling and device-specific GPU behaviour.
- Renderer suitability, target-device minimums and production wildlife fidelity.

## BLOCKED

- Physical-device acceptance until a named Android device and profiler/sensor capture path are available.
- Production wildlife species selection until candidate evidence and regional occurrence sources are reviewed.
- Renderer/production quality selection until equivalent device measurements exist.

## Governance

No merge, release, publication, paid service, destructive action, permission expansion, major canon change, weapon/combat implementation, production-region wildlife placement or Ember modification was performed.
