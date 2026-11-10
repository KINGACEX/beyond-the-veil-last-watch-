# BTV — Logos Rhema Chapel Interior Study 001

| Field | Value |
|---|---|
| File | `logos_rhema_chapel_interior_study_001.glb` (original, unmodified) — **NOT YET COMMITTED: binary must be added from a local clone (see tools/transfer_chapel_glb.sh)** |
| SHA-256 | `fd1014f2ed1c6d65d74cc632af113ebc811dff6f699c47684cf0fa03493b67be` |
| Size | 5,748,472 bytes (glTF 2.0 binary) |
| Source | Blendstra-generated study supplied by the creator; exporter "Khronos glTF Blender I/O v4.5.48" |
| Licence / provenance | **UNVERIFIED** — record Blendstra output terms before any release build |
| Status | PROPOSED visual study. Not canon. Not yet opened in Godot. |

## Contents (measured from the GLB JSON, not from the editor)
- 264 nodes, 264 meshes (one mesh per node), 312 primitives, 13 materials
- 84,864 triangles, 170,720 vertices
- No textures, no images, no cameras, no lights, no animations
- Materials are flat PBR colour/roughness/metallic factors (floor, champagne metal, carpet, oak, plaster, glass, upholstery ...)
- All nodes named `LR | ...` (floor, ceiling beams/panels, walls, piers, etc.)
- Approx. bounds (m): X -12.01..12.01, Y -0.14..6.89, Z -16.0..12.0 -> about 24.0 x 7.0 x 28.0 m, Y-up, origin not at centre

## Import (Godot 4.7.2) — defaults intended
Let Godot generate the `.import` file; do not hand-edit it. No external textures, so no dependencies.
Suggested: keep defaults, lightmap UV generation off, no collision generation in the importer.

## Known limitations
1. Interior-only; no light sources. The scene adds placeholder lights.
2. No collision. The scene adds a placeholder floor box.
3. 264 separate meshes is draw-call heavy for Android; merge by material (13) before a mobile pass.
4. Which end is the sanctuary front is not confirmed; spawn marker is a placeholder.
5. Glass is opaque unless alpha is set in-engine; not checked.
6. No congregation, props, Covenant insignia, cross or Scripture elements. Church is not a Covenant space.
7. Godot import, rendering and Android performance are NOT VERIFIED.

## Rollback
Delete the branch, or `git revert` the commits. The scene is additive; no existing scene is edited.
