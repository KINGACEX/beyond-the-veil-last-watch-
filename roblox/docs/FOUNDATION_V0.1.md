# BTV Roblox Foundation v0.1

**Status:** Approved foundation direction; implementation source drafted.  
**Visual direction:** Realistic/cinematic, quality-scaled for mobile.  
**Gameplay architecture:** Multiplayer from the beginning; solo-friendly session design.  
**Primary authoring device:** Android.  
**Runtime/editor:** Roblox Studio (Windows/macOS required).

## 1. Product intent

Create a separate Roblox adaptation of BTV as a multiplayer, story-led action-adventure experience. The Roblox edition must preserve BTV's modern Christian worldview, human community focus, story boundaries and established visual identity. It is not a replacement for the standalone Godot edition.

## 2. First vertical-slice target

Respect the currently established slice sequence:
1. Asher's first-Sunday Communion context at Logos Rhema Temple.
2. A Covenant alert.
3. Scout Report and evidence review.
4. Journey to Ridgeview.
5. Investigation and context-sensitive response.
6. Final report.

Do not replace this authored opening with a generic combat tutorial or a Covenant-base opening. A Covenant facility may appear later if supported by the authored slice and canon.

The first technical prototype should prove:
- multiplayer server/client lifecycle;
- Asher as the fixed playable protagonist;
- mobile-friendly movement/camera/HUD;
- a first authored location with readable navigation;
- a basic interaction/dialogue flow;
- Ember command request validation (visual/AI behaviour can follow later);
- a mission-state flow that does not award spiritual scores.

## 3. Multiplayer model

Use Roblox's standard client/server model.

**Client responsibilities**
- input collection and touch controls;
- camera and local presentation;
- HUD, menus, accessibility settings;
- sending intent requests to the server;
- rendering server-confirmed state.

**Server responsibilities**
- authoritative player/session state;
- mission state transitions;
- inventory and currency changes;
- interaction eligibility and distance checks;
- NPC/world state;
- Ember command validation and AI authority;
- persistence when a reviewed schema is ready.

Never accept client claims that a mission is complete, a reward is earned, a currency balance should change, or an NPC has been defeated.

## 4. Proposed Roblox service layout

- ReplicatedStorage/BTVShared: shared configuration and type/contract modules.
- ReplicatedStorage/BTVRemotes: server-created remotes only.
- ServerScriptService/BTVServer: server bootstrap and services.
- StarterPlayer/StarterPlayerScripts/BTVClient: client bootstrap and controllers.
- Workspace/World: authored environment, loaded in bounded regions.
- ServerStorage/PrivateAssets: server-only assets when needed.

The Rojo mapping is in `default.project.json`.

## 5. Service boundaries

| Service | Responsibility | Authority |
|---|---|---|
| PlayerStateService | In-memory session snapshot | Server |
| CurrencyService | Validate server-originated balance changes | Server |
| MissionService (future) | Mission transitions/objectives | Server |
| InteractionService (future) | Range, context and eligibility checks | Server |
| EmberService (future) | Companion state/commands/AI | Server |
| PersistenceService (future) | Profile schema and safe DataStore lifecycle | Server |
| MobileHUDController | Touch-first interface | Client |
| CameraController (future) | Camera presentation | Client |

## 6. Session state and persistence

v0.1 uses in-memory session state only. Player state is discarded when the player leaves or the server closes. This is deliberate: do not persist an unreviewed schema or claim persistence is implemented.

Before DataStore integration, define:
- schema version;
- default profile;
- retry/backoff and failure handling;
- autosave cadence and shutdown flush;
- session-locking strategy;
- migration and corruption policy;
- data minimisation and privacy review.

## 7. Realistic visual direction

The visual target is grounded modern realism with cinematic composition, believable materials, controlled lighting, environmental storytelling and consistent character presentation.

Use a scalable quality ladder:
- **Mobile baseline:** readable silhouettes, restrained post-processing, efficient meshes/materials, baked or inexpensive environmental detail where appropriate, limited dynamic shadows, conservative particle counts.
- **Standard:** richer materials, denser vegetation, more local lighting and environmental effects.
- **High quality:** additional detail and effects only where device performance permits.

Use PBR/material variation and authored meshes where they materially improve the scene. Avoid excessive tiny geometry, transparent overdraw, many simultaneous dynamic lights, and unbounded particle systems. Use instance streaming and region-based content where appropriate after profiling.

Do not casually redesign Asher, Ember, Covenant insignia/uniforms, HUD identity, currencies or locked visual references. The existing visual consistency-lock document remains authoritative. No final 3D asset is included in v0.1.

## 8. Mobile experience

- touch-first controls with large, well-spaced targets;
- camera sensitivity and control options;
- UI safe-area awareness;
- avoid text smaller than comfortable phone reading size;
- no critical action dependent on hover or keyboard;
- scalable UI using relative sizing and constraints;
- test on a low/mid-range Android device before raising visual budgets;
- keep gameplay readable at common phone aspect ratios.

## 9. Canon guardrails

- Asher Vance is the sole playable protagonist and the Chosen; age 18; human, never divine.
- Asher begins as an Agent/Specialist in the Watcher branch.
- Covenant ranks: Recruit → Agent/Specialist → Team Leader → Commander → General.
- Branches: Guardians, Messengers, Watchers, Shepherds, Scouts, Keepers.
- Ember is an intelligent animal companion and field partner, not a weapon or omniscient guide.
- Official Ember commands: Attack, Protect, Scout, Track, Retrieve, Hold, Regroup.
- Aces and Covenant Credits remain distinct.
- Faith, salvation, prayer, divine favour, spiritual worth and the Holy Spirit are never currencies, scores, loot, unlock currencies or purchasable power.
- Prayer is not a guaranteed transaction or combat spell.
- The Holy Spirit is not a controllable scanner, attack resource or certainty engine.
- Logos Rhema Temple is the fictional church. HCI is real-world inspiration only and does not appear under its real name.
- Church and Covenant remain distinct. Church members do not automatically know Asher's Covenant affiliation.
- Communion is contextual and has no gameplay buff.
- No universal morality/conversion meter.
- Unknown lore remains UNKNOWN; proposals remain PROPOSED.
- Combat and advanced Ember behaviour remain behind design review gates.

## 10. Scope exclusions

Not in v0.1:
- combat implementation;
- monetisation, paid items, Robux purchases or paid asset packs;
- premium progression or pay-to-win systems;
- detailed economy prices or reward tables;
- invented Ember species/origin;
- unapproved character customisation;
- final story dialogue beyond approved source material;
- public release or advertising;
- Godot project edits.

## 11. Definition of done

Foundation v0.1 is complete when:
- source tree and Rojo mapping exist;
- shared configuration is explicit;
- server owns state and currency authority;
- client cannot directly award currency or complete missions;
- Ember command requests are allowlisted and throttled;
- mobile HUD source exists;
- canon and Android workflow docs exist;
- acceptance tests are documented;
- all untested runtime/editor claims remain marked unverified.
