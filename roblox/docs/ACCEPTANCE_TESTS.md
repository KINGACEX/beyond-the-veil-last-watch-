# BTV Roblox Foundation — Acceptance Tests

**Status:** Test plan authored; tests not yet executed in Roblox Studio.

## A. Source and project mapping

- [ ] Rojo project JSON parses.
- [ ] Shared source maps to ReplicatedStorage/BTVShared.
- [ ] Server source maps to ServerScriptService/BTVServer.
- [ ] Client source maps to StarterPlayerScripts/BTVClient.
- [ ] No Roblox files overwrite root Godot files.
- [ ] No credentials, private keys or tokens exist in source.

## B. Server authority

- [ ] Server creates the remote folder and remotes.
- [ ] Client cannot create or award Aces.
- [ ] Client cannot create or award Covenant Credits.
- [ ] Client cannot mark a mission complete.
- [ ] Server rejects malformed Ember command payloads.
- [ ] Server rejects commands outside the exact allowlist.
- [ ] Server throttles repeated command requests.
- [ ] Server returns only the requesting player's session snapshot.

## C. Canon

- [ ] Only Asher Vance is represented as the playable protagonist.
- [ ] Asher's fixed identity and starting role are not replaced by a character-selection system.
- [ ] Ember commands match the official list exactly.
- [ ] No spiritual score, faith currency, prayer points or divine-favour meter exists.
- [ ] Communion does not change health, stats, XP, equipment or currency.
- [ ] Church remains distinct from Covenant.
- [ ] HCI is not presented as an in-game real organisation.
- [ ] Unresolved lore is not filled with invented explanations.

## D. Mobile UI

- [ ] HUD fits common phone aspect ratios.
- [ ] Touch targets are comfortably tappable.
- [ ] Command panel opens and closes.
- [ ] All seven official Ember commands can be requested.
- [ ] UI remains readable at reduced screen size.
- [ ] Safe areas and notches do not obscure controls.
- [ ] UI does not require hover or keyboard.

## E. Multiplayer

- [ ] Two clients can join one test server.
- [ ] Each client receives only its own initial state snapshot.
- [ ] One player's command does not overwrite another player's session state.
- [ ] Server is authoritative for accepted commands.
- [ ] Disconnect cleanup removes transient session state.
- [ ] No unreviewed persistent profile schema is written.

## F. Performance

- [ ] Profile on a low/mid-range Android device.
- [ ] Measure frame rate and memory rather than guessing.
- [ ] Inspect streaming behaviour in a region larger than the initial play area.
- [ ] Check transparent effects, dynamic shadows and particle overdraw.
- [ ] Establish separate mobile/standard/high visual quality profiles.

## Current verification state

- Repository source files: pending commit verification.
- Luau syntax/type check: NOT RUN.
- Rojo project validation: NOT RUN.
- Roblox Studio import: NOT RUN.
- Multiplayer test: NOT RUN.
- Android device test: NOT RUN.
