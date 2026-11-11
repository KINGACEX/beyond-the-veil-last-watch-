# Companion Selection & Premium Ability UX — Roblox Edition

**Status:** Design proposal based on creator clarification; not yet canon-locked.  
**Scope:** Roblox multiplayer companion roster, player choice, companion-specific functional abilities and optional premium convenience features.  
**Canon authority:** Subordinate to BTV Master Canon, Character Bible and existing visual/UI bibles. This proposal does not change the separate Godot game's protagonist or canon.

## 1. Product direction

Each player may select one active companion from an approved roster. Ember is one of the selectable companions and receives a premium product offering. Other companions may have their own distinct premium convenience abilities and optional cosmetic packs.

The design goal is:

- meaningful choice between companions;
- distinct identities, roles and command behaviours;
- a complete, high-quality free experience;
- optional premium features that reduce interface friction and make routine interactions faster;
- no paywall on essential mission capability or story content.

**Important:** The roster shown in this proposal is a system architecture, not approval to add new animal species, origins, personalities or lore. Each companion must pass canon and visual review before production.

## 2. Player companion selection

- Each player selects one active companion from the companions they have legitimately unlocked.
- The game communicates each companion's role, strengths, limitations and command style before selection.
- Players can change their active companion at approved safe locations or menu states; switching rules must not be exploitable during encounters.
- A player should not be forced to buy Robux to obtain a companion required by a mission.
- The game must support missions that remain completable with the free starter companion.
- Multiplayer servers must handle players with different companion selections without breaking mission logic or creating unfair dependencies.
- Companion ownership, unlocks and active selection are stored server-side and persist across sessions.

## 3. Companion roster framework

Use role archetypes until the creator approves the actual roster and canon:

| Slot | Intended gameplay identity | Free functional baseline |
|---|---|---|
| Ember | Tracking, protection and versatile field support | Core commands and all mission-required functions |
| Recon archetype | Environmental reconnaissance and observation | Required clues remain discoverable through normal play |
| Swift archetype | Agility-oriented assistance and quick interaction | No exclusive route or objective access |
| Guardian archetype | Defensive positioning and protective support | Required protection remains possible without premium |

These labels are placeholders, not final companion names or species. Avoid adding an eagle, fox, bear or other specific species to canon without approval.

## 4. Free versus premium ability model

Every companion has a **free functional kit** that is complete enough to participate in the full intended game. Premium offers **convenience abilities** that improve the command UX, reduce repetitive inputs or make non-critical routines easier.

### Free functional abilities

- Include all commands needed for missions and the companion's advertised role.
- Remain responsive, reliable and understandable.
- Must not be deliberately slowed, hidden, degraded or made frustrating to sell premium.
- Provide equivalent mission outcomes and access to evidence/objectives.
- Functional progression, if used, must have a fair gameplay-earned route.

### Premium convenience abilities

Examples of acceptable premium features:

- **Quick Command:** invoke an already-unlocked command directly from a compact shortcut instead of opening multiple menu layers.
- **Command Presets:** save a small set of player-configured command sequences for safe, non-combat routines.
- **Contextual Prompt:** show the relevant available command when near an eligible interaction, reducing menu navigation.
- **Routine Recall:** offer a one-tap regroup/return command in appropriate safe contexts.
- **Companion Status Panel:** expanded, clearer status and task feedback.
- **Non-combat Automation:** repeat harmless follow/hold/return routines where the player can interrupt them immediately.
- **Ability Presentation:** alternate command animations, audio cues and visual styles.

These features improve convenience and perceived responsiveness, not the companion's underlying physical performance or chance of success.

## 5. Companion-specific premium examples

| Companion | Free core abilities | Optional premium convenience |
|---|---|---|
| Ember | Attack, Protect, Scout, Track, Retrieve, Hold, Regroup | Quick command wheel, saved field presets, contextual Track/Scout prompt, clearer task/status feedback |
| Recon archetype | Free observation and reconnaissance functions | Custom scan/observation interface preset, quick waypoint command, saved safe-area patrol routine |
| Swift archetype | Free movement support and ordinary interaction | Quick follow/recall controls, saved traversal command layout, reduced menu navigation |
| Guardian archetype | Free protection and defensive support | Quick protect-position shortcut, saved formation preset, clearer ally/companion status panel |

The exact abilities and names must be designed after the companion roster is approved. Do not implement these examples as new lore or final skill definitions automatically.

## 6. Fairness and quality parity rules

Premium convenience must never:

- increase damage, health, armour, speed, jump, attack frequency or resistance;
- extend detection radius, reveal additional clues, improve tracking accuracy or expose hidden evidence unavailable to free players;
- improve loot quality, reward amounts, XP, currency earnings or mission completion rates;
- shorten combat cooldowns or create an advantage in competitive encounters;
- auto-complete objectives, bypass puzzles, skip investigations or guarantee success;
- grant access to a mission, region or story outcome that is otherwise unavailable;
- make the free command interface intentionally cumbersome or unreliable.

The intended distinction is **fewer interface steps**, not **better gameplay results**. A free player and a premium player who issue the same command in the same circumstances should receive the same functional result.

If a convenience feature would materially change multiplayer balance, remove it from premium or make it available to everyone.

## 7. Ember-specific requirements

Ember remains the established BTV companion and field partner. Preserve the seven approved commands:

1. Attack
2. Protect
3. Scout
4. Track
5. Retrieve
6. Hold
7. Regroup

Premium Ember convenience can include:
- a configurable quick-command wheel;
- saved safe-context command presets;
- contextual Track/Scout command prompts;
- one-tap Regroup in approved contexts;
- expanded companion task/status feedback;
- optional animation and accessory collections.

All seven functional commands and any command required for mission progression remain available without Robux. Premium does not improve Ember's detection, damage, movement, survivability, retrieval success or mission outcomes.

## 8. Monetization packaging

Proposed one-time products, to be evaluated after the free roster is complete:

- **Ember Companion Bond Pass:** optional companion presentation, bonding interactions and cosmetic collection.
- **Ember Field Convenience Pass:** quick-command layouts, saved non-combat presets and contextual UX shortcuts.
- **Other Companion Convenience Passes:** companion-specific UX features, sold individually or in a transparent bundle.
- **Companion Cosmetic Collections:** approved accessories and animation/audio presentation variants.

Do not create a separate paid product for every tiny button or routine. Bundle coherent, useful convenience features at a transparent price. Avoid randomized rewards, loot boxes, artificial scarcity and pressure prompts.

Product IDs and prices remain unset. Do not create, price or publish products without explicit creator approval.

## 9. UX and mobile requirements

- Touch-first command wheel with large, readable targets.
- A simple free command path that is never buried behind premium UI.
- Premium shortcuts must be discoverable but not intrusive.
- One-handed operation should be considered for Android.
- Keep command feedback clear: requested, accepted, in progress, completed, unavailable.
- Support accessibility settings, reduced effects and readable contrast.
- Avoid requiring rapid repeated tapping.
- Companion behaviour and command results must remain consistent across devices.

## 10. Multiplayer and implementation architecture

- Server owns companion selection, ability availability, functional state and purchase entitlements.
- Client sends command requests; server validates player ownership, companion state, command eligibility, context and rate limits.
- Premium UI shortcuts call the same validated command pathway as the free UI.
- Premium entitlements change available interface options only; they do not modify gameplay stats.
- Persist companion selection and owned convenience entitlements reliably.
- Prevent duplicate command execution and replay abuse.
- Test simultaneous companion commands and differing companion selections in multiplayer.
- Keep product IDs in server configuration and unset until approved products exist.

## 11. Release sequence

1. Approve the companion roster and canon boundaries.
2. Build one free companion end-to-end, starting with Ember.
3. Implement and test the complete free command system.
4. Add companion selection and server-side persistence.
5. Test co-op missions with different companion choices.
6. Measure mobile usability and command friction.
7. Add optional premium UX shortcuts only where they solve real friction.
8. Test free and premium players side by side to verify equivalent mission outcomes.
9. Obtain creator approval before creating or publishing any paid product.

## 12. Acceptance criteria

- A non-paying player can complete the full intended core experience.
- Each released companion has a complete free functional baseline.
- Premium features reduce menu steps or improve clarity without changing game-world outcomes.
- The same command in the same context produces the same functional result for free and premium players.
- No paid companion feature reveals exclusive evidence or bypasses mission design.
- Mobile controls remain usable without premium.
- All entitlements are verified and applied server-side.
- The Godot BTV project and its canon remain separate and unchanged.
