# BTV Technical and Development Audit — Pre-Trailer Gate

**Audit date:** 13 November 2026  
**Scope:** Godot main-game repository, pre-trailer readiness  
**Audit mode:** Read-only repository and source inspection; no runtime/device claims  
**Selected audit baseline:** `btv/chapel-visual-integration-001`  
**Baseline commit:** `ea411616b60f772c675e417132b27704fb19f48c`  
**Final verdict:** **NOT READY**

## 1. Executive finding

BTV currently has a tested Godot prototype foundation, not a playable cinematic vertical slice. The repository contains a basic third-person capsule controller, keyboard/mouse and touch input paths, proximity interaction, deterministic NLI foundations, mission-data validation, and one imported chapel-interior study. It does not yet contain Asher's production character, Ember, a Covenant Headquarters, a functional NPC ecosystem, a mission board, companion AI, authored gameplay missions, production animation, or a verified Android build.

The most important governance issue is branch separation: the repository default branch `main` does not currently contain the Godot project entry point. The most complete Godot feature branch is separate and unmerged. No branch was merged or published during this audit.

## 2. Repository and branch audit

### Confirmed repository state
- Repository: `KINGACEX/beyond-the-veil-last-watch-`
- Default branch: `main`
- Default-branch head: `a092b8c5c524973b6631ef40638010d9d6a8a062` — 10 November 2026.
- The default branch tree contains a README, documentation, and a small weather-validation scene/script. It does **not** contain `project.godot`, the player scene, or the playable prototype.
- The repository README on the Godot feature line identifies `btv/test-first-contracts-001` as the active isolated engineering branch. That branch head is `023855507523bd1bcf9ece8840fc33ceba61506b` (6 November 2026).
- The latest and most complete Godot feature line found is `btv/chapel-visual-integration-001`, head `ea411616b60f772c675e417132b27704fb19f48c` (10 November 2026). It is **34 commits ahead and 0 behind** `btv/test-first-contracts-001`.
- The chapel feature branch and `main` have diverged: comparison reports 294 commits ahead and 4 behind, with a merge base outside the current main head. Do not merge or reconcile automatically.
- The chapel branch is a better audit baseline than the documented test-first branch because it preserves that branch's foundation and adds the touch-input hardening and chapel asset study. This is a working-baseline selection, not proof of the user's local checkout.
- The Roblox feature branch is separate and is not part of this Godot audit.

### Branch-control finding
GitHub exposes repository refs, not the user's current local checkout. Therefore the actual locally checked-out branch is **UNKNOWN**. The repository README's documented active branch is stale relative to the newer chapel feature branch. Before future implementation, maintain one explicitly designated Godot working branch and keep all work isolated there.

## 3. Engine, configuration and dependencies

- Engine: Godot 4.x / GDScript.
- CI pins Godot **4.7.2**. This confirms the CI toolchain version, not the editor version installed on a developer's device.
- `project.godot` uses config version 5 and sets `scenes/main.tscn` as the run scene.
- Viewport/window baseline: 1280×720.
- Keyboard movement and interaction actions are configured. Touch has a separate action namespace so touch releases cannot cancel keyboard input.
- The project does not explicitly pin a renderer in the inspected project configuration. Renderer selection remains unresolved and must be measured on the target Android device.
- No Android export preset, APK, signing configuration, or Android build artifact was found in the audited project tree.
- No external runtime dependency or paid service is required by the current prototype.

## 4. Existing implemented systems

### Player and input
- `CharacterBody3D` capsule placeholder with collision.
- Third-person camera pivot and SpringArm3D.
- Camera-relative keyboard movement, gravity and facing rotation.
- Desktop mouse capture/look handling.
- Touch analogue movement, separate look finger and touch interaction action.
- Touch action composition is separated from keyboard actions.
- Proximity sensor tracks interactable areas and selects the nearest eligible target with deterministic tie-breaking and duplicate-ID exclusion.

These are real prototype systems, but the player is still a capsule. There is no Asher model, animation state machine, jump/parkour system, polished collision traversal or final camera presentation.

### Interaction, NLI and mission data
- Reusable `BTVInteractable` contract and a neutral test interactable.
- Deterministic NLI phrase parser, intent validator, request gate, authored knowledge base and orchestration service.
- Neutral typed-registry mission-data validator.

These are foundations, not a finished dialogue or mission system. The NLI service does not own or verify a live NPC actor's acceptance/execution lifecycle. The mission validator validates data structure; it is not a mission board, mission runtime or completed mission.

## 5. Scenes, environment and reusable assets

### Main scene
`scenes/main.tscn` is a greybox test area: flat 40×40 floor, directional light, capsule player, test interactable and touch-control overlay. It does not instance the chapel scene.

### Chapel study asset
The feature branch contains:
- `scenes/chapel/logos_rhema_chapel_study_001.tscn`
- `assets/environment/chapel/logos_rhema_chapel_interior_study_001/logos_rhema_chapel_interior_study_001.glb`

The GLB is 5,748,472 bytes and the asset record reports 264 meshes, 312 primitives, 84,864 triangles, 170,720 vertices and 13 materials. It has no textures, images, cameras, lights or animations. The scene adds placeholder lighting and a placeholder floor collision.

**Asset qualification:** The asset README records Blendstra as the source, marks licence/provenance as unverified, and labels the study proposed/not canon. It also says the binary is not yet committed, although the GLB is present in the audited branch tree; that README statement is stale. A headless scene-load test exists but is not included in the current CI workflow and has not been run in this audit.

**Important canon distinction:** This is a church-interior study, not a Covenant Headquarters. BTV keeps the Church distinct from the Covenant. Do not repurpose this chapel as the Covenant HQ. It may be retained for a future church scene only after provenance/licence review, import verification, collision review and Android profiling.

### Missing production assets
No Asher model, Ember model, character rig, animation clips, character textures, Covenant Headquarters environment, production NPC models, mission-board asset, production props, environmental audio or music were found in the audited feature-branch tree.

## 6. Character readiness

### Asher Vance
- Creator directive confirms age 18, human identity, white Covenant uniform, restrained gold details and cross-centred insignia.
- No Asher model, rig, materials, texture set or animation exists in the repository.
- Exact approved face, hairstyle, detailed body design and final model reference remain unresolved in the repository.
- The historical Library character-showcase candidate has age and design metadata that conflict with the current age-18 direction and is not an approved production model sheet. Do not reproduce its unapproved details as canon.

**Status: NOT IMPLEMENTED.** A consistent premium protagonist cannot be claimed until an approved reference is reconciled and a model/rig/animation set is integrated and tested.

### Ember
- The companion reference material describes Ember as a natural, original canid companion with fallible perception and animal behaviour. He must not speak or become a divine/spiritual authority.
- Exact visual appearance remains open.
- No BTV Ember model, rig, locomotion clips, follow AI, proximity logic or command execution system exists in the repository.
- A historical Afterfall companion image is not evidence of BTV Ember's approved appearance and must not be silently reused.

**Status: NOT IMPLEMENTED.** The natural canine identity is a hard constraint; model and behaviour are outstanding.

## 7. Covenant Headquarters and gameplay readiness

No Covenant Headquarters scene, exterior, explorable floor plan, mission board, interactive command area, NPC routine system, contextual dialogue runtime, persistent NPC state, companion interaction point or mission selection flow exists in the current main scene.

The chapel study cannot substitute for the HQ. The first HQ slice should be a compact, purpose-built Covenant facility with a clear navigation loop, a small number of functional rooms, and only the interactions required for the first mission. Do not build the entire open world before this loop works.

## 8. Android and performance audit

**Confirmed:** Android-first is the approved platform intent. Touch input code exists.

**Not verified / blocked:**
- Physical Android export, installation and launch.
- Touch safe areas, scaling, multitouch and usability on actual hardware.
- Target device model, GPU, RAM and Android version.
- Renderer comparison.
- Sustained frame time, memory, battery and thermal behaviour.
- Region loading, streaming, LOD, pooling and NPC simulation budgets.

The chapel GLB's 264 separate meshes are a clear profiling risk for mobile. Its triangle count alone does not establish performance; draw calls, materials, overdraw, import behaviour and lighting must be measured. The current greybox is not a representative performance benchmark.

No local Godot executable or Android build tool was available in the audit container. No physical-device claim is made.

## 9. Automated validation baseline

The latest successful CI run found on the documented test-first branch is run **42297356878**, dated 6 November 2026, commit `023855507523bd1bcf9ece8840fc33ceba61506b`. It installed Godot 4.7.2 and passed project import/parsing, NLI smoke tests, NLI contract tests, mission-data validator tests, core interaction tests and a 10-frame main-scene launch.

After inspection, `.github/workflows/godot-validation.yml` was updated in commit `6043090bf24fd315c0efd0824eabb59334db25c1` to include the chapel branch, increase the timeout to 15 minutes, run the additional touch lifecycle/composition/input suites, and run the chapel GLB load test. **CONFIRMED:** GitHub Actions run [43410957023](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/43410957023) completed successfully on commit `9e7d9c3fd84d10aaaff6c1c8b54a50043fa4bfd1`. It passed Godot 4.7.2 verification, editor import/parsing, all 15 test scripts (including the chapel GLB load test), and a 10-frame main-scene launch. The later documentation-only commit `10a6946003170911f33552af6cd43b386770c25d` has a new validation run in progress; it does not change game code.

A previous XH-003 implementation note reports 14 suites / 276 assertions passing locally on its ancestor branch. That is historical branch evidence, not a fresh CI result for the current chapel branch.

**Baseline conclusion:** The prototype foundation has historical headless CI evidence. The current feature branch, chapel asset import, Android build and device behaviour are not presently verified.

## 10. Reference-video lessons carried forward

The five previously reviewed reference videos are not fully identified by title/URL in the current audit record. The recorded lessons to apply are:
- believable lighting/reflections, small material imperfections and natural movement;
- distinct regional identity and inhabited spaces;
- gradual discovery through environmental clues;
- NPC routines, relationships and remembered interactions;
- choices reflected in later dialogue/conditions/relationships;
- contextual, uncluttered HUD;
- deliberate camera composition, sound and transitions.

Apply these principles in original BTV designs. Do not copy protected maps, characters, assets, branding, story beats or signature mechanics.

## 11. Baseline readiness matrix

| Requirement | Status | Evidence / blocker |
|---|---|---|
| Repository and branch audit | COMPLETED | Default main, documented branch and latest Godot feature branch inspected |
| Godot engine baseline | CONFIRMED | CI pins 4.7.2 |
| Current branch headless validation | BLOCKED | No CI run on chapel branch; no local Godot executable |
| Asher production character | NOT IMPLEMENTED | No model, rig, textures or animation |
| Ember companion | NOT IMPLEMENTED | No model, rig, follow/command AI or animation |
| Covenant Headquarters | NOT IMPLEMENTED | Only separate chapel study; no HQ |
| Third-person movement/camera | PROTOTYPE IMPLEMENTED | Capsule controller and camera; not presentation-polished |
| Touch input | PROTOTYPE IMPLEMENTED | Source code and tests; physical device not checked |
| NPC ecosystem | NOT IMPLEMENTED | No NPC actors/routines/persistent state |
| Mission board / selection | NOT IMPLEMENTED | No mission runtime or board |
| Environmental audio | NOT IMPLEMENTED | No audio assets/system found |
| Android export and launch | BLOCKED / NOT RUN | No export preset or device evidence |
| Android performance | BLOCKED / NOT MEASURED | Target hardware unknown |
| Sample gameplay footage | NOT AVAILABLE | No verified playable vertical slice |
| Trailer storyboard/narration | NOT YET READY | Must be based on implemented gameplay |

## 12. Recommended implementation order

1. Designate one Godot working branch and update stale branch/readme status without merging to `main`.
2. Restore reliable validation on that branch: Godot 4.7.2 import, all relevant test suites, chapel asset load test, and main-scene launch.
3. Establish the approved Asher and Ember reference set and asset provenance before production modelling.
4. Build the Asher player scene and animation foundation; retain keyboard/mouse and touch parity.
5. Implement Ember as a natural canine with follow/proximity behaviour before adding the seven approved commands.
6. Build a separate Covenant Headquarters blockout with one reliable exploration route, a mission board, a small NPC set and functional interactions.
7. Implement one short, authored mission introduction that proves the HQ-to-gameplay loop.
8. Add lighting/material/audio polish only after the scene is functionally stable.
9. Identify the minimum Android test device; export, install, profile and run a sustained test before choosing renderer or budgets.
10. Record sample gameplay only after the vertical slice passes the final readiness gate.

## 13. Governance and audit limits

- No code, canon, branch merge, release, public upload, paid generation or subscription was changed or initiated during this audit.
- No game was launched in the Godot editor or on a physical Android device during this audit.
- This report distinguishes source-code presence and historical CI evidence from runtime/device verification.
- The audit baseline is the latest complete Godot feature branch found, not proof of the user's local checkout.

**Final verdict: NOT READY.** BTV has a useful prototype foundation and an environment asset study, but it does not yet have the required character, companion, Covenant Headquarters or functional gameplay loop for credible trailer recording.
