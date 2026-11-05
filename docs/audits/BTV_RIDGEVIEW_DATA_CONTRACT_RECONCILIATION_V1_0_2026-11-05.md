# Ridgeview Data Contract Reconciliation — Vertical Slice v1.0

**Date:** 5 November 2026  
**Status:** CONFIRMED source reconciliation / PROPOSED implementation contracts  
**Authority:** Recovered merged source `docs/source-of-truth/vertical-slice/BTV_Vertical_Slice_Specification_v1.0.md`  
**Scope:** Data-model preparation only. No mission content, dialogue, flags, or gameplay systems are implemented here.

## 1. Source constraints that implementation must preserve

- Scout confidence is immutable historical provenance: `Observed`, `Reported`, `Inferred`, `Unconfirmed`.
- On-site claim state is a separate working value: `Confirmed`, `Contradicted`, `Still open`.
- `Unverified` describes a player-drawn Evidence Board connection only; it is not a Scout confidence value.
- A Reported claim requires Asher's own observation or two independent sources before it can be confirmed. One frightened resident's statement alone remains Reported.
- Scout source identity remains the original Scout. A duty officer may receive/forward the report but cannot become its origin.
- A Scout report is incomplete and non-binding. It must not imply the Scout entered Ridgeview or knows whether anyone is in danger.
- Repairman fate remains `unresolved` throughout this slice. The trail can be found/followed, but no death, rescue, capture or final location is inferred.
- The five approaches remain Speak/Preach, Investigate, Rescue, Defend and Withdraw. They can combine; Withdraw remains a legitimate option.
- No response grants XP, currency, equipment, promotion, faith score or morality score.
- No player-facing string, subtitle, report, UI label or mission identifier may name or identify the reserved Devourer group.
- Pike's condition/classification remains uncertain. Do not force a villain classification or a single explanation.
- Wren's account is human testimony containing fear, useful information and gaps; she is not an exposition device.
- No children at Ridgeview; content notice precedes arrival; no graphic remains or descriptions.

## 2. Proposed data contracts

### 2.1 Scout report
```gdscript
{
  "report_id": String,
  "source": {"actor_id": String, "actor_role": "scout"},
  "area": {"region_id": "ridgeview", "precision": "approximate"},
  "claims": Array[ScoutClaim],
  "alternative_explanations": Array[String],
  "limitations": Array[String],
  "recommendation": String
}
```
A `ScoutClaim` carries `claim_id`, `claim_text`, `confidence`, `source_refs`, and `observed_at` where known. Confidence is restricted to the four immutable Scout labels. Missing timestamps or source detail remain explicit unknowns; never fabricate them.

### 2.2 Claim verification
```gdscript
{
  "claim_id": String,
  "original_confidence": "Observed|Reported|Inferred|Unconfirmed",
  "working_status": "confirmed|contradicted|open",
  "verification_refs": Array[String],
  "verification_basis": "direct_observation|physical_evidence|independent_sources|none"
}
```
The original confidence field is write-once. Working status can change as evidence is added. A status transition must preserve its verification references and basis.

### 2.3 Evidence record
```gdscript
{
  "evidence_id": String,
  "kind": "physical|testimony|record|environmental",
  "source_actor_id": String,
  "location_id": String,
  "captured_by": "asher",
  "content_ref": String,
  "is_dialogue_only": bool,
  "timestamp": String
}
```
Evidence is not equivalent to testimony. Dialogue/NLI answers do not automatically create evidence records. The source actor and capturing actor are separate fields.

### 2.4 Response and outcome
- Store approaches used as a set from the five approved values.
- Keep Wren outcome and Pike outcome as separate enums.
- Repairman status is fixed to `unresolved` for this slice.
- Follow-up assignment is a non-binding Covenant response to Asher's report; no promotion or reward.
- Do not add faith, prayer, holiness, conversion, morality or spiritual-worth fields.

## 3. Acceptance invariants

1. A Scout report cannot be rewritten as an on-site observation.
2. A duty officer cannot overwrite the Scout source.
3. An Inferred claim cannot be marked Confirmed solely because it is plausible.
4. A single testimony source cannot satisfy the two-independent-sources rule for Reported claims.
5. Evidence references must resolve; dangling references are rejected or left explicitly unresolved, never silently treated as evidence.
6. Player-drawn connections use `unverified` until evidence supports them.
7. Repairman status serializes only as `unresolved` in the slice.
8. All five approaches are reachable without requiring optional evidence or a particular faith response.
9. Withdraw can be selected at any point and produces a reportable outcome, not a failure state.
10. No response path creates XP, currency, equipment, promotion or moral/faith scores.
11. Pike and Wren remain evidence-led, speaker-scoped knowledge sources.
12. String scanning covers dialogue, UI, reports, resources and test fixtures for prohibited reserved-group naming.

## 4. Open decisions and implementation blockers

- Exact report and evidence IDs, timestamps, location IDs, and evidence wording must come from authored v1.0-compliant mission data; none are invented here.
- The final Psalm 23 translation remains undecided. Do not add quotation text or language-specific triggers.
- The repairman's name is UNKNOWN.
- Scout, duty officer and visitor names are UNKNOWN.
- Full save/load schema is reserved; the slice data model must not imply a final persistence architecture.
- No mission content implementation begins until these contracts are reviewed against the Master Canon and the relevant specialized Bibles.

## 5. Source map

- v1.0 §§7, 9, 12: Scout report, investigation, confidence and verification.
- v1.0 §§13–18: Pike, Wren, repairman, response options, flags, final report and content boundaries.
- v1.0 §§19–22: slice-scoped stubs, build order and reserved systems.

**Conclusion:** The data model can be prepared independently, but the content authoring gate remains closed until each fact, speaker and evidence item has an approved source.