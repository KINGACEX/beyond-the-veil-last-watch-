# Mission and Progression Contract

**Version:** 1.0  
**Status:** Approved design contract; schema and implementation alignment required

## 1. Mission state model

Recommended mission states:

`Locked → Available → Active → ObjectivesComplete → ReadyForReview → Completed`

An Active mission may also be suspended and resumed, or enter a separately defined Failed/Retry state where appropriate.

State transitions must be server-authoritative and validated against prerequisites. A client must not set its own mission phase.

## 2. Objective model

Recommended objective classes:
- Mandatory
- Optional
- Investigation
- Dialogue
- Companion
- Exploration

Recommended objective states:
- Hidden
- Available
- Active
- Completed
- Failed

Optional objectives must not silently block mandatory progression unless the mission explicitly defines that dependency.

## 3. Evidence and Field Notes

Illustrative conceptual record:

```text
FieldNote
  id
  missionId
  sourceId
  category
  discovered
  attribution
  sharePermission
```

This is an example of the information a record may need. It is not a replacement for the current repository schema and must not be copied into production without inspecting existing types and migration constraints.

Evidence categories:
- Observation
- Testimony
- Physical record
- Interpretation
- Unverified

Keep stable identifiers and preserve the original source attribution. An interpretation is not a new observation.

## 4. Consent and attribution

- Wren's testimony is private by default.
- Sharing requires an explicit action.
- Pike's account remains separately attributed to Pike.
- Pike's account does not become objective truth merely because it is presented after a share decision.
- Consent-sensitive state must be authoritative and concurrency-safe.
- If consent becomes persistent, the persistence schema and recovery behavior require a separately reviewed migration plan.

## 5. Report draft

A report draft may contain:
- observations,
- attributed testimony,
- physical records,
- interpretations,
- unresolved questions,
- sharing/consent context.

A draft must not imply submission, recipient receipt, verdict or reward. Those features require a separately specified workflow and explicit acceptance tests.

## 6. Progression invariants

- Mission prerequisites are checked on the server.
- Repeated objective completion is idempotent.
- Duplicate requests cannot duplicate rewards or evidence.
- Player progression is isolated.
- Invalid mutations are rejected without partially mutating state.
- Session acceptance and durable persistence are separate outcomes.
- Pending save state is visible to diagnostics and never represented as durable success.
- Reconnect recovery is not considered verified until tested in Studio with an appropriate test persistence environment.

## 7. Acceptance checklist

- [ ] Locked missions cannot be activated by client request alone.
- [ ] Available mission requires all prerequisites.
- [ ] Mandatory objectives control progression as defined.
- [ ] Optional objectives do not create accidental soft locks.
- [ ] Objective completion is idempotent.
- [ ] Evidence IDs and attribution remain stable.
- [ ] Wren's testimony remains private until explicit share.
- [ ] Pike's account remains separately attributed.
- [ ] Unverified claims remain unverified.
- [ ] Report draft preserves uncertainty.
- [ ] Duplicate requests do not duplicate progression or rewards.
- [ ] Two players' mission state remains isolated.
- [ ] Pending persistence is never presented as Saved.
- [ ] Reconnect and failure recovery are tested before durable progression is claimed.

## 8. Compatibility rule

Before implementation, inspect current module contracts and existing profile schemas. Do not replace existing structures or add a migration solely to match this conceptual contract. Any schema change requires backup, compatibility analysis, migration design, tests and explicit approval.
