# BTV_Natural_Language_Interaction_System_Spec_v0.1.md

> **ARCHIVAL REFERENCE.** Earlier NLI specification; reconcile with current NLI implementation and audit findings. Original Library source remains untouched.

# BTV Natural Language Interaction (NLI) System Specification

- **Document ID:** `BTV-TECH-NLI-001`
- **Version:** 0.1
- **Status:** **PROPOSED DESIGN — NOT IMPLEMENTED OR TESTED**
- **Target:** Android-first, scalable to PC
- **Scope:** Player-to-NPC dialogue, requests, commands, companion instructions, and mission coordination
- **Canon rule:** This document does not change locked story, character, world, or theological canon.

## 1. Goal and principle

Let players ask questions, answer, express beliefs, apologize, request help, and issue commands in their own words. The game should interpret reasonable paraphrases, use scene context and established facts, and respond honestly when it cannot understand or act.

**Core principle: Free expression; contextual understanding; bounded execution.** A language model may interpret words and propose a structured action. It must never directly mutate authoritative game state, execute arbitrary code, or decide canon.

## 2. Runtime pipeline

1. Capture typed input (speech can be an optional later feature).
2. Resolve context: speaker, location, active mission, nearby entities, recent dialogue, companion state, and relevant facts.
3. Interpret into a typed intent, candidate targets, constraints, confidence, and missing fields.
4. Ground names and claims in authoritative game data and the speaker's knowledge.
5. Validate deterministically: allowlisted intent, actor capability, target, range, quest/world state, resources, constraints, and plot invariants.
6. Clarify or confirm if intent, target, or consequence is materially ambiguous.
7. Execute only a validated typed action through a deterministic handler.
8. Read the handler's actual result.
9. Generate a response that truthfully reflects completion, partial completion, blockage, failure, or uncertainty.
10. Persist only significant, authorized memories.

## 3. Proposed typed intents

These identifiers are proposals; each stays disabled until a deterministic handler exists and passes tests.

| Intent | Purpose | Boundary |
|---|---|---|
| `dialogue.ask_about_topic` | Ask about a grounded topic | Respect NPC knowledge |
| `dialogue.answer_custom` | Answer in free text | Player assertion is not automatically truth |
| `dialogue.express_belief` | State a belief or disagreement | No forced agreement or hidden morality score |
| `dialogue.apologize` | Apologize | No guaranteed forgiveness or restored trust |
| `dialogue.persuade` | Attempt a context-appropriate argument | Outcome grounded in authored context and NPC state |
| `npc.request_information` | Ask an NPC for information | Respect knowledge, trust, and availability |
| `npc.request_assistance` | Request help | Require a supported handler and valid conditions |
| `npc.assign_wait` / `npc.assign_follow` / `npc.assign_regroup` | Direct a capable ally | Validate actor and scene state |
| `companion.scout_area` | Ask a companion to scout | Preserve “do not engage” and similar constraints |
| `companion.protect_person` | Protect a valid person | Validate target and capability |
| `companion.report_observation` | Request an observation report | Separate observation from inference |
| `mission.request_medical_help` | Request medical assistance | Do not create unavailable resources |
| `mission.request_transport` | Request transport | Validate availability, location, and mission state |
| `mission.coordinate_bystanders` | Coordinate civilians | Preserve civilian safety and agency |

Never expose `run_code`, `set_quest_state`, `grant_item`, `change_canon`, or unrestricted engine commands to the language model.

## 4. Action contract and outcomes

Each action request should include a unique request ID, typed intent, actor ID, optional target ID, bounded parameters, preserved constraints, and relevant context version. The deterministic handler returns one of: `accepted`, `completed`, `partially_completed`, `needs_clarification`, `blocked`, `failed`, or `cancelled`.

The NPC must not claim success from `accepted` alone. It must use the final handler result. State-changing requests must be idempotent so retries cannot duplicate actions, items, rewards, or mission transitions. Cancellation must prevent a late model response from triggering an action.

## 5. Knowledge and truth boundaries

Keep these categories distinct:
- **Authoritative world fact:** set by trusted world/quest state.
- **Observed fact:** witnessed by an NPC or recorded by a valid game system.
- **Reported claim:** told to the NPC by an attributed source.
- **Belief/inference:** an NPC interpretation that may be mistaken.
- **Unknown:** not established for that NPC or the game.
- **Player assertion:** what the player said; not automatically proof.

NPCs may say “I don't know,” ask for a source, or offer a qualified inference. Do not invent clues, evidence, character history, relationships, Scripture references, or quest outcomes merely to sound fluent.

## 6. Canon and Christian-integrity safeguards

- God remains ultimate authority and is not a controllable combat actor.
- The Holy Spirit is not mana, an attack, a summon, or a player-controlled resource.
- Prayer is relationship, not a transaction or guarantee of a preferred outcome.
- Never score, sell, grind, or reward salvation, divine favor, holiness, or spiritual worth.
- Quote/reference Scripture only when grounded in an approved source and translation; otherwise acknowledge uncertainty.
- Model-generated lore never becomes canon automatically. Use project statuses such as `PROPOSED`, `UNKNOWN`, and `CONFLICT` for unapproved or unresolved details.
- Evangelism remains genuine and non-coercive; players may question, disagree, or decline.
- Forgiveness does not imply instant trust, erased consequences, or unsafe reconciliation.
- Christian characters are not automatically virtuous; non-Christian characters are not automatically evil.

## 7. Android UI, accessibility, privacy, and reliability

- Text-first Android input with keyboard submission, editing, cancellation, clear errors, and screen-reader labels.
- Voice input is optional; never require an always-on microphone.
- Disclose when network services or external models are used; do not claim offline AI unless tested.
- Bound context, retries, request duration, and memory growth. Measure latency and cost before setting numeric budgets.
- Provide timeout, cancellation, duplicate-request protection, and deterministic fallback dialogue/actions.
- Fallback must not silently perform an action that the unavailable model merely suggested.
- Minimize personal data sent to models; define retention and deletion behavior before implementation.

## 8. Candidate vertical-slice evaluation

**Candidate only—not canon:** *Mercy Beyond Boundaries*, an original scenario inspired by the ethical question in Luke 10:25–37. Use only if compatible with the approved vertical slice.

Test asking what happened, identifying the source of a report, requesting help, staying with someone in need, questioning a suspicious claim, correcting an NPC, and telling Ember to scout without engaging. Never reward conversion, prayer, or donation with combat power, divine favor, or spiritual score.

## 9. Release gates

Use `BTV_NLI_Acceptance_Test_Matrix.csv`. At minimum:
- Equivalent paraphrases resolve consistently; ambiguity triggers clarification.
- Model cannot mutate authoritative state or execute arbitrary code.
- Invalid targets, capabilities, parameters, quest transitions, and constraints are rejected deterministically.
- NPC responses match actual handler outcomes.
- Knowledge boundaries, attribution, idempotency, cancellation, and fallback pass tests.
- Canon, Scripture, and theology safeguards pass regression tests.
- Critical authored scenes work with NLI enabled and disabled.
- Android accessibility, privacy disclosure, latency, and cost are measured.

## 10. Work packages

1. `NLI-01` — typed intent/action schema.
2. `NLI-02` — context assembly and entity resolution.
3. `NLI-03` — deterministic router, validation, idempotency, cancellation.
4. `NLI-04` — NPC knowledge boundaries and bounded memory.
5. `NLI-05` — grounded response from actual action results.
6. `NLI-06` — Android input UI and deterministic fallback.
7. `NLI-07` — automated evaluation harness and regression suite.
8. `NLI-08` — vertical-slice integration and measured performance/cost review.

## 11. Unresolved decisions — do not guess

- Engine and actual implementation location.
- Runtime model/provider, hosting, and network requirements.
- Supported languages and localization workflow.
- Privacy/retention policy and age-appropriate online protections.
- Numeric latency/cost budgets, to be set after measurements.
- Which handlers exist in the actual codebase.
- Whether the candidate test mission fits the approved vertical slice.

## 12. Current status

**PROPOSED DESIGN — NOT IMPLEMENTED OR TESTED.** The public repository `KINGACEX/beyond-the-veil-last-watch-` was readable, and its README describes BTV at a high level. GitHub reported HTTP 403 `Resource not accessible by integration` when attempting to create branch `spec/natural-language-interaction-v0-1`. No repository files or branches were changed. These documents are local working artifacts, not committed repository files.
