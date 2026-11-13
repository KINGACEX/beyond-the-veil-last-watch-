# BTV Roblox — Settlement Playable Increment 001

**Branch:** `btv/roblox-settlement-playable-001`  
**Status:** Source implementation committed; automated CI and Roblox Studio verification pending.  
**Scope:** Ridgeview settlement blockout, adult NPC placeholders, authored conversations, and Wren disclosure consent.

## Implemented in source

- A small settlement blockout is generated beside the existing Ridgeview approach using reusable house, public-square, path, sign and lighting helpers.
- Wren, Dorian Pike and two unnamed adult resident blockouts are created as temporary stylised figures.
- The NPC blockouts follow short waypoint loops. This is placeholder movement, not skeletal animation.
- NPC interactions use server-created ProximityPrompts, supporting the normal Roblox interaction affordances on touch and desktop.
- A responsive client dialogue panel displays only server-authored dialogue and choices.
- Existing approved Ridgeview dialogue-pack lines are used for Wren's initial account, Pike's first contact, Pike's Wren-account challenge and resident observations.
- Wren's testimony is session-only. Recording it does not grant permission to disclose it.
- Wren must explicitly authorize sharing of the specific observation before the Pike testimony-challenge branch becomes available.
- The server validates interaction distance, mission phase, action type and per-player action timing. Clients cannot directly set testimony, consent or Pike-admission state.
- A pure policy module and Lune regression test cover the disclosure gate.

## Consent boundary

The permission wording — “You may tell Pike only that I saw the repairman go toward the camp. Please don't share anything else.” — is a prototype consent line derived from Wren's established knowledge boundary. It is deliberately narrow and does not disclose her other statements or imply knowledge of the repairman's fate. Treat this exact line as **PROTOTYPE WORDING** pending final dialogue review.

A private choice records Wren's testimony for the player's session while keeping it unavailable to Pike. An explicit permission choice records the testimony and authorizes only the stated observation. Pike's testimony-challenge branch is server-locked unless both conditions are true.

## Verification

- Source files: committed to this feature branch.
- Lune policy test: added to `.github/workflows/roblox-validation.yml`; result pending.
- StyLua and Selene: configured in CI; result pending.
- Rojo place build: configured in CI; result pending.
- Roblox Studio import / Play Solo: not run.
- Two-player server test: not run.
- Android touch/device test: not run.
- PC keyboard/mouse test: not run.

A passing Lune test or Rojo build does not prove the settlement renders correctly or that the dialogue works in Roblox Studio.

## Known limitations

- The NPCs are anchored part-based blockouts with scripted waypoint movement. They have no Humanoid rigs, facial animation, skeletal animation, final clothing, voice or audio.
- The player still uses Roblox's normal player character. The existing Roblox adaptation identifies each multiplayer player as their own Chosen, not as Asher Vance. Do not silently replace that multiplayer identity contract; a custom Asher-only player character requires an explicit adaptation decision.
- Ember remains the existing low-poly placeholder actor. Full companion navigation, natural movement, commands and final rig integration are not completed by this increment.
- The settlement is a first layout pass and has not been visually reviewed in Studio.
- Wren testimony and Pike's admission are session-only and are not yet integrated into the existing Ridgeview Field Notes journal or persistent player profile.
- The existing Ridgeview field-note loop remains separate and unchanged.
- No combat, enemy AI, final evidence board, final report or persistent save/load flow is added here.

## Studio acceptance checklist

1. Import `roblox/default.project.json` with Rojo into a new private test place.
2. Confirm the settlement is generated once and is reachable from the Ridgeview arrival path.
3. Confirm all four NPC blockouts appear, move between their waypoints and remain interactable.
4. Complete Wren's conversation and choose **Keep this testimony private**. Confirm Pike's Wren-account option does not appear.
5. Re-enter Wren's conversation, request permission, confirm the explicit permission, and verify the UI reports the limited sharing scope.
6. Speak with Pike and verify the Wren-account branch appears only after both recording and explicit permission.
7. Test out-of-range prompt/action attempts and confirm no state is changed.
8. Join a second test client and verify each player's testimony and permission state are isolated.
9. Test the dialogue panel at phone and desktop viewport sizes.
10. Record Studio output, screenshots, device details and any errors before marking runtime validation complete.
