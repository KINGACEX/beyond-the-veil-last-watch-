# BEYOND THE VEIL: THE LAST WATCH
## INVESTIGATION & EVIDENCE BIBLE v0.1

**Status:** PROPOSED — design specification; not approved canon except where explicitly marked CONFIRMED FROM EXISTING BTV REFERENCES  
**Date:** 2026-11-01  
**Authority:** Subordinate to later explicit creator decisions, BTV Master Canon, Canon Changelog & Reconciliation, Master Development Handoff, and relevant specialist bibles.  
**Related references:** Veil Rules & Metaphysics Bible v0.1; Vertical Slice Specification v0.2; Story & Lore Bible; Veil & Enemy Encyclopedia; Covenant Bible; Faith, Prayer & Armor of God Bible; Character Bible; Natural Language Interaction System Specification v0.1.

> **Purpose:** Establish a fair, legible, replayable investigation framework for BTV. This document governs how evidence is authored, discovered, attributed, interpreted, challenged and used in decisions. It does not define the ultimate nature of the Veil, the origins of the Devourers, or any unapproved character, faction or event history.

---

## 0. Executive summary

BTV investigations should make the player feel observant and responsible, not dependent on arbitrary hidden-object hunts or an omniscient assistant. The player gathers information from people, places, records and events; distinguishes observation from interpretation; tests competing explanations; then chooses what to do under uncertainty.

The central design principle is **earned understanding**:

1. The world presents observable details.
2. The player can inspect and preserve relevant evidence.
3. Every important claim has a source and context.
4. Characters may disagree, misunderstand, omit or deceive, but the narrative must know why.
5. Multiple clues support important conclusions.
6. The player can act without collecting every optional clue.
7. Outcomes reflect the quality and limits of the player's understanding without reducing people or faith to a score.

The investigation system is a narrative and gameplay framework, not a forensic simulator. It should be readable on Android, scalable to PC, and implementable first with deterministic authored content.

## 1. Authority, status and canon discipline

Use the project's current working statuses:

- **CONFIRMED:** explicitly established by creator decision or authoritative BTV reference.
- **PROPOSED:** recommended design awaiting approval where approval is required.
- **UNKNOWN:** not established; do not invent an answer.
- **BLOCKED:** cannot be finalised until a named dependency or decision is resolved.
- **COMPLETED:** finished with evidence recorded.

### 1.1 Confirmed anchors relevant to this bible

- **CONFIRMED:** The vertical slice includes a Scout Report leading to an investigation at Ridgeview Outpost.
- **CONFIRMED:** Ridgeview is an established Devourers mission setting.
- **CONFIRMED:** The outpost is isolated; the established mission premise includes missing people, a leader to speak with, evidence to find and a decision to make.
- **CONFIRMED:** The player approaches are Speak/Preach, Investigate, Rescue, Defend and Withdraw.
- **CONFIRMED:** The Scout Report distinguishes first-hand observations, second-hand reports, inferences, alternatives and gaps.
- **CONFIRMED:** Covenant Scouts handle reconnaissance, reporting and threat identification; Watchers help distinguish reliable information from deception.
- **CONFIRMED:** Covenant members can be mistaken; the organisation is not omniscient or infallible.
- **CONFIRMED:** The Evidence Board, photography as evidence, Journal, Covenant Link and signal dead zones are established systems in the vertical-slice material.
- **CONFIRMED:** The Devourers are rare, disturbing and non-graphic; their depiction is choice-driven.
- **CONFIRMED:** The Veil's origin, ultimate metaphysics and limits remain unknown.
- **CONFIRMED:** Prayer and the Holy Spirit are not navigation, clue-reveal or answer mechanics.
- **CONFIRMED:** The NLI may not invent evidence, hidden facts, Scripture, quest outcomes or canon; authoritative game-state changes remain deterministic and validated.

### 1.2 Proposed design decisions in this document

The evidence taxonomy, source reliability model, evidence record schema, clue graph, hypothesis handling, case-board behaviour, fail-forward rules, and acceptance tests below are **PROPOSED**. They are not canon until approved.

### 1.3 Non-negotiable integrity rules

1. Do not turn an AI-generated possibility into a world fact.
2. Do not use an unexplained clue to retroactively justify a twist.
3. Do not make the player prove a supernatural explanation merely because a mission is labelled supernatural.
4. Do not treat a character's confidence, rank, charisma or religious language as proof.
5. Do not make prayer, Scripture, the Holy Spirit, salvation or spiritual maturity into a clue-solving resource or score.
6. Do not make every mystery resolve to the Veil.
7. Do not allow a single optional clue to permanently block the main mission.
8. Do not label a hypothesis as confirmed until the evidence and source chain support it.

---

## 2. The investigation loop

### 2.1 Core loop

**Report → Orient → Observe → Preserve → Attribute → Compare → Hypothesise → Corroborate → Prepare → Decide → Resolve → Review**

| Phase | Player activity | System responsibility | Failure to avoid |
|---|---|---|---|
| Report | Reads or hears an intelligence report | Separate observed facts, reports, inference and gaps | Report presented as omniscient truth |
| Orient | Understands location, objective and known risks | Provide clear context and optional preparation | Forcing immediate action without comprehension |
| Observe | Examines people, spaces, objects and changes | Surface authored, relevant details fairly | Pixel-hunting or arbitrary interaction hotspots |
| Preserve | Records a photo, note, item or testimony | Store the evidence with source and context | Evidence silently changing after collection |
| Attribute | Checks who/what produced it and when | Keep provenance attached | Detached clues with no origin |
| Compare | Relates evidence and contradictions | Make relationships inspectable | Auto-solving every deduction |
| Hypothesise | Considers possible explanations | Permit multiple plausible interpretations | Presenting one unsupported answer as certain |
| Corroborate | Seeks independent confirmation | Offer alternative sources and routes | Requiring one exact NPC or item |
| Prepare | Chooses equipment, route, allies or timing | Reflect actual capabilities and constraints | Preparation as a hidden mandatory checklist |
| Decide | Chooses an approach | Validate actions and preserve consequences | Moral score or forced combat |
| Resolve | Sees what the action actually achieved | Report success, failure and unresolved elements truthfully | Claiming outcomes that did not occur |
| Review | Updates journal and understanding | Separate resolved facts from remaining questions | Retconning earlier evidence without explanation |

### 2.2 Player-facing objective language

Objectives should describe what the player can reasonably do, not prescribe an unsupported conclusion.

Prefer:
- “Find out why the supply route has gone quiet.”
- “Establish whether anyone remains at the outpost.”
- “Speak with the outpost leader if it is safe to do so.”
- “Determine what can be verified about the missing travellers.”

Avoid:
- “Prove the Devourers are responsible” before the evidence supports it.
- “Find the Veil portal” when no such object or rule is established.
- “Use prayer to reveal the truth.”

### 2.3 Information versus objective completion

Evidence collection and mission completion are related but distinct. The player may complete a mission with incomplete information. The Journal should preserve what remains uncertain; it must not imply that an unresolved question was answered simply because the mission ended.

---

## 3. Evidence taxonomy

An evidence item may have more than one tag. Tags describe its form, not its truth value.

| Type | Examples | Main design questions |
|---|---|---|
| Physical | A damaged object, disturbed material, abandoned supply container | Is it authentic, intact and connected to this incident? |
| Environmental | Unusual room condition, changed route, power state, weather trace | Could ordinary conditions explain it? What changed and when? |
| Digital / recorded | Radio log, device record, photograph, audio recording | Is the record complete, authentic and correctly timestamped? |
| Testimonial | Witness account, Scout statement, trader report | What did the speaker personally perceive? What are their limits? |
| Behavioural | Repeated routines, avoidance, inconsistent conduct | What alternative explanations fit the behaviour? |
| Archival | Written log, delivery record, old notice, map annotation | Who created it, for what purpose, and when? |
| Anomalous | An observation that does not fit known ordinary explanations | Is the observation repeatable? Is its description precise? |
| Contradictory | Two records or accounts that cannot both be fully correct | Are they truly incompatible, or do they describe different times or contexts? |

### 3.1 Evidence is not interpretation

Each record must keep the following separate:

- **Observation:** what the player or source directly perceived.
- **Description:** a neutral account of the observation.
- **Interpretation:** what someone thinks the observation means.
- **Attribution:** who or what produced the information.
- **Context:** where, when and under what conditions it was obtained.

Example:

- Observation: “The east gate is open.”
- Interpretation: “Someone may have left in a hurry.”
- Alternative: “The gate may have been left open during ordinary use.”
- Unknown: “Who opened it, and when?”

The game must not silently promote the interpretation to fact.

### 3.2 Evidence status labels

**PROPOSED player-facing labels:**

- **Observed:** directly perceived by the player or a named source.
- **Recorded:** captured in a record whose existence is confirmed; its contents may still require authentication.
- **Reported:** stated by another person or source.
- **Inferred:** reasoned from one or more observations.
- **Unverified:** not independently confirmed.
- **Disputed:** credible sources or evidence conflict.
- **Discredited:** a specific claim has been shown unreliable; this does not automatically discredit every claim from that source.
- **Unknown:** not currently established.

Avoid numeric certainty percentages unless a future tested design need justifies them. A label should communicate the kind of knowledge, not pretend to calculate truth mathematically.

---

## 4. Provenance and source assessment

### 4.1 Evidence record schema

Every important evidence record should store:

| Field | Purpose |
|---|---|
| `evidence_id` | Stable unique identifier |
| `title` | Short player-readable name |
| `neutral_description` | What was actually observed or recorded |
| `evidence_type` | One or more taxonomy tags |
| `source_id` | Person, object, device, location or record that produced it |
| `collector_id` | Player or character who obtained it |
| `location_id` | Where it was obtained |
| `observed_at` | In-world time or a bounded time estimate |
| `created_at` | Time the record or object was created, if known |
| `integrity_state` | Whether it is intact, partial, altered or unknown |
| `authenticity_state` | Verified, unverified, disputed or unknown |
| `directness` | First-hand observation, second-hand report or later interpretation |
| `context_notes` | Conditions affecting interpretation |
| `related_evidence` | Links to corroborating or conflicting items |
| `claims_supported` | Specific claims this item can support |
| `claims_not_supported` | Tempting conclusions it does not establish |
| `knowledge_permissions` | Which characters/systems may know it |
| `visibility_state` | Hidden, discoverable, collected, reviewed or disclosed |

The schema is a proposed data contract, not a commitment to a particular engine implementation.

### 4.2 Source assessment dimensions

Do not compress source reliability into a single magic score. Assess the dimensions that matter:

1. **Authenticity:** Is this genuinely from the claimed source?
2. **Integrity:** Has it been altered, damaged, edited or selectively presented?
3. **Directness:** Did the source witness the event, hear about it, or infer it?
4. **Competence:** Was the source in a position to observe this particular detail?
5. **Context:** Were visibility, distance, stress, timing, equipment or environmental conditions limiting?
6. **Independence:** Does corroboration come from a genuinely separate source, or do sources repeat the same original rumour?
7. **Relevance:** Does the item bear on the specific claim being considered?
8. **Temporal fit:** Does the evidence relate to the same event and time window?

A source can be reliable about one detail and unreliable about another. A witness may accurately report a sound but be unable to identify its cause.

### 4.3 Corroboration rules

- Two accounts that repeat the same rumour are not independent corroboration.
- A photograph and the witness who took it may be one source chain, not two independent sources.
- A damaged recording can corroborate that a transmission occurred without proving the speaker's identity.
- An absence of evidence is not automatically evidence of absence; the search method and expected detectability matter.
- Contradictory evidence should trigger review, not automatic deletion of one side.
- A source's Covenant rank does not make an unverified claim true.

### 4.4 Chain of custody — lightweight narrative model

For critical evidence, record who collected it, whether it was altered, who accessed it and whether it was transferred. This is a narrative consistency tool, not a full legal or forensic simulation. Do not burden every ordinary collectible with a chain-of-custody minigame.

---

## 5. Claims, hypotheses and deduction

### 5.1 Three-layer model

1. **Evidence item:** a particular observation or record.
2. **Claim:** a statement that may be supported or challenged by evidence.
3. **Hypothesis:** a possible explanation connecting multiple claims.

Example:
- Evidence: “No delivery vehicle was observed on the approach road during the Scout's two-day watch.”
- Claim: “The road appears to have had no recent delivery traffic during that observation window.”
- Hypothesis: “The outpost may be isolated because its supply route has been interrupted.”

The hypothesis is plausible, but the evidence does not establish why the route was interrupted.

### 5.2 Hypothesis states

**PROPOSED:**
- **Possible:** compatible with currently known evidence.
- **Supported:** backed by relevant evidence, but alternatives remain.
- **Strongly supported:** supported by multiple relevant sources with no known decisive contradiction.
- **Disputed:** meaningful evidence conflicts with it.
- **Rejected:** contradicted by sufficiently strong evidence in this case.
- **Unresolved:** the investigation ends without enough information.

These labels describe the current case file, not universal truth. The player may be allowed to hold an incorrect belief; the game should not silently rewrite the player's belief as an objective fact.

### 5.3 Fair deduction

For every major conclusion, the writer must prepare an internal argument map:

- What is the conclusion?
- Which evidence supports it?
- Which evidence challenges it?
- What assumptions connect evidence to conclusion?
- What ordinary alternatives remain?
- What does the conclusion *not* prove?
- What new observation would change the assessment?

A player should be able to explain the conclusion in plain language after seeing the relevant evidence. If the writer cannot do that, the clue chain is not ready.

### 5.4 Avoid false precision

Do not use a percentage such as “87% certain” unless the game has a defensible in-world method for deriving it. Narrative confidence is qualitative and claim-specific.

---

## 6. The Evidence Board and Journal

### 6.1 Evidence Board purpose

The Evidence Board helps the player organise information; it should not solve the mystery automatically. Its primary functions are:

- list collected evidence;
- show each item's source and status;
- link evidence to claims and hypotheses;
- show contradictions and missing corroboration;
- let the player review unresolved questions;
- preserve the difference between what the player knows and what a character believes.

### 6.2 Board interaction

**PROPOSED interaction model:**

- Evidence cards are grouped by source, location or type.
- The player can open an item to inspect its full description and provenance.
- Related items may be connected manually or surfaced as authored suggestions.
- A suggested connection is labelled as a suggestion, not a fact.
- The board never invents a link merely because two items were collected near each other.
- Important story conclusions can be authored as explicit deductions once their prerequisites are met.
- Optional connections reward curiosity but do not gate the main mission unless clearly communicated and fairly signposted.

### 6.3 Journal structure

Recommended sections:

1. **Current objective** — the immediate task.
2. **Known facts** — directly observed or verified claims.
3. **Reports and testimony** — attributed statements.
4. **Interpretations** — hypotheses and competing explanations.
5. **Open questions** — unresolved matters.
6. **Decisions and outcomes** — what the player chose and what actually followed.
7. **People and places** — only information the protagonist has legitimately learned.

### 6.4 No hidden auto-completion

Collecting an item should not automatically imply the player understood it. Where interpretation matters, provide a deliberate review or deduction step. Conversely, do not force the player to manually connect obvious facts simply to pad playtime.

### 6.5 Mobile-first presentation

- Prioritise readable cards and vertical lists over a dense desktop-style corkboard.
- Provide a compact overview and a detail view.
- Use touch targets large enough for comfortable interaction.
- Avoid requiring drag-and-drop precision; offer tap-to-select and tap-to-link alternatives.
- Keep important labels visible without relying on hover.
- Preserve state when the player closes the board.

---

## 7. NPC knowledge, testimony and information flow

### 7.1 Knowledge is character-specific

Each NPC's knowledge should be represented as a bounded record, not a global story database available to every character.

A knowledge record should include:
- fact or claim identifier;
- whether the NPC observed it, was told it, inferred it or believes it;
- source of the information;
- time and place learned;
- confidence or uncertainty expressed by the NPC;
- whether the NPC is permitted to disclose it;
- reasons for withholding or misunderstanding it, if authored;
- whether later events have corrected or challenged it.

### 7.2 NPC knowledge boundaries

- An NPC cannot know evidence they have not encountered or received.
- A character may know a fact but lack the vocabulary to explain it.
- A character's belief may be mistaken without the character being malicious.
- A witness can withhold information for a grounded reason, but the writer must define that reason.
- A lie must have an authorial purpose and a discoverable or at least coherent basis; arbitrary deception is not a substitute for mystery.
- The Covenant is not omniscient. Scouts and Watchers have roles, not infallibility.

### 7.3 Testimony dialogue

Questions should distinguish:
- “What did you see?”
- “What did you hear from someone else?”
- “When did this happen?”
- “How close were you?”
- “What makes you think that?”
- “Is there anyone else who can confirm it?”

NPCs should answer only within their knowledge. They may say “I don't know,” “I heard that from someone else,” or “I might be mistaken.” These are valid narrative outcomes, not failed dialogue.

### 7.4 Rumour propagation

If rumours spread through the world, track their origin and transformations. A repeated rumour should not be mistaken for independent confirmation. A rumour may become distorted over time, but the distortion should be authored or governed by explicit rules, not generated arbitrarily.

### 7.5 Memory boundaries

The NLI may maintain only approved, useful character memory. Minor conversation should not become permanent world truth. Player assertions do not become facts merely because they were spoken. The NLI must distinguish an NPC's belief, the player's claim and authoritative world state.

---

## 8. Player approaches and consequences

### 8.1 Established Ridgeview approaches

The five approaches are **CONFIRMED FROM EXISTING VERTICAL-SLICE REFERENCE**:

1. **Speak/Preach** — engage people through conversation and truthful Christian witness where appropriate.
2. **Investigate** — prioritise understanding, corroboration and careful assessment.
3. **Rescue** — prioritise locating and helping people who may be at risk.
4. **Defend** — prioritise protection when a credible threat requires it.
5. **Withdraw** — disengage when the available information, capability or circumstances do not justify continuing.

These are approaches, not a morality ladder. They may overlap; the player may gather information before choosing one. Do not frame one approach as the universal “good” answer.

### 8.2 Consequence design

Consequences should be:
- causally connected to the player's actual actions;
- proportionate to what the player could reasonably know;
- communicated through the world and characters;
- consistent with established character motivations;
- recorded in mission state where needed;
- reversible only where the fiction and systems support reversal.

Do not use a universal morality meter, spiritual score, salvation score or hidden divine-favour variable.

### 8.3 Outcome dimensions

A mission outcome may track separate practical dimensions, such as:
- people located or assisted;
- information verified;
- immediate risk reduced or left unresolved;
- trust gained, strained or unchanged;
- resources used or preserved;
- Covenant information quality;
- unresolved follow-up questions.

These are descriptive mission variables, not a single judgement of the player's worth.

### 8.4 Truthful outcome reporting

The game should report what happened, not flatter the player. If an attempt fails, say so. If the player withdraws, record that the situation remains unresolved rather than inventing a successful rescue. If a witness refuses to speak, do not pretend the conversation succeeded.

---

## 9. Fail-forward, missed clues and re-entry

### 9.1 Main-path resilience

A critical story beat must not depend on one obscure optional object. For each essential inference, provide more than one fair route to the necessary information, unless the intended design explicitly allows the player to miss that information and continue with a different outcome.

### 9.2 Missed evidence

If the player leaves an area before collecting optional evidence:
- preserve the missed item as missed, rather than silently granting it;
- allow a later return if the world state permits;
- provide a different information route when narratively credible;
- update the objective so the player understands what remains unknown;
- avoid an unexplained mission soft-lock.

### 9.3 Incorrect hypothesis

The player may draw a wrong conclusion. The system should:
- show which evidence the player used;
- allow new evidence to challenge the conclusion;
- avoid punishing a reasonable inference with an arbitrary dead end;
- preserve the consequence if the player acts on the mistaken belief;
- make the correction understandable after the fact.

### 9.4 Incomplete investigation

If the player must decide with incomplete evidence, the game should communicate the relevant uncertainty. It should not require perfect knowledge for every decision. Some situations are time-sensitive or morally difficult; the design should make the trade-off legible.

### 9.5 Re-entry recap

On returning to a mission after a break, provide a concise recap of:
- the current objective;
- last confirmed facts;
- current hypotheses and disputes;
- the last player decision;
- the most immediate unresolved issue.

The recap must not reveal undiscovered clues or collapse uncertainty into a single answer.

---

## 10. NLI and AI integrity contract

### 10.1 AI role

The NLI may:
- interpret a player's natural-language question or request;
- retrieve authored evidence the character is allowed to know;
- explain the difference between an observation and an inference;
- summarise the case file without changing its meaning;
- ask a clarifying question;
- suggest an authored, grounded next step;
- phrase a response based on a deterministic action result.

The NLI may not:
- create evidence or alter its provenance;
- reveal hidden information the NPC cannot know;
- invent witness testimony, records, dates, names or events;
- declare a hypothesis true without authored support;
- create or change canon;
- directly mutate authoritative mission state;
- execute arbitrary code or bypass validated action contracts;
- claim an action succeeded before the game reports success;
- fabricate Scripture quotations or references;
- present prayer or the Holy Spirit as an investigative tool.

### 10.2 Required processing sequence

**Input → context resolution → typed intent → knowledge retrieval → source grounding → deterministic validation → clarification if ambiguous → validated action → actual handler result → grounded response → authorised memory update.**

### 10.3 Evidence answer format

When an NPC or assistant explains a conclusion, it should be able to identify:
- the claim being discussed;
- the evidence supporting it;
- the source of that evidence;
- any known limitation or contradiction;
- what remains unknown.

If the system cannot retrieve the evidence, it should say so rather than improvising.

### 10.4 Graceful fallback

If the model, network or retrieval system is unavailable, the authored Journal, Evidence Board, dialogue choices and mission objectives must remain usable. The player must not lose access to critical story content because an online model is unavailable.

---

## 11. Ridgeview Outpost — investigation framework

**Status:** The setting and broad mission premise are CONFIRMED; the specific case truth, clue content, named NPCs, exact events and outcome branches below are PROPOSED design placeholders pending cross-check and creator approval. This section does not establish new Devourer or Veil lore.

### 11.1 Mission purpose

Test the complete investigation loop in a compact, readable location. The player should learn how to distinguish a Scout's direct observations from a trader's report, inspect the environment, speak with the outpost leader, preserve evidence and choose an approach without being forced into combat or a predetermined supernatural conclusion.

### 11.2 Known report foundation

The existing Scout Report draft includes these information categories and examples:
- The Scout observed no vehicles using the approach road during a two-day watch.
- The Scout observed only one building showing lights at night.
- A radio check was answered once by an unfamiliar voice that gave no name and ended the call.
- A roadside trader reported that the regular supply delivery did not arrive and that the outpost had “been shut for weeks.”
- The Scout did not enter the outpost; signal quality was weak beyond the ridge.

These are report contents in the existing proposal, not independently verified world facts. The trader's statement remains reported testimony. The Scout's inference that people may be staying in the lit building is not proof of who is there.

### 11.3 Case design rule

The writer must create a private case-truth document before finalising player-facing clues. That document must answer:
- What actually happened at Ridgeview?
- Which people know each part of the truth?
- Which claims are accurate, mistaken, incomplete or deceptive?
- What caused each observable clue?
- Which ordinary explanations are plausible at first?
- What is genuinely anomalous, if anything?
- What is deliberately left unresolved?

**Do not fill these answers by assuming the Devourers' origin, the Veil's ultimate purpose or a hidden hierarchy.** The case may establish local events without resolving cosmic questions.

### 11.4 Proposed clue architecture

The following are *slots* for authored content, not locked clue facts:

| Slot | Evidence role | Player question | Design requirement |
|---|---|---|---|
| R-01: Approach-road observation | Environmental / physical | Has the route been used recently? | Give a readable time window and ordinary alternatives |
| R-02: Supply record or remnant | Archival / physical | Was a delivery scheduled, attempted or missed? | Establish source and date; do not infer cause automatically |
| R-03: Radio record | Digital / recorded | What was actually transmitted? | Separate audible content from speaker identity and interpretation |
| R-04: Occupied-building signs | Environmental | Is anyone present now or recently? | Avoid treating one light or sound as proof of identity |
| R-05: Witness account | Testimonial | What did the witness directly observe? | Bound knowledge by location, time and opportunity to observe |
| R-06: Outpost leader conversation | Testimonial / behavioural | What does the leader know, believe or withhold? | Give the leader a coherent knowledge boundary and motive |
| R-07: Contradictory detail | Contradictory | Which accounts do not align, and why? | Contradiction must have a discoverable context or remain explicitly unresolved |
| R-08: Optional corroboration | Any appropriate type | Can an important claim be independently checked? | Reward thoroughness without gating the entire mission |

At least three inspectable evidence items or environmental clues are required by the vertical-slice spec. The final authored mission should use a richer chain only if each item contributes a distinct inference or decision.

### 11.5 Information gates

**PROPOSED:**
- The player can begin the investigation from the Scout Report alone.
- The player can speak to the leader without having collected every clue, subject to the scene's authored safety and access conditions.
- The player can reach a meaningful decision with partial evidence.
- Optional evidence can improve the player's understanding or change a practical decision, but should not be a disguised mandatory checklist.
- If the player chooses to withdraw, the mission can resolve as a withdrawal with unresolved questions; the game must not falsely report a full investigation.

### 11.6 Five approaches in practice

| Approach | Possible focus | Must not imply |
|---|---|---|
| Speak/Preach | Listen, speak truthfully, offer help, share Christian witness where appropriate | That faith guarantees cooperation or supernatural answers |
| Investigate | Gather and compare evidence, ask questions, test explanations | That the player must solve every detail before acting |
| Rescue | Prioritise locating and assisting people | That every missing person is confirmed alive or reachable |
| Defend | Protect people when a credible threat is established | That violence is the default or only effective response |
| Withdraw | Preserve life and reassess when risk or capability is unacceptable | That withdrawal is automatically cowardice or failure |

This framework must not predetermine which approach is morally superior. Outcomes depend on the actual case truth, the player's information and the consequences of the chosen action.

### 11.7 Mystery pacing

The Ridgeview case should answer its local question(s) sufficiently to make the mission satisfying while preserving the larger Veil mystery. It should not reveal the Veil's ultimate origin, final antagonist, cosmology or full history merely to provide a dramatic ending.

### 11.8 Writer's case file template

- Case ID:
- Working title:
- Status:
- Confirmed canon anchors:
- Private underlying truth:
- What the player initially knows:
- What the Scout knows:
- What the leader knows:
- What each witness knows:
- Timeline:
- Evidence items and provenance:
- Claims supported:
- Claims challenged:
- Competing hypotheses:
- Ordinary explanations:
- Anomalous observations, if any:
- Critical inference:
- Optional inference:
- Five approach outcomes:
- Consequences and follow-up:
- Unresolved questions:
- Canon conflicts checked:
- Theology review:
- Accessibility review:
- NLI knowledge-boundary review:
- Acceptance-test results:

---

## 12. Accessibility and player comprehension

- Never make colour the only way to distinguish evidence status; pair colour with text, iconography or shape.
- Provide subtitles and text equivalents for audio clues.
- Provide visual alternatives for sound-dependent clues where fair and appropriate.
- Support adjustable text size and strong contrast.
- Avoid requiring rapid reading during a timed decision; allow players to review critical information where the scene permits.
- Do not make essential evidence depend on hearing a quiet sound at a precise moment.
- Avoid tiny inspectable objects and pixel-perfect touch targets.
- Ensure camera angle, lighting and contrast do not conceal mandatory clues unfairly.
- Provide a clear interaction prompt and accessible Journal navigation.
- Do not make speech recognition the only way to question an NPC; provide authored text choices or typed input alternatives.
- Localisation must preserve distinctions among observed, reported, inferred, disputed and unknown.

---

## 13. Technical and production guidance

### 13.1 Android-first principles

- Evidence records should be data-driven and lightweight.
- Keep mission state deterministic and saveable.
- Avoid a large continuously simulated evidence graph; compute or load only the active case's relevant relationships.
- Use authored dialogue and deterministic clue interactions for the first prototype.
- Keep NLI optional and non-critical to progression.
- Cache Journal and evidence text locally where appropriate.
- Measure memory, save size, interaction latency and loading cost before setting numerical budgets.

### 13.2 Suggested logical data objects

These are conceptual names, not confirmed code symbols:
- `EvidenceRecord`
- `EvidenceSource`
- `ClaimRecord`
- `HypothesisRecord`
- `KnowledgeRecord`
- `CaseDefinition`
- `CaseState`
- `EvidenceRelation`
- `MissionDecision`
- `OutcomeRecord`

### 13.3 Deterministic state

The game should own authoritative values such as:
- whether evidence has been discovered;
- whether a character has been spoken to;
- whether an action is available;
- whether a decision has been made;
- which outcome branch was actually executed;
- which facts are authorised for the Journal.

A language model may request a typed action, but the game validates and executes it. The model must never write directly to these values.

### 13.4 Save and restore

Save enough state to restore:
- collected evidence;
- reviewed evidence;
- authored deductions unlocked;
- current objective;
- relevant NPC knowledge updates;
- player decisions;
- outcome state;
- unresolved case questions.

Test save/load at each major investigation phase. Do not persist transient model text as authoritative evidence.

---

## 14. Acceptance criteria and test suite

A case is ready for implementation only when all applicable criteria pass:

1. Every critical evidence item has a source and provenance.
2. Observation and interpretation are explicitly separated.
3. Important claims have a defensible evidence chain.
4. Independent corroboration is genuinely independent.
5. Contradictions are intentional and explainable or clearly unresolved.
6. No single optional clue hard-gates the main mission.
7. A player can act with incomplete information and understand the uncertainty.
8. NPC knowledge is bounded and attributable.
9. The NLI cannot invent or disclose unauthorised facts.
10. The Journal accurately reflects what the protagonist knows.
11. Outcomes match the actions that actually executed.
12. Five Ridgeview approaches remain viable as distinct approaches where the case permits.
13. No universal morality or spiritual score is introduced.
14. Faith, prayer, Scripture and the Holy Spirit are handled within the approved theological boundaries.
15. The Veil and Devourers' unknown origins are not accidentally established.
16. Essential clues have accessibility alternatives.
17. The mission remains playable with NLI/model/network unavailable.
18. Save/load preserves the investigation state accurately.
19. The case has been checked against Master Canon, Changelog, Veil/Enemy, Story/Lore and Vertical Slice references.
20. No implementation or test is claimed until it has actually been performed.

### 14.1 Proposed test cases

| Test ID | Scenario | Expected result | Priority |
|---|---|---|---|
| INV-01 | Read Scout Report | Observed, reported, inferred and unknown details remain distinct | Must pass |
| INV-02 | Inspect evidence | Record includes source, location and context | Must pass |
| INV-03 | Two witnesses repeat one rumour | System does not label them independent corroboration | Must pass |
| INV-04 | Witness reports a sound but not its cause | Dialogue preserves that distinction | Must pass |
| INV-05 | Player misses optional clue | Main mission remains completable or branches honestly | Must pass |
| INV-06 | Player forms a wrong hypothesis | New evidence can challenge it without arbitrary lockout | Must pass |
| INV-07 | Conflicting timestamps | Board marks dispute and offers context where authored | Must pass |
| INV-08 | NPC asked about unseen evidence | NPC admits lack of knowledge or cites a valid source | Must pass |
| INV-09 | Player asks NLI to invent a missing clue | NLI refuses to fabricate and identifies the gap | Must pass |
| INV-10 | Player withdraws | Mission records withdrawal and unresolved facts truthfully | Must pass |
| INV-11 | Player chooses Rescue before full investigation | Valid action proceeds if authored conditions permit | Must pass |
| INV-12 | Prayer requested as clue detector | System does not turn prayer/Holy Spirit into a mechanic | Must pass |
| INV-13 | Colour-only status display disabled or inaccessible | Text/icon labels still communicate evidence status | Must pass |
| INV-14 | Model/network unavailable | Authored investigation remains playable | Must pass |
| INV-15 | Save/load after evidence collection | Evidence, journal and case state restore correctly | Must pass |
| INV-16 | Player returns after a long break | Recap reports known facts and unresolved questions without spoilers | Should pass |
| INV-17 | Player asks whether an inference is confirmed | Response names supporting evidence and limitations | Must pass |
| INV-18 | Mission resolution with unresolved hypothesis | Journal preserves unresolved status after completion | Must pass |

---

## 15. Mystery & Revelation Register — initial framework

This register is intended to become the central index for major BTV mysteries. It prevents separate documents from accidentally promising incompatible answers or revealing information too early.

### 15.1 Register fields

- Mystery ID
- Working question / player promise
- Domain (Veil, Covenant, character, enemy, location, event, theology, other)
- Status (CONFIRMED / PROPOSED / UNKNOWN / BLOCKED / COMPLETED)
- First hint / first appearance
- Evidence and clue references
- Character knowledge permissions
- Intended reveal window (chapter/arc, not an invented calendar date)
- Answer status (known to writers / approved / unresolved)
- Required setup
- Red herrings and their fair explanation
- Consequences of discovery
- Follow-on question
- Source-of-truth document
- Canon approval record

### 15.2 Initial register entries

| ID | Mystery question | Status | Safe handling | Source of truth |
|---|---|---|---|---|
| MR-001 | What is the Veil ultimately? | UNKNOWN | Do not supply a definitive origin or cosmology in incidental dialogue | Master Canon; Veil Bible |
| MR-002 | What causes the observed Veil incident stages? | UNKNOWN | Use observable case facts; do not invent universal thresholds | Changelog; Veil Bible |
| MR-003 | What is Ember's origin and nature? | UNKNOWN | Keep Ember useful but non-omniscient; no accidental species reveal | Character Bible; Changelog |
| MR-004 | What are the Devourers' origins and hierarchy? | UNKNOWN | Write local behaviour and mission facts only where approved | Veil & Enemy Encyclopedia |
| MR-005 | What happened at Ridgeview Outpost? | PROPOSED case design; local mission setting confirmed | Define private case truth before clue scripting; do not confuse proposal with canon | Vertical Slice; mission case file to be authored |
| MR-006 | What does the Covenant know about the Veil? | UNKNOWN | Knowledge varies by person, role and source; no omniscience | Covenant Bible; NLI spec |
| MR-007 | What is the full history of the Veil? | UNKNOWN | Reveal only what an approved story arc needs | Master Canon; Veil Bible |
| MR-008 | Who is the ultimate antagonist? | UNKNOWN | Do not seed a false identity or prematurely name a hierarchy | Master Canon; Story & Lore |
| MR-009 | What can Veil Sight reveal? | BLOCKED | Requires a separate bounded Ember ability contract | Ember ability bible to be authored |
| MR-010 | What is the relationship between local incidents and the wider Veil mystery? | PROPOSED design question | Each case may resolve locally while contributing a carefully controlled clue to the larger arc | Veil Bible; future story outline |

These entries are not promises that every mystery will be answered. A mystery may remain open, be answered partially, or be reframed by an approved story decision. The register exists to keep promises deliberate and consistent.

---

## 16. Five-revelation architecture versus six Veil stages

These are separate systems and must not be conflated.

### 16.1 Five-revelation narrative architecture

**PROPOSED:**
1. **The Signs** — the player notices discrete details that do not yet form a complete pattern.
2. **The Pattern** — multiple observations suggest a connection, while ordinary alternatives remain possible.
3. **The Influence** — the player learns that the situation affects people, places or events in a meaningful way.
4. **The Competing Understandings** — characters or groups interpret the evidence differently; the player must evaluate sources and limits.
5. **The Arc Revelation** — an approved answer resolves the arc's central question while preserving any larger mystery deliberately left open.

### 16.2 Six incident stages

**CONFIRMED framework:**
1. Normal
2. Disturbed
3. Influenced
4. Veil-Touched
5. Veil Breach
6. Critical / Endgame-Level

The five revelations describe how the audience learns. The six stages classify an incident. One revelation may span multiple stages; one stage may be encountered before or after a particular revelation. No one-to-one mapping is implied.

---

## 17. Production roadmap

1. Reconcile this bible against the latest Master Canon, Canon Changelog, Veil & Enemy Encyclopedia, Story & Lore, Covenant, Faith/Prayer/Armor, Character and Vertical Slice documents.
2. Confirm which Ridgeview report details are retained in the latest approved mission text.
3. Author a private Ridgeview case-truth document before finalising the player-facing clue chain.
4. Build a clue-to-claim argument map and NPC knowledge matrix.
5. Review the five approaches and outcome branches for fairness and theological integrity.
6. Create deterministic evidence, Journal and Board data contracts.
7. Add NLI only as a bounded optional interaction layer after deterministic dialogue and evidence retrieval work.
8. Test the investigation on Android-sized screens and with model/network unavailable.
9. Reconcile the Mystery & Revelation Register with the story outline before adding major twists.
10. Only after creator approval, convert the relevant sections into implementation tasks and repository-ready specifications.

---

## 18. Status ledger

- **CONFIRMED:** Ridgeview Outpost is an established Devourers mission setting; Scout Report information categories; Evidence Board, photography, Journal, Covenant Link and signal dead zones; five approaches; non-graphic, choice-driven Devourers; NLI knowledge and canon boundaries; unknown Veil origin and metaphysics.
- **PROPOSED:** Investigation loop; evidence taxonomy; provenance model; qualitative source assessment; claim/hypothesis states; Evidence Board behaviour; NPC knowledge schema; fail-forward rules; Ridgeview clue slots; initial Mystery & Revelation Register; acceptance tests.
- **UNKNOWN:** The actual underlying Ridgeview case truth; final clue contents; exact witness identities and knowledge; Devourer origin and hierarchy; Veil origin, limits and ultimate metaphysics; final antagonist; Ember's origin.
- **BLOCKED:** Final mission scripting and implementation until the Ridgeview case truth is authored and reconciled with the Veil & Enemy Encyclopedia and current approved canon.
- **COMPLETED:** Drafted this v0.1 investigation and evidence framework. No game implementation, repository changes or gameplay tests are claimed.

---

**End of BTV Investigation & Evidence Bible v0.1**