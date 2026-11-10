# BTV Wind, Weather and Atmospheric Systems Research 001

**Date:** 2026-11-10  
**Engine target:** Godot 4.7.2  
**Primary platform:** Android-first; PC scalability later  
**Status:** Research and proposed architecture only. No weather mechanic, climate profile, gameplay penalty or final visual target is locked by this document.

## 1. Executive recommendation

Build weather as a data-driven environmental system with one authoritative state model and several inexpensive presentation/interaction adapters. Separate the simulated weather state from the visual effects that communicate it.

For the Android-first baseline:
- Use a small set of readable weather profiles and blend between them over time.
- Represent wind as a sampled vector field with a stable mean direction, bounded gust variation and optional low-frequency local variation.
- Use shaders for distant foliage/grass sway, a small number of GPU particle systems for nearby leaves/dust/rain, and ordinary depth/height fog for atmospheric distance.
- Do not rely on Godot's built-in Area3D wind to push ordinary rigid bodies or the player. Godot documents that this wind currently affects SoftBody3D only.
- Apply wind forces only to explicitly opted-in lightweight props or soft-body test objects. The player controller is excluded by default.
- Keep weather transitions deterministic and testable. A fixed seed and explicit profile inputs should reproduce the same sequence in automated tests.
- Keep rain, fog and cloud rendering optional. Weather must not obscure navigation, interaction prompts, captions or accessibility-critical visual information.

## 2. Atmospheric concepts translated into game systems

| Weather concept | Physical basis | Visual/audio cues | Candidate BTV use | Priority |
|---|---|---|---|---|
| Mean wind | Bulk horizontal air movement | Tree lean, grass direction, drifting particles, ambient wind audio | Establishes environmental mood and regional identity | High |
| Gusts | Short-lived increases/decreases around mean wind | Brief stronger foliage bend, particle bursts, cloth response | Adds variation without a constant force | High |
| Turbulence | Irregular air motion from convection, obstacles and wind shear | Local swirling leaves/dust, irregular foliage movement | Localized environmental variation near terrain/buildings | Medium |
| Wind shear | Wind velocity changes with position/height | Different motion in canopy, ground plants and drifting particles | Layered atmosphere in valleys, cliffs and open spaces | Medium |
| Rain | Condensed cloud droplets falling under gravity | Rain streaks, surface response, splashes, roof/leaf audio | Mood, wet materials and environmental ambience | High |
| Cloud cover | Suspended droplets/ice crystals; cloud formation linked to cooling/saturation and condensation nuclei | Sky coverage, softer direct sunlight, changing ambient colour | Time/weather transitions and regional mood | High |
| Fog/mist | Near-ground cloud or suspended droplets reducing visibility | Depth fade, low-lying haze, dampened distant detail | Spatial atmosphere and controlled sightline composition | High |
| Storm | Combined high wind, precipitation, cloud and electrical/atmospheric cues | Layered audio, stronger rain, darker sky, brief light changes | Rare set-piece weather state; no mandatory player penalty | Medium |
| Dry haze/dust | Suspended particles and atmospheric scattering | Warm distance fade, drifting dust | Dry-season and interior/exterior transitions | Medium |

Cloud formation requires water vapour, condensation nuclei and air reaching saturation; rising air commonly cools as it expands. Fog is cloud at ground level. Rain develops as cloud droplets grow and become heavy enough to fall. These are useful visual/state relationships, not a requirement to simulate atmospheric thermodynamics in real time.

## 3. Wind model and game-facing physics

### 3.1 Wind field representation

Represent a wind sample as:
- mean_direction: normalized world-space direction;
- mean_speed: scalar baseline;
- gust_offset: bounded, time-varying speed/direction perturbation;
- local_variation: low-frequency noise or a small authored vector field;
- influence: blend weight for local wind zones.

The final sampled vector should be continuous across frames and zones. Avoid per-frame unseeded random values: they create visual jitter and make tests non-reproducible. Use a seeded low-frequency function or precomputed gust curve.

A simple first implementation can use:
wind_velocity = direction * (mean_speed + gust_offset)

Do not attempt full computational fluid dynamics. Buildings, trees and terrain can use authored local wind zones or a low-resolution vector field to approximate shelter, channeling and eddies.

### 3.2 Drag relationship

For a body in airflow, use relative air velocity rather than absolute world velocity:

v_relative = wind_velocity - body_velocity

A useful physical reference is:
F_drag = 0.5 * rho * Cd * A * |v_relative|^2

where:
- rho is air density;
- Cd is a drag coefficient representing shape/flow effects;
- A is reference area facing the flow;
- |v_relative| is relative airflow speed.

The force direction follows the relative airflow. For a real-time game, treat this equation as a scaling guide, then expose a project-specific multiplier and a maximum acceleration/force. Do not pretend the game-unit scale is SI-accurate unless mass, length and time scales are calibrated.

Wind response should be per-object:
- foliage: shader bend, not rigid-body simulation;
- leaves/dust: particle motion and attractors;
- lightweight props: optional capped force;
- soft cloth: consider SoftBody3D/Area3D only after device profiling;
- player: no default wind force. If a later design calls for a small environmental influence, it must be isolated, bounded, accessibility-aware and tested against movement/traversal acceptance.

### 3.3 Gusts and turbulence

A gust is a short fluctuation around the prevailing wind, not a completely random new direction every frame. The National Weather Service glossary defines a wind gust using rapid fluctuations with a peak-to-lull variation threshold; the game should not copy an operational meteorological threshold as a gameplay rule. Use it as a reminder to distinguish sustained wind from short peaks.

Turbulence can be approximated with:
- low-frequency noise;
- spatially coherent vector fields;
- stronger local variation near obstacles or terrain;
- bounded amplitude and a smooth fade at zone boundaries.

Do not use high-frequency noise on the player camera or core controls. Environmental motion should remain readable rather than visually noisy.

## 4. Godot 4.7.2 implementation implications

### 4.1 Built-in wind is not a universal force system

Godot 4.7 Area3D exposes wind magnitude, source, direction and attenuation. The official class documentation explicitly states that this wind force currently applies to SoftBody3D; ordinary physics bodies are not affected. Therefore, a BTV wind service is required for rigid props or other opted-in objects.

### 4.2 Particles and vector fields

Godot supports GPUParticles3D and CPUParticles3D. ParticleProcessMaterial exposes initial velocity, direction/spread, damping, turbulence and particle-attractor interaction. GPUParticlesAttractorVectorField3D can use a NoiseTexture3D to create a spatially varying field; Godot specifically notes its usefulness for sandstorm-like effects.

Recommended use:
- GPU particles for distant/nearby rain, leaves, dust and light mist when supported by the chosen renderer;
- low particle counts and short lifetimes for mobile baseline;
- fixed seeds for repeatable visual tests;
- particle attractors or a shared vector field for coherent drift;
- CPU particles or shader-only fallbacks where GPU particle features are unavailable or too expensive.

Particle collision is optional. Godot's 3D particle collision system has box, sphere, SDF and height-field options. Height-field collision is useful for broad outdoor terrain but has resolution/update costs. Use it only where visible interaction materially improves the shot; most rain should not require every drop to collide with world geometry.

### 4.3 Sky, fog and renderer constraints

Godot 4.7 supports panorama, procedural and physically based sky materials, plus exponential depth fog and height fog. These are suitable foundations for the baseline.

Volumetric fog is not supported by Mobile or Compatibility renderers; it is a Forward+ feature. Do not make the Android baseline depend on volumetric fog. Use depth/height fog, sky tint, particle mist and authored local haze as fallbacks.

Mobile GPUs are sensitive to fill-rate/overdraw and transparency. Rain sheets, overlapping mist layers, large transparent cloud cards and dense particles can be expensive. Keep transparent effects spatially limited and reduce particle counts/draw distance at lower quality tiers.

### 4.4 Wind-driven vegetation

Prefer vertex-shader sway for grass and foliage:
- one shared wind direction/speed signal;
- per-instance phase/strength variation;
- bend weighted by vertex height or authored vertex colour;
- low-frequency motion for trunks/large branches;
- higher-frequency, low-amplitude motion for leaves;
- distance-based reduction or impostors for distant vegetation.

Avoid running a separate physics body for every leaf or branch. Use a few representative interactive props where the player can clearly see the result.

## 5. Weather state architecture

Proposed components (names are candidates, not committed API):
- BTVWeatherController: authoritative weather profile, transition timer, seed and time-of-day inputs.
- BTVWeatherProfile: resource containing cloud cover, precipitation intensity/type, fog density, wind direction/speed, gust envelope, ambient tint and audio mix.
- BTVWindField: samples the global and local wind vector at a world position.
- BTVWindReactive: opt-in component for a small set of props.
- BTVWeatherPresentation: applies sky, fog, particle and audio changes without owning gameplay truth.
- BTVWeatherZone: local profile override/blend region for biome or interior transitions.

Keep weather state separate from day/night. A clear night and a rainy afternoon should be combinations of independent time-of-day and weather inputs. Local zones should blend into the global state rather than abruptly replace it.

### Candidate state variables
- cloud cover: 0..1;
- precipitation intensity: 0..1;
- fog density: 0..1;
- wind speed: non-negative project units per second;
- wind direction: normalized Vector3;
- gust strength: 0..1;
- wetness: 0..1, visual/material state only in the first version;
- transition progress: 0..1.

These values are authoring controls, not calibrated meteorological measurements.

## 6. BTV design opportunities — proposals only

- Exploration: weather changes the mood and silhouette of locations without blocking core route readability.
- Environmental observation: wind direction can be inferred from flags, grass, tree canopies, drifting leaves and water surface cues.
- Optical systems: rain, mist and wet surfaces can change visual presentation, but must not silently alter deterministic optical puzzle solutions.
- Regional identity: coastal, forest, highland, urban and dry/open regions can use different weather profiles.
- Soundscape: wind through gaps, rain on different materials, distant thunder and indoor rain muffling can strengthen spatial presence.
- Traversal readability: wind-driven foliage and rain should not hide ledges, climb tags, interaction targets or camera-critical geometry.
- Accessibility: offer reduced particles, reduced camera-affecting effects, clear contrast and stable visibility. No mandatory loss of control due to weather in the baseline.

No weather system, storm event, environmental penalty or region-specific climate is approved canon by this research.

## 7. Proposed quality tiers

| System | Mobile baseline | Enhanced mobile / later PC |
|---|---|---|
| Sky | Single procedural or authored sky; slow transitions | Higher-quality sky and richer cloud layers |
| Wind | Shared vector + shader foliage | Local vector fields and more varied vegetation response |
| Rain | One bounded particle system and simple surface response | Multiple layers, localized splashes and selected collision |
| Fog | Depth/height fog and restrained local mist | Additional localized effects; volumetric only on supported renderer |
| Clouds | Sky material/texture with slow coverage changes | More detailed cloud animation or layered meshes |
| Audio | Small set of blended loops/one-shots | More localized spatial audio layers |
| Simulation | A few opted-in props | More reactive props, still capped and profiled |

## 8. Validation plan

Before production integration, create a separate Weather Validation Lab and test:
1. Wind vector normalization and zone blending.
2. Gust envelope bounds, smoothness and deterministic seeded output.
3. Drag scaling with relative wind speed (doubling speed should produce approximately four times the drag under the simplified quadratic model).
4. Object response caps and no force on non-opted-in bodies.
5. Wind direction changes without abrupt visual snaps.
6. Rain particle count, lifetime, camera-follow bounds and overdraw.
7. Particle collision cost compared with non-collision presentation.
8. Depth/height fog readability in indoor, outdoor and long-distance views.
9. Weather transition continuity with independent day/night state.
10. Accessibility/reduced-effects mode and HUD/interaction visibility.
11. Renderer fallback and export validation on the actual Android target.
12. Automated tests for deterministic state transitions and force calculations.

Acceptance gates:
- deterministic tests pass;
- weather transitions do not change core player controls unexpectedly;
- interaction prompts and traversal geometry remain readable;
- no weather-dependent puzzle correctness is encoded only in shaders;
- mobile frame-time and thermal behaviour are measured on an actual device;
- no visual-quality or Android-ready claim is made from headless CI alone.

## 9. Recommended implementation order

1. Build a pure BTVWindField math module and unit tests (no particles or renderer dependency).
2. Add deterministic weather profile/state blending and tests.
3. Create the separate Weather Validation Lab with visible wind direction, gust response and simple foliage.
4. Add one mobile-baseline rain particle system and ordinary fog.
5. Add optional local weather zones and audio transitions.
6. Profile renderer/export on a real Android device before choosing advanced effects.
7. Only then consider limited weather integration into a production region.

## 10. Research sources

**Godot 4.7**
- Area3D wind properties and SoftBody3D-only limitation: https://docs.godotengine.org/en/4.7/classes/class_area3d.html
- PhysicsServer3D wind parameters: https://docs.godotengine.org/en/4.7/classes/class_physicsserver3d.html
- ParticleProcessMaterial: https://docs.godotengine.org/en/4.7/classes/class_particleprocessmaterial.html
- 3D particles overview: https://docs.godotengine.org/en/4.7/tutorials/3d/particles/index.html
- 3D particle collisions: https://docs.godotengine.org/en/4.7/tutorials/3d/particles/collision.html
- Vector-field particle attractor: https://docs.godotengine.org/en/4.7/classes/class_gpuparticlesattractorvectorfield3d.html
- Feature list (sky, fog, particles and renderer capabilities): https://docs.godotengine.org/en/4.7/about/list_of_features.html
- Internal rendering architecture and mobile constraints: https://docs.godotengine.org/en/4.7/engine_details/architecture/internal_rendering_architecture.html

**Atmospheric science and physics**
- NASA drag equation: https://www1.grc.nasa.gov/beginners-guide-to-aeronautics/drag-equation/
- OpenStax drag forces: https://openstax.org/books/college-physics/pages/5-2-drag-forces
- NOAA wind gust and wind shear glossary: https://forecast.weather.gov/glossary.php?word=s
- NOAA cloud formation: https://www.noaa.gov/jetstream/clouds/how-clouds-form
- NOAA fog and clouds: https://www.nesdis.noaa.gov/about/k-12-education/atmosphere/whats-the-difference-between-fog-and-clouds
- NOAA rain formation: https://www.nesdis.noaa.gov/about/k-12-education/atmosphere/what-makes-it-rain
- Met Office synoptic charts and pressure gradients: https://weather.metoffice.gov.uk/learn-about/weather/how-weather-works/synoptic-weather-chart
- NWS Beaufort scale and visible wind effects: https://www.weather.gov/tbw/beaufort

**Research conclusion:** use a coherent, deterministic wind-field and weather-state architecture with lightweight visual effects. The engine's built-in wind is not a universal rigid-body solution, and Forward+-only volumetric effects must remain optional. This is a technical recommendation, not approval to change canon or the production world's climate.


## 8. Deterministic weather-profile blending implementation

Added `scripts/weather_profile_blend.gd` as a pure deterministic helper for blending normalized weather-intensity channels. The current contract requires each profile to expose the same numeric keys and clamps each channel to 0..1. Non-negative weights are normalized; empty inputs, mismatched schemas and zero total weight return an empty result rather than silently inventing defaults.

The initial unit test is `tests/weather_profile_blend_test.gd`; it covers weighted interpolation, deterministic repeatability, negative/zero weights, schema mismatch and channel bounds. **Godot 4.7.2 CI run #42782571229 passed** the new weather blend suite and all preceding project tests.

This helper does not yet implement time-based transitions, local weather zones, precipitation particles, sky/fog presentation or climate simulation. The player remains excluded from wind forces by default. No regional climate or gameplay penalty is approved by this implementation.
