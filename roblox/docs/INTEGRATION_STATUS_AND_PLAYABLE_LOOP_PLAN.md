# Integration status and playable loop plan

**Date:** 2026-11-14
**Owner:** MiniMax Code (Implementation Agent)
**Scope:** the Roblox track only. The Godot track is untouched by this work.

This document answers three questions: where the Roblox integration stands, what still blocks a player from a
complete loop, and what the next concrete playable milestone is.

---

## 1. Integration order and readiness

The chain is linear and every pull request targets the tip of the one below it, so merging bottom-up is safe.

```
btv/roblox-foundation-001                     56bd1dd
  └─ btv/roblox-covenant-multiplayer-fixes-001
       └─ btv/roblox-playable-prototype-001
            └─ btv/roblox-settlement-playable-001
                 └─ btv/roblox-stylua-fix-001                        (#9)
                      └─ btv/roblox-ridgeview-journal-002  814bfb4    (#10)
                           └─ btv/roblox-runtime-test-pipeline-001 23161ee (#11)
                                └─ btv/roblox-ridgeview-corrections-001 938462cf (#12)
                                     └─ btv/roblox-canon-enforcement-001  (#13)
```

### Readiness results

Produced by `roblox/ci/integration-readiness.sh`, which inspects ancestry, file overlap, persistence impact and the
offline suites at each head. It never merges.

| PR | Base → head | Ancestry | Persistence | Offline suites | State |
|---|---|---|---|---|---|
| #8 audit | `56bd1dd` → `5964695` | ahead 1, behind 0 | unchanged | pass | **merge first** — docs only, no conflict surface |
| #10 ridgeview journal | `settlement-playable` → `814bfb4` | ahead, behind 0 | unchanged | pass | ready; needs CI once the triggers widen |
| #11 runtime pipeline | `814bfb4` → `23161ee` | ahead 1, behind 0 | unchanged | pass | ready; needs the Studio workflow installed |
| #12 corrections | `23161ee` → `938462cf` | ahead 4, behind 0 | **changed** (`PlayerProfileSchema.luau`) | pass | ready; the schema change is value-only, no version bump |
| #13 canon enforcement | `938462cf` → | ahead 2, behind 0 | **changed** (schema **version 4** + migration) | pass | ready; **migration must be read before merging** |

### Overlap analysis

- **PR #12 and PR #13 both touch `PlayerProfileSchema.luau` and `PlayerStateService.luau`** — by design, and in the
  same order: PR #12 changes the identity *value*, PR #13 changes the identity *rule* and the schema version. PR #13
  is based on PR #12's head, so there is no textual conflict, but the order matters: **PR #12 first, PR #13 second**.
- **PR #12 and PR #13 both touch `roblox/tests/foundation.spec.luau`.** Again ordered, never parallel.
- **PR #11, #12 and #13 all touch `roblox/tests/engine/EngineTests.luau` or the suites it is required from.** PR #12
  added the sign test and moved the engine harness onto the shared cylinder policy; PR #13 added the identity suite.
  PR #13's head carries all of them ✓.
- **PR #8 touches only `roblox/docs/`** → it cannot conflict with any code pull request ✓.

### Persistence compatibility

| PR | Persistence impact | Assessment |
|---|---|---|
| #12 | `PlayerProfileSchema.luau` — the default identity value only | **Compatible.** The schema version stays 3, so a stored profile keeps validating; a stored profile that still carries `roblox_player_chosen` is rejected by PR #13's rule, which PR #13 then migrates ✓ — the two pull requests are meant to land together. |
| #13 | Schema **version 3 → 4** with a migration | **Compatible.** The migration is version-aware: a version 3 profile is validated against the version 3 rules, its identity is replaced by the default operative identity, and the result is re-validated against version 4. Balances, inventory, ownership and progression are preserved. The migration never rewrites the stored profile in place ✓. |
| #13 | The identity policy is threaded through the record policy, the merchant transaction policy, the persistence adapter and the merchant service | **API change, internal only.** Every one of those modules takes the policy as an injected dependency, so no module reaches for a global. The offline suites cover every one of those paths ✓. |

**Rule for the integrator:** merge #12 and #13 in the same maintenance window, or PR #13 alone. PR #13 alone is safe
because it carries the value change with it. PR #12 alone is *also* safe (a stored `roblox_player_chosen` profile
simply migrates to the operative identity when PR #13 lands).

### Merges

**Nothing is merged.** The creator approves each merge. The two pull requests that should be closed rather than
merged are **PR #9** (superseded by PR #10, whose base is `settlement-playable`) and the branch
`btv/roblox-fix-batch-001` (no pull request; its remaining corrections are ported or superseded).

---

## 2. The playable loop, step by step

Each step is marked with what the code does **today**, with the evidence.

| # | Step | Status | Evidence |
|---|---|---|---|
| 1 | Player enters the game | **PRESENT** | `Bootstrap.server.luau` binds every service on `PlayerAdded` and releases them on `PlayerRemoving` |
| 2 | Temple introduction | **PRESENT** | `OpeningMission.server.luau` publishes `communion_context`, then `covenant_alert`; `LogoRhemaTemple.server.luau` builds the sanctuary |
| 3 | Travel to Ridgeview | **PRESENT, corrected** | `DepartForRidgeviewPrompt` on the departure marker, plus `RidgeviewDepartureSign`; PR #12 fixed the sign so it faces the approaching player |
| 4 | Interact with NPCs | **PRESENT** | `RidgeviewSettlement.server.luau` builds Wren and Dorian Pike and exposes a dialogue remote that re-checks NPC proximity server-side |
| 5 | Investigate and collect evidence | **PRESENT** | `RidgeviewFieldNotes.server.luau` with the consent-gated `RidgeviewFieldNotePolicy` |
| 6 | Field Notes journal | **PRESENT** | `RidgeviewFieldNotes.client.luau` renders the journal with the approved confidence labels |
| 7 | Complete meaningful objectives | **PRESENT** | `MissionService` holds five server-owned phases; PR #12 made the Scout Report phase say *"Travel to Ridgeview"* instead of describing missing evidence |
| 8 | Earn and spend validated currency | **BROKEN — unreachable** | `CurrencyService` and `MerchantService` exist and are tested, but **neither is referenced anywhere outside its own file**, and no gameplay code calls `AwardFromServer` or `AdjustCurrency`. The player can neither earn nor spend anything in the game. |
| 9 | Progress persists after reconnecting | **BROKEN — not implemented** | `ProfilePersistenceAdapter`, `ProfileLeasePolicy` and `ProfileRecordPolicy` are a complete, tested persistence layer, but the adapter is **never constructed outside its own file**, and there is **no `DataStoreService` call anywhere in `src/`**. Progress cannot survive a reconnect today. |

### The Ember and multiplayer gap

- The seven Ember commands (`Attack`, `Protect`, `Scout`, `Track`, `Retrieve`, `Hold`, `Regroup`) are stored and
  echoed in the HUD; the companion actor plays an acknowledgement animation. **No command produces a gameplay
  effect.** `CompanionActorService.AcknowledgeCommand` only switches the animation track.
- Selecting Fox, Owl or Horse **is** safe on the current chain: the actor is rebuilt as a low-poly blockout and the
  command panel is not hidden. This was a defect on the branch the audit read; the chain has since gained the
  blockouts.
- Multiplayer is server-authoritative in the places it exists (the settlement dialogue re-checks NPC proximity, the
  merchant uses server-owned prices, the profile layer uses leases and optimistic revisions), but it has **never been
  run with two clients**, because no Studio runtime has executed yet.

---

## 3. The next concrete playable milestone

**Milestone M1 — "the vertical slice closes and survives a reconnect".**

A single player, in one Studio session, completes the opening slice end to end, and their progress is still there
after they reconnect. Nothing else is in scope for M1.

### M1 acceptance criteria

| # | Criterion | How it is proven |
|---|---|---|
| M1-1 | A player who reaches the Ridgeview can **earn** at least one currency award from a real in-game source | A new engine test asserts the award path is reachable from world code |
| M1-2 | A player can **spend** that currency at a merchant that exists in the world | A merchant stall is built in the settlement with a proximity prompt, and an engine test asserts the stall and its prompt exist |
| M1-3 | The merchant uses **server-owned prices** only | The client sends an item id and a quantity; the server resolves the price. Already true in `MerchantService`; the wiring must not weaken it |
| M1-4 | Progress **survives a reconnect** | The profile is written to a real data store on `PlayerRemoving` and read back on `PlayerAdded` |
| M1-5 | The save **fails safe** | A store error never loses the session's progress and never blocks the player; the failure is logged and the session continues |
| M1-6 | The write respects the data store budget | Writes are rate limited per key and use `UpdateAsync`, never `SetAsync`, so concurrent servers cannot lose an update |
| M1-7 | The Studio job is **green** with the 10 engine tests | The real runtime result, from a real Studio run, attached to the pull request |

### M1 build order

1. **M1a — a real data store adapter.** A `ProfileDataStore` that wraps `DataStoreService` and satisfies the store
   interface `ProfilePersistenceAdapter` already expects (`UpdateAsync`). Keys stay under the 50 character limit;
   writes go through `UpdateAsync` so a concurrent write cannot be lost; the store exposes the request budget so the
   caller can skip a save rather than be throttled. **Offline proof:** the retry, backoff and budget decisions are
   extracted into a pure policy module so the offline suite can prove them, exactly as the cylinder rule was.
2. **M1b — session wiring.** On `PlayerAdded`, acquire the profile; on `PlayerRemoving`, save it; on server shutdown,
   save what is still in flight inside `game:BindToClose` with a bounded budget. A save error is logged, never fatal.
3. **M1c — the merchant in the world.** A stall in the Ridgeview settlement with a proximity prompt and a purchase
   panel; the client sends an item id and a quantity only.
4. **M1d — a first real currency award.** One in-world source that awards currency through `CurrencyService` with a
   stable context key, so the award is idempotent across reconnects.
5. **M1e — the Studio run.** The first genuine runtime result, with the log artifact attached. Failures are fixed in
   source and the run is repeated.

### Why M1 comes after the Studio workflow is live

M1d and M1e are only meaningful in a real runtime. M1a to M1c can be written and verified offline, but **the claim
"progress persists after reconnecting" cannot be made until a Studio session has actually reloaded a player** — and
that claim is the whole point of M1. The agent will therefore not report M1 as complete until the Studio job has run
twice with a real reconnect between the runs.

### Budget notes for the data store work

The game server API allows `60 + numPlayers × 40` read requests and the same for writes, per minute, and a single
`UpdateAsync` consumes **both** budgets. Per-key usage is measured over a rolling 60 seconds. The design therefore
uses one write per key per save, never a write loop, and checks the remaining budget before writing rather than
being throttled. `UpdateAsync` is used instead of `SetAsync` because two servers can hold the same key.

---

## 4. The research track

| Topic | Current position | Next concrete step |
|---|---|---|
| Roblox Studio automation | The `run-in-roblox` harness and the Windows job exist and are documented; not yet executed | Install the workflow (maintainer) and run it |
| Multiplayer testing | `--num-clients 2` is wired into the Studio job as a dispatch input | Run it once the job is live, with a second client making a settlement request |
| Android performance | **Unverified.** No device or emulator was available, and no Android figure has ever been measured | The mobile HUD is layout-aware already; the first real measurement must come from a device, not from a claim |
| Data store reliability | The retry, lease, revision and idempotency rules exist and are tested; there is no live store | M1a, then measure the real failure rate in a Studio session |
| Mobile UI | The HUD moves the touch toggles to the bottom centre and away from the thumbstick; the panel stack is mutually exclusive | Validate on a real device once one is available |
| Security and exploit resistance | The client sends ids and quantities only; the server resolves prices, re-checks proximity, validates amounts through one shared rule, and the identity rule now fails closed | Re-audit the new merchant and persistence wiring after M1 lands |

**No figure in this table is a claim about a device, an emulator or a live store.** Every one of them is either
measured by a test in this repository or explicitly marked as unverified.
