<!-- Historical Library source copy. Preserve source status; reconcile against current canon before use. -->

# BEYOND THE VEIL: THE LAST WATCH
## Ridgeview Investigation — Data Contracts & State Model v0.1

**Date:** 1 November 2026  
**Status:** PROPOSED technical specification; not implemented  
**Target:** Godot 4.7.2 stable / typed GDScript, Android-first  
**Dependencies:** Vertical Slice Specification v1.0; Investigation & Evidence Bible v0.1; Ridgeview Case Design v0.2; Ridgeview Dialogue & Content Pack v0.1  
**Authority:** Creator decisions and approved canon override this specification. It defines implementation contracts only and does not promote story proposals to canon.

---

## 0. Executive recommendation

Implement Ridgeview as a deterministic, data-driven case. Keep authored evidence, claims, dialogue conditions and mission outcomes in Resources or equivalent data files. The game owns all authoritative state. Any future NLI layer may request a supported action, but the game validates and executes it.

**Do not begin with a generative NPC architecture.** The first playable slice should work fully offline with authored dialogue, deterministic interactions, a Journal and an Evidence Board. This is the smallest reliable path and the safest foundation for later AI-assisted interaction.

## 1. Architectural boundaries

### 1.1 Ownership

| System | Owns | Must not own |
|---|---|---|
| CaseDefinition | Static authored case content and IDs | Player progress |
| CaseState | Runtime progress and collected evidence IDs | Narrative truth not yet discovered |
| EvidenceRepository | Valid evidence records and source metadata | Player hypotheses |
| ClaimEvaluator | Deterministic claim status from evidence rules | Moral judgement or supernatural certainty |
| KnowledgeService | What an NPC is authorised to know | Global omniscience |
| DialogueRunner | Authored dialogue nodes and conditions | Arbitrary world-state mutation |
| MissionDecisionService | Validates response choices and preconditions | Hidden morality score |
| WorldState stub | Existing `ridgeview.*` outcome flags | Full regional simulation |
| Journal / Evidence Board | Player-facing presentation of known facts and hypotheses | Authoritative case truth |
| Optional NLI adapter | Parse player request into typed intent | Direct state writes, invented clues or canon |

### 1.2 Dependency direction

`UI / Interaction → Mission Services → CaseState / WorldState → Data Resources`

- UI never edits Resources directly.
- Dialogue does not write arbitrary flags; it emits a typed, authored event for a service to validate.
- The Board requests relation checks from the case service; it does not decide the truth itself.
- The Journal renders only records authorised for Asher's knowledge state.
- Ember's perception is a local input, not a global evidence query.

## 2. Shared enums

Conceptual names below are proposed code symbols. The exact names may change during implementation, but semantics must remain stable.

```gdscript
enum ReportLabel {
    OBSERVED,
    REPORTED,
    INFERRED,
    UNCONFIRMED
}

enum ClaimStatus {
    CONFIRMED,
    CONTRADICTED,
    STILL_OPEN
}

enum EvidenceKind {
    PHYSICAL,
    ENVIRONMENTAL,
    RECORDED,
    TESTIMONIAL,
    BEHAVIOURAL,
    ARCHIVAL,
    ANOMALOUS,
    CONTRADICTORY
}

enum KnowledgeKind {
    DIRECT_OBSERVATION,
    REPORTED_TESTIMONY,
    INFERENCE,
    BELIEF,
    SPECULATION,
    UNKNOWN,
    DELIBERATE_DECEPTION
}

enum Approach {
    SPEAK_PREACH,
    INVESTIGATE,
    RESCUE,
    DEFEND,
    WITHDRAW
}
```

Do not use the same enum for the Scout's historical report label and the player's current claim status. The report is immutable; local verification is a second layer.

## 3. Static data contracts

### 3.1 EvidenceRecord

| Field | Type | Required | Rule |
|---|---|---:|---|
| `id` | StringName | Yes | Stable ID, e.g. `RV-E03` |
| `kind` | EvidenceKind | Yes | One primary kind; secondary tags may be a small array |
| `title` | String | Yes | Short, localised display title |
| `description` | String | Yes | Exact observation, not interpretation |
| `source_id` | StringName | Yes | Source or witness ID |
| `location_id` | StringName | Yes | Authored zone/location ID |
| `time_context` | String | Yes | Relative or authored time context |
| `acquisition_condition` | StringName | Yes | Deterministic condition ID |
| `supports_claim_ids` | Array[StringName] | No | Claims this item can support |
| `challenges_claim_ids` | Array[StringName] | No | Claims this item can contradict |
| `knowledge_permissions` | Array[StringName] | Yes | Who may access the record |
| `accessibility_text` | String | Yes | Text equivalent for audio/visual cues |
| `is_optional` | bool | Yes | Optional evidence cannot hard-gate the case |

**Integrity:** Evidence text describes what is available to Asher. Writer-only truth belongs in a separate private case file and must never be loaded into player-facing UI.

### 3.2 ClaimRecord

| Field | Type | Required | Rule |
|---|---|---:|---|
| `id` | StringName | Yes | Stable claim ID |
| `statement` | String | Yes | One falsifiable or assessable proposition |
| `initial_report_label` | ReportLabel | Yes | Immutable Scout label, if report-derived |
| `supporting_evidence_ids` | Array[StringName] | No | Authored eligible evidence IDs |
| `contradicting_evidence_ids` | Array[StringName] | No | Authored eligible evidence IDs |
| `minimum_support_rule` | StringName | Yes | Deterministic rule ID |
| `scope_limit` | String | Yes | Time, place, actor or context boundary |
| `journal_visibility` | enum/string | Yes | When Asher is allowed to see it |

Claim evaluation must not rely on an LLM judgement. It uses authored evidence eligibility and corroboration rules.

### 3.3 KnowledgeRecord

| Field | Type | Required | Rule |
|---|---|---:|---|
| `character_id` | StringName | Yes | NPC/character ID |
| `fact_id` | StringName | Yes | Atomic fact or testimony reference |
| `knowledge_kind` | KnowledgeKind | Yes | Distinguishes observation from belief/inference |
| `source_id` | StringName | Yes | How the character knows |
| `learned_at` | StringName | Yes | Story sequence marker |
| `disclosure_condition` | StringName | Yes | When the character may share it |
| `reliability_note` | String | No | Writer-side guidance; never a numeric truth score |
| `privacy_rule` | StringName | No | E.g. Wren's permission before sharing her private account |

### 3.4 DialogueNode

| Field | Type | Required | Rule |
|---|---|---:|---|
| `id` | StringName | Yes | Stable node ID |
| `speaker_id` | StringName | Yes | Authored speaker |
| `line_key` | StringName | Yes | Localisation key |
| `condition_ids` | Array[StringName] | No | All conditions must be checked by game services |
| `choice_ids` | Array[StringName] | No | Authored choices |
| `knowledge_requirements` | Array[StringName] | No | Evidence or facts required for this line |
| `emitted_event_id` | StringName | No | Typed event; never arbitrary script |
| `next_node_map` | Dictionary | No | Deterministic branch mapping |

### 3.5 CaseDefinition

Static case package containing:
- `case_id = ridgeview`
- report reference;
- evidence record IDs;
- claim record IDs;
- dialogue graph IDs;
- location and zone IDs;
- authored decision definitions;
- final report templates;
- content/accessibility metadata;
- version and source-of-truth references.

### 3.6 CaseState

Runtime saveable state containing only:
- case version;
- current mission phase;
- collected evidence IDs;
- reviewed evidence IDs;
- claim statuses;
- player-created hypothesis/link IDs;
- dialogue nodes already used where one-time;
- NPC disclosure state;
- approaches actually used;
- current decision and outcome flags;
- report draft selections;
- unresolved question IDs.

Do not store hidden writer truth, raw model speculation, transient UI state or a morality/faith score.

## 4. Evidence and claim evaluation

### 4.1 Deterministic rules

1. A direct observation can confirm only the proposition it directly establishes.
2. A photograph can support only what is visible and attributable in that photograph.
3. A witness statement remains testimony even if sincerely delivered.
4. Two sources are independent only if they do not derive the claim from the same original source.
5. Repetition of a rumour does not create independent corroboration.
6. A contradiction changes a claim only when both records refer to compatible time, place and proposition scopes.
7. Missing evidence is not evidence of absence unless the case explicitly establishes a reliable search scope.
8. A claim may remain open after mission completion.
9. Player hypotheses are never promoted automatically because an NPC agrees.
10. A final report cannot exceed the strongest supported label.

### 4.2 Example: disproving the trader's statement

- Claim: “The outpost has been shut for weeks.”
- Initial label: Reported / Unconfirmed.
- Evidence: Asher directly observes residents present in the settlement.
- Result: Contradicted.
- Scope: This disproves the claim that the settlement is shut; it does not prove every service is operating normally.

### 4.3 Example: repairman trail

- Claim: “The repairman went toward the camp.”
- Evidence: Wren's bounded testimony plus the physical trail/work record, if both are found.
- Result: Confirmed only for the direction/last known trail within the authored scope.
- Prohibited inference: “The repairman is dead,” “the repairman is being held,” or “the repairman has been rescued.”
- `repairman_status` remains `unresolved` throughout the slice.

## 5. Existing mission state machine

The Vertical Slice Specification already defines the mission progression and flags. Use these as the authoritative slice-level contract; do not replace them with a new parallel state model.

```text
NotStarted
  → ReportRead
  → Investigating
  → EvidenceCollected (zero or more)
  → DecisionMade
  → Resolved
```

**Important:** `EvidenceCollected` is a descriptive state, not a requirement that every clue be found. A player may move to DecisionMade with partial evidence. Withdraw may transition from any active investigation state to a resolved withdrawal outcome.

### 5.1 Transition guards

- `ReportRead`: Covenant alert delivered after service; report opened by Asher.
- `Investigating`: Asher reaches the Ridgeview approach or settlement.
- `EvidenceCollected`: at least one evidence record acquired; optional state for UI, not a gate.
- `DecisionMade`: player selects a valid response or combination.
- `Resolved`: outcome and report state saved; repairman status still unresolved.

### 5.2 Existing world-state keys

Reuse only the currently specified `ridgeview.*` keys unless a separate schema review approves a change:

- `approaches_used`
- `wren_outcome`
- `pike_outcome`
- `repairman_trail`
- `repairman_status`
- `claims_resolved`
- `evidence_documented`
- `visitor_connection`
- `combat_occurred`
- `covenant_followup`
- `veil_state_at_exit`

The existing `pike_outcome` enum has no dedicated cooperation value. Record any bounded admission in sourced evidence/report content; do not silently add a new enum member. The value `removed_from_settlement` is semantically ambiguous: before implementation, define whether it means voluntary departure, civilian evacuation, or another authorised event. Do not implement it as arrest, detention or forced removal; the Covenant's legal authority is not established.

## 6. Typed mission events

Proposed event names; events are requests or notifications, not direct writes.

- `evidence_discovered(evidence_id)`
- `evidence_reviewed(evidence_id)`
- `claim_status_changed(claim_id, new_status)`
- `dialogue_node_completed(node_id)`
- `npc_disclosure_authorized(character_id, fact_id)`
- `approach_selected(approach_id)`
- `rescue_route_validated(route_id)`
- `mission_withdrawn(reason_id)`
- `final_report_submitted(report_id)`

Each event handler validates the current case state and authored preconditions. Duplicate events should be idempotent: discovering the same evidence twice does not create duplicate records or duplicate consequences.

## 7. Final report validation

The report builder should offer claim records grouped by:
- Observed by Asher;
- Reported to Asher;
- Inferred by Asher;
- Unconfirmed / unresolved.

Validation rules:
- Asher cannot mark a claim Observed unless he personally observed it.
- A Scout observation remains a Scout observation; Asher may state that the report said it, but cannot claim he personally saw it.
- A witness statement includes speaker and context.
- A contradiction must identify the claim and the evidence that contradicts it.
- The repairman's fate remains unresolved.
- A withdrawn mission may submit a partial report.
- No outcome text claims a person was rescued unless the saved outcome confirms departure to safety.

## 8. Save/load and versioning

- Save stable IDs and state, not full copies of static Resources.
- Include a case schema version and migration path for future changes.
- Validate all saved IDs against the loaded CaseDefinition.
- Unknown or retired evidence IDs must be handled safely; do not crash or silently invent replacements.
- Save after major evidence acquisition, decision transitions and report submission.
- Test reload from every major phase, including partial investigation and withdrawal.
- Do not persist generated NLI prose as authoritative evidence.

## 9. Android-first performance and UX

- Load only the active case data; do not simulate a global graph for Ridgeview.
- Use compact stable IDs and localised text keys.
- Avoid expensive runtime NLP for deterministic dialogue.
- Board relations should be authored and small; no graph-wide recomputation each frame.
- UI should work on a narrow phone display with readable cards, large touch targets and clear back navigation.
- Provide text equivalents for sound cues and visual alternatives for audio-only clues.
- Keep all core interactions functional offline.
- Profile on the actual target device before setting numerical memory/latency budgets.

## 10. Test contracts

| Test | Input/state | Expected invariant |
|---|---|---|
| DC-01 | Duplicate `evidence_discovered` event | One evidence ID, no duplicate side effect |
| DC-02 | Reported claim repeated by two people from one rumour | No independent corroboration |
| DC-03 | Direct observation disproves trader's claim | Claim becomes Contradicted, not all settlement claims |
| DC-04 | Wren reports seeing repairman go toward camp | Only direction/last known trail may be supported |
| DC-05 | Player misses toolkit | Visitor link remains Unverified or not made |
| DC-06 | Player withdraws before camp | Mission resolves as withdrawal; camp facts remain unknown |
| DC-07 | Player asks Pike about evidence he has not seen | Pike does not know the evidence unless shown/told |
| DC-08 | Player saves after Wren agrees to leave but before departure | Reload does not mark her rescued |
| DC-09 | Player reloads after report submission | Submitted report and unresolved questions persist |
| DC-10 | NLI returns an unsupported fact | Validation rejects it; no state mutation |
| DC-11 | Model/network unavailable | Mission remains fully playable |
| DC-12 | `repairman_status` is evaluated in every outcome | Remains `unresolved` |
| DC-13 | Dialogue uses a new unapproved flag | Build/content validation fails |
| DC-14 | Final report attempts an Observed label for a Scout-only claim | Validation rejects the over-claim |
| DC-15 | Pike outcome requests `removed_from_settlement` before its meaning is approved | Transition is blocked; no arrest/detention interpretation is inferred |

## 11. Implementation order

1. Verify the Godot 4.7.2 project and Android export templates before creating the project.
2. Create the smallest project skeleton and a build/run baseline on the actual phone.
3. Implement stable IDs, data Resources and validation utilities.
4. Implement CaseState and existing world-state stub.
5. Implement evidence acquisition and Journal rendering.
6. Implement claim evaluation and Evidence Board links.
7. Implement authored dialogue and knowledge permissions.
8. Implement five approach selection and outcome validation.
9. Implement final report builder and save/load migration tests.
10. Add optional NLI only after deterministic paths pass.

**Do not start implementation in a guessed folder or repository.** The known GitHub repository was previously audited as effectively empty, and the local Android project location has not been verified. First re-inspect the current environment and target repository before any write.

## 12. Status ledger

- **CONFIRMED:** Godot/GDScript direction in the reconciled project plan; Android-first; deterministic slice state and existing `ridgeview.*` flags; evidence labels; bounded NPC knowledge; NLI cannot mutate state directly.
- **PROPOSED:** Data contracts, event names, validation rules, state transition guards, save schema and test contracts.
- **UNKNOWN:** Actual project folder, current Android device baseline, final test framework, exact renderer and numerical performance budgets.
- **BLOCKED:** Implementation until a real project directory/repository and Android export setup are verified.
- **COMPLETED:** Drafted Ridgeview Data Contracts & State Model v0.1. No code has been added to the game and no tests have been run.

**End of BTV Ridgeview Investigation — Data Contracts & State Model v0.1**
