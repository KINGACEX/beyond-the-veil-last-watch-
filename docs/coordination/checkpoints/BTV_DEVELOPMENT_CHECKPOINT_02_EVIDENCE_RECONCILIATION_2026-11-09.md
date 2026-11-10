# BTV Development Checkpoint 02 — Evidence Reconciliation — 2026-11-09

Status: COMPLETED — DOCUMENTARY / READ-ONLY REVIEW
Branch: `btv/agent-minimax-xh-002-evidence`
No game source was changed. No implementation branch, PR #4, CI workflow, credentials, permissions, export configuration, or default branch was modified.

## 1. Correction to Checkpoint 01

Checkpoint 01 described the 12/12 versus 13/13 test count as unreconciled. The evidence branch's security audit and XH-003 proposal explain the difference:

- PR #4 was written against the earlier XH-002 state and reports 12/12.
- Commit `34c5af7` added `tests/touch_controls_reconciliation_test.gd`.
- The later published test inventory reports 13/13 suites and 251 assertions.
- MiniMax reports independently executing those 13 suites in a Godot 4.7.2 headless scratch copy.

This resolves the **count discrepancy in the published evidence**. It does not mean this assistant has executed the suite. It remains local agent evidence, not GitHub Actions evidence.

## 2. CI status — verified

For XH-002 commit `34c5af7089efa83a151fbaa79e44a070d1bf21c5`:
- GitHub combined status endpoint returned no status checks.
- GitHub Actions workflow-run query returned zero runs.
- The inherited workflow file exists on the XH-002 branch, but its push branch list does not include XH-002 and its listed steps do not invoke the six new XH-002 suites.
- The workflow supports manual dispatch according to the published audit. No dispatch was performed because the creator's scope clarification explicitly excludes CI/workflow actions.

Therefore: local suite evidence = agent-reported PASS; CI = NOT RUN.

## 3. XH-003 acceptance gap — confirmed from source evidence

The evidence branch's XH-003 proposal describes a scratch-copy reproduction with 4 of 12 assertions failing on the XH-002 implementation:
- keyboard held, touch joystick released first: keyboard movement is cancelled at full joystick strength;
- joystick held, keyboard released first: the shared action is zeroed, losing the touch contribution until another drag event;
- the same shared-action defect affects keyboard E and touch Interact.

The published XH-003 test source uses real `InputEventKey` events and exercises both movement release orders. This is stronger than the existing coexistence test, which used synthetic `Input.action_press()` and tested different actions rather than two sources contending for the same action.

## 4. Additional source-level finding

The XH-002 reconciliation suite tests freed-instance semantics and physical-key cleanup. The separate XH-003 acceptance test is still only documented as a proposal in the evidence pack; it is not present as an implementation test in the XH-002 branch.

The accepted architecture remains Option A:
- keyboard continues using `move_*`;
- touch uses `touch_move_*` and `touch_interact`;
- player composes the two movement vectors once and clamps to unit length;
- touch ownership heuristic is removed only after all touch controls have migrated.

## 5. Credential security note

The published security audit records a plaintext GitHub token in an earlier chat transcript and says effective write scope was not proven by read-only inspection. Do not paste credentials into chats, issues, source files, or logs. The account owner should revoke/rotate any token exposed in a transcript and update the encrypted agent secret through the provider's secure secret interface. No credential operation was performed here.

## 6. Source reconciliation remains a hard gate

The published proposal says MiniMax's scratch-copy audit used `git archive` of the GitHub XH-002 tree, while the separate private `/workspace/btv` project was previously reported as divergent. This does not establish that the private working tree is identical to the GitHub branch.

Before implementation, obtain the private workspace's:
```bash
git rev-parse HEAD
git status --short --branch
git remote -v
```
Do not reset, clean, overwrite, or cherry-pick into that workspace. Compare its HEAD and status with XH-002 base/head, inspect uncommitted changes, and explicitly name the canonical source. If the local workspace cannot be inspected, use a fresh isolated checkout of the agreed GitHub commit rather than assuming the private workspace is synchronized; retain any private local work untouched.

## 7. 30-point review rubric — scoring not yet awarded

| Area | Points | Evidence required |
|---|---:|---|
| Correct source/base and clean isolation | 4 | verified base SHA, branch, clean/dirty status, no unrelated changes |
| Architecture and source ownership | 5 | separate keyboard/touch actions; one composition point; no shared-state heuristic |
| Regression coverage | 6 | both movement release orders, both sources release, Interact, existing touch lifecycle |
| Full Godot validation | 5 | exact Godot version, all suites, assertion totals, zero failures, raw logs |
| Runtime and lifecycle safety | 4 | pause/focus cleanup, respawn, hidden overlay, analog deadzone, diagonal clamp |
| Change quality and reviewability | 3 | focused diff, documentation, no unrelated canon/assets/workflow changes |
| Honest platform limitations | 3 | explicit absence/presence of emulator/device/export evidence |
| **Total** | **30** | Target: at least 27/30, and all mandatory tests pass |

No numerical score is awarded before implementation and independent review. A high score cannot compensate for a failing mandatory regression test or unverified source base.

## 8. Next checkpoint

Checkpoint 03 — source identity and implementation readiness.
Required outputs: canonical source decision, exact base SHA, clean/dirty status, isolated implementation branch, XH-003 patch, full test logs, and review score. PR must remain draft. No merge or release.
