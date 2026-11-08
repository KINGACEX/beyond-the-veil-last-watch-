# XH-002 Evidence Pack — MiniMax Code

Everything here was produced by **MiniMax Code (cloud session, GDScript / Godot 4.7.2)** between
2026-11-08 21:49 and 22:10 UTC. It is published here so that **ChatGPT (Lead Coordinator)** and
**Claude (Visual Director)** can read it through their own authenticated GitHub connections, as
Issue #3 ("BTV Agent Coordination Hub") requires.

**Status labels used here:** CONFIRMED / PROPOSED / UNKNOWN / BLOCKED / COMPLETED.

## Contents

| File | What it is | Status |
|---|---|---|
| `BTV_GITHUB_MCP_VERIFICATION_2026-11-08.md` | Read-only verification of the `btv-github` MCP connection: install, authentication, repository access, Issue #3 access, 39-tool catalogue, permissions gaps, evidence | CONFIRMED |
| `BTV_XH-001_MINIMAX_CODE_REVIEW_2026-11-08.md` | The XH-001 implementation review of M2 touch controls (7 godot suites + 23 scratch-copy probe assertions; 2 probe failures exposing defects) | CONFIRMED |
| `verify-github-mcp-readonly.sh` | Reproducible read-only MCP verification script (initialize → tools/list → repo → issue #3 → issues → PRs). Reads `${GITHUB_PAT}` from the environment; never prints it | COMPLETED |
| `XH-002-touch-input-hardening.patch` | Full diff of the XH-002 implementation against its base commit `3484672` (11 files, +1040/−21) | PROPOSED (draft PR #4, not merged) |
| `xh-002-ci-workflow.patch` | CI workflow change that could **not** be pushed — the PAT lacks the `workflow` scope | BLOCKED |
| `pr-body.md` | The description body of draft PR #4, including the CI YAML inline for manual application | PROPOSED |
| `run-cross-agent-review.sh` | Helper that drives a Claude Code review pass over the change set | COMPLETED |

## Deliberately NOT published

| File | Reason |
|---|---|
| `AGENT-SIGN-IN.md` | Contains a live Claude OAuth PKCE URL and a ChatGPT/Codex device sign-in code. Live sign-in credentials must not be pasted into a public repository — Issue #3 forbids posting credentials to this issue. Held locally by the creator only. |
| `xh-002-branch.zip` | Binary duplicate of the branch content already reachable through the git history. |

No file in this pack contains a GitHub token. The personal access token is held only as an encrypted
MCode secret (`GITHUB_PAT`) and is referenced as `${GITHUB_PAT}`.

## Where the live work is

- **Implementation branch:** `btv/agent-minimax-xh-002` @ `34c5af7089efa83a151fbaa79e44a070d1bf21c5`
- **Draft PR:** https://github.com/KINGACEX/beyond-the-veil-last-watch-/pull/4
  (base `btv/mobile-touch-input-adapter-001`, 11 files, +1040/−21, 2 commits, still draft)
- **Coordination issue:** #3 — https://github.com/KINGACEX/beyond-the-veil-last-watch-/issues/3

## Test evidence at the pushed commit `34c5af7`

```
13/13 headless Godot 4.7.2 suites PASS
  nli_smoke_test, nli_contract_test, mission_data_validator_test,
  core_interaction_acceptance_test, player_camera_input_test,
  touch_input_adapter_test, touch_controls_integration_test,
  touch_controls_lifecycle_test, touch_controls_composition_test,
  touch_controls_coexistence_test, touch_controls_resize_test,
  touch_controls_input_path_test, touch_controls_reconciliation_test
main scene 10-frame launch: PASS
local HEAD == remote branch SHA
```

**Not tested:** no physical-device run, no Android export, no emulator run, no CI run (CI is BLOCKED
above). A passing headless suite is not physical Android validation.

## The two qualifications Issue #3 asked to reconcile

Resolved in `BTV_XH-001_MINIMAX_CODE_REVIEW_2026-11-08.md` and locked down by
`tests/touch_controls_reconciliation_test.gd` (in PR #4) — see the verification report for the full
evidence:

1. **HIGH-1 (freed-instance reference semantics).** `is_instance_valid(cached)` is `false` after
   `free()`, and in Godot 4 a freed instance compares equal to `null`. The old `!= null` guard
   therefore *did* suppress the call: the defect was a **silent loss of camera look after a respawn,
   not a crash**. Re-resolution is lazy — it happens on the next look drag, the only moment the
   reference is needed.
2. **MEDIUM-2 (physical-key coexistence).** The earlier probe used a synthetic `Input.action_press()`.
   The new suite drives a **real `InputEventKey` (physical W) through Godot's key pipeline**: the
   action is held, touch cleanup does **not** cancel it, and the old unconditional
   `Input.action_release()` **does** cancel it. No synthetic-only claim remains.

## Open decisions that are not mine to make

- **XH-002 approval.** Issue #3 still labels it "Proposed, NOT APPROVED / NOT STARTED". The branch and
  draft PR exist; the creator closes the gate.
- **CI.** Either grant the PAT the `workflow` scope, or paste the YAML from `pr-body.md` into
  `.github/workflows/godot-validation.yml` via the GitHub web editor.
- **Token rotation.** The PAT was pasted in plaintext into the agent chat and should be revoked and
  rotated; the replacement belongs in the encrypted `GITHUB_PAT` secret.
- **Claude's authenticated access.** The visual review of the touch HUD has not started — Claude has
  not yet acknowledged this task through an authenticated session.
