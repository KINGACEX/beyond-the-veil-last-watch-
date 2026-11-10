# BTV — Handoff for ChatGPT (Lead Coordinator)

**Prepared by:** MiniMax Code / Mavis — 2026-11-09 06:55 UTC
**Purpose:** an independent, verifiable picture of BTV's current state for the coordinator's review.
**Scope note:** this is a report only. No repository, issue, pull request, workflow, permission or
credential was changed while preparing it, and no new task was started.

**Evidence classes used throughout:** `VERIFIED` (checked directly against the repository, the GitHub API
or a local execution) · `REPORTED` (a claim made by an artifact, not independently confirmed) ·
`INFERRED` (a reasoned conclusion from verified facts) · `UNVERIFIED`.

> No credential value, token, secret, authentication file or private session content appears in this
> document. Credential material is referenced only by name and by whether it is valid.

---

## 1. Session

| Item | Value | Class |
|---|---|---|
| Agent | MiniMax Code (MCode), agent display name `Mavis` | VERIFIED |
| Session ID | `460954906607848` | VERIFIED |
| Session title | "Connecting AI to BTV Development" | VERIFIED |
| Runtime | MiniMax Code cloud session, client platform `app`, model `MiniMax-M3.1-Flash` (thinking effort max, 512k context) | VERIFIED |
| Session state | active, not archived; created 2026-11-07, last updated 2026-11-09 06:55 UTC | VERIFIED |
| Working directory | `/workspace` (persists across cloud sessions) | VERIFIED |

**Current task.** XH-003 — *Same-Action Input Composition and CI Evidence*. Status **PROPOSED**. The
requested reproduction and architecture proposal are complete; **implementation is deliberately not
started**, pending creator approval.

**Active objectives across the BTV engagement:**

1. **XH-002** — touch-input hardening, implemented on a draft branch, **awaiting creator approval**;
   Issue #3 still records it as "Proposed, NOT APPROVED / NOT STARTED".
2. **XH-003** — same-action input composition + CI evidence; reproduction and proposal delivered,
   awaiting approval.
3. **Visual review of the touch HUD** (XH-001 HIGH-2 / HIGH-3) — not started; requires Claude's
   authenticated repository access.
4. **Credential rotation** — the current GitHub token was supplied in plaintext chat and should be
   rotated (§6).

---

## 2. Repository

| Item | Value | Class |
|---|---|---|
| Repository | `KINGACEX/beyond-the-veil-last-watch-` | VERIFIED |
| Visibility | **public** | VERIFIED |
| Default branch | `main` | VERIFIED |
| `main` content | **2 files** — all engineering lives on unmerged branches | VERIFIED |
| Work branch (XH-002) | `btv/agent-minimax-xh-002` | VERIFIED |
| **Latest commit SHA (work branch)** | `34c5af7089efa83a151fbaa79e44a070d1bf21c5` (`34c5af7`) | VERIFIED |
| Base branch | `btv/mobile-touch-input-adapter-001` @ `3484672809ad95e4e36591e7ca7d49d5f61dfd5e` (`3484672`) | VERIFIED |
| Evidence branch | `btv/agent-minimax-xh-002-evidence` @ `c19d0a54767a928376e810837a402b0879f89953` (`c19d0a5`) | VERIFIED |
| Project shape | Godot 4.7.2, GDScript only; 26 `.gd` scripts, 4 scenes, 13 test suites, extensive `docs/` | VERIFIED |

**Divergence worth flagging (VERIFIED):** the local project at `/workspace/btv` is a **different
codebase** — layout `scripts/core/`, `scripts/player/`, `tests/cases/`, `tools/validate.sh`, no touch
controls, no NLI, no mission validator. 17 of its 22 files exist in **no branch** of this repository. The
XH-001/XH-002/XH-003 work was done against the GitHub lineage; the local copy has never received it.

---

## 3. Changes

### 3.1 Published — branch `btv/agent-minimax-xh-002` (2 commits, 11 files, +1040/−21)

| File | Kind | Explanation |
|---|---|---|
| `scripts/touch_controls.gd` | modified (+44/−12) | player re-resolution; action-ownership table; Android `NOTIFICATION_APPLICATION_PAUSED`; hidden-overlay input gate; ownership-aware release |
| `scripts/player_controller.gd` | modified (+12/−4) | `apply_look_delta()` made public (shared mouse/touch path); `_apply_look_delta()` kept as a compatibility alias |
| `project.godot` | modified (+12/−4) | the four movement actions' InputMap deadzone 0.2 → **0.0**, so the adapter's analog curve is the only one applied |
| `tests/touch_controls_integration_test.gd` | modified (+6/−1) | now makes the overlay visible (it previously drove a hidden HUD — the exact state in which the hidden-overlay defect was invisible). No assertion weakened or removed |
| `docs/implementation/BTV_XH-002_TOUCH_INPUT_HARDENING_2026-11-08.md` | added (+132) | the XH-002 implementation note |
| `tests/touch_controls_lifecycle_test.gd` | added (+129) | player arrives late / is replaced on respawn |
| `tests/touch_controls_composition_test.gd` | added (+190) | analog curve, deadzone, diagonal, player-input magnitude |
| `tests/touch_controls_coexistence_test.gd` | added (+147) | touch cleanup vs a keyboard-held action |
| `tests/touch_controls_resize_test.gd` | added (+90) | overlay tracks the viewport; joystick usable at 2400×1080 and 1080×2400 |
| `tests/touch_controls_input_path_test.gd` | added (+142) | events pushed through real viewport routing; hidden overlay does not drive the player |
| `tests/touch_controls_reconciliation_test.gd` | added (+136) | reconciles the XH-001 HIGH-1 / MEDIUM-2 qualifications (second commit `34c5af7`) |

### 3.2 Published — branch `btv/agent-minimax-xh-002-evidence` (1 commit, 8 files, +2012)

`docs/coordination/xh-002-evidence/` — `README.md` (index, status labels, exclusions),
`BTV_GITHUB_MCP_VERIFICATION_2026-11-08.md`, `BTV_XH-001_MINIMAX_CODE_REVIEW_2026-11-08.md`,
`verify-github-mcp-readonly.sh`, `XH-002-touch-input-hardening.patch`, `xh-002-ci-workflow.patch`,
`pr-body.md`, `run-cross-agent-review.sh`.
Documentation and scripts only — **no game source** on this branch.

### 3.3 Deliberately not published

`AGENT-SIGN-IN.md` (live OAuth PKCE URL + device sign-in codes) and `xh-002-branch.zip` — see the
evidence-pack README. No published byte contains a credential.

### 3.4 Local only, never published

The XH-002/XH-003 audit and proposal documents, the scratch probe scripts
(`/workspace/.audit/probe/tests/*`), the intake keypair (`/workspace/.secrets/`, mode 600) and the
local verification scripts.

**Nothing was deleted.** No file, branch, PR or issue was removed in this session.

---

## 4. Tests

### 4.1 Exact commands

```bash
godot --headless --editor --path . --quit          # import + parse check
godot --headless --path . --script res://tests/<suite>.gd
godot --headless --path . --quit-after 10         # main scene, 10 frames
```

Engine: `/workspace/.tools/godot` = `4.7.2.stable.official.ed1daf0bf`.

### 4.2 Authoritative inventory — 13 published suites, executed independently on `34c5af7`

| # | Suite | Assertions executed | Result | In CI? |
|---|---|---|---|---|
| 1 | `nli_smoke_test` | 50 | PASS | yes |
| 2 | `nli_contract_test` | 41 | PASS | yes |
| 3 | `mission_data_validator_test` | 22 | PASS | yes |
| 4 | `core_interaction_acceptance_test` | 24 | PASS | yes |
| 5 | `player_camera_input_test` | 15 | PASS | yes |
| 6 | `touch_input_adapter_test` | 31 | PASS | yes |
| 7 | `touch_controls_integration_test` | 17 | PASS | yes |
| 8 | `touch_controls_lifecycle_test` | 5 | PASS | **no** |
| 9 | `touch_controls_composition_test` | 13 | PASS | **no** |
| 10 | `touch_controls_coexistence_test` | 8 | PASS | **no** |
| 11 | `touch_controls_resize_test` | 10 | PASS | **no** |
| 12 | `touch_controls_input_path_test` | 6 | PASS | **no** |
| 13 | `touch_controls_reconciliation_test` | 9 | PASS | **no** |
| | **total** | **251** | **13/13 PASS** | **7 of 13** |

Main scene 10-frame headless launch: **PASS**. All of the above is **VERIFIED by local execution** on the
published tree.

### 4.3 Reconciling the "12/12" and "13/13" figures (VERIFIED)

Both were true when written; they differ by one commit.

- **12/12** — PR #4 body and the XH-002 implementation report. Basis: the 7 pre-existing suites + the 5
  suites added by the **first** XH-002 commit `8553804` (20:29 UTC). PR #4 was opened at 21:50 with this
  text.
- **13/13** — the Issue #3 comment, the evidence-pack README and the MCP verification report. Basis: the
  same 12 **plus** `touch_controls_reconciliation_test.gd`, added by the **second** commit `34c5af7`
  (21:54 UTC) to satisfy Issue #3's request to reconcile HIGH-1/MEDIUM-2. The Issue #3 comment was
  posted at 22:11.

**13/13 is current.** The PR body and the implementation report are stale (they also understate the
assertion totals: they say 37 for the five new suites; the executed count is 42, and 51 across all six).

### 4.4 Failures — the XH-003 acceptance test (VERIFIED, local)

`tests/xh003_same_action_composition_test.gd` (drafted in a scratch copy, **not committed**) reproduces
the task's sequence and **fails 4 of 12 assertions** against the current branch:

- releasing the joystick **stops** forward movement even though the physical W key is still held;
- releasing the W key **stops** forward movement even though the joystick is still held.

Root cause and evidence table: `BTV_XH-003_SAME_ACTION_COMPOSITION_PROPOSAL_2026-11-09.md` §1.

### 4.5 CI results — **none for this branch** (VERIFIED)

`btv/agent-minimax-xh-002` → **0 runs**. `btv/agent-minimax-xh-002-evidence` → **0 runs**. The last CI
evidence in the repository is *"BTV Godot Validation #253, completed/success, sha `3484672`, branch
`btv/mobile-touch-input-adapter-001`"* — the **base** branch. Every XH-002/XH-003 test result is local.

---

## 5. GitHub

### 5.1 Branches — 16 (VERIFIED)

`main` (`d3b028a`) · `btv/agent-minimax-xh-002` (`34c5af7`) · `btv/agent-minimax-xh-002-evidence`
(`c19d0a5`) · `btv/mobile-touch-input-adapter-001` (`3484672`) ·
`btv/project-history-and-lore-bridge-001` (`1ba1c5a`) · `btv/test-first-contracts-001` (`0238555`) ·
`btv/mission-validator-strict-types-001` (`7542b2f`) · `btv/bootstrap-prototype-001` ·
`btv/camera-relative-mouselook-001` · `btv/claude-review-temp-001` (`d3b028a`) ·
`btv/kay-family-character-bible-001` · `btv/nli-lifecycle-guard-001` · `btv/multi-agent-system-v1` ·
`codex/btv-write-access-proof` · `feature/m1-godot-foundation` · `test/gdunit4-compatibility-001`

`btv/claude-review-temp-001` is **new since the previous audit** and is **identical to `main`**
(`ahead_by: 0`, `behind_by: 0`, 0 files changed, no commits) — an empty branch. It has **no PR, no issue
comment and no pushed commit** (VERIFIED). *INFERRED:* the name suggests it was created to host a Claude
review that has not yet been pushed. No branch is protected.

### 5.2 Commits on the work branch (VERIFIED)

- `8553804` — *fix: harden touch input lifecycle, analog composition and action ownership*
- `34c5af7` — *test: reconcile the XH-001 HIGH-1 and MEDIUM-2 qualifications*

### 5.3 Draft pull requests (VERIFIED)

| PR | Head → Base | Files | State |
|---|---|---|---|
| **#4** | `btv/agent-minimax-xh-002` → `btv/mobile-touch-input-adapter-001` | 11 (+1040/−21) | open, **draft**, `mergeable: clean`, never merged |
| **#5** | `btv/agent-minimax-xh-002-evidence` → `btv/project-history-and-lore-bridge-001` | 8 (+2012) | open, **draft** |
| **#2** | `btv/mission-validator-strict-types-001` → `btv/test-first-contracts-001` | — | open, **draft** (unrelated to XH-002) |

### 5.4 Issues (VERIFIED)

- **#3** *BTV Agent Coordination Hub — Shared Task Queue and XH-001 Follow-up* — open, **1 comment**
  (the MiniMax Code 10-point acknowledgement), no labels/assignees/milestone. Its work queue still marks
  XH-002 "Proposed, NOT APPROVED / NOT STARTED".
- **#1** *Core Motive* — open, label `good first issue`, 0 comments, untouched since 2026-09-12.
- Issues #2/#4/#5 are pull requests surfaced by the issues API.

---

## 6. Outstanding work

### 6.1 Defects — VERIFIED by source inspection and/or local execution

| ID | Severity | Issue |
|---|---|---|
| XH2-01 / XH3 | **HIGH** | **Same-action composition is broken.** The XH-002 ownership table infers ownership from an action strength Godot does not partition by source. With the keyboard held (strength 1.0) and the joystick at full deflection (also 1.0), the check concludes "still mine" and releases the action, **cancelling the keyboard**. Below full deflection it survives. The mirror case — releasing the key while the joystick is held — zeroes the action and drops the joystick's contribution until the next drag event. |
| XH3 | **HIGH** | The same defect reaches the shared `interact` action: releasing the touch Interact button cancels a keyboard-held **E**. |
| XH-002 | MEDIUM | **Zero CI evidence** for the branch: the workflow file exists on the branch but does not trigger there and runs none of the 6 new suites. |
| XH-001 HIGH-2 | MEDIUM | **No safe-area insets** — the HUD is fixed-pixel; `grep` for safe-area/notch across the branch returns nothing. Blocks Android readiness. Deferred to Claude's brief. |
| XH-001 HIGH-3 | MEDIUM | **Resolution-dependent look sensitivity** — `look_sensitivity_degrees_per_pixel = 0.12`; the same swipe turns the camera differently per resolution. Deferred. |
| XH-002 | MEDIUM | The implementation report lists the CI workflow change under "## Changes" as done; **the branch contains no such change**. The PR body and the Issue #3 comment both say the workflow "is not in the branch" — it *is*; only the modification is missing. |
| repo | MEDIUM | 26 `.uid` files are untracked and `.gitignore` does not exclude them → every checkout is dirty. |
| repo | MEDIUM | `README.md` names the wrong active branch, describes the touch overlay as "initial", and omits 7 touch suites from the test list. |
| repo | MEDIUM | The repository has **no** `tools/validate.sh`; the project's own convention (in `/workspace/btv/AGENTS.md`) prescribes one. |
| repo | LOW | No license, no topics, no branch protection; 16 branches and 3 stale draft PRs. |

### 6.2 Unresolved questions

1. **Which codebase is canonical** — the GitHub lineage or `/workspace/btv`? (VERIFIED that they differ;
   the choice is the creator's.)
2. **Should two sources be able to drive the same action simultaneously at all?** If yes, the player
   controller needs a summed input source rather than shared InputMap actions.
3. **Does the XH-002 branch need `workflows` write scope**, or should the creator paste the CI YAML?
4. **What is `btv/claude-review-temp-001` for**, and has Claude produced anything yet? (VERIFIED: no
   commits, no PR, no comment.)
5. **Is the creator's "continue autonomously" instruction the XH-002 approval that Issue #3 is waiting
   for?** The issue still says "NOT APPROVED"; the branch and draft PR exist.

### 6.3 Incomplete requirements

- **Android export pipeline** — no `export_presets.cfg`, no application identifier, no signing, and CI
  installs no export templates (`include-templates: false`).
- **No physical-device, emulator or export evidence** for anything, including multitouch, latency, thumb
  reach, orientation change and frame pacing.
- **Claude's visual review** has not started (no authenticated session from that agent).

### 6.4 Security state

- The GitHub credential is held in an **encrypted, account-scoped secret store** under the name
  `GITHUB_PAT`; it is referenced as `${GITHUB_PAT}` and never appears in any command, file, log, commit
  or published byte (VERIFIED: a full-length-PAT pattern scan over the workspace and the local MCP
  directory returns **0 files**). Authentication succeeds as the repository owner (VERIFIED).
- **The token was supplied in plaintext in a chat message**, so the transcript — not the store — is the
  exposure point. Rotation is recommended (VERIFIED risk, INFERRED consequence).
- **Its write scope is unproven**: the repository API reports owner-level `admin:true` while the declared
  scope is read-only. A read cannot separate the two; a controlled write would, and is approval-gated.
  **Do not assume read-only protection.**
- The repository is public, so all published artifacts stay readable without any credential — the
  exposure did not leak non-public data.

---

## 7. Next steps

### 7.1 Recommended next task — **XH-003**, on approval

**Objective:** give each input source its own action channel and compose the movement intent once in the
player controller, so that keyboard, touch and (later) gamepad cannot overwrite one another.

**Acceptance criteria** (all must hold, on the branch, with CI evidence):

1. The XH-003 acceptance test passes **all 12 assertions** in both ownership orders, using a real
   `InputEventKey` for the keyboard.
2. The `interact` action is covered by the same rule: releasing the touch button never cancels a
   keyboard-held **E**.
3. The existing 13 suites still pass (251 assertions), plus the new suite.
4. Movement is diagonal-safe: the composed vector is clamped to unit length.
5. `scripts/touch_controls.gd` no longer contains the ownership heuristic (`_owned_actions`,
   `_release_owned_action`, the strength comparison).
6. **CI runs on the branch** and executes **all 14 suites** (13 + the new one) — via a `workflow_dispatch`
   of the existing workflow, or by adding the branch and the suite steps to the workflow.
7. An implementation note is added under `docs/implementation/` (AGENTS.md requires one per system).

**Risks:** the deadzone change in `project.godot` must not be disturbed — the analog curve must stay
single-sourced in the adapter, and `Input.get_vector` must not re-apply a deadzone. Touch and keyboard
are separated by *action namespace*, so any other code that reads `move_forward` directly must be
checked for a hidden dependency. Movement feel changes for players who use both devices at once; the
clamp is the only place that is decided, so it must be reviewed explicitly.

### 7.2 Sequence after that

1. **CI evidence** for XH-002/XH-003 — dispatch first (no file edit), then the workflow edit for
   permanence.
2. **Rotate the credential** via the encrypted-drop path, not a chat paste.
3. **Correct the documentation** — implementation report, PR #4 body, README — so the coordinator's
   evidence base is accurate.
4. **Close the XH-002 gate** in Issue #3 (approval or rejection), then merge PR #4 only with the
   creator's explicit approval.
5. **Resolve the codebase divergence** between `/workspace/btv` and the repository.
6. **Add `tools/validate.sh`** and settle the `.uid` policy.
7. **Claude's visual brief** for HIGH-2 / HIGH-3, then a separate bounded task.
8. **Android export** — creator selects the application identifier; export templates and an export job
   follow.

---

## 8. Coordination

### 8.1 Does this session support an external MCP / ACP / API integration?

**MCP — yes, two servers are registered** (in `~/.minimax/mcp.json`, VERIFIED):

| Server | Type | Endpoint | Status now | Tools |
|---|---|---|---|---|
| `btv-lore` | stdio | `node /workspace/btv-lore/server/server.mjs` | **alive** — `initialize` + `tools/list` succeeded (VERIFIED this session) | `lore_search`, `lore_get`, `lore_list`, `lore_stats`, `repo_files`, `lore_gap` (6) |
| `btv-github` | http | `https://api.githubcopilot.com/mcp/` | **configured and functional** — session id issued, 39 tools (22 read / 17 write) | repos / issues / pull_requests |

**Important operational detail (VERIFIED):** MCP tools are bound at **session start**. `btv-github` was
registered after this session began, so its tools are not exposed as first-class tools here and
`tool_search` returns no GitHub hits — the server is nonetheless reachable and was exercised directly
over its HTTP endpoint with the same credential. A new session exposes the tools natively.

**ACP — not supported.** No Agent Communication Protocol endpoint is registered or advertised.

**REST API — yes, and it is the primary channel.** `https://api.github.com` with the stored credential;
this handoff and every figure above were gathered through it. The repository is public, so
unauthenticated reads also work.

**Publishing channel:** the established convention is (1) an evidence branch, (2) a draft PR, (3) an
Issue #3 comment in the 10-point protocol format. PR #5 and the Issue #3 comment are visible to any
authenticated agent.

### 8.2 Can this session be resumed through a documented interface?

**Yes.** The MCode session API exposes it: `session_get`, `session_list`, `session_messages` and
`session_update` (verified this session — `session_get` on `me` returns the session record). A peer
agent can therefore address this session by id, read its history, and update its metadata. Session
metadata is the only thing exposed this way; credentials are not.

**Resumption characteristics (VERIFIED):** the workspace at `/workspace` persists across cloud
sessions, but **globally installed CLI binaries do not** — `claude` and `codex` must be reinstalled
(`npm i -g @anthropic-ai/claude-code @openai/codex`) after a sandbox reset. Credentials and MCP
configuration live in the account-scoped secret store and the `~/.minimax` configuration, so they
survive.

**Not resumed by anyone yet (VERIFIED):** Claude and ChatGPT have not authenticated to the repository in
any session that left a trace. There is no PR, comment, or commit from either agent. The empty
`btv/claude-review-temp-001` branch is the only sign of activity.

---

*Prepared read-only. No repository, issue, pull request, workflow, permission or credential was changed.
This document contains no credential value, token, secret, authentication file or private session
content.*
