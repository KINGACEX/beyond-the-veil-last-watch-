# BTV — Secure Credential Verification & Read-Only Audit

**Audit date:** 2026-11-08 22:37–22:55 UTC
**Auditor:** MiniMax Code (MCode, cloud session 460954906607848)
**Repository:** `KINGACEX/beyond-the-veil-last-watch-` (public)
**Subject branch:** `btv/agent-minimax-xh-002` @ `34c5af7089efa83a151fbaa79e44a070d1bf21c5`
**Base branch:** `btv/mobile-touch-input-adapter-001` @ `3484672809ad95e4e36591e7ca7d49d5f61dfd5e`
**Mode:** READ-ONLY. Nothing was committed, pushed, merged, commented on, or reconfigured. Two probe
scripts were added to a scratch copy outside the repository (`/workspace/.audit/probe`) to obtain
execution evidence; the repository working tree was verified clean before and after.

**Evidence types are distinguished throughout:**
`SOURCE` = read from the published tree · `LOCAL` = executed here on Godot 4.7.2 headless ·
`CI` = GitHub Actions run records · `API` = GitHub REST responses.

---

# PHASE 1 — Credential Security Verification

| # | Property | Verdict | Evidence |
|---|---|---|---|
| 1 | Encrypted at rest | **CONFIRMED (agent environment)** / **UNKNOWN (platform internals)** | No plaintext token exists on any disk the agent can read: a pattern scan for a full-length `github_pat_` literal across `/workspace/` and `~/.minimax/` returns **0 files** (SOURCE). `~/.minimax/` contains exactly one file — `mcp.json` — whose Authorization header is the literal string `Bearer ${GITHUB_PAT}` (SOURCE). The store has **no local backing file at all**: no secret/vault/credential file exists in the sandbox, and the only key material present is the unrelated intake keypair. The store's read path never returns a plaintext value — `secret list` exposes names and descriptions only (API). Whether GitHub-side storage uses envelope encryption/KMS cannot be observed from inside the sandbox. |
| 2 | Encryption key protected separately | **CONFIRMED (agent environment)** / **UNKNOWN (platform)** | The sandbox holds **no key capable of decrypting the store**: the only private key on disk is `/workspace/.secrets/btv-intake.key` (mode 600), which is a locally generated RSA-3072 key for file intake and is unrelated to the store. `~/.gnupg/` contains an empty public keyring and **no secret keys**. The platform-side key custody model is not observable from here. |
| 3 | Stored persistently | **CONFIRMED** | Cross-session persistence is demonstrated: the previous token was stored in an earlier session and was injected into this session's environment at startup (it resolved to a 93-char value before being deleted). The current token was created in this session and resolves in every subsequent shell process. `secret list` shows one durable entry: `GITHUB_PAT`. |
| 4 | Retrieved securely when needed | **CONFIRMED** | `${GITHUB_PAT}` is injected into the process environment by the runtime. Every authenticated call in this audit used the **reference**, never the value: `curl -H "Authorization: Bearer ${GITHUB_PAT}"`. The literal token never appears in a command string, a file, a log, or any tool output in this audit. |
| 5 | GitHub authentication succeeds | **CONFIRMED** | `GET /user` → **HTTP 200**, authenticated as **KINGACEX** (type User). MCP `initialize` → session id issued; `tools/list` → **39 tools** (22 read, 17 write). Read paths verified: `issues` → 200, `pulls` → 200, `contents/README.md` → 200. |
| 6 | Restricted to the intended repository | **CONFIRMED for non-public data** / **UNKNOWN for the selection rule** | The token sees **17 repositories, all `visibility: public`** — which is GitHub's documented baseline for fine-grained PATs ("Tokens always include read-only access to all public repositories"). The owner has **no private repository** in the list, so there is no non-public asset the token can reach, and equally no private repo against which the "Only select repositories" restriction could be empirically proven or disproven. The token's access to the audited repo is confirmed; the scope *rule* is unverifiable in this environment. |
| 7 | Permissions read-only | **UNKNOWN — not proven** | The declared scope (`contents/issues/pull_requests/metadata: read`, no `workflows`) was supplied by the creator and matches the observable read behaviour. However the repository endpoint reports the token's effective permissions as `{"admin":true,"maintain":true,"push":true,"triage":true,"pull":true}` — owner-level rights (API). This field can reflect the authenticated principal's role rather than the fine-grained token's own grant, so the two readings cannot be separated by a read. The only decisive test is a write attempt, which this audit is not authorized to perform. **Treat the token's write scope as unverified.** |

**Verdict on secure storage:** available and sound for the agent environment. One item must be carried as
an open risk: the token was supplied as plaintext in a chat message, so the **conversation transcript is
the exposure point**, not the store. No fallback to plaintext storage was used — no file, no commit, no
report contains the value.

---

# PHASE 2 — Repository Audit

### 2.1 Repository status — CONFIRMED (API)
`KINGACEX/beyond-the-veil-last-watch-` · **public** · not a fork · default branch **`main`** · 1059 KB ·
created 2026-09-12 · last push **2026-11-08T22:11:00Z** · not archived, not disabled · issues on,
wiki on, discussions off, pages off · **no license** · no topics.

### 2.2 Branches — CONFIRMED (API)
**15 branches** (14 before the evidence branch was added today):

`main` (d3b028a) · `btv/agent-minimax-xh-002` (34c5af7) · `btv/agent-minimax-xh-002-evidence` (c19d0a5) ·
`btv/mobile-touch-input-adapter-001` (3484672) · `btv/project-history-and-lore-bridge-001` (1ba1c5a) ·
`btv/test-first-contracts-001` (0238555) · `btv/mission-validator-strict-types-001` (7542b2f) ·
`btv/bootstrap-prototype-001` · `btv/camera-relative-mouselook-001` · `btv/kay-family-character-bible-001` ·
`btv/nli-lifecycle-guard-001` · `btv/multi-agent-system-v1` · `codex/btv-write-access-proof` ·
`feature/m1-godot-foundation` · `test/gdunit4-compatibility-001`

No branch is protected (API: `protected: false` on all sampled).

### 2.3 Pull requests — CONFIRMED (API)

| PR | State | Head → Base | Merged | Notes |
|---|---|---|---|---|
| #2 | open, **draft** | `btv/mission-validator-strict-types-001` → `btv/test-first-contracts-001` | no | unrelated to XH-002 |
| #4 | open, **draft** | `btv/agent-minimax-xh-002` → `btv/mobile-touch-input-adapter-001` | no | subject of Phase 3; 11 files, +1040/−21, 2 commits, `mergeable: clean` |
| #5 | open, **draft** | `btv/agent-minimax-xh-002-evidence` → `btv/project-history-and-lore-bridge-001` | no | evidence pack, 8 files |

No PR has been merged, and none is merge-ready in the sense of having been reviewed — all three are
drafts.

### 2.4 Commits — CONFIRMED (API / LOCAL)
`btv/agent-minimax-xh-002` carries two commits:
- `8553804` — *fix: harden touch input lifecycle, analog composition and action ownership*
- `34c5af7` — *test: reconcile the XH-001 HIGH-1 and MEDIUM-2 qualifications*

Tip commit touches 7 files (`project.godot`, `scripts/player_controller.gd`, `scripts/touch_controls.gd`,
`tests/touch_controls_integration_test.gd`, + 3 new suites).

### 2.5 Issues and coordination records — CONFIRMED (API)
- **#3** *BTV Agent Coordination Hub* — open, 1 comment (the 10-point MiniMax Code acknowledgement,
  7536 chars, all ten protocol points present), no labels, no assignees, no milestone. Its work queue
  still records **XH-002 as "Proposed, NOT APPROVED / NOT STARTED"**.
- **#1** *Core Motive* — open, label `good first issue`, 0 comments, untouched since creation.
- Issues **#2 / #4 / #5** are pull requests surfaced through the issues API.
- **Total open issues: 5** (the repository's counter includes PRs).

### 2.6 Godot project structure — CONFIRMED (SOURCE)
The audited branch contains a coherent, minimal Godot 4 project:

```
project.godot                    scenes/main.tscn                 scenes/test_interactable.tscn
scenes/player.tscn               scenes/touch_controls.tscn
scripts/player_controller.gd     scripts/interactable.gd          scripts/test_interactable.gd
scripts/touch_controls.gd        scripts/touch_input_adapter.gd
scripts/nli/{command_parser,intent,knowledge_base,request_gate,service,validator}.gd
scripts/mission/mission_data_validator.gd
tests/ (13 suites) + tests/fixtures/
docs/{art,audits,coordination,implementation,qa,research,source-of-truth}/
```

26 `.gd` scripts, 4 scenes, 13 test suites, an extensive documentation corpus.

### 2.7 Test suites and results — CONFIRMED (LOCAL, independent)
Executed here on **Godot 4.7.2.stable.official.ed1daf0bf**, headless, against the published tree
extracted from git (`git archive btv/agent-minimax-xh-002`):

```
13/13 published suites PASS   0 FAIL
  nli_smoke_test                          PASS
  nli_contract_test                       PASS
  mission_data_validator_test             PASS
  core_interaction_acceptance_test        PASS
  player_camera_input_test                PASS
  touch_input_adapter_test                PASS
  touch_controls_integration_test         PASS
  touch_controls_lifecycle_test           PASS   (5 assertions executed)
  touch_controls_composition_test         PASS   (13 assertions executed)
  touch_controls_coexistence_test         PASS   (8 assertions executed)
  touch_controls_resize_test              PASS   (10 assertions executed)
  touch_controls_input_path_test          PASS   (6 assertions executed)
  touch_controls_reconciliation_test      PASS   (9 assertions executed)
main scene, 10-frame headless launch: PASS
```

This independently reproduces the "13/13" figure. **These are local results only — see 2.8.**

### 2.8 CI configuration and actual runs — CONFIRMED (API) — **GAP**
- `.github/workflows/godot-validation.yml` **exists on `btv/agent-minimax-xh-002`** (it was inherited from
  the base branch). It also exists on `btv/project-history-and-lore-bridge-001`,
  `btv/test-first-contracts-001` and `btv/mobile-touch-input-adapter-001`. It does **not** exist on `main`.
- The workflow's `on.push.branches` list contains **only** `btv/bootstrap-prototype-001`,
  `btv/test-first-contracts-001`, `btv/camera-relative-mouselook-001`,
  `btv/mobile-touch-input-adapter-001`. **The XH-002 branch is not in it.**
- The workflow references **none** of the six new XH-002 suites (grep for the six suite names → **0 matches**).
- Runs: **`btv/agent-minimax-xh-002` → 0 runs.** `btv/agent-minimax-xh-002-evidence` → 0 runs.
  `btv/mobile-touch-input-adapter-001` → 253 runs (latest #253 success @ `3484672`).
  `btv/test-first-contracts-001` → 196 runs. `main` → 0 runs.
- The workflow declares `on: workflow_dispatch:` — **a manual dispatch on the XH-002 branch would run CI
  today with no workflow edit at all.**
- The implementation report's claim that "CI run 42500466981" was reproduced locally resolves to
  *"BTV Godot Validation #253, completed/success, sha 3484672, branch btv/mobile-touch-input-adapter-001"*
  — a real, successful CI run **on the base branch** (API). The claim is accurate.

### 2.9 Documentation consistency — **DRIFT CONFIRMED** (SOURCE)
- `README.md` still states *"The active isolated engineering/research branch is `btv/test-first-contracts-001`"* —
  stale; the current work is on `btv/agent-minimax-xh-002`.
- `README.md` describes `scenes/touch_controls.tscn` / `scripts/touch_controls.gd` as an *"initial touch
  overlay mapped to shared InputMap actions"* — stale; it is now an analog joystick + look surface with
  ownership tracking.
- `README.md`'s `tests/` bullet lists only NLI, mission-validator and core-interaction tests — it omits
  **seven** touch suites present on this branch.
- `README.md` documents `.github/workflows/godot-validation.yml` as existing — true on this branch, false on
  `main`.
- The implementation report and PR body are internally consistent with each other on scope, but not with
  the branch contents (see Phase 4).

### 2.10 Outstanding bugs and technical risks
See the Phase 3/5 findings. The standing ones that are not part of XH-002: **HIGH-2** (fixed-pixel HUD,
no safe-area insets — `grep` for safe-area/notch across the whole branch returns **nothing**) and
**HIGH-3** (`look_sensitivity_degrees_per_pixel: float = 0.12` — per-pixel, therefore resolution-dependent).
Both are correctly deferred to the Visual Director, and both block Android readiness.

---

# PHASE 3 — XH-002 Technical Review

### 3.1 What the branch actually does (SOURCE)

`scripts/touch_controls.gd` introduces an **action-ownership table**:
`_owned_actions: Dictionary` maps action → the strength this overlay applied. `_set_action_strength()`
presses an action and records the strength; `_release_owned_action()` releases it **only if the action
still carries the recorded strength** (`absf(Input.get_action_strength(action) - owned_strength) <= 0.01`),
otherwise it leaves the action alone. `_release_all_actions()` iterates only over owned actions.
`_resolve_player()` re-queries the `btv_player` group whenever the cached instance is no longer valid.

Other changes: `NOTIFICATION_APPLICATION_PAUSED` handled alongside `NOTIFICATION_APPLICATION_FOCUS_OUT`;
`_input()` returns early when the overlay is hidden; `apply_look_delta()` made public on the player
controller (with a compatibility alias); the four movement actions' InputMap deadzone changed 0.2 → **0.0**
so the adapter's deadzone is the only one applied; `tests/touch_controls_integration_test.gd` now makes
the overlay visible.

### 3.2 The central question: can keyboard and touch contribute to the SAME action simultaneously?

**Short answer: no — and the mechanism that stops them interfering also prevents them combining.**

Godot keeps **one state per action** (one `pressed` flag, one `strength` value). There is no per-source
aggregation, so two sources driving `move_forward` cannot be summed. Measured here (LOCAL, scratch copy):

| Probe | Result |
|---|---|
| **C** — physical key held **first**, then touch drives the same action, then touch releases | Key registers (strength 1.000). During touch: effective strength **1.000** — the touch's 0.5 is **masked, not added**. After touch release: **still pressed, strength 1.000** → the keyboard survives. ✔ no interference |
| **D** — touch drives the action **first**, then a physical key is pressed, then touch releases | During: pressed, strength 1.000. After touch release: **still pressed** → the keyboard survives. ✔ no interference |
| **G** — key (1.0) + touch (0.5) simultaneously | Effective strength **1.000**, `Input.get_vector().y` = **1.000**. The touch contribution is **completely masked** by the keyboard; it contributes nothing to movement while the key is held. |
| **F** — key held + touch down, then **the key is released** (finger still on the joystick) | Effective strength drops to **0.000, pressed = false**. **The touch contribution is not restored.** Movement stays dead until the finger generates another drag event. ⚠ **stall** |

**Assessment.** The XH-002 design **does** solve interference: releasing a touch action no longer cancels a
keyboard-held action, in either order, and focus-loss/pause cleanup preserves the keyboard (LOCAL probe H:
pressed stays true, strength 1.000). That is a genuine, tested improvement over the base branch.

But simultaneous *contribution* to the same action is **not supported and is not achievable with this
architecture** — the keyboard's 1.0 masks the joystick entirely (probe G), and the transition where the key
is released while the touch is still held loses the touch contribution until the next drag event (probe F).
Both the PR body and the implementation report disclose the first half honestly ("Action ownership is a
heuristic… it cannot merge two simultaneous sources of one action"), but neither describes the **stall**
in probe F. This is a genuine, unclaimed defect, not a documentation gap.

The architectural fix, named by the report but not designed, is a dedicated input source that the player
controller sums — i.e. the player reads a merged movement vector instead of relying on `Input.get_vector()`
over shared actions.

### 3.3 The nine review focus areas

| # | Area | Verdict | Detail |
|---|---|---|---|
| 1 | Keyboard/touch coexistence | **CONFIRMED (no interference)** | `_owned_actions` + strength comparison. Verified in both orders (LOCAL C, D, H). |
| 2 | Touch release cancelling a keyboard-held action | **CONFIRMED FIXED** | Ownership check declines to release when the effective strength no longer matches what the overlay set (LOCAL C, D). Base branch released unconditionally → cancelled the key. |
| 3 | Player re-resolution after respawn | **CONFIRMED FIXED** | `_resolve_player()` re-queries the `btv_player` group when the cached instance is invalid; called in `_ready()` and before every look delta (SOURCE). LOCAL: the next look drag re-resolves and the replacement player's camera receives the delta. |
| 4 | Analog deadzone & movement math | **CONFIRMED** | InputMap deadzone 0.0 + single adapter curve. The PR's published figures reproduce exactly by hand: (0.25−0.12)/0.88 = 0.14772, (0.50−0.12)/0.88 = 0.43182, (0.75−0.12)/0.88 = 0.71591 — the report states 0.1477 / 0.4318 / 0.7159. LOCAL probe E: `get_vector` with raw strength 0.1 → **0.100**, i.e. no second deadzone. The deadzone itself is single-sourced in `touch_input_adapter.gd` (unchanged by this branch). |
| 5 | Pause & overlay input handling | **CONFIRMED FIXED** | `NOTIFICATION_APPLICATION_PAUSED` now handled beside `NOTIFICATION_APPLICATION_FOCUS_OUT`; both route to `_cancel_all_touch_input()` → adapter cancel + zero vector + ownership-aware release. `_input()` returns early when `not visible` (SOURCE). LOCAL probe H: keyboard survives cleanup. |
| 6 | Physical multitouch | **PARTIALLY CONFIRMED** | The adapter enforces one movement finger and one look finger (`begin_movement`/`begin_look` refuse a second finger and refuse the finger already used by the other role), and the Interact button is excluded from the look surface (SOURCE). But multitouch is exercised only through **synthetic** `InputEventScreenTouch`/`ScreenDrag` in headless — there is **no physical-device evidence**, and `tests/touch_controls_input_path_test.gd` is the only suite that pushes events through real viewport routing. |
| 7 | HUD safe-area handling | **NOT ADDRESSED — CONFIRMED OPEN** | `git grep` for safe-area/notch/insets across the whole branch returns **nothing**. The HUD is fixed-pixel with no notch or gesture-area handling. Correctly deferred (HIGH-2) — but it blocks Android readiness. |
| 8 | Resolution-independent camera sensitivity | **NOT ADDRESSED — CONFIRMED OPEN** | `look_sensitivity_degrees_per_pixel: float = 0.12` — expressed per screen **pixel**, so the same finger swipe turns the camera differently on different resolutions. Correctly deferred (HIGH-3), same blocker. |
| 9 | Test coverage & missing acceptance tests | **CONFIRMED — good, with named gaps** | 6 new suites, 51 executed assertions across them, plus an independently reproduced 13/13 green run. Missing: any physical-device or emulator test; any test of the **same-action simultaneous-contribution stall** (probe F); any test of the joystick's interaction with an Android back/system gesture; any test of the `NOTIFICATION_APPLICATION_PAUSED` path specifically (only focus-out is asserted). |

### 3.4 Base-branch comparison
The base branch's `scripts/touch_controls.gd` released **every** action unconditionally on focus-out and
on tree exit, had **no** player re-resolution, and left the InputMap deadzone at 0.2 on top of the
adapter's own 0.12. Every one of the five XH-002 defects is genuinely addressed on the branch. The branch
is a real improvement — the findings above are refinements, not a refutation.

---

# PHASE 4 — Independent Verification

Claims were checked against the artifacts themselves, not against my own earlier summaries.

| Claim (source) | Verified result | Verdict |
|---|---|---|
| "PASS — 12/12 suites" (PR #4 body) | 13/13 pass (LOCAL, independent) | **Understated** — the reconciliation suite was added in the second commit and the PR body was never updated |
| "12/12 suites pass" (implementation report) | same | **Understated**, same cause |
| "Add five headless suites (37 assertions)" (PR #4 body) | 6 suites; the five named execute **42** assertions | **Understated and miscounted** — call-site counting, not executed assertions; also omits the 6th suite |
| "The five new suites run in CI, and the branch is added to the push trigger list" (implementation report, § *Changes*) | The workflow file on the branch contains **0 references** to any new suite and **does not** list the branch in its trigger list; the file is byte-identical to the base branch's | **FALSE — contradicted by the branch.** The report lists a change that does not exist in the tree |
| "`.github/workflows/godot-validation.yml` is **not** included in this branch" (PR #4 body) | The file **is** on the branch (inherited from the base). What is missing is the *modification* | **Misleading** — invites the reviewer to think the branch has no CI workflow at all |
| "This branch is **not merged** and **not pushed**" (implementation report) | Branch is pushed; PR #4 is open at `34c5af7` | **Stale / false** — written before the push |
| "Action ownership is a heuristic… the last writer wins… it cannot merge two simultaneous sources" (PR body + report) | Correct in substance, but incomplete: probe F shows a key **release** zeroes the action and drops the still-held touch contribution entirely | **Accurate but incomplete** — the documented "last writer wins" understates a real stall |
| "The workflow file … could not be pushed (no `workflow` scope)" | True for *modifying* a file under `.github/workflows/`. But `workflow_dispatch:` is already present in the workflow | **Incomplete remedy** — a manual dispatch would run CI on this branch today with no workflow edit |
| "reproduced CI run 42500466981 locally" | Resolves to *"BTV Godot Validation #253, success, sha 3484672, branch btv/mobile-touch-input-adapter-001"* | **CONFIRMED** |
| "`.uid` files remain untracked" | 0 `.uid` files tracked on the branch vs 26 `.gd` scripts; `.gitignore` does not exclude them | **CONFIRMED** |
| "keyboard-held actions survive touch release, focus loss and teardown" (coexistence suite) | Independently reproduced LOCAL (probes C, D, H) | **CONFIRMED** |
| "13/13 suites PASS at 34c5af7" (Issue #3 comment) | Independently reproduced | **CONFIRMED** |
| "The workflow is therefore not in the branch. CI currently shows 0 runs for this branch" (Issue #3 comment) | "0 runs" is **true**; "not in the branch" is **misleading** in the same way as the PR body | **Partially false** |
| "The PAT was pasted in plaintext into the agent chat" (Issue #3 comment) | True of the first token; a second token has since been pasted in the same way | **True but now understated** |
| Deadzone arithmetic 0.1477 / 0.4318 / 0.7159 (PR body) | Reproduces exactly from (m−0.12)/0.88 | **CONFIRMED** |

**Material contradictions:** 1 (report claims a workflow change that does not exist) · **Stale claims:** 3
· **Misleading claims:** 2 · **Understated counts:** 3 · **Unsupported/outright false:** the report's
"not pushed".

---

# PHASE 5 — Findings

## Credential
| ID | Sev | Finding | Evidence | Next action |
|---|---|---|---|---|
| **CRED-01** | **HIGH** | The live token was supplied as plaintext in a chat message, so it is exposed in the session transcript and model context. The encrypted store does not remove that copy. | Chat input | Rotate after this audit. Use the encrypted-drop path (`/workspace/.secrets/` + `btv-intake.pub`) or the client secrets UI so the value never enters a message. |
| **CRED-02** | MEDIUM | Write scope is unproven: the repository API reports `admin:true` for this token while the declared scope is read-only. | API | Do not rely on the read-only declaration for protection. Confirm by a single approved write attempt, or mint the token with `workflows=write` excluded and verify via the token's own permission page. |
| **CRED-03** | LOW | The token is injected into every shell the agent runs, so every child process can read it. | SOURCE | Inherent to the runtime's secret-injection model; minimise the number of shell invocations that touch it. |
| **CRED-04** | INFO | Platform-side storage encryption and key custody cannot be observed from inside the sandbox. | — | Marked UNKNOWN; no action available locally. |

## Repository
| ID | Sev | Finding | Evidence | Next action |
|---|---|---|---|---|
| **REPO-01** | **HIGH** | **XH-002 has zero CI evidence.** The workflow file exists on the branch but the branch is absent from `on.push.branches`, and the workflow runs none of the six new suites. | API + SOURCE | Two options, in order of cost: (a) `workflow_dispatch` the existing workflow on the branch — needs `actions:write` + your approval, no file edit; (b) add the branch and the six suite steps to the workflow — needs the `workflow` scope or a web-editor paste. |
| **REPO-02** | MEDIUM | `README.md` names the wrong active branch, describes the touch overlay as "initial", and omits seven touch suites from the test list. | SOURCE | Update the README on the XH-002 branch. |
| **REPO-03** | MEDIUM | 26 `.uid` files are untracked and `.gitignore` does not exclude them → every checkout is a dirty working tree, and the files will not survive a move between machines. | SOURCE + API | Either commit the `.uid` files (Godot 4.7 convention) or add `*.uid` to `.gitignore`. |
| **REPO-04** | MEDIUM | The audited repository has **no** `tools/validate.sh` and no single-command validation entry point, while the project's own convention (in `/workspace/btv/AGENTS.md`) prescribes one. | SOURCE | Add a `tools/validate.sh` to the repo that imports, parse-checks and runs all suites — one command, one exit code. |
| **REPO-05** | MEDIUM | **`/workspace/btv` is a divergent working copy that matches no branch of this repository** — different layout (`scripts/core/`, `scripts/player/`, `tests/cases/`, `tools/`), no touch controls, no NLI, no mission validator. 17 of its 22 files exist in no branch. | SOURCE + API | Decide which codebase is canonical. The XH-001/XH-002 work was done against the GitHub lineage; the local copy has never received it. |
| **REPO-06** | LOW | 15 branches, 3 stale draft PRs (#2 unrelated, #4, #5), no branch protection, no license, no topics. | API | Prune/close stale drafts when you decide the direction; add a license and branch protection for `main`. |

## XH-002
| ID | Sev | Finding | Evidence | Next action |
|---|---|---|---|---|
| **XH2-01** | **HIGH** | **Same-action simultaneous contribution is impossible, and the key-release transition stalls the touch input.** With the keyboard held, the joystick's analog contribution is masked entirely (effective strength 1.000, vector 1.000); when the key is released while the finger is still down, the action drops to 0.000 and does not resume until the next drag event. | LOCAL probes F, G | Decide the intended behaviour, then implement a summed input source (player reads a merged movement vector) rather than relying on shared `Input.get_vector()` actions. This is a design decision, not a patch. |
| **XH2-02** | **HIGH** | The implementation report lists the CI workflow change under "## Changes" as done. The branch contains no such change. | SOURCE vs report | Correct the report before it is used as evidence by the coordinator. |
| **XH2-03** | **HIGH** | No CI run exists for the branch; every XH-002 test claim is local-only. | API | REPO-01. |
| **XH2-04** | MEDIUM | PR body and report both say "the workflow file is not in this branch" / "not in the branch". The file is present; only the modification is missing. Both mislead a reviewer. | API + SOURCE | Reword to "the workflow change is not applied; the file inherited from the base branch runs only the seven pre-existing suites". |
| **XH2-05** | MEDIUM | The CI patch covers only five of the six new suites — `touch_controls_reconciliation_test.gd` is missing. | SOURCE | Include the sixth step when the workflow is updated. |
| **XH2-06** | MEDIUM | HIGH-2 (no safe-area insets) and HIGH-3 (per-pixel look sensitivity) remain open, as correctly deferred. Both block Android readiness. | SOURCE (`grep` = 0 hits; `look_sensitivity_degrees_per_pixel`) | Claude's visual brief, then a separate bounded task. |
| **XH2-07** | MEDIUM | Multitouch is only ever synthetic; no emulator or device evidence exists for any of it. | SOURCE + LOCAL | Device QA remains mandatory before any release claim. |
| **XH2-08** | LOW | Suite and assertion counts are stale/understated in both the PR body (12/12, 37) and the report (12/12, per-suite 4/12/7/9/5). Actual: 13/13 and 42 executed assertions across the five, 51 across all six. | LOCAL | Refresh when the docs are next edited. |
| **XH2-09** | LOW | The report says the branch is "not pushed"; it is pushed, and PR #4 is open. | API | Refresh the report header. |
| **XH2-10** | LOW | `NOTIFICATION_APPLICATION_PAUSED` is implemented but not asserted by any suite — only the focus-out path is tested. | SOURCE | Add one assertion; cheap and closes a real Android-only path. |

---

# Closing

## 1. Credential security verdict
**CONDITIONALLY SOUND.** The credential is held in the platform's encrypted, persistent secret store; no
plaintext token exists on any disk the agent can read; no key material for the store is present in the
sandbox; the value is retrieved by reference only and never appears in a command, a file, a log, a commit
or a report; authentication succeeds as KINGACEX; and no non-public resource is reachable through it.
Two open items: the token is exposed in the chat transcript (CRED-01) and its **write** scope is
**unproven** (CRED-02). Storage did not fall back to plaintext at any point.

## 2. Repository health verdict
**STABLE BUT DRIFTING.** The repository is public, active, and has a coherent Godot 4 structure with
13 passing suites and a real CI history on the base branch. Against that: XH-002 has **no** CI evidence
(REPO-01), the README has drifted from the code (REPO-02), `.uid` files are untracked (REPO-03), there is
no one-command validation harness (REPO-04), and the local working copy `/workspace/btv` is a **different
codebase** that matches no branch (REPO-05). The single most important structural fact: the repository's
default branch `main` contains **2 files** and no CI — all engineering lives on unmerged branches.

## 3. XH-002 readiness verdict
**NOT READY TO MERGE; TECHNICALLY SOUND AT ITS STATED SCOPE.** The five targeted defects are genuinely
fixed and independently reproduced (13/13 local, 0 CI). The central question has a precise answer:
**interference is solved, simultaneous contribution is not** — the keyboard masks the joystick, and the
key-release transition stalls the touch input (XH2-01). The supporting documentation overstates its own
evidence in two places (XH2-02, XH2-04) and the CI gap means the "13/13" figure is unverified by any
independent runner (XH2-03). Merge readiness additionally requires your approval and, ideally, one CI
dispatch on the branch.

## 4. Outstanding blockers
1. **CI evidence absent for XH-002** — 0 runs; workflow not triggered on the branch; six suites not in the workflow.
2. **Token write scope unproven** — API reports `admin:true` against a read-only declaration.
3. **Token exposed in the chat transcript** — rotation pending.
4. **HIGH-2 / HIGH-3 open** — no safe-area insets; per-pixel look sensitivity. Both block Android readiness.
5. **Android export unconfigured** — no `export_presets.cfg`, no application identifier, no signing, no export templates in CI.
6. **Codebase divergence** — `/workspace/btv` vs the audited repository is unresolved.
7. **No physical-device evidence** — every result in this audit is headless and synthetic.

## 5. Recommended next development steps
1. **Rotate the credential** via the encrypted-drop path or the client secrets UI — never a chat paste.
2. **Run CI on the branch**: `workflow_dispatch` the existing `godot-validation.yml` on `btv/agent-minimax-xh-002`
   (needs `actions:write` + your approval, no file edit) — this yields independent evidence in minutes.
3. **Update the workflow** (web editor or a PAT with `workflow` scope): add the branch to `on.push.branches`
   and add the **six** suite steps, including the reconciliation suite.
4. **Decide the same-action behaviour** (XH2-01) and, if simultaneous contribution is wanted, design the
   summed input source before more HUD work lands on the current model.
5. **Correct the implementation report** (XH2-02, XH2-04, XH2-08, XH2-09) and the PR body, so the
   coordinator's evidence base is accurate.
6. **Refresh `README.md`** (REPO-02) and settle **`.uid` tracking** (REPO-03).
7. **Add `tools/validate.sh`** to the repository (REPO-04) and reconcile `/workspace/btv` with the
   repository (REPO-05).
8. **Obtain Claude's visual brief** for HIGH-2 and HIGH-3, then address them in a separate bounded task.

## 6. Actions requiring your approval
Nothing below was performed. Each is a write, and each is available on your word:

| # | Action | Why it needs approval | Prereq |
|---|---|---|---|
| A1 | **Dispatch `godot-validation.yml` on `btv/agent-minimax-xh-002`** | Starts a CI run (a write to GitHub Actions) | Token with `actions:write`, or your own dispatch |
| A2 | **Update `.github/workflows/godot-validation.yml`** | GitHub refuses PAT writes to workflow paths without the `workflow` scope | `workflow` scope, or your web-editor paste |
| A3 | **Commit and push a corrected implementation report + PR body + README** | Repository writes | your go-ahead |
| A4 | **Post the audit findings to Issue #3** | Issue comment (write) | your go-ahead |
| A5 | **Add `tools/validate.sh`, commit `.uid` files or ignore them** | Repository writes | your go-ahead |
| A6 | **Close or update stale draft PRs (#2, #5)** | PR writes | your go-ahead |
| A7 | **Probe the token's true write scope with one controlled write** | Repository write, purpose-built to measure scope | your explicit approval, and a throwaway branch |
| A8 | **Merge PR #4** | Merge | your explicit approval, after A1–A5 |
| A9 | **Mint a replacement token with `workflows:write`** | Token creation — browser-only, your action | your action; I can supply the pre-filled URL |
| A10 | **Rotate to a GitHub App** (1-hour installation tokens, no manual rotation) | App creation and install | your decision |

---

*Audited read-only. No repository, issue, pull request, workflow, or account setting was modified. The
credential value never appeared in any command, file, log, or output produced by this audit.*
