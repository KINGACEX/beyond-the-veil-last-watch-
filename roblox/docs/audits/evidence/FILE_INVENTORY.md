# Files inspected — complete inventory

Every Luau source file on the audited commit was read in full. No file was skipped.

## Source (18 files, 2,852 lines)

| File | Lines | Area |
|---|---|---|
| `src/shared/GameConfig.luau` | 49 | shared |
| `src/shared/CompanionCatalog.luau` | 113 | shared |
| `src/shared/CompanionRigContract.luau` | 39 | shared |
| `src/server/Bootstrap.server.luau` | 120 | server |
| `src/server/Services/CompanionActorService.luau` | 447 | server |
| `src/server/Services/CompanionOwnershipPolicy.luau` | 73 | server |
| `src/server/Services/CurrencyService.luau` | 48 | server |
| `src/server/Services/PlayerStateService.luau` | 99 | server |
| `src/server/Services/MissionService.luau` | 84 | server |
| `src/server/Services/ArchiveService.luau` | 88 | server |
| `src/server/World/OpeningMission.server.luau` | 166 | world |
| `src/server/World/LogosRhemaTemplePrototype.server.luau` | 333 | world |
| `src/server/World/RidgeviewLandscapeStudy.server.luau` | 332 | world |
| `src/server/World/CuriosityArchive.server.luau` | 173 | world |
| `src/client/Bootstrap.client.luau` | 38 | client |
| `src/client/Controllers/MobileHUDController.luau` | 394 | client |
| `src/client/CuriosityArchiveHUD.client.luau` | 64 | client |
| `tests/foundation.spec.luau` | 192 | test |

## Supporting files read in full

- `default.project.json` — Rojo mapping (ReplicatedStorage/BTVShared, ServerScriptService/BTVServer, StarterPlayerScripts/BTVClient)
- `.stylua.toml`, `selene.toml`, `rokit.toml` — pinned toolchain
- `README.md` — separation rule, current-foundation claims
- `../.github/workflows/roblox-validation.yml` — CI definition
- `../../AGENTS.md` — repository engineering rules (Godot baseline only)

## Documentation read

`ANIMAL_COMPANION_ROSTER_V0.1.md`, `COMPANION_3D_ASSET_PIPELINE_V0.1.md`, `COMPANION_QOL_CATALOG.md`,
`ACCEPTANCE_TESTS.md`, `FOUNDATION_V0.1.md`, `CI_AND_STUDIO_TESTING.md`, `ANDROID_WORKFLOW.md`,
`CANON_ADAPTATION.md`, `MULTIPLAYER_CHOSEN_ADAPTATION_PROPOSAL.md`, `OPENING_VERTICAL_SLICE.md`,
`RIDGEVIEW_LANDSCAPE_STUDY.md`, `LOGOS_RHEMA_TEMPLE_VISUAL_PROTOTYPE.md`, `EMBER_PREMIUM_COMPANION_DESIGN.md`,
`CURIOSITY_ARCHIVE_AND_REVENUE_RECOMMENDATION.md`, `MONETIZATION_AND_MAIN_GAME_FUNDING.md`,
`SIGNATURE_CHARACTER_PRESENTATION_V0.1.md`.

## Explicitly not performed

- Roblox Studio import, Play Solo, multi-client or device testing (**BLOCKED** — Studio requires Windows/macOS).
- Rojo sync or place upload (**not performed**; the Rojo **build** is verified by CI run #88).
- Roblox Open Cloud Luau Execution (**BLOCKED** — no test universe or API key configured).
- Any Roblox Studio runtime claim is made anywhere in this audit.
