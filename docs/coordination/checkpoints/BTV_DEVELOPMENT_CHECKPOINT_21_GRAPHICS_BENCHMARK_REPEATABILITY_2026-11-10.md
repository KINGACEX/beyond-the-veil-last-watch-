# BTV Development Checkpoint 21 — Graphics Benchmark Repeatability and Metrics

**Date:** 10 November 2026  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Code commit tested:** `920364cb18c41da089ad97cb3156b46a172f7236`  
**Validation:** [Godot 4.7.2 CI run #42801417895](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42801417895) — **PASS**.

## Inspection findings

The live branch already contained the wildlife LOD lab, local weather-zone lab, optics/material/shadow station and five-zone neutral graphics greybox. Their current state was inspected before making changes. The graphics benchmark was structurally valid but lacked a repeatable camera traversal and any frame-time sample summary.

## Four milestones

### 1. Repository and benchmark inspection — COMPLETED
- Confirmed branch HEAD and workflow state.
- Inspected graphics benchmark contract, implementation status, scene/controller, wildlife lab, weather lab, quality-budget helper, tests and CI workflow.
- Confirmed that wildlife markers are scheduler proxies, not finished animal models or production wildlife.
- Confirmed weather lab validates normalized profile blending, not final weather rendering.
- Confirmed benchmark is greybox-only and must not be represented as production visual quality.

### 2. Deterministic frame-time summary utility — COMPLETED
- Added `scripts/benchmark_metrics.gd`.
- Computes sample count, mean, median, nearest-rank p95, maximum and threshold exceedance count.
- Rejects empty, negative, non-finite and invalid-threshold inputs.
- Added `tests/benchmark_metrics_test.gd` and CI execution.

### 3. Bounded runtime sampling and repeatable camera route — COMPLETED
- Graphics benchmark records a bounded rolling window of up to 3,600 frame-delta samples.
- Exposes summary and sample-count APIs.
- Added fixed six-viewpoint route playback: key 5 starts, key 6 stops; each segment interpolates for two seconds.
- Extended structural tests to exercise sample APIs, route start, stop and completion.

### 4. Evidence, documentation and CI verification — COMPLETED
- Updated `docs/engineering/BTV_NEUTRAL_GRAPHICS_BENCHMARK_IMPLEMENTATION_STATUS_001.md`.
- Added this checkpoint.
- Latest code commit passed all workflow steps in run #42801417895.

## Measurement limitations

Frame delta is a CPU-side frame interval observation. It is not a GPU timestamp, dedicated CPU profiler, memory measurement, thermal sensor, renderer comparison or device performance certification. Headless CI success verifies parsing and deterministic tests only. Do not report FPS/performance acceptance from this run.

## Remaining work / blockers
1. Add fixed dwell points, warm-up/cold-run procedure and run metadata export.
2. Add render-scale and supported graphics-quality comparison controls.
3. Collect visual captures at fixed viewpoints and maintain a defect log.
4. Obtain a physical Android device and perform export/install, input, sustained frame-time, memory and thermal testing.
5. Select the renderer only after measured target-device evidence.
6. Production wildlife models, rigging, animation, navigation, population placement and weather visual integration remain future work.

## Governance
No merge, release, paid service, external dependency, production-region integration, canon change or permission expansion was performed. The benchmark remains isolated and canon-neutral.
