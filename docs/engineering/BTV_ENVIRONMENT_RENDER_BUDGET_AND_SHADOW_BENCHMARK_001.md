# BTV Environment Render Budgets and Shadow Benchmark 001

**Date:** 10 November 2026  
**Status:** RESEARCH-ALIGNED ENGINEERING SPECIFICATION; DEVICE VALUES NOT YET MEASURED  
**Engine:** Godot 4.7.2 CI baseline  
**Scope:** Mobile-first environment rendering, shadow quality, wildlife/vegetation update budgets and measurable quality scaling.

## 1. Purpose and constraints

This document operationalizes the existing Visual Art Bible, Technical Graphics Specification, Android Graphics and Device Benchmark Research, and Neutral Graphics Benchmark Scene Acceptance Contract. It does not replace those documents.

The goal is to develop a repeatable way to control visual resource use without choosing arbitrary device limits. No renderer, shadow distance, shadow-map resolution, polygon budget, memory cap or minimum Android device is selected here.

No production art, game assets, copyrighted game assets, paid plugins or runtime dependencies are introduced by this specification.

## 2. Reference-game study translated into BTV requirements

- **Red Dead Redemption 2:** study ecological plausibility, animal presence, wet/dry material response, vegetation ambience and world continuity.
- **Assassin's Creed Shadows:** study seasonal/environmental presentation, foliage response, animal animation and wildlife material rendering.
- **Grand Theft Auto VI:** study regional environmental density, local weather variation and persistent environmental presentation.
- **The Witcher 3:** study regional identity, atmosphere and environmental storytelling.

These references inform high-level craft analysis only. BTV must not copy protected models, textures, animation, code, music, UI, characters or locations. Their reported feature counts and desktop/console performance are not BTV budgets.

## 3. Godot 4.7 rendering facts relevant to shadows

The version-matched Godot 4.7 internal rendering architecture documentation describes:

- **Forward+:** clustered lighting intended primarily for desktop-class rendering; its clustered approach is substantially less efficient on mobile GPUs.
- **Mobile:** a forward renderer designed around mobile GPU constraints. It supports PCF-filtered shadow maps and PCSS for OmniLight3D/SpotLight3D, but not PCSS for DirectionalLight3D. Contact shadows are not part of the Mobile renderer feature set.
- **Compatibility:** a lower-feature rendering path. Shadow-casting lights use a multi-pass approach; performance does not scale well with many shadowed lights. It does not support PCSS.
- In all renderers, shadow-casting lights are more expensive than lights without shadows. Baked lighting can reduce repeated real-time lighting cost where static geometry permits it.

Version-matched source:
https://docs.godotengine.org/en/4.7/engine_details/architecture/internal_rendering_architecture.html

Additional official references:
- https://docs.godotengine.org/en/4.7/tutorials/performance/optimizing_3d_performance.html
- https://docs.godotengine.org/en/4.7/tutorials/3d/3d_rendering_limitations.html

## 4. Shadow benchmark cases

The neutral benchmark scene should compare these cases at identical camera positions and exposure:

1. Directional sun shadow on a static receiver.
2. Directional shadow on a moving neutral mannequin.
3. Foliage shadow casting enabled versus disabled.
4. A small number of local shadow lights versus non-shadowed local lights.
5. Shadow distance and resolution variants.
6. Baked static lighting plus one selected dynamic directional light.
7. Shadow LOD transitions at near/mid/far camera distances.
8. Shadow acne, peter-panning, cascade transition and foliage silhouette artefacts.
9. Indoor/outdoor transitions and moving occluders.
10. Renderer feature fallback comparison where supported.

Measure frame-time and visual defects. Do not select settings based on a single screenshot.

## 5. Proposed quality-tier structure

The project already defines Low, Balanced, High and PC intentions. For this milestone, the implementation rule is data-driven:

- Each tier requests named resource quantities.
- A device benchmark supplies measured caps for the same named quantities.
- The resolved budget is the lower of the request and the measured cap.
- Missing, negative or non-numeric measurements invalidate the profile rather than silently guessing.
- No fixed numeric defaults are declared until a real target device and representative scene are benchmarked.

The new `BTVEnvironmentQualityBudget` helper provides this pure validation/clamping boundary. It does not detect hardware, select a renderer or modify Godot project settings.

## 6. Wildlife update scheduling

Wildlife LOD is independent of render LOD:

- Near agents may receive full behaviour updates.
- Mid agents may receive reduced update frequency.
- Far agents may be represented by lower-cost ambient state.
- Off-screen populations may use coarse population/occupancy state.

The new scheduler assigns distance tiers and chooses a bounded number of agents per tier. A rotating start index prevents the same agents from being permanently skipped when a tier contains more agents than its update budget.

The scheduler returns indices only. It does not instantiate, navigate, animate, spawn or despawn animals. The caller owns time-step cadence, deterministic simulation state and all scene integration.

## 7. Local weather-zone blending

The weather profile helper now supports weighted blending of a base profile with multiple caller-supplied local zones.

The caller must calculate spatial weights from zone overlap/falloff. The helper:
- validates compatible normalized profile schemas;
- ignores zero/negative zone weights;
- blends all active channels deterministically;
- does not own Area3D lifecycle, spatial queries, timers, particles, audio or visual weather effects.

Weather transitions remain separate from time-of-day and from deterministic optical puzzle logic.

## 8. Test and acceptance plan

Automated tests now cover:
- per-tier wildlife update limits;
- rotating fairness across over-budget populations;
- invalid distance radii and malformed budgets;
- local weather zone composition and schema rejection;
- data-driven quality budget clamping and invalid measurement rejection.

Remaining acceptance work:
- create a wildlife validation scene with neutral placeholder geometry and debug labels;
- create a weather presentation lab with local zone overlap and transition controls;
- extend the existing optics lab with controlled material/light/shadow comparison stations;
- implement the full neutral graphics benchmark scene against the existing acceptance contract;
- record visual captures and frame-time/thermal evidence on the named physical Android device.

## 9. Current decision

**CONFIRMED:** the pure scheduling, weather blending and resource-budget helper code can be tested in Godot 4.7.2 CI.

**UNKNOWN:** actual shadow performance, renderer choice, device-specific resource caps, visual quality, thermal stability and Android export behaviour.

**BLOCKED:** device-derived budgets and renderer selection until the target Android hardware and physical test path are available.

No production-region integration or canon change is authorized by this engineering specification.
