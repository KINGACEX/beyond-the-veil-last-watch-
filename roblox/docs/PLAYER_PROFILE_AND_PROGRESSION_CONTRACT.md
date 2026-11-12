# Roblox Player Profile and Covenant Progression Contract — v0.1

**Status:** Engineering contract for implementation. This document does not enable persistence, promotions, purchases or live gameplay authority.

## 1. Current baseline

The current `PlayerStateService` stores player state in server memory and clears it when a player leaves. It initializes each session at Recruit and assigns core companion ownership. Rank and currency therefore do not yet persist across servers or sessions.

The current `CovenantRankCatalog` defines the approved 15-rank order. It is a catalogue, not a promotion system.

A pure shared schema module now exists at `src/shared/PlayerProfileSchema.luau`. A deterministic lease decision module now exists at `src/shared/ProfileLeasePolicy.luau`. A pure record-transformation module now exists at `src/shared/ProfileRecordPolicy.luau`; it defines `UpdateAsync`-callback-safe acquisition, save and release transformations, validates stored and candidate profiles, rejects active competing leases and stale revisions, increments revisions on save, and returns new records without mutating callback inputs. Headless regression cases cover these rules. None of these modules calls DataStoreService or enables persistence. The schema creates the proposed version-1 default profile and validates schema version, revision, identity, rank membership, event-list shape, non-negative integer balances, companion IDs, premium-candidate restrictions and equipped-companion ownership. Persistence remains disabled.

## 2. Profile ownership

All authoritative profile writes happen on the Roblox server. Clients may request an action, but may not submit an authoritative rank, balance, entitlement, team leader role or promotion result.

Suggested profile envelope:

```luau
{
    schemaVersion = 1,
    revision = 0,
    identity = {
        characterId = "roblox_player_chosen",
        covenantBranch = "Unassigned",
    },
    progression = {
        covenantRank = "Recruit",
        completedEvaluations = {},
        completedMissionIds = {},
    },
    economy = {
        aces = 0,
        covenantCredits = 0,
    },
    companions = {
        owned = { ember = true, fox = true, owl = true, horse = true },
        equipped = "ember",
    },
}
```

This is a proposed schema. It must be reconciled with existing PlayerStateService, mission and companion data before migration or production use.

## 3. Data integrity

- Use a versioned profile schema and explicit migration functions.
- Validate every loaded field; reject or quarantine malformed values rather than trusting them.
- Use server-side DataStore operations only.
- Prefer atomic `UpdateAsync` transformations for profile mutations that must not overwrite concurrent writes.
- Do not save every frame or every UI change.
- Coalesce safe changes and save at controlled lifecycle points, with retry/backoff for transient failures.
- Handle throttling and service outages without resetting a returning player to a fresh Recruit profile.
- Do not report a save as successful until Roblox confirms it.
- Do not store passwords, email addresses, real names, chat transcripts or other unnecessary personal data.
- Use a reviewed session-lock/lease strategy before enabling writes from multiple servers for the same player.

## 4. Rank progression

- The only valid rank values are those in `CovenantRankCatalog.Ranks`.
- The initial rank is Recruit.
- Promotion must be an explicit server-side state transition from the current rank to exactly the next rank.
- A promotion request must reference a server-recorded evaluation or progression event, not client-provided claims.
- Evaluation IDs must be unique and idempotent.
- A repeated evaluation event must not grant a second promotion.
- A failed save must not leave the in-memory session claiming a promotion that was not durably committed.
- Rank changes must be audited with previous rank, next rank, event identifier and server timestamp; avoid retaining unnecessary personal data.
- The actual criteria for each promotion are not authored yet. Do not invent requirements or enable promotions until approved.

## 5. Economy and purchases

- Currency balances are server-owned.
- Award amounts must be selected by trusted server gameplay configuration, not by clients.
- Session-only duplicate-award protection is not sufficient for durable rewards; the final design needs durable receipt/event idempotency.
- Robux purchases must use Roblox's server-side receipt processing and durable entitlement records.
- A purchase may grant only its configured cosmetic/lifestyle entitlement.
- No purchase grants rank, promotion, command authority, mission completion or competitive advantage.
- Keep all product IDs, prices and receipt processing disabled until separately reviewed and approved.

## 6. Server-local organisation

Server assignment is ephemeral and must not be stored as a player's permanent rank:

```luau
{
    serverSessionId = "...",
    teamId = "...",
    assignedRole = "Member" -- or a narrowly defined leadership duty
}
```

- Derive eligibility from the persistent rank plus explicit server policy.
- Do not automatically make the highest-ranked player an unrestricted server administrator.
- Leadership powers must be narrow, logged and revocable when the player leaves.
- Server assignments never rewrite the persistent rank.
- NPC leadership fills operational gaps when no eligible player leader is available.
- Team assignment must be server-authoritative and resilient to players joining/leaving.

## 7. Required test cases before enabling persistence

1. New profile receives Recruit and the approved default free companions.
2. Returning profile loads the exact saved rank, balances and companion ownership.
3. Unknown rank, malformed balance or unsupported schema is rejected safely.
4. Migration from each prior schema preserves valid progress.
5. Two servers cannot silently overwrite each other's profile updates.
6. A DataStore outage does not silently replace an existing profile with defaults.
7. Repeated mission/evaluation event IDs do not duplicate rewards or promotions.
8. A failed save does not produce a false success message.
9. A player leaving during a save does not corrupt the profile.
10. Client-forged rank, balance, ownership and leadership payloads are ignored.
11. Rejoining another server preserves rank while rebuilding server-local team assignment.
12. PC and mobile clients receive identical authoritative profile data.

## 8. Rollout gates

Do not enable production persistence until schema review, migration tests, concurrent-session strategy, failure handling and Roblox Studio multi-client tests pass.

Do not enable promotions until promotion criteria and evaluator permissions are approved.

Do not enable purchases until product catalogue, price presentation, server-side receipt handling, durable entitlement delivery and recovery tests are reviewed.


## 9. DataStore adapter implementation gate

The pure policies above are necessary but are not a persistence adapter. The adapter must satisfy all of the following before it is connected to `PlayerStateService`:

- Use one namespaced key per Roblox user and a unique owner token per player session. The token must not be reused by another server or a later session.
- Perform acquisition, save and release through atomic `UpdateAsync` transformations. The transformation callback must remain deterministic, non-yielding and free of external side effects because Roblox may invoke it more than once.
- Treat lease contention, malformed stored data, unsupported schema and revision conflict as terminal domain outcomes, not transient service errors.
- Retry only errors classified as transient, with a bounded attempt count, exponential backoff and jitter. Do not retry every error indiscriminately.
- Resolve ambiguous write outcomes before retrying a save. An `UpdateAsync` call can fail at the client boundary after a server-side write may have committed; retrying the same revision blindly can misreport a successful save as a conflict. The record policy currently has no durable operation identifier for save reconciliation, so this must be designed and tested before automatic save retries are enabled.
- Renew a lease comfortably before expiry. A server that cannot renew must stop accepting new authoritative profile mutations and must not overwrite a newer owner's record.
- Do not create a fresh default profile after a load/acquisition failure. A player must not enter a writable session unless the profile was acquired successfully.
- On departure, save the latest valid snapshot before releasing the lease. If saving fails, do not claim the profile was saved; release behavior must not erase or replace the stored profile. Shutdown handling must use bounded work and must not depend on an unbounded wait.
- Use an injectable fake DataStore for deterministic tests of callback retries, contention, service errors, ambiguous outcomes, save ordering and release ownership. Then run Roblox Studio multi-server tests before enabling the adapter in production.
- Keep the adapter disconnected from live player joins until the above checks pass. The current in-memory service remains the active implementation.

**Current blocker:** the pure record policy does not yet include durable save-operation idempotency/reconciliation. Therefore, a production adapter with automatic save retries is not approved by this contract.

## 10. Cross-platform invariant

Profile and progression rules are platform-independent. PC, mobile and supported gamepad clients use the same server-authoritative data and permissions. Input method may change controls and layout only; it must never change rank, rewards or entitlement.
