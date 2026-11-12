# BTV Roblox Edition

**Foundation:** v0.2 in progress  
**Product:** Beyond the Veil: The Last Watch — Roblox Edition  
**Engine:** Roblox  
**Language:** Luau  
**Target:** Android-first play experience; multiplayer architecture  
**Status:** Roblox source foundation and validation workflow configured; not yet imported into Roblox Studio or runtime-tested.

## Separation rule

This is a sibling product track inside the BTV repository. All Roblox-specific files live under `roblox/`. Do not edit, replace, rename, or migrate the Godot project as part of Roblox work. The Godot project remains at the repository root and continues on its own branch/workstream.

## Canon authority

Use the existing BTV source-of-truth documents under `../docs/source-of-truth/`. In particular:

- `canon/BTV_Master_Canon_v1.0.md`
- `canon/BTV_Canon_Reconciliation_and_Story_Veil_Decisions_v1.1.md`
- `characters/BTV_Character_Bible_v1.0.md`
- `faith/BTV_Faith_Prayer_Armor_of_God_Bible_v1.0.md`
- `church/BTV_Church_HCI_Service_Communion_Bible_v1.0.md`
- `missions/BTV_Mission_Progression_Economy_Bible_v1.0.md`
- `visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.1_Consistency_Lock.md`

The Roblox adaptation document records implementation boundaries; it does not supersede those references.

## Source layout

- `default.project.json` — Rojo mapping for Studio DataModel services.
- `src/shared` — shared immutable configuration and contracts.
- `src/server` — server-authoritative gameplay modules.
- `src/client` — presentation and touch-first controls.
- `docs` — adaptation, architecture, Android workflow and acceptance criteria.

## Current foundation

Implemented as source files:
- shared BTV identity, protagonist, rank, branch, currency names and Ember command definitions;
- server-side in-memory session state;
- server-side currency award boundary (no client award endpoint);
- validated Ember command requests with a basic per-player request throttle;
- initial client HUD and command panel;
- data-driven eight-animal companion catalog with roles, personalities, signature support behaviours and free-equivalent boundaries;
- server-authoritative, session-only companion selection with fail-closed premium-candidate ownership checks and per-player ownership-map isolation;
- an Ember rig import contract and server-side animation adapter that safely falls back to the existing placeholder until a reviewed Roblox asset and animation IDs are imported;
- server-authoritative, session-only companion selection with a touch selector populated from the server-owned companion list. Initial access is Ember, Fox, Owl and Horse; a fail-closed server policy rejects unknown/malformed IDs and blocks all four premium candidates even if a session ownership map is incorrectly marked true;
- a server-generated Logos Rhema Temple environment visual prototype with sanctuary, foyer, seating, lighting and exterior approach. This is a proposed layout, not canon-locked or Studio-verified;
- a separate Ridgeview landscape study with layered ridges, woodland, road, footpath, stream and lookout. This is proposed geography only and is not canon-locked or Studio-verified;
- a pinned Roblox toolchain and GitHub Actions validation workflow for headless Luau tests, formatting, lint and Rojo place builds (latest confirmed Run #43 passed on 2026-11-12);
- a server-owned opening-sequence state machine with sanctuary-entry and Scout Report interactions, a live objective HUD and a report viewer that clearly marks mission intelligence as pending. No report evidence is fabricated.

The Temple and Ridgeview environments, Ember follower and opening interactions are source implementations only; they have not been executed in Studio or profiled on Android. See `docs/LOGOS_RHEMA_TEMPLE_VISUAL_PROTOTYPE.md` and `docs/RIDGEVIEW_LANDSCAPE_STUDY.md` for scope and canon boundaries. GitHub Actions Run #43 passed the headless tests, formatting, lint and Rojo place build; this does not establish Roblox runtime playability.

The catalog covers all eight animals. Companion selection is server-authoritative and session-only; ownership is not persistent and premium entitlement verification is not implemented. Eagle, Bear, Leopard and Falcon remain unavailable candidates with no purchase path. The Ember rig import adapter and animation routing are implemented in source, but no 3D asset or Roblox animation IDs have been imported; the low-poly placeholder remains active. Companion AI is not implemented. Ember's seven core commands remain available as core functionality; the optional Ember Bond Pack is presentation/bonding only. No product IDs or prices are defined.

Not implemented:
- final world assets, Asher character model, companion models/AI, combat, completed authored missions, persistence, economy values, monetisation, or published Roblox place.

## Tooling

The pinned toolchain is defined in `rokit.toml`. GitHub Actions runs the foundation regression suite, StyLua formatting for the changed foundation scripts (with corrections committed on branch pushes), Selene and a Rojo build for changes under `roblox/`. It uploads a temporary `.rbxlx` artifact and does not publish to Roblox. See `docs/CI_AND_STUDIO_TESTING.md`.

The project is prepared for Rojo-based source mapping. Rojo sync/build and Roblox Studio editing require Windows or macOS. Android can edit and version the source and documentation, but cannot run the full Roblox Studio editor.

## Safety and release policy

No paid assets, paid APIs, paid credits, public release, monetisation, destructive repository changes, or merges are part of this foundation. Keep changes on the Roblox feature branch until reviewed and approved.
