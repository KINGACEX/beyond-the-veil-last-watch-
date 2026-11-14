# Covenant Multiplayer Hierarchy — Roblox Design v0.1

**Status:** Architecture specification. Not a gameplay implementation or canon change.  
**Identity note:** The player-identity section below follows the sole-Chosen decision recorded in `CANON_ADAPTATION.md`.

## 1. Player identity

- Asher Vance remains the sole Chosen and the original main game's central protagonist.
- Every other Roblox player is a player-created Covenant operative with their own individual character identity; they are not additional Chosen and no player is silently assigned Asher's identity.
- Multiplayer cooperation runs as Covenant operations alongside the established Asher storyline; it does not multiply the Chosen role.
- Covenant membership and earned rank are persistent player-profile data once a reviewed persistence layer is approved.

## 2. Separate four concepts

These must never be collapsed into one field:

1. **Covenant rank** — the player's earned position in the approved 15-rank ladder.
2. **Server assignment** — the team, unit or operational group the player is assigned to in the current server.
3. **Server leadership role** — whether the player is acting as team lead, unit lead or another delegated role in that server.
4. **NPC authority** — canonical NPC officers and instructors who provide continuity, instruction and mission direction.

A player's earned rank follows their profile between servers. Server assignments and temporary leadership roles are recalculated for each server session.

## 3. Rank ladder

Use the existing `CovenantRankCatalog` as the single source of rank names and order:

Recruit; Field Agent; Senior Agent; Elite Agent; Specialist; Senior Specialist; Principal Specialist; Team Leader; Senior Team Leader; Unit Leader; Field Commander; Senior Commander; Regional Commander; Senior General; High General.

The catalog establishes ordering only. It does not grant permissions by itself.

## 4. Progression and promotion

- New players begin as Recruit.
- Promotion criteria must be authored and approved before promotion code is enabled.
- Only trusted server-side progression services may award a promotion.
- Client requests, UI state, chat claims, purchases and companion ownership must never grant rank.
- A promotion must be validated against the player's current rank, required evaluation state and next rank in the catalog.
- Rank changes must be persisted atomically once profile persistence is implemented.
- A duplicate mission/evaluation event must not grant duplicate progression.
- Robux purchases must never grant rank, promotion eligibility or command authority.

**Current implementation boundary:** the rank catalog exists; player state currently stores Recruit in memory for the session. Persistent profiles, evaluation criteria, promotion service and rank permissions are not yet implemented.

## 5. Server hierarchy and team assignment

- On joining a server, the server reads the player's persistent rank and builds an operational assignment for that server.
- Players can be peers, superiors or subordinates relative to other players, depending on rank and current assignment.
- Server assignment does not rewrite earned rank.
- A high-ranking player is not automatically granted unrestricted control over all players.
- Leadership permissions are narrow, explicit and server-validated: for example, proposing a team, assigning a mission group or coordinating a ready team.
- Critical mission completion, rewards, kicks, moderation and account actions remain outside player command authority.
- If a server lacks an eligible player leader, designated Covenant NPCs provide mission structure and leadership continuity.
- When players leave, the server reassigns affected teams safely without changing anyone's persistent rank.

## 6. NPC structure

Covenant NPCs and ordinary world NPCs coexist with player Chosen characters. Covenant NPCs can act as instructors, evaluators, mission contacts, team coordinators and senior officers. NPCs must not falsely claim that a player has earned a rank or evaluation they have not completed.

## 7. Chat and communication

- Chat is optional; no mission or progression requirement may depend on using chat.
- Use Roblox TextChatService and Roblox's filtering/moderation pipeline.
- Potential channels: public/proximity where supported, team, Covenant and restricted command coordination.
- Channel membership and posting permissions are server-controlled.
- Do not build an unfiltered custom text relay or bypass Roblox chat safety controls.
- UI must remain usable when chat is disabled, unavailable or restricted by platform/account settings.

## 8. Cross-platform requirements

The same server, progression, rank permissions, missions and companion ownership rules apply to PC and mobile.

- PC: mouse-accessible HUD; keyboard controls only where deliberately mapped and documented.
- Mobile: touch targets and layouts that avoid default movement/action zones.
- Gamepad: do not advertise support until selection, focus, navigation and activation are tested in Studio.
- Layout adapts to viewport size and preferred input; no platform receives a gameplay or progression advantage.
- Test PC-only, mobile-only and mixed PC/mobile clients in one server.
- Test window resizing, aspect ratios, safe areas, respawn and preferred-input changes.

## 9. Asher and Ember premium presentation

Asher and Ember may be offered as a premium signature collection to help fund development. Their premium value is presentation, identity, animation, cosmetics and companion interaction. Ownership must not grant Covenant rank, leadership authority, exclusive mission success, combat advantage, hidden-information detection or progression bypass. Purchase products, prices and receipt processing remain disabled until separately reviewed and approved.

## 10. Implementation sequence

1. Keep the rank catalog as the canonical ordered list.
2. Define a reviewed persistent profile schema and migration strategy.
3. Implement server-only rank read/write APIs with no client promotion endpoint.
4. Author and approve promotion criteria and evaluation records.
5. Implement server-local team assignment and narrow leadership permissions.
6. Add NPC fallback leadership and mission continuity.
7. Add moderated, optional TextChatService channel configuration.
8. Add cross-platform HUD/input adaptation and PC/mobile mixed-server tests.
9. Add persistence, exploit-resistance, reconnect and multi-client tests before release.

## 11. Explicit non-goals

- No purchase-based rank or authority.
- No server-local rank inflation or rank reset.
- No unrestricted player command over other users.
- No unmoderated custom chat.
- No requirement to use chat.
- No claim of Studio, PC, mobile or gamepad runtime verification until those tests have actually run.
