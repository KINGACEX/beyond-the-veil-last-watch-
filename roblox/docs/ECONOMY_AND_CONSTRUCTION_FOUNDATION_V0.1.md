# Roblox Economic Foundation & Construction System — v0.1

**Status:** Approved direction; staged design specification. No economy or construction gameplay is enabled by this document.
**Scope:** Roblox Edition only. No Godot or main-game canon change.
**Priority:** Economic foundation first; property and construction second; other professions later.
**Platform:** PC and mobile are equal targets. Gamepad support remains unclaimed until Studio testing.

## 1. Product intent

Create a persistent, player-driven civilian economy that gives Chosen players meaningful activities outside missions: earning Aces, purchasing supplies, operating businesses, commissioning property and building places that become part of the shared world.

The economy must support long-term social play without making Covenant progression dependent on wealth. A player may pursue business or construction while remaining a Covenant Chosen. Civilian careers do not replace Covenant identity, rank or mission responsibilities.

### Design principles

1. Earned value before monetization: establish a complete, enjoyable free economy before purchases.
2. Server authority: clients request transactions; the server validates and commits them.
3. Persistence before scale: no public trading, contracts or property ownership until durable persistence is proven.
4. No pay-to-win: purchases do not grant rank, authority, combat superiority, mission success, evidence or progression bypass.
5. Understandable systems: clear prices, ownership, contract scope, deadlines and dispute outcomes.
6. Cross-platform parity: PC and mobile have the same economic rules and access.
7. Canon protection: no paid spiritual status, prayer, Communion, Scripture, divine favour or sacred authority.
8. Performance budgets: building, inventory and NPC systems must be viable on supported mobile devices.

## 2. Currency and value boundaries

### Aces
- Primary currency for civilian purchases, services, business transactions, construction materials and player contracts.
- Earned from approved gameplay, services and completed contracts.
- Balances are server-owned and persist only after the profile persistence release gate passes.

### Covenant Credits
- Remain a separate Covenant-related currency.
- Do not use Covenant Credits for civilian property, merchant stock or ordinary construction.
- Do not convert between Aces and Covenant Credits without a separate design review.

### Robux
- Reserved for optional, clearly described developer products such as cosmetics, visual themes and approved presentation items.
- Do not sell Aces or Covenant Credits in the initial monetization release.
- No product IDs, prices, purchase prompts, receipt handlers or entitlements are authorized here.

Aces are player/gameplay value; Robux is platform monetization. A successful player economy may improve retention and create opportunities for optional cosmetic sales, but it does not guarantee developer revenue.

## 3. Phase 0 — persistence and transaction readiness

The repository contains a version-1 pure player profile schema, pure lease and profile-record policies, a fake profile store for callback replay and ambiguous-result tests, and a session-only PlayerStateService and CurrencyService.

The policy/test foundations are not a live DataStore adapter. Current balances, inventory, ownership and companion state are still session-only.

Before any economy feature depends on persistence, implement and validate:
1. A server-only DataStore adapter using atomic UpdateAsync transformations.
2. Profile load/acquire/save/release lifecycle with session leases.
3. Bounded retry/backoff for classified transient failures only.
4. Durable idempotency for every economic operation.
5. Recovery for ambiguous write outcomes and player departure.
6. A migration strategy before expanding the profile schema.
7. Fake-adapter tests for concurrency, retries, duplicate operations, failure recovery and corrupt data.
8. Roblox Studio multi-server tests with at least two clients and server instances.
9. A read-only failure mode: if a profile cannot be acquired, do not create a writable fresh profile or allow economic actions.

Do not connect persistence to live joins until these gates pass.

## 4. Phase 1 — minimum viable economy

Build in this order.

### 4.1 Item catalogue

Create a server-owned, versioned item catalogue. Each definition specifies a stable item ID, display name, description, category, stackability, maximum stack, tradeability, merchant availability, reference value and whether it is cosmetic, utility, building material or quest-bound.

Rules:
- Never trust item names, prices, quantities or item metadata sent by clients.
- Quest evidence, story-critical items, Scripture-related items, Communion items and canon-sensitive artifacts are non-tradeable and never sold.
- Do not add weapons, consumables or combat balance items to civilian shops without a separate gameplay review.
- Reject unknown IDs, negative quantities, fractional quantities and over-limit stacks.

### 4.2 Player inventory

Inventory is a server-owned profile component. Start with a simple bounded slot/stack model; add weight only if playtesting demonstrates a need.

Required operations:
- add/remove item with validated reason and operation ID;
- query a sanitized inventory snapshot;
- split/merge stacks server-side;
- reserve items for a contract so they cannot be sold twice;
- reconcile inventory after interrupted operations.

The client may display inventory and request actions. It may never set its own inventory contents or balances.

### 4.3 NPC merchant vertical slice

Start with one or two curated NPC merchants, not a full player marketplace.

Player loop:
1. Open a merchant catalogue.
2. Inspect item details and exact Aces price.
3. Submit a purchase request.
4. Server validates item, quantity, stock policy, price, profile state and rate limit.
5. Server applies one idempotent transaction that debits Aces and grants the item.
6. Server returns the confirmed result and updated snapshot.

Selling reverses the flow: validate item ownership and tradeability, remove the item, credit the configured sale value and record the operation.

Initial merchant stock should be deterministic and curated. Avoid dynamic global stock until basic transactions are stable. Never display success before the server confirms the committed operation.

### 4.4 Transaction ledger

Every economic mutation needs a durable, unique operation ID and an auditable record with only necessary data:
- operation ID;
- transaction type;
- player account IDs involved;
- item IDs and quantities where relevant;
- currency delta;
- server timestamp;
- outcome/state;
- source context (merchant, contract, reward, refund);
- schema/version information needed for recovery.

Do not store chat transcripts or unnecessary personal information in the ledger.

**Cross-account transaction warning:** Roblox DataStores do not provide a general multi-key ACID transaction. Do not implement player-to-player payments as a naive debit from one profile followed by an unprotected credit to another. Use a durable transaction coordinator and escrow/reservation state machine with idempotent per-account steps and reconciliation. If recovery from every interruption point cannot be proven, keep direct transfers disabled.

### 4.5 Economy controls

- Server-configured reward and price tables only.
- Per-player and per-action rate limits.
- Positive integer currency values; reject NaN, infinity, negative and fractional amounts.
- Maximum balance and transaction bounds to prevent overflow and abuse.
- Duplicate event and receipt rejection.
- Transaction logs and restricted audit tools.
- No client-provided award amount or arbitrary transaction reason.
- No AFK income, idle rooms, forced login streaks or empty-playtime rewards.

## 5. Phase 2 — property and construction

Construction is the first major player-to-player service economy and should launch only after the ledger and contract system are proven.

### 5.1 Property ownership

Each property definition should include a stable property ID and region, parcel bounds and allowed build volume, owner user ID, property revision, permitted build templates, object/part and memory budgets, access policy and current construction state.

Ownership changes must be server-authoritative, durable and idempotent. Do not allow two players to claim the same parcel. Do not sell story-critical or mission-critical locations as private property.

Start with a small number of curated parcels and bounded residential plots. Do not begin with unrestricted land claiming or an infinite world-building system.

### 5.2 Build system

Use a curated, server-approved modular kit:
- foundation pieces;
- walls, doors and windows;
- roof modules;
- stairs and structural pieces;
- lighting and furnishing;
- exterior landscaping.

Build placement must be validated server-side for parcel ownership and collaborator permissions, allowed asset IDs, grid/snap and rotation rules, parcel boundaries and collision, object/part count and size limits, overlap rules, asset cost and material requirements, and rate limits.

Do not allow arbitrary client-created Instances, scripts, uploaded meshes or unbounded physics objects. Keep the first version template-based and visually flexible rather than unrestricted.

### 5.3 Architect and builder workflow

1. Property owner posts a commission with parcel, budget, requested style, required rooms/features and deadline.
2. Architect submits a blueprint preview and fixed quotation or milestone quote.
3. Owner accepts one proposal.
4. Contract reserves the agreed Aces budget in escrow.
5. Architect may hire builders and order materials through smaller linked contracts.
6. Construction is delivered as approved modules within the parcel.
7. Owner inspects against the agreed scope.
8. Payment is released according to contract milestones.
9. Contract closes with a receipt and reputation outcome.

Architects design and plan; builders place approved modules; suppliers provide materials. A player may hold multiple roles, but the contract must state responsibility for each deliverable.

### 5.4 Contract state machine

Suggested states:

Draft -> Offered -> Accepted -> Funded -> InProgress -> Submitted -> Inspection -> Completed

Terminal or recovery states:
- Cancelled
- Expired
- Disputed
- RefundPending
- Refunded
- FailedRecovery

Every transition is server-authoritative, validated against the previous state and idempotent. Never permit a client to jump directly to Completed or release escrow.

Before acceptance, both parties see deliverables and exclusions, total budget and payment milestones, expected completion time, cancellation/refund rules, inspection criteria, dispute window and resolution method.

Keep initial contracts simple: one client, one provider, one parcel, bounded deliverables. Multi-team construction is later.

### 5.5 Inspection and dispute protection

For the first release, use objective checks wherever possible: required structure modules placed, parcel boundary compliance, agreed room/feature checklist, object budget, no prohibited assets and no damage to adjacent parcels.

A client can request a review, but cannot unilaterally confiscate completed work or release all escrow after a rejected submission. Provide a defined dispute flow with neutral system/NPC review for the earliest version. Human moderation is not a substitute for clear contract rules.

### 5.6 Property retention and world performance

- No punitive property decay or surprise taxes.
- Use storage limits and regional streaming.
- Load nearby property detail; distant buildings use simplified representations.
- Cap active physics, lights, scripts and decorative objects.
- Keep a recovery path for invalid or over-budget builds.
- Save build revisions incrementally with safe checkpoints.
- Provide a low-detail mode for weaker mobile devices.
- Public spaces and mission routes must remain navigable and performant.

## 6. Economy balance: sources and sinks

A healthy economy requires controlled currency sources and meaningful optional spending.

Sources (faucets):
- approved mission rewards;
- merchant buyback of approved resources;
- verified service contracts;
- construction contracts;
- later, resource gathering and other professions.

Sinks:
- merchant purchases;
- building materials;
- furnishing and optional renovation;
- business stock replenishment;
- cosmetic customisation purchasable with Aces;
- optional property upgrades that do not grant mission or combat advantage.

Avoid mandatory rent, punitive upkeep, paywalls, or systems that punish players for taking breaks. Exact values, prices, wages, taxes and caps remain UNSET until a playable economy can be measured.

Track aggregate Aces created and spent, median balance and balance distribution, merchant purchase/sale ratio, item supply and demand, contract completion and dispute rates, average time to first purchase, business/contract participation and repeat sessions/player return rate.

Use these measures to detect inflation, hoarding, exploit loops and dead markets. Do not optimise for compulsive spending or manipulative engagement.

## 7. Profession rollout after construction

Only add a profession when it has a real gameplay loop, clear outputs, a buyer and a reason to interact with other players.

Recommended order:
1. Merchants and shop owners — stock, pricing, supply and demand.
2. Architects and builders — design, construction and property services.
3. Suppliers and farmers — materials and resources that feed construction.
4. Hunters and trackers — wilderness tracking, Veil-threat investigation and approved resource gathering; avoid unrestricted animal-killing loops.
5. Engineers and mechanics — repair, utilities and transport infrastructure.
6. Civilian police and emergency services — public safety, investigations and response.

Civilian police operate under fictional civilian law and do not gain automatic authority over Covenant Chosen players. Covenant authority and player rank remain separate. No profession grants unrestricted moderation or account-control powers.

## 8. Retention and revenue strategy

The economy should create legitimate reasons to return: long-term personal projects and property, repeat customer relationships, visible architectural reputation, player-run shops and supply chains, cooperative commissions, seasonal content additions without expiring player rewards, and social showcases/community builds.

Revenue should follow quality and trust, not pressure. Possible later products include architectural style packs, room and furniture themes, business signage and branding, player cosmetics and emotes, companion presentation cosmetics, and Asher/Ember presentation collections under existing fairness restrictions.

Do not monetize Aces or Covenant Credits in the initial release, property/business success multipliers, faster construction completion that creates competitive advantage, premium-only tools needed for normal construction, exclusive mission areas/evidence/progression, Covenant rank/authority/combat superiority or spiritual status.

A paid visual theme may decorate a house, but a free player must be able to build a functional and attractive house using the core kit. Show exact contents and price; no randomized paid rewards, artificial scarcity or repeated purchase prompts.

## 9. Cross-platform and accessibility acceptance

Before release, test PC-only, mobile-only and mixed PC/mobile servers; touch placement and selection with appropriately sized controls; mouse placement and selection; responsive inventory, merchant, contract and build interfaces; screen resizing, safe areas and aspect ratios; property streaming and performance on lower-end mobile hardware; reconnect, server-hop and interrupted-save recovery; and exploit attempts using forged prices, quantities, ownership, build IDs and contract states.

Do not advertise gamepad support until selection, focus, navigation and activation are tested in Roblox Studio.

## 10. Implementation backlog and gates

### Gate A — persistence reliability
- [ ] Diagnose and repair the current failing headless regression run.
- [ ] Run the full CI sequence: Lune tests, StyLua, Selene and Rojo build.
- [ ] Implement and test the DataStore adapter behind a disabled-by-default feature gate.
- [ ] Run Studio multi-server persistence tests before live join integration.

### Gate B — minimum viable economy
- [ ] Review profile schema expansion and migration plan.
- [ ] Add item catalogue and inventory policy with pure regression tests.
- [ ] Add durable transaction journal/coordinator.
- [ ] Add NPC merchant buy/sell vertical slice.
- [ ] Add recovery and exploit tests.
- [ ] Validate PC/mobile UI in Studio.

### Gate C — property
- [ ] Add property catalogue, parcel ownership and revision rules.
- [ ] Add modular build catalogue and placement policy.
- [ ] Add contract state machine and escrow coordinator.
- [ ] Add inspection, cancellation, dispute and recovery tests.
- [ ] Add a small residential construction demo and performance budget.

### Gate D — scale
- [ ] Add player-owned shops and limited peer-to-peer trade.
- [ ] Add supplier/farmer loops.
- [ ] Add additional professions only after real demand and balance data exist.
- [ ] Consider cosmetic monetization only after the free system is complete and tested.

## 11. Explicit current status

**CONFIRMED**
- The user approved the direction and priority: economic foundation first, construction second, professions later.
- Aces and Covenant Credits remain distinct.
- PC and mobile are equal targets.
- Existing profile/lease/record policy and fake-store test foundations exist.

**IMPLEMENTED AS SOURCE / HEADLESS RULES ONLY**
- Injectable profile persistence adapter with bounded retry, lease acquisition/release and ambiguous-save reconciliation; not connected to live joins.
- Construction-supply item catalogue with stable IDs, stack caps and merchant-group metadata; no prices or live stock.
- Pure bounded inventory policy with validation, add/remove transformations and regression tests.
- Profile schema v2 now includes inventory; valid v1 profiles migrate to v2 while preserving progression and balances. Record acquisition applies the migration atomically.

**NOT IMPLEMENTED**
- Live DataStore integration or persistent player profiles.
- Durable inventory, merchant transactions, escrow, contracts, businesses or property.
- Construction tools, parcels, build validation or inspection.
- Any Robux product, price, receipt handler or purchase entitlement.

**BLOCKERS**
- Latest completed GitHub Actions validation run after schema migration and inventory tests passed: headless regression tests, StyLua, Selene and Rojo build.
- Roblox Studio multi-client and device testing has not been performed.
- No production persistence or economy should be enabled until the relevant gates pass.

This specification is a staged design contract, not a claim that any of these systems are already playable.
