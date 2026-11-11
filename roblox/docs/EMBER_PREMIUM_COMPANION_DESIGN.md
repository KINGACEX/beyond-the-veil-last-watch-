# Ember Premium Companion Design — Roblox Edition

**Status:** Proposed product and design specification; requires creator approval before implementation or sale.  
**Canon authority:** Subordinate to the BTV Master Canon and Character Bible. This document does not redefine Ember.

## Design objective

Offer meaningful optional premium presentation and companion interactions around Ember while keeping the core companion role fair, accessible and canon-consistent.

## Product layers

### Free core Ember

- Ember's story identity and essential companion role remain available through the free story path.
- All seven approved commands are supported by the game design: Attack, Protect, Scout, Track, Retrieve, Hold and Regroup.
- Any ability needed for mission completion is available without Robux.
- Functional upgrades that affect success, detection, combat or traversal are earned through play and balanced for all players.

### Premium Ember Bond Pack

Potential one-time Game Pass benefits:
- additional non-combat bonding interactions;
- companion profile and collection presentation;
- alternate approved idle, rest and camp animations;
- cosmetic accessories that preserve Ember's recognizable design;
- optional photo poses and companion showcase presentation.

### Premium Ability Style Pack

Potential separate cosmetic pass:
- alternate Scout and Track animation presentation;
- alternate Protect stance and command response animation;
- alternate Retrieve and Regroup presentation;
- optional non-canonical visual trails or paw effects;
- optional sound/voice presentation variants, subject to accessibility and device-performance review.

These are **ability styles**, not stronger abilities. They must not change detection radius, movement speed, damage, health, stealth, success chance, item quality, mission outcomes or competitive balance.

## Ability progression matrix

| Command | Core functional access | Premium option |
|---|---|---|
| Attack | Free; balanced and context-limited | Animation/stance style only |
| Protect | Free; mission-required protection remains accessible | Guard stance/response animation |
| Scout | Free; essential evidence remains discoverable without purchase | Scout animation and visual trail style |
| Track | Free; no paid-only clue or evidence | Tracking presentation style; no extra range or accuracy |
| Retrieve | Free for required objectives | Retrieve animation/accessory style |
| Hold | Free | Alternate idle/hold animation |
| Regroup | Free | Recall animation and cosmetic effects |

## Multiplayer and technical requirements

1. Server owns Ember's functional state and validates command requests.
2. Client may request a command but cannot award items, set companion stats or claim purchase ownership.
3. Game Pass ownership is verified server-side before premium cosmetic/interaction entitlements are granted.
4. Cosmetic entitlements must persist reliably and be recoverable after rejoin.
5. All players see consistent, fair functional behaviour even if they do not own premium cosmetics.
6. Premium effects must be performance-budgeted for low-end Android devices and must have reduced-effects settings where appropriate.
7. Product IDs remain unset until actual products are created and reviewed.

## Visual and canon constraints

- Preserve Ember's established proportions, silhouette, colour identity, temperament and field-partner role.
- Accessories must not obscure recognition, interfere with animation or imply a different species/origin.
- No weaponized transformation or paid evolution tier.
- No spiritual status, favour, prayer outcome or sacred authority attached to ownership.
- New abilities, species lore, origin explanations or major visual changes require separate canon approval.

## Release gates

- Free Ember role and required mission path implemented first.
- All seven commands tested in multiplayer, with server validation and abuse/throttle checks.
- Companion state and ownership persistence tested across rejoin.
- Premium effects tested on low-end mobile devices.
- Clear product descriptions and purchase recovery/support path.
- Creator approval before any Game Pass is created, priced or published.

## Recommendation

Start with **one Ember Companion Bond cosmetic pass** after the free companion is complete. Do not launch functional ability sales in the first release. Add an Ability Style Pack only after the core companion system is stable and the cosmetic-only boundary is verified.
