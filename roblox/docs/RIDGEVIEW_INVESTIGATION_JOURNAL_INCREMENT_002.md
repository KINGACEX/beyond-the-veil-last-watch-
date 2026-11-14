# Ridgeview Investigation Journal Increment 002

**Status:** Implemented in source; headless tests, formatting, lint and Rojo build passed. Roblox Studio, multiplayer and device runtime validation remain pending.  
**Branch:** `btv/roblox-ridgeview-journal-002`  
**Build validation:** GitHub Actions run [43571684971](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/43571684971)  
**Authority:** Implementation increment subordinate to BTV Master Canon and approved creator decisions. This document records code behaviour; it does not promote proposed investigation-bible material into canon.

## Implemented player flow

1. Arrive at Ridgeview.
2. Examine and record the two approved approach observations: belongings near the approach and the parked work vehicle/toolkit.
3. After both observations are recorded, the Wren testimony conversation becomes available.
4. Wren gives a first-hand account with explicit limits: she saw the repairman go toward the camp, did not follow him, cannot provide an exact time, did not see him return, and does not know what happened.
5. The account is recorded in the player's own Field Notes journal.
6. Sharing is a separate decision. If the player asks, Wren explicitly authorizes only this detail: she saw the repairman go toward the camp. The player must confirm that permission before the detail can be discussed with Pike.
7. Pike's follow-up is available only when that permission exists. His limited admission is recorded as his statement, not as proof of every accusation or a legal finding.
8. A player who keeps Wren's testimony private can still proceed to review findings and unresolved questions.

## State and privacy contract

- `RidgeviewInvestigationService` is the shared server-side session state owner, keyed by `UserId`.
- The policy keeps observations, testimony recorded, explicit sharing permission, and Pike's admission as separate fields.
- The journal snapshot is generated server-side and returned only to the requesting player.
- Updates use `FireClient(player, ...)`; no global broadcast is used for testimony, consent or admission.
- The permission scope is narrow and fixed to the single approved detail. Pike dialogue no longer repeats unrelated private information.
- Re-recording testimony resets prior permission and the dependent Pike admission.
- A completed Pike conversation is not retroactively undisclosed; the policy rejects that invalid state change.
- State is session-only and cleared when the player leaves. Persistence is intentionally not added in this increment.

## Objective progression

- `collect_observations` → `speak_with_wren`
- `speak_with_wren` → `choose_disclosure`
- `choose_disclosure` → `pike_followup` when explicit permission is confirmed
- `choose_disclosure` → `review_findings` when the player keeps the account private
- `pike_followup` → `review_findings` after Pike's limited admission
- A player who initially keeps the account private may later revisit Wren and explicitly authorize the limited disclosure; the optional Pike follow-up remains available.

Wren's testimony is gated until both approach observations are recorded. Pike's general conversation remains available, but the Wren-specific discussion choice is not offered without permission.

## Regression coverage

`tests/ridgeview_investigation.spec.luau` checks:

- unknown, malformed and duplicate observation IDs;
- immutable source state during observation recording;
- separation of observations, testimony, permission and Pike's admission;
- permission cannot precede testimony and must be an explicit boolean;
- private testimony blocks Pike discussion and admission;
- authorized disclosure records only the narrow permitted detail;
- a new testimony recording resets permission and dependent admission;
- player-state isolation;
- objective ordering, rejected skips, the consented Pike branch, and the valid private-review branch.

The existing foundation and settlement regression suites also pass.

## Validation evidence

**CONFIRMED:** GitHub Actions run 43571684971 completed successfully:
- headless foundation, settlement and Ridgeview investigation tests;
- StyLua formatting checks;
- Selene Luau lint;
- Rojo place build;
- build artifact upload.

**NOT YET CONFIRMED:** Roblox Studio runtime, two-client multiplayer isolation, prompt exploit resistance under live simulation, character respawn behaviour, touch layout on Android, desktop layout, and real device performance. CI source checks and a Rojo build do not prove those runtime properties.

## Explicitly out of scope

- Persistent testimony or journal storage across sessions.
- Final evidence board, case report or mission resolution.
- Any inference that identifies the repairman, explains the camp, establishes a culprit, or resolves the missing-person question.
- Rewards, currency, XP, ranks, morality or faith scoring.
- Final NPC rigs, animation, voice acting or production art.
