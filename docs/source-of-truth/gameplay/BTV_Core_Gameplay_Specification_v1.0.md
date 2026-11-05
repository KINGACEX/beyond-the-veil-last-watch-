# BEYOND THE VEIL: THE LAST WATCH
## Core Gameplay Specification v1.0

**Document type:** Core gameplay design reference  
**Status:** PROPOSED DESIGN — prepared under creator delegation; detailed implementation choices remain adjustable  
**Scope:** Core gameplay model only. This document does not replace the Master Canon, specialized Bibles, or the locked Vertical Slice Specification. It does not define the technical proof, implementation plan, or expansion beyond the vertical slice.

---

## 1. Purpose

Define the repeatable player experience of *Beyond the Veil: The Last Watch* (BTV): what the player does, how systems support those actions, how choices create consequences, and how action-adventure survival gameplay remains consistent with BTV's Christian foundations.

The player should feel like a capable but still-learning Covenant field operative protecting real people in a world that remains worth living in—even when the Veil makes parts of it frightening and unreliable.

## 2. Authority and status rules

Use the following priority when resolving a conflict:
1. The creator's latest explicit instruction or correction.
2. Reconciled Master Canon.
3. Specialized Bibles within their domains.
4. The Vertical Slice Specification for details explicitly locked to that slice.
5. This Core Gameplay Specification.
6. Older handoffs, prompts, prototypes, mockups, and generated assets.

Status labels:
- **CANON:** established and protected.
- **APPROVED DESIGN:** approved for use, while implementation details may evolve.
- **CANON DIRECTION:** firm creative direction; some details remain open.
- **PROPOSED:** a recommendation in this document, not yet creator-confirmed.
- **RESERVED:** intentionally deferred; do not implement early.
- **UNKNOWN:** not established; do not invent as fact.

This document proposes a gameplay framework. It does not silently convert every recommendation into permanent canon.

## 3. Core player promise

**Explore a living world, discover what is happening, decide whom and what to trust, protect people, act with judgment, and live with the consequences.**

BTV is an action-adventure survival RPG. Combat is important, but combat is not the default answer to every problem. Investigation, traversal, dialogue, stealth or avoidance, rescue, community service, tactical coordination, and retreat must remain legitimate forms of play when the situation supports them.

## 4. Design pillars

### 4.1 A living world before a dangerous world
Public spaces should feel occupied by civilians, families, workers, merchants, worshippers, visitors, and responders. Covenant personnel should be more common at Covenant facilities than in ordinary community spaces. Daily routines and reactions change with location, time, local activity, and crisis conditions.

### 4.2 Evidence before certainty
Reports, witness accounts, environmental signs, records, and supernatural effects can be incomplete. The player should distinguish what was observed, what was reported, what is inferred, and what remains unconfirmed. A strong investigator does not automatically know the truth; they make better-supported decisions.

### 4.3 Protection is a real objective
Civilians are not background props or disposable escorts. Protecting, evacuating, locating, reassuring, or helping them can be central mission objectives. A mission can succeed while some uncertainty remains, and a tactically impressive victory can still have serious costs.

### 4.4 Action with purpose
Combat, stealth, dialogue, and retreat should arise from the situation. Enemies have readable motives and behavior. The player should have time to understand danger when the fiction allows it, rather than being forced into an arena fight by default.

### 4.5 Faith is meaningful, not a game currency
Prayer, Scripture, church life, service, and spiritual reflection belong to the story and the character's life. They are not purchasable powers, stat buffs, conversion counters, XP tracks, or guarantees of success. God is not a controllable combat character; the Holy Spirit is not a scanner or certainty engine.

### 4.6 Consequences without a universal morality score
Choices may affect safety, evidence, relationships, trust, available information, resources, and later events. Do not collapse those outcomes into a single numerical “goodness” or spiritual-worth meter.

## 5. The core gameplay loop

**Explore → Observe → Investigate → Talk / Interact → Interpret → Prepare → Choose → Act → Face consequences → Report / Reflect → Continue.**

This is a flexible pattern, not a mandatory checklist. A battle operation may move quickly from observation to defense. A community mission may focus on listening and repair. A Veil investigation may involve several rounds of evidence gathering before the player acts.

### Loop stages
1. **Explore:** Move through connected locations, learn routes, notice local routines, and discover people, places, services, resources, and unusual events.
2. **Observe:** Notice environmental changes, behavior, sound, signs of danger, and inconsistencies. Observation provides details, not automatic explanations.
3. **Investigate:** Examine clues, compare accounts, question people respectfully, use Watcher skills, and record confidence or uncertainty.
4. **Talk / Interact:** Listen, ask questions, negotiate, warn, preach when appropriate, offer practical help, or leave a conversation.
5. **Interpret:** Connect evidence and test competing explanations. The game should communicate confidence and contradictions without requiring one arbitrary “correct” answer every time.
6. **Prepare:** Select suitable equipment, plan a route, review the report, decide what supplies are appropriate, and choose how to use Ember or available teammates.
7. **Choose:** Decide whether to investigate further, approach, avoid, rescue, protect, negotiate, withdraw, or engage in combat where justified.
8. **Act:** Execute the chosen approach with responsive movement, contextual interactions, tactical decisions, and readable feedback.
9. **Face consequences:** The world responds in ways grounded in what happened. Consequences may be immediate or appear later.
10. **Report / Reflect:** Submit findings, identify remaining uncertainty, review the mission's impact, and continue into a changed or clarified situation.

## 6. Mission structure

### 6.1 Mission categories
Recognized categories include Rescue, Investigation, Evangelism / Outreach, Restoration, Battle Operations, Scout Operations, Community Help, and Veil Investigations. A mission may combine several categories.

### 6.2 Mission brief
A mission brief should convey, as applicable:
- why the objective matters and who may be affected;
- what is known, who reported it, and how reliable it is;
- what remains uncertain or disputed;
- likely risks and available support;
- the player's authority and limits;
- possible approaches without promising that every approach will work.

The brief must not magically reveal hidden enemies, secret identities, or the Veil's ultimate explanation.

### 6.3 Flexible objectives
Objectives can change as the player discovers new information. A mission might begin as observation, become a rescue, and finish with evidence preservation or restoration. Optional objectives should add meaningful context rather than simply pad completion time.

### 6.4 Multiple viable approaches
Where context supports it, allow combinations of:
- observation and evidence collection;
- dialogue, listening, warning, negotiation, or de-escalation;
- stealth, concealment, route choice, or avoidance;
- rescue, evacuation, escort, protection, or practical assistance;
- tactical defense and combat;
- withdrawal and later reassessment.

No approach must be viable in every encounter. The game should communicate why an option is unavailable or risky rather than pretending all choices are equal.

## 7. Investigation and Watcher gameplay

Asher is an Agent/Specialist in the Watcher branch. Watcher play emphasizes observation, intelligence, evidence assessment, threat identification, and discernment, while leaving him a capable field operative.

### 7.1 Evidence model
Use four source labels consistently:
- **Observed:** directly witnessed or documented by a source.
- **Reported:** someone has claimed it; accuracy may vary.
- **Inferred:** a conclusion drawn from available information.
- **Unconfirmed:** a claim or explanation not yet adequately corroborated.

“Unverified” may be used for a connection the player proposes on an Evidence Board. These labels describe confidence, not absolute truth.

### 7.2 Evidence Board
**PROPOSED:** A diegetic or diegetic-feeling board lets the player group clues, connect claims, flag contradictions, and keep alternative explanations visible. It should not require a single exact combination of clues if multiple interpretations are reasonable.

The board must distinguish:
- evidence the player actually found;
- information supplied by a source;
- the player's interpretation;
- unresolved questions.

Do not penalize the player for recording a reasonable hypothesis that later proves wrong. The learning comes from new evidence and consequences.

### 7.3 Observation limits
Careful observation can reveal details worth examining but should not function as x-ray vision, omniscience, or a universal supernatural detector. It may cost time or increase exposure when the location is dangerous. Key story information must not depend on tiny visual details alone; provide fair alternative clues or accessibility supports.

### 7.4 Dialogue and testimony
People have their own motives, fears, limitations, and knowledge. A frightened or mistaken witness is not automatically malicious. Dialogue options should communicate tone and intention clearly enough for players to understand what Asher is attempting, while allowing the other character to respond naturally.

## 8. Traversal, stealth, and field presence

### 8.1 Traversal
Traversal should make places legible and distinct. Routes may include streets, buildings, paths, wilderness, facilities, and Veil-affected spaces. Environmental storytelling should reward attention without requiring constant scanning.

### 8.2 Stealth and avoidance
**PROPOSED:** When a threat can reasonably be avoided, the player should be able to use cover, timing, routes, concealment, distraction, or patient observation. Stealth is not a universal invisibility mode; enemy awareness should respond to noise, visibility, context, and suspicious behavior.

### 8.3 Readability
Communicate danger through a combination of animation, sound, environment, witness behavior, and UI where appropriate. Do not rely on color alone to communicate danger, evidence quality, or interactability.

### 8.4 No mandatory busywork
Walking, waiting, conversations, travel, and exploration should serve atmosphere, choice, discovery, or relationships. Avoid forcing repetitive interactions merely to inflate playtime.

## 9. Combat design direction

The exact combat model remains open. This section defines principles rather than final controls, formulas, weapons lists, or animation requirements.

### 9.1 Combat purpose
Combat exists to defend life, stop immediate threats, create openings for rescue, survive hostile operations, and resolve conflicts where other approaches are unsafe or have failed. It is not the sole source of progress, rewards, or narrative importance.

### 9.2 Readable encounters
- Enemies should telegraph major actions fairly through animation, sound, positioning, or contextual cues.
- Enemy behavior should reflect its established function and identity, not arbitrary health inflation.
- Multiple enemies should create tactical pressure through positioning, coordination, terrain, and objectives—not only larger health bars.
- Civilians and fragile surroundings may change the player's priorities and available actions.
- The player should usually have a meaningful opportunity to retreat unless the story clearly establishes a no-retreat situation.

### 9.3 Enemy function
- **Destroyers:** direct aggression, force, and destruction.
- **Persuaders:** influence, manipulation, temptation, and coercive persuasion.
- **Deceivers:** false perception, misinformation, confusion, illusion, and ambush.
- **Commanders / Bosses:** coordinate or embody a major conflict; they must have narrative and behavioral identity beyond high damage or health.

These are functional categories, not a complete species taxonomy or universal hierarchy. Human antagonists need specific motives; being a civilian or non-believer does not make someone evil.

### 9.4 Defense and recovery
**PROPOSED:** Favor clear defensive choices such as repositioning, blocking or guarding where appropriate, using cover, interrupting a threat, helping an ally, and disengaging. Avoid designing every fight around perfect timing alone. Healing and recovery rules, stamina costs, weapon statistics, and exact combat inputs remain open for later design.

### 9.5 Non-lethal outcomes
Where appropriate, encounters may support warning, de-escalation, surrender, escape, restraint, or rescue. These outcomes must fit the threat and should not become an automatic “best ending” button.

## 10. Survival pressure and resources

BTV's survival elements should create preparation and prioritization without turning the game into constant inventory administration.

### 10.1 Intended pressure
**PROPOSED:** Use situational pressure—limited supplies, exposure, fatigue, difficult routes, damaged equipment, communications limits, and civilian needs—when it adds meaningful decisions. Not every system must be active in every mission.

### 10.2 Resource rules
- Ordinary equipment and materials may be found, purchased, supplied, crafted, repaired, or earned through context-appropriate activities if those systems are later approved.
- Enemy drops can include clues, materials, equipment, information, or access to opportunities; not every enemy needs loot.
- Aces are general-world currency. Covenant Credits remain Covenant-focused. They must not be casually merged.
- Faith, salvation, grace, divine favor, prayer effectiveness, holiness, spiritual worth, and the Holy Spirit are never purchasable, lootable, or tradable resources.
- Church giving is voluntary and must never guarantee gameplay benefits.

Exact prices, inventory limits, crafting recipes, durability, healing items, and economy formulas remain **UNKNOWN / RESERVED**.

## 11. Ember as a companion

Ember is an intelligent animal companion and field partner, not a weapon, an omniscient detector, or a substitute for player judgment.

### 11.1 Official commands
**Attack, Protect, Scout, Track, Retrieve, Hold, Regroup.** “Stay” is informal or legacy wording for Hold. “Follow” and “Guard” are not official commands. Default companion movement behavior is an implementation detail, not an extra command.

### 11.2 Companion principles
- Commands should have clear, contextual effects and understandable feedback.
- Ember's behavior should adapt to the environment and immediate danger, but must not secretly solve every investigation.
- Scouting and tracking should provide leads, signs, or direction—not unquestionable explanations.
- Protect should prioritize the assigned person or nearby immediate danger according to context; it should not make Ember invulnerable.
- Attack is a tactical instruction, not a promise that violence is always the right choice.
- Ember should be able to regroup or be recalled so that companion separation does not become tedious.
- Bond growth can be shown through behavior, trust, responsiveness, and story moments; it must not imply spiritual worth or become a purchasable faith system.

Established ability names are Veil Sight, Guardian Instinct, Veil Energy, Tracking Sense, and Spirit Guidance. Their exact activation rules, resource costs, upgrade paths, species, origin, and full Veil relationship remain open.

## 12. Teammates and Covenant tactics

When teammates are present, they should feel like people with specialties, judgment, limitations, relationships, and independent priorities—not interchangeable stat containers.

Recognized tactical instructions include **Hold, Push, Scout, Protect Civilians, Retreat, and Protect Teammate**. Exact command menus and implementation remain open.

Tactical advice can vary by teammate expertise and available evidence. Teammates may disagree reasonably. The player should be able to consider advice without the game implying that one character is always correct.

Asher's authority is bounded by his current rank and assignment. He may protect life in immediate danger, use field judgment, and withdraw; larger organizational decisions may need to be reported or recommended. Promotion follows story-earned responsibility, service, judgment, and trust—not kill counts or ordinary XP alone.

Multi-team command, regional strategy, and General-level leadership systems are **RESERVED** for later work.

## 13. Faith, prayer, and Scripture in gameplay

### 13.1 Faith boundaries
Faith is not a level, statistic, skill tree, currency, morality score, or grindable resource. Prayer is not a guaranteed transaction. The Holy Spirit is not a controllable attack, map scanner, or certainty engine. God is the ultimate authority, not a playable combat unit.

### 13.2 Appropriate integration
Faith may shape how Asher reflects, responds to fear, treats others, seeks counsel, serves communities, understands responsibility, and draws courage from Scripture. Such moments should arise from character and context, not from a cooldown or a combat optimization loop.

### 13.3 Scripture declarations
Rare, authored Scripture moments must be contextually appropriate and narratively earned. They are not spells, buffs, damage abilities, repeatable tactical inputs, or guarantees of success. Psalm 23's Ridgeview use remains governed by the locked Vertical Slice Specification.

### 13.4 Church life and Communion
Logos Rhema Temple is a living fictional church, not a Covenant base. Service and Communion are contextual, reflective experiences. Communion uses the Communion Set only within the CommunionContextZone and provides no stats, XP, currency, healing, equipment, or progression. Giving is voluntary, private, and never tied to reward or penalty.

## 14. Choice and consequence model

BTV should model specific outcomes rather than a universal morality meter.

Possible consequence dimensions include:
- immediate safety and civilian protection;
- evidence preserved, lost, or contaminated;
- trust, willingness to speak, and relationship changes;
- time, supplies, equipment, and access;
- whether a threat escapes, escalates, surrenders, or is contained;
- the information available to the Covenant and future missions;
- community disruption, repair needs, displacement, or recovery.

Not every consequence must be visible immediately. The game should give fair feedback when possible, but should not expose every hidden variable or turn people into numerical reputation bars.

Mercy, forgiveness, surrender, reconciliation, and restoration can matter. They do not erase harm automatically, guarantee repentance, or function as a conversion percentage.

## 15. Failure, retreat, and recovery

Failure should teach through grounded consequences rather than always ending the game. Possible outcomes include a missed lead, a lost opportunity, an injured or displaced person, damaged infrastructure, a changed relationship, delayed information, a forced retreat, or a different follow-up mission.

### Recommended fairness rules
- Distinguish a failed objective from a total mission failure.
- Where fiction permits, let the player retreat and reassess.
- Preserve meaningful discoveries across a failed attempt when doing so makes narrative sense.
- Communicate why an approach failed when the character could reasonably understand it.
- Do not punish players for not discovering a hidden clue that the game did not fairly communicate.
- Avoid making one unmarked dialogue choice permanently destroy a major route without warning unless the story clearly signals the stakes.

Exact checkpoints, save behavior, retry rules, injury persistence, and mission reset remain **UNKNOWN / RESERVED**.

## 16. Progression and rewards

Progression should represent growing capability, knowledge, relationships, equipment, access, responsibility, and leadership. It must not represent increasing holiness or divine favor.

Potential reward types include information, clues, materials, equipment, access, relationships, opportunities, Covenant recognition, and story progression. Reward scale should match the risk and context. Some missions should primarily reward understanding, rescue, community stability, or new responsibilities rather than loot.

Major Covenant promotions are narrative milestones earned through responsibility, service, judgment, leadership, and trust. Do not make repetitive grinding or enemy kills the sole advancement path.

Exact player levels, XP curves, skill trees, equipment grades, Armor of God acquisition order, upgrade statistics, currency prices, and Ember progression formulas remain open.

## 17. World response and NPC behavior

The world should respond to what actually happened, not simply to a binary mission-complete flag.

NPC reactions may reflect what they personally witnessed, heard from credible sources, or inferred. Do not give every NPC universal knowledge of the player's actions. Communities may respond through altered routines, requests for help, increased caution, repaired services, memorials, renewed activity, or continued disagreement.

A peaceful settlement should not behave like an active war zone. Public areas should remain civilian-heavy and diverse; Covenant facilities may be Covenant-heavy. Veil incidents layer abnormal effects over recognizable places rather than erasing all ordinary life automatically.

Persistent world simulation depth is not defined here; only the behavioral principle is established.

## 18. Player information and interface principles

The interface should support decisions without replacing observation or turning the world into a checklist.

- Show mission objectives and urgent risks clearly, while allowing the player to hide or reduce nonessential markers.
- Distinguish evidence status and source confidence consistently.
- Make interaction targets and command states legible without relying on color alone.
- Use contextual HUD changes for exploration, investigation, combat, dialogue, and companion commands while preserving a recognizable BTV identity.
- Avoid constant pop-ups for faith, Scripture, civilian assistance, or ordinary dialogue.
- Never use a morality meter, conversion percentage, prayer-power meter, or spiritual-worth score.
- Provide adjustable subtitles, text size, camera sensitivity, aim assistance where appropriate, remappable controls where feasible, and options to reduce camera shake or visual effects.
- Essential clues should have alternatives or accessibility aids; visual acuity and fast hearing should not be the only way to understand a critical story beat.

Detailed HUD layouts, control mappings, accessibility settings, and platform-specific interaction design remain outside this document's implementation scope.

## 19. Difficulty and fairness

Difficulty may adjust pressure, enemy behavior, resource scarcity, or timing, but must not rewrite character identity, theology, or established world rules.

Challenge should reward observation, preparation, tactical judgment, and adaptation. Avoid difficulty based primarily on hidden rules, arbitrary enemy durability, unavoidable damage, or withholding essential information.

Where possible, let players tailor combat assistance and interface support independently of narrative difficulty. Do not equate easier settings with weaker faith, less worthy choices, or a lesser story.

## 20. Audio and environmental feedback

Audio should help players read the world: ordinary community activity, changes in wildlife, equipment sounds, radio reliability, enemy cues, companion behavior, and spatial danger. Veil audio should have a recognizable logic but not become a universal warning alarm that gives away every answer.

Use subtitles and non-audio cues for essential information. Avoid using loudness or sensory overload as the only way to communicate danger.

Specific sound palettes, music themes, voice direction, and technical audio systems remain open.

## 21. Example of the loop in practice: Ridgeview

This example explains how the gameplay model supports the already-locked Ridgeview slice; it does **not** redesign or expand it.

1. Asher receives a Scout Report containing observations, reports, inferences, alternatives, and gaps.
2. He reviews the report and decides what he wants to verify, without being handed an exact enemy marker.
3. During travel and approach, environmental signs and Ember's behavior suggest an abnormal condition but do not explain its cause.
4. At Ridgeview, Asher observes that people are present, disproving a second-hand claim that the settlement is shut. This teaches the player to test reports against reality.
5. He listens to residents, speaks with Wren, examines evidence, and decides how to approach Dorian Pike.
6. He organizes the evidence and considers what remains uncertain. He is not required to identify the Devourers by name.
7. He chooses among the established response options for the slice: Speak/Preach, Investigate, Rescue, Defend, or Withdraw, as context allows.
8. The choice changes immediate risk and consequences; no choice earns XP or a morality score.
9. Asher submits a report that separates findings from hypotheses. The Covenant receives useful information even if some questions remain unresolved.
10. The Psalm 23 scene remains a rare authored moment of faith, not a gameplay power or guaranteed solution.

## 22. Core design anti-patterns

Do not:
- reduce every mission to travel, kill, loot, return;
- make every enemy hostile or every human antagonist irredeemable;
- reward preaching or conversion with points, percentages, loot, or guaranteed obedience;
- turn prayer, Scripture, Communion, generosity, or the Holy Spirit into combat resources;
- make Ember an all-purpose supernatural detector or automatic solution;
- reveal the Veil's ultimate origin simply because a mission needs an explanation;
- give every NPC perfect knowledge of the player or every report perfect accuracy;
- make Covenant rank a measure of spiritual worth;
- treat every failed objective as a total game-over;
- create a universal morality meter;
- let procedural variety override canon or character motives;
- lock exact formulas, prices, combat controls, or technical architecture without a later design decision.

## 23. Open decisions intentionally not finalized

These remain open for later focused design:
- exact combat inputs, weapon classes, damage formulas, stamina, blocking, aiming, and enemy health rules;
- player health, healing, injury, fatigue, hunger/thirst, and other survival variables;
- inventory capacity, crafting, equipment durability, prices, and economy simulation;
- player XP/levels, skill trees, and numeric progression;
- exact Ember ability activation, cooldowns, and growth;
- detailed companion and teammate AI;
- exact stealth detection and alert-state formulas;
- save, checkpoint, retry, mission reset, and persistence rules;
- full HUD, controls, and platform-specific accessibility implementation;
- technical architecture and engine implementation;
- anything reserved for the separate technical proof, vertical-slice completion, or wider-expansion stages.

## 24. Acceptance criteria for the core gameplay design

The core model is coherent when a representative set of missions can demonstrate that:
1. The player has meaningful choices beyond combat where the context supports them.
2. Evidence is distinguishable from inference and can remain uncertain.
3. Protecting civilians is a meaningful objective with specific consequences.
4. Combat is readable and serves the mission context.
5. Retreat or partial failure can produce a coherent continuation where the story permits.
6. Ember helps without replacing player judgment or solving every clue.
7. Faith and church activities remain meaningful without becoming mechanical currencies or buffs.
8. Progression reflects capability and responsibility, not spiritual worth.
9. NPCs react according to plausible knowledge and context.
10. The world remains recognizable as BTV and preserves established canon.

---

**End of Core Gameplay Specification v1.0**