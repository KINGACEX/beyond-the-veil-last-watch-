# BTV Roblox Edition

**Foundation:** v0.2 in progress  
**Product:** Beyond the Veil: The Last Watch — Roblox Edition  
**Engine:** Roblox  
**Language:** Luau  
**Target:** Cross-platform Roblox experience — Android/iOS touch, PC keyboard/mouse, and supported gamepads  
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
- `src/client` — responsive presentation and input-aware controls for touch, keyboard/mouse and supported gamepads.
- `docs` — adaptation, architecture, Android workflow, acceptance criteria, character-production briefs, and the economic/construction design contract (`ECONOMY_AND_CONSTRUCTION_FOUNDATION_V0.1.md`).

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
- a pinned Roblox toolchain and GitHub Actions validation workflow for headless Luau tests, formatting, lint and Rojo place builds (Run #84 passed on 2026-11-12 before the current fake-store test additions; the latest commits still require a fresh confirmed CI result);
- a test-only fake profile store plus an injectable profile persistence adapter with bounded transient retries, lease acquisition/release and ambiguous-save reconciliation; the adapter is not connected to live joins, and save serialization, proactive lease renewal and shutdown orchestration remain pending;
- a construction-supply item catalogue with stable IDs and stack caps, plus a pure bounded inventory policy with validation and add/remove transformations;
- profile schema v2 includes inventory, with a tested v1-to-v2 migration that preserves existing progression and balances;

- a proposed Asher and Ember Signature Presentation brief covering premium-quality models, animations, cosmetic tiers and a non-intrusive Showcase; no final models, purchase IDs or payment systems are implemented;
- an optional Curiosity Archive exploration feature with three server-tracked, session-only discoveries, a per-player locked entrance, a small progress HUD and a UTC-week rotating non-canon display; no currency, mission, evidence, combat or paid access effects. This source feature has not yet been Studio/runtime-tested.
- a server-owned opening-sequence state machine with sanctuary-entry and Scout Report interactions, a live objective HUD and a report viewer that clearly marks mission intelligence as pending. No report evidence is fabricated.

The Temple and Ridgeview environments, Ember follower and opening interactions are source implementations only; they have not been executed in Studio or profiled on Android. See `docs/LOGOS_RHEMA_TEMPLE_VISUAL_PROTOTYPE.md`, `docs/RIDGEVIEW_LANDSCAPE_STUDY.md` and `docs/SIGNATURE_CHARACTER_PRESENTATION_V0.1.md` for scope and canon boundaries. GitHub Actions Run #171 for commit `93acef9` passed the headless regression suite, StyLua, Selene, Rojo build and artifact upload, including profile schema v3, inventory, idempotent merchant transactions and the injected merchant coordinator. Neither CI success nor a source build establishes Roblox runtime playability.

The catalog covers all eight animals. Companion selection is server-authoritative and session-only; ownership is not persistent and premium entitlement verification is not implemented. Eagle, Bear, Leopard and Falcon remain unavailable candidates with no purchase path. The Ember rig import adapter and animation routing are implemented in source, but no 3D asset or Roblox animation IDs have been imported; the low-poly placeholder remains active. Companion AI is not implemented. Ember's seven core commands remain available as core functionality; the optional Ember Bond Pack is presentation/bonding only. No product IDs or prices are defined.

Not implemented:
- final world assets, Asher character model, companion models/AI, combat, completed authored missions, live persistence, configured economy values, merchant UI, contracts, construction, monetisation, or published Roblox place. The injectable profile persistence adapter is implemented and headlessly tested but not integrated into live sessions. Inventory and a bounded transaction journal are included in profile schema v3, and pure NPC merchant transaction rules and an injected server-side merchant coordinator are tested against durable adapter saves; persistent player sessions, configured merchant prices, remotes and live inventory/merchant UI are not enabled. The economic and construction direction is documented in `docs/ECONOMY_AND_CONSTRUCTION_FOUNDATION_V0.1.md`; those gameplay systems are not implemented.

## Supported input and display targets

The Roblox edition is designed for both mobile and PC players. HUD layout responds to viewport size and Roblox preferred input; touch controls avoid the default thumb zones, while desktop players use mouse-driven interface controls. Gameplay actions and server-authoritative progression remain consistent across platforms. Gamepad navigation and input must be verified in Studio before being advertised as fully supported. Device-specific performance profiles are required rather than assuming one graphics configuration fits every device.

## Tooling

The pinned toolchain is defined in `rokit.toml`. GitHub Actions runs the foundation regression suite, StyLua formatting for the changed foundation scripts (with corrections committed on branch pushes), Selene and a Rojo build for changes under `roblox/`. It uploads a temporary `.rbxlx` artifact and does not publish to Roblox. See `docs/CI_AND_STUDIO_TESTING.md`.

The project is prepared for Rojo-based source mapping. Rojo sync/build and Roblox Studio editing require Windows or macOS. Android can edit and version the source and documentation, but cannot run the full Roblox Studio editor.

## Safety and release policy

No paid assets, paid APIs, paid credits, public release, monetisation, destructive repository changes, or merges are part of this foundation. Keep changes on the Roblox feature branch until reviewed and approved.
