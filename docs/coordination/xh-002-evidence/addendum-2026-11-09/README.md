# Addendum — 2026-11-09

**Published by:** MiniMax Code / Mavis · 2026-11-09 07:10 UTC
**Scope:** read-only audit + XH-003 proposal + coordinator handoff. **No implementation.**
**Branch:** `btv/agent-minimax-xh-002-evidence` (PR #5) — **PR #4 and the XH-002 work branch are
untouched**, and their commit SHAs are unchanged.

This addendum exists because the original evidence pack was published at 2026-11-08 22:11 UTC, before
the audit and the XH-003 work existed. A reviewer reading PR #4 and the original pack alone would not
see the findings below.

## Read in this order

| # | Document | What it gives you | Status |
|---|---|---|---|
| 1 | `BTV_SECURITY_AND_READONLY_AUDIT_2026-11-08.md` | Full audit: credential security (7 properties), repository audit, 9-point XH-002 technical review, claim-by-claim cross-check, **20 findings** with IDs, severity, evidence and next actions | CONFIRMED / UNKNOWN / BLOCKED as labelled |
| 2 | `BTV_XH-003_SAME_ACTION_COMPOSITION_PROPOSAL_2026-11-09.md` | **Root cause** of the same-action input defect, the reproduction evidence table, the minimal architecture proposal, the authoritative test inventory, the precise CI diff | PROPOSED — awaiting creator approval |
| 3 | `BTV_CHATGPT_COORDINATION_HANDOFF_2026-11-09.md` | Coordinator-facing handoff: session, repository, changes, tests, GitHub state, outstanding work, next steps, coordination interfaces. Verified facts separated from assumptions | — |
| 4 | `TEST_SOURCES.md` | The XH-003 acceptance test and the four audit/diagnostic scripts, as text, with reproduction instructions | PROPOSED |

## The three things a reviewer most needs to know

1. **A real defect remains open in XH-002, and it is the same-action case.** XH-002's ownership table
   infers "is this action still mine?" by comparing the strength the overlay applied against the
   engine's current strength. Godot keeps **one strength slot per action**, so when the keyboard is held
   (strength `1.0`) and the joystick is at full deflection (also `1.0`) the check concludes "still mine"
   and **releases the action, cancelling the keyboard**. Below full deflection it survives. The mirror
   case — releasing the key while the joystick is held — zeroes the action and drops the joystick's
   contribution until the next drag event. The same defect reaches the shared `interact` action.
   The XH-003 acceptance test **fails 4 of 12 assertions** on the current branch. Full evidence and the
   minimal fix (separate action namespaces, compose once in the player controller) are in document 2.

2. **Two claims in the already-published artifacts are wrong and should not be relied on.**
   - The implementation report (`docs/implementation/BTV_XH-002_TOUCH_INPUT_HARDENING_2026-11-08.md`)
     lists the CI workflow change under *## Changes* as done. **The branch contains no such change.**
   - PR #4's body and the Issue #3 comment say the workflow file "is not in the branch". It **is** on
     the branch (inherited from the base branch); only the *modification* is missing. The file's
     `on.push.branches` list does not contain this branch and it runs none of the six new suites.
   - Both also say **12/12** suites. The current, independently reproduced figure is **13/13**
     (13 suites, **251 assertions**). The difference is one commit — `34c5af7` added
     `touch_controls_reconciliation_test.gd` after those documents were written.

3. **XH-002 has no CI evidence at all.** `btv/agent-minimax-xh-002` → **0 workflow runs**. Every test
   result for XH-002 is local and headless. The cheapest remedy needs no file edit at all: the workflow
   already declares `on: workflow_dispatch:`.

## Credential state

The GitHub credential is held in an encrypted, account-scoped secret store as `GITHUB_PAT`, referenced
as `${GITHUB_PAT}`, and appears in **zero** published bytes. Two open items, both stated in the audit:
the token was supplied as plaintext in a chat message (so the transcript is the exposure point), and its
**write scope is unproven** — the repository API reports owner-level `admin:true` while the declared
scope is read-only. Do not assume read-only protection. No credential value appears in any document in
this addendum.

## XH-003 — implemented on a successor branch (2026-11-10)

The same-action defect in finding 1 above is **fixed** on `btv/agent-minimax-xh-003` (draft PR #7,
base `btv/agent-minimax-xh-002`), by giving each input source its own action namespace and composing
keyboard + touch once in the player controller.

- Branch: `btv/agent-minimax-xh-003` @ `61c35aefbd6e5b4562fdb3f684c16a0367a89aac`
- Draft PR: https://github.com/KINGACEX/beyond-the-veil-last-watch-/pull/7
- Implementation note: `docs/implementation/BTV_XH-003_SAME_ACTION_COMPOSITION_2026-11-09.md` (on that branch)
- Tests on that branch: **14/14 suites, 276 assertions, 0 failures** (headless Godot 4.7.2) — the 13
  suites on the XH-002 branch plus the new `tests/xh003_same_action_composition_test.gd` (22 assertions).
- The counts on **this** page remain correct for the **XH-002** branch: 13 suites, 251 assertions.

PR #4's description was reconciled in the same pass: the "12/12 suites" figure is now "13/13 (251
assertions)", the statement that the workflow file "is not included in this branch" is corrected (the file
**is** on the branch; only the modification is missing), and the cheapest CI remedy — dispatching the
existing workflow — is recorded.

## What was deliberately not done

No implementation of XH-003 · no commit to `btv/agent-minimax-xh-002` · no change to PR #4 · no merge ·
no default-branch change · no workflow edit · no permission or credential change · no Android export
configuration or application ID · no canon change · no issue or PR comment beyond the single pointer
posted alongside this addendum.
