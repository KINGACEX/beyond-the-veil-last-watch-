# BTV Development Checkpoint 22 — Wildlife Visual Prototype Lab

**Date:** 10 November 2026  
**Branch:** `btv/controls-hardening-prototype-layout-plan-001`  
**Starting HEAD:** `2279ff6e71406847cf724349aca3139526d0726d`  
**Validation before final presentation-text correction:** [Godot 4.7.2 CI run #42803291496](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42803291496) — **PASS**, 43 successful steps on commit `90295d392ef714d2bf2c5be98892d896a6b08dd6`.

## Milestone — generic wildlife visual prototype — IMPLEMENTED

Added an isolated scene, `scenes/wildlife_visual_prototype_lab.tscn`, with its controller `scripts/wildlife_visual_prototype_lab.gd`.

The scene presents three generic greybox body-form studies:

- Mammal-like quadruped with rough fur-like material parameters.
- Bird-like form with feather-like material parameters and simple paired-wing motion.
- Reptile-like form with smoother scale-like material parameters.

The forms use procedural primitive meshes and broad material properties only. They are not species-specific reconstructions, production assets, textured fur/feathers/scales, rigged animation, or finished locomotion. No species profile is assigned and no real-world animal is asserted by the geometry.

## Verification added

- Added `tests/wildlife_visual_prototype_lab_test.gd`.
- CI workflow now runs this test.
- Structural checks cover scene camera/HUD, all three generic forms, wing placeholders, prototype count, and explicit non-production/no-species-assignment boundaries.

## Existing wildlife architecture preserved

- No changes to the wildlife ecology simulator or species-profile schema.
- Modern, historical and deep-time evidence requirements remain separate.
- No production-region species placement or unsupported fossil co-occurrence claim.
- No changes to Ember, Asher, Covenant canon or game lore.
- No hunting, attacks, capture, injury, combat or weapon systems.

## Status and limitations

**COMPLETED:** First generic visual-form prototype and CI integration.  
**NOT COMPLETED:** Production animal meshes, species-authentic anatomy, texture authoring, skeletal rigs, locomotion, navigation, habitat-specific authored scenes, distance-based render LOD, device profiling and visual QA.  
**BLOCKED:** Android visual/performance acceptance until an export and physical-device test are performed.

## Next sequence

1. Extend the benchmark with a documented warm-up/capture procedure, dwell at each fixed viewpoint, and exportable run metadata.
2. Add repeatable visual capture/defect review instructions.
3. Refine wildlife prototypes with verified reference anatomy/material studies before selecting species.
4. Integrate wildlife render LOD separately from the existing simulation LOD scheduler.
5. Validate on Android before choosing renderer or quality defaults.

No merge, release, paid asset, external dependency, canon change or production-region integration was performed.
