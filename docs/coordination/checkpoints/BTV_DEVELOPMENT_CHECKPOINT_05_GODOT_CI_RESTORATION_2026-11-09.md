# BTV Development Checkpoint 05 — Godot CI Restoration

**Date:** 2026-11-09  
**Status:** Workflow configuration restored for XH-003; execution pending  
**XH-003 branch:** `btv/xh-003-input-source-composition-spec-001`  
**Workflow commit:** `9448f905e880e932bcbdddae22ac70577daadfc5`  
**PR:** #6 — open, draft, unmerged

## Confirmed findings

1. The repository already contains the `BTV Godot Validation` workflow at `.github/workflows/godot-validation.yml`.
2. The workflow installs Godot **4.7.2** on an Ubuntu runner, performs an editor import/parse check, runs test scripts, and launches the main scene headlessly.
3. The prior push filter named four older development branches and did **not** include the active XH-003 branch. This explains why an ordinary push to XH-003 was not covered by the workflow's configured branch filter.
4. The workflow file was updated on the XH-003 branch to include `btv/xh-003-input-source-composition-spec-001`.
5. The workflow's least-privilege permission remains `contents: read`. No credential, token scope, repository permission, or secret was changed.
6. The workflow sequence now runs the 7 pre-existing suites and adds the 7 additional touch regression suites: coexistence, composition, input path, lifecycle, reconciliation, resize, and input-source composition. This is a 14-suite inventory, followed by the headless main-scene launch.
7. The workflow update is included in PR #6. PR #6 remains open, draft, and unmerged.

## Execution status

A GitHub Actions run was **not observed** for commit `9448f905e880e932bcbdddae22ac70577daadfc5` at checkpoint time. The commit status returned no checks. Therefore:

- Godot 4.7.2 import has not been verified on this commit.
- None of the 14 test suites is claimed to have passed on this commit.
- The headless main-scene launch is not yet verified.
- No CI success is claimed.

The GitHub connector exposed read and repository-content write actions but no workflow-dispatch action. The available route to execute immediately is to manually dispatch **BTV Godot Validation** in GitHub Actions with branch `btv/xh-003-input-source-composition-spec-001`, or make a normal authenticated Git push that triggers the branch's push event. A manual dispatch should use the existing `workflow_dispatch` trigger.

## Safety and governance

- No merge, release, Android export, signing, package identifier, secret change, token-scope expansion, or destructive operation occurred.
- MiniMax's private workspace was not inspected or modified.
- The existing draft PR remains the review boundary.
- Keep XH-003 unmerged until the full Godot 4.7.2 workflow passes and an independent source/test review is complete.

## Next actions

1. Dispatch the workflow manually for the XH-003 branch.
2. Inspect every job step and log; fix only evidence-backed failures on an isolated branch.
3. Re-run the complete 14-suite matrix and main-scene launch.
4. Record run ID, Godot version, per-suite exit results, and final status in the next checkpoint.
