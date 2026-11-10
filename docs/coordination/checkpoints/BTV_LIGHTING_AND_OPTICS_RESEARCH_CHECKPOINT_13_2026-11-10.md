# BTV Lighting and Optics Research Checkpoint 13

**Date:** 2026-11-10  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Research document commit:** `d55e8bfcc4333cf19d58bfce1a9d2aed1ca5de62`  
**Plan update commit:** `44f1ea564b0c031207cc35e2477e7a8e1791291d`  
**Latest traversal CI:** [Run #42779166032 — PASS](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42779166032)

## Outcome

**COMPLETED:** researched the physical optics needed for convincing lighting and authored optical interactions, then recorded the Godot 4.7.2 rendering constraints and a staged implementation plan.

## Confirmed research findings

- Indirect bounced light is global illumination; practical real-time/baked systems approximate the infinite physical bounce sequence.
- Reflection, refraction, Snell's law, critical angle, total internal reflection and dispersion can be expressed as deterministic ray-path rules.
- Godot 4.7 provides multiple renderers with materially different capabilities and costs.
- Mobile-oriented GI options are LightmapGI and ReflectionProbe; Forward+-only effects cannot be required by Android gameplay.
- StandardMaterial3D provides PBR material controls and screen-space refraction, but transparent refraction has known sorting and off-screen limitations.
- Emission appearance is not the same as guaranteed illumination of nearby geometry.

## Approved technical direction

1. Keep the target renderer undecided until actual Android hardware is profiled.
2. Start with static baked bounce lighting and selective reflection probes for the mobile baseline.
3. Keep optical puzzle logic in a deterministic ray solver, separate from shader visuals.
4. Implement reflection, refraction and total internal reflection first; add dispersion, water/glass visuals and caustic approximations later.
5. Create a controlled Lighting Validation Lab before applying a lighting pass to Ridgeview.
6. Ensure visual effects have lower-quality fallbacks and never become the sole source of puzzle information.

## Next work

- Create the lighting validation scene.
- Add deterministic tests for reflection, refraction and total internal reflection.
- Compare renderer-safe lighting approaches.
- Profile exported builds on the actual Android target.
- Only then apply accepted materials, shadows, atmosphere and water effects to a production environment.

## Boundaries

- This checkpoint adds no new canon, supernatural abilities or combat mechanics.
- No final art direction or renderer is locked.
- No production lighting pass has been applied.
- CI success is not physical Android performance evidence.
- No merge, release, paid service or public announcement is authorised.
