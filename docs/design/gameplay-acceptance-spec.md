# Gameplay Acceptance Specification

**Version:** 0.1  
**Status:** Approved design direction; end-to-end runtime acceptance remains unverified

## 1. Purpose

Define the intended opening investigation loop and its narrative integrity requirements. This is an acceptance contract, not a claim that every stage is implemented or playable.

## 2. Intended player journey

1. **Temple opening:** Player receives the opening context and a clear next objective.
2. **Transition to Ridgeview:** Player enters the Ridgeview settlement/camp area. The current prototype transition is a same-place transition, not a separate Roblox place or cinematic unless later verified otherwise.
3. **Initial investigation:** Player explores permitted locations and records observations.
4. **Wren testimony:** Player may hear Wren's account through the appropriate dialogue path.
5. **Consent choice:** Player chooses whether Wren's testimony remains private or is explicitly shared.
6. **Pike response:** Pike's response becomes available only after the player explicitly shares Wren's testimony, where the relevant mission logic permits it.
7. **Field Notes:** Player records evidence with source and attribution.
8. **Evidence Board:** Player organizes observations, testimony, physical records and interpretations without collapsing them into one certainty category.
9. **Report Draft:** Player prepares a draft that distinguishes known facts, attributed accounts and unresolved questions.

The sequence is a target journey. Each step must be verified in the current build before it is described as implemented.

## 3. Narrative integrity requirements

- Wren's testimony is private by default.
- Wren's testimony must not be shared without an explicit player choice that represents her permission.
- Pike's account is attributed to Pike and is not automatically objective truth.
- A character's testimony is not silently converted into a confirmed world fact.
- Observation, testimony, physical record, interpretation and unverified information remain distinguishable.
- A report draft must preserve uncertainty and unresolved questions.
- The player's report must not fabricate a verdict, recipient response, reward, or completed submission.
- The repairman's fate remains unresolved unless the canon is explicitly updated through the proper review process.
- No dialogue choice should imply a theological conclusion that the established canon does not support.

## 4. Evidence model

Recommended evidence categories:

| Category | Meaning |
|---|---|
| Observation | Directly observed by the player or game system |
| Testimony | A statement attributed to a named speaker |
| Physical record | An in-world document, object, or trace |
| Interpretation | A reasoned explanation that remains distinguishable from evidence |
| Unverified | A lead or claim not yet corroborated |

Every evidence entry should retain a stable identifier and source attribution. Do not overwrite the source when the player forms an interpretation.

## 5. Consent and sharing rules

- Default consent state is private.
- Only an explicit, valid player action can change the sharing state.
- UI labels must communicate the consequence of sharing before confirmation.
- A failed or interrupted save must not be presented as proof that a share decision is durable.
- Concurrent requests must not allow a private/share race to produce an ambiguous final state.
- Pike's response gate must read the authoritative consent state, not a client-provided boolean.

## 6. Report draft requirements

A report draft should support:
- observations,
- testimony with speaker attribution,
- physical records,
- interpretations,
- unresolved questions,
- sharing/consent context.

A draft is not a submitted report. No verdict, reward, or recipient reaction should be implied until a separately designed and tested submission workflow exists.

## 7. Acceptance checklist

- [ ] Player can complete the opening objective path without a soft lock.
- [ ] Ridgeview entry and return behavior are understandable.
- [ ] Wren's testimony can be recorded with correct attribution.
- [ ] Private remains the default.
- [ ] Pike's gated response is unavailable before explicit sharing.
- [ ] Pike's response remains separately attributed.
- [ ] Field Notes preserve stable evidence IDs.
- [ ] Evidence Board distinguishes evidence from interpretation.
- [ ] Report Draft preserves uncertainty and unresolved questions.
- [ ] Repeated requests do not duplicate evidence or progression.
- [ ] Two players' choices and evidence remain isolated.
- [ ] Reconnect behavior is tested before any durable-progression claim.
- [ ] Mobile controls and readable dialogue are verified on an actual supported device.

## 8. Known boundary

Current source-level context indicates draft-only report behavior. Submission, recipient, verdict and reward handling are not established. Treat end-to-end completion, reconnect and live multiplayer behavior as UNKNOWN until tested.
