# BTV Ridgeview Revelation & Evidence Matrix v0.1

**Status:** PROPOSED ANALYTICAL DESIGN AID — NOT NEW CANON  
**Scope:** Scout Report → Ridgeview observations and testimony → Evidence Board → player response → Asher's final report.  
**Authority:** Subordinate to the BTV Master Canon and the merged Vertical Slice Specification v1.0. If this matrix conflicts with either, the controlling source wins.  
**Primary source:** `docs/source-of-truth/vertical-slice/BTV_Vertical_Slice_Specification_v1.0.md`, especially Sections 7–18.  
**Companion source:** `docs/story/BTV_VERTICAL_SLICE_OPENING_TO_RIDGEVIEW_NARRATIVE_FLOW_v0.1.md`.

## 1. Purpose and interpretation rules

This matrix translates the locked slice's investigation requirements into a traceable content and QA aid. It does not add a new culprit, event, clue, character, enemy identity, repairman fate, or explanation of the Veil.

The investigation must teach the player to distinguish:
- **Observed / Reported / Inferred / Unconfirmed:** the Scout Report's historical evidence labels and Asher's report categories.
- **Confirmed / Contradicted / Still open:** Asher's working status for an individual claim after field assessment.
- **Unverified:** a connection the player draws on the Evidence Board, not a synonym for a weak fact.

A source's label is never silently rewritten. A later observation may change the working status of a claim without changing what the Scout originally knew.

### Evidence discipline

1. Direct observation can establish only what Asher actually observes, at the time and place he observes it.
2. Physical evidence can support a conclusion only to the extent its contents and provenance justify.
3. A Reported claim requires Asher's own observation or two independent sources to be confirmed. One frightened resident's testimony alone remains Reported.
4. A contradiction disproves the contradicted proposition, not every other claim from the same speaker.
5. A plausible connection is not a confirmed causal explanation.
6. Ember supplies local observations, warnings and possibilities, not answers or omniscience.
7. The Evidence Board does not solve the mystery. It highlights a contradiction only when the player connects incompatible items.
8. The repairman's status remains unresolved in this slice. Do not report him as dead, rescued, found, or definitively explained.
9. The Devourers are never named or identified in dialogue, UI, Covenant classification or Asher's report.
10. Keep all evidence and threat presentation non-graphic and within the locked content boundaries.

## 2. Scout Report claim matrix

The IDs below are proposed stable content/QA identifiers, not new in-world labels.

| ID | Scout Report claim | Original label | What Ridgeview can establish | What it cannot establish by itself | Working status guidance |
|---|---|---|---|---|---|
| SR-01 | No vehicle traffic on the approach road for two days | Observed | Asher can observe the road's present condition and any authored visible signs. | One visit cannot independently prove the full two-day period. Do not invent a log, tracks or camera record. | Still open unless the slice supplies direct, time-bounded corroboration. |
| SR-02 | Only one building was lit at night | Observed | Arrival moves from late afternoon into evening, allowing Asher to observe the settlement's lighting at that time. | A single later observation does not prove what was lit on the Scout's earlier night. | Confirmed or Contradicted only against the actual authored observation window; otherwise Still open. |
| SR-03 | People are staying in that building | Inferred | Asher may observe people present in the building or settlement, if the scene explicitly shows this. | Seeing a person once does not prove residence or how long they have stayed. | Confirm presence only; retain the broader “staying” inference unless supported. |
| SR-04 | A radio check was answered once by an unfamiliar voice that ended the call | Observed | The Scout's account remains attributable to the Scout. | Asher cannot independently verify a past radio exchange merely by hearing silence or later signal failure. | Historical Scout observation; local verification Still open unless an approved source is authored. |
| SR-05 | The supply delivery was missed | Reported (trader), Unconfirmed | A separate delivery record or independent testimony could support it only if such evidence is approved and authored. | Settlement occupancy does not prove whether a delivery was missed. Do not invent delivery paperwork or a named supplier. | Still open on current approved slice evidence. |
| SR-06 | The outpost has been shut for weeks | Reported (trader), Unconfirmed | Asher finds the settlement occupied; this disproves the broad claim that the outpost/settlement has been shut. | Occupancy does not establish the supply-delivery status or explain why the trader said it. | Contradicted, with the contradiction scoped to the “shut for weeks” claim. |
| SR-07 | Two travellers are overdue, one a man on a repair contract | Reported, Unconfirmed | The work vehicle/toolkit and start of a repairman's trail can support the existence of a repair-related presence. A marked toolkit or trail may support the visitor-relative connection if authored. | These details alone do not establish the two travellers' identities, their current locations, the repairman's fate, or that the visitor's relative is the repairman. | Still open; visitor connection remains Unverified until its specified support exists. |
| SR-08 | Birdsong and small wildlife are unusually absent | Observed; cause Unconfirmed | Asher can experience the unusually quiet approach and observe the absence described by the slice. | The absence does not identify a cause, prove a specific enemy, or excuse human choices. | The absence may be Confirmed as an observation; cause remains Unconfirmed/Still open. |

### Required contradiction handling

The trader's second-hand “shut for weeks” claim is the deliberately planted error. Finding people in the settlement contradicts that claim. The report must not then discard the trader's separate delivery statement or infer deliberate deception. Those are different propositions and remain independently assessable.

## 3. Ridgeview local evidence matrix

| ID | Approved source / observation | Evidence class | May support | Does not prove | Required restraint |
|---|---|---|---|---|---|
| RV-01 | Watched road | Direct environmental observation | The approach is monitored or watched, if the authored scene makes that visible. | Who is watching, why, or whether a specific person is hostile. | Do not invent a watcher identity or motive. |
| RV-02 | Abandoned belongings | Physical evidence | Someone left belongings at the location. | Who left them, why, or what happened afterward. | Keep item details within the approved asset/content brief. |
| RV-03 | Parked work vehicle and toolkit | Physical evidence | A work/repair-related presence at Ridgeview. | The repairman's identity, the visitor-relative connection, or his fate without additional support. | No invented name, personal record or identifying mark. |
| RV-04 | Beginning of the repairman's trail | Physical/tracking observation | A trail exists and can be followed if the player finds and follows it. | The trail's full destination, the repairman's condition or what caused the trail to end. | Tracking Sense indicates where someone went, not why; the trail can be lost. |
| RV-05 | Occupied settlement | Direct observation | People are present; contradicts the trader's “shut for weeks” claim. | The settlement's normal population, the residents' freedom, or every other report claim. | Residents are wary but may answer if Asher listens first. |
| RV-06 | Wren's private testimony | Testimony / Reported | Her own perspective, fear, information and checkable statements. | A complete explanation or automatic confirmation of her claims. | One frightened resident's word alone stays Reported. She is not an exposition machine. |
| RV-07 | Dorian Pike's account | Testimony / Reported | His explanation and perspective; statements to cross-check against evidence. | His innocence, guilt, full condition, or a final classification. | Keep him calm, persuasive and complex; do not force a complete reveal. |
| RV-08 | Outlying camp evidence | Physical evidence and environment | The hardest available evidence about what became of the repairman; may establish that something happened. | A complete account, definitive fate, or full explanation of the wider threat. | Non-graphic details only; leave a reasoning gap. |
| RV-09 | Work log / recorded stay ending / hurried tidy-up | Non-graphic physical or documentary evidence, only as authored in the slice | A documented work presence and an unexplained interruption or gap. | Death, cause, perpetrator, destination or definitive fate. | Do not invent entries, dates, names or graphic aftermath. |
| RV-10 | Quiet deepens; radio/devices unreliable toward settlement centre and camp | Environmental / Veil-state observation | The slice's Influenced state intensifies toward the camp. | The Veil's origin, full mechanics, a named enemy or justification for human choices. | Veil-Touched, Breach and Critical are not reached in this slice. |

**Scope note:** RV-09 lists evidence forms explicitly permitted by the merged slice specification. It does not assert that every item must appear in the final build. Exact item content, placement and provenance still require content authoring and review.

## 4. Character testimony and reveal limits

### Wren

- Wren is frightened and wants out; she signals that she wants to speak away from others.
- Her account may mix checkable fact, fear and gaps. She may contradict herself under stress.
- Her testimony is valuable but not automatically true.
- A single statement from Wren cannot by itself upgrade a Reported claim to Confirmed.
- Her reasons for not having left already must not be replaced with an invented explanation before approved writing.

### Dorian Pike

- Pike is the local leader, calm and persuasive; much of what he says is true.
- Reveal layers are earned through first impressions, small contradictions, physical evidence, Wren's testimony and his words under pressure.
- His true condition remains uncertain until the player gathers enough evidence.
- The player may leave without learning every layer.
- Do not assign an enemy class, definitive guilt, legal status or a one-dimensional villain role.

### The visitor connection

- The visitor at Logos Rhema mentions one relative who went to work in a remote area and has missed check-ins. She does not name Ridgeview or explain the case.
- The relationship between that relative and the overdue repairman is a player-generated connection and begins **Unverified**.
- A marked toolkit or the repairman's trail are examples in the slice specification of evidence that may support the connection.
- The precise marker, identity match and final support threshold must be defined by authored content; do not fabricate them in this matrix.
- If no supporting evidence is found, the connection remains Unverified or is not made.

## 5. Veil observation versus causal explanation

| Stage | Approved slice presentation | Permitted player conclusion | Forbidden conclusion |
|---|---|---|---|
| Approach — Disturbed | Missing wildlife, muffled sound, Ember more alert | The environment is unusually quiet and warrants attention. | The player knows the cause or enemy. |
| Settlement/camp — Influenced | Unreliable radio/devices, uneasy residents, quiet deepening toward camp | The influence is more pronounced toward the camp. | The player knows what the Veil is, why it is happening, or that it absolves human choices. |

Ember's cues can prompt observation but never label a clue as the answer. The slice does not reach Veil-Touched, Breach or Critical. No monster is created in Ridgeview by the Influenced state.

## 6. Evidence Board and claim-state transitions

A claim record should keep the historical Scout label separate from the current field assessment.

| Field | Meaning |
|---|---|
| `claim_id` | Stable ID such as SR-06; proposed data key, not an in-world string. |
| `claim_text` | Exact proposition being assessed. |
| `origin_source` | Scout, trader, Wren, Pike, physical observation or other authored source. |
| `origin_label` | Original Observed / Reported / Inferred / Unconfirmed label. |
| `field_status` | Confirmed / Contradicted / Still open. |
| `evidence_refs` | Only evidence actually collected by Asher. |
| `independent_source_count` | Count of independent sources, not repeated statements from one source. |
| `player_link_status` | Unverified until supported; only applies to player-created connections. |
| `reason` | Short explanation of why the status is justified. |
| `unresolved_limit` | What the collected evidence still cannot establish. |

### Safe transition rules

- Start with the original Scout label and a field status of Still open.
- Change field status only when the player collects evidence that supports or contradicts the exact proposition.
- A direct observation can confirm a current observable proposition, not an unobserved historical duration.
- A contradiction must be proposition-specific. Do not cascade it to unrelated claims.
- A Reported claim remains Reported until Asher observes it or two independent sources support it.
- An Unverified player connection remains Unverified until its own support condition is met.
- Never convert a clue into a causal explanation simply because it appears near another clue.
- Preserve all unresolved claims in the final report.

## 7. Player response and evidence sufficiency

The five locked responses are Speak/Preach, Investigate, Rescue, Defend and Withdraw. Options can combine; Withdraw is valid at any point.

| Response | Evidence and state needed | What the narrative must record |
|---|---|---|
| Speak/Preach | Honest, patient conversation; earlier listening makes it possible. | Who was spoken to and the actual response, without guaranteeing conversion. |
| Investigate | Player chooses to continue gathering and cross-checking. | New observations, source provenance and any additional exposure/time cost defined by the implementation. |
| Rescue | Locate Wren or another person who wants to leave and establish a feasible route. | Who actually left, with whom, and whether the repairman lead was followed. |
| Defend | Only an authored credible threat or immediate danger. | Whether a defensive encounter actually occurred; do not make combat a default response to uncertainty. |
| Withdraw | Always available. | The player leaves and reports; unresolved risks remain explicit. |

Do not write combat choreography, tactical instructions or weapon detail into this narrative matrix. This is a story-state and acceptance document.

## 8. Outcome flags and report mapping

The merged specification defines these slice flags:

- `ridgeview.approaches_used`
- `ridgeview.wren_outcome`
- `ridgeview.pike_outcome`
- `ridgeview.repairman_trail`
- `ridgeview.repairman_status` — always `unresolved` in this slice
- `ridgeview.claims_resolved`
- `ridgeview.evidence_documented`
- `ridgeview.visitor_connection`
- `ridgeview.combat_occurred`
- `ridgeview.covenant_followup`
- `ridgeview.veil_state_at_exit`

The final report must be generated from recorded observations and flags, not from the option label the player selected. It must distinguish:
1. What Asher personally observed.
2. What another person reported, with source and context.
3. What Asher inferred, with its supporting evidence.
4. What remains unconfirmed.
5. What action Asher actually took.
6. What follow-up is justified, including uncertainty.

A claim cannot be labelled Observed unless Asher observed it. The duty officer may challenge confidence and the Covenant may disagree; neither is omniscient or infallible. No promotion, reward or morality score is attached.

## 9. Required narrative and QA acceptance tests

| Test ID | Scenario | Expected result |
|---|---|---|
| REV-001 | Player observes residents in the settlement. | “Outpost shut for weeks” becomes Contradicted; the separate missed-delivery claim stays Still open. |
| REV-002 | Player only visits the road once. | The historical two-day no-traffic claim is not automatically confirmed. |
| REV-003 | Player observes a person in the previously lit building. | Presence may be confirmed; long-term residence is not inferred without support. |
| REV-004 | Player hears no radio response after the ridge. | This does not independently prove the Scout's earlier radio exchange. |
| REV-005 | Player hears Wren's account but gathers no corroboration. | Her statements remain Reported; no claim is automatically Confirmed. |
| REV-006 | Player hears Pike's account. | His statements are recorded and cross-checked; no automatic guilt or innocence flag is set. |
| REV-007 | Player finds the work vehicle/toolkit. | Repair-related presence may be supported; repairman identity and fate remain unresolved. |
| REV-008 | Player follows the trail to the outlying camp. | The trail-followed state can be recorded; the repairman's fate remains unresolved. |
| REV-009 | Player links the visitor's relative to the repairman without supporting evidence. | Connection remains Unverified. |
| REV-010 | Player sees missing wildlife and hears muffled sound. | Disturbed environmental state is supported; cause remains Unconfirmed. |
| REV-011 | Player reaches the camp and devices/radio become unreliable. | Influenced state is represented; no new Veil stage or enemy identity is disclosed. |
| REV-012 | Player withdraws before collecting all evidence. | Withdraw is accepted; incomplete claims remain Still open and the report states the gaps. |
| REV-013 | Player selects Defend without a credible threat or immediate danger. | Defend is not offered as a justified response. |
| REV-014 | Player's report labels an unobserved event as Observed. | Report builder blocks or corrects the unsupported label and retains provenance. |
| REV-015 | Any dialogue/UI/report string is scanned for the forbidden enemy name or graphic material. | Content QA fails on prohibited player-facing content. |
| REV-016 | A clue appears close to another clue. | The system does not infer causation or reveal the answer automatically. |

## 10. Open implementation questions — deliberately unresolved

These are not answered by the source material and must not be guessed:

1. Exact visual details, text and provenance for each physical evidence item.
2. Exact source wording and individual factual statements from Wren and Pike.
3. Exact criteria for two sources to count as independent in the implementation.
4. The precise marked-toolkit or trail detail that can support the visitor connection.
5. Whether the player can photograph every evidence item or only selected authored objects.
6. The exact claim-resource schema and UI representation on the Evidence Board.
7. The duty officer's identity and exact dialogue; the officer remains unnamed by design.
8. The final report's detailed wording for each possible outcome.
9. Which authored credible-threat conditions can unlock Defend; do not add them in this document.
10. Exact local resolution and follow-up wording for each combination of flags.

## 11. Source traceability

| Matrix section | Controlling source |
|---|---|
| Scout claim labels and report | Vertical Slice Specification v1.0, Section 7 |
| Arrival, road, settlement, camp and Veil stages | Vertical Slice Specification v1.0, Sections 8–9 |
| Watcher and Ember limits | Vertical Slice Specification v1.0, Sections 10–11 |
| Evidence labels, confirmation and player links | Vertical Slice Specification v1.0, Section 12 |
| Pike, Wren and repairman | Vertical Slice Specification v1.0, Sections 13–14 |
| Response options and flags | Vertical Slice Specification v1.0, Sections 15–16 |
| Final report and content boundaries | Vertical Slice Specification v1.0, Sections 17–18 |
| Narrative sequencing and continuity | Opening-to-Ridgeview Narrative Flow v0.1 |

## 12. Disposition

**Completed:** Source-derived evidence matrix and test scenarios drafted.  
**Not completed:** No dialogue, new canon, mission resources, Godot code, or playable investigation was created.  
**Next implementation step:** Convert only the approved claim/evidence relationships into typed neutral data resources after the existing mission-data validator and claim-verification interfaces are reviewed. Do not author final character testimony until the creator reviews the evidence matrix and dialogue brief.
