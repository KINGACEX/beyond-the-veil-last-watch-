# BTV Roblox Runtime Testing Pipeline

**Status:** Source implemented. The Studio job cannot be installed by an agent (GitHub refuses workflow
changes from a token without the `workflow` scope), so one maintainer step is required before it runs.
**Date:** 2026-11-14

## 1. Why this exists

Until now the Roblox track could prove exactly three things:

| Layer | Tool | What it proves | What it cannot prove |
|---|---|---|---|
| Static | Selene | The source parses and lints | That anything runs |
| Offline | Lune (0.10.5) | Pure rules — missions, ownership, policies | Anything that needs the engine |
| Build | Rojo | The project maps into a place file | That the place runs |

**None of them can execute a single line of the actual game.** The world builders, the companion actor,
the ProximityPrompts, the dialogue remotes and the DataStore adapter have never run.

This pipeline adds the missing layer, and it is deliberately small: one harness module, one task entry
point, three runners, and one CI job.

## 2. What was investigated, and what actually works

| Route | Result |
|---|---|
| **Roblox Studio in this environment** | **Not available — tested.** `run-in-roblox` 0.3.2 on Linux x64 exits with *"Could not locate a Roblox Studio installation. Caused by: Your platform is not currently supported."* Studio has no Linux build. |
| **Studio via MCP** | Not applicable without Studio running on the same machine. No Studio, no MCP. |
| **Open Cloud Luau Execution** | **Real and available** — a documented, stable Roblox API. Implemented here (`tools/opencloud/run_luau_task.py`). Needs a universe, a place and an API key, all creator-side. |
| **Studio in CI on a Windows runner** | **Real and available.** `run-in-roblox` installs Studio automatically. The repository is **public**, so GitHub-hosted runners are free. This is the recommended primary route: it needs no Roblox experience, no API key and no upload. |
| **A headless Roblox *server* binary on Linux** | Not available. The CDN paths for a Linux server build are not publicly reachable (HTTP 403), and no supported package exposes one. |
| **Android device testing** | **Blocked** — requires the physical device. No emulator is available here, and the Studio device emulator is itself a Studio feature. |

## 3. The pieces

```
roblox/test.project.json                  Rojo mapping that adds ServerStorage/BTVTestKit to the place
roblox/tests/engine/EngineTests.luau      the engine test harness (433 lines, 9 tests)
roblox/tools/engine-task.luau             the chunk the runners execute inside the place
roblox/tools/opencloud/run_luau_task.py   Open Cloud client (key from the environment, never printed)
roblox/tools/studio/run-engine-tests.ps1  Studio runner for a maintainer's Windows or macOS machine
roblox/ci/roblox-studio-validation.yml    the CI job source
roblox/ci/install-studio-workflow.sh      one-command installer for the CI job
roblox/tests/pipeline.spec.luau           offline checks that the pipeline itself is intact
```

### The harness

`EngineTests.luau` runs **inside** a real place and checks the things no offline test can reach:

| Test | Checks |
|---|---|
| `bootstrap_remotes` | `Bootstrap.server` created all six remotes |
| `world_scenes_exist` | Both world builders ran and produced their scenes |
| `temple_structure` | Interior, `WelcomeDesk` (the Scout Report prompt's anchor) and a **neutral** spawn exist |
| `ridgeview_arrival_marker` | The mission's travel anchor exists and is inert — no collision, touch or query |
| `ridgeview_tree_trunks_are_upright` | Every tree trunk is an upright post: cylinder long axis local X, roughly circular cross-section, axis pointing up |
| `archive_prompt_is_shared` | Records the archive entry prompt's shared `ObjectText` |
| `companion_actor_spawns` | A companion actor exists for this session, is the right species, and has no collision, touch or query |
| `mission_service_state` | `MissionService` loads in the live tree and returns no state for a player who never joined |
| `client_hud_present` | The touch HUD was built on the client |

Each test returns `(ok, message)`; a failure never aborts the run, and `RunAll` returns a structured
summary that both runners assert on.

### Why the harness has no engine access at module scope

Every `game:` reference happens inside a test function. That means `tests/pipeline.spec.luau` can
`require` the harness in **Lune**, so CI proves the harness still loads and still registers its nine
tests — without a Studio licence.

## 4. Running it

### 4.1 In CI (recommended primary route)

```bash
bash roblox/ci/install-studio-workflow.sh
git add .github/workflows/roblox-studio-validation.yml
git commit -m "ci(roblox): add Roblox Studio runtime validation workflow"
git push
```

The job runs on `windows-latest`, installs Rojo 7.7.0 and `run-in-roblox`, builds the test place and
executes the harness in a live Studio instance. It requests `contents: read` only — no write, no
auto-commit, no publish.

> **Why an agent cannot do this:** GitHub rejects workflow-file changes from a personal access token
> without the `workflow` scope. This was tested on 2026-11-14: the push was refused with *"refusing to
> allow a Personal Access Token to create or update workflow ... without `workflow` scope"*. Either
> grant the scope on the token, or paste the file through the GitHub web editor.

### 4.2 On a maintainer's machine (Windows or macOS)

```powershell
winget install Rojo.Rojo
npm install -g run-in-roblox
pwsh roblox/tools/studio/run-engine-tests.ps1
pwsh roblox/tools/studio/run-engine-tests.ps1 -Clients 2   # multiplayer check
```

### 4.3 Through Open Cloud (no local Studio)

1. Create an experience and a **test place** on Roblox (one-time, creator-side).
2. Create an API key at <https://create.roblox.com/dashboard/credentials> with the **Luau Execution**
   permission, restricted to that experience.
3. Build and upload the test place as a Saved version (`universe-places: write`).
4. Export the key **in your shell only** — never in a file, a repository or a chat message:

   ```bash
   export ROBLOX_API_KEY="..."          # Windows: setx ROBLOX_API_KEY "..."
   python roblox/tools/opencloud/run_luau_task.py \
       --universe <UNIVERSE_ID> --place <PLACE_ID> \
       --script roblox/tools/engine-task.luau
   ```

The client reads the key from the environment, sends it as an `x-api-key` header, and never prints or
stores it. `--dry-run` shows the request without contacting Roblox.

## 5. What this pipeline still cannot do

| Test | Status | Needs |
|---|---|---|
| Engine harness (9 tests) | **Ready, not yet executed** | Studio or Open Cloud — one of the two routes above |
| Multiplayer replication and player isolation | **Blocked** | Studio with `--num-clients 2`, or two devices |
| ProximityPrompt behaviour under player movement | **Blocked** | Studio Play mode |
| HUD overlap with the default thumbstick and jump button | **Blocked** | Studio device emulator or a real phone |
| Android frame rate, memory, draw calls, streaming | **Blocked** | A physical Android device |
| DataStore behaviour against the live service | **Blocked** | Open Cloud with a real DataStore, or a published place |
| Companion pathing under real physics | **Blocked** | Studio |

The harness covers what can be checked deterministically. The blocked rows above need a machine that
runs Studio, and — for the Android rows — a phone.

## 6. Rules the pipeline follows

- The harness never calls a `RemoteEvent`, never mutates gameplay state and never writes to a
  `DataStore`. It observes.
- It builds with `test.project.json`, never with `default.project.json`, so the test kit is not shipped
  in the playable place.
- The CI job requests read-only repository permissions and publishes nothing.
- The Open Cloud key is read from the environment and never written to disk.
