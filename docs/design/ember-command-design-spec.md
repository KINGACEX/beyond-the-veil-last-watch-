# Ember Command Design Specification

**Version:** 0.1  
**Status:** Approved design direction; implementation incomplete  
**Scope:** Roblox companion command system

## 1. Purpose

Define a predictable, server-authoritative command model for Ember. Commands should improve exploration and tactical cooperation without turning Ember into an autonomous source of mission truth or allowing one player to control another player's companion.

## 2. Current implementation boundary

**CONFIRMED:** The current known implemented command scope is:
- Hold
- Regroup

**NOT IMPLEMENTED:** The following five commands are design targets only:
- Protect
- Scout
- Track
- Retrieve
- Attack

Do not expose an unfinished command as functional merely because its button, enum, animation, or placeholder exists.

## 3. Command semantics

| Command | Intended behavior | Constraints |
|---|---|---|
| Hold | Ember remains near a safe, valid hold point and does not initiate a new task | Must not trap Ember in geometry; owner can cancel |
| Regroup | Ember returns toward its owning player using safe navigation | Must fail safely if pathing is unavailable |
| Protect | Ember stays near the owner or a server-approved protected target and reacts within a bounded defensive role | No autonomous lethal escalation; no cross-player target assignment |
| Scout | Ember investigates a permitted nearby point or route and returns observations | Report only server-observed, non-spoiling information; no omniscient detection |
| Track | Ember follows a valid, authorized trail or mission clue | Must respect mission gates and evidence attribution |
| Retrieve | Ember attempts to collect or bring back a permitted item | Validate item identity, range, availability and ownership on server |
| Attack | Ember engages a server-authorized hostile target under encounter rules | Requires explicit encounter eligibility and server validation; never attack players or neutral NPCs |

Command names describe player intent. They do not grant capabilities beyond the current encounter, mission, or world rules.

## 4. Proposed controller model

Use one authoritative command controller per player-owned Ember instance.

Recommended conceptual flow:

1. Client requests a command with a command identifier and, where relevant, a target identifier.
2. Server validates player ownership, Ember availability, command enum, target, mission context, cooldown, distance, and current state.
3. Server accepts or rejects the request with a bounded result code.
4. The controller cancels or transitions the prior command according to the interruption policy.
5. Ember executes only the accepted server-side command.
6. Server emits a state update suitable for the owner's UI.
7. On player removal, Ember despawns or returns to a defined safe lifecycle state.

### Invariants

- One active primary command per Ember at a time.
- Commands are scoped to the owning player.
- The server is authoritative for command acceptance, targets, outcomes and rewards.
- A repeated request must not duplicate item collection, damage, rewards or mission progress.
- Invalid or unreachable targets result in a safe idle/regroup state, not a crash or unbounded retry loop.
- Command interruption is deterministic and does not leave stale pathfinding tasks running.
- Other players cannot issue commands to this Ember by guessing identifiers.

## 5. Interruption and priority

Proposed priority order:
1. Despawn, death, or server cleanup.
2. Explicit owner cancellation.
3. Safety fallback (invalid target, navigation failure, region unload).
4. New accepted owner command.
5. Existing command continuation.

A newly accepted command cancels the prior command cleanly. Commands must not overlap movement or interaction tasks in ways that create conflicting state.

## 6. Implementation sequence

Recommended order:
1. Protect
2. Scout
3. Track
4. Retrieve
5. Attack

This sequence prioritizes companion utility and investigation before combat complexity. The order is a proposal, not a promise of delivery dates.

## 7. Minimum acceptance tests

- Owner can issue each implemented command.
- Non-owner requests are rejected.
- Unknown command identifiers are rejected.
- Invalid, missing, distant or unauthorized targets are rejected.
- Repeated requests do not duplicate effects.
- A new command interrupts the old command exactly once.
- Pathfinding failure enters a safe fallback.
- Ember cleanup occurs when the owner leaves or the region unloads.
- Two players can command their own Ember independently.
- Existing Hold and Regroup behavior remains unchanged after each addition.
- Mobile users can reach and understand the command controls without obscuring movement or dialogue.

## 8. Observability

Record structured, privacy-conscious diagnostics for:
- request accepted/rejected,
- rejection reason category,
- command transition,
- navigation failure,
- target invalidation,
- cleanup.

Do not log secrets, authentication tokens, or unrestricted player-submitted strings.

## 9. Release gate

A command is not complete until its server behavior, client feedback, interruption, cleanup, multiplayer isolation, and mobile usability have been tested. Source presence or a passing offline unit test alone is insufficient.
