# NLI 002 — Ridgeview NPC Knowledge Contract

**Status:** PROPOSED DATA CONTRACT — NO RIDGEVIEW STORY FACTS AUTHORED  
**Branch:** `btv/bootstrap-prototype-001`  
**Scope:** Data shape and validation rules only. This document does not establish mystery truth, clue wording, witness testimony, or mission outcomes.

## Purpose

Define the minimum structure required before Ridgeview NPC knowledge can be added to the NLI knowledge base. The contract prevents an NPC from answering from another character's knowledge, treating dialogue as evidence, or presenting interpretation as confirmed fact.

## Canon anchors currently permitted

| Character / record | Established anchor | Boundary |
|---|---|---|
| Dorian Pike | Motive and accountability are relevant character dimensions | Specific motive, actions, testimony and culpability remain OPEN |
| Wren | Agency and incomplete knowledge are important | Exact knowledge, observations and testimony remain OPEN |
| Repairman | A trail toward a camp is an established direction | Identity details, trail contents, destination facts and fate remain OPEN |

No automatic Concordance connection is authorized. Do not add Devourers, children, remains, graphic content or an explicit threat to this slice.

## Required NPC knowledge record

Every future authored statement must provide:

- `npc_id`: stable identifier for the speaker.
- `topic_id`: explicit topic key, never guessed from the final word of a sentence.
- `statement_id`: stable unique identifier for this authored statement.
- `response_text`: the actual authored dialogue.
- `provenance_category`: exactly `Observed`, `Reported`, `Inferred`, or `Unconfirmed`.
- `source_id`: stable identifier for the observation, report, reasoning record or unresolved claim supporting the statement.
- `knowledge_scope`: the speaker's own knowledge profile; never a global pool.
- `canon_status`: `LOCKED`, `SLICE`, `RESERVED`, or `OPEN`.
- `is_evidence`: always false for NLI dialogue output.

A source identifier records provenance; it does not by itself prove truth. A reported claim must retain attribution. An inference must remain explicitly an inference. Unconfirmed information must not be phrased as established fact.

## Knowledge access rules

1. Resolve answers only against the current speaker's own knowledge profile.
2. A speaker may know an event only if an authored observation or attributed report grants that knowledge.
3. Never infer that a character witnessed an event because they were nearby, present in a scene, or important to the plot.
4. If no authorized entry matches, return the knowledge-boundary response.
5. If several entries match and conflict, do not silently choose one. Return an ambiguity result for authored dialogue handling.
6. NLI dialogue is not an Evidence Board item and cannot satisfy an investigation requirement.
7. The Evidence Board may separately store an observation or report through its own validated gameplay action; the NLI response is not that action.
8. Companion commands remain requests. A companion actor or gameplay authority must explicitly accept or reject them.
9. NLI cannot update mission state, relationships, inventory, objective completion or world state.

## Topic routing

Question parsing must use an explicit alias table that maps recognized phrases to authored topic IDs. Unmapped or ambiguous questions must return a clarification-required result. Do not fall back to arbitrary last-word extraction.

The first safe topic set may include identity and location only when those entries have actually been authored for the relevant NPC. The presence of a topic alias does not imply that any NPC has an answer.

## Validation requirements

A future validator should reject:
- Missing NPC, topic, statement or source identifiers.
- Empty dialogue text.
- Unknown provenance categories.
- Missing knowledge-scope or canon-status values.
- Any NLI dialogue entry with `is_evidence=true`.
- Duplicate statement IDs within the same knowledge dataset.
- An NPC statement whose source is not present in that NPC's permitted knowledge scope.
- A response that upgrades Reported, Inferred or Unconfirmed content into an Observed/confirmed assertion.

A validator should not attempt to judge whether a fictional claim is true. That remains an authored canon and narrative review responsibility.

## Acceptance scenarios

1. Dorian cannot answer a question about Wren's private knowledge unless an explicit authorized report grants him that information.
2. Wren cannot identify an event as witnessed unless an authored observation grants that knowledge.
3. A reported statement retains attribution and the `Reported` category.
4. An inference remains labeled `Inferred`.
5. An unconfirmed lead cannot be presented as a confirmed clue.
6. An unknown topic produces an honest knowledge-boundary response.
7. Conflicting authored entries produce an ambiguity result rather than an arbitrary answer.
8. NLI dialogue always has `is_evidence=false`.
9. NLI cannot complete an objective or mutate world state.
10. The repairman trail remains a direction toward camp; no fate or additional clue is invented.

## Open items

- Exact NPC knowledge facts and witness statements.
- Exact clue text and clue-to-claim relationships.
- The underlying Ridgeview mystery truth.
- The repairman's fate.
- Any Concordance relationship.
- Final five-approach outcomes for Speak/Preach, Investigate, Rescue, Defend and Withdraw.

These remain OPEN until separately authored and reviewed. This contract is not permission to fill them by inference.
