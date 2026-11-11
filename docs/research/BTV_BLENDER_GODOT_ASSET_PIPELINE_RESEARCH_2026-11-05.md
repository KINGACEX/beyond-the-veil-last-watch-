# BTV BLENDER–GODOT ASSET PIPELINE RESEARCH
**Date:** 5 November 2026  
**Status:** PRACTITIONER CASE STUDY + OFFICIAL DOCUMENTATION CROSS-CHECK  
**Project:** Beyond the Veil: The Last Watch  
**Scope:** Asset authoring, export/publishing, import, modular asset references and scene assembly.

## 1. Primary production case: Blender Studio DOGWALK

**Primary source:** Simon Thommes, Blender Studio Technical Director, “Our Workflow with Blender and Godot” (2025).  
https://studio.blender.org/blog/our-workflow-with-blender-and-godot/

Blender Studio documents a Blender-to-Godot pipeline for a team of eight people. The studio wanted to reuse its film-production strengths and keep Blender central for asset creation, scene assembly, animation libraries and some game-specific definitions, while using Godot for game logic and runtime validation.

This is a first-hand production account, not a universal requirement for Godot projects.

### 1.1 glTF as the publishing boundary
The team selected glTF as the interchange format because Blender and Godot both support it natively, and it can carry meshes, materials and animation data. The studio chose not to rely on direct .blend import for its team workflow. Its stated reason was process control: an explicit export step distinguishes an artist's working file from the asset that has been published to the game project.

This does not mean direct .blend import is inherently wrong. It is a trade-off between rapid local iteration and a controlled, reproducible publishing workflow.

### 1.2 Separate source files from game-ready exports
The studio kept Blender working files and game asset exports in separate directory structures. Artists could retain references, helpers and working data without automatically shipping all of it to the game.

### 1.3 Collection-based export
The pipeline used dedicated Blender collections to define exportable assets. This allowed multiple assets to be exported individually from one Blender file, with settings prepared in advance. It reduced the need to export an entire working scene as one monolithic game asset.

### 1.4 Asset identity and references
The studio aimed to export each asset's own data once. If a set contained a tree, the set could carry a reference and transform for the tree rather than duplicating the tree's mesh/material data. The Godot-side importer reconstructed relationships between exported assets.

The studio built custom tooling on both sides:
- a Blender extension to configure and execute exports and attach metadata;
- a Godot plugin to interpret that metadata and recreate asset/game data during import.

This is more advanced than BTV should build initially. The lesson is separation of asset identity, reusable asset data and scene-instance references—not that BTV should immediately write custom import plugins.

### 1.5 Import-generated data
The studio reports that collaborators needed to open the game in Godot before committing, so the editor could generate import data alongside new exports. This was part of its pipeline. BTV must follow the selected Godot version's current import rules; do not blindly copy another team's cache-commit policy.

### 1.6 Production problems
The studio records several concrete problems:
- A central asset index caused frequent merge conflicts because many people needed to update it.
- Duplicating assets could duplicate IDs, causing material identity collisions.
- Material export did not always preserve a single source of truth; resulting settings could depend on import order.
- The studio identified dynamically building the asset index and separating material export data as possible future improvements.

## 2. Official Godot cross-check

Godot 4.7 stable documentation identifies glTF 2.0 (.gltf and .glb) as the recommended 3D interchange format. Godot can also import .blend by invoking Blender's glTF exporter. Direct .blend import therefore relies on the glTF conversion path and requires Blender to be available to the editor.

Godot documentation also notes that direct .blend import is unavailable in the Android and web editors because those platforms cannot call external programs. This does not prevent using Blender on a desktop development machine to export glTF assets and then importing those exported files into a Godot project.

Sources:
- Available 3D formats: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html
- Importing 3D scenes: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html
- Khronos glTF: https://www.khronos.org/gltf/

## 3. Proposed BTV pipeline — staged, not over-engineered

The following is **PROPOSED**, not approved architecture. It is deliberately simpler than Blender Studio's eight-person custom toolchain.

### Stage A — Source authoring
- Keep Blender source files in a clearly identified source-art location.
- Organise assets into named collections by export responsibility.
- Keep reference images, non-game helpers and working geometry out of game exports unless intentionally required.
- Use consistent object, collection, material, skeleton and animation names.
- Define an asset ID convention before there are many assets.

### Stage B — Explicit publishing
- Export selected assets as glTF 2.0, using .glb for self-contained assets where appropriate.
- Keep a repeatable export preset.
- Avoid changing unrelated asset settings in one export batch.
- Record source file, exported file, asset version and intended Godot use.

### Stage C — Godot import validation
- Import the exported asset into a clean copy of the pinned Godot version.
- Check scale, orientation, origin/pivot, material appearance, texture paths, skeleton, animation names and collision assumptions.
- Confirm the asset can be instantiated as a reusable Godot scene.
- Check warnings and missing dependencies.
- Test a second reimport after a source change.

### Stage D — Assembly
- Keep reusable asset scenes separate from level/set scenes.
- Place reusable assets by reference/instance rather than copying their geometry into each level.
- Keep collision, interaction and gameplay logic explicit in Godot rather than hiding unreviewed behaviour in art exports.
- Avoid a single global asset index until there is a demonstrated need.

### Stage E — Version control and review
- Commit source and exported assets in a predictable relationship, subject to repository size constraints.
- Review text-based .gltf diffs where useful; use .glb when compact binary packaging is more practical.
- Do not commit generated caches merely because another studio did so; follow Godot's current import rules and actual CI requirements.
- Test the asset in Godot before declaring it ready.
- Preserve the previous working asset until the new export passes checks.

## 4. Asset contract and loophole checks

| Failure mode | Prevention | Acceptance evidence |
|---|---|---|
| Wrong scale or orientation | Defined export units, axis and origin conventions | Known-size reference asset appears at expected size/orientation |
| Missing textures/material drift | Explicit texture/material export rules | Clean import and reimport visually match approved reference |
| Animation clips merge or disappear | Named actions/NLA strips and documented export settings | All expected clips appear separately and play in Godot |
| Duplicate asset IDs | Stable unique IDs; duplicate detection in review/import tooling | Deliberately duplicated ID is caught before acceptance |
| Nested asset geometry duplicated | Export references and instances deliberately | Repeated instances do not duplicate source geometry unexpectedly |
| Material source-of-truth ambiguity | Define ownership of material values and avoid import-order dependence | Clean reimport produces identical material settings |
| Asset index merge conflict | Avoid central mutable index until necessary | Parallel asset additions do not require conflicting edits |
| Import works only on one workstation | Documented tool versions and clean import check | Fresh checkout imports with documented free tools |
| Generated files accidentally lost | Establish which Godot import artifacts are reproducible/required | Fresh CI import succeeds from committed source and exports |
| Art export changes gameplay collision | Separate art and gameplay collision contracts | Collision tests pass after asset replacement |
| Large assets damage mobile budget | Track mesh/texture/material/animation budgets | Representative device profiling before approval |

## 5. What should be tested first in BTV

Do not start by building a large asset library or custom Blender extension. Use one representative, non-canon test asset with:
1. one mesh;
2. one PBR material and texture;
3. optionally, one skeleton and two named animation clips;
4. one simple collision proxy;
5. one reusable Godot scene instance.

Acceptance checks:
- export is repeatable;
- scale/origin are predictable;
- textures/materials import correctly;
- animation names remain separate;
- collision is not accidentally coupled to visual mesh detail;
- clean checkout/import works;
- a source edit and re-export do not break existing scene references;
- no unexplained duplicate IDs or import warnings;
- asset remains within a provisional performance budget once a target device is known.

The test asset should not be Asher or Ember until their source assets and visual baselines have been reviewed and approved for that use.

## 6. BTV-specific boundaries
- This research does not approve a new character appearance, rig, outfit or Ember design.
- Do not replace or reinterpret the existing Asher GLB asset based on this research.
- Do not add unapproved visual symbolism or lore through environment props.
- Do not implement gameplay collision solely from artist-authored geometry without an explicit gameplay collision contract.
- Do not choose a renderer or claim Android readiness from desktop import success.
- Do not introduce paid plugins, marketplace assets or services.

## 7. Source quality and limitations
- Blender Studio's article is a first-hand technical director account of a real eight-person game pipeline. It is strong primary practitioner evidence for that project, but not an independent benchmark.
- The article describes a custom pipeline whose repository archive is 9.9 GB and requires a paid Blender Studio membership to download. This research did not download it or incur any cost.
- Official Godot docs are authoritative for supported import formats and editor behaviour, but do not prescribe one ideal team pipeline.
- A 2026 animation-export blog was discovered during research but is secondary material; its claims require validation against version-specific Blender and Godot documentation.

## 8. References
- Blender Studio, “Our Workflow with Blender and Godot” (2025): https://studio.blender.org/blog/our-workflow-with-blender-and-godot/
- Blender Studio, “Dogwalk Asset Creation Process”: https://studio.blender.org/blog/dogwalk-asset-creation-process/
- Godot 4.7, “Available 3D formats”: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html
- Godot 4.7, “Importing 3D scenes”: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html
- Khronos glTF: https://www.khronos.org/gltf/

## 9. Next research
- Character pipeline: skeleton conventions, retargeting, locomotion, facial animation and companion performance.
- Blender Studio DOGWALK character/animation pipeline and accessible production breakdowns.
- Godot 4.7 AnimationTree, AnimationLibrary and retargeting workflows.
- Build a test-first asset-import acceptance specification before touching BTV's existing character assets.
