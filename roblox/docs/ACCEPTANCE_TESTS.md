# BTV Roblox Foundation — Acceptance Tests

**Status:** Test plan authored; tests not yet executed in Roblox Studio.

## A. Source and project mapping

- [ ] Rojo project JSON parses.
- [ ] Shared source maps to ReplicatedStorage/BTVShared.
- [ ] Server source maps to ServerScriptService/BTVServer.
- [ ] Client source maps to StarterPlayerScripts/BTVClient.
- [ ] No Roblox files overwrite root Godot files.
- [ ] No credentials, private keys or tokens exist in source.
- [ ] CompanionCatalog is available from the shared mapping.

## B. Server authority

- [ ] Server creates the remote folder and remotes.
- [ ] Client cannot create or award Aces.
- [ ] Client cannot create or award Covenant Credits.
- [ ] Client cannot mark a mission complete.
- [ ] Server rejects malformed Ember command payloads.
- [ ] Server rejects commands outside the exact allowlist.
- [ ] Server throttles repeated command requests.
- [ ] Server returns only the requesting player's session snapshot.
- [ ] Companion selection requests are validated against server-owned session state.
- [ ] Initial selectable companions are Ember, Fox, Owl and Horse only.
- [ ] Eagle, Bear, Leopard and Falcon cannot be equipped without a future approved server-verified entitlement path.
- [ ] Client cannot claim a premium entitlement by changing local UI state.
- [ ] Malformed, unknown and unowned companion IDs are rejected.
- [ ] Companion selection requests are throttled per player.
- [ ] Malformed and unowned command/selection requests are rate-limited before payload and ownership validation; repeated invalid requests cannot bypass per-player throttles.
- [ ] Ember imported rig is loaded only from ServerStorage and cannot be supplied by the client.
- [ ] Invalid rig hierarchy, disconnected Motor6D parts, missing animation IDs or executable scripts cause safe placeholder fallback.
- [ ] A selection updates only the requesting player's state snapshot.

## C. Companion roster and fairness

- [ ] Catalog contains Ember, Eagle, Fox, Bear, Owl, Leopard, Horse and Falcon.
- [ ] Every premium-candidate role has a free functional equivalent.
- [ ] No premium animal reveals exclusive evidence, hidden objectives or entities through cover.
- [ ] No premium animal grants damage, health, armour, speed, stealth, detection or reward advantages.
- [ ] Ember's seven core commands remain available without a purchase.
- [ ] Ember Bond Pack contains presentation/bonding features only.
- [ ] No product IDs, prices or purchase prompts are active without creator approval.
- [ ] Horse mounting is not advertised until its separate movement and multiplayer tests pass.

## D. Canon

- [ ] Original main-game continuity retains Asher Vance as its central protagonist.
- [ ] Each Roblox player has their own player-character identity and is recognised as a Chosen within the Roblox Covenant adaptation.
- [ ] Roblox player identity is not initialised as `asher_vance`.
- [ ] Roblox players begin at Recruit unless a reviewed progression/profile migration specifies otherwise.
- [ ] All fifteen approved Covenant ranks are represented consistently.
- [ ] Persistent player rank is separate from current-server team assignment and leadership.
- [ ] Two players can have different ranks and interact as superior, subordinate or teammate according to server assignments.
- [ ] Covenant NPCs and ordinary world NPCs coexist with player members.
- [ ] Optional chat uses Roblox TextChatService moderation/filtering and does not require chat to complete missions.
- [ ] Asher and Ember premium presentation grants no rank, authority, mission, combat, detection or reward advantage.
- [ ] Ember commands match the official list exactly.
- [ ] No spiritual score, faith currency, prayer points or divine-favour meter exists.
- [ ] Communion does not change health, stats, XP, equipment or currency.
- [ ] Church remains distinct from Covenant.
- [ ] HCI is not presented as an in-game real organisation.
- [ ] Unresolved lore is not filled with invented explanations.

## E. Mobile UI

- [ ] HUD fits common phone aspect ratios.
- [ ] Touch targets are comfortably tappable.
- [ ] Command panel opens and closes.
- [ ] All seven official Ember commands can be requested.
- [ ] UI remains readable at reduced screen size.
- [ ] Safe areas and notches do not obscure controls.
- [ ] UI does not require hover or keyboard.
- [ ] On touch-enabled devices, companion controls are positioned away from the default left-thumb movement and right-thumb action zones.
- [ ] Companion selection and command panels remain within the visible phone viewport at narrow widths.

## F. Environment visual prototype

- [ ] Logos Rhema Temple prototype builds without runtime errors.
- [ ] Foyer and sanctuary entrances remain clear and traversable.
- [ ] Seating, lectern, platform and Communion table have believable scale and collision.
- [ ] Cross and church signage remain restrained and contextually appropriate.
- [ ] No HCI real-world likeness, invented church leader, service order, or Covenant insignia appears.
- [ ] Communion remains environmental context only; no buff, reward, currency or interaction is introduced.
- [ ] Scene is visually reviewed against the approved BTV church and visual references.
- [ ] Low/mid-range Android frame rate and memory are measured before increasing detail.
- [ ] Asher and Ember reference assets are used before final character/companion models are approved.

## F1. Ember follower visual prototype

- [ ] Ember appears for a player whose equipped companion is Ember.
- [ ] Ember follows at a stable trailing offset without obstructing the player.
- [ ] Ember remains available after character respawn.
- [ ] Selecting another owned companion removes the Ember actor; selecting Ember again restores it.
- [ ] Actor cleanup occurs when the player leaves.
- [ ] The model has no collision, touch, or query interactions.
- [ ] The current low-poly appearance is clearly treated as a placeholder.
- [ ] A valid imported Ember rig loads Idle_Breathing, Walk_Cycle and Alert_Acknowledge from the shared contract.
- [ ] Idle/walk transitions follow only the owner's horizontal movement; accepted Ember commands play acknowledgement presentation only.
- [ ] Imported animation playback changes no damage, health, speed, detection, evidence, rewards or mission outcomes.
- [ ] No combat, detection, evidence, reward, speed or mission advantage is granted.
- [ ] Multiple players receive separate companion actors without shared ownership or position.

## F2. Ridgeview landscape study

- [ ] Ridgeview landscape study builds without runtime errors.
- [ ] Ridgeview remains spatially separate from the Temple prototype.
- [ ] Ridgeview arrival marker is aligned with the footpath start and has no collision, touch or query behaviour.
- [ ] The Ridgeview departure interaction has a visible wayfinding sign and remains discoverable from the intended temple route.
- [ ] The HUD directs players toward the Ridgeview travel marker after Scout Report access.
- [ ] Road, path, stream, hill forms, trees and lookout are inspected for alignment and collision.
- [ ] The lookout is reachable from the footpath without unintended jumps or gaps.
- [ ] No named residents, mission clues, evidence, settlement history or canon facts are introduced.
- [ ] The scene is profiled on a low/mid-range Android device before additional detail is added.

## G. Opening vertical slice interactions

- [ ] Mission state is created and removed server-side per player.
- [ ] Initial objective is the passive Communion context followed by sanctuary entry; Communion itself grants no interaction reward or gameplay effect.
- [ ] Sanctuary entry advances only the interacting player's mission state.
- [ ] Scout Report prompt is accepted only during the Covenant-alert phase and within server-checked range.
- [ ] Ridgeview departure is accepted only after report access and within server-checked range.
- [ ] Ridgeview arrival places the player on the provisional footpath without spawning inside terrain or props.
- [ ] A player who respawns after Ridgeview arrival is restored to the Ridgeview marker while their session mission phase remains server-owned.
- [ ] A player who has not reached Ridgeview continues to respawn at the Temple's initial spawn.
- [ ] Ridgeview arrival advances only the interacting player's mission state and updates only that player's HUD.
- [ ] Out-of-order, repeated, remote, and malformed interaction attempts cannot advance mission state.
- [ ] Mission objective HUD updates only from server-confirmed state.
- [ ] Scout Report viewer opens after server-confirmed report access, can be closed and reopened, and explicitly shows authored evidence is pending.
- [ ] No fabricated clues, NPC dialogue, rewards or mission outcomes are presented.
- [ ] No spiritual score, faith currency, Communion buff, or automatic mission reward is created.

## H. Multiplayer

- [ ] Two clients can join one test server.
- [ ] Each client receives only its own initial state snapshot.
- [ ] One player's command does not overwrite another player's session state.
- [ ] Server is authoritative for accepted commands.
- [ ] Disconnect cleanup removes transient session state.
- [ ] No unreviewed persistent profile schema is written.
- [ ] Different selected companions can coexist without mission dependency or unfair advantage.

## I. Performance

- [ ] Profile on a low/mid-range Android device.
- [ ] Measure frame rate and memory rather than guessing.
- [ ] Inspect streaming behaviour in a region larger than the initial play area.
- [ ] Check transparent effects, dynamic shadows and particle overdraw.
- [ ] Establish separate mobile/standard/high visual quality profiles.

## Companion selection implementation notes

- Selection is session-only; reconnecting resets the equipped companion to Ember.
- The client menu is populated from the server-provided ownership snapshot.
- The server independently checks the catalog ID and ownership on every request; client UI visibility is not authoritative.
- No premium purchase prompt, product ID, entitlement grant endpoint or persistent ownership schema exists.

## Automated source checks

- [x] Lune foundation, companion ownership and Ember rig-contract regression suite passes in CI (Run #84).
- [x] Companion ownership policy rejects malformed/unknown IDs and premium candidates, including forged ownership-map entries (Run #84).
- [x] Default ownership contains only Ember, Fox, Owl and Horse; per-session ownership maps are independent (Run #84).
- [x] Ember rig contract verifies the required import path, root name and three presentation clip names (Run #84).
- [x] StyLua formatting check passes in CI (Run #84).
- [x] Selene lint passes with 0 errors, 0 warnings and 0 parse errors (Run #84).
- [x] Rojo place build succeeds in CI; `btv-roblox-place` artifact uploaded (Run #84).

## Current verification state

- Repository source files: PRESENT on `btv/roblox-foundation-001`.
- Headless Luau mission, roster, ownership and Ember rig-contract regression suite: PASS in GitHub Actions Run #84.
- Ownership policy: PASS for default free access, unknown/malformed rejection, premium fail-closed behaviour and per-session map isolation (Run #84).
- Ember rig contract: PASS for the expected server asset path, root part name and three presentation clip names (Run #84).
- StyLua formatting: PASS in GitHub Actions Run #84.
- Selene lint: PASS, 0 errors / 0 warnings / 0 parse errors, Run #84.
- Rojo project build: PASS; artifact uploaded in Run #84.
- Companion selection runtime and exploit-resistance tests: NOT RUN.
- Roblox Studio import and play test: NOT RUN.
- Logos Rhema Temple scene execution: NOT RUN.
- Ridgeview landscape study execution: NOT RUN.
- Ember follower runtime and multiplayer tests: NOT RUN.
- Imported Ember model validation and animation playback in Roblox Studio: NOT RUN.
- Multiplayer test: NOT RUN.
- Android device test: NOT RUN.

## J. Curiosity Archive — optional exploration feature

- [ ] Three Curio Marks are placed in the Ridgeview landscape and are discoverable without purchases.
- [ ] Server validates proximity and allowlisted mark IDs before recording discoveries.
- [ ] Duplicate, unknown and malformed mark requests cannot increase progress.
- [ ] Discovery progress is isolated per player and cleared on disconnect until persistence is reviewed.
- [ ] All three marks are required to enter the Archive.
- [ ] The locked wall remains physically closed; access is granted by server-checked per-player teleport, not a global door unlock.
- [ ] Players without all three marks cannot enter by invoking client-side state or changing local UI.
- [ ] Archive progress HUD appears only after a discovery and fits phone safe areas.
- [ ] Weekly display rotates by UTC week; no reward expires and older displays are not permanently removed.
- [ ] Easter eggs are optional developer/environment references, not canon revelations, mission evidence, Scripture items or sacred artifacts.
- [ ] Archive contains no Aces, Covenant Credits, XP, loot, paid random rewards or gameplay advantages.
- [ ] Two-player test confirms one player's discoveries do not unlock the other player's Archive.
- [ ] Roblox Studio and Android runtime checks are completed before the feature is called playable.

## K. Asher and Ember Signature Presentation

- [ ] Asher remains the sole playable protagonist and is available to every player.
- [ ] Asher's approved face, apparent age, hairstyle, proportions and Covenant identity match the visual references.
- [ ] Asher's Signature wardrobe preserves the established Covenant visual language.
- [ ] Asher's Signature animations do not change movement, combat, stamina or interaction timings.
- [ ] Ember's model preserves the approved original natural canid identity and reference silhouette.
- [ ] Ember has no fantasy wings, demonic anatomy, cybernetic body, angelic transformation or human speech.
- [ ] Ember's Signature accessories and effects do not imply new abilities or reveal hidden information.
- [ ] Ember's command animations do not change command execution time or results.
- [ ] Core Asher and Ember models are complete and are not deliberately degraded to sell cosmetics.
- [ ] Signature and Legacy items are fully previewable with exact contents disclosed.
- [ ] No randomised paid rewards, artificial scarcity, countdown pressure or expiring cosmetics are used.
- [ ] No purchase IDs, prices, prompts or entitlement grants exist without separate creator approval.
- [ ] Signature models pass close, gameplay-distance and far-distance mobile visual review.
- [ ] Asher and Ember assets pass Roblox Studio, multi-client and low/mid-range Android checks before release.
