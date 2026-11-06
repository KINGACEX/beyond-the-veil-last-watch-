# MISSION DATA VALIDATION CONTRACT 001

**Status:** PROPOSED IMPLEMENTATION CONTRACT — NOT CANON, NOT IMPLEMENTED  
**Date:** 6 November 2026  
**Scope:** Static validation and runtime-boundary checks for authored mission, objective, dialogue, evidence and outcome data.  
**Authority:** Vertical Slice Specification v1.0; Ridgeview Data Contract Reconciliation v1.0; Mission Scripting and Dialogue Pipeline Research (6 November 2026).

## 1. Purpose and non-goals

Define checks that reject malformed or internally inconsistent authored mission data before it reaches gameplay. This is a validation boundary proposal, not approval of a final Resource schema, Ridgeview dialogue, open story facts, a dialogue editor or the full mission/save architecture.

## 2. Authority and separation invariants

1. Authored definitions are immutable during a play session. Runtime progress is stored separately.
2. Dialogue presentation cannot create evidence, complete objectives, resolve claims or write world-state flags by itself.
3. Only the authoritative evidence-acquisition service may create a collected-evidence record.
4. Only the mission-state service may apply an objective/mission transition after checking prerequisites and event source.
5. UI text reports authoritative state; displaying or selecting an option does not declare success.
6. NLI knowledge is speaker-scoped and provenance-backed. An NPC statement does not become an observed fact or evidence record.
7. Unknown, reserved and unresolved facts remain unknown. Validation must not invent defaults that resolve story uncertainty.
8. No mission field may encode faith, holiness, prayer quality, conversion, spiritual worth or morality score.

## 3. Stable identity and reference rules

Every mission, objective, dialogue node, choice, evidence definition, claim, outcome and authored condition needs a non-empty stable ID.

Reject:
- missing or whitespace-only IDs;
- duplicate IDs within the declared namespace;
- collisions after the project's declared normalization rule;
- missing or ambiguous references.

Do not silently rename duplicates. Diagnostics identify source file, owning record, field and conflicting IDs. **Open choice:** global versus typed-namespace uniqueness; the first neutral fixture should use explicit typed namespaces without assuming a final naming convention.

## 4. Mission and objective graph checks

For each mission:
- A valid entry point and at least one reachable terminal/report state exist.
- Every prerequisite resolves to an objective or approved condition.
- Dependency cycles are rejected unless a future bounded-loop contract is approved.
- Every required objective has a reachable completion path.
- Mutually exclusive outcomes cannot both be satisfied.
- Optional objectives/evidence cannot become hidden prerequisites for mandatory progression.
- Failed, unavailable or interrupted actions are not recorded as completed.
- Branch convergence preserves the selected approach and actual completed objectives.

The validator reports graph defects; it does not rewrite the graph.

## 5. Dialogue graph checks

For each dialogue graph:
- Entry and choice-target nodes resolve.
- Conditions reference declared mission, objective, claim, evidence or actor-state IDs.
- Non-terminal nodes have a valid continuation or explicit end.
- Reachability is checked from the entry node; cycles require an explicit bounded-loop policy.
- Choices with unmet prerequisites are not displayed.
- Displaying a choice does not imply its action succeeded.
- Dialogue cannot create evidence or directly mutate mission state.
- Speaker identity, knowledge scope and source provenance resolve to approved records.
- Wording preserves uncertainty and does not claim unseen events occurred.

Semantic support between a statement and its source remains an editorial review gate. A source ID alone does not prove accurate wording.

## 6. Evidence and claim validation

Authored evidence definitions and runtime collected-evidence records are separate.

- Runtime collection records identify the event and actor that actually acquired evidence.
- Dialogue-only records cannot be promoted into physical evidence.
- Evidence references must resolve before a claim uses them for verification.
- Original confidence/provenance is immutable; current working status is separate and carries verification references and basis.
- An Inferred claim cannot be confirmed merely because it is plausible.
- A Reported claim must satisfy the approved verification rule; one testimony source alone is insufficient where the slice requires independent corroboration.
- Unverified is reserved for player-drawn Evidence Board connections, not Scout confidence.
- Conflicting evidence remains ambiguous unless an authored verification rule resolves it.

## 7. Ridgeview validation profile

The Ridgeview profile must enforce:

| Rule | Validation |
|---|---|
| Five approaches | Speak/Preach, Investigate, Rescue, Defend and Withdraw are represented and reachable |
| Withdraw | Remains a legitimate option, not a failure terminal |
| Optional evidence | Missing optional evidence cannot softlock required report paths |
| Repairman | Status remains unresolved throughout the slice |
| Pike | No forced villain classification or single definitive explanation |
| Wren | Testimony retains speaker provenance and uncertainty |
| Scout report | Original Scout remains source; forwarding cannot rewrite authorship |
| Confidence | Only Observed, Reported, Inferred and Unconfirmed are valid Scout labels |
| Working claim status | Confirmed, Contradicted and Still open remain separate from original confidence |
| Player connections | Unverified applies only to Evidence Board connections |
| Outcomes | No XP, currency, equipment, promotion, faith or morality rewards |
| Reserved threat | Prohibited group naming/identification absent from player-facing text and internal mission identifiers |
| Content boundary | No children at Ridgeview; content notice before arrival; no graphic remains/descriptions |

These are slice-specific constraints, not a universal mission framework.

## 8. World-state flag validation

For Ridgeview, validate the approved ridgeview namespace and value domains from Vertical Slice v1.0. Reject undeclared keys, invalid enum/type values and writes from dialogue presentation or NLI. Preserve repairman status as unresolved. Store approaches as a set, not a score. Do not create faith, prayer, holiness, conversion, morality or spiritual-worth flags. Covenant follow-up is an authored response to Asher's report, not a reward.

Stub persistence and the full save schema remain separate reserved decisions.

## 9. Shared Resource and runtime-state isolation

Godot Resources may be cached and shared. Treat authored definitions as immutable after load; store runtime state in separate objects/services. A player choice or mission run must not mutate its source Resource. Two instances of the same mission definition must not leak runtime state into each other. Reset/restart must not alter authored content.

Required isolation test: instantiate two runtime states from one authored definition, mutate one, and assert the other and the authored definition remain unchanged.

## 10. Validation pipeline and diagnostics

**Proposed order:** load/parse; validate required fields and types; check ID uniqueness; resolve references; validate mission/objective graph; validate dialogue graph and conditions; validate evidence/claim provenance; validate speaker/source scope; apply mission-specific rules; scan player-facing strings; emit deterministic report.

Each diagnostic includes stable code, severity (error/warning/review), file/resource path, record ID and field path, explanation, and referenced target/source where relevant. Errors block the affected mission. Warnings and editorial-review items remain visible and are never silently approved.

## 11. Proposed validation matrix

| ID | Defect | Expected result |
|---|---|---|
| MDV-001 | Missing/blank stable ID | Error; mission blocked |
| MDV-002 | Duplicate ID in namespace | Error; no auto-renaming |
| MDV-003 | Missing objective prerequisite | Error |
| MDV-004 | Objective dependency cycle | Error |
| MDV-005 | Unreachable required objective | Error |
| MDV-006 | No reachable terminal/report state | Error |
| MDV-007 | Choice points to missing node | Error |
| MDV-008 | Unreachable dialogue node | Warning/error per authored-node policy |
| MDV-009 | Condition references missing ID | Error |
| MDV-010 | Optional evidence gates required progress | Error |
| MDV-011 | Dialogue attempts evidence creation | Error |
| MDV-012 | Dialogue claims success without authoritative event | Error/review |
| MDV-013 | Speaker source outside approved scope | Error |
| MDV-014 | Source is pending, stale or withdrawn | Error |
| MDV-015 | Claim verification reference is dangling | Error |
| MDV-016 | Original confidence overwritten by working status | Error |
| MDV-017 | One testimony confirms a Reported claim where two sources are required | Error |
| MDV-018 | Repairman status differs from unresolved | Error for Ridgeview |
| MDV-019 | Withdraw absent or treated as failure | Error for Ridgeview |
| MDV-020 | Faith/morality/spiritual-worth score or reward field | Error |
| MDV-021 | Reserved threat term appears in player-facing content | Error |
| MDV-022 | Runtime state mutates shared authored Resource | Error |
| MDV-023 | Two runtime instances share mutable progress | Error |
| MDV-024 | Invalid Ridgeview flag key or enum value | Error |

## 12. Test-first implementation sequence

1. Build a neutral fixture with no BTV character names, story facts or reserved terms.
2. Write validator tests for IDs and dangling references.
3. Add graph reachability and cycle tests.
4. Add dialogue-condition and terminal-node tests.
5. Add evidence/dialogue separation tests.
6. Add Resource immutability and two-instance isolation tests.
7. Add a separate Ridgeview profile fixture only after the neutral validator contract passes.
8. Add the prohibited-string scan to content validation.
9. Integrate with Godot CI; keep editor/manual and Android QA distinct.

No external test framework is selected. Use the existing headless harness first unless it proves inadequate.

## 13. Status and blockers

- **CONFIRMED:** Vertical Slice v1.0 and Ridgeview reconciliation define the constraints above.
- **CONFIRMED:** Mission/dialogue research recommends separating authored definitions, runtime state, presentation and validation.
- **PROPOSED:** This validation contract and diagnostic model.
- **UNKNOWN:** Final Resource schema, ID namespace policy, condition grammar, dialogue loop policy and validator API.
- **NOT IMPLEMENTED:** No mission data validator, dialogue graph validator, mission-state service or Ridgeview content data is added here.
- **BLOCKED:** Mission authoring remains gated on approved content sources and unresolved character/fact details.

## 14. Source references

- docs/source-of-truth/vertical-slice/BTV_Vertical_Slice_Specification_v1.0.md
- docs/audits/BTV_RIDGEVIEW_DATA_CONTRACT_RECONCILIATION_V1_0_2026-11-05.md
- docs/research/BTV_MISSION_SCRIPTING_AND_DIALOGUE_PIPELINE_RESEARCH_2026-11-06.md
