# BTV-MOD-001 — Logos Rhema Temple 3D Interior Blockout

**Status:** v0.1 SAVED / INSPECTED; v0.2 REVISION QUEUED  
**Target:** Godot 4.x environment prototype (future import; not yet imported)  
**Design authority:** Proposed BTV-ENV-001 concept only; controlling canon and slice remain authoritative.

---

## 1. Purpose

Create a modular, meter-scaled 3D blockout of the fictional Logos Rhema Temple interior to test room proportions, sightlines, seating, central aisle, stage, and future NPC navigation. This is a greybox-quality environment model, not a final art asset.

## 2. Design basis

- Room concept: 18 m wide × 12 m deep × approximately 6 m high (all measurements are PROPOSED for blockout testing).
- Central aisle and paired seating rows.
- Modest raised front platform and simple lectern.
- Centered, restrained wooden cross.
- Side windows, ceiling beams, pendant fixtures, and rear entry doors.
- No characters, logos, Covenant symbols, HUD, supernatural effects, or external church branding.

## 3. Source-of-truth boundaries

- Logos Rhema Temple is a fictional church and living community.
- It is not a Covenant facility or a gameplay reward/buff station.
- HCI is inspiration only; this model does not reproduce real HCI branding or claim institutional representation.
- Exact architecture, dimensions, materials, furniture, and layout are not canon-locked.
- The model is derived from a proposed visual study and must be reviewed against the current Godot greybox and slice requirements.

## 4. Technical plan

- Blender 4.5.3 / Python 3.11.15 through Blendstra CPU modeling.
- Metric units, meters.
- Separate named semantic parts for shell, windows, pews, platform, lectern, cross, doors, lights, and planters.
- Editable source retained by the private modeling workspace.
- Future export target: GLB for Godot import.
- Future checks: object hierarchy, scale, material slots, navigation clearance, mobile draw-call/triangle budget, and scene loading.

## 5. Cost and privacy

- Workspace capability inspection reported CPU modeling available, with a zero-USD rate and a zero maximum job charge.
- The job request explicitly set `maxChargeMicros: 0`.
- No GPU job was requested.
- The model project is private; it has not been published or shared.
- No model has been accepted or deployed.

## 6. Current job state

- Model project title: `BTV — Logos Rhema Temple Interior Blockout v0.1`.
- v0.1 completed and saved as a private Blendstra model version.
- Geometry inspection confirms 141 mesh objects and 14,684 triangles; no animation.
- The first poster/inspection views were too obstructed by the closed shell to assess the interior reliably.
- v0.2 revision has been submitted to remove the rear wall/door leaves for inspection, add an interior camera and soft area lighting, and create a clearer poster plus reference/top inspection views.
- v0.2 state at this update: QUEUED.
- The project identifier and private workspace URL are deliberately not embedded in this repository document.

## 7. Acceptance criteria

1. Correct room scale and readable central aisle.
2. Clear separation between seating, platform, and access paths.
3. Modular, named objects with reasonable topology.
4. No accidental overlap or floating furniture.
5. No unapproved character, Covenant, or supernatural design.
6. Exportable GLB with scale verified.
7. Later Godot import and Android test pass.

**Current result:** NOT VERIFIED. Do not use in the runtime game until all acceptance gates pass.

**End — BTV-MOD-001.**
