# BEYOND THE VEIL: THE LAST WATCH
## Economy, Progression & Production Readiness v1.0

**Status:** Existing reference updated with creator-approved design principles (2026-10-11). Approved Design is not a claim of implementation or testing. This document does not silently change content canon.

**Scope:** Covers the non-story economy/progression framework and production-readiness practices that can be advanced without settling the reserved collaborative topics. It does not define the final combat model, technical architecture, vertical-slice completion, UI/audio/accessibility/visual bible, or the story/character/Christian-identity decisions reserved for creator collaboration.

## 1. Source-of-truth rule

Apply the latest explicit creator decision first, then the BTV Master Canon and accepted creator decisions, then the relevant specialized Bible, then this proposal. If a conflict appears, record it instead of blending incompatible versions. Unknowns remain unknown until the creator approves a decision.

Use these labels consistently:
- **CANON** — established and protected.
- **APPROVED DESIGN** — approved design direction; implementation, integration, and verification remain separate evidence-based states.
- **CANON DIRECTION** — intended direction, implementation still open.
- **PROPOSED** — useful recommendation awaiting creator approval.
- **RESERVED** — intentionally deferred.
- **UNKNOWN / CREATOR DECISION REQUIRED** — do not invent as fact.
- **CONFLICT** — inconsistent with a higher-authority source.

## 2. Economy principles

### 2.1 Established currency distinction — CANON

- **Aces:** general-world currency.
- **Covenant Credits:** Covenant-focused currency.
- They are distinct and should not be treated as interchangeable by default.
- Faith, salvation, grace, divine favor, prayer effectiveness, holiness, spiritual worth, the Holy Spirit, worship, and Communion must never be purchasable, lootable, tradable, or represented as spendable resources.
- Giving is voluntary; it must not be coerced or evaluated only by amount.

### 2.2 Three distinct reward categories — APPROVED DESIGN

Keep three clearly separated value categories:

1. **Ordinary exchange:** goods and services paid for with Aces.
2. **Covenant logistics:** authorized equipment, mission supplies, training access, and operational services paid for with Covenant Credits where the fiction supports it.
3. **Non-monetary rewards:** information, trust, access, rescued people, restored services, relationships, new missions, and changes in community conditions.

The third category is important: not every meaningful result should be translated into currency.

### 2.3 Economy guardrails

- Do not reward violence as the universally most profitable approach.
- Do not pay the player for prayer, worship, Scripture recitation, Communion, conversion, or acts of generosity.
- Do not make charity a financial optimization mini-game.
- Avoid inflationary rewards that make ordinary goods meaningless.
- Avoid compulsory grinding for routine story progress.
- Show why a reward was granted and who authorized it, where appropriate.
- Distinguish personal wealth from Covenant resources; do not allow one wallet to bypass the other system's constraints.

### 2.4 Proposed reward review checklist

Before approving a reward, answer:
- What action or contribution earned it?
- Does the reward fit that action?
- Is it money, equipment, information, access, relationship change, or world-state change?
- Could it incentivize a harmful or uncharacteristic player behavior?
- Does it accidentally commodify a sacred practice?
- Does it break scarcity, mission balance, or progression pacing?
- Can the player understand the outcome without a morality score?

### 2.5 Lore-grounded Covenant logistics — APPROVED DESIGN

Covenant supplies and operational access should be explained through the organization rather than treated as an unexplained player wallet. Use established roles in their existing scope:

- **Keepers:** equipment, inventory, supply availability, maintenance and resource accountability.
- **Scouts:** field observations, route conditions, local needs and operational leads.
- **Watchers:** investigation, corroborated intelligence, threat analysis and information reliability.
- **Team leaders / Commanders / Generals:** assignment priorities, authorization, deployment decisions and responsibility appropriate to rank.

This is a design rule, not a final UI or technical architecture. Exact authorization rules, team counts, prices, supply formulas and interfaces remain OPEN or PROPOSED until separately designed. Covenant Credits must remain distinct from Aces; neither currency grants spiritual authority.

## 3. Progression framework

### 3.1 Separate progression tracks — APPROVED DESIGN

Keep these progression dimensions distinct. None is a measure of spiritual worth.

**Practical capability progression — APPROVED DESIGN:** equipment familiarity, practical abilities, traversal options, investigative tools, and team coordination can improve through use, instruction, discovery, and authored milestones. Exact skill trees and numerical formulas remain open.

**Knowledge progression — CANON DIRECTION:** the player learns from observations, testimony, documents, patterns, and verified reports. Knowledge should change what the player can reasonably infer or do, rather than merely fill a percentage bar.

**Contextual relationship progression — APPROVED DESIGN:** people and teammates respond to reliability, honesty, judgment, service, and prior consequences. Do not reduce every relationship to one universal approval meter.

**Covenant responsibility progression — APPROVED DESIGN (within established rank canon):** Covenant rank advancement is story-earned and grounded in service, leadership, judgment, trust, and consequences—not kill counts, XP alone, or supposed spiritual superiority.

**World recovery and contextual progression — APPROVED DESIGN:** successful rescue, investigation, restoration, or defensive action can change local safety, access, services, NPC routines, available information, and future mission conditions.

### 3.2 Avoid false equivalences

- More equipment does not mean greater holiness.
- A higher Covenant rank is more responsibility, not greater spiritual worth.
- A successful mission does not guarantee every person will repent, forgive, or trust Asher.
- Mercy does not erase harm or remove consequences.
- A failed objective does not necessarily erase all knowledge or all good achieved.
- Combat success is not the only evidence of leadership.

### 3.3 Progression pacing

Recommended principles:
- Introduce one meaningful system at a time.
- Prefer understandable, consequential upgrades over a large volume of tiny statistical bonuses.
- Give the player useful feedback about what changed and why.
- Do not require repetitive side activities to understand the main story.
- Keep exact numerical values, XP rules, crafting, durability, shop prices, and skill-tree structure **OPEN / RESERVED** until deliberately designed and tested.

## 4. Mission reward and consequence matrix

| Activity | Suitable outcome types | Avoid |
|---|---|---|
| Investigation | verified information, leads, access, better preparation | automatic money for every clue; certainty without evidence |
| Rescue | lives protected, trust, new contacts, community recovery | reducing rescued people to loot drops |
| Community restoration | repaired services, access, relationships, local stability | treating generosity as a score multiplier |
| Covenant operation | authorized supplies, tactical intelligence, responsibility | rank increases based only on kills |
| Dialogue or de-escalation | cooperation, time gained, changed threat, useful testimony | guaranteeing that every speech persuades everyone |
| Combat | immediate safety, recovered evidence/materials when plausible, a safer route | making violence always the most profitable option |
| Withdrawal | preserved evidence, survival, future opportunity, partial loss | treating every retreat as total failure |

This matrix is a design guide, not a final implementation contract.

## 5. Economy and progression testing

For each mission and major reward, test:
- Is the reward understandable and proportional?
- Can the player become stuck because of an avoidable currency gate?
- Can one repeatable activity trivialize the economy?
- Is any sacred activity mistakenly tied to money, XP, equipment, or buffs?
- Can non-combat approaches remain viable without always being strictly better?
- Does the game recognize partial success and information gained?
- Are rank and leadership earned through the story rather than a grind loop?
- Are rewards consistent with the player's actual actions and outcomes?

## 6. Production readiness: minimum discipline

### 6.1 Source control and safe changes — PROPOSED PROCESS

- Keep the original project and repository history intact.
- Work on a branch or clearly named checkpoint before significant changes.
- Make small, reviewable changes with descriptive commit messages.
- Do not overwrite unknown files or generated project settings without inspecting them.
- Keep secrets, API keys, signing keys, passwords, and personal credentials out of source control.
- Use a `.gitignore` appropriate to the selected engine/toolchain once that engine is confirmed.
- A successful commit is not proof that the game runs; record actual test results separately.

### 6.2 Asset provenance and intellectual property

For every external or generated asset, record:
- asset name and location;
- creator/source;
- license or usage terms;
- whether attribution is required;
- whether commercial use and modification are permitted;
- date acquired or generated;
- any restrictions or uncertainties.

Rules:
- Use reference games only for high-level design learning, not to reproduce protected characters, maps, distinctive assets, dialogue, or signature presentation.
- Do not assume that an image found online is free to use.
- Do not use a real person's likeness, voice, church identity, or branding in-game without an appropriate basis and approval.
- Keep BTV's fictional Logos Rhema Temple distinct from real-world HCI; HCI is inspiration/reference only under established direction.
- Mark unclear rights **UNVERIFIED** and do not ship those assets until resolved.

### 6.3 Documentation quality

Each major system should eventually have:
- purpose and status;
- canon dependencies;
- expected player experience;
- inputs and outputs;
- dependencies and integration points;
- known failure modes;
- test steps and observed results;
- platform considerations for Android and PC;
- asset/license notes where applicable;
- owner/next action and change history.

Do not label a feature “complete” because a document describes it. Distinguish **DOCUMENTED**, **IMPLEMENTED**, **TESTED**, and **ACCEPTED**.

## 7. Evidence-based production gates — APPROVED DESIGN

These gates are an approved project-control framework, not a promise that any stage has already been completed.

1. **Canon and scope gate:** resolve conflicts; mark reserved topics; identify the source of truth.
2. **Design gate:** document the intended behavior, edge cases, and acceptance criteria for the next feature.
3. **Implementation gate:** make a small, reversible change with explicit dependencies.
4. **Verification gate:** test the actual build and record device/platform, steps, expected result, actual result, and known limitations.
5. **Regression gate:** confirm the change did not break existing behavior.
6. **Documentation gate:** update only the documents affected by the change and record the change.
7. **Release-readiness gate:** review stability, performance, asset rights, save/data safety, platform compliance, and known defects before sharing a build.

No gate is passed by assumption. If no runnable build or device test is available, mark the result **NOT VERIFIED**.

### 7.1 Evidence required at each gate — APPROVED DESIGN

Use separate states; never infer one from another:

- **DOCUMENTED:** an existing design/reference describes intended behavior and its status.
- **IMPLEMENTED:** a specific change exists in the actual project; record repository/commit or exact changed-file evidence.
- **INTEGRATED:** the feature is connected to its dependencies in the project; record the integration points and any migration/configuration changes.
- **VERIFIED:** repeatable checks were actually run; record build/version, platform/device where relevant, steps, expected result, observed result, and limitations.
- **ACCEPTED:** the responsible reviewer has checked the evidence against acceptance criteria and explicitly accepted the result.
- **NOT VERIFIED:** required runnable build, platform access, or evidence is unavailable.

A design document alone supports DOCUMENTED only. A code diff alone may support IMPLEMENTED but does not prove integration or correct runtime behavior. A test plan alone is not a test result. Never claim the BTV game, a build, or a platform has passed a gate without the corresponding evidence.

### 7.2 One source of truth and change control — APPROVED DESIGN

- The **BTV Master Canon** remains the primary authority for content canon and cross-project rules.
- The relevant specialized Bible is the domain reference for its system; this economy/production document is guidance for the approved economy/progression and production-discipline principles.
- Record approved design decisions in the relevant existing reference, then add a concise cross-reference/change note to the Master Canon or changelog when the decision affects multiple domains. Do not create a parallel competing specification merely to restate the same rule.
- When references disagree, follow the existing authority order, identify the exact conflict, and reconcile the lower-authority reference; do not silently blend contradictory rules.
- Preserve version history and note what changed, why, dependencies, and whether implementation has actually been verified.

## 8. Defect and risk register template

| Field | Required content |
|---|---|
| ID | Unique short identifier |
| Area | System or document affected |
| Finding | Observable issue, not speculation stated as fact |
| Evidence | File, scene, log, reproduction steps, or source document |
| Severity | Blocker / High / Medium / Low |
| Confidence | Confirmed / Likely / Unverified |
| Impact | Player, canon, save data, platform, legal, or production impact |
| Recommendation | Smallest safe next action |
| Status | Open / Investigating / Fixed / Retest required / Closed |

## 9. Reserved collaborative work — do not advance independently

The following remain deliberately untouched beyond cross-reference:

- **#2 Story, characters and Christian identity:** creator collaboration required.
- **#4 Technical and update-readiness audit:** requires a deliberate technical/repository review and shared decisions.
- **#5 Vertical-slice completion:** do not declare the slice complete or change its scope without collaboration.
- **#6 UI, audio, accessibility and visual consistency:** creator collaboration required.

This document does not select a game engine, settle story or character questions, define final combat mechanics, redesign the vertical slice, or approve final UI/art/audio.

## 10. Next independent actions

1. Keep the canon reconciliation addendum and core gameplay specification labeled as working documents, not automatic replacements for the Master Canon.
2. Apply the creator-approved economy/progression guardrails to the existing economy and progression reference; leave unrelated or unselected mechanics clearly marked PROPOSED.
3. Establish an asset provenance register before adding external assets to a distributable build.
4. Use the production gates and defect template for future changes; distinguish written plans from verified implementation.
5. When reviewing the actual project, report evidence and gaps rather than claiming code, performance, or platform readiness without tests.

**Final principle:** BTV should grow through small, traceable, testable changes that protect canon, preserve originality, and keep sacred Christian practices outside commercialized game reward systems.