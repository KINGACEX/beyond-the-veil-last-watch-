# BTV Roblox Edition

**Foundation:** v0.2 in progress  
**Product:** Beyond the Veil: The Last Watch — Roblox Edition  
**Engine:** Roblox  
**Language:** Luau  
**Target:** Android-first play experience; multiplayer architecture  
**Status:** Foundation source and companion catalog committed; not yet imported into Roblox Studio or runtime-tested.

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
- data-driven eight-animal companion catalog with roles, personalities, signature support behaviours and free-equivalent boundaries.

The companion catalog is descriptive configuration only. It does not yet implement ownership, selection, companion models, AI, animations or purchases. Ember's seven core commands remain available as core functionality; the optional Ember Bond Pack is a presentation/bonding offer only. No product IDs or prices are defined.

Not implemented:
- world geometry, Asher character model, companion models/AI, companion selection, combat, missions, persistence, economy values, monetisation, or published Roblox place.

## Tooling

The project is prepared for Rojo-based source mapping. Rojo sync/build and Roblox Studio editing require Windows or macOS. Android can edit and version the source and documentation, but cannot run the full Roblox Studio editor.

## Safety and release policy

No paid assets, paid APIs, paid credits, public release, monetisation, destructive repository changes, or merges are part of this foundation. Keep changes on the Roblox feature branch until reviewed and approved.
