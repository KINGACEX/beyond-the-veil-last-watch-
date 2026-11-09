# BTV Godot CI Runbook

**Purpose:** Run real Godot 4.7.2 headless validation for BTV without requiring the creator to own or access a PC.

## Confirmed runner capability

The repository workflow is **BTV Godot Validation** at `.github/workflows/godot-validation.yml`.

It runs on a GitHub-hosted Ubuntu runner and installs **Godot 4.7.2 stable**. The current pipeline performs:

1. Godot engine-version verification.
2. Headless editor import and project/script parsing.
3. All 19 contract/regression suites:
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
   - Touch-control geometry at five representative viewport sizes (headless layout check only; not device safe-area certification)
   - Neutral movement physics lab scene structure and telemetry acceptance
   - Neutral movement acceleration, braking, diagonal speed-cap, progressive turning, direction-reversal and diagonal-braking response
   - Neutral-lab wall blocking, doorway/corridor clearance and ramp floor-contact probes
4. Headless launch of the neutral movement physics lab (the current main scene) for 10 frames.

The XH-003 implementation passed in [run #42653466596](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42653466596). The control-hardening branch passed 16 suites in [run #42655805462](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42655805462). After the touch-camera scaling correction and neutral lab construction, the 17-suite pipeline passed in [run #42665594447](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42665594447). The expanded 18-suite pipeline, including acceleration/braking response tests and a 10-frame lab launch, passed in [run #42665909377](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42665909377) on commit `6d2e5a20f47a8927416c8c42d8d1d0e94958b3b4`. The 19-suite pipeline added wall, doorway, corridor, ramp, step and SpringArm3D camera-obstruction probes and passed in [run #42666264480](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42666264480) on commit `c9dbe133891febdc76d7e93cfdaf85b2d3702710`. The same suite was extended with a steeper-ramp floor-contact probe and a high-step blocking/no-vertical-snap probe; the full 19-suite run passed again in [run #42666506202](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42666506202) on commit `28a76d8dc15980963900758a378241a1c97f6338`. The motion suite was subsequently expanded with progressive turning, turn convergence, direction reversal and diagonal braking; the full workflow passed in [run #42712465318](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42712465318) on commit `f27f85b165c9a25b6c9fbcf480f1aab684fece2a`.

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
7. Inspect the job and confirm the import, all 19 test suites, and 10-frame scene launch each report success.

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
