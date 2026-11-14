# BTV Agent Workstream and Integration Contract

**Version:** 0.1  
**Status:** Approved coordination direction; assignments must be confirmed against the live local worktree before execution  
**Purpose:** Parallelize implementation without overlapping file ownership, losing work or integrating unverified behavior.

## 1. Operating rules

1. Inspect the active branch, HEAD, dirty paths, stash and current agent ownership before starting.
2. Do not assume the GitHub documentation branch is the active local gameplay branch.
3. Each implementation agent works in an isolated worktree or clearly isolated branch.
4. Each workstream declares exact files it may edit before implementation.
5. Shared files have one designated owner at a time.
6. Agents do not edit files owned by another active workstream.
7. Integration is performed by a designated integrator after review and test evidence.
8. No agent commits, pushes, merges, rebases, resets, cleans, publishes, changes live persistence, or spends money without the required explicit approval.
9. Canon and theology changes are outside ordinary engineering authority.
10. Report source changes, tests, runtime limitations and unresolved risks separately.

## 2. Workstream ownership

The assignments below define functional ownership. Exact file paths must be confirmed from the current repository before work begins; the list is not permission to assume that a suggested file exists.

### A. Gameplay Agent

**Mission:** Temple opening, Ridgeview exploration, objectives, investigation progression and report-draft flow.

**Owns conceptually:**
- Temple and Ridgeview gameplay scripts.
- Mission objective policy and progression integration points.
- Investigation interactions and world objective triggers.
- Gameplay-specific acceptance tests.

**Must not own:**
- Profile coordinator internals.
- Shared persistence adapter semantics.
- Ember controller internals.
- Global Bootstrap/player lifecycle without an explicit handoff.

**Deliverables:**
- A verified mission flow with prerequisites and objective state transitions.
- Idempotent objective completion.
- Correct evidence IDs and source attribution.
- No invented report submission, verdict or reward.
- Offline tests plus Studio evidence when available.

### B. Ember Agent

**Mission:** Companion command controller, navigation, interactions and per-player actor lifecycle.

**Owns conceptually:**
- Ember command policy and controller.
- Ember-specific client UI/controller.
- Ember-specific tests and diagnostics.

**Must not own:**
- Mission service internals except through an agreed interface.
- Profile persistence internals.
- Shared Bootstrap lifecycle.
- Other players' companion state.

**Deliverables:**
- Preserve existing Hold and Regroup behavior.
- Implement additional commands only as separately scoped, accepted tasks.
- Server-side ownership and target validation.
- Deterministic interruption, cancellation and cleanup.
- Two-player isolation tests.
- Mobile command usability evidence.

### C. Persistence Agent

**Mission:** Profile session lifecycle, save status semantics, retry and recovery safety.

**Owns conceptually:**
- Profile session coordinator.
- Persistence bridge/adapter.
- Profile-focused tests and fake-store integration tests.

**Must not own:**
- Gameplay mission logic.
- Dialogue policy or consent UI.
- Ember command behavior.
- Live DataStore activation or schema migration without explicit approval.

**Deliverables:**
- Preserve the Saved, Pending, Rejected and Disabled distinctions.
- Ensure invalid mutations do not partially alter profiles.
- Ensure accepted but unsaved changes remain explicitly Pending.
- Test save failure and later retry with fake storage.
- Document pending-data loss risk before durable release.
- Keep the live persistence gate disabled until release criteria are met.

### D. Multiplayer and Security Agent

**Mission:** Remote validation, player isolation, concurrency, startup ordering and lifecycle security.

**Owns conceptually:**
- Shared remote validation policy only when explicitly assigned.
- Security and multiplayer tests.
- Test harnesses and test fixtures that do not modify another agent's production modules.

**Must not own:**
- Feature implementation in Gameplay, Ember or Persistence without a handoff.
- Shared Bootstrap changes while another agent owns lifecycle work.
- Consent policy changes without Gameplay/Dialogue owner agreement.

**Deliverables:**
- Execute the Multiplayer Interaction and Security Test Catalogue.
- Reproduce and verify the dialogue consent concurrency case.
- Reproduce and verify player initialization ordering.
- Test cross-player mission, Ember, Field Notes and session isolation.
- Report blocked runtime cases as BLOCKED, never PASS.

### E. Integrator / Technical Lead

**Mission:** Resolve interfaces, manage integration windows and protect repository integrity.

**Owns:**
- Workstream manifest and file ownership ledger.
- Integration branch/worktree.
- Interface contract review.
- Cross-workstream regression suite.
- Final integration report.

**Must not:**
- Rewrite another agent's work without first coordinating.
- Resolve conflicts by discarding dirty work.
- merge code merely because individual tests pass.

**Deliverables:**
- Confirm each agent's base commit and changed-file list.
- Review diffs for scope and compatibility.
- Integrate one workstream at a time.
- Run combined tests after each integration.
- Preserve recoverable snapshots and exact provenance.

## 3. Dependency and integration order

Recommended order:

1. **Preservation checkpoint:** capture branch, HEAD, dirty paths, stash and verified backup.
2. **Persistence status contract:** confirm existing local fix and test behavior; do not activate live storage.
3. **Lifecycle and concurrency fixes:** resolve player initialization and dialogue consent races with controlled tests.
4. **Gameplay interface freeze:** agree mission/objective/evidence contracts before feature expansion.
5. **Gameplay and Ember implementation:** proceed in isolated worktrees against the agreed interfaces.
6. **Multiplayer integration:** run cross-player and concurrency tests against the combined implementation.
7. **Studio and Android validation:** verify runtime behavior on supported platforms.
8. **Release review:** assess canon, data safety, performance, rollback and publishing approval.

Dependencies:
- Gameplay progression depends on stable profile mutation semantics.
- Consent-sensitive dialogue depends on authoritative, concurrency-safe state.
- Ember multiplayer acceptance depends on per-player ownership and lifecycle cleanup.
- End-to-end acceptance depends on the combined mission, evidence and dialogue contracts.
- Durable progression release depends on controlled persistence and reconnect verification.

## 4. Shared-file lock protocol

Before editing a shared file, the agent must publish:

- File path.
- Current base commit.
- Intended change.
- Expected duration or completion checkpoint.
- Required dependent files.
- Tests to run.

The integrator records the owner and marks the file **LOCKED**. Other agents may inspect but must not edit that path until the owner releases it.

Suggested ownership priority:
- Bootstrap/player lifecycle: Multiplayer Agent or designated integrator, one owner only.
- Profile coordinator and persistence adapter: Persistence Agent.
- Mission and investigation services: Gameplay Agent.
- Ember controller and companion UI: Ember Agent.
- Shared remote router: Multiplayer Agent only after explicit interface agreement.
- Shared project configuration: integrator approval required.

A lock is a coordination convention, not a Git lock. Use separate worktrees and verify the file diff before integration.

## 5. Handoff contract

Every agent handoff must include:

1. **Status:** COMPLETED, BLOCKED or IN PROGRESS.
2. **Base:** branch and base commit SHA.
3. **Changed paths:** complete list, including untracked files.
4. **Behavior:** what changed and what did not change.
5. **Tests:** exact commands and actual outputs.
6. **Runtime:** Studio/device/multiplayer status.
7. **Risks:** known regressions, data risks and unresolved questions.
8. **Preservation:** backup/snapshot location and checksum if created.
9. **Git state:** commit/push status and any remaining dirty paths.
10. **Next owner:** explicit handoff target.

Do not say "all tests pass" without listing the tests actually run.

## 6. Integration checklist

Before integrating an agent's work:

- [ ] Base commit is known.
- [ ] Agent's complete changed-path list is known.
- [ ] No unrelated dirty work is included.
- [ ] No protected file was modified without permission.
- [ ] Interfaces match current service contracts.
- [ ] Canon and attribution rules are preserved.
- [ ] Unit and integration tests pass.
- [ ] Formatting/build checks pass where available.
- [ ] Runtime-only requirements are marked BLOCKED if Studio is unavailable.
- [ ] Combined regression tests pass after integration.
- [ ] Recovery snapshot is verified.
- [ ] Integrator records resulting commit and test evidence.

## 7. Conflict response

If two agents modify the same file:
1. Stop integration for that file.
2. Preserve both versions and their base commits.
3. Compare intended behavior and dependencies.
4. Ask the designated owner to propose a merged result.
5. Review the merged diff.
6. Run the affected tests and combined regression suite.
7. Record the resolution and provenance.

Never use reset, clean, force-push, or deletion as a conflict-resolution shortcut.

## 8. Release gates

A workstream is not complete merely because code exists.

- **Source complete:** implementation and offline tests are present.
- **Integration complete:** combined branch tests and build pass.
- **Studio verified:** Roblox runtime behavior is confirmed.
- **Multiplayer verified:** two-client isolation and concurrency are confirmed.
- **Mobile verified:** actual Android usability and performance are measured.
- **Persistence verified:** controlled save, failure, retry and reconnect tests pass.
- **Release approved:** canon, rollback, privacy and publishing gates are approved.

## 9. Current known boundaries

- Existing Ember command scope is Hold and Regroup; five other commands remain design targets.
- The persistence status correction has an offline test report, but Studio, live DataStore and reconnect verification remain outstanding.
- The live persistence gate remains disabled.
- The previously reported development host is Debian 12 ARM64 without Roblox Studio runtime.
- A GitHub documentation branch is not proof that the local active gameplay branch contains the same commits.
- This contract does not authorize agents to edit one another's active work.

## 10. Completion definition

Parallel development is successful only when independently owned workstreams integrate without lost work, cross-player state leakage, canon violations, false durability claims or unverified release claims.
