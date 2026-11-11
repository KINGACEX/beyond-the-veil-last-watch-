# BTV Roblox — Opening Vertical Slice

**Status:** Source implementation committed; Roblox Studio runtime verification pending.  
**Scope:** First interactive loop at Logos Rhema Temple.  
**Authority:** Subordinate to the BTV Master Canon, Mission Bible, Character Bible, Church Bible and Visual/UI/HUD Bible.

## Implemented flow

1. **First-Sunday Communion context** — passive narrative context only. No Communion interaction, buff, reward, currency or spiritual score.
2. **Enter the sanctuary** — server-validated proximity interaction advances the player's own opening state.
3. **Covenant alert** — represented as the next approved opening-sequence state.
4. **Open Scout Report** — server-validated proximity interaction at the foyer desk advances the player to the report-access state.
5. **Evidence review** — UI currently states that authored evidence is pending. No evidence, named NPC, dialogue, suspect, threat, confidence score or outcome is invented.
6. **Travel to Ridgeview** — after report access, a server-validated departure prompt moves the player to the provisional Ridgeview footpath and advances the session to the Ridgeview-arrival phase. The report panel closes on arrival; its reopen control remains available.

The next approved sequence stages—journey to Ridgeview, investigation/response and final report—remain visible in the source-of-truth opening sequence but are not falsely marked implemented here.

## Technical architecture

- `MissionService.luau` owns per-player, in-memory mission state.
- `OpeningMission.server.luau` creates sanctuary-entry, Scout Report and gated Ridgeview-departure prompts; it validates interaction distance and travel phase server-side.
- `Bootstrap.server.luau` owns mission session lifecycle and read-only snapshot retrieval.
- `Bootstrap.client.luau` receives mission state through server-created remotes.
- `MobileHUDController.luau` renders the current sequence index, objective and status from server-confirmed snapshots, plus a Scout Report viewer that explicitly shows the absence of authored intelligence.

No client remote can directly set a mission phase or award rewards.

## Deliberate limitations

- Mission state is session-only and resets on reconnect.
- Ridgeview is a same-place scene transition within the provisional landscape study, not a separate server or streamed place.
- The Scout Report has no authored evidence payload yet.
- There is no combat, enemy, NPC, dialogue, reward, currency or save system in this slice.
- Ridgeview's exact environment and mission evidence remain unimplemented pending approved authored content and world references.
- No final Asher or Ember model is included.

## Required Studio validation

1. Import `roblox/default.project.json` through Rojo.
2. Run a two-player Studio server.
3. Confirm both players start at phase 1 independently.
4. Confirm entering the sanctuary changes only the interacting player's phase.
5. Confirm Scout Report activation is rejected until the Covenant-alert phase.
6. Confirm the report-access state updates only the interacting player's HUD.
7. Attempt repeated and out-of-range prompt activation.
8. Confirm no currency or spiritual-stat changes occur.
9. Profile the scene and UI on an Android device.

## Current verification

- Repository implementation and read-back: VERIFIED.
- Luau type/syntax check: NOT RUN.
- Rojo build: NOT RUN.
- Roblox Studio play test: NOT RUN.
- Two-player server test: NOT RUN.
- Android test: NOT RUN.
