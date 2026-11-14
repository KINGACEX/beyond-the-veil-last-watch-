# Studio CI activation — maintainer handoff

**Date:** 2026-11-14
**Owner:** MiniMax Code (Implementation Agent)
**For:** a maintainer with GitHub **workflow write** access, or anyone with the GitHub web editor

This is the exact procedure to activate the Roblox Studio runtime test job and to make every Roblox branch run
validation CI. It is two commands and one commit. No agent work remains for it.

---

## 1. Why it is not already active

The implementation token used by the agent has neither the `workflow` scope nor `actions: write`. Both were
**tested**, not assumed:

| Attempt | Result |
|---|---|
| Push a file under `.github/workflows/**` | `refusing to allow a Personal Access Token to create or update workflow '…' without 'workflow' scope` — the probe branch was not created |
| `POST /actions/workflows/415146632/dispatches` | `403 Resource not accessible by personal access token` |

Roblox Studio also has no Linux build, so the runtime job cannot run in the agent's sandbox at all. The barrier is
**access to a Windows runner**, not a missing capability: GitHub-hosted `windows-latest` runners are free for public
repositories, and `run-in-roblox` installs the pinned Studio build automatically.

---

## 2. Step 1 — install the Studio runtime workflow

From a clone of the repository, on the branch you want the workflow to live on:

```bash
bash roblox/ci/install-studio-workflow.sh
git add .github/workflows/roblox-studio-validation.yml
git commit -m "ci(roblox): add the Roblox Studio runtime validation workflow"
git push
```

That script copies `roblox/ci/roblox-studio-validation.yml` to `.github/workflows/roblox-studio-validation.yml` and
prints the remaining three commands. **It has already been run against a scratch copy of this repository and the
result was parsed and inspected**: it is valid YAML with the `studio-runtime` job on `windows-latest`.

If you prefer the web editor: create `.github/workflows/roblox-studio-validation.yml` and paste the contents of
`roblox/ci/roblox-studio-validation.yml` verbatim.

### What the job does

| Step | Detail |
|---|---|
| Checkout | the branch or pull request that triggered it |
| Install Node, Rojo and `run-in-roblox` | Rojo is pinned; `run-in-roblox` pulls the Studio build |
| Build the test place | `rojo build test.project.json --output build/BTVRobloxTest.rbxlx` — the harness lands in `ServerStorage/BTVTestKit` |
| Run the harness | `run-in-roblox run --script tools/engine-task.luau --place-file build/BTVRobloxTest.rbxlx --num-clients <n>` |
| Upload the log | `build/studio-run.log` is uploaded as the artifact `btv-roblox-studio-log`, retained 7 days, uploaded even when the job fails |
| Failure handling | the job exits non-zero if the harness prints `FAIL `, so a red job always means a real failure |

The job needs `permissions: contents: read` only. It never commits, never pushes and never changes repository
settings.

### Triggers

The workflow file already declares:

- `push` on `btv/roblox-*` — every Roblox branch, present and future;
- `pull_request` on any base — every Roblox pull request;
- `workflow_dispatch` with a `num_clients` input — `1` for a solo check, `2` for the multiplayer check.

So once the file is installed, **any push to a Roblox branch runs the Studio runtime tests** — no further
configuration and no `actions: write` permission are needed.

---

## 3. Step 2 — widen the validation workflow triggers

`.github/workflows/roblox-validation.yml` (the Lune suites, Selene, StyLua and Rojo build) still enumerates its
trigger branches by hand. PR #10 targets `btv/roblox-ridgeview-journal-002` and PR #11 targets
`btv/roblox-runtime-test-pipeline-001`; **neither branch is in the `pull_request` list, so those pull requests
currently receive no CI at all**.

```bash
python3 roblox/ci/widen-workflow-triggers.py --check   # shows the diff, changes nothing
python3 roblox/ci/widen-workflow-triggers.py             # applies it
```

The script replaces the enumerated `push` and `pull_request` branch lists with the glob `"btv/roblox-**"`, refuses to
touch anything else in the file, and verifies the result. It was run against a scratch copy of the workflow in this
environment and the output was inspected.

---

## 4. Step 3 — the first genuine runtime result

Once step 1 is pushed, the agent will:

1. Watch the run to completion on the branch under test.
2. Download the `btv-roblox-studio-log` artifact and read the full harness output.
3. Report the **actual** result of every engine test — no inference, no "should pass".
4. For each failure, read the failing assertion, find the defect in source, fix it, and re-run.
5. Repeat until the harness is green, then run the multiplayer variant (`num_clients: 2`).

**Until a Studio run has actually executed, the runtime status is `NOT TESTED`.** No agent in this environment may
report runtime success.

### The engine tests that will run

The harness currently registers **10** tests (it was 9 before the ridgeview corrections; the departure-sign
orientation test was added):

| # | Test | What it proves |
|---|---|---|
| 1 | `bootstrap_remotes` | The server creates its remotes |
| 2 | `world_scenes_exist` | The world scenes are built |
| 3 | `temple_structure` | The temple is present and shaped as authored |
| 4 | `ridgeview_arrival_marker` | The Ridgeview arrival marker exists |
| 5 | `ridgeview_tree_trunks_are_upright` | Every Ridgeview trunk is an upright cylinder (long axis on local X, rotated up) — this is the test the correction was written for |
| 6 | `ridgeview_departure_sign_faces_the_player` | The departure sign faces the approach, not away from it |
| 7 | `archive_prompt_is_shared` | The shared archive prompt never carries a per-player count |
| 8 | `companion_actor_spawns` | A companion actor exists for a player |
| 9 | `mission_service_state` | The mission service holds server-owned state |
| 10 | `client_hud_present` | The client HUD exists |

---

## 5. If the Studio job cannot run at all

Two documented fallbacks, in order of preference:

1. **Open Cloud Luau Execution** — `POST /cloud/v2/universes/{u}/places/{p}/luau-execution-session-tasks`, scope
   `universe.place.luau-execution-session:write`, roughly 5 tasks per minute and a 5-minute ceiling. It runs the same
   harness headlessly. It needs a real experience and place, which only the creator has.
2. **A maintainer with Studio** — run `roblox/tools/studio/run-engine-tests.ps1` locally against
   `roblox/build/BTVRobloxTest.rbxlx` and attach the log.

---

## 6. What the agent has already verified, so the maintainer does not have to

| Check | Result |
|---|---|
| `rojo build test.project.json` | Succeeds; `ServerStorage.BTVTestKit` is present in the built place |
| `rojo build default.project.json` | Succeeds |
| All six offline Lune suites at every commit of the correction stack | Pass |
| The Studio workflow YAML parses and declares the expected job and triggers | Verified |
| The trigger-widening script applied to a scratch copy | Verified, output inspected |
| `run-in-roblox` on Linux | Confirmed unsupported (*"Your platform is not currently supported"*) — the reason the job runs on Windows |

---

## 7. Cost

GitHub-hosted `windows-latest` runners are free for public repositories. The job installs Studio, Rojo and Node
through the standard toolchain caches. There is no paid service, no credit spend and no Robux cost anywhere in this
procedure. `run-in-roblox` uses the public Studio distribution for an unpublished place file; no experience is
published and no player-facing data is involved.
