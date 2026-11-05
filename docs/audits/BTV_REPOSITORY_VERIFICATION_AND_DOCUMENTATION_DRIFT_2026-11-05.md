# BTV REPOSITORY VERIFICATION & DOCUMENTATION DRIFT AUDIT
**Date:** 5 November 2026  
**Branch:** `btv/bootstrap-prototype-001`  
**Inspected head:** `159da05640960a292e08ce48ea2489a2191ab39a`  
**Scope:** Read-only GitHub repository tree, current CI workflow/run, README, implementation status, NLI code and source index.  
**Code changes:** None during inspection.

## 1. Current verified state

- Branch exists and points to `159da05640960a292e08ce48ea2489a2191ab39a`.
- Repository tree contains 116 entries.
- Godot project files are present: `project.godot`, main/player/touch-control scenes, movement/touch/interactable scripts, NLI modules and smoke-test harness.
- One GitHub Actions workflow exists: `.github/workflows/godot-validation.yml`.
- No open pull requests were returned.
- One open issue was returned: #1 “Core Motive”, last updated 2026-09-12; its relevance/current status has not been reconciled.
- No merge to `main` is evidenced by this branch inspection.

## 2. Latest CI evidence

**Run:** [42025346911](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42025346911)  
**Run number:** 85  
**Commit:** `159da05640960a292e08ce48ea2489a2191ab39a`  
**Result:** SUCCESS

The run's job and step metadata confirms:
1. Godot 4.7.2 installation — passed.
2. Engine version check — passed.
3. Headless editor import and project parsing — passed.
4. NLI smoke-test command — passed.
5. Main scene launch for 10 headless frames — passed.

The workflow is narrow. It does not perform Android export/install, physical-device testing, rendered visual inspection, interactive input testing, PC/editor manual QA, performance profiling, save/load tests or full vertical-slice acceptance.

**Important distinction:** The latest run was triggered by a documentation commit. It demonstrates that the existing project still passes its configured headless gate at that commit. It does not mean the character inventory or game features are implemented.

## 3. Documentation drift and source-of-truth gaps

### D-01 — Latest CI references are stale
**Status:** CONFIRMED.

- Root `README.md` and `docs/implementation/BOOTSTRAP_STATUS.md` still cite run `41671365779` on commit `f990811...`.
- Current branch head has a newer successful run `42025346911` on commit `159da056...`.
- Correct the links and commit references while preserving the limited scope of what CI proves.

### D-02 — Vertical Slice v1.0 is referenced but absent from inspected branch tree
**Status:** CONFIRMED REPOSITORY GAP; SOURCE AVAILABILITY ELSEWHERE UNKNOWN.

- The current source index and historical Ridgeview audit refer to a merged Vertical Slice Specification v1.0.
- The inspected branch tree contains `BTV_Vertical_Slice_Specification_v0.2.md`, but no v1.0 file at the expected vertical-slice path.
- The current Library/recovery notes indicate that a merged v1.0 exists as a separate source artifact. Its exact final file and approval provenance must be re-verified before import.
- Do not silently relabel v0.2 as v1.0 or copy older drafts over it.
- Required action: recover the exact merged v1.0 artifact, verify its content/hash and status, then add it as a distinct source-of-truth file. If unavailable, mark the canonical repository copy BLOCKED and request the original file.

### D-03 — Historical bootstrap handoff is stale
**Status:** CONFIRMED.

- `BOOTSTRAP_001_ONE_READ.md` describes the initial scaffold as unvalidated and records an earlier branch head.
- Later CI and implementation work superseded those verification statements.
- Preserve the document as historical handoff; add a dated correction/current-status pointer rather than rewriting its historical account.

### D-04 — NLI service handoff wording requires a future contract correction
**Status:** CONFIRMED SOURCE ISSUE; NO CODE CHANGE.

- `nli_service.gd` returns `accepted: true` for a validated companion command.
- The same result says the companion gameplay system must explicitly accept or reject it.
- The validator describes the command as “validated and ready” for the companion system.
- This is a semantic contract mismatch. The service must report a state such as validated/handoff-ready; only the companion actor may report accepted, rejected or executed.
- No code change was made in this audit.

### D-05 — NLI source allowlist is not a source registry
**Status:** CONFIRMED DESIGN GAP.

- The knowledge base verifies that a source ID is in the NPC profile allowlist.
- It does not establish that the source ID resolves to a real source record, that the source is current, or that the response is supported by it.
- Add a registry/resolution contract before production NPC facts are authored.

### D-06 — Prototype scope remains materially narrower than the vertical slice
**Status:** CONFIRMED.

Current source contains the greybox movement/interaction foundation and deterministic NLI foundation. It does not establish a playable Logos Rhema-to-Ridgeview vertical slice. Asher/Ember gameplay, authored mission systems, evidence board/journal, production UI, save/load, final character assets, Android build and device QA remain separate gates.

## 4. CI workflow limitations

The workflow runs on pushes to `btv/bootstrap-prototype-001` and manual dispatch. It installs Godot 4.7.2, imports/parses the project headlessly, runs `tests/nli_smoke_test.gd`, and launches the main scene for ten frames.

The workflow's concurrency group cancels in-progress runs on the same branch. This explains why some closely spaced documentation commits have cancelled runs; cancellation is not a failed test.

The workflow grants `contents: read`. No code or workflow permissions were changed.

## 5. Prioritised correction tasks

| ID | Workstream | Priority | Next action | Gate |
|---|---|---:|---|---|
| D-01 | Delivery evidence | P0 | Update README and implementation status to latest successful run | Documentation-only |
| D-02 | Canon source | P0 | Recover and verify exact Vertical Slice v1.0 file | Source provenance required |
| D-03 | Handoff hygiene | P1 | Add current-status pointer to historical Bootstrap 001 handoff | Documentation-only |
| D-04 | NLI semantics | P0 | Correct validated vs accepted vs executed result contract and tests | Code change after test-first plan |
| D-05 | NLI provenance | P0 | Design source registry/resolution and invalid/stale-source tests | Design then code |
| D-06 | Product scope | P1 | Maintain explicit slice acceptance gate separate from prototype CI | Documentation-only |
| D-07 | Issue hygiene | P2 | Review #1 Core Motive against current design; do not close without evidence | Read-only review first |
| D-08 | Platform QA | P1 | Establish target Android device/profile and manual test record | User/device availability required |

## 6. What was not done

- No game code or project settings changed.
- No issue or PR was created, edited, assigned, or closed.
- No branch protection or repository permissions changed.
- No merge, release, deployment, asset import or device test occurred.
- No attempt was made to bypass Library access restrictions.

## 7. Conclusion

**CONFIRMED:** The current branch has a small Godot prototype and its configured headless CI gate passes at the inspected commit.  
**BLOCKED:** The repository does not contain the merged Vertical Slice v1.0 file referenced by current source documents.  
**CONFIRMED:** NLI has two production-relevant contract gaps: premature `accepted=true` wording and missing source resolution.  
**UNKNOWN:** Current relevance of issue #1 and status of any external Mavis/local workspace work.  
**NOT CLAIMED:** Full slice implementation, Android readiness, character integration or production readiness.
