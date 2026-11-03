# NLI 001 — Natural Language Interaction Foundation

**Status:** SOURCE IMPLEMENTED — NOT ENGINE-VERIFIED  
**Branch:** `btv/bootstrap-prototype-001`

## Purpose
NLI is the player-facing natural-language layer for NPC conversation and companion requests. It must preserve player agency, narrative integrity and authoritative game-state ownership.

## Pipeline
`utterance → deterministic parse → intent validation → request lifecycle guard → bounded knowledge/action handoff`

## Implemented modules
- `NLICommandParser`: exact allowlisted command phrases and complete question aliases; unsupported questions return `clarification_required` rather than guessing a topic.
- `NLIValidator`: validates question topics, companion targets and supported commands. The canonical `attack` command is recognised but deferred until its gameplay system is designed and reviewed.
- `NLIRequestGate`: rejects empty/duplicate request IDs and manages pending, completed and cancelled request states.
- `NLIKnowledgeBase`: requires an explicitly registered per-NPC profile with an allowlist of source IDs; validates complete provenance-bearing records, enforces profile scope and approved provenance/canon vocabularies, rejects evidence-marked dialogue and duplicate statement IDs, and returns ambiguity when multiple records match.
- `NLIService`: orchestrates the pipeline and returns structured results. It does not directly mutate mission, inventory, relationship or world state.

## Canon and integrity rules
1. NPCs can only answer from their own authored knowledge entries.
2. Unknown or unsupported questions must produce an honest uncertainty response, not invented lore, evidence or claims.
3. NLI output is not itself evidence and cannot directly complete objectives.
4. Companion commands are typed requests handed to the companion gameplay system; that system retains authority to accept, reject or execute them.
5. No hidden spiritual scoring, transactional prayer, purchasable faith/salvation/holiness or divine-favour mechanics.
6. Voice transcription, LLM integration, persistent conversational memory and open-ended dialogue are out of scope for this foundation.

## Initial companion command vocabulary
- Supported handoff: Protect, Scout, Track, Retrieve, Hold, Regroup.
- Recognised but deferred: Attack.
- Unknown commands are rejected. The parser currently recognises explicit phrase forms only; it does not infer intent from arbitrary text.

## Limitations
- This is a deterministic prototype grammar, not a production natural-language understanding model.
- The active parser/validator/service pipeline uses Dictionary intent envelopes. `NLIIntent` exists as a reserved schema but is not wired into the pipeline.
- Question routing is intentionally limited to a small explicit alias table; new question forms and topics must be deliberately authored.
- Request lifecycle is in-memory only; save/load persistence is not implemented.
- The command handoff is not yet connected to an actual companion actor.
- No Godot parser, editor, runtime or Android test has been recorded as passed.

## Smoke-test coverage (source committed; execution pending)
The harness covers empty/unknown input, explicit question aliases, clarification for unsupported questions, companion command validation, deferred Attack, NPC profile registration, authorized-source checks, profile-scope checks, provenance output, evidence rejection, duplicate statement IDs, ambiguity, unknown topics, request lifecycle and bounded service handoff.

## Local smoke-test harness

A lightweight test script is provided at `tests/nli_smoke_test.gd`. Run it from the project root with a local Godot executable:

```sh
godot --headless --path . --script res://tests/nli_smoke_test.gd
```

The script exits with code 0 when all assertions pass and code 1 when any fail. This harness has been committed but has not yet been executed in this environment.

## Next milestone
Execute the smoke-test harness in Godot 4.7.2, resolve any parser/runtime errors, then add isolated NPC profile fixtures for the approved Ridgeview acceptance scenarios. No unresolved Ridgeview facts should be authored during this technical validation step.
