# Curiosity Archive & Sustainable Revenue Strategy

**Status:** Archive source implementation added; Studio verification pending. Monetization strategy documented only; no purchase implementation authorized.
**Scope:** Roblox Edition only, under `roblox/`.
**Canon:** The Curiosity Archive is an optional exploration space, not a story location. It adds no canon, mission evidence, Scripture, sacred artifacts or theology.

## 1. Curiosity Archive

The Curiosity Archive is a small optional destination in Ridgeview.

- Three free Curio Marks are hidden beside existing landscape landmarks.
- Finding all three unlocks the room for that player only.
- Discovery progress is session-only until persistence is reviewed.
- The room contains harmless developer Easter eggs and cosmetic display plinths.
- A weekly display rotates by UTC week. Rotation changes presentation only; no reward expires and there are no timed rewards.
- The Archive grants no Aces, Covenant Credits, XP, evidence, clues, mission access, companion advantages or combat/detection benefits.
- No Robux purchase is required to find marks or enter.

It is not an AFK room, idle reward loop, paid countdown or daily login streak.

## 2. Revenue strategy — recommended order

### 1. Creator Rewards — primary low-maintenance route after release

Roblox's current Creator Rewards program includes Daily Engagement Rewards and Audience Expansion Rewards. Official documentation describes 5 Robux per day when a qualifying Active Spender plays an experience for at least 10 minutes, subject to the first-three-experiences condition. Audience Expansion has separate eligibility and sustained-audience requirements. These are conditional platform rewards, not guaranteed income.

**BTV implication:** prioritize a genuinely enjoyable first session, a polished opening mission, stable performance, clear onboarding, meaningful exploration and regular quality updates. Do not ask players to idle, keep devices running, create alternate accounts or play solely to trigger rewards. Never optimize for empty playtime.

Official reference: https://create.roblox.com/docs/creator-rewards

### 2. Supporter Collection — first direct purchase

After the free game is complete, stable and tested, offer one optional, one-time Game Pass with a clearly displayed bundle:

- distinctive profile frame;
- premium nameplate treatment;
- decorative Archive room theme;
- one or more non-gameplay emotes/photo poses;
- optional cosmetic companion accessory that does not alter abilities, detection, speed, health or mission outcomes.

The collection should feel like a polished way to support the project and personalize a player's identity. It must not contain exclusive story, secrets, Curio Marks, mission access, or any competitive advantage.

**Presentation standard:** show a 3D preview, list every included item, show the exact price before purchase, explain that the purchase is optional, and let players close the preview without repeated prompts. Do not use fake discounts, countdowns, guilt messaging, confusing currency conversion or purchase prompts on first launch.

Official reference: https://create.roblox.com/docs/production/monetization/passes

### 3. Companion Style Collections — second direct purchase

The approved animal roster is Ember, Eagle, Fox, Bear, Owl, Leopard, Horse and Falcon. The monetization rule is **style, not strength**.

- Keep a complete, useful free companion selection.
- Paid variants may offer distinct fur/feather palettes, accessory sets, idle animations, call sounds and companion introduction effects.
- Any signature companion ability must have equivalent gameplay utility available to free players; paid ownership must not increase the effect.
- Do not sell stronger, faster, tougher, more perceptive or mission-exclusive companions.
- Show the complete companion model and animation preview before purchase.
- Avoid random eggs, mystery crates and paid spins. Sell known items with known contents.

This makes premium companions appealing through craft, personality and visual identity without creating a paid combat tier.

### 4. Individual cosmetic items and themed bundles

Once there is enough high-quality cosmetic content, consider a small catalogue of known, permanent items:
- outfit colourways and visual trims;
- companion collars, harnesses or decorative accessories;
- player emotes and photo poses;
- Archive display themes;
- non-functional vehicle/room decoration if those systems are later approved.

Use bundles when the items share a coherent theme. The bundle must list its contents and offer meaningful value without making the individual items artificially unavailable. Avoid flooding the shop with low-quality items.

### 5. Private servers — optional social feature

Consider private servers for friend groups and organized community sessions only if configuration and moderation needs make them suitable. Public servers and all core content remain available. Never put secrets, story or progression behind private-server access.

### 6. Original avatar cosmetics — later expansion

Consider original BTV-themed avatar cosmetics only after the experience has a stable identity, approved designs and eligibility to publish them. Treat this as a separate production stream, not a foundation dependency.

## 3. Store design that earns trust

The in-world store should be a **showroom**, not a pressure funnel.

1. Put it in a clearly marked optional location, not in the first mission path.
2. Let players inspect and rotate a full-size 3D preview.
3. Display exact contents, ownership status and price before any purchase confirmation.
4. Label cosmetics as cosmetic and describe any gameplay-equivalent ability policy.
5. Make the free catalogue visible too; do not disguise free options.
6. Keep purchase prompts user-initiated. No repeated pop-ups after dismissal.
7. Use clear categories: Companions, Companion Styles, Player Cosmetics, Archive Themes and Supporter Bundles.
8. Provide a simple owned-items view and reliable entitlement restoration.
9. Track aggregate store views, preview-to-purchase conversion, refund/complaint signals and retention; use the data to improve item quality, not to pressure individual players.
10. Use Roblox's current managed pricing and regional pricing controls where available; do not guess a permanent price before testing the actual audience and platform settings.

## 4. What BTV should not monetize

- Paid evidence, clues, story chapters, mission access or progression.
- Companion strength, speed, health, detection, combat output or mission outcomes.
- Aces or Covenant Credits in the initial release.
- Paid random eggs, crates, spins, loot boxes or mystery rewards.
- AFK/idle income rooms, forced long sessions or artificial engagement loops.
- Daily streaks, expiring rewards, fake scarcity or manipulative countdowns.
- Recurring subscriptions before there is a reliable monthly content-delivery commitment.
- Pay-to-skip mechanics that undermine the intended challenge or story pacing.

Roblox has specific rules for paid random items, including odds disclosures and user restrictions. BTV should avoid that category entirely rather than add complexity and risk. Official reference: https://create.roblox.com/docs/production/monetization/paid-random-items

## 5. Revenue model and prioritization

**Near term:** build the complete free experience, improve onboarding and performance, and create a memorable first 10–20 minutes. Revenue cannot be optimized responsibly before players have a good reason to return.

**First monetization release:** one Supporter Collection pass with a small number of polished cosmetics.

**Second monetization release:** curated, direct-purchase companion style packs and themed cosmetic bundles.

**Later:** private servers and original avatar cosmetics if there is real demand and the operational workload is manageable.

Do not forecast earnings from player counts alone. Revenue depends on actual audience, conversion, pricing, regional conditions, platform rules, refunds and eligibility. Treat every estimate as a scenario, not a promise.

## 6. Financial, age and platform boundaries

Robux sales and Creator Rewards are not guaranteed cash income. Robux earnings and DevEx are subject to current Roblox eligibility, terms, identity, tax and other requirements. Any real-world financial administration, identity or payout matters must follow Roblox rules with a parent or legal guardian where required. Never put personal, identity, tax or payment information in this repository or chat.

No cash forecast is made. No DevEx action, purchase, product creation, pricing, publishing or public release is authorized by this strategy.

Official references:
- https://create.roblox.com/docs/monetize
- https://create.roblox.com/docs/creator-rewards
- https://create.roblox.com/docs/production/monetization/passes
- https://create.roblox.com/docs/production/monetization

## 7. Release gates

1. Complete the free opening loop and test it in Roblox Studio.
2. Test Archive access isolation with at least two clients.
3. Verify mobile layout, performance and accessibility.
4. Validate age-appropriate privacy, moderation and safety.
5. Test the free companion roster and ensure ability parity before any premium cosmetic variant is offered.
6. Review every cosmetic for quality, clear ownership and accurate preview.
7. Obtain explicit creator approval before any monetization implementation or product configuration.

## 8. Current implementation status

- ArchiveService: source added; headless tests added.
- CuriosityArchive world builder: source added; not Studio-tested.
- CuriosityArchive HUD: source added; not Android-tested.
- Weekly display: deterministic UTC-week presentation; no expiring rewards.
- Monetization: no purchase code, product IDs, prices, purchase prompts or entitlement grants.
- Revenue: no earnings or payout claimed.
