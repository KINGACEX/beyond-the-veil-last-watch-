# BTV Roblox Edition — Independent Technical Audit

**Auditor:** MiniMax Code / Mavis (Implementation Agent), acting as an independent auditor
**Date:** 2026-11-12
**Repository:** `KINGACEX/beyond-the-veil-last-watch-`
**Branch audited:** `btv/roblox-foundation-001` @ `56bd1dda737e6e2d11c9cc0055ca79aab1ba9c3b`
**Mode:** READ-ONLY audit. No source file was modified, no implementation was begun, no repository setting was changed, nothing was published, and no paid generation or credit was consumed. The findings below were subsequently published as documentation only, on a separate branch with a draft PR (see the header of §11).
**Runtime claims:** No Roblox Studio runtime testing was performed and none is claimed. Every statement below is either derived from the committed source, verified by a tool I ran locally, or explicitly marked as blocked/unverified.

---

## 0. Executive summary

The Roblox foundation is **honest, disciplined and unusually well documented** — the docs repeatedly refuse to claim runtime validation that has not happened, and every unchecked acceptance box is genuinely unchecked. The server-authority boundary is real: the client cannot award currency, complete a mission, or equip an unowned companion.

The weaknesses are not in the security posture. They are in **completeness and in the gap between what the product promises and what the code does**:

1. **The seven commands have no behaviour.** `emberCommand` is stored and echoed in the HUD. Nothing else reads it. There is no command execution path at all.
2. **Three of the four free companions are dead ends.** Fox, Owl and Horse are owned and selectable, but selecting them **destroys the companion actor** and **removes the command panel** — no companion, no commands, no feedback.
3. **The opening slice is not completable by a first-time player.** The Ridgeview travel trigger is an invisible prompt on an unsigned lawn ~50 studs from the temple exit, and the objective HUD never mentions it.
4. **The format gate in CI covers 6 of 18 files, and 7 files actually fail the format check.** I verified this with the pinned StyLua 2.5.2.
5. **CI holds `contents: write` and auto-commits to the branch** — outside the repository's own draft-PR governance.

Everything in this report is a proposal. Nothing has been implemented.

---

## 1. Files inspected

**All 18 Luau source files — every line read.**

| Area | File | Lines |
|---|---|---|
| Shared | `roblox/src/shared/GameConfig.luau` | 49 |
| Shared | `roblox/src/shared/CompanionCatalog.luau` | 113 |
| Shared | `roblox/src/shared/CompanionRigContract.luau` | 39 |
| Server | `roblox/src/server/Bootstrap.server.luau` | 120 |
| Server | `roblox/src/server/Services/CompanionActorService.luau` | 447 |
| Server | `roblox/src/server/Services/CompanionOwnershipPolicy.luau` | 73 |
| Server | `roblox/src/server/Services/CurrencyService.luau` | 48 |
| Server | `roblox/src/server/Services/PlayerStateService.luau` | 99 |
| Server | `roblox/src/server/Services/MissionService.luau` | 84 |
| Server | `roblox/src/server/Services/ArchiveService.luau` | 88 |
| World | `roblox/src/server/World/OpeningMission.server.luau` | 166 |
| World | `roblox/src/server/World/LogosRhemaTemplePrototype.server.luau` | 333 |
| World | `roblox/src/server/World/RidgeviewLandscapeStudy.server.luau` | 332 |
| World | `roblox/src/server/World/CuriosityArchive.server.luau` | 173 |
| Client | `roblox/src/client/Bootstrap.client.luau` | 38 |
| Client | `roblox/src/client/Controllers/MobileHUDController.luau` | 394 |
| Client | `roblox/src/client/CuriosityArchiveHUD.client.luau` | 64 |
| Test | `roblox/tests/foundation.spec.luau` | 192 |

**Supporting files read in full:** `roblox/default.project.json` (Rojo mapping), `roblox/.stylua.toml`, `roblox/selene.toml`, `roblox/rokit.toml`, `roblox/README.md`, `.github/workflows/roblox-validation.yml`, root `AGENTS.md`.

**Documentation read:** `ANIMAL_COMPANION_ROSTER_V0.1.md`, `COMPANION_3D_ASSET_PIPELINE_V0.1.md`, `COMPANION_QOL_CATALOG.md`, `ACCEPTANCE_TESTS.md`, `FOUNDATION_V0.1.md`, `CI_AND_STUDIO_TESTING.md`, `ANDROID_WORKFLOW.md`, `CANON_ADAPTATION.md`, `MULTIPLAYER_CHOSEN_ADAPTATION_PROPOSAL.md`, `OPENING_VERTICAL_SLICE.md`, `RIDGEVIEW_LANDSCAPE_STUDY.md`, `LOGOS_RHEMA_TEMPLE_VISUAL_PROTOTYPE.md` (plus the remaining `roblox/docs/*.md` skimmed for runtime claims).

### Verification actually performed by me

| Check | Tool | Result |
|---|---|---|
| Regression suite | `lune 0.10.5` (the pinned version) | **PASS** — `tests/foundation.spec.luau` exits 0, "Foundation and companion ownership rules passed." |
| Format compliance | `stylua 2.5.2 --check src tests` (pinned version) | **7 of 18 files fail** — all 7 outside the CI gate list |
| CI history | GitHub Actions API (read-only) | 88 runs on the branch; **#88 success** on the audited tip; **#84 success** (the README's claim is true) |
| CI failure forensics | Run #81 job steps + logs | Failed at `selene src tests` — 2 warnings (a deprecated `Enum.Font.GothamSemibold`, an unused `plinth` variable), **both since fixed**; #82/#83 were cancelled by the concurrency group |
| Lint cleanliness | CI run #88 (includes `selene src tests`) | 0 errors / 0 warnings / 0 parse errors |
| Roblox cylinder axis | Roblox Creator Docs + engine reference | **Cylinder's long axis is local X**, cross-section in Y–Z — used to confirm A7 below |
| `os.clock()` semantics | Roblox Creator Docs (`os` library) | **Monotonic elapsed time**, not CPU time — a suspected throttle defect was **discarded**, not reported |
| Runtime geometry counts | Source-derived by expanding the builder loops | 177 (temple) + 112 (Ridgeview) + 22 (archive) = **311 parts instantiated at runtime**; Ember placeholder = 27 parts per player |
| Branch/PR state | GitHub API (read-only) | 5 open PRs, **none for the Roblox branch**; branch-protection endpoint returns 403 (unverifiable with this token) |

**Not done (deliberately):** no Roblox Studio run, no Rojo build executed locally, no emulator, no device, no Open Cloud execution, no Roblox place upload.

---

## 2. Confirmed findings (Claude's, re-verified independently)

### CF-01 — Missing pathfinding — **CONFIRMED**

`CompanionActorService.luau:404-445`. The follow loop computes
`target = root.CFrame * FOLLOW_OFFSET * idleOffset` and `PivotTo(current:Lerp(target, alpha))`.
There is no `PathfindingService`, no raycast, no obstacle test, no stuck detection and no recovery.
The companion therefore interpolates toward a point **through** walls, the temple's 16 interior columns, the 48 bench parts and the archive walls. It will read as a companion sliding through solid geometry.

Consequences against the project's own requirements: `FQ-04 Obstacle Navigation` (Must), `FQ-05 Safe Recall` (Must), roster doc §5 "Safe recovery if stuck", asset pipeline §7 "If pathfinding fails, recover to a safe nearby position without teleporting through mission barriers" — **all unimplemented**.

### CF-02 — Missing non-Ember companion actors — **CONFIRMED, and worse than stated**

`CompanionActorService.luau:311`:
```lua
if character == nil or snapshot == nil or snapshot.equippedCompanion ~= "ember" then
    destroyActor(player)
    return
end
```
Any equipped companion other than Ember **destroys the actor**. Fox, Owl and Horse are owned by default
(`CompanionOwnershipPolicy.DEFAULT_OWNED_COMPANIONS`) and are selectable, but selecting one yields
**no companion at all**.

Compounding it, `MobileHUDController.luau:261` — `toggle.Visible = currentCompanion == "ember"` — hides the
command panel for the same three. So equipping Fox leaves the player with **no companion and no commands**.
The acceptance test at `ACCEPTANCE_TESTS.md:85` treats "selecting another owned companion removes the Ember actor"
as correct behaviour; it is correct *for the current scope*, but it means three of four free companions are
non-functional rather than "unfinished".

### CF-03 — Incomplete command behaviour — **CONFIRMED**

`PlayerStateService.SetEmberCommand` writes `state.emberCommand = command` and returns. A full grep of
`src/` shows the only readers of `emberCommand` are the HUD label (`MobileHUDController.luau:256, 380-381`).
**No command produces any world effect**: no movement, no animation on the placeholder, no state machine, no
per-command context check. `Attack` — which the canon registers as an approved command label — has no behaviour
and, importantly, **no bounded substitute**: `CANON_ADAPTATION.md` warns "do not treat command availability as
approved AI behaviour", and combat is explicitly behind a design gate. A command named `Attack` that does
nothing is safer than one that attacks, but the gap must be closed deliberately, not by accident.

### CF-04 — Mobile HUD overlap — **CONFIRMED (geometry); exact runtime overlap is BLOCKED**

`MobileHUDController.luau`: the companion toggle is anchored bottom-**left** at `(0, 16, 1, -18)` (142×46) and the
Ember toggle bottom-**right** at `(1, -16, 1, -18)` (112×46). These are precisely the corners occupied by Roblox's
default mobile thumbstick (bottom-left) and jump button (bottom-right), and the two command panels open upward
from the same corners (`(1,-16,1,-74)` 184×294 and `(0,16,1,-74)` 184×214). The code sets
`IgnoreGuiInset = false`, which handles the **top** inset but not the bottom control zones.

A second, independent overlap: the Curiosity Archive HUD is **top-right** (`(1,-14, 0,14)`, 218×42) while the
mission header is **top-left** (`(12,12)`, 220×54). On a 360-logical-pixel portrait phone these overlap.
Both are unchecked acceptance items (`ACCEPTANCE_TESTS.md:60, 65`).

### CF-05 — Currency validation — **PARTIALLY CONFIRMED**

**Correct:** `CurrencyService.AwardFromServer` validates the currency against an allowlist, rejects NaN, zero,
negative and fractional amounts, and requires a non-empty context key.

**Incomplete — three gaps:**
- The **`contextKey` is validated and then discarded**. There is no per-player set of consumed keys anywhere in
  the codebase, so the same reward can be awarded repeatedly by any caller that passes the same key. The parameter's
  name promises idempotency that does not exist.
- `PlayerStateService.AdjustCurrency` (the function actually performing the change) applies **no validation
  whatsoever** — negative, fractional and NaN amounts are accepted, and balances can go negative. The boundary
  exists only one layer up, so any future server caller can bypass it.
- **Nothing calls the currency path at all.** `AwardFromServer` has zero call sites; there is no reward flow, no
  earning, no spending. Balances are always 0 and 0.

### CF-06 — Context-key deduplication — **CONFIRMED**

`CurrencyService.luau:18, 28-30, 33`. `contextKey: string` is type-checked and non-emptiness-checked, then never
read again — the function returns `PlayerStateService.AdjustCurrency(player, currency, amount)` and drops it.
No deduplication state exists in `CurrencyService`, `PlayerStateService` or anywhere else. **The
duplicate-protection the parameter implies is absent.**

### CF-07 — CI permissions and auto-commit behaviour — **CONFIRMED**

`.github/workflows/roblox-validation.yml`:
- **Line 18-19: `permissions: contents: write`** — the workflow can write to the repository. It needs this only
  because of the auto-commit step, so the write scope is a consequence of that step, not of the validation itself.
- **Lines 53-71: the workflow formats and then commits and pushes directly to `btv/roblox-foundation-001`**,
  as `github-actions[bot]`, on every push. That is a self-modifying pipeline writing to a branch outside the
  repository's own draft-PR governance.
- **The auto-commit re-triggers the workflow**: the push it makes touches `roblox/**`, which matches the `paths`
  filter, so every push produces a second run (visible in the run history: #79→#88 with paired runs).
- **The concurrency group cancels in-progress runs** (`cancel-in-progress: true`, and #82/#83 were cancelled).
  A cancelled run can be interrupted between `git commit` and `git push`.
- **Third-party actions are pinned to mutable tags, not SHAs**: `actions/checkout@v4`, `CompeyDev/setup-rokit@v0.2.1`.
  With `contents: write` available, that is a supply-chain surface.
- **The branch-protection endpoint returns 403** for this token, so I **cannot confirm** whether
  `btv/roblox-foundation-001` is protected. **UNKNOWN.**

### CF-08 — Curiosity Archive shared-state issues — **CONFIRMED, mechanism identified**

The specific shared-state defect is in `CuriosityArchive.server.luau:157`:
```lua
entryPrompt.ObjectText = "Curiosity Archive • Find 3 Curio Marks"
```
`entryPrompt` is **one shared `ProximityPrompt` instance**. When one player without the unlock presses Enter, the
text changes **for every player in the server**, and it is never restored. Separately, the prompt's text is
hardcoded at creation as `"Curiosity Archive • 0/3"` (line 108) and is **never updated to the individual
player's count** — a player with 3/3 who walks up still sees "0/3" until someone else fails an entry attempt.

Other archive observations:
- Per-player discovery state **is** correctly isolated (`ArchiveService` keyed by `UserId`, verified by the test
  suite at `foundation.spec.luau:184-185`) — that part of the concern does **not** hold.
- `ArchiveService.AddPlayer`/`RemovePlayer` are called **only** by the archive world script
  (`CuriosityArchive.server.luau:139, 148`), **not** by `Bootstrap.server.luau`. If that world script is absent
  from a place, `ArchiveService.Collect` returns `false` for every request and the HUD never appears.

### CF-09 — CompanionActorService movement and replication — **PARTIALLY CONFIRMED**

**Sound:** the follow is server-authoritative and rate-bounded at 15 Hz (`FOLLOW_UPDATE_INTERVAL = 1/15`), the
exponential smoothing (`alpha = 1 - exp(-5.5 * elapsed)`) is frame-rate independent, every placeholder part is
`Anchored = true` (so the server's CFrame **does** replicate), the imported-rig path anchors the root and leaves
Motor6D parts free, and the `destroyActor` path runs on leave and on character removal.

**Not sound:**
- The **walk animation is driven by the player's velocity**, not the companion's — `updateAnimation` reads
  `root.AssemblyLinearVelocity` where `root` is the **player's** `HumanoidRootPart` (line 384, called with the
  player's root at line 433). The companion plays `Walk_Cycle` whenever the *player* moves, even while it is
  still or lagging. The acceptance wording "Idle/walk transitions follow only the owner's horizontal movement"
  describes this as intended, but it means the animation cannot represent the companion's own state.
- **No pathfinding** (CF-01), so "movement" is a straight-line lerp.
- The **placeholder has no acknowledgement animation**: `createEmber` returns no `animationTracks`, so
  `AcknowledgeCommand` returns at line 363 and the "clear command acknowledgement" promised by the Ember catalog
  entry produces **no visual acknowledgement at all** with the shipped art.
- The procedural tail (`TailMid`, `TailTip`) is repositioned by **world-space CFrame assignment** after
  `PivotTo` (lines 436-443), which places the parts outside the model's pivot relationship. It works for the
  un-jointed placeholder only.
- `Players:GetPlayerByUserId(userId)` is called **per actor, per 1/15 s tick** (line 415) — a needless lookup;
  the `Player` reference should be cached on the actor record.
- **No replication quality measurement exists** (Studio/multiplayer blocked).

---

## 3. Additional problems discovered (not in the previous audit)

### A1 — **HIGH** — The seven commands are labels with no executor — **CONFIRMED**
See CF-03. Recommendation in §5.

### A2 — **HIGH** — The opening slice cannot be completed by a first-time player — **CONFIRMED (source-derived)**
`OpeningMission.server.luau:134-164` places the Ridgeview departure prompt at `CFrame.new(0, 1.5, -127)` — an
invisible 8×1×2 trigger on the forecourt lawn, roughly **50 studs beyond the temple's entrance canopy**
(the canopy is at z = −78, the walkway runs z ∈ [−112, −70], the forecourt ground spans z ∈ [−154, −54]).
There is **no sign, marker, arch or guide** at that point: the temple's only text signage is
`"LOGOS RHEMA TEMPLE"` above the entrance, and the trail posts are in Ridgeview, not here.

Worse, the objective HUD gives no hint. During the `report_accessed` phase the objective string is
`"Scout Report opened — authored evidence pending"` (`MissionService.luau:28`) — there is **no
"Travel to Ridgeview" objective phase at all**; the travel prompt *is* the transition. A player who opens the
Scout Report is left standing in the foyer with a dead-end objective and no pointer to the lawn.

### A3 — **HIGH** — No persistence of any kind — **CONFIRMED (documented, but load-bearing)**
Mission phase, currency, equipped companion, ownership map and archive progress all live in in-memory tables
keyed by `UserId` and are discarded on `PlayerRemoving`. `FOUNDATION_V0.1.md` §6 and the service header comments
state this deliberately and correctly — but it means `FQ-12 Persistence` (Must) and roster doc §5 "Reliable
persistence of selected companion and earned ownership" are unmet, and every player loses progress on every
rejoin. The honest labels are already in place; what is missing is the schema.

### A4 — **MEDIUM** — The CI format gate covers 6 of 18 files, and 7 files fail the format check — **CONFIRMED (tool-verified)**
The workflow's format steps (`roblox-validation.yml:53-58, 63, 69`) name exactly six files:
`MissionService`, `CompanionActorService`, `Bootstrap.server`, `OpeningMission.server`,
`MobileHUDController`, `foundation.spec`. Running the **pinned** `stylua 2.5.2 --check src tests` over the whole
tree reports diffs in **seven** files — all of them outside the gate list:

```
src/server/Services/CompanionOwnershipPolicy.luau
src/server/Services/CurrencyService.luau
src/server/Services/PlayerStateService.luau
src/server/World/CuriosityArchive.server.luau
src/server/World/LogosRhemaTemplePrototype.server.luau
src/server/World/RidgeviewLandscapeStudy.server.luau
src/shared/CompanionCatalog.luau
```

The six gated files pass. So `ACCEPTANCE_TESTS.md:153` ("StyLua formatting check passes in CI (Run #84)") is
**true but narrower than it reads** — it means "the six listed files are formatted". The obvious next change —
widening the gate to `src tests` — **fails CI immediately** and must be paired with a formatting pass.
`selene src tests` *does* cover every file ✓, so linting is complete; only formatting is partial.

### A5 — **MEDIUM** — Ridgeview tree trunks are geometrically wrong — **CONFIRMED (externally + internally)**
`RidgeviewLandscapeStudy.server.luau:261-270`:
```lua
local trunk = makePart(tree, "Trunk", Vector3.new(2.1, height, 2.1),
    CFrame.new(base + Vector3.new(0, height / 2, 0)), bark, Enum.Material.Wood)
trunk.Shape = Enum.PartType.Cylinder
-- comment: "Roblox cylinder parts use their local Y axis as the long axis; keep the trunk upright."
```
The Roblox Creator Docs and engine reference are explicit: a `Cylinder` Part's **long axis is its local X**, and
the circular cross-section lies in Y–Z. With `Size = (2.1, height, 2.1)` and no rotation, each "trunk" is a
**2.1-stud-long horizontal tube whose elliptical cross-section is `height` tall × 2.1 deep** — a thin vertical fin,
not a post. The in-code comment states the axis rule incorrectly.

The same repository contains the **correct** implementation: `LogosRhemaTemplePrototype.server.luau:298` uses
`Vector3.new(11, 2.2, 2.2)` with `CFrame.Angles(0, 0, math.rad(90))` — length along X, rotated 90° about Z so it
stands upright. The two builders contradict each other; the Ridgeview one is wrong. All **17** Ridgeview trees are
affected, and each trunk is also a collider, so the collision profile is wrong too.

### A6 — **MEDIUM** — The whole environment is procedural, so visual work requires code — **CONFIRMED**
Both world builders `Instance.new` their geometry at runtime (**177** + **112** + **22** parts, from source-derived
counting). Consequences: (a) nothing is visible or editable in Studio without pressing Play, which directly
constrains the Visual Director's iteration loop; (b) every client receives ~311 newly replicated instances at
join; (c) the `Status` string on each scene (`"not canon-locked or Studio-verified"`) can never be seen in the
Studio hierarchy. `LOGOS_RHEMA_TEMPLE_VISUAL_PROTOTYPE.md` already flags the absence of measured geometry counts.

### A7 — **MEDIUM** — The command allowlist is enforced in only one place — **CONFIRMED**
`Bootstrap.server.luau:86` checks `allowedCommands[command]`; `PlayerStateService.SetEmberCommand`
(lines 57-68) accepts **any string** and stores it. The remote path is safe, but the service method is not
self-validating — the next caller (a future premium shortcut, a preset loader, an NPC command) inherits an
unchecked write. Defence in depth is cheap here: validate against `GameConfig.EmberCommands` inside the service.

### A8 — **MEDIUM** — The companion selection panel's button order is non-deterministic — **CONFIRMED**
`MobileHUDController.luau:348` iterates `CompanionCatalog`, a **string-keyed** table. Luau does not guarantee an
order for string-keyed iteration, so the four companion buttons appear in a **different order every session**
(the `order` counter inherits the iteration order). Cosmetic, but it reads as unfinished in a premium selector.

### A9 — **MEDIUM** — Mission progression implements 4 of the 6 approved sequence stages — **CONFIRMED**
`GameConfig.OpeningSequence` lists six stages (Communion → Covenant alert → Scout Report/evidence → Journey to
Ridgeview → Ridgeview investigation/response → Final report). `MissionService` defines **four** phases
(`communion_context`, `covenant_alert`, `report_accessed`, `ridgeview_arrival`); the "Journey" stage exists only as
the prompt, and "Investigation/response" and "Final report" do not exist. The HUD header reads
`"OPENING SEQUENCE • n / 6"` and clamps to 6, so it **stalls at 4 / 6** forever. `OPENING_VERTICAL_SLICE.md`
correctly records the last two as unimplemented ✓ — the finding is that the HUD denominator advertises six.

### A10 — **LOW–MED** — Mission and archive scripts hard-depend on the world builders — **CONFIRMED**
`OpeningMission.server.luau:14-18` waits on `BTV_World`, `LogosRhemaTemple_VisualPrototype`, `Interior` and
`Ridgeview_LandscapeStudy`; `CuriosityArchive.server.luau:10-11` waits on `BTV_World` and
`Ridgeview_LandscapeStudy`. These instances exist **only if the procedural builders ran**. `WaitForChild` yields
indefinitely rather than failing loudly, so a rename or a disabled builder silently disables the entire opening
mission — with no error, only a frozen player. The world scripts already guard against duplicates; they do not
guard against absence.

### A11 — **LOW–MED** — Three copies of the seven-command list, with no test tying them together — **CONFIRMED**
`GameConfig.EmberCommands` (server allowlist), `CompanionCatalog.Ember.CoreCommands` (data) and
`MobileHUDController.COMMANDS` (client) each list the seven commands independently. `foundation.spec.luau:74`
asserts only that the catalog list has **seven** entries — not that it **matches** the other two. A rename in one
place would silently break the client panel or the server allowlist.

### A12 — **LOW** — The first command in the server's first 0.4 s is dropped — **CONFIRMED (edge case)**
`Bootstrap.server.luau:80-82`: `previous = lastCommandAt[player.UserId] or 0`, compared against `os.clock()`.
Within the first 0.4 s of server uptime the elapsed clock is below the threshold and the request is discarded
without feedback. Negligible in practice; worth a `previous = -math.huge` default.

*Note on `os.clock()`:* the current Roblox Creator Docs describe it as **monotonic elapsed time** ("returns
elapsed time in seconds since an arbitrary baseline"), so the throttle is sound on current Roblox. Older community
documentation and the Blueprint node description still describe it as **CPU time**, under which this throttle
would become a multi-second lockout. **UNKNOWN** whether the platform's behaviour is stable across versions.
Pinning the throttle to `workspace:GetServerTimeNow()` would remove the ambiguity.

### A13 — **LOW** — `getDisplayTitle` can index outside the table — **CONFIRMED (edge case)**
`ArchiveService.luau:38`: `math.floor(currentTime / 604800) % #DISPLAY_TITLES + 1`. For a negative timestamp the
Luau `%` yields a negative remainder, producing index 0 or lower → `DISPLAY_TITLES[index]` is `nil` → the function
returns `nil` where its type says `string`. Only server-controlled input reaches it today.

### A14 — **LOW** — The root `AGENTS.md` describes only the Godot project — **CONFIRMED**
`AGENTS.md` opens with "Engine: Godot 4.x, GDScript" and contains no Roblox section, while the repository now
carries a complete Roblox track with different rules (Luau, Rojo, Studio, Luau-specific canon boundaries). An
agent or contributor reading the root file will apply Godot rules to Roblox work. `roblox/README.md` carries a
clear separation rule ✓ — but the file agents actually read does not.

### A15 — **LOW** — The Roblox track has no pull request — **CONFIRMED**
Five PRs are open on the repository; **none** involves `btv/roblox-foundation-001`. The branch has 88 CI runs
directly on it, and CI itself pushes to it. The repository's own protocol is draft-PR review.

### A16 — **LOW** — Version marker mismatch — **CONFIRMED**
`roblox/README.md` header says "Foundation: **v0.2** in progress"; `GameConfig.FoundationVersion` is `"0.1"`; the
foundation document is `FOUNDATION_V0.1.md`. The README also still cites "latest confirmed Run #84" while #88 is now
the latest.

### A17 — **LOW** — The archive service's player lifecycle is owned by an optional world script — **CONFIRMED**
See CF-08. `ArchiveService.AddPlayer`/`RemovePlayer` are called only from `CuriosityArchive.server.luau`, never from
the server bootstrap. Session ownership of a player-facing service should sit in the bootstrap.

### A18 — **INFO** — Companion parts are `CanQuery = false` — **CONFIRMED**
`CompanionActorService.luau:59` sets `CanQuery = false` on every placeholder part (and line 192 on imported parts).
Correct for a decorative follower today, but it makes the companion invisible to any future raycast or
proximity interaction, and it will need revisiting before "interact with your companion" exists.

### A19 — **INFO** — No movement, camera or touch-control code exists at all — **CONFIRMED**
`roblox/src/client/` contains only `Bootstrap.client`, `CuriosityArchiveHUD.client` and
`Controllers/MobileHUDController`. There is **no joystick, camera controller, or touch movement**; the game relies
entirely on Roblox's default controls. `FOUNDATION_V0.1.md` §8 and the acceptance plan assume touch-first movement
and camera; neither is implemented.

### A20 — **INFO** — No NPC, enemy or combat systems exist — **CONFIRMED**
Nothing in `src/` creates NPCs, enemies, damage, health or combat. The Veil enemy encyclopedia is canon-only.
This is consistent with the documented scope ✓ — recorded so it is not mistaken for an omission.

---

## 4. Verification of Claude's findings — summary table

| # | Claude finding | Verdict | Note |
|---|---|---|---|
| 1 | CompanionActorService movement and replication | **PARTIALLY CONFIRMED** | Server-authoritative, 15 Hz, anchored replication: sound. Pathfinding absent; walk animation driven by the *player's* velocity; placeholder has no acknowledgement clip; `GetPlayerByUserId` per tick; replication quality unmeasured. |
| 2 | Missing pathfinding | **CONFIRMED** | Straight-line lerp to a fixed offset; no raycast, no avoidance, no recovery. FQ-04/FQ-05 unmet. |
| 3 | Missing non-Ember companion actors | **CONFIRMED** | Stronger than stated: Fox/Owl/Horse are owned and selectable, but selecting one **destroys** the actor and **hides** the command panel. |
| 4 | Incomplete command behaviour | **CONFIRMED** | `emberCommand` is stored and echoed; nothing else reads it. No executor exists for any of the seven, including Attack. |
| 5 | Mobile HUD overlap | **CONFIRMED (geometry)** | Bottom-left/bottom-right toggles sit in Roblox's default thumbstick/jump-button zones; a second top-bar overlap exists on narrow screens. Runtime confirmation BLOCKED on Studio. |
| 6 | Currency validation | **PARTIALLY CONFIRMED** | Boundary validation is real (allowlist, integer, positive, NaN-safe). But `contextKey` is discarded, `AdjustCurrency` validates nothing, and no caller awards currency. |
| 7 | Context-key deduplication | **CONFIRMED** | The key is validated then dropped; no consumed-key state exists anywhere. |
| 8 | CI permissions and auto-commit behaviour | **CONFIRMED** | `contents: write` + direct bot commits to the branch; the commit re-triggers the workflow; concurrency cancels can interrupt a commit; actions pinned to tags, not SHAs. Branch protection UNKNOWN (403). |
| 9 | Curiosity Archive shared-state issues | **CONFIRMED** | Mechanism identified: the shared `ProximityPrompt.ObjectText` is mutated by one player's failed entry and never restored, and the prompt text is hardcoded "0/3". Per-player discovery isolation is **correct** — that sub-concern does not hold. |

**None of the nine is incorrect.** Two are partial, and in both cases the missing half is specified above.

---

## 5. Architectural recommendations — supporting all eight animals

### 5.1 The shape that avoids both a primitive-placeholder look and an over-engineered system

The eight animals must not become eight bespoke systems, and they must not ship as identical primitives. The
cheapest structure that satisfies both is **one controller + one contract + one parameter block per animal**, with
the animal's identity expressed as **data**:

**One shared runtime contract** — generalise `CompanionRigContract` from Ember-specific to per-animal:
```
ServerStorage/BTVAssets/Companions/<AnimalId>/
  Model        PrimaryPart = "CompanionRoot", Motor6D-connected or Bone-hierarchy
  AnimationController/Animator
  Animations/  <state>.rbxassetid://...
```
Keep the existing fail-closed validation verbatim — it is the best security control in the codebase (no
`Script`/`LocalScript`/`ModuleScript` descendants, Motor6D connectivity from the root, a real `Animator`, a valid
`rbxassetid://` pattern, and a safe fallback on any failure). Extend it by **state name → clip name** rather than
by hardcoded clip names, and raise the required clip set from 3 to the pipeline's own baseline
(`COMPANION_3D_ASSET_PIPELINE_V0.1.md` §5 lists 12 states: idle, alert, walk, trot, turns, settle, follow, hold,
regroup, rest, acknowledge, transitions).

**One controller** — refactor `CompanionActorService` into a `CompanionController` that is entirely
parameter-driven. Every animal-specific value lives in `CompanionCatalog`:

| Field | Purpose |
|---|---|
| `RigFamily` | `quadruped_canine` / `quadruped_feline` / `quadruped_heavy` / `equine` / `avian` |
| `ModelName` | folder name under `BTVAssets/Companions` |
| `Animations` | state → clip mapping |
| `Scale`, `FollowOffset`, `FollowSpeed` | presentation and formation |
| `Surface` | `ground` / `perch` / `aerial` |
| `SpeedProfile` | walk/trot multipliers for path following |
| `CommandSet` | which of the seven commands apply (Ember's set stays exclusive to Ember) |

**One parametric placeholder builder** — this is the key to eliminating primitive placeholders cheaply. Instead of
hand-building 27 parts per animal, write a single `buildPlaceholder(definition)` that composes a silhouette from a
small parameter block: body length/height/width, neck length, head size, ear type (perked/rounded/tufted), tail
type (bushy/slender/long/short), leg length, and a palette. The five rig families then produce visibly distinct
animals from one function, and each animal's look is a **data row**, not new code. This satisfies the pipeline
rule "Do not use a single primitive-part assembly as the final visual asset" **for the final art**, while making
the interim state unmistakably a stylised placeholder rather than a copy-pasted blockout — and it costs one
function instead of eight.

### 5.2 Movement and pathfinding

One shared `CompanionPathfinder` (server) using `PathfindingService`:
- A per-animal state machine — `Follow`, `Hold`, `Regroup`, `Recall`, `Rest` — with `SpeedProfile` per animal.
- Waypoint following with a radius, plus a **progress watchdog**: if displacement over N seconds falls below a
  threshold, abandon the path and re-plan; after M failed attempts, perform a **safe recovery** (return to the last
  valid position) rather than a teleport through mission barriers — exactly what pipeline §7 requires.
- `PathfindingService` costs server CPU: compute on the **server**, cache waypoints, and recompute only when the
  target moves beyond a threshold (e.g. 4 studs), never per frame.

### 5.3 Lifecycle, ownership and replication

- Keep server ownership: one actor per player, keyed by `UserId`, destroyed on leave/respawn-switch ✓ (already correct).
- Add the missing safe-context rule: the roster and pipeline both require that **companion switching happens only in
  approved safe contexts** — currently switching is allowed anywhere.
- **Move the visual transform to the client.** Today the server `PivotTo`s an anchored model at 15 Hz per player:
  15 Hz visible stepping, and one replicated transform stream per companion. The standard Roblox pattern is:
  the **server** owns the companion's *state* and broadcasts a compact target (position + facing + animation state)
  at ~10 Hz; the **client** owns the *visual* model and interpolates. This keeps authority where it matters and
  removes the snapping. If the team prefers to keep the current model, at minimum raise the smoothing response and
  interpolate on the client.
- Animate on the **companion's own** state, not the player's velocity (A/CF-09).

### 5.4 Animation

- One state machine, one animation table, per-animal clip names. Walk/trot/turn/settle/rest clips per rig family.
- The pipeline's fairness rule must be enforced in code: **animation timing must not change command effectiveness**
  (pipeline §5). If a Falcon's acknowledgement clip is shorter, the *result* must still take the same time.
- Keep the `AnimationController`/`Animator` contract and the fail-closed fallback.

### 5.5 Mobile

- One companion per player, LOD and visibility distance, no shadow casting on small parts, no per-frame allocations
  in the follow loop (the current loop allocates a `CFrame` per actor per tick — minor but free to fix).
- Cache the `Player` reference on the actor record instead of `GetPlayerByUserId` per tick.
- Reduce the nameplate's `MaxDistance` (45 → ~30) and drop the nameplate entirely for non-owner clients if
  profiling shows a cost.

### 5.6 The eight-animal rollout, staged so the roster never blocks the free experience

| Stage | Deliverable | Gate |
|---|---|---|
| A | Refactor to the shared controller + parametric placeholder builder + generalised contract | The existing 8-animal catalog renders **all eight** placeholders; no behaviour change |
| B | Pathfinding + command state machine for Follow/Hold/Regroup | FQ-01…FQ-05 evidenced in a Studio multiplayer test |
| C | Command execution (all seven, with Attack bounded to a non-combat intercept until combat is gated) | Canon review of Attack semantics |
| D | Persistence schema + DataStore lifecycle | Schema version, migration, failure policy, autosave cadence — per `FOUNDATION_V0.1.md` §6 |
| E | Ember reference → final Ember model (the pipeline's own gate) | Creator approves the silhouette |
| F | Fox, Owl, Horse as free role representatives | Free roster complete; every mission completable free |
| G | Eagle, Bear, Leopard, Falcon as premium candidates | Role-equivalence tests against Owl/Ember/Fox pass **before** any product work |

**Phase A is the highest-value single change**: it is what makes the eight-animal promise true today, without
touching canon, premium policy or the free-equivalent guarantee.

---

## 6. Gameplay systems — current state and recommendations

| System | State | Verdict | Recommendation |
|---|---|---|---|
| **Seven commands** | Stored, echoed, never executed | **CONFIRMED — no behaviour** | Build `CompanionCommandService` with a per-command state machine. `Attack` must be bounded: canon says Ember is not a weapon and combat is gated — propose "intercept/alert" semantics until a combat design gate exists. |
| **Mission progression** | Server-owned, ordered, rejects skips/repeats, per-player | **SOUND** — well built | Extend to stages 5 and 6 once canon content exists; fix the HUD denominator (A9); make the travel objective explicit (A2). |
| **Player data / persistence** | None | **CONFIRMED — session-only** | Schema before DataStore: version, defaults, autosave cadence, shutdown flush, session locking, migration, corruption policy, data minimisation (`FOUNDATION_V0.1.md` §6 lists these — follow it exactly). |
| **Currency & rewards** | Boundary exists; **no caller**; balances always 0/0 | **CONFIRMED — no reward path** | Keep the boundary; add the consumed-context-key store; validate inside `AdjustCurrency`; add a floor; then wire the first server-originated award. |
| **NPC / enemy systems** | None | **OUT OF SCOPE** (A20) | No action. Keep behind the design gate. |
| **Multiplayer security** | Server-authoritative, allowlisted, throttled, premium fail-closed | **SOUND with gaps** | Close the gaps in §6.1 below. |
| **Mobile controls** | HUD only; **no joystick/camera code** (A19) | **CONFIRMED — defaults only** | The HUD is the only touch surface in the project; it collides with the default controls (CF-04). Either take control of the thumbstick via `PlayerModule`/custom controls or move the HUD clear of the default zones. |
| **World interaction** | `ProximityPrompt` with server distance re-checks | **SOUND** | Keep the re-check pattern; fix the shared prompt mutation (CF-08). |

### 6.1 Security concerns — consolidated

**Good, keep as is:** server authority for missions/currency/companions; command allowlist; per-player rate
throttling applied *before* payload inspection; premium fail-closed even against a forged ownership map; per-player
ownership-map isolation; the imported-rig validator rejecting executable code and broken Motor6D graphs;
`GetInitialState`/`GetMissionState` returning only the caller's snapshot; the archive's allowlisted mark IDs and
duplicate rejection.

**Gaps to close, in order:**

1. **Currency context-key deduplication** (CF-06) — a reward can be granted repeatedly.
2. **`AdjustCurrency` performs no validation** (CF-05) — negative/fractional/NaN amounts, no balance floor.
3. **The command allowlist lives only in the remote handler** (A7) — move validation into the service.
4. **Shared `ProximityPrompt` mutation** (CF-08) — one player's action changes everyone's UI.
5. **Archive session lifecycle owned by an optional world script** (A17) — move to the bootstrap.
6. **`SetEmberCommand` accepts any string** — defence in depth (same as 3).
7. **No abuse ceiling on total awards** — with a dedup store, also cap awards per session.
8. **Supply chain:** third-party actions pinned to tags with `contents: write` available (CF-07) — pin to SHAs.
9. **Branch protection UNKNOWN** — verify out of band whether `btv/roblox-foundation-001` is protected; if it is,
   the CI auto-commit would fail on push (and would have been failing loudly — the runs are green, so it is likely
   unprotected, but I could not confirm the endpoint).

**Explicitly not a finding:** the `os.clock()` throttle. Current Roblox documentation describes `os.clock()` as
monotonic elapsed time, so the 0.4 s window is sound; I raised the CPU-time reading, checked it, and discarded it.

---

## 7. Android optimisation recommendations

Ordered by expected impact. All are **PROPOSED** — none are measured, because no device profiling has been done.

1. **Move static geometry out of runtime generation** (A6). 311 replicated instances per join is avoidable; a
   Rojo-synced place file ships them as static content. This is also the single biggest unlock for the Visual
   Director's workflow.
2. **Author the world in Studio, keep scripts for logic.** Visual iteration currently requires code edits and a
   Play-mode reload.
3. **Reduce the collider count.** Of the 177 temple parts, 48 are bench parts (seat + back + 2 legs each) and 16
   are columns; the trees' canopies and the hillside masses already avoid collision ✓ — apply the same to benches
   (a single collider per bench row) and to shrub/canopy parts.
4. **Client-side companion interpolation** (§5.3) — removes 15 Hz transform replication per companion and the
   visible stepping.
5. **Cap `PointLight` count** — 5 in the temple now; keep lights small, `Shadows = false` ✓ (already correct),
   and prefer baked/ambient lighting for the mobile profile.
6. **Disable shadow casting on decorative parts** — `CastShadow = true` is set on nearly every part; shrubs, canopies,
   sills and signs do not need to cast.
7. **Fix the Ridgeview trunk geometry** (A5) — wrong shapes also mean wrong colliders and wrong draw geometry.
8. **HUD layout for real phone metrics** (CF-04) — move the two bottom toggles clear of the default thumbstick and
   jump button; use `GuiService`/safe-area insets; set the command-panel buttons to ≥44 px; make the header,
   mission card and archive HUD stack rather than compete on narrow screens.
9. **Quality ladder** — the docs call for mobile/standard/high profiles (§7 of `FOUNDATION_V0.1.md`); nothing
   implements one. `LevelOfDetail`/`StreamingEnabled` on the hillside masses and a distance-based visibility
   rule for the archive are the first candidates.
10. **Measure before raising budgets** — the acceptance plan already says this; keep it.

---

## 8. Dependencies and implementation priorities

### 8.1 Blocking dependencies (in order)

| # | Dependency | Blocks | Owner |
|---|---|---|---|
| D1 | **Roblox Studio access** (Windows/macOS) | Every runtime claim: Play Solo, multi-client, touch, device profiling, rig import | Creator — the only true blocker |
| D2 | **A reviewed persistence schema** | FQ-12, ownership persistence, archive persistence, currency continuity | Creator + coordinator |
| D3 | **Canon-approved content for stages 5-6** (Ridgeview investigation/response, final report) | The 4/6 → 6/6 sequence, the "Final report" phase | Creator / coordinator |
| D4 | **Attack command semantics** | The command executor; combat is behind a design gate | Creator + canon authority |
| D5 | **Ember reference asset** (from the approved BTV visual assets) | The Ember visual benchmark gate → all eight final models | Creator / Visual Director |
| D6 | **The creator decision on the multiplayer "every player is a Chosen" proposal** | `MULTIPLAYER_CHOSEN_ADAPTATION_PROPOSAL.md` vs the locked "Asher Vance remains the sole Chosen" | Creator — see §9 |
| D7 | **Three Roblox animation IDs** mapped to the contract names | Any imported-rig animation | Creator / pipeline owner |

### 8.2 Implementation priorities

**P0 — correctness and honesty (no design decisions needed, no new content):**
1. Fix the Ridgeview trunk geometry and its wrong comment (A5).
2. Fix the shared `ProximityPrompt` mutation and the hardcoded "0/3" (CF-08).
3. Implement the currency context-key dedup + validate inside `AdjustCurrency` (CF-01/05/06).
4. Move the command allowlist into `PlayerStateService.SetEmberCommand` (A7).
5. Make the archive's session lifecycle owned by the bootstrap (A17).
6. Widen the CI format gate to `src tests` **after** a formatting pass on the 7 failing files (A4).
7. Deterministic companion button ordering (A8).
8. Fix the HUD denominator and add the travel objective; signpost the travel trigger (A2, A9).
9. Move the archive's `AddPlayer`/`RemovePlayer` and add the missing Roblox section to `AGENTS.md` (A14).

**P1 — the eight-animal architecture (does not need new content):**
10. Generalise `CompanionRigContract` to per-animal state-name mapping (5.1).
11. Build the parametric placeholder builder so **all eight** animals render distinctly (5.1).
12. Refactor `CompanionActorService` into a parameter-driven `CompanionController` (5.1).
13. Add `PathfindingService` follow with stuck detection and safe recovery (5.2).
14. Client-side visual interpolation; animate from the companion's own state (5.3, CF-09).
15. Generalise the command set from "Ember-only" to "per-companion command set" while keeping Ember's seven intact.

**P2 — product depth (needs creator decisions):**
16. Command executor + per-command state machine (needs D4 for Attack).
17. Persistence service (needs D2).
18. Mission stages 5-6 (needs D3).
19. Android profiling pass and the quality ladder (needs D1).

**P3 — governance:**
20. Open a draft PR for the Roblox track instead of pushing straight to the branch (A15).
21. Decide whether CI keeps `contents: write` and auto-commit; if not, use `stylua --check` as a gate only (CF-07).
22. Pin third-party CI actions to commit SHAs (CF-07).

### 8.3 What is already good and should not be disturbed

The server-authority boundary, the premium fail-closed policy, the imported-asset validator, the honesty labelling in
the docs, the pinned-toolchain CI, the acceptance-test structure, and the separation rule between the Godot and
Roblox tracks. **The foundation's problem is not that it was built badly — it is that a small, well-built scaffold
is currently being read as a playable slice.**

---

## 9. Studio-dependent tests that remain BLOCKED

**BLOCKED** — requires Roblox Studio (Windows/macOS) and cannot be performed from this environment.
**UNKNOWN** — requires information or an artefact not present in the repository.

| # | Test | Status |
|---|---|---|
| 1 | Rojo sync into a private test place; DataModel mapping and script placement | **BLOCKED** — Rojo build verified in CI (Run #88), never synced to Studio |
| 2 | Play Solo: server bootstrap, world builders, no runtime errors | **BLOCKED** |
| 3 | Temple prototype builds; foyer/sanctuary entrances traversable; scale and collision of seats, lectern, platform, Communion table | **BLOCKED** — `ACCEPTANCE_TESTS.md` F |
| 4 | Ridgeview scene builds; road/path alignment; lookout reachable without unintended jumps; no spawn traps | **BLOCKED** — F2 |
| 5 | **Ridgeview tree geometry inspection** (A5) — confirm the fin-shaped trunks | **BLOCKED** (source-verified defect; visual confirmation pending) |
| 6 | **Ember actor**: appears, follows at a stable offset, survives respawn, is removed on companion switch, cleanup on leave, no collision/touch/query | **BLOCKED** — F1 |
| 7 | **Ember pathing through the temple columns and benches** (CF-01) | **BLOCKED** — the defect is certain from source; its visual severity is not |
| 8 | Two clients, one server: separate actors, separate snapshots, no cross-contamination | **BLOCKED** — H |
| 9 | Command acknowledgement on the placeholder (A/CF-09) — currently no animation exists | **BLOCKED** |
| 10 | Imported Ember rig: contract satisfied, three clips load, idle/walk/acknowledge playback, respawn, multi-client | **BLOCKED** — no asset imported; prototype is outside the repository |
| 11 | **HUD overlap with the default thumbstick/jump button** (CF-04) on a phone-sized viewport | **BLOCKED** — Studio device emulator |
| 12 | HUD at common phone aspect ratios, safe areas/notches, reduced screen size, no hover/keyboard dependency | **BLOCKED** — E |
| 13 | Curiosity Archive: three marks discoverable, all three required, wall stays shut, per-player isolation, two-player test | **BLOCKED** — J |
| 14 | Archive prompt text behaviour under two players (CF-08) | **BLOCKED** |
| 15 | ProximityPrompt distance checks under movement and teleport abuse | **BLOCKED** |
| 16 | Remote-abuse testing: malformed/unknown/unowned payloads, throttle bypass attempts | **BLOCKED** — acceptance test plan calls it out explicitly |
| 17 | Android frame rate, memory, draw calls, shadow and overdraw cost, streaming behaviour | **BLOCKED** — I |
| 18 | Mobile/standard/high quality profiles | **BLOCKED** — I |
| 19 | Open Cloud Luau Execution as a future CI integration layer | **BLOCKED** — needs a test universe, place and narrowly scoped API key (`CI_AND_STUDIO_TESTING.md` §Roblox engine validation) |
| 20 | Branch protection state for `btv/roblox-foundation-001` | **UNKNOWN** — API returned 403 for this token |
| 21 | Whether `os.clock()` behaves as monotonic elapsed time on the target Roblox client/server versions | **UNKNOWN** — current docs say yes; older community docs say CPU time |
| 22 | **Creator decision: the "every player is a Chosen" + purchasable Asher proposal** (`MULTIPLAYER_CHOSEN_ADAPTATION_PROPOSAL.md`) versus the locked decision that **Asher Vance remains the sole Chosen** | **UNKNOWN — creator decision required.** The document is correctly labelled as a proposal with four unmet approval gates, and **no code implements it**: `GameConfig.Protagonist` is a fixed `asher_vance` and there is no character-selection UI, so the locked decision is currently upheld in code. The two documents simply state different positions, and the proposal must not be read as approved. |
| 23 | Whether the Roblox branch is under the same review discipline as the Godot branches | **UNKNOWN** — no PR exists (A15) |

---

## 10. Final status by label

- **CONFIRMED:** CF-01, CF-02, CF-03, CF-06, CF-07, CF-08 (mechanism identified), A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20.
- **PARTIALLY CONFIRMED:** CF-04 (geometry confirmed; runtime overlap blocked), CF-05 (boundary real, three gaps), CF-09 (replication sound, movement/animation/replication-quality gaps).
- **INCORRECT:** none of the nine prior findings.
- **PROPOSED:** every recommendation in §5, §6, §7 and §8.2 — none implemented; no design decision taken on the creator's behalf; no locked decision changed.
- **UNKNOWN:** items 20, 21, 22 and 23 in §9.
- **BLOCKED:** items 1-19 in §9 — all Studio- or device-dependent.
- **COMPLETED (independently verified by me):** full read of all 18 Luau files, the Rojo mapping, the workflow and 16 documents; the regression suite executed locally with the pinned `lune 0.10.5` (PASS); formatting audited with the pinned `stylua 2.5.2` (7 failing files identified); CI run history and a failing run's job steps and logs inspected; the Roblox cylinder axis and `os.clock()` semantics checked against the Creator Docs.

**No implementation was begun. No source file was modified. No merge, publication, repository-setting change,
paid generation or credit consumption occurred.**

---

## 11. Publication note

This document and its `evidence/` folder were published **after** the audit was completed, as **documentation only**:

- **Branch:** `btv/audit-roblox-independent-2026-11-12`, branched from `btv/roblox-foundation-001` @ `56bd1dd`.
- **PR:** draft, into `btv/roblox-foundation-001`.
- **Contents:** this report plus a reproducible evidence pack
  (`roblox/docs/audits/evidence/`): the pinned-toolchain verification log, the StyLua format-check output, the
  Lune suite run, the CI run-history snapshot, the file inventory, the source-derived geometry counts, and a
  read-only `reproduce-audit-checks.sh`.

No `.luau` file, scene, configuration or workflow was changed by this publication. The audited commit
`56bd1dd` is byte-for-byte the code these findings describe.
