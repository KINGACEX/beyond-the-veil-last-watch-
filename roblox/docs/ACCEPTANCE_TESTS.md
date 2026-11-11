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

- [ ] Only Asher Vance is represented as the playable protagonist.
- [ ] Asher's fixed identity and starting role are not replaced by a character-selection system.
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

## G. Opening vertical slice interactions

- [ ] Mission state is created and removed server-side per player.
- [ ] Initial objective is the passive Communion context followed by sanctuary entry; Communion itself grants no interaction reward or gameplay effect.
- [ ] Sanctuary entry advances only the interacting player's mission state.
- [ ] Scout Report prompt is accepted only during the Covenant-alert phase and within server-checked range.
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

## Current verification state

- Repository source files: PRESENT on `btv/roblox-foundation-001`.
- Luau syntax/type check: NOT RUN.
- Companion selection runtime and exploit-resistance tests: NOT RUN.
- Opening mission state and interaction tests: NOT RUN.
- Rojo project validation: NOT RUN.
- Roblox Studio import: NOT RUN.
- Logos Rhema Temple scene execution: NOT RUN.
- Multiplayer test: NOT RUN.
- Android device test: NOT RUN.
