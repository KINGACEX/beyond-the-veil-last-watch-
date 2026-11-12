# ChatGPT Coordination Handoff — BTV Roblox Independent Technical Audit

**From:** MiniMax Code / Mavis (Implementation Agent)
**To:** ChatGPT (Lead Coordinator), copied to the creator (KINGACEX)
**Date:** 2026-11-12
**Subject:** Independent technical audit of `btv/roblox-foundation-001` — findings submitted for review and disposition

---

## 1. What you are receiving

A complete, independent, read-only technical audit of the Roblox track, plus a reproducible evidence pack.

| Artifact | Path |
|---|---|
| Full audit report (666 lines, 9 sections + publication note) | `roblox/docs/audits/BTV_ROBLOX_INDEPENDENT_TECHNICAL_AUDIT_2026-11-12.md` |
| Evidence pack | `roblox/docs/audits/evidence/` |
| Reproduction script (read-only) | `roblox/docs/audits/evidence/reproduce-audit-checks.sh` |

**Branch:** `btv/audit-roblox-independent-2026-11-12`, branched from `btv/roblox-foundation-001` @ `56bd1dda737e6e2d11c9cc0055ca79aab1ba9c3b`.
**Pull request:** draft, into `btv/roblox-foundation-001`.

**Documentation only.** No `.luau` file, scene, configuration or workflow was changed. No implementation was
begun, no merge, no publication, no repository-setting change, no paid generation or credit consumption.

## 2. Scope covered

Every Luau source file on the audited commit was read in full — 18 files, 2,852 lines — together with the Rojo
mapping, the CI workflow, `AGENTS.md`, and 16 documents. Nothing was sampled.

## 3. Verification I actually performed (not inherited from a badge)

| Check | Tool | Result |
|---|---|---|
| Regression suite | `lune 0.10.5` (pinned) | **PASS**, exit 0 |
| Format compliance | `stylua 2.5.2 --check src tests` (pinned) | **7 of 18 files fail** — all outside the CI gate |
| CI history | Actions API, read-only | 88 runs; **#88 green** on the audited tip; **#84 green** (the README's claim is true) |
| CI failure forensics | Run #81 job steps + logs | Failed at `selene src tests`: 2 warnings, **both since fixed**; #82/#83 cancelled by the concurrency group |
| Cylinder axis | Roblox Creator Docs | Cylinder's long axis is **local X** — used to confirm the Ridgeview trunk defect |
| `os.clock()` semantics | Roblox Creator Docs | **Monotonic elapsed time** — a suspected throttle defect was checked and **discarded**, not reported |

## 4. Bottom line

**The foundation is honest and the security posture is sound. The problem is completeness, and the gap between
what the product promises and what the code does.**

Confirmed good and not to be disturbed: server authority for missions, currency and companions; the command
allowlist; per-player throttling applied before payload inspection; premium fail-closed behaviour even against a
forged ownership map; the imported-rig validator that rejects executable code and broken Motor6D graphs; the
per-player archive isolation; the pinned-toolchain CI; and a documentation set that consistently refuses to claim
runtime validation that has not happened.

## 5. What needs disposition — nine items, ordered

### P0 — correctness and honesty (no design decisions, no new content)

| # | Finding | Location | Why it matters |
|---|---|---|---|
| 1 | **Ridgeview tree trunks are the wrong shape** — a Roblox cylinder's long axis is local X, so `Size = (2.1, height, 2.1)` with no rotation makes a thin vertical fin, not a post. The in-code comment states the axis rule backwards; the temple builder in the same repo gets it right. | `RidgeviewLandscapeStudy.server.luau:261-270` | All 17 trees affected, and each trunk is also a collider |
| 2 | **The Curiosity Archive entry prompt mutates shared state** — one shared `ProximityPrompt` instance; a failed entry rewrites `ObjectText` for every player and never restores it. The prompt's text is hardcoded "0/3" and never reflects the individual player's count. | `CuriosityArchive.server.luau:108, 157` | One player's action changes everyone's UI |
| 3 | **The currency context key is validated and then discarded** — no consumed-key state exists, so a reward can be granted repeatedly. `AdjustCurrency` itself validates nothing and allows negative/fractional amounts with no balance floor. | `CurrencyService.luau:18,28-30,33`; `PlayerStateService.luau:84-97` | The only reward-safety mechanism in the codebase is a no-op |
| 4 | **The command allowlist lives only in the remote handler** — `SetEmberCommand` accepts any string. | `Bootstrap.server.luau:86`; `PlayerStateService.luau:57-68` | Defence in depth for the next caller |
| 5 | **The archive's session lifecycle is owned by an optional world script**, not the bootstrap. If that script is absent from a place, collection always fails silently. | `CuriosityArchive.server.luau:139,148` | Silent failure mode |
| 6 | **The CI format gate covers 6 of 18 files, and the other 7 fail the check.** "StyLua formatting passes in CI" is true but narrower than it reads; widening the gate fails immediately. | `.github/workflows/roblox-validation.yml:53-58,63,69` | The obvious next CI change breaks the build |
| 7 | **The opening slice cannot be completed by a first-time player** — the Ridgeview travel trigger is an invisible prompt on an unsigned lawn ~50 studs past the temple exit, and the objective HUD never mentions it. | `OpeningMission.server.luau:134-164`; `MissionService.luau:28` | The first-run loop has a dead end |
| 8 | **Mission progression implements 4 of the 6 approved stages** while the HUD advertises "n / 6" and stalls at 4/6. | `MissionService.luau`; `GameConfig.luau:33-40` | Advertised progress the game cannot deliver |
| 9 | **Non-deterministic companion button order** (iteration over a string-keyed table) and **root `AGENTS.md` describes only the Godot baseline** — no Roblox section. | `MobileHUDController.luau:348`; `AGENTS.md` | Reads as unfinished; agents will apply the wrong rules |

### P1 — the eight-animal architecture (no new content required)

| # | Finding | Location |
|---|---|---|
| 10 | **The seven commands have no executor.** `emberCommand` is stored and echoed in the HUD; nothing else reads it. No command — including `Attack` — produces any world effect. | `PlayerStateService.luau:66`; only reader is `MobileHUDController.luau:256,380-381` |
| 11 | **Three of the four free companions are dead ends.** Selecting Fox, Owl or Horse **destroys the companion actor** and **hides the command panel** — no companion, no commands. | `CompanionActorService.luau:311`; `MobileHUDController.luau:261` |
| 12 | **No pathfinding** — the follow is a straight-line lerp toward a fixed offset, so the companion passes through walls, the temple's 16 columns and 48 bench parts. No stuck detection, no recovery. FQ-04 and FQ-05 unmet. | `CompanionActorService.luau:404-445` |
| 13 | **The walk animation is driven by the player's velocity, not the companion's**, so the companion cannot represent its own state. The placeholder has **no acknowledgement animation** at all. | `CompanionActorService.luau:384,433,363` |
| 14 | **No persistence of any kind** — mission phase, currency, companion selection, ownership and archive progress are all lost on rejoin. FQ-12 unmet. | all `Sessions` tables |

**Recommended shape** (audit §5): one generalised rig contract (state-name → clip mapping, keeping the existing
fail-closed validator verbatim), one parameter-driven controller, and **one parametric placeholder builder** so all
five rig families render as visibly distinct animals from data rows rather than eight bespoke systems. That is
what removes the primitive-placeholder look without adding an over-engineered architecture.

### P2 — governance

- **CI holds `contents: write` and auto-commits to the branch.** The commit re-triggers the workflow (the `roblox/**`
  path filter matches it), the concurrency group can cancel a run mid-commit, and third-party actions are pinned to
  mutable tags rather than SHAs. Branch protection is **UNKNOWN** — the API returned 403 for my token.
- **The Roblox track has no pull request.** Five PRs are open; none involves `btv/roblox-foundation-001`, and CI
  writes to it directly.

## 6. Verification of the previous audit's nine findings

**None is incorrect.** Two are partial, and in both cases the missing half is specified in §5 above.

| # | Finding | Verdict |
|---|---|---|
| 1 | CompanionActorService movement and replication | **PARTIALLY CONFIRMED** — server-authoritative, 15 Hz, anchored replication: sound. Pathfinding absent; walk animation driven by the player's velocity; placeholder has no acknowledgement clip; `GetPlayerByUserId` per tick; replication quality unmeasured |
| 2 | Missing pathfinding | **CONFIRMED** |
| 3 | Missing non-Ember companion actors | **CONFIRMED**, and stronger than stated — see item 11 |
| 4 | Incomplete command behaviour | **CONFIRMED** — see item 10 |
| 5 | Mobile HUD overlap | **CONFIRMED (geometry)** — both bottom toggles sit in Roblox's default thumbstick and jump-button zones; a second top-bar overlap exists on narrow screens. Runtime confirmation BLOCKED on Studio |
| 6 | Currency validation | **PARTIALLY CONFIRMED** — the boundary validation is real; the context key is discarded, `AdjustCurrency` validates nothing, and no caller awards currency at all |
| 7 | Context-key deduplication | **CONFIRMED** |
| 8 | CI permissions and auto-commit behaviour | **CONFIRMED** |
| 9 | Curiosity Archive shared-state issues | **CONFIRMED** — mechanism identified in item 2. Per-player discovery isolation is **correct**; that sub-concern does not hold |

## 7. Decisions I did not take

I made no design decisions and changed no approved decision. Four items need the creator, not me:

1. **The multiplayer "every player is a Chosen" proposal** (`MULTIPLAYER_CHOSEN_ADAPTATION_PROPOSAL.md`) versus the
   locked decision that **Asher Vance remains the sole Chosen**. The document is correctly labelled as a proposal
   with four unmet approval gates, and **no code implements it** — `GameConfig.Protagonist` is a fixed
   `asher_vance` and there is no character-selection UI, so the locked decision is upheld in code. The document set
   simply states two positions; the proposal must not be read as approved.
2. **`Attack` command semantics.** Canon says Ember is not a weapon and combat is behind a design gate. A command
   named `Attack` that does nothing is safer than one that attacks, but the gap must be closed deliberately.
3. **The persistence schema**, before any DataStore work (`FOUNDATION_V0.1.md` §6 already lists the requirements).
4. **The canon-approved content** for the Ridgeview investigation/response and final report stages.

## 8. What I need from you

1. **Review and disposition** of the nine P0 items — accept, defer, or dispute each one. Items 1, 2, 3, 4 and 5
   are small, self-contained fixes with no design content.
2. **Confirm the P1 sequencing** — particularly whether the parametric placeholder builder plus a generalised
   contract should land before any further art work, since that is what makes all eight animals real today.
3. **Escalate the four creator decisions** in §7. Item 1 is the one with a live document conflict.
4. **Rule on CI governance** — whether `contents: write` and the auto-commit step stay, and whether the Roblox track
   moves onto the draft-PR path the Godot tracks already use.
5. **Route the Studio-dependent tests** to whoever has Studio access. 19 runtime tests are listed as BLOCKED in
   audit §9, including the two multiplayer cases and every Android measurement.

## 9. Honest limits of this audit

Everything here is derived from the committed source or from a tool I ran. **No Roblox Studio runtime testing was
performed and none is claimed.** Geometry counts are source-derived, not measured. Branch protection is unverified.
No physical device or emulator was used. Nothing in this audit should be read as evidence that the game runs.
