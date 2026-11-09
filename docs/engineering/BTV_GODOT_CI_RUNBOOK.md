# BTV Godot CI Runbook

**Purpose:** Run real Godot 4.7.2 headless validation for BTV without requiring the creator to own or access a PC.

## Confirmed runner capability

The repository workflow is **BTV Godot Validation** at `.github/workflows/godot-validation.yml`.

It runs on a GitHub-hosted Ubuntu runner and installs **Godot 4.7.2 stable**. The current pipeline performs:

1. Godot engine-version verification.
2. Headless editor import and project/script parsing.
3. All 14 contract/regression suites:
   - NLI smoke
   - NLI handoff and source-registry contract
   - Mission data validator
   - Core interaction acceptance
   - Player camera input
   - Touch input adapter
   - Touch controls integration
   - Touch controls coexistence
   - Touch controls composition
   - Touch controls input path
   - Touch controls lifecycle
   - Touch controls reconciliation
   - Touch controls resize
   - Touch input source composition
   - Concurrent three-finger movement/look/Interact through the real viewport input path
4. Headless launch of the main scene for 10 frames.

The XH-003 implementation passed in [run #42653466596](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42653466596). The control-hardening branch then passed the expanded 15-suite pipeline in [run #42654969493](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42654969493) on commit `0403e35feadd057e2ca02feefeac1a0575b7c847`.

## How to run it

### Automatic branch validation

A push to one of the branches listed under `on.push.branches` in the workflow should start validation. Do not assume every repository branch is covered; check the workflow file before relying on an automatic run.

### Manual run from Android or any browser

1. Open the repository on GitHub.
2. Open **Actions**.
3. Select **BTV Godot Validation**.
4. Select **Run workflow**.
5. Choose the branch containing the code to test.
6. Start the workflow and open the resulting run.
7. Inspect the job and confirm the import, all 14 test suites, and 10-frame scene launch each report success.

The workflow also declares `workflow_dispatch` for manual runs. If a commit appears but no run is listed, do not assume validation happened; start it manually using the steps above.

## Acceptance rule

A change is **headless-verified** only after a completed successful run on the relevant code commit. Record the run URL and tested commit SHA in the engineering checkpoint or PR. If a later commit changes source, tests, or workflow configuration, run validation again. A documentation-only follow-up may reference the last tested implementation commit, but must state that the follow-up itself was not separately run.

Never report a pending, cancelled, skipped, or failed run as a pass. Inspect logs for any failure and fix it before marking the change verified.

## What CI does not prove

Headless CI does not prove:

- Android export or signing readiness.
- Physical-device multitouch behaviour.
- Safe-area layout, thumb reach, orientation, or screen-size behaviour.
- Device GPU compatibility, frame rate, memory use, thermal behaviour, or battery impact.
- Play Store readiness.

These require separate Android device/export checks. Keep those gates explicit.

## Governance

- Keep workflow permissions least-privilege; the current workflow uses `contents: read`.
- Do not add credentials, broaden permissions, select an Android package ID, configure signing, publish builds, merge PRs, or release without explicit creator approval.
- Preserve private MiniMax workspace contents. Reconcile its HEAD, status, and remotes against the public repository before transferring changes.
