# BTV SEPARATED WORKSTREAM EXECUTION BOARD
**Date:** 5 November 2026  
**Branch at planning:** `btv/bootstrap-prototype-001`  
**Purpose:** Coordinate parallel areas of BTV without mixing canon, character art, gameplay code, tooling or platform QA.

## Operating rules

1. Each workstream has its own source set, owner boundary, deliverables, status and acceptance gate.
2. Cross-workstream dependencies are explicit. No workstream may silently make decisions for another.
3. Canon and creator-approved design outrank prototypes, old prompts, generated images and mockups.
4. Read-only discovery and reversible documentation may proceed autonomously. Code changes require a scoped implementation plan, test cases and branch-state check. Destructive, paid, public, deployment, security-sensitive, canon-changing or permission-changing actions require explicit approval.
5. Preserve all originals. Historical sources remain historical; never overwrite them with a cleaned-up interpretation.
6. A green headless CI run is not a playable vertical slice or device certification.
7. Every deliverable states CONFIRMED / PROPOSED / UNKNOWN / BLOCKED / COMPLETED and cites its source or commit.

## Workstream A — Canon and source-of-truth recovery
**Priority:** P0  
**Goal:** Make every implementation decision traceable to the correct source.

**Tasks**
- Recover the exact merged Vertical Slice Specification v1.0 artifact and verify hash/status.
- Add it as a separate source document; do not relabel v0.2.
- Maintain authority order, conflict register, historical archive labels and source index.
- Reconcile source references in the Character, Covenant, Church, Veil, World/NPC and Mission bibles.
- Keep biblical language research (Biblical Hebrew, Koine Greek, Biblical Aramaic) as a distinct optional learning/research module. It must not become a supernatural power system, a prayer shortcut or a mandatory barrier to play.

**Exit criteria**
- Exact source artifact available and indexed.
- Every locked slice requirement has a traceable source.
- Unknowns and conflicts remain visible, not silently resolved.

**Dependencies:** Creator Library/source availability.  
**Current status:** COMPLETED — exact 363-line Library source recovered and imported at `docs/source-of-truth/vertical-slice/BTV_Vertical_Slice_Specification_v1.0.md` (commit `dee3b0b8259cceb76e935435ecb8ae16bd121760`). v0.2 is preserved as historical draft.

## Workstream B — Character identity and asset provenance
**Priority:** P0  
**Goal:** Establish consistent, approved Asher and Ember assets before game integration.

**Tasks**
- Reconcile Asher showcase, Asher gameplay mockups, Asher GLB package and all BTV character images.
- Build asset manifest: original filename, Library ID/path, hash, provenance, approval state, canon conflicts and permitted use.
- Prepare source-grounded dossiers for Asher, Ember, five Logos Rhema leaders, Dorian Pike, Wren and Marek Sloane.
- Keep Afterfall assets and unverified Stephen/other profiles isolated.
- Confirm model scale, rig, skeleton, material and animation compatibility only after a source asset is selected.

**Exit criteria**
- One approved Asher visual baseline and one approved production model package.
- Ember visual is consistent with locked rare canid lineage while exact appearance remains subject to approval.
- No unapproved concept is integrated into runtime.

**Dependencies:** Authorized Library access; creator approval for ambiguous art.

## Workstream C — Core Godot foundation and interaction
**Priority:** P1  
**Goal:** Turn the greybox foundation into a robust, testable player interaction loop.

**Tasks**
- Review movement/camera separation, input ownership, interaction selection and scene lifecycle.
- Add an on-screen interaction prompt only after UX scope is defined.
- Test target enter/exit, multiple interactables, ties, invalid/freed targets, scene transitions and focus loss.
- Separate keyboard, touch and future gamepad input from gameplay semantics.
- Keep renderer choice open until device comparison.

**Exit criteria**
- Repeatable interaction behavior with explicit acceptance tests.
- No softlocks from stale targets or scene transitions.
- Manual editor verification recorded separately from CI.

**Dependencies:** Target device/profile for mobile UX.

## Workstream D — NLI and character knowledge
**Priority:** P0  
**Goal:** Keep dialogue truthful, bounded, provenance-backed and separate from world-state authority.

**Tasks**
- Change NLI result semantics to distinguish parsed, validated, handoff-ready, accepted, rejected, executed, cancelled and failed.
- Companion actor alone owns accepted/rejected/executed state.
- Add a source registry/resolver; an allowlisted source ID must resolve to an approved source record.
- Test missing, stale, withdrawn, conflicting and out-of-scope sources.
- Define duplicate, timeout, cancellation, retry, scene transition, pause/quit/reload and offline behavior.
- Keep dialogue non-evidence and all world mutation in authoritative game services.

**Exit criteria**
- Tests prove NLI validation cannot masquerade as companion acceptance or execution.
- Every factual answer traces to a valid, approved source record.
- NPC knowledge remains speaker-scoped.

**Dependencies:** Workstream A for source truth; Workstream B for character knowledge boundaries.

## Workstream E — Ridgeview investigation vertical slice
**Priority:** P1  
**Goal:** Implement a deterministic, offline-first case without revealing reserved information.

**Tasks**
- Verify v1.0 slice source before authoring gameplay data.
- Convert evidence, claims, knowledge, dialogue and response options into data contracts.
- Preserve Scout report provenance and distinguish Observed/Reported/Inferred/Unconfirmed from player claim status.
- Keep repairman fate unresolved; do not implement ambiguous `removed_from_settlement` semantics.
- Add fail-forward paths and optional evidence rules.
- Add automated player-facing string scans for prohibited Devourer naming/hints during the slice.

**Exit criteria**
- All five approaches (Speak/Preach, Investigate, Rescue, Defend, Withdraw) can reach a coherent report without hidden faith/morality scores.
- Optional evidence cannot softlock the case.
- No dialogue claims unseen/off-screen success.

**Dependencies:** A and D; B for NPC identity/knowledge.

## Workstream F — Faith, Scripture and ancient-language learning
**Priority:** P2  
**Goal:** Preserve Christian accuracy and provide optional, non-coercive learning.

**Tasks**
- Verify all Scripture quotations, translation, context and references against approved Bible resources.
- Maintain distinction between Scripture as authored dialogue/learning and gameplay mechanics.
- Research Hebrew, Koine Greek and Biblical Aramaic with scholarly/lexical sources and transparent uncertainty.
- Keep ancient-language lessons optional and separate from player progression, salvation or spiritual worth.
- Review prayer, Communion, evangelism and Armor of God content for theological accuracy and non-transactional treatment.

**Exit criteria**
- Source-backed language notes and Scripture references.
- No language mechanic functions as a magic spell, password or guaranteed divine response.

**Dependencies:** Workstream A.

## Workstream G — Android/PC platform and UX validation
**Priority:** P1  
**Goal:** Validate the actual target experience instead of assuming compatibility.

**Tasks**
- Record target Android model, OS, RAM/resolution and input expectations when available.
- Compare renderer choices on the target device.
- Test touch safe areas, scaling, multitouch, interaction target size, orientation and pause/resume.
- Define PC keyboard/mouse behavior without compromising Android-first architecture.
- Add export, install, launch, performance, memory, thermal and stability evidence.

**Exit criteria**
- Named device/OS test record with reproducible results.
- Android export/install verified.
- Desktop editor and runtime checks recorded separately.

**Dependencies:** User/device access; Workstream C.

## Workstream H — Project governance, CI and delivery
**Priority:** P1  
**Goal:** Keep work traceable, low-cost and reviewable.

**Tasks**
- Keep branch and commit evidence current.
- Keep CI focused on reproducible headless checks; add tests only for deterministic contracts.
- Maintain separate manual/device QA status.
- Review stale issue #1 “Core Motive” before any status change.
- Track Mavis/local work only from a supplied report, commit or accessible artifact.
- Preserve no-cost toolchain; no new paid services or credits without approval.

**Exit criteria**
- Every milestone has acceptance criteria, evidence and rollback.
- No unreviewed changes merged to main.
- No unsupported claims of tests, permissions or Mavis progress.

## Dependency map

```text
A Canon/source recovery ──┬──> B Character/assets ──> C Core integration
                         ├──> D NLI/knowledge ──────> E Ridgeview slice
                         ├──> F Faith/language QA
                         └──────────────────────────> E Ridgeview slice

C Core interaction ─────────> G Android/PC validation
A/B/C/D/E/F/G ──────────────> H Governance and delivery evidence
```

## Execution order

1. **Now:** A (recover v1.0), B (asset provenance/dossiers), H (keep evidence current).
2. **Next:** D (NLI contract design and tests), C (interaction QA plan).
3. **After source gate:** E (Ridgeview deterministic data and gameplay).
4. **In parallel as independent review:** F (Scripture/language research).
5. **When target device is available:** G (renderer, touch and Android export validation).

## Current branch evidence

- Branch head at planning: `159da05640960a292e08ce48ea2489a2191ab39a`.
- Latest CI run: `42025346911`, SUCCESS, on that exact commit.
- CI scope: Godot 4.7.2 install/version, headless import/parse, NLI smoke test, 10-frame main-scene launch.
- No open PRs returned. One old open issue #1 “Core Motive” remains unreconciled.
- No Android build/device evidence.
- No code change was made as part of this workstream planning pass.

## Immediate next actions

| Order | Workstream | Action | Status |
|---:|---|---|---|
| 1 | A | Recover exact Vertical Slice v1.0 source artifact | COMPLETED |
| 2 | B | Continue visual asset discovery and create approved-reference manifest | IN PROGRESS |
| 3 | H | Refresh stale CI references in README/status | READY |
| 4 | D | Write NLI result-state and source-registry contract | PROPOSED |
| 5 | C | Write interaction edge-case acceptance matrix | PROPOSED |
| 6 | F | Separate ancient-language research notes from gameplay canon | PROPOSED |
| 7 | G | Await actual target-device details before renderer/export decision | BLOCKED |

**Governance note:** This board coordinates the lanes; it does not approve new canon, commit gameplay code, purchase tools, publish builds or deploy services.
