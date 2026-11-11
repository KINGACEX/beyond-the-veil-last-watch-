# BTV Lighting, Optics and In-Game Visual Effects Research 001

**Date:** 2026-11-10  
**Engine target:** Godot 4.7.2  
**Primary platform:** Android-first; PC scalability later  
**Status:** Research and proposed technical direction. No renderer, visual style, or final quality tier is locked by this document.

## 1. Executive recommendation

Build a physically informed, performance-scalable lighting system rather than attempting to simulate every optical effect at full real-time fidelity.

For the Android-first baseline:
- Begin with a measured Mobile-versus-Compatibility renderer test on the actual target device. Godot's Mobile renderer targets newer Vulkan-capable hardware; Compatibility covers older and broader hardware. Do not lock the renderer until device QA.
- Prefer baked indirect lighting for static environments (LightmapGI where the device/renderer path supports it), reflection probes for selected reflective areas, restrained real-time lights, and carefully authored materials.
- Keep most world materials opaque. Use transparency and refraction only where the player can notice the effect.
- Use layered quality settings: baseline mobile, enhanced mobile, and later PC/high-end options. Never make core navigation or puzzle readability depend on a costly optional effect.

## 2. Optical phenomena and their game representation

| Physical phenomenon | Real-world principle | Useful in-game representation | Production priority |
|---|---|---|---|
| Direct illumination | Light travels from a source to a surface | Sun, moon, lamps, windows, lanterns and localized lights | Essential |
| Diffuse reflection | Rough surfaces scatter reflected light over many directions | Matte stone, plaster, soil, cloth and broad natural shading | Essential |
| Specular reflection | Smooth surfaces reflect light in a view-dependent direction | Highlights on polished stone, metal-like trim, glass and wet surfaces | High |
| Indirect bounce / global illumination | Surfaces reflect light onto other surfaces; bounce energy decreases | Warm/cool colour bleed, softly lit corners, indoor daylight bounce | High |
| Shadowing | Objects block direct illumination | Stable readable shadows, contact grounding, time-of-day direction | High |
| Refraction | Light changes direction when crossing between media with different refractive indices | Water surface distortion, glass, lenses and transparent crystal | High for selected set pieces |
| Total internal reflection | Above the critical angle, light is reflected inside a higher-index medium | Light pipes, optical channels, crystal guides and reflective water/glass boundaries | High for authored puzzles |
| Dispersion | Refractive index varies by wavelength, separating colours | Subtle prism rainbow separation and restrained spectral highlights | Medium |
| Scattering | Light is redirected by particles or irregularities | Dust in sunbeams, mist, haze, cloudy water and atmospheric depth | High |
| Absorption / transmission | Materials absorb some wavelengths or transmit some light | Tinted glass, coloured water, stained glass and light attenuation | Medium |
| Caustics | Concentrated light patterns caused by reflection/refraction | Moving water-light patterns on nearby surfaces; preferably baked or shader-approximated | Medium |
| Diffraction / interference | Wave behaviour around edges or from overlapping waves | Rare stylized lens/portal-like visual accents, not a default world effect | Low |

Physics reference: reflection, refraction, Snell's law, critical angle, total internal reflection and dispersion are described in OpenStax and the Optical Society's optics tutorial. NASA summarizes reflection, transmission, absorption, refraction, diffraction and scattering as common light-wave interactions.

## 3. Core physics rules for authored optical puzzles

### Reflection
- For a smooth mirror-like surface, angle of incidence equals angle of reflection.
- Angles are measured from the surface normal, not from the surface itself.
- Rough surfaces produce diffuse reflection rather than a single crisp reflected ray.

### Refraction
Use Snell's law for any deterministic ray/path puzzle:
\[
n_1\sin(\theta_1)=n_2\sin(\theta_2)
\]
- \(n\) is refractive index; \(\theta\) is measured from the normal.
- Entering a higher-index medium bends the ray toward the normal; entering a lower-index medium bends it away, provided refraction occurs.
- A ray-based puzzle should calculate its path from surface normals and material indices rather than use arbitrary angle offsets.

### Total internal reflection
It can occur only when light travels from a higher-index medium toward a lower-index medium and the incident angle exceeds the critical angle:
\[
\theta_c=\sin^{-1}\left(\frac{n_2}{n_1}\right),\quad n_1>n_2
\]
This is useful for enclosed light guides and prism-like puzzle components. It should not be confused with ordinary mirror reflection.

### Dispersion
Different wavelengths refract by slightly different amounts because refractive index varies with wavelength. For a game, a small number of representative colour bands is sufficient; full spectral rendering is unnecessary for the intended visual result.

## 4. Godot 4.7.2 rendering constraints and implications

### Renderer choice
- Forward+ is the feature-rich desktop renderer; it is not the preferred Android target.
- Mobile is intended for newer Vulkan/RenderingDevice-capable mobile hardware.
- Compatibility targets older/low-end mobile and broad hardware support, with a more limited feature set.
- The final choice must be based on exported builds and actual device profiling, not editor appearance or headless CI.

### Global illumination and bounced light
- Godot describes GI as direct plus indirect lighting; indirect light includes bounced surface light and emissive-surface contribution.
- Mobile GI options are LightmapGI and ReflectionProbe. VoxelGI, SDFGI and SSIL are not available on Mobile/Compatibility in the renderer feature comparison.
- LightmapGI is appropriate for static environment geometry, but is baked and cannot respond dynamically to runtime lighting changes.
- ReflectionProbe is appropriate for selected reflective spaces; frequent Always updates are more expensive than Once.
- For moving/emissive objects on mobile, use carefully budgeted local lights or baked/artist-authored approximations. Do not assume a glowing material automatically illuminates nearby geometry on every renderer.

### Materials and refraction
- StandardMaterial3D provides albedo, metallic, roughness, emission, normal mapping and refraction.
- Roughness controls reflection blur; metallic changes the balance between diffuse and reflected light.
- Emission makes a surface appear luminous but is not, by itself, guaranteed to light surrounding geometry.
- Godot's refraction is screen-space and requires transparency. It can show sorting artifacts, cannot refract itself or other transparent layers correctly, cannot show off-screen objects, and may distort opaque edges in front of it.
- Therefore, use refraction selectively for a few visible glass/water/prism assets; use authored distortion or opaque surface shading where stable mobile performance matters more.

### Fog and scattering
- Standard depth/height fog is available across renderers.
- Volumetric fog is a Forward+ feature and must not be a required Android visual.
- For Android, approximate shafts of light with restrained geometry/particles and authored textures; use low density and avoid full-screen overdraw.

### Lighting cost
- On Mobile, the renderer supports up to 8 OmniLights and 8 SpotLights affecting each mesh resource (plus view-level limits); shadow-casting lights cost more than lights without shadows.
- Prefer one dominant directional light, selective local lights, baked ambient contribution, and distance-based light/shadow reduction.
- Avoid dozens of overlapping shadow-casting lights and stacked transparent layers.

## 5. BTV visual applications

### World and exploration
- Outdoor daylight: one dominant sun direction, readable shadow shapes, atmospheric depth and subtle colour bounce.
- Interior spaces: baked lightmaps, carefully placed windows, warm/cool indirect colour, a few dynamic local lights.
- Water: restrained surface reflection, normal-map distortion, depth tint, selective refraction and optional low-cost caustic patterns.
- Glass and crystal: clear silhouette, edge highlights, roughness variation and localized refraction.
- Dust and mist: localized particles and subtle depth fog; keep visibility and navigation legible.
- Night scenes: strong value hierarchy, readable paths, restrained light pools and silhouettes.

### Optical interaction and puzzle prototypes
- Flat mirror: reflect a ray using the surface normal.
- Curved reflector: approximate with authored geometry or a set of normal-defined segments; avoid costly per-pixel ray tracing.
- Prism: refract entering/exiting rays and display a small spectral fan.
- Water/glass boundary: Snell-law direction change and visible distortion.
- Light guide: total internal reflection within a higher-index channel.
- Coloured filter: absorb selected wavelength bands and tint transmitted light.
- Dust beam: visible shaft only when light intersects a controlled particle volume.
- All puzzles must provide clear feedback when the ray path is blocked, misaligned, refracted or absorbed. No puzzle should rely solely on subtle colour perception; use shape, sound and animation cues as redundant feedback.

## 6. Proposed lighting architecture

Keep systems separate:
1. **WorldLightingProfile** — per-region sun/sky/fog/exposure and quality settings.
2. **SurfaceMaterialLibrary** — reusable opaque, rough, polished, glass, water, emissive and foliage material presets.
3. **OpticalSurface** — authored optical index, surface normal and interaction classification for puzzle simulation.
4. **LightPathSolver** — deterministic ray reflection/refraction/TIR logic for puzzle correctness; independent of the visual shader.
5. **OpticalVisualRenderer** — draws the visible beam, bounce points, colour separation and impact feedback.
6. **QualityScaler** — selects renderer-compatible features, shadow distance, particle density, reflection updates and refraction quality.
7. **LightingValidationLab** — controlled test scene with matte/glossy surfaces, mirror, glass, prism, water plane, emissive panel, shadow blockers and fog.

The LightPathSolver must be the source of truth for optical puzzle logic. Visual beams and shaders are presentation only and must never decide puzzle success.

## 7. Lighting validation plan

Create a dedicated test scene before applying a visual style to Ridgeview.

Test cases:
- Diffuse versus specular response across roughness values.
- Reflection angle against a known surface normal.
- Refraction at two material boundaries using Snell's law.
- Critical-angle threshold and total internal reflection.
- Prism dispersion with a limited RGB/three-band approximation.
- Reflection probe coverage and update modes.
- Baked indirect light from coloured surfaces.
- Emissive surface appearance versus actual surrounding illumination.
- Water distortion/refraction sorting and edge cases.
- Fog/particle overdraw and visibility at target mobile resolution.
- Shadow quality and cost with overlapping local lights.
- Renderer fallback and visual parity between Mobile and Compatibility.

Acceptance requirements:
- Correct optical path math with deterministic unit tests.
- Clear puzzle feedback under low graphics settings and colour-vision differences.
- No reliance on unsupported renderer features.
- Frame-time and memory budgets measured on physical Android hardware.
- Quality fallback never changes puzzle logic.
- No production-region lighting pass until the test lab has a recorded pass.

## 8. Recommended implementation order

1. Create the Lighting Validation Lab with static geometry and a small set of material presets.
2. Implement and unit-test the deterministic ray solver: reflection, refraction and total internal reflection.
3. Add visual beam rendering and impact feedback.
4. Add prism dispersion and coloured filters.
5. Add baked bounce-light and reflection-probe comparisons.
6. Prototype water/glass refraction with fallback visuals.
7. Add restrained atmospheric scattering and optional caustic approximation.
8. Profile Mobile and Compatibility exports on actual target hardware.
9. Apply the accepted lighting profile to Ridgeview.

## 9. Decisions still open

- Actual Android device/GPU and supported renderer.
- Final art direction and colour script.
- Whether optical puzzles are part of the initial playable slice or a later content milestone.
- Which glass/water assets justify real refraction versus a stable visual approximation.
- Target frame-rate and graphics-quality tiers.

No new lore, supernatural power, combat system or canon rule is created by this rendering research. Optical puzzle interactions are environmental gameplay proposals and require separate level-design approval before story integration.

## 10. Sources

- Godot 4.7 — [List of features](https://docs.godotengine.org/en/4.7/about/list_of_features.html)
- Godot 4.7 — [Overview of renderers](https://docs.godotengine.org/en/4.7/tutorials/rendering/renderers.html)
- Godot 4.7 — [Global illumination](https://docs.godotengine.org/en/4.7/tutorials/3d/global_illumination/index.html)
- Godot — [StandardMaterial3D and ORM materials](https://docs.godotengine.org/en/4.7/tutorials/3d/standard_material_3d.html)
- Godot 4.7 — [3D rendering limitations](https://docs.godotengine.org/en/4.7/tutorials/3d/3d_rendering_limitations.html)
- OpenStax — [16.2 Refraction](https://openstax.org/books/physics/pages/16-2-refraction)
- Florida State University / Optical Society — [Snell's Law, Reflection, and Refraction](https://osa.magnet.fsu.edu/tutorials/snell.html)
- NASA — [Wave Behaviors](https://science.nasa.gov/ems/03_behaviors/)
