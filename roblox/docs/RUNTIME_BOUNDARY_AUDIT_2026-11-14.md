# BTV Roblox — Runtime Testing, Technical Boundary Audit and Blocker Resolution

**Auditor:** MiniMax Code / Mavis (Implementation Agent)
**Date:** 2026-11-14
**Primary target audited:** `btv/roblox-ridgeview-journal-002` @ `814bfb4` (the tip of the integration chain)
**Secondary targets:** `btv/roblox-foundation-001` @ `56bd1dd` (the audited base), `btv/roblox-fix-batch-001` @ `92a5408`
**Mode:** READ-ONLY investigation. **No existing implementation was modified, reverted, overwritten or
compromised.** The only source change made by this audit is the *additive* runtime-testing pipeline on a
dedicated branch, plus one line wiring a new offline suite into the existing CI command.

---

## 1. Result in one paragraph

Roblox Studio **cannot** be reached from this environment, and I tested that rather than assuming it.
What I *did* establish is that the Studio barrier is an **access** problem, not a capability problem: a
public GitHub repository can run real Studio runtime tests on a free Windows runner, and Open Cloud
Luau Execution can run the same harness headlessly against a published place. Both routes are now
implemented in this branch, so the "we can never run the game" boundary is **eliminated** the moment one
maintainer installs the workflow file. In parallel I ran the newest chain's four offline suites against
the pinned toolchain, audited the new persistence and economy code for exploit surface, and found that
the audit-fix branch carrying the earlier P0 corrections **was never proposed as a pull request and is
not in the chain** — one of its fixes (the Ridgeview cylinder axis) is therefore still live.

---

## 2. Files inspected

The chain tip now carries **43 Luau files**. I read the full service and policy layer of the chain and
the whole of the audit-fix branch:

| Area | Files |
|---|---|
| New shared policies | `PlayerProfileSchema`, `ProfileLeasePolicy`, `ProfileRecordPolicy`, `MerchantTransactionPolicy`, `PropertyPolicy`, `InventoryPolicy`, `ItemCatalog`, `PropertyCatalog`, `CovenantRankCatalog`, `ConstructionPlacementPolicy`, `BuildModuleCatalog`, `RidgeviewFieldNoteCatalog`, `RidgeviewFieldNotePolicy`, `RidgeviewInvestigationPolicy`, `RidgeviewSettlementPolicy` |
| New server services | `ProfilePersistenceAdapter`, `MerchantService`, `RidgeviewFieldNotes.server`, `RidgeviewInvestigationService` |
| New world/client | `RidgeviewSettlement.server`, `RidgeviewFieldNotes.client`, `RidgeviewSettlement.client` |
| Modified | `CompanionActorService`, `CurrencyService`, `PlayerStateService`, `MissionService`, `Bootstrap.server`, `MobileHUDController`, `CuriosityArchive.server`, `RidgeviewLandscapeStudy.server`, `CompanionCatalog` |
| Tests | `foundation.spec.luau` (1,357 lines), `settlement.spec.luau`, `ridgeview_investigation.spec.luau`, `support/FakeProfileStore.luau` |
| CI | `.github/workflows/roblox-validation.yml` on the chain tip |

---

## 3. Results by layer — kept separate as required

### 3.1 Static analysis — CONFIRMED

| Check | Result |
|---|---|
| `selene 0.31.0 src tests` (pinned) | **0 errors, 0 warnings, 0 parse errors** ✓ |
| `stylua 2.5.2 --check src tests` (pinned) | **20 of 43 files fail** ✗ |
| The CI format gate | **passes** — because it is an explicit file list, not a directory |

### 3.2 Automated CI (offline) — CONFIRMED, executed by me with the pinned toolchain

| Suite | Result |
|---|---|
| `tests/foundation.spec.luau` | **PASS** (exit 0) |
| `tests/settlement.spec.luau` | **PASS** (exit 0) |
| `tests/ridgeview_investigation.spec.luau` | **PASS** (exit 0) |
| `tests/pipeline.spec.luau` (added by this audit) | **PASS** (exit 0) |
| Rojo build, `default.project.json` | **PASS** — place builds |
| Rojo build, `test.project.json` (added by this audit) | **PASS** — place builds and carries `ServerStorage.BTVTestKit` |

Upstream CI agrees: runs #231–#234 on the chain tip are green.

### 3.3 Roblox Studio runtime — BLOCKED

**No Studio runtime test was executed. None is claimed.** The blocker was established by test, not by
assumption:

```
$ run-in-roblox run --script probe.lua --place-file BTVRoblox.rbxlx --universe-id 0 --place-id 0 ...
ERROR run_in_roblox] place runner task exited early with err: Could not locate a Roblox Studio installation.
Caused by:
    Your platform is not currently supported
```

This sandbox is Debian 12, headless (no `DISPLAY`, no Xvfb, no Docker, no Wine). Roblox Studio has no
Linux build. **Mitigation implemented**: the engine harness plus two runners (§5), so the runtime tests
execute the moment one maintainer installs the CI job.

### 3.4 Multiplayer — BLOCKED

Not executed. No client has ever joined a BTV place. The harness is client-capable (it carries a
`client_hud_present` check) and the Studio runner accepts `-Clients 2`, but no run has happened.

### 3.5 Android hardware — BLOCKED

Not executed. No device and no emulator is reachable from here, and the Studio device emulator is itself a
Studio feature. No Android performance number in this repository is real.

---

## 4. Boundary investigation — what can be eliminated, worked around, or must wait

| Boundary | Verdict | Resolution |
|---|---|---|
| Studio is unavailable on our Android device | **CONFIRMED — cannot be eliminated on the device** | Move the runtime to a **Windows/macOS** machine or a **Windows CI runner**. Roblox Studio will never run on an Android phone. |
| Claude Mobile cannot supply a local Studio runtime | **CONFIRMED** | The runtime is a CI/Studio concern, not an agent concern. An agent never needs Studio locally. |
| Studio MCP needs Studio and its AI client on the same computer | **CONFIRMED** | Not needed. The harness runs *inside* the place; no MCP bridge is required. |
| Headless CI and static checks cannot establish playability | **CONFIRMED** | **Partially eliminated.** The new Studio job runs the real engine. It does not replace device testing. |
| Multiplayer replication unverified | **CONFIRMED** | `--num-clients 2` in the Studio runner; needs Studio. |
| Android performance unverified | **CONFIRMED — irreducible here** | Needs the phone. The runbook in `roblox/docs/ANDROID_WORKFLOW.md` covers it. |
| HUD and touch interactions untested | **CONFIRMED** | Needs the Studio device emulator or a phone. The harness checks that the HUD *builds*; it cannot check that it does not overlap the thumbstick. |
| DataStore behaviour unverified | **CONFIRMED** | Open Cloud with a real place, or a published test place. The adapter's own logic **is** verified offline through `FakeProfileStore`. |
| Assets and some systems incomplete | **CONFIRMED** | Out of scope for infrastructure; the place model and rig contract already fail closed to a placeholder. |

**Newly established, previously unknown:** the Open Cloud Luau Execution API is **stable** and
documented (`POST /cloud/v2/universes/{u}/places/{p}/luau-execution-session-tasks`, scope
`universe.place.luau-execution-session:write`, ~5 tasks/minute, 5-minute ceiling), and Roblox publishes
a reference implementation of exactly this pipeline.

---

## 5. What this audit implemented

### 5.1 The runtime testing pipeline — the capability that did not exist

| File | Purpose |
|---|---|
| `roblox/tests/engine/EngineTests.luau` | 9 engine tests that run inside a live place |
| `roblox/tools/engine-task.luau` | The chunk the runners execute in the place |
| `roblox/test.project.json` | Rojo mapping that ships the harness in `ServerStorage.BTVTestKit` |
| `roblox/tools/opencloud/run_luau_task.py` | Open Cloud client; key from the environment, never printed |
| `roblox/tools/studio/run-engine-tests.ps1` | Studio runner for a maintainer's Windows or macOS machine |
| `roblox/ci/roblox-studio-validation.yml` | CI job source: Windows runner, read-only permissions, no publish |
| `roblox/ci/install-studio-workflow.sh` | One-command installer for that job |
| `roblox/tests/pipeline.spec.luau` | Offline checks that keep the pipeline itself intact |
| `roblox/docs/RUNTIME_TESTING_PIPELINE.md` | The runbook and the boundary matrix |

**Regression coverage:** the new offline suite runs **inside the existing CI command** — `lune run
tests/foundation.spec.luau` now requires `tests/pipeline.spec.luau` — so the pipeline is covered by CI
today without a workflow edit.

**Verification performed:** all four offline suites pass with the pinned `lune 0.10.5`; `selene` reports
0 errors / 0 warnings on the new files; `stylua` reports them clean; both Rojo builds succeed and the
test place was inspected to confirm `ServerStorage.BTVTestKit.EngineTests` is present.

### 5.2 One toolchain footgun found and documented

**CONFIRMED:** **StyLua 2.5.2 cannot parse positional Luau tuple types.** `type A = { string, number }`
is a *parse error* in StyLua 2.5.2, while the named-field form `type A = { a: string, b: number }`
parses fine. The repository currently happens to use only the named-field form, so nothing is broken —
but any contributor who writes a positional tuple gets a confusing "syntax error" from the format step
rather than from the compiler. The harness documents this in a comment, and the pipeline suite would
catch a regression of it.

---

## 6. Security and multiplayer integrity audit

### 6.1 The new persistence layer — SOUND

`ProfilePersistenceAdapter`, `ProfileLeasePolicy` and `ProfileRecordPolicy` were read in full. They are
well constructed and worth protecting from future churn:

- **Dependency injection everywhere** (`Clock`, `Wait`, `GenerateToken`, `Random`, `Store`) — so retry,
  backoff and lease behaviour are testable offline, which is why `FakeProfileStore` exists.
- **Lease semantics are correct**: an unexpired lease owned by another server is never displaced
  (`ProfileLeasePolicy.TryAcquire`), expiry is exclusive (`expiresAt > now`), and only the matching owner
  token may release.
- **Optimistic concurrency**: a save whose `candidate.revision` differs from the stored revision is
  refused rather than overwriting newer data.
- **Idempotent retries**: a repeated operation ID is only accepted when owner, base revision, result
  revision *and* the complete resulting profile all match; anything else is rejected outright.
- **Fail-closed**: a malformed stored record, a malformed save marker, or a profile that fails validation
  is refused — the adapter will not overwrite it.
- **Retry hygiene**: transient failures are distinguished from terminal ones, backoff is exponential with
  jitter, attempts are capped at 5, and a *policy cancellation* is explicitly terminal rather than
  retryable.
- **Correctly not wired in**: the adapter is not connected to player joins, and says so. Nothing claims
  persistence works.

### 6.2 The new economy — SOUND

`MerchantService` and `MerchantTransactionPolicy`: prices come from injected server configuration and
**clients never submit prices**; request IDs, quantities and merchant/item IDs are validated; requests
are rate-limited per player and a second concurrent transaction is refused; the service is not connected
to remotes yet.

### 6.3 The new client-facing surfaces — SOUND

Two new client→server paths appeared on the chain and both were checked:

- `GetFieldNotes` — a read-only `RemoteFunction`.
- `RidgeviewDialogueAction` — the settlement dialogue action. The handler **re-checks proximity to the
  NPC server-side** (`canInteract(player, npcId)`) before advancing, type-checks the action, rate-limits
  it, and advances only on phase-and-action matches. A client cannot fast-forward a conversation from
  across the map or skip a consent gate.

### 6.4 Gaps that remain

| Gap | Severity | Note |
|---|---|---|
| The **persistence adapter and merchant service are not wired into player joins** | By design | Documented in both modules. Nothing may claim persistence or commerce works. |
| `os.clock()` is used as the rate-limit clock | LOW | Current Roblox documentation describes `os.clock()` as monotonic elapsed time, so this is sound today; older community documentation described CPU time, under which a throttle would become a multi-second lockout. `workspace:GetServerTimeNow()` would remove the ambiguity. |
| The dialogue remote is created by the settlement world script rather than the bootstrap | LOW | If that script is absent from a place, the client would wait on a remote that never appears. The same pattern as the archive service's lifecycle. |
| `DialogueAction` has no client-side `WaitForChild` evidence in this audit | INFO | The client file references `dialogueAction:FireServer`, so the remote is resolved on the client; the exact resolution path was not traced line by line. |

---

## 7. Findings in the project's own workflow

### F1 — **CONFIRMED — the audit-fix branch was never proposed and is not in the chain**

`btv/roblox-fix-batch-001` (23 commits) carries the corrections from the 2026-11-12 independent audit:
the Ridgeview cylinder axis, currency context-key dedup, archive shared-state, mobile companion panels
and CI hardening.

- It has **no pull request** — five PRs are open on the repository and none involves it.
- It is **not an ancestor** of the chain tip (`git merge-base --is-ancestor` → false).
- One of its fixes is therefore **still live in the chain**: `RidgeviewLandscapeStudy.server.luau:263-266`
  still builds every tree trunk as `Vector3.new(2.1, height, 2.1)` with the comment *"Roblox cylinder
  parts use their local Y axis as the long axis"*, which is not how Roblox cylinders work — a cylinder
  extrudes along its **local X**. All 17 trees render as thin vertical fins instead of posts, and each
  trunk is also a collider.
- Two other fixes were implemented **independently on the chain** and are fine: the currency context-key
  dedup (`CurrencyService.luau:41,48`) and the eight-animal companion actors
  (`CompanionActorService.luau:401-427`, which builds distinct per-species placeholders for fox, owl,
  horse and the rest).

**Action:** the coordinator should open a pull request for `btv/roblox-fix-batch-001` against the chain
tip and resolve the overlap with the chain's own currency and archive work. The harness test
`ridgeview_tree_trunks_are_upright` will fail until the cylinder fix is integrated — which is exactly
what a runtime test should do.

### F2 — **CONFIRMED — the CI format gate is an allowlist that grows instead of a directory**

The gate lists specific files on four separate `stylua --check` lines. Every newly added file is added
to the list; the files that were already failing are never fixed. The result on the chain tip is
**20 unformatted files, all outside the gate**, so CI stays green while the tree rots. The count has
grown from 7 (2026-11-12) to 20 as new modules arrived.

**Root cause:** the gate was written as an explicit file list instead of `stylua --check src tests`.

**Why I did not simply fix it:** reformatting 20 files that other agents are actively editing would
create a large, conflict-prone diff across files the chain owns — the opposite of preserving in-flight
work. The remedy is one command, run once, at the right moment:

```bash
cd roblox && stylua src tests        # format the tree
# then replace the four `stylua --check` lines with a single:
#   stylua --check src tests
```

Both steps are mechanical and behaviour-free. The second needs a workflow edit, which this token cannot
make (§9).

### F3 — **CONFIRMED — the CI job auto-commits to the branch**

`roblox-validation.yml` still holds `permissions: contents: write` and commits formatting corrections
straight back to the branch. Its own commit re-triggers the workflow through the `roblox/**` path
filter, and the concurrency group can cancel a run between `git commit` and `git push`. The new Studio
job in this branch deliberately requests `contents: read` only, so it does not repeat the pattern.

### F4 — **CONFIRMED — the Roblox track still has no review path**

The chain is five stacked branches deep with two pull requests. The audit-fix branch has none.

---

## 8. What is blocked, and on whom

| # | Blocked item | Blocked on | Who |
|---|---|---|---|
| 1 | **Installing the Studio CI workflow** | GitHub refuses workflow changes from a token without the `workflow` scope — tested, the push was rejected and no branch was created | Creator: grant the scope, or paste the file via the web editor |
| 2 | **Open Cloud Luau Execution** | A Roblox experience, a test place, and an Open Cloud API key | Creator, one-time |
| 3 | **Multiplayer runtime tests** | A Studio installation — now automated by the Windows job | Creator installs the workflow; the runner takes `--num-clients 2` |
| 4 | **Android device testing** | The physical phone | Creator |
| 5 | **HUD overlap with the default touch controls** | The Studio device emulator or a phone | Creator |
| 6 | **Live DataStore behaviour** | Open Cloud with a real place | Creator |
| 7 | **Horse mounting, combat, premium products** | Their own design gates | Creator and canon authority |

---

## 9. Why the workflow file could not be installed by the agent

Tested on 2026-11-14, the push of a workflow file was rejected:

```
! [remote rejected] … (refusing to allow a Personal Access Token to create or update
  workflow `.github/workflows/zz-probe.yml` without `workflow` scope)
```

**No branch was created and nothing landed** — the probe was clean. Two ways forward, both one step:

1. Grant the PAT the **Workflows: write** permission, and this branch's workflow can be installed
   immediately.
2. Run `bash roblox/ci/install-studio-workflow.sh` from a machine with a normal token, or paste
   `roblox/ci/roblox-studio-validation.yml` into the GitHub web editor.

The repository is **public**, so GitHub-hosted Windows runners are free: option 1 or 2 gives real Studio
runtime tests at zero cost.

---

## 10. Classification summary

**CONFIRMED** — Studio unsupported on Linux (tested); the CI format gate allows 20 unformatted files;
the audit-fix branch has no pull request and is not in the chain; the Ridgeview cylinder defect is still
live in the chain; CI holds `contents: write` and auto-commits; StyLua 2.5.2 cannot parse positional
tuple types; the offline suites, Selene, StyLua and both Rojo builds behave as described above; the
persistence, economy and dialogue code paths are sound as described.

**PROPOSED** — install the Studio workflow; open a pull request for `roblox-fix-batch-001`; run
`stylua src tests` and widen the gate to `src tests`; wire the persistence adapter and merchant service
into the player lifecycle once the schema is approved; move rate limiting to
`workspace:GetServerTimeNow()`; move the dialogue remote creation into the bootstrap; add the eight
missing stubs for the premium candidates.

**UNKNOWN** — whether the branch `btv/roblox-foundation-001` is protected (the API returned 403 for this
token); whether `os.clock()` behaviour has changed across Roblox client versions; the exact runtime
behaviour of the HUD against the default touch controls.

**BLOCKED** — Studio runtime execution, multiplayer, Android hardware, the live DataStore, and the
Open Cloud route (items 1-7 of §8).

**COMPLETED** — the full boundary investigation; the execution of all four offline suites on the chain
tip with the pinned toolchain; the security audit of the new persistence, economy and dialogue code; the
implementation of the engine test harness, the Open Cloud client, the Studio runner, the CI job source,
the installer and the offline pipeline suite; the documentation of the runbook and this report.

**No existing implementation was modified, reverted or compromised. No merge, no publication, no paid
service or credit consumption, and no credential exposure.**
