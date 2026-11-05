# BTV GODOT 3D SMALL-TEAM POSTMORTEM RESEARCH
**Date:** 5 November 2026  
**Status:** SINGLE-CASE PRACTITIONER EVIDENCE — useful but not generalizable  
**Project:** Beyond the Veil: The Last Watch  
**Research focus:** Practical risks when a solo developer ships a 3D game using Godot.

## 1. Case study: Trigger of Time

**Source:** “Releasing a 3D game with Godot Engine,” Pantopie Studio  
https://pantopie.studio/releasing-a-3d-game-with-godot-engine/

The author describes building and releasing a small 3D first-person adventure in Godot. The project used Godot 4.3 and 4.4. The developer identifies as mostly solo and explicitly notes that the article does not cover a multi-person team workflow.

### Reported advantages
- Godot was lightweight and quick to launch.
- The author found it flexible for prototyping.
- Open-source licensing and the small build footprint suited the project.
- The engine was considered sufficient for the project's visual goals.
- The author reported cross-platform desktop testing across macOS, Windows and some Linux.

### Reported production difficulties
- **Language/tooling workflow:** the author regretted choosing C# for that project, citing setup/compile/launch friction and lack of integrated profiling in the Godot versions used. The author planned to use GDScript on the next project.
- **Asset import:** direct Blender `.blend` import was reported as slow and occasionally unstable. The author later preferred keeping source working files separate and exporting through glTF.
- **Editor stability:** the author reported frequent editor crashes during development, while noting that testers did not encounter crashes in the shipped game.
- **Scene/project integrity:** the author reported scenes, overrides and signal connections unexpectedly reverting or disappearing, and states that Git version control prevented permanent loss.
- **3D editor workflow:** the author found 3D selection and gizmo operations frustrating and used Blender or other external tools for some level-building tasks.
- **Visual performance:** the author used LOD, visibility/distance fade, occlusion culling, shadow/light controls and other optimisation techniques. The author also reported historical lightmap-baking issues in the versions used.
- **Audio:** built-in audio covered much of the project's needs, but the author wanted more advanced features such as sound occlusion and per-sound processing.

## 2. Evidence quality and limitations
This is a first-person postmortem from one mostly-solo developer. It is valuable because it records practical friction that engine feature lists often omit. It is not a controlled comparison and cannot establish that every Godot project will experience the same problems.
- The project used Godot 4.3 and 4.4; several reported issues may have changed in later releases.
- The author's language choice, asset pipeline and editor experience are context-dependent.
- A single desktop 3D game does not validate Android performance or BTV's larger interconnected-world ambitions.
- Reported editor instability should be treated as a risk to mitigate, not as proof that Godot is broadly unstable.

## 3. Current engine-version context (5 November 2026)

Official Godot sources report:
- Godot 4.7 stable released 18 June 2026.
- Godot 4.7.1 stable released 14 July 2026.
- Godot 4.7.2 stable released 18 August 2026.
- Godot 4.8 beta 2 released 29 October 2026; it is a beta, not the stable production baseline.

Sources:
- Official download archive: https://godotengine.org/download/archive/
- Godot release policy: https://docs.godotengine.org/en/stable/about/release_policy.html
- Godot 4.7.2 maintenance release: https://godotengine.org/article/maintenance-release-godot-4-7-2/
- Official signed GitHub release listing: https://github.com/godotengine/godot/releases

**BTV status:** engine version is not yet confirmed/pinned in this research record. Godot 4.7.2 is the current stable candidate as of this date, but this is not an approval to migrate or pin BTV. Before choosing, inspect the actual project, plugins, import formats, platform requirements and CI. Do not use 4.8 beta for production without a deliberate risk decision and isolated validation.

## 4. Practical risk controls proposed for BTV

| Risk | Control to evaluate | Acceptance evidence |
|---|---|---|
| Editor crash or corrupted scene | Git commits before risky imports/scene edits; small commits; recoverability checks | Restore a prior commit and verify scene opens |
| Asset import stalls | Separate source files from engine-ready exports; test glTF import path | Reimport test scene without missing resources or broken materials |
| Language slows iteration | Prototype a representative gameplay loop in the intended language | Measure edit-run-debug cycle and profiling support |
| 3D level editing becomes inefficient | Evaluate Blender-based blockout and Godot integration | Round-trip a small greybox without scale/origin/material loss |
| Large scenes become slow | Profile representative scenes; use LOD/HLOD/occlusion only where measurements support them | Frame-time and memory measurements on target device |
| Audio needs exceed built-in tools | Inventory actual sound requirements before middleware | Prototype ambience, positional audio, mixing and scene transitions |
| Version drift breaks project | Pin exact engine version and export templates in project documentation/CI | Clean import and test run on pinned version |
| Android export is mistaken for readiness | Test on verified target hardware under sustained load | Repeatable performance, memory, thermal and stability evidence |

## 5. Implications for BTV

1. Keep Git/version-control discipline central. This aligns with BTV's existing isolated-branch workflow.
2. Test the Blender-to-Godot asset path early with one representative model, one material and one animation before scaling asset production.
3. Do not select GDScript or C# from one developer's experience alone. Compare iteration speed, profiling, Android support, library needs and team familiarity using a tiny prototype.
4. Keep 3D blockout and environment art workflows modular. If Godot editor selection becomes a bottleneck, evaluate external blockout tools rather than forcing every task into one editor.
5. Build an audio requirements list before selecting middleware; do not add paid middleware without explicit approval.
6. Choose an exact stable engine version only after inspecting the actual repository and testing a clean project copy. A version number in the docs is not proof that the BTV project uses it.

## 6. Related official Godot sources
- Godot scene organization: https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- Godot 3D scene import pipeline: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html
- Godot profiler: https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html
- Godot mesh LOD: https://docs.godotengine.org/en/stable/tutorials/3d/mesh_lod.html
- Godot visibility ranges/HLOD: https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html
- Godot occlusion culling: https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html
- Godot Android export: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

## 7. What this research does not authorize
- No engine-version migration or pinning.
- No switch of scripting language.
- No new paid asset, audio, profiling or middleware purchase.
- No changes to BTV architecture or canon.
- No Android readiness claim.
- No claim that the reported postmortem problems reproduce in BTV.
