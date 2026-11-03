# NLI 001 — Natural Language Interaction Foundation

**Status:** SOURCE IMPLEMENTED — NOT ENGINE-VERIFIED  
**Branch:** `btv/bootstrap-prototype-001`

## Purpose
NLI is the player-facing natural-language layer for NPC conversation and companion requests. It must preserve player agency, narrative integrity and authoritative game-state ownership.

## Pipeline
`utterance → deterministic parse → intent validation → request lifecycle guard → bounded knowledge/action handoff`

## Implemented modules
- `NLICommandParser`: exact allowlisted phrase grammar for the initial command vocabulary and basic question prefixes.
- `NLIValidator`: validates question topics, companion targets and supported commands. The canonical `attack` command is recognised but deferred until its gameplay system is designed and reviewed.
- `NLIRequestGate`: rejects empty/duplicate request IDs and manages pending, completed and cancelled request states.
- `NLIKnowledgeBase`: stores authored NPC/topic responses only; unknown questions return an explicit knowledge-boundary response.
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
- Question topic extraction is deliberately basic and requires authored topic mapping.
- Request lifecycle is in-memory only; save/load persistence is not implemented.
- The command handoff is not yet connected to an actual companion actor.
- No Godot parser, editor, runtime or Android test has been recorded as passed.

## Acceptance tests to run in Godot
1. Empty input is rejected.
2. `scout ahead` parses as a Scout companion command.
3. A command without a companion ID is rejected.
4. `attack` is recognised but rejected as deferred.
5. A known NPC/topic returns its authored response.
6. An unknown NPC/topic returns the explicit knowledge-boundary response.
7. Reusing a request ID is rejected.
8. Cancelling a pending request removes it from the pending set.
9. NLI returns structured data and does not mutate authoritative game state.

## Next milestone
Add a small automated test harness and connect the validated request/result contract to a neutral NPC and companion test double. Only after those tests pass should the project consider a constrained LLM adapter.
