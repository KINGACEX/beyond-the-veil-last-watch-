# Curiosity Archive & Sustainable Revenue Recommendation

**Status:** Archive source implementation added; Studio verification pending. Monetization remains unimplemented and unauthorized.
**Scope:** Roblox Edition only, under `roblox/`.
**Canon:** This optional exploration space is not a story location and does not add canon, mission evidence, Scripture, sacred artifacts or theology.

## 1. Recommended Archive design

The Curiosity Archive is a small optional destination in Ridgeview.

- Three free Curio Marks are hidden beside existing landscape landmarks.
- Finding all three unlocks the room for that player only.
- Discovery progress is session-only until persistence is reviewed.
- The room contains harmless developer Easter eggs and cosmetic display plinths.
- A weekly display rotates by UTC week. Rotation changes presentation only; old displays do not expire and there are no timed rewards.
- The Archive grants no Aces, Covenant Credits, XP, evidence, clues, mission access, companion advantages or combat/detection benefits.
- No Robux purchase is required to find marks or enter.

The feature is intentionally not an AFK room, idle reward loop, paid countdown or daily login streak.

## 2. Revenue recommendation — ranked

### 1. Creator Rewards (best low-maintenance opportunity after public release)

Roblox's current Creator Rewards program includes Daily Engagement Rewards and Audience Expansion Rewards. Official documentation currently describes a 5 Robux daily reward when a qualifying Active Spender plays an experience for at least 10 minutes, subject to the first-three-experiences condition. Audience Expansion has separate eligibility and sustained audience requirements. These are conditional platform rewards, not guaranteed income.

Design implication: make the Archive and core game genuinely enjoyable, but never ask players to idle, keep a device running, create alternate accounts, or play solely to trigger rewards. Do not optimize for empty playtime.

Official reference: https://create.roblox.com/docs/creator-rewards

### 2. Optional fixed-price cosmetic Supporter Collection (later)

After the free game is complete and stable, consider one clearly described, one-time Game Pass containing only:
- an optional profile frame;
- a cosmetic nameplate;
- a decorative Archive display skin;
- a non-gameplay emote or photo pose.

All players retain the same Archive access, secrets, story, companion functionality, evidence and mission outcomes. Do not add product IDs, prices, purchase prompts or entitlement code until separately approved and the complete free experience is tested.

Official references:
- https://create.roblox.com/docs/production/monetization/passes
- https://create.roblox.com/docs/production/monetization

### 3. Optional private servers (later)

Could support friend groups and private exploration if Roblox configuration and the experience's moderation needs make this suitable. Public servers and all core content remain available. Do not make private servers required for secrets or progression.

### 4. UGC cosmetics (much later)

Potentially consider original BTV-themed avatar cosmetics only after the project has a stable identity, approved designs and eligibility to publish them. This is a separate production stream, not a foundation dependency.

### Not recommended for BTV

- Paid random eggs, crates, spins, loot boxes or mystery rewards.
- AFK/idle income rooms, forced long sessions or artificial engagement loops.
- Daily streaks, expiring rewards and manipulative countdowns.
- Paid evidence, mission access, companion strength, detection or progression.
- Recurring subscriptions before there is a reliable monthly content-delivery commitment.
- Selling Aces or Covenant Credits in the initial release.

Roblox requires disclosures and may impose per-user restrictions for paid random items. BTV should avoid that entire category rather than add complexity and risk. Official reference: https://create.roblox.com/docs/production/monetization/paid-random-items

## 3. Financial and age-appropriate boundaries

Creator Rewards and Robux sales are not guaranteed cash income. Robux earnings are subject to Roblox's current eligibility, platform terms and review. Any real-world financial administration, identity or payout matters must follow current Roblox rules with a parent or legal guardian where required. Never put personal, identity, tax or payment information in this repository or chat.

No cash forecast is made. No DevEx action, purchase, product creation, pricing, publishing or public release is authorized by this plan.

## 4. Release gates

1. Complete the free opening loop and test it in Roblox Studio.
2. Test Archive access isolation with at least two clients.
3. Verify mobile layout and performance.
4. Validate age-appropriate privacy, moderation and safety.
5. Review exact cosmetic deliverables and support obligations.
6. Obtain explicit creator approval before any monetization implementation or product configuration.

## 5. Current implementation status

- ArchiveService: source added; headless tests added.
- CuriosityArchive world builder: source added; not Studio-tested.
- CuriosityArchive HUD: source added; not Android-tested.
- Weekly display: deterministic UTC-week presentation; no expiring rewards.
- Monetization: no purchase code, product IDs, prices, purchase prompts or entitlement grants.
- Revenue: no earnings or payout claimed.
