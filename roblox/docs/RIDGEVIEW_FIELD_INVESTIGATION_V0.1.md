# Ridgeview Field Investigation v0.1

**Status:** Implemented in source; automated policy tests added; Roblox Studio/runtime validation pending.

## Scope

This is the first interactive investigation loop for the Roblox vertical slice. It adds two player-observable interactions on the Ridgeview approach:

1. **Belongings near the approach** — records that a small collection of personal belongings has been left near the approach. The owner and reason are explicitly unknown.
2. **Parked work vehicle** — records that a work vehicle is parked near the approach with a toolkit inside. The owner and reason it was left there are explicitly unknown.

These observations are drawn from the approved BTV Vertical Slice Specification v1.0, Ridgeview investigation section.

## Player flow

- The player must reach the server-owned `ridgeview_arrival` mission phase.
- The player approaches either visible blockout prop and uses its ProximityPrompt.
- The server checks player presence, distance, mission phase, request interval and note identifier.
- A valid observation is added once to that player's session journal.
- The server sends the updated snapshot to that player only.
- The client displays the observations in the Field Notes panel.

## Technical boundaries

- Server-authoritative recording; the client cannot submit arbitrary text or define note content.
- Per-player session isolation by UserId.
- Duplicate and unknown note IDs are rejected.
- Journal is session-only and is cleared when the player leaves.
- No XP, Aces, Covenant Credits, items, scores, rank changes or morality values.
- No inferred culprit, owner, cause, missing-person identity or mission conclusion.
- The two greybox props are presentation blockouts, not final assets or a canon-locked settlement layout.

## Files

- `src/shared/RidgeviewFieldNoteCatalog.luau`
- `src/shared/RidgeviewFieldNotePolicy.luau`
- `src/server/Services/RidgeviewFieldNotes.server.luau`
- `src/client/RidgeviewFieldNotes.client.luau`
- `tests/foundation.spec.luau`

## Validation

The pure policy has headless tests for approved IDs, unknown IDs, duplicate rejection, immutable source journals, stable ordering and preservation of the Observed confidence label.

A passing headless test or Rojo build does not establish runtime playability. Studio checks still required:

- Verify prompts appear at the intended Ridgeview approach positions.
- Verify both props are visible and reachable without obstructing the arrival path.
- Verify a player cannot record notes before Ridgeview arrival.
- Verify one player's notes are not visible to another player.
- Verify duplicate prompt activation does not duplicate entries.
- Verify the journal panel fits supported mobile viewport sizes.
- Verify character respawn does not erase session notes.
