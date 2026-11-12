# BTV Roblox Companion 3D Asset Pipeline v0.1

**Status:** Production specification; proposed budgets require profiling in Roblox Studio on target devices.
**Scope:** Roblox edition only. Does not modify the Godot project's asset pipeline or canon.
**Visual target:** Grounded, realistic, cinematic animal companions with mobile-first performance.
**First benchmark:** Ember. The current procedural low-poly actor is temporary and must not be presented as final art.

## 1. Production objective

Create one reusable animal asset pipeline rather than eight unrelated models. Each companion must have:
- recognisable, species-accurate anatomy and silhouette;
- believable proportions, materials and surface detail;
- a consistent animation quality bar;
- reliable follow, hold, regroup and safe recovery behaviour;
- readable presentation on small Android screens;
- predictable multiplayer replication and bounded performance cost.

No asset purchase, paid plugin, paid generation, public upload or marketplace purchase is authorised by this specification.

## 2. Asset architecture

Separate each companion into four layers:

1. **Species asset:** mesh, skeleton, materials, texture maps and species-specific animation clips.
2. **Shared runtime contract:** root attachment, scale metadata, animation state names, interaction anchors and LOD configuration.
3. **Server behaviour:** selection, ownership, valid state transitions, follow target and safe recall.
4. **Client presentation:** animation playback, cosmetic presentation and non-authoritative visual effects.

The server remains authoritative for ownership, equipped companion, commands and mission context. Cosmetic animation must never grant information, movement advantages or mission outcomes.

## 3. Rig families

| Rig family | Animals | Production notes |
|---|---|---|
| Quadruped canine | Ember, Fox | Shared broad locomotion state names; separate species proportions and gait timing |
| Quadruped large feline | Leopard | Separate feline shoulder, spine, tail and paw motion; do not reuse canine silhouette |
| Quadruped heavy mammal | Bear | Weight-aware stance and slower transitions; no gameplay stat benefit |
| Equine | Horse | Dedicated gait set; mounted locomotion is a later feature gate |
| Avian | Eagle, Owl, Falcon | Dedicated wing, tail, neck and foot controls; perch and flight states |

A shared rig family is a technical starting point, not permission to make species look interchangeable. Each animal requires species-specific proportions, topology, deformation tests and animation review.

## 4. Required model deliverables

Each production-ready animal should include:

- clean, named mesh parts or skinned mesh hierarchy;
- named root and attachment points;
- deformation-safe skeleton and weights;
- neutral/rest pose;
- high-quality material assignment;
- texture maps sized for mobile;
- LOD variants or an approved simplification strategy;
- collision proxy separate from decorative geometry;
- animation clips listed in the shared state contract;
- source project and export settings;
- in-engine screenshot evidence at near, medium and far viewing distances.

Do not use a single primitive-part assembly as the final visual asset. Do not add excessive small geometry that is invisible at normal mobile camera distance.

## 5. Animation baseline

All animals require, where biologically appropriate:

- idle / breathing;
- alert / attention;
- walk;
- trot or equivalent faster gait;
- turn left and right;
- stop / settle;
- follow;
- hold / stay;
- regroup / recall;
- rest;
- interaction acknowledgement;
- transition into and out of movement.

Species-specific additions:
- **Ember:** expressive ears, head, tail and clear command acknowledgement.
- **Fox:** light, cautious foot placement and expressive tail/ears.
- **Bear:** grounded weight shifts and measured turns.
- **Leopard:** fluid feline spine and tail motion.
- **Horse:** walk, trot, canter only when locomotion and control are ready; natural hoof contact.
- **Owl:** perch, head orientation, short flight and landing.
- **Eagle:** grounded perch, take-off, controlled flight arc and landing.
- **Falcon:** compact perch, responsive flight and return.

Animation timing must not create different command effectiveness between free and premium animals. A quicker-looking animation must not execute the same command sooner or improve its result.

## 6. Proposed mobile performance budgets

These are initial project targets, not Roblox platform guarantees. Validate them on a low-end Android device before locking them.

| Metric | Initial target |
|---|---|
| Hero companion LOD0 | Aim for 8k–12k triangles |
| Mid-distance LOD | Aim for 4k–6k triangles |
| Far LOD | Aim for 1k–2k triangles or hide beyond useful view distance |
| Texture resolution | Prefer 512–1024 px per map; use 2K only with a documented visual need |
| Materials | Target 1–2 material slots per animal |
| Active companion count | Design for one owned companion per player; test a full multiplayer server |
| Shadows | Use selective shadow casting; avoid expensive small-part shadow clutter |
| Effects | No persistent particle trails; use short, low-cost effects only when justified |

Profile total scene cost, not just one animal. A server with multiple players can display multiple companions simultaneously. LOD and visibility rules must account for that multiplier.

## 7. Multiplayer and behaviour constraints

- One active companion per player.
- A companion must never become another player's controllable actor.
- The server validates owner, selection, command and context.
- Other clients receive coherent movement and state changes.
- Avoid per-frame server-to-client remote spam.
- Use bounded update rates and smooth local visual interpolation.
- Companion collision must not block doorways, objectives or other players.
- Safe recall must work without a purchase.
- If pathfinding fails, recover to a safe nearby position without teleporting through mission barriers.
- Companion switching occurs only in approved safe contexts.
- A premium shortcut calls the same server command path as the free control.

## 8. Ember visual benchmark gate

Do not begin mass production of all seven other animals until Ember passes this review:

1. Silhouette matches the approved Ember reference.
2. Face and eyes remain readable at normal mobile camera distance.
3. Fur, coat and markings use coherent, efficient materials.
4. Skeleton deforms cleanly during walk, turn, sit/rest and recall.
5. Follow distance and orientation feel natural without jitter.
6. Idle motion is subtle and does not look mechanical.
7. Nameplate is legible without obstructing the animal.
8. Performance is acceptable with several companions visible.
9. No mission or combat advantage is introduced by the visual actor.
10. The same asset works in a multiplayer Studio test.

The current low-poly procedural Ember actor remains a temporary fallback until this gate is passed.

## 9. Production sequence

| Stage | Deliverable | Exit condition |
|---|---|---|
| A | Ember reference and proportion sheet | Creator confirms silhouette and markings |
| B | Ember high-quality model and rig | Mesh, materials and deformation review passed |
| C | Ember animation set | Required state clips reviewed in engine |
| D | Ember mobile and multiplayer test | Device profiling and multi-client checks passed |
| E | Reusable quadruped pipeline | Fox, Bear and Leopard can use the pipeline without sharing species appearance |
| F | Avian pipeline | Owl, Eagle and Falcon have species-correct flight/perch states |
| G | Equine pipeline | Horse follow behaviour passes; mounting remains separately gated |

## 10. Asset sourcing and approvals

Preferred order:
1. Original project-owned model and textures created with free tools.
2. Clearly licensed free assets that permit the intended Roblox use and modification.
3. Paid assets only after explicit creator approval.

For every external asset, record creator, source URL, licence, attribution requirement, modification permission and date checked. Never assume that a model being downloadable means it is licensed for commercial use.

No marketplace asset is accepted until its licence and visual quality are reviewed. No external asset may replace Ember's approved identity without creator review.

## 11. Acceptance checklist

- [ ] Ember reference sheet approved.
- [ ] Ember model is no longer the low-poly placeholder.
- [ ] Rig and animation clips imported successfully.
- [ ] Companion follows and recalls without visible jitter.
- [ ] Species silhouette remains distinct at mobile viewing distance.
- [ ] LOD transitions do not visibly pop.
- [ ] Several players and companions tested in Studio.
- [ ] Low-end Android performance recorded.
- [ ] No paid-only gameplay function exists.
- [ ] Asset provenance and licence recorded.
- [ ] Creator approves the final visual benchmark.

## 12. Explicit non-goals

This specification does not authorise:
- Robux products, prices, purchase IDs or monetisation implementation;
- paid assets or paid generation credits;
- supernatural animal abilities or new Veil lore;
- mounted horse gameplay before its separate technical gate;
- combat-stat changes or mission-critical evidence detection;
- replacing the original Godot BTV companion canon with Roblox-only decisions.
## 13. Roblox import adapter — source implemented, asset not imported

The Roblox server now looks for a reviewed Ember model at:

`ServerStorage/BTVAssets/Companions/Ember`

The model must satisfy the shared contract in `src/shared/CompanionRigContract.luau`:

- A Model with PrimaryPart named `CompanionRoot`.
- A rig hierarchy containing Motor6D joints or skinned Bones. For Motor6D rigs, every BasePart must be connected to the root.
- An `AnimationController` containing an `Animator`.
- An `Animations` folder containing Animation objects named `Idle_Breathing`, `Walk_Cycle`, and `Alert_Acknowledge`, each with a valid Roblox animation asset ID.
- No Script, LocalScript or ModuleScript descendants.
- The server disables collision, touch and query on every imported BasePart. The imported actor remains visual-only.

The server loads the three clips, starts idle, switches between idle and walk using the owner's horizontal movement, and plays the one-shot acknowledgement clip after an accepted Ember command. The existing 15 Hz server follow update remains bounded. Missing or invalid imported assets fail closed to the current low-poly placeholder; the client cannot supply an asset or animation ID.

### Existing private technical prototype inspected on 12 November 2026

A private Blendstra project named **BTV Roblox — Ember Technical Rig Prototype** was inspected read-only:

- [Open exact prototype version](https://blendstra.com/studio?workspace=wsp_eb50fef55b992e1938b3c1c3483498a40f6f06c8&project=b0f678ff-c3cf-4848-bc69-071153712baf&version=version_98dd979755d97fdfa22a037c7d92588e6cb77172fdb087b085b4271e13509adf)
- Source contains a 14-bone armature and 30 separately named mesh parts.
- Blender source defines `Idle_Breathing`, `Walk_Cycle`, and `Alert_Acknowledge` actions (24 frames per action).
- The saved web preview reports one `Scene` animation clip of 3 seconds. Separate clip export and Roblox animation asset mapping are therefore **not verified**.
- The prototype follows the current placeholder palette and is explicitly not an approved final Ember likeness. Exact appearance remains open; no Afterfall asset is reused.

This prototype is not yet in the Git repository, Roblox ServerStorage, or a Roblox place. It does not satisfy the import contract until it is exported, imported and wrapped with the required Roblox root/controller/Animation objects. No Studio import or runtime animation test has been performed.

### Integration status

- [x] Server-side import contract and fail-closed placeholder fallback implemented.
- [x] Server-side idle/walk/acknowledgement animation routing implemented for a valid imported rig.
- [x] Accepted Ember commands trigger presentation acknowledgement only.
- [ ] Prototype GLB exported and imported into Roblox Studio.
- [ ] Three Roblox animation IDs created and mapped to the contract names.
- [ ] Studio validation of the imported rig, animation playback, respawn and multiple players.
- [ ] Android performance and visual review.
