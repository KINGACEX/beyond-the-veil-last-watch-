# BTV Neutral Graphics Benchmark — Repeatable Run Procedure v1.0

**Date:** 11 November 2026  
**Engine baseline:** Godot 4.7.2  
**Scene:** `scenes/neutral_graphics_benchmark.tscn`  
**Scope:** Canon-neutral structural comparison only. This is not a production-level or device-certification benchmark.

## 1. Before each comparison set

1. Launch the same project build and benchmark scene.
2. Record the project commit, scene revision, asset-set revision, Godot version, OS, device model, SoC/GPU, RAM, Android version, display resolution and refresh rate where known.
3. Use the same device, power mode, display orientation, background-app state, scene revision and camera route for all runs in a comparison set.
4. Allow the scene to finish loading before starting the acceptance run. Do not interact with the camera during a run.
5. Do not substitute an emulator or headless CI for physical-device measurements.

Optional metadata environment variables read by the benchmark:
- `BTV_BUILD_COMMIT` (falls back to `GITHUB_SHA`)
- `BTV_SCENE_REVISION`
- `BTV_ASSET_SET_REVISION`
- `BTV_DEVICE_MODEL`
- `BTV_SOC`
- `BTV_GPU`
- `BTV_DEVICE_RAM_MB`

Missing values are written as `NOT_CAPTURED`; they must not be guessed.

## 2. Supported comparison settings

### Benchmark-scene profiles

Press `Q` to cycle these supported scene-only bundles:

| Profile | Shadows | Fog | Foliage proxies | NPC proxies |
|---|---|---|---|---|
| `reference` | On | Off | On | On |
| `reduced` | Off | Off | On | Off |
| `minimal` | Off | Off | Off | Off |

These are benchmark-scene comparison bundles, not BTV Low/Balanced/High/PC presets and not renderer-wide quality settings. Keys `1`–`4` toggle one feature at a time and mark the active profile as `custom`.

### 3D render scale

Press `9` to cycle the supported viewport 3D buffer scales: `1.00`, `0.85`, `0.70`. Press `0` to restore `1.00`. Unsupported values are rejected. The scale applies to the benchmark viewport; it does not select a renderer or alter the display resolution.

For an isolated render-scale comparison, hold the scene profile constant. For a profile comparison, hold render scale constant. Change only one comparison dimension at a time.

## 3. Acceptance run timing

Press `7` to start the fixed acceptance run.

1. Camera snaps to the first authored route point.
2. **Warm-up:** 5 seconds at viewpoint 0. Warm-up frame intervals are excluded from the recorded sample window.
3. **Dwell:** 3 seconds at each of six fixed viewpoints.
4. **Transit:** 1 second between adjacent viewpoints. Transit intervals are excluded from the sample window.
5. **Total nominal duration:** 28 seconds (5-second warm-up + 18 seconds of dwell + 5 seconds of transit).

Do not move the camera, change settings, resize the window or background the app during the run. The route and dwell points are deterministic; operating-system scheduling and actual frame intervals are not.

The separate route-preview controls are `5` (start) and `6` (stop). Route preview is not the acceptance run and does not create a benchmark sample set.

## 4. Export and repeatability

1. Wait until the HUD reports phase `complete`.
2. Press `8` to export the completed run.
3. The JSON file is written under `user://benchmark_runs/` with a timestamped name. This is the app's user-data directory; the benchmark does not upload it.
4. Retain the original JSON file and associate it with any external screenshots or profiler captures.
5. Run each configuration at least three times without changing build, scene, asset set or device conditions. Keep every run; do not discard slow runs or average away severe hitches.
6. Compare frame-time distributions and notes across equivalent configurations. Record any external profiler data as a separate source with tool/version and capture timestamp.

The JSON includes schema version, run sequence/time/duration, comparison key, build and scene identifiers when supplied, engine/platform/device context, supported and active scene settings, fixed route points, warm-up/transit/dwell timing, frame-delta summary and telemetry availability boundaries.

## 5. Measurement semantics — strict

The benchmark samples `Node._process(delta)` in milliseconds during dwell windows. This is the main-loop frame interval observed by the callback. It is **not**:
- CPU execution duration, CPU utilization or a CPU profiler trace;
- GPU frame time, GPU utilization or GPU timestamp data;
- process memory, device RAM usage or GPU memory;
- thermal state, throttling, power draw or battery telemetry.

The exported record explicitly marks those unavailable measurements as `NOT_CAPTURED`. Never infer them from frame delta, screenshots, headless CI or emulator output. A separate device profiler or OS sensor capture is required.

## 6. Acceptance boundaries

- Headless Godot CI proves parsing and deterministic software tests only.
- Android export/emulator smoke tests do not certify a physical Android device.
- No universal FPS threshold is set until a minimum target device is selected.
- Renderer selection and production quality defaults remain undecided until equivalent physical-device evidence is available.
- This scene remains greybox test content and must not be represented as final BTV visual quality.
