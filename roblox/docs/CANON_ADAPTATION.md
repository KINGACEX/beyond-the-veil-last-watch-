# BTV Roblox Canon Adaptation Register

**Authority:** Subordinate to the BTV creator, Master Development Handoff, Master Canon and specialized source-of-truth bibles.  
**Purpose:** Translate existing canon into Roblox implementation constraints without creating new canon.

## Approved facts carried into the Roblox edition

| Domain | Canon / approved fact | Roblox implementation boundary |
|---|---|---|
| Protagonist | Asher Vance, sole Chosen, age 18 | Asher remains the sole Chosen; multiplayer users are individual Covenant operatives, not alternate Ashers or additional Chosen |
| Role | Agent/Specialist, Watcher branch at start | Display role only where story context permits |
| Covenant | Hidden service/protection organisation | Do not present as government agency or Church replacement |
| Roblox rank | Recruit → Field Agent → Senior Agent → Elite Agent → Specialist → Senior Specialist → Principal Specialist → Team Leader → Senior Team Leader → Unit Leader → Field Commander → Senior Commander → Regional Commander → Senior General → High General | Rank is earned responsibility/trust, not spiritual worth; player rank is profile-owned and server leadership is separate |
| Branches | Guardians, Messengers, Watchers, Shepherds, Scouts, Keepers | Functional roles, not cosmetic-only factions |
| Ember | Intelligent animal companion and field partner | Not a weapon, omniscient guide or generic pet skin; premium presentation cannot grant gameplay advantage |
| Ember commands | Attack, Protect, Scout, Track, Retrieve, Hold, Regroup | Allowlist exact command labels; do not treat command availability as approved AI behaviour |
| Currencies | Aces; Covenant Credits | Separate data fields and presentation; exact values/prices remain open |
| Prayer | Meaningful, non-transactional | No mana, cooldown reward, guaranteed buff or purchase |
| Holy Spirit | Guidance, conviction, warnings, wisdom and discernment | Never a player-controlled combat/scanner resource |
| Armor of God | Six canonical elements; medieval-inspired modern/tactical direction | Do not convert into generic loot/stat tree without approved design |
| Church | Logos Rhema Temple is fictional in-game church | Keep church distinct from Covenant |
| HCI | Real-world inspiration/reference only | Do not use HCI real name, leaders, building likeness or imply endorsement in-game |
| Communion | First Sunday; Communion Set only in CommunionContextZone | No health, XP, stat, combat, currency or equipment buffs |
| Opening slice | Communion → alert → Scout Report/evidence → Ridgeview → response → final report | Preserve authored sequence; no generic combat-first rewrite |

## Multiplayer identity boundary

- Asher Vance remains the sole Chosen and established central protagonist.
- Each connected player is represented as their own individual Covenant operative, with an individual player identity and session state.
- Multiplayer cooperation occurs as Covenant operations alongside the established Asher storyline; it does not multiply the Chosen role.
- Do not assign every player the same Asher character identity.
- Do not spawn duplicate Asher protagonists in shared scenes. If Asher appears as a story character, players remain separate operatives.
- An Asher Signature Appearance is not an approved player identity system; any future cosmetic presentation requires a separate review.

## Non-negotiable theological and narrative constraints

1. God is ultimate authority and is not a playable combat character.
2. Christ is above the Covenant and above the Chosen. Asher is human and never a replacement for Christ.
3. The Holy Spirit is not a game resource or player-controlled ability.
4. Prayer is not a guaranteed transaction, spell, buff, or resource expenditure.
5. No Faith Coins, Prayer Points, Grace currency, Salvation items, divine-favour meter, holiness score, universal morality score, or conversion percentage.
6. Voluntary giving never purchases spiritual worth or guarantees blessings, loot, healing, XP or luck.
7. The Covenant and Church are distinct institutions.
8. Ordinary civilians and non-Covenant characters are not automatically enemies.
9. Human antagonists require specific motives; do not label people evil merely for being civilians, outsiders or non-believers.
10. Do not resolve unknown Veil metaphysics, Ember species/origin, or other open canon questions through implementation.

## Visual identity preservation

The Roblox edition must use the approved Asher/Ember/Covenant/UI references as its consistency baseline. Improve rendering quality, material response, lighting, readability, composition and mobile performance without casually changing:
- Asher's established appearance;
- Ember's established design and role;
- Covenant uniform/insignia identity;
- currency identity;
- HUD structure and information hierarchy;
- established Christian visual language;
- locked worldbuilding.

If a reference asset is unavailable in the Roblox workstream, mark the dependency as BLOCKED/UNKNOWN and request the source rather than inventing a replacement.

## Canon conflict procedure

When Roblox implementation requirements conflict with an existing BTV source:
1. Stop the affected implementation.
2. Record the exact source and conflict.
3. Apply the higher-authority creator decision/source.
4. Do not blend conflicting versions.
5. Ask for a creator decision only when the source hierarchy does not resolve it.

## Source references

- `docs/source-of-truth/canon/BTV_Master_Canon_v1.0.md`
- `docs/source-of-truth/canon/BTV_Canon_Reconciliation_and_Story_Veil_Decisions_v1.1.md`
- `docs/source-of-truth/characters/BTV_Character_Bible_v1.0.md`
- `docs/source-of-truth/faith/BTV_Faith_Prayer_Armor_of_God_Bible_v1.0.md`
- `docs/source-of-truth/church/BTV_Church_HCI_Service_Communion_Bible_v1.0.md`
- `docs/source-of-truth/missions/BTV_Mission_Progression_Economy_Bible_v1.0.md`
- `docs/source-of-truth/visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.1_Consistency_Lock.md`
