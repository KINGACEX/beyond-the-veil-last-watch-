# BTV Roblox Multiplayer Chosen Adaptation

**Status:** APPROVED Roblox-edition direction.  
**Scope:** Roblox multiplayer only. The original main-game continuity and Godot project remain unchanged.  
**Authority:** Subordinate to the creator and BTV source-of-truth canon.

## 1. Player identity and Covenant membership

Every Roblox player creates or uses their own player character. In the Roblox adaptation, every player character is one of the Chosen and is a member of the Covenant.

Chosen status is a narrative role, not a measurable spiritual score, holiness rating, purchasable divine status, competitive leaderboard category, or indication that one player is spiritually superior to another. Players remain human and fallible. Christ remains above the Covenant and every Chosen.

Players belong to the Covenant and participate in its missions, training, teams, evaluations and rank structure.

## 2. Covenant hierarchy and progression

The approved Roblox rank ladder has fifteen ranks:

1. Recruit
2. Field Agent
3. Senior Agent
4. Elite Agent
5. Specialist
6. Senior Specialist
7. Principal Specialist
8. Team Leader
9. Senior Team Leader
10. Unit Leader
11. Field Commander
12. Senior Commander
13. Regional Commander
14. Senior General
15. High General

Ranks represent earned responsibility, experience, trust and leadership duties. They are not a measure of holiness, divine favour or personal worth. Ranks cannot be purchased with Robux, Aces or Covenant Credits.

The player's earned rank belongs to their player profile and must remain consistent when they move between servers. The active server forms its operational hierarchy from the players currently present. A higher-ranked player may be a teammate, superior or subordinate to another player according to rank and current team assignment.

Server leadership and team assignment are distinct from persistent rank. Joining a different server must not randomly change a player's rank. NPC Covenant leaders provide mission continuity, training and supervision when suitable higher-ranking players are absent.

Promotion criteria, evaluations, rank persistence schema and leadership permissions require separate implementation review. Until persistence is implemented, prototype rank data is session-only and must not be described as permanently saved.

## 3. Covenant NPCs and ordinary NPCs

The world contains both Covenant NPCs and ordinary civilian/world NPCs. Covenant NPCs may serve as instructors, mission contacts, specialists, team leaders, commanders and senior leadership. Ordinary NPCs provide a living world and are not automatically enemies.

NPCs supplement the multiplayer hierarchy; they do not erase the player's earned rank or make the Covenant a player-only organisation. NPC authority, mission availability and team command rules must be server-authoritative.

## 4. Optional in-game communication

In-game chat is optional. Use Roblox's supported TextChatService and its moderation, filtering and privacy controls. Do not create an unfiltered custom text channel.

Potential channels, subject to platform configuration and age-appropriate safety:
- Proximity chat for nearby players.
- Team chat for assigned teams.
- Covenant/server chat for eligible Covenant members.
- Leadership/command chat restricted by server-validated role permissions.
- Direct messages only if supported by Roblox privacy and safety settings.

Chat must never be required to complete the main gameplay loop. Provide non-chat alternatives such as mission markers, team pings and preset communication where feasible. Do not expose a player's rank as permission to harass, threaten or control another player.

## 5. Asher Vance and Ember premium funding

Asher Vance remains the central protagonist of the original main game. Ember remains his established companion.

For Roblox funding, the approved direction is a premium **Asher & Ember Signature Collection**. It may provide an exceptional Asher character presentation/appearance package and premium Ember companion presentation, subject to approved final asset references and Roblox implementation review.

This premium offer must not:
- Change the original main-game canon or imply multiple canonical Ashers.
- Make every Roblox player literally become the unique Asher Vance in the main-game continuity.
- Grant rank, command authority, exclusive mission completion, damage, health, speed, detection, hidden evidence, reward multipliers or progression shortcuts.
- Make core Asher/Ember quality deliberately inferior to pressure purchases.
- Replace required free companion functionality.

Premium value should come from exceptional art direction, model quality, animation, sound, visual presentation, customisation and personality interactions. No price, product ID, purchase prompt, entitlement grant or asset upload is approved by this document.

## 6. Main-game continuity boundary

The original main game retains Asher Vance as its central protagonist. The Roblox multiplayer adaptation allows each player to be their own Chosen Covenant member. This is an edition-specific multiplayer structure, not a rewrite of the original story.

Do not edit Godot source or main-game canon as part of Roblox implementation.

## 7. Server architecture requirements

Keep these concepts separate:
- Player identity and avatar appearance.
- Chosen status in the Roblox adaptation.
- Persistent Covenant rank.
- Active server team assignment.
- Leadership permissions for the current server.
- NPC rank and authority.
- Chat-channel eligibility.
- Companion ownership and equipped companion.
- Premium cosmetic entitlement.

The server validates promotions, rank changes, team assignment, leadership permissions, companion ownership and premium entitlements. Clients may display state but cannot authoritatively grant it.

## 8. Approval boundaries and unresolved implementation

Approved: player-created Chosen identities within the Roblox Covenant, the fifteen-rank ladder, dynamic server hierarchy, Covenant NPCs and ordinary NPCs, optional Roblox-moderated chat, and the Asher/Ember premium-funding direction.

Not yet implemented or verified: persistent player profiles, promotion/evaluation workflow, team assignment and leadership permissions, NPC rank behaviours, chat channels, premium product IDs, prices, receipts, final Asher/Ember assets, Studio runtime, multi-client testing and Android device profiling.

No Godot source, public release, paid asset generation or purchase setup is authorised by this adaptation document.
