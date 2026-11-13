# BTV Pre-Trailer Readiness Pack v0.1

**Date:** 13 November 2026  
**Status:** PROPOSED PRODUCTION PLAN — NOT RECORDING APPROVAL  
**Audit baseline:** `btv/chapel-visual-integration-001`  
**Authority:** Creator's Master Pre-Trailer Development & Readiness Directive; BTV source-of-truth documents

This pack fulfils the initial reporting deliverables after the technical audit. It records current implementation evidence, blockers and a staged plan. It does not convert proposed art or gameplay into canon, and it does not authorize trailer production.

## 1. Character Readiness Report — Asher Vance

**Identity:** CONFIRMED — Asher Vance, age 18, human, central protagonist. The current creator directive specifies a white Covenant uniform, restrained gold details and cross-centred Christian insignia.

**Repository evidence:** No Asher model, rig, materials, textures, animation clips or character scene are present in the audited Godot feature branch. The player is a capsule placeholder.

**Reference status:** An archived Asher showcase candidate exists outside the repository, but its printed age and accessory/body metadata conflict with or exceed the current approved facts. It is not a final production model sheet. Exact facial identity, hairstyle, detailed body design and final equipment are not sufficiently established in the audited source tree to reproduce safely.

**Readiness:** NOT READY.

**Required sequence**
1. Reconcile the current creator-approved Asher reference and reject stale/unapproved details.
2. Record a character asset brief with front/side/back views, face/hair, uniform construction, insignia placement, material references and scale.
3. Build or obtain the model through a zero-credit/free workflow with recorded provenance and licence.
4. Validate humanoid skeleton, proportions, skinning, materials, LOD and import scale.
5. Implement idle, walk, run, start/stop, turn, interaction and listening clips.
6. Integrate into the player scene and test camera framing, collision, movement responsiveness and animation blending.
7. Verify the same identity in gameplay and all future recording scenes.

Do not add weapons, armour, accessories, scars, new powers or costume variants merely to make the character appear more elaborate.

## 2. Ember Companion Readiness Report

**Identity:** CONFIRMED — Ember is Asher's natural animal companion and field partner. He must remain a believable canine, communicate through animal body language and never speak as a human or claim divine authority.

**Appearance:** UNKNOWN at production-model level. The exact approved BTV appearance is not represented in the Godot repository. A historical Afterfall companion image is not a valid substitute for BTV Ember.

**Repository evidence:** No Ember mesh, rig, animation, companion scene, follow controller, perception logic or command execution system is present.

**Readiness:** NOT READY.

**Required sequence**
1. Reconcile a BTV-specific approved reference and record species/anatomy, proportions, coat, markings, size and silhouette.
2. Create a canine model and rig with correct quadruped anatomy and natural deformation.
3. Implement idle, alert, walk, trot, run, turn, stop, rest, sniff and follow locomotion.
4. Implement follow-distance bands, path recovery, obstacle avoidance and safe teleport/recovery only as a last-resort technical fallback.
5. Add context-sensitive commands only after baseline following works. Approved command vocabulary remains Attack, Protect, Scout, Track, Retrieve, Hold and Regroup; each command needs a defined safe acceptance/rejection condition.
6. Respect Ember's survival/protection priorities and animal judgment. He may delay, interrupt or refuse an unsafe or impossible command.
7. Test proximity, animation transitions, collision, navigation and mobile performance.

No wings, cybernetics, demonic/angelic anatomy, human speech, divine status or guaranteed supernatural detection.

## 3. Covenant Headquarters Development Plan

**Status:** PROPOSED — no Covenant HQ scene exists.

The headquarters must be a distinct Covenant facility, not a renamed church or reuse of the Logos Rhema chapel study. The Church and Covenant remain separate in BTV canon.

### Vertical-slice footprint

| Zone | Purpose | Required interaction |
|---|---|---|
| Exterior approach and arrival court | Establish the HQ silhouette, scale and navigation landmark | Spawn, approach, enter |
| Reception / central atrium | Orient the player and stage a small number of NPCs | Speak to one duty NPC; receive a contextual direction |
| Operations / briefing room | Make mission information understandable | Open the mission board and review one authored assignment |
| Training / movement court | Test movement, camera, collision and companion following in a controlled space | Traverse, turn, interact, call Ember |
| Optional archive or equipment alcove | Add a useful secondary point of interest only if the vertical slice requires it | Inspect one approved information object |

### Functional requirements
- One coherent player route from spawn to briefing, with clear landmarks and no dead-end navigation.
- A small NPC set using unnamed role placeholders until canon-approved character records are assigned.
- Initial NPC behaviour can use simple authored routines: idle, walk between marked points, face/attend, respond to proximity and enter a dialogue state.
- Dialogue must be authored, context-aware and sourced from approved content. Do not invent new canon to fill idle chatter.
- Mission board must show real mission data and state, not decorative UI. Begin with one approved mission introduction.
- Ember must follow and respond to the player's proximity and a small, testable interaction loop.
- Interior/exterior transitions must preserve player state and avoid a loading black screen where practical.
- Keep collision, navigation and decorative geometry separable.

### Art direction
- Distinctive modern Covenant architecture; white base with restrained gold and approved cross-centred insignia.
- The Church is not a Covenant facility. Avoid copying church architecture or turning the HQ into a worship space.
- Establish exterior, atrium and briefing-room silhouettes before surface detail.
- Use material variation, weathering, signage, believable reflections and practical light sources.
- Add audio ambience only after zone layout and sound ownership are defined.

### Explicitly out of scope for this slice
A full open world, large NPC population, complex daily schedules, advanced combat, full economy, extensive facilities, persistent world simulation and elaborate cutscenes.

## 4. Vertical Slice Implementation Checklist

### P0 — Build and test foundation
- [x] Inspect repository, branches, project configuration, scenes, scripts, assets and historical CI evidence.
- [x] Record pre-trailer technical audit.
- [x] Add the chapel feature branch to the Godot validation workflow and expand test commands.
- [x] Obtain a successful full CI run on the current feature branch.
- [x] Verify the GLB import and chapel load test in that run.
- [ ] Establish one designated working branch and keep main isolated.

**P0 validation evidence:** GitHub Actions run [43410957023](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/43410957023) passed on commit `9e7d9c3fd84d10aaaff6c1c8b54a50043fa4bfd1`: Godot 4.7.2, editor import/parsing, 15 test scripts, chapel scene-load test and 10-frame main-scene launch. The later documentation-only commit is being revalidated. This is headless validation, not Android or visual/device certification.

### P1 — Functional vertical slice
- [ ] Approve Asher production reference and integrate model/rig.
- [ ] Implement Asher animation state machine and camera presentation.
- [ ] Approve BTV Ember reference and integrate natural canine model/rig.
- [ ] Implement reliable Ember follow behaviour and test it before commands.
- [ ] Build separate Covenant HQ blockout and connect it to the main scene.
- [ ] Add one functional NPC interaction.
- [ ] Add a working mission board backed by approved mission data.
- [ ] Implement one short mission introduction using existing BTV story material.
- [ ] Test transitions, collision and navigation.
- [ ] Keep keyboard/mouse and touch behaviour on the same gameplay contract.

### P2 — Gameplay and visual polish
- [ ] Animation blending and foot placement.
- [ ] Camera responsiveness, obstruction handling and framing.
- [ ] NPC pathing and interaction feedback.
- [ ] Ember proximity, follow-distance and recovery behaviour.
- [ ] Lighting/material pass and contextual signage.
- [ ] Environmental ambience, footsteps and companion sounds.
- [ ] Visual review on low and high graphics settings.

### P3 — Android readiness
- [ ] Identify minimum target Android device and comparison device.
- [ ] Add and validate Android export configuration.
- [ ] Export, install and launch on physical device.
- [ ] Test safe areas, touch layout, multitouch and display scaling.
- [ ] Profile frame-time, memory, loading, thermal state and sustained stability.
- [ ] Choose renderer and graphics tiers from measured results, not assumptions.

### P4 — Recording readiness
- [ ] Complete all vertical-slice acceptance tests.
- [ ] Capture representative sample footage.
- [ ] Review sample footage for visible glitches, camera issues and false representation.
- [ ] Approve final storyboard, narration, sound and shot list.
- [ ] Record final gameplay takes.
- [ ] Edit landscape and vertical masters separately.
- [ ] Obtain creator approval before any public upload.

## 5. Android Performance Report

**Current status:** BLOCKED / NOT MEASURED.

Confirmed:
- Android-first is the approved target intent.
- Touch input source code exists.
- CI uses Godot 4.7.2 headless.

Unknown or not run:
- Minimum supported phone model, GPU, RAM and Android version.
- Renderer choice and graphics API compatibility.
- Android export, APK installation and launch.
- Sustained frame-time, memory, battery and thermal behaviour.
- Real touch safe areas and multitouch behaviour.

The chapel study contains 264 separate meshes and 84,864 triangles according to its asset record. This is a profiling candidate, not an approved mobile budget. Merge-by-material, LOD, baked lighting, texture compression, visibility ranges and selective simulation should be evaluated only after import and device measurements.

**Target policy:** use 30 FPS (33.3 ms/frame) as a proposed minimum-device planning objective and pursue 60 FPS (16.7 ms/frame) on capable tiers where measurements allow. These are targets, not current results or guarantees.

## 6. Visual Quality Report

**Current status:** NOT READY FOR PRODUCTION REVIEW.

| Area | Current evidence | Gap |
|---|---|---|
| Player | Capsule mesh and collision | No Asher identity, materials, rig or animation |
| Companion | No scene or asset | No Ember model, rig, locomotion or AI |
| Headquarters | No Covenant HQ | Only a separate church-interior study |
| Lighting | Basic directional light in greybox; placeholder omnis in chapel scene | No approved HQ lighting pass or device profiling |
| Materials | Greybox primitive materials; chapel flat PBR materials | No production texture/material set |
| Environment | Flat test floor and chapel interior asset | No exterior, regional identity or gameplay set dressing |
| NPCs | None in main scene | No characters, routines, dialogue or persistence |
| Audio | No production audio assets found | No ambience, footsteps, companion sounds or music |
| Cinematic camera | Basic third-person gameplay camera | No authored shot rig or recording camera system |

The five previously reviewed reference-video lessons should guide original work: material imperfections, believable light/reflections, natural movement, regional identity, inhabited spaces, gradual discovery, NPC routines/relationships/memory, contextual HUD and deliberate camera/sound composition. The exact video titles/URLs are not recoverable in this audit record; no copyrighted assets or distinctive designs are to be copied.

## 7. Provisional Trailer Storyboard — 38 seconds

**Status:** PROPOSED. Not approved for recording. Every shot is conditional on the corresponding gameplay being implemented and verified.

| Time | Intended scene | Required real gameplay evidence | Camera intent |
|---|---|---|---|
| 0–4 s | Covenant HQ exterior and world atmosphere | Finished exterior, lighting and ambience | Wide establishing shot; slow controlled move |
| 4–9 s | Asher Vance reveal | Approved model, uniform, face and walk animation | Medium tracking reveal; brief facial detail |
| 9–15 s | HQ interior reveal | Explorable atrium with functional navigation | Wide interior reveal into a controlled forward move |
| 15–21 s | NPC activity and mission board | Working NPC interaction and live mission board | Over-shoulder interaction, then board detail |
| 21–26 s | Ember companion reveal | Natural canine model, follow behaviour and readable response | Low camera at Ember's height, then side-follow |
| 26–33 s | Core gameplay and Christian identity | Actual movement, interaction and approved environmental storytelling | Gameplay-height tracking and one clear interaction |
| 33–38 s | Final title: “THE WATCH BEGINS” | Approved title treatment and original/cleared audio | Clean title hold and controlled audio resolve |

### Provisional narration draft
*Not canon, not locked, and not recorded.*

“Beyond the world we know, a hidden struggle is unfolding. Asher Vance stands watch with the Covenant, where truth, responsibility and courage are tested. With Ember beside him, the path leads beyond what the eye can see. Beyond the Veil: The Last Watch. The watch begins.”

Revisit every sentence against the finished gameplay and story context before recording. Do not imply mechanics, characters or events that are not in the build.

## 8. Trailer Shot List

1. HQ exterior wide establishing shot.
2. Slow push toward the HQ entrance landmark.
3. Asher entering frame at natural walking speed.
4. Medium shot of Asher's approved uniform and insignia.
5. Restrained facial close-up during an authored interaction.
6. Atrium reveal showing real NPC activity.
7. Tracking shot following Asher through the HQ.
8. Over-shoulder NPC conversation.
9. Mission board close-up with readable, real mission state.
10. Ember enters frame naturally and approaches Asher.
11. Side-profile follow shot showing believable canine gait.
12. Demonstration of one implemented companion command, if ready.
13. Gameplay traversal through the HQ movement route.
14. Close-up of one genuine interactable/evidence object.
15. Exterior transition or mission departure only after that area exists.
16. Final BTV title card: “THE WATCH BEGINS”.

Capture alternate takes for 16:9 and 9:16. Do not rely on cropping a landscape master to create a readable vertical version.

## 9. Production and Editing Plan

### Formats
- Landscape master: 1920×1080, 16:9.
- Vertical version: 1080×1920, 9:16.
- Capture separate framing or camera takes for vertical. Keep Asher, Ember and important UI inside the relevant safe composition.
- Keep gameplay UI readable and do not add fictional HUD elements in post.

### Audio
- Original human narration.
- Original or properly licensed music only.
- Separate ambience, footsteps, Ember sounds, interaction sounds and music on the edit timeline.
- No AI voice or music generation unless separately approved and verified as zero-credit/free.
- Preserve dialogue intelligibility and avoid overpowering environmental cues.

### Editing
Use existing/free tools such as VN Video Editor, Shotcut or Kdenlive. Preserve source footage and project files. Do not publish or upload without creator approval.

### Thumbnail concept
A real gameplay frame with Asher and Ember in the foreground and the completed Covenant HQ behind them. Use the BTV title and a short, readable hook. Do not use generated characters or a fictional HQ render as if it were gameplay.

## 10. Pre-Trailer Readiness Report

**Current verdict: NOT READY.**

Blocking items:
1. No production Asher character or animations.
2. No BTV Ember model or companion behaviour.
3. No Covenant Headquarters.
4. No functional NPC interaction or mission board.
5. No verified mission introduction/gameplay loop.
6. No fresh validation run on the current feature branch after workflow expansion.
7. No Android export/install/device evidence.
8. No performance or thermal measurements.
9. No reviewed sample footage.
10. No final approved narration/recording.

The storyboard and shot list above are planning artefacts only. Final trailer production remains blocked until the creator's final readiness gate is passed.

## 11. Change and credit policy

- No paid asset, paid service, AI generation or credit-consuming action is required by this pack.
- No public upload, deployment, merge or release is authorized.
- Do not claim a feature is implemented from a storyboard, plan, mockup or scene placeholder.
- Keep proposals labelled PROPOSED until the creator approves them.
- The production objective remains: build a real, stable, beautiful gameplay experience first; then record what actually exists.
