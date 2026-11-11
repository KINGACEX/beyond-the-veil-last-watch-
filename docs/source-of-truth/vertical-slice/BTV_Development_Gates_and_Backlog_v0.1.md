<!-- Historical Library source copy. Preserve source status; reconcile against current canon before use. -->

# BEYOND THE VEIL: THE LAST WATCH
## Development Gates & Prioritised Backlog v0.1

**Date:** 1 November 2026  
**Status:** APPROVED WORKFLOW DIRECTION / PROPOSED TASKS  
**Purpose:** Convert the current design package into a safe, testable Android-first production sequence without pretending an implementation already exists.

---

## 0. Executive decision

BTV should not begin with a large world, high-detail character models, advanced combat, generative NPCs or a broad AI stack. The best next production move is a **small, deterministic, end-to-end vertical slice** that proves the central experience:

**Logos Rhema → Scout Report → travel → Ridgeview investigation → meaningful response → accurate Covenant report.**

The design package is now sufficiently developed to plan the first implementation, but the actual project workspace and Android toolchain are not verified. Therefore, the immediate task is **Gate 0: environment and source verification**, not writing code into an assumed location.

### Why this sequence is best

- It tests BTV's distinctive identity before expensive production work.
- It proves the investigation and choice systems, not just movement or combat.
- It keeps the first build small enough for Android-first development.
- It protects canon and prevents a pile of disconnected prototypes.
- It keeps AI optional until deterministic content and state handling work.
- It avoids paid tools, credits, deployment and unnecessary dependencies.

## 1. Verified project state

### 1.1 GitHub repository — read-only inspection on 1 November 2026

Repository: `KINGACEX/beyond-the-veil-last-watch-`

- Default branch: `main`.
- Branch search returned only `main`.
- `README.md` contains a short project description.
- `doc` contains the text `now starting`.
- No `project.godot`, game scenes, scripts, assets, tests or playable release were found in the previously audited repository state.
- No repository write, branch creation, commit or deployment was performed during this work.

**Conclusion:** Treat the repository as an empty shell for game implementation. Do not assume there is an existing Godot project to preserve or extend.

### 1.2 Local workspace inspection

The current working area contains BTV design documents only. A search under `/mnt/data` found no `project.godot` file. This says nothing about files on the user's phone or another unconnected computer; those locations have not been inspected.

### 1.3 Confirmed technology direction

The Canon Changelog records:
- Godot 4.7.2 stable;
- GDScript;
- Android/mobile first;
- PC second;
- possible later console porting.

Official-source check completed: Godot 4.7.2-stable is available (released 18 August 2026), and the official archive lists Android support and matching export templates. The actual editor installation, template installation and Android export toolchain on the user's development device remain unverified. Renderer selection must be tested on the actual Android target rather than guessed.

## 2. Current design assets available

| Artifact | Status | Use |
|---|---|---|
| Master Canon and reconciliation | Existing reference | Authority and canon guardrails |
| Vertical Slice Specification v1.0 | Existing locked slice reference | Defines the first experience and build order |
| Veil Rules & Metaphysics Bible v0.1 | Draft in Library | Veil consistency and unknowns |
| Investigation & Evidence Bible v0.1 | Saved in Library | Evidence and investigation framework |
| Ridgeview Case Design v0.2 | Saved in Library | Approved slice-level case direction; not global canon |
| Ridgeview Dialogue & Content Pack v0.1 | Draft in working files | Dialogue and evidence content; proposed lines |
| Ridgeview Data Contracts v0.1 | Draft in working files | Deterministic data and state design |
| Mystery & Revelation Register v0.2 | Saved in Library | Mystery control; later local v0.3 update is not yet saved due upload limit |

**Important:** A document being saved in the Library does not mean it is implemented, tested or promoted to canon.

## 3. Production gates

### Gate 0 — Environment and source verification

**Goal:** Establish the actual place and toolchain in which BTV can be built.

Tasks:
1. Locate the intended development computer/workspace or confirm a new authorized workspace.
2. Verify the locally installed Godot 4.7.2 editor and matching export templates; official release/download availability is already confirmed.
3. Verify GDScript editor/parser availability.
4. Identify the actual target Android device model and Android version.
5. Confirm USB debugging/export path or another safe device-install route.
6. Check whether the existing GitHub repository is still the intended remote.
7. Confirm that the working tree is empty or identify any existing user files before writes.
8. Create a read-only source manifest of the authoritative design documents.

**Exit criteria:** exact workspace path, engine version, export-template state, target device and repository target are recorded. No existing work is overwritten.

**Stop conditions:** missing workspace access, engine version mismatch, unavailable export templates, unclear target repository, or any unexpected existing files.

### Gate 1 — Empty project bootstrap

**Goal:** Create the smallest reproducible Godot project.

Tasks:
1. Create `project.godot` and a minimal main scene in the verified workspace.
2. Add `README.md` with exact engine version and startup instructions.
3. Add `CHANGELOG.md` and `docs/canon/` index.
4. Create the agreed folder skeleton.
5. Add a simple start scene and one test scene.
6. Run locally in the editor.
7. Export and install on the target Android device.
8. Record actual launch, input, resolution and performance observations.

**Exit criteria:** clean project opens, launches, exports and runs on the target Android device. No renderer decision is made without a small device comparison.

### Gate 2 — Player movement and interaction

**Goal:** Prove basic third-person traversal and reusable interactions.

Tasks:
- Player controller and camera rig separated.
- Touch-first controls with safe areas and readable interaction prompts.
- One reusable interaction interface.
- One NPC interaction and one document interaction.
- Scene transition and basic save/restart.

**Exit criteria:** player can move, look, interact, leave and re-enter without softlock on device.

### Gate 3 — Logos Rhema experience

**Goal:** Prove that BTV feels like a living world before the mission alert.

Tasks:
- Greybox Logos Rhema Temple.
- ServiceDirector and flexible service phases.
- Small, low-cost civilian NPC population with believable routines.
- CommunionContextZone and Communion Set restrictions.
- Offering remains voluntary and non-rewarding.
- Ember's designated waiting location and Hold behavior.
- No Covenant alert during worship or Communion.

**Exit criteria:** service sequence can be experienced without forced timers, rewards, spiritual scores or Covenant intrusion.

### Gate 4 — Scout Report and investigation foundation

**Goal:** Establish the player's information model before the field mission.

Tasks:
- Covenant alert queue with service context gating.
- Scout Report resource and viewer.
- Evidence Board and Journal.
- Immutable report labels: Observed, Reported, Inferred, Unconfirmed.
- Separate local claim statuses: Confirmed, Contradicted, Still open.
- Optional visitor connection only if the player listened to her.

**Exit criteria:** report can be read/reopened, labels remain accurate, and player-created links remain Unverified until supported.

### Gate 5 — Ridgeview greybox

**Goal:** Prove the mission's core loop without final art.

Tasks:
- Perimeter, settlement, private conversation area, camp threshold and camp zone.
- Local Veil presentation consistent with Disturbed → Influenced slice boundary.
- No Veil-Touched, Breach or Critical escalation in this slice.
- At least three inspectable evidence items.
- Pike, Wren and small resident dialogue roles.
- Ember's local observations only.

**Exit criteria:** all Scout Report claims can be tested on site; the trader's error is disproved; the repairman trail can be found without resolving his fate.

### Gate 6 — Choices, outcomes and reporting

**Goal:** Make the five approaches meaningfully distinct and persist consequences.

Tasks:
- Speak/Preach.
- Investigate.
- Rescue.
- Defend only when a credible authored threat justifies it.
- Withdraw at any active point.
- Combine approaches where authored.
- Save existing `ridgeview.*` flags.
- Build final report with no over-claiming.
- Covenant reply based on actual outcomes.

**Exit criteria:** every approach is reachable where permitted; Withdraw works; flags match actual actions; repairman status remains unresolved; no morality or spiritual score exists.

### Gate 7 — Quality and device acceptance

**Goal:** Demonstrate repeatable quality, not a one-off successful run.

Tasks:
- Full acceptance test route.
- Save/load from every major mission phase.
- Touch/UI readability and accessibility pass.
- Audio clue alternatives and subtitles.
- Performance, memory, loading and thermal observations on target device.
- Canon and string scan, especially the no-Devourers-name rule in the slice.
- Asset provenance and licence registry.

**Exit criteria:** documented test evidence, no known critical softlocks, reproducible clean checkout, and creator review of the playable slice.

### Gate 8 — Visual target and asset pipeline

**Goal:** Establish visual quality after the game loop is proven.

Tasks:
- Define visual target and lighting language.
- Test one small environment asset end-to-end.
- Test one character placeholder replacement.
- Record polygon, texture, material and animation budgets after device profiling.
- Use free/licensed assets first; maintain manual fallback.

**Exit criteria:** one asset path is proven, licensed and performs acceptably. Paid or credit-consuming generation remains opt-in and separately authorised.

## 4. Prioritised backlog

| Priority | Task | Dependency | Deliverable | Status |
|---|---|---|---|---|
| P0 | Verify workspace and target Android device | User environment access | Environment manifest | BLOCKED |
| P0 | Verify Godot 4.7.2 and export templates | Gate 0 | Toolchain record | BLOCKED |
| P0 | Reconcile authoritative documents into canon index | Existing Library docs | Canon index | PROPOSED |
| P1 | Bootstrap clean project | Gate 0 passed | Minimal Godot project | BLOCKED |
| P1 | Android launch proof | Bootstrap | Recorded device test | BLOCKED |
| P1 | Player movement/interaction | Gate 1 | Traversal prototype | BLOCKED |
| P2 | Temple service greybox | Player/interaction | Sunday scene | BLOCKED |
| P2 | Covenant alert + Scout Report | Temple | Report viewer | BLOCKED |
| P2 | Evidence Board/Journal | Report data contracts | Investigation UI | BLOCKED |
| P3 | Ridgeview greybox | Mission/report systems | Investigation level | BLOCKED |
| P3 | Pike/Wren dialogue | Approved case direction | Authored dialogue graph | PROPOSED |
| P3 | Five approach outcomes | Ridgeview case state | Outcome flow | PROPOSED |
| P4 | Save/load and final report | Mission state | Persistent slice | PROPOSED |
| P4 | Device QA and canon audit | Full slice | Acceptance evidence | BLOCKED |
| P5 | Visual asset pipeline | Greybox passes | Asset proof | DEFERRED |
| P6 | Optional NLI | Deterministic systems pass | Bounded NLI adapter | DEFERRED |
| P7 | Full world, advanced combat, broad AI | Later design/technical gates | Future systems | RESERVED |

## 5. Explicitly deferred work

Do not spend the first build effort on:
- a fully open world;
- multiplayer or online accounts;
- full economy, crafting or equipment progression;
- complete Covenant hierarchy simulation;
- final combat/weapon inventory;
- a full companion party system;
- advanced generative NPCs;
- voice acting or cinematic production;
- high-poly character/environment art;
- paid plugins, asset packs or AI generation credits;
- monetisation, analytics or live-service infrastructure.

These may be revisited after the vertical slice demonstrates the core experience and the creator approves the scope.

## 6. Risk register

| Risk | Severity | Mitigation |
|---|---|---|
| No verified project workspace | Critical | Gate 0; no guessed path or repository writes |
| Android hardware limits unknown | High | Record target device; renderer comparison; profile early |
| Scope expands beyond slice | High | Enforce gates and explicit out-of-scope list |
| Canon drift across docs | High | Canon index; source-of-truth links; pre-merge audit |
| AI invents evidence or lore | High | Deterministic game-owned state; NLI only as typed request adapter |
| Small-screen Evidence Board is hard to use | Medium | Touch-first card/list alternative; test on actual phone |
| Asset licensing unclear | High | Provenance and licence registry; exclude unclear assets |
| Tool/credit lock-in | Medium | Free/manual fallback; no paid dependency in minimum slice |
| Mission feels like a combat funnel | High | Five approaches, rescue, dialogue and withdrawal tested as real paths |
| Faith becomes a mechanic | Critical | Theology audit; no faith/prayer/Holy Spirit scores or buffs |

## 7. Governance and delegated autonomy

Within the user's time-bounded delegation, the following can be approved autonomously when reversible and consistent with higher-authority sources:
- design drafts and internal planning;
- non-destructive local document creation;
- proposed task ordering and technical recommendations;
- internal slice-level dialogue and data contracts;
- read-only repository and source inspection.

Still requires explicit permission:
- paid tools, subscriptions, asset credits or purchases;
- public repository writes, commits, pull requests or issues;
- deployment, publication or public marketing changes;
- destructive edits, deletions, overwrites or migrations of user work;
- major global canon changes;
- sharing personal information or connecting new external accounts.

The delegation does not imply continuous background execution after the conversation pauses. Work is performed when the conversation and tools are active.

## 8. Immediate next action

**Gate 0 remains the only legitimate implementation entry point.** The repository was read-only checked and remains an empty shell with only `README.md`, `doc` and the `main` branch. The current working area contains design files and no `project.godot`. Therefore the next useful action is to locate or establish the actual authorized Godot workspace and record the Android target device before creating any project files.

Until Gate 0 passes, continue refining documentation and tests, not game implementation.

---

## 9. Status ledger

- **CONFIRMED:** Godot 4.7.2/GDScript direction; Android-first/PC-second; approved vertical-slice scope; repository's current read-only state; no verified local Godot project in the working area.
- **APPROVED WORKFLOW:** Gate-based, deterministic, Android-first vertical-slice production; graybox before high-detail art; NLI after deterministic investigation; no paid dependency in the minimum slice.
- **PROPOSED:** Backlog, gate exit criteria, risk register and task ordering.
- **UNKNOWN:** Actual user-side development workspace, target Android device baseline, locally installed editor/templates, renderer and final test framework.
- **BLOCKED:** Project bootstrap and all implementation until Gate 0 is satisfied.
- **COMPLETED:** Read-only repository check; working-area project-file check; development gates and backlog drafted. No repository write, project creation, build, deployment or gameplay test occurred.

**End of BTV Development Gates & Prioritised Backlog v0.1**
