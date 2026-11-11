<!-- Historical Library source copy. Preserve source status; reconcile against current canon before use. -->

# BEYOND THE VEIL: THE LAST WATCH
## Ridgeview Case v0.2 — Canon & Content Audit v0.1

**Date:** 1 November 2026  
**Status:** COMPLETED — documentation audit only  
**Scope:** Ridgeview Case Design v0.2, Dialogue & Content Pack v0.1, Data Contracts v0.1  
**No implementation, repository writes, or gameplay tests were performed.**

---

## 1. Audit result

<badge>PASS WITH ONE BLOCKER</badge>

The Ridgeview case direction is compatible with the reviewed higher-authority sources when the locked Vertical Slice Specification remains controlling and the Devourers/Concordance identities are not exposed or conflated.

One implementation blocker was identified: the existing `pike_outcome` value `removed_from_settlement` has no sufficiently precise meaning. The Vertical Slice Specification explicitly says the Covenant's legal authority is unknown and avoids arrest/detention flags. This value must not be implemented as arrest, detention or forced removal. Its semantics need a defined, authorised event before the branch is built.

## 2. Source checks

| Source | Audit finding | Result |
|---|---|---|
| Vertical Slice Specification v1.0 | Preserves Ridgeview layout, Pike/Wren roles, five approaches, Psalm 23 threshold, report limits and unresolved repairman | PASS |
| Canon Reconciliation & Story/Veil Decisions v1.1 | Human antagonist is Marek Sloane / Concordance; no Ridgeview connection is established; Veil operational laws bound | PASS — separation preserved |
| Veil & Enemy Encyclopedia v1.0 | Enemy origins/hierarchy remain open; encounters may include investigation, dialogue, rescue, de-escalation and withdrawal; no graphic horror requirement | PASS |
| Investigation & Evidence Bible v0.1 | Evidence provenance, bounded knowledge, fail-forward and no AI invention rules align | PASS |
| Ridgeview Case Design v0.2 | Pike's complicity, Wren's partial knowledge, repairman trail and local payoff remain within slice boundaries | PASS WITH BLOCKER |
| Dialogue & Content Pack v0.1 | Player-facing lines do not name the Devourers or assert repairman fate; evidence-gated admissions are used | PASS |
| Data Contracts v0.1 | Deterministic state and evidence ownership; flags reused; `removed_from_settlement` now blocked pending semantics | PASS WITH BLOCKER |

## 3. Confirmed compatibility

### 3.1 Story and character

- Pike remains a complex local leader, not a one-dimensional villain.
- His fear may explain decisions but does not excuse concealment or harm.
- Wren remains a frightened resident who wants out, with bounded knowledge and personal agency.
- The repairman remains missing and not confirmed dead in every slice outcome.
- The trader's inaccurate claim is disproved by direct observation, not by an invented supernatural reveal.

### 3.2 Veil and enemy boundaries

- Ridgeview stays within Disturbed on the approach and Influenced around the settlement/camp.
- No Veil-Touched, Breach or Critical escalation is introduced.
- The Veil's ultimate origin and full metaphysics remain unknown.
- No new supernatural entity, portal, ritual, power or universal detector is added.
- The Devourers are not named or identified in player-facing slice content.
- The Concordance is not assumed to be behind Ridgeview. Any future connection requires its own evidence chain and creator approval.

### 3.3 Faith and theological boundaries

- Psalm 23 remains an authored, one-time scene and has no gameplay buff or guaranteed outcome.
- Prayer, Scripture and the Holy Spirit do not act as clue detectors, passwords or certainty engines.
- Preaching is truthful witness, not coercion or a conversion mechanic.
- No faith, salvation, divine favour, spiritual worth or morality score is stored.

### 3.4 Investigation and technical boundaries

- Scout report labels remain immutable historical provenance.
- Local claim status is a separate layer.
- NPC knowledge has a traceable source and disclosure condition.
- The Evidence Board does not solve the case automatically.
- NLI cannot create evidence, change canon or mutate state directly.
- All core investigation paths remain playable without a model or network.

## 4. Blocker: Pike outcome semantics

**Existing enum value:** `removed_from_settlement`

**Problem:** It may be interpreted as voluntary departure, evacuation, community action, or coercive/legal removal. The current source does not resolve the meaning, and Covenant legal authority is explicitly unknown.

**Safe handling until resolved:**
- Do not use the value to represent arrest, detention or punishment.
- Do not implement a forced removal branch.
- Do not silently rename or extend the enum.
- Keep Pike as `confronted_left_in_place`, `fled` or `unresolved` where those values accurately describe the executed outcome.
- If the mission later requires a relocation/evacuation state, define the responsible actor, consent, safety reason and downstream consequences before adding a new value.

**Status:** BLOCKED for this enum branch only. Other Pike dialogue and investigation paths may proceed.

## 5. Dialogue and content QA findings

- Pike's first contact is plausible and avoids immediate exposition.
- Pike's admission is gated by evidence and remains bounded.
- Wren's account distinguishes what she saw from what she fears or heard.
- The repairman trail supports only a last-known direction, not a fate.
- The visitor/repairman link requires an actual identifying match; otherwise it stays Unverified or absent.
- Board prompts are neutral and do not reveal hidden enemy identities.
- Covenant replies match the report and do not claim off-screen success.
- The player-facing string scan remains a required pre-implementation QA step; it has not yet been executed against a game build.

## 6. Required next work

1. Define the meaning of `removed_from_settlement` or exclude that branch from the first implementation.
2. Finalise the evidence IDs and actual source records.
3. Convert dialogue pack lines into localised dialogue resources.
4. Map all dialogue branches to existing flags without adding hidden scores.
5. Create automated checks for the no-Devourers-name rule and repairman unresolved invariant.
6. Build only after Gate 0 of the Development Gates & Backlog is satisfied.

## 7. Status ledger

- **CONFIRMED:** Ridgeview's locked slice boundaries and compatibility with reviewed story, Veil, enemy, investigation and theology sources.
- **APPROVED DESIGN:** Coercive-isolation case direction and associated Pike/Wren/repairman treatment for slice-level design only.
- **PROPOSED:** Exact dialogue, evidence wording, and final report text.
- **UNKNOWN:** Repairman's fate; Devourer origin/hierarchy; Veil ultimate metaphysics; Ridgeview–Concordance relationship.
- **BLOCKED:** Implementing `pike_outcome=removed_from_settlement` until its meaning is explicitly resolved; all project implementation remains blocked by Gate 0.
- **COMPLETED:** Source-by-source documentation audit. No gameplay or code test has been run.

**End of BTV Ridgeview Canon & Content Audit v0.1**
