# PDF text extraction — BTV_Mavis_Technical_Creative_Handoff_v1.0.pdf

> **ARCHIVAL REFERENCE.** Extracted text from the original Library PDF. Treat as historical/proposal material unless current canon or later creator decisions confirm it. The original PDF remains in ChatGPT Library. PDF layout, typography, diagrams and embedded images are not represented by this text extraction.

- Source file: `BTV_Mavis_Technical_Creative_Handoff_v1.0.pdf`
- Extraction: complete according to Files read result (`has_more=false`)

---

<PARSED TEXT FOR PAGE: 1 / 13>
                                       BEYOND THE VEIL:
                                       THE LAST WATCH
                             TECHNICAL & CREATIVE HANDOFF SPECIFICATION


                                  Prepared for Mavis (MCode) · MiniMax-M3.1-Flash

                             Prepared by ChatGPT · 02 November 2026 · Version 1.0




   Purpose
   A self-contained working brief for executable systems modelling, data design, browser-playable prototypes, technical
   review and production artifacts. It preserves BTV canon while making the limits of current design explicit.




Critical status statement
This is a design handoff, not proof of a playable build. The latest inspected repository evidence showed a small public GitHub
repository with a README and documentation only; no Godot project structure, native build, or tested implementation was
evidenced. The current engine remains unconfirmed in the authoritative design record.




CONFIDENTIAL WORKING PROJECT DOCUMENT · CREATOR AUTHORITY RESERVED




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                             Page 1
<PARSED TEXT FOR PAGE: 2 / 13>
Document control
  Field                                                                        Value

  Project                                                                      Beyond the Veil: The Last Watch (BTV)

  Recipient                                                                    Mavis / MCode — MiniMax-M3.1-Flash

  Document                                                                     Technical & Creative Handoff Specification

  Version / date                                                               v1.0 / 02 November 2026

  Authority                                                                    Human creator decisions and corrections; BTV Master Canon v1.0;
                                                                               domain-specific Bibles

  Purpose                                                                      Enable modelling, structured data, prototypes and technical recommendations
                                                                               without silently creating canon

  Current implementation status                                                UNKNOWN / NOT VERIFIED. Do not claim code, integration, tests or playable
                                                                               build without evidence.



Status vocabulary
  Label                                            Meaning                                               Mavis action

  CONFIRMED / CANON                                Established by creator or controlling BTV source.     Preserve; do not alter without creator decision.

  APPROVED DESIGN                                  Creator-approved design principle; not proof of       May implement within scope; retain approval label.
                                                   implementation.

  CANON DIRECTION                                  Accepted direction, exact mechanics/details open.     Use as constraint; do not invent missing values as
                                                                                                         canon.

  PROPOSED                                         Technical/design recommendation awaiting human        Prototype or simulate in an isolated branch; do not
                                                   approval.                                             merge into canon.

  UNKNOWN / OPEN                                   Not established.                                      Record as blank; ask only when blocking.

  RESERVED                                         Intentionally held for creator collaboration.         Do not decide or implement final form.

  CONFLICT                                         Contradicts higher authority or another source.       Stop affected work and report exact conflict.

  [REQUIRES_EDITOR]                                Needs Godot/Unity/Unreal editor, native build or      Prepare files/instructions; hand off to human.
                                                   real-device validation.


Authority order: latest explicit creator decision/correction → BTV Master Canon → relevant specialized Bible within its domain →
this handoff's proposals. When sources conflict, record the conflict; do not blend incompatible versions.

The source Bibles are reference authorities, not proof that their content is integrated into a single project repository or game build.


1. PROJECT IDENTITY, CREATIVE INTENT & WORLD
1.1 Core identity — CONFIRMED
Title: Beyond the Veil: The Last Watch (BTV).

Genre: Modern Christian action-adventure survival RPG.

World structure: Large, interconnected, semi-open modern world; not an unrestricted seamless open world by requirement.

Platforms: PC and Android/mobile are considered from the beginning. Android-first small prototype is a production preference,
not a confirmed engine or shipping commitment.

Core identity: Christian worldview, spiritual conflict, investigation, survival, service, community, leadership, responsibility,
redemption and restoration.

BTV is not a Bible retelling. Biblical themes and Christian worldview inform the original fictional world; BTV must not reproduce
another game's plot, characters, setting, distinctive terminology, signature mechanics or copyrighted assets.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                                          Page 2
<PARSED TEXT FOR PAGE: 3 / 13>
1.2 Creative pillars
  Pillar                                                           Design consequence

  Christ-centred Christian integrity                               God is ultimate authority; Christ is above the Covenant and the Chosen. Never
                                                                   imply fictional characters or systems supersede Christ.

  People before objectives                                         Civilians and communities matter; rescue, care, restoration and consequences
                                                                   can be central gameplay.

  Discernment before certainty                                     The Veil may create uncertainty; investigation, evidence and cautious
                                                                   interpretation matter.

  Action with purpose                                              Combat is one tool, not the default solution or universal reward path.

  Responsibility with capability                                   Leadership and growth reflect service, judgment, trust and responsibility—not
                                                                   merely kills or currency.

  Original identity                                                Quality references are principles only; do not copy protected expression from
                                                                   other games.



1.3 Quality references — inspiration only
The creator has cited The Witcher, Red Dead Redemption 2, Elden Ring, Cyberpunk, God of War, Baldur's Gate 3, Ghost of
Tsushima, Zelda: Breath of the Wild and Black Myth as quality references. Extract broad principles such as world reactivity,
meaningful exploration, readable combat, character depth and environmental storytelling. Do not clone their content or signature
expression.

1.4 World and population
• World spaces include urban, rural, wilderness, community, institutional, Covenant and Veil-influenced environments.

• Public spaces should contain substantially more civilians than Covenant personnel, except in Covenant facilities or crisis
contexts.

• NPCs have plausible routines, relationships, needs, knowledge limits and lives independent of the player.

• Regional geography, named cities, settlements, map topology, transport model and density numbers remain UNKNOWN.

1.5 Narrative tone
The narrative should balance danger with quiet moments. Themes include truth versus deception, faith versus fear, light versus
darkness, spiritual warfare, service, sacrifice, compassion, redemption, restoration, discernment and responsibility. Characters
may be emotionally complex; faith does not make them flawless or emotionless.


2. CANON CHARACTERS, COVENANT & EMBER
2.1 Asher Vance — CONFIRMED
  Field                                                            Established value

  Name                                                             Asher Vance

  Age                                                              16–19 years (int range; exact age UNKNOWN)

  Role                                                             The Chosen; Covenant-trained field member

  Leadership trajectory                                            Field role → Team Leader → Commander → General

  Growth basis                                                     Service, responsibility, decisions, trust, leadership and demonstrated
                                                                   capability

  Guardrails                                                       Human; not divine, infallible, spiritually superior, source of God's authority, or
                                                                   replacement for Christ or the Church


Exact age, appearance, birthplace, family history, detailed biography, personality, hobbies, fears, weaknesses, early Covenant
history, Chosen-selection circumstances, combat style and dialogue voice remain UNKNOWN.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                                 Page 3
<PARSED TEXT FOR PAGE: 4 / 13>
2.2 The Chosen — unresolved decision
The earlier selectable male/female Chosen concept remains UNKNOWN and requires creator decision. Do not invent a second
Chosen's identity, biography, appearance, personality, selection mechanics, relationship to Asher, or whether both exist
simultaneously.

2.3 The Covenant — CONFIRMED
A hidden service/protection organization serving God and protecting people. It is not the Church, all of Christianity, a government
agency, Christ or God. Rank represents responsibility and trust, never spiritual superiority.

  Rank order                                                       Meaning

  1. Recruit                                                       Entry / training stage; exact requirements UNKNOWN.

  2. Agent / Specialist                                            Operational service; exact grade structure UNKNOWN.

  3. Team Leader                                                   Leads a field team; scope and requirements UNKNOWN.

  4. Commander                                                     Higher operational responsibility; scope and requirements UNKNOWN.

  5. General                                                       Senior leadership; exact structure and named officeholders UNKNOWN.


  Branch                                                           Function

  Guardians                                                        Combat/protection; courage, discipline, restraint and responsibility.

  Messengers                                                       Communication, evangelism/outreach, listening, truth and discernment.

  Watchers                                                         Investigation/intelligence, observation, evidence and analysis.

  Shepherds                                                        Rescue, support, restoration, care and recovery.

  Scouts                                                           Reconnaissance, mobility, observation, adaptability and reporting.

  Keepers                                                          Equipment, resources, logistics, preparation, stewardship and maintenance.



Covenant Oath — exact wording
   “By truth we stand.
   By faith we endure.
   By the Light we rise.
   Darkness will not prevail.”

2.4 Ember — CONFIRMED foundation
Ember is a male companion and field partner to Asher, from a rare original canid lineage with natural created origin and long-term
Veil exposure. He has innate but limited Veil sensitivity. He is not an artificial/occult creation, divine being, omniscient guide or
replacement for God, Christ, Scripture, prayer or the Holy Spirit.

  Dimension                                                        Established design

  Development dimensions                                           Bond, Training, Instinct, Veil Sensitivity, Physical Development (five
                                                                   dimensions; exact thresholds UNKNOWN).

  Progression                                                      No conventional RPG skill tree.

  AI                                                               Layered, context-aware behavioral architecture; exact implementation OPEN.

  Commands                                                         Contextual and priority-aware; detailed command list/priority numbers OPEN.

  Behavior                                                         Natural animal behavior; survival and protection priorities; meaningful
                                                                   memory.

  Relationship                                                     Progressive trust and learned cooperation; not an inventory item.


Exact appearance, birthplace, original pack/family, first meeting, Covenant classification, animations, UI, AI implementation,
thresholds and physical growth schedule remain OPEN.

2.5 Named cast and antagonists
Named Covenant leadership, named teammates, mentors, named civilians, named antagonists and the main antagonist are
UNKNOWN. Do not fabricate names and present them as canon.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                             Page 4
<PARSED TEXT FOR PAGE: 5 / 13>
3. CHRISTIAN WORLDVIEW, FAITH, PRAYER, ARMOR &
CHURCH
3.1 Non-negotiable theological boundaries — CONFIRMED
• God is the ultimate authority; Christ is above every fictional system, the Covenant and the Chosen.

• The Holy Spirit is not a player-controlled combat resource or controllable attack.

• Prayer is not a transaction, spell list, or guaranteed player-triggered supernatural effect.

• Faith, salvation, grace, divine favor, holiness and spiritual worth are never purchasable, tradable, grindable or represented as
spendable resources.

• Do not implement Scripture as a damage cheat code, faith as mana, salvation as loot, grace as currency, or church/Communion
as stat farms.

• Covenant rank is not a measure of holiness. Church and Covenant are distinct.

3.2 Armor of God — canonical components
  Component                                                          Status / known meaning

  Belt of Truth                                                      Component is established; exact gameplay/stat behavior OPEN.

  Breastplate of Righteousness                                       Component is established; exact gameplay/stat behavior OPEN.

  Shoes of the Gospel of Peace                                       Component is established; exact gameplay/stat behavior OPEN.

  Shield of Faith                                                    Component is established; exact gameplay/stat behavior OPEN.

  Helmet of Salvation                                                Component is established; exact gameplay/stat behavior OPEN.

  Sword of the Spirit                                                Component is established; combat expression and implementation OPEN.


Do not invent equipment stats, acquisition order, rarity, upgrades, cooldowns or numerical combat effects. These require a
creator-approved gameplay specification and theological review.

3.3 Prayer and Scripture
Prayer interaction, UI, outcomes and exact mechanics remain OPEN. Prayer must feel like prayer, not a player-controlled vending
machine for buffs. Scripture references and quotations must be accurate and contextual; research informs accuracy but does not
automatically become BTV canon.

3.4 Church, HCI, KITFIT and Communion
• Churches are living communities with worship, teaching, fellowship, service, ordinary work, relationships, celebration, grief,
disagreement and care.

• Harvest Chapel International (HCI) is a real-world inspiration. Degree of direct institutional representation is UNKNOWN; do not
invent endorsements, leadership, doctrine, policies or official in-game identities.

• KITFIT occurs before preaching and includes Scripture plus a short teaching/message about giving. Exact acronym expansion is
UNKNOWN.

• Giving and charity are voluntary; generosity is not measured only by amount.

• First Sunday Communion is established. The Communion Set combines bread and wine and may be used only within a
CommunionContextZone.

• Communion is reflective/contextual and gives no buffs, XP, health, stat increase or purchasable spiritual advantage.

• Exact service order and HCI representation level remain UNKNOWN.

3.5 Spiritual guidance
Guidance may shape interpretation, choices, atmosphere and narrative possibilities. It is not an omniscient navigation system and
should not be reduced to a controllable combat ability.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                        Page 5
<PARSED TEXT FOR PAGE: 6 / 13>
4. THE VEIL, ENEMY TAXONOMY & ENCOUNTERS
4.1 The Veil — established role
The Veil is a central supernatural/worldbuilding concept that may influence locations, perception, enemies, information,
environments, events and investigations. It is not a generic fantasy portal and must retain a distinctive BTV identity. Its origin,
metaphysics, history, rules, limitations and ultimate nature are UNKNOWN.

4.2 Enemy classes — CONFIRMED taxonomy
  Class                                                              Status / high-level role

  Destroyers                                                         Established enemy class; specific archetypes, behavior and mechanics
                                                                     require design.

  Persuaders                                                         Established enemy class; specific archetypes, behavior and mechanics
                                                                     require design.

  Deceivers                                                          Established enemy class; specific archetypes, behavior and mechanics
                                                                     require design.

  Commanders / Bosses                                                Established high-level enemy class; named entities and encounter structures
                                                                     UNKNOWN.


Enemy origins, hierarchy, named entities, communication/languages, exact supernatural abilities, weaknesses, Antichrist-related
implementation and Seven Deadly Sins implementation remain OPEN/UNKNOWN.

4.3 Structured enemy data contract
Mavis may create schema validators and blank data tables now. Populate numerical values only after an explicit PROPOSED
balance model is separately labelled and isolated from canon.
   {
   "enemy_id": "string",
   "name": "string",
   "class": "Destroyer|Persuader|Deceiver|CommanderBoss",
   "status": "CANON|PROPOSED|UNKNOWN",
   "hp": null,
   "atk": null,
   "def": null,
   "speed": null,
   "ai_behavior": [],
   "abilities": [],
   "status_resistances": [],
   "drop_table_id": null,
   "xp": null,
   "narrative_role": "string",
   "civilian_risk": "UNKNOWN",
   "notes": "Do not invent canon"
   }


4.4 Encounter data contract
   {
   "encounter_id": "string",
   "location_tag": "string",
   "mission_context": "string",
   "enemy_group": [],
   "environment_tags": [],
   "civilian_presence": "UNKNOWN",
   "objectives": [],
   "noncombat_routes": [],
   "difficulty_profile": "UNKNOWN",
   "reward_table_id": null,
   "status": "PROPOSED|UNKNOWN"
   }

No approved enemy HP/ATK/DEF/speed, encounter frequency, spawn weights, drop rates, XP, resistance, status-effect values or
boss phases were found in the current source set. Keep these null/UNKNOWN; do not use placeholder numbers as design truth.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                            Page 6
<PARSED TEXT FOR PAGE: 7 / 13>
5. GAMEPLAY SYSTEMS, STATUS EFFECTS & COMBAT
5.1 Combat status
A complete combat model is not established. This is the largest technical gap for a combat prototype. Mavis may produce a
clearly labelled PROPOSED combat sandbox, but the human creator must approve the direction before it becomes BTV canon.

5.2 Required status-effect schema
  Field                                            Type                                  Definition

  status_id                                        string                                Stable identifier.

  name                                             string                                Player-facing label.

  duration_turns                                   int|null                              Duration in turns; null if real-time/unknown.

  duration_seconds                                 float|null                            Duration in seconds; null if turn-based/unknown.

  stack_rule                                       enum                                  Refresh | StackMagnitude | StackDuration |
                                                                                         Replace | Ignore | Unique.

  magnitude                                        float|null                            Effect strength; unit must be specified.

  tick_behavior                                    enum                                  OnApply | TurnStart | TurnEnd | RealTimeInterval |
                                                                                         OnEvent | None.

  tick_interval                                    float|null                            Seconds or turns, explicitly declared.

  affected_targets                                 enum[]                                Player | Ally | Enemy | NPC | Area.

  source                                           string|null                           Ability/item/environment/source identifier.

  cleansable                                       bool|null                             Whether a cleanse can remove it; UNKNOWN until
                                                                                         designed.

  status                                           enum                                  PROPOSED | UNKNOWN | APPROVED.


No status effects are currently locked with numerical duration, magnitude or stacking behavior. The table above is a data contract,
not a list of approved effects.

5.3 Proposed combat resolver — sandbox only
The following is a test harness contract, not a canon formula. Mavis may compare candidate formulas, log assumptions and run
simulations; no candidate becomes official without creator approval.
   # PROPOSED SANDBOX ONLY — NOT CANON
   raw_damage = max(
   MIN_DAMAGE,
   (attacker.ATK * (1 + attacker.STR / STR_SCALE)
   - defender.DEF * DEF_WEIGHT)
   * element_multiplier
   )
   final_damage = max(MIN_DAMAGE, round(raw_damage * mitigation_multiplier))
   target.HP = max(0, target.HP - final_damage)

   # All constants are deliberately unset:
   MIN_DAMAGE = UNKNOWN
   STR_SCALE = UNKNOWN
   DEF_WEIGHT = UNKNOWN
   element_multiplier = PROPOSED_TABLE_REQUIRED
   mitigation_multiplier = PROPOSED_TABLE_REQUIRED


5.4 Gameplay loop candidates
Recognized mission objectives include protecting civilians, rescuing, gathering evidence, investigating anomalies, escorting,
evacuating, repairing, restoring, communicating, negotiating, scouting, defending, pursuing, containing and fighting. Non-combat
routes may include dialogue, de-escalation, investigation, stealth/avoidance, rescue, evacuation, protection, pursuit or withdrawal.

Do not reduce every mission to travel → kill → collect. Combat should serve the mission context, not exist solely to generate XP
or loot.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                         Page 7
<PARSED TEXT FOR PAGE: 8 / 13>
5.5 Inventory and equipment
Inventory architecture, slots, weight/capacity, durability, rarity, crafting, equipment upgrades, item prices, ammunition/resource
rules and save persistence are UNKNOWN. Do not choose final values. A prototype can test a minimal data-driven inventory
using dummy items clearly labelled PROPOSED.


6. MISSIONS, PROGRESSION, ECONOMY & WORLD
REACTIVITY
6.1 Mission categories — established
  Category                                                         Purpose / examples

  Rescue                                                           Protect, locate, evacuate or assist people.

  Investigation                                                    Gather evidence, compare accounts, inspect anomalies.

  Evangelism / Outreach                                            Communication, listening, outreach; never coercive.

  Restoration                                                      Repair services, relationships, places or community conditions.

  Battle Operations                                                Combat where justified by context and objectives.

  Scout Operations                                                 Reconnaissance, observation and reporting.

  Community Help                                                   Practical assistance and local problem-solving.

  Veil Investigations                                              Investigate Veil-influenced events with evidence and discernment.



6.2 Progression principles — APPROVED DESIGN
• Keep practical capability, Covenant responsibility, Ember growth, contextual relationships and knowledge progression distinct.

• None of these dimensions measures spiritual worth.

• Promotion reflects demonstrated responsibility, judgment, service, leadership and trust—not kills or currency alone.

• Failed missions may teach through consequences, evidence, relationships and changed circumstances; failure need not mean
automatic game over.

• Exact mission list/chronology, promotion timing, rank requirements, XP/level system, level cap, skill trees, equipment upgrades,
Armor acquisition order and difficulty scaling remain UNKNOWN.

6.3 Economy — CONFIRMED / APPROVED DESIGN
  Resource category                                                Established rule

  Aces                                                             General-world currency for ordinary goods/services.

  Covenant Credits                                                 Covenant-focused currency for authorized resources/services where fiction
                                                                   supports it; not interchangeable with Aces by default.

  Non-monetary outcomes                                            Information, trust, access, rescued people, restored services, relationships,
                                                                   new missions and world-state changes.


• Do not add unnecessary currencies.

• Do not reward violence as the universally most profitable approach.

• Do not pay the player for prayer, worship, Scripture recitation, Communion, conversion or generosity.

• Do not turn charity into a financial optimization minigame.

• Avoid inflationary rewards and compulsory grinding for routine story progress.

• Where appropriate, show who authorized a reward and why.

6.4 World recovery — APPROVED DESIGN
Rescue, investigation, restoration and community outcomes may change future access, NPC reactions, available information,
services, safety and local conditions. Consequences should be proportionate and understandable.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                              Page 8
<PARSED TEXT FOR PAGE: 9 / 13>
6.5 Structured mission and reward schemas
   {
   "mission_id": "string",
   "title": "string",
   "category": ["Rescue"],
   "location_id": null,
   "objectives": [],
   "known_information": [],
   "uncertainties": [],
   "npc_ids": [],
   "enemy_encounter_ids": [],
   "civilian_impact": "UNKNOWN",
   "approaches": ["PROPOSED"],
   "rewards": [],
   "consequences": [],
   "status": "PROPOSED|UNKNOWN|APPROVED"
   }

   {
   "reward_id": "string",
   "category": "Aces|CovenantCredits|NonMonetary",
   "amount": null,
   "unit": "UNKNOWN",
   "source_or_authorizer": "UNKNOWN",
   "conditions": [],
   "faith_boundary_check": true,
   "status": "PROPOSED|UNKNOWN|APPROVED"
   }



7. VISUAL IDENTITY, UI, HUD & AUDIO
7.1 Known visual direction
• Covenant visual language: white with restrained gold and cross insignia.

• Variants may include tactical, formal, stealth and weather-appropriate clothing.

• HUD should be reactive to context rather than permanently cluttered.

• The visual identity should communicate a modern Christian service organization without turning the Covenant into a generic
military faction.

7.2 Open visual/UI decisions
Exact character models, clothing meshes, insignia geometry, palette values, typography, HUD layout, iconography, accessibility
settings, camera model, animation set, audio identity, music direction and UI interaction details are not fully specified in the
available source set. Treat these as PROPOSED until approved.

7.3 Asset production guidance
Mavis can generate concept sheets, UI mockups, portraits, icons, ambience and original audio assets. Label generated concept
assets as PROPOSED. Do not use copyrighted game assets or imitate a living artist's exact style. No generated asset is
integrated into an engine project until the human performs the required import/in-editor work.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                            Page 9
<PARSED TEXT FOR PAGE: 10 / 13>
8. TECHNICAL HANDOFF, DATA CONTRACTS &
VERIFICATION
8.1 Mavis capability boundary
  Can do                                                                   Cannot do

  Execute Python (pandas, numpy, matplotlib, openpyxl, python-docx,        Run Godot/Unity/Unreal editor.
  python-pptx, reportlab, pypdf), Node 22, bash, git, jq, ripgrep.

  Use headless Chromium via Playwright; build self-contained HTML/CSS/JS   Compile or ship a native build.
  prototypes.

  Run thousands of balance/encounter simulations; produce CSV/JSON/XLSX    Test on a real Android or PC device.
  and reports.

  Write/review engine code and research with live web sources.             Open a connection to the project/repository unless the human explicitly
                                                                           supplies access or files.

  Generate images/audio/video and documents.                               Claim in-editor integration, native build success or device validation without
                                                                           human evidence.



8.2 Suggested work discipline
• Start with read-only discovery of all supplied files and repository state; report exact branch, commit, tree and file inventory.

• Preserve existing work. Do not overwrite, delete, force-push, publish, deploy, purchase credits or change permissions.

• Separate canon, approved design, proposal and unknown in every artifact and data row.

• Prefer small, testable modules and data-driven JSON/CSV tables.

• Use reproducible simulations with recorded random seed, trial count, assumptions, version and output.

• Keep prototype code isolated from authoritative source docs until human approval.

• Report documentation, implementation, integration, verification and acceptance as separate gates.

8.3 Suggested repository-neutral structure — PROPOSED
   /btv-handoff/
   /canon/ # read-only copies or references
   /schemas/ # JSON Schema / CSV headers
   /data/proposed/ # all unapproved numbers clearly isolated
   /simulations/ # scripts, seeds, configs, outputs
   /prototype/web/ # self-contained HTML/CSS/JS
   /prototype/tests/ # automated tests
   /reports/ # balance and verification reports
   /engine-adapters/ # code prepared for human integration
   README.md
   STATUS.md
   CHANGELOG.md


8.4 Data typing rules
  Data                                                Type                                             Rule

  IDs                                                 string                                           Stable, unique, machine-readable.

  HP / ATK / DEF                                      int or float                                     Unitless combat points unless a unit is defined; do
                                                                                                       not fill without approval.

  Speed                                               float                                            Declare whether turn initiative, m/s, or another unit.

  Duration                                            int or float                                     Always specify turns or seconds.

  Drop probability                                    float                                            Range [0.0, 1.0]; no approved values currently.

  Currency                                            int or decimal                                   Declare denomination and rounding rule; prices are
                                                                                                       UNKNOWN.

  Status                                              enum                                             Use the status vocabulary in this document.

  Lists                                               array                                            Use stable IDs for cross-references.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                                      Page 10
<PARSED TEXT FOR PAGE: 11 / 13>
8.5 Verification report minimum
• Artifact name, version, date, owner and commit/hash (if applicable).

• Environment and tool versions.

• Test command, exact test count, pass/fail count and logs.

• Simulation trial count, random seed(s), assumptions and confidence intervals where useful.

• Known limitations and [REQUIRES_EDITOR] tasks.

• Explicit statement of what was not tested.

8.6 Project/repository status snapshot — 02 Nov 2026
Latest available read-only repository check identified a public repository named KINGACEX/beyond-the-veil-last-watch- (default
branch main; reported repository size 1 KB). The root exposed README.md and a documentation item. The README described
BTV but did not evidence a Godot project structure or playable implementation. Earlier project discovery also found design
documents but no verified native project folder. Therefore: repository exists, playable project/build NOT VERIFIED,
engine/editor NOT CONFIRMED, tests NOT VERIFIED.

A prior plan named Godot and an Android-first prototype, with later PC scalability, but this remains a proposed/declared direction
unless the creator confirms the engine choice. Do not assume a working project merely because a local environment appears
normal.

8.7 Human-only integration gates
Anything requiring the engine editor, native compilation, import settings, Android permissions, device performance, touch feel,
input mapping, rendering pipeline, packaging or real-device testing must be marked [REQUIRES_EDITOR]. Mavis should provide
exact files, steps and expected results for the human to execute.


9. NOT DECIDED YET — EXPLICIT UNKNOWN REGISTER
This section is intentionally explicit. A blank or absent field elsewhere must not be interpreted as permission to invent it.

  Area                                                               Not decided / not verified

  Engine / project                                                   Final engine confirmation; repository write access; authoritative project folder;
                                                                     project architecture; native build status.

  Combat                                                             Core combat loop; attack/defense timing; targeting; stamina/resource model;
                                                                     damage formula; hitboxes; animation cancel; player/enemy stats.

  Status effects                                                     Approved effect list; durations; stacking; magnitude; tick timing; cleanse rules;
                                                                     resistances.

  Enemies                                                            Named enemy roster; exact AI; HP/ATK/DEF/speed; abilities; weaknesses;
                                                                     resistances; XP; drops; boss phases.

  Encounters                                                         Spawn rules; frequency; group size; location tables; encounter pacing;
                                                                     civilian-risk rules; difficulty curve.

  Progression                                                        XP/levels; caps; skills; unlocks; equipment progression; rank
                                                                     requirements/timing; exact promotion process.

  Economy                                                            Prices; Aces earning rates; Covenant Credit issuance/spending; scarcity; loot
                                                                     values; reward amounts; anti-exploit model.

  Inventory                                                          Slots; weight; capacity; durability; rarity; crafting; consumables; equipment
                                                                     restrictions; save schema.

  Missions                                                           Complete mission list; chronology; named locations; quest graph; exact
                                                                     branching; failure/retry/checkpoint behavior.

  World                                                              Named cities, districts, settlements, map, travel, transport, time/weather
                                                                     simulation, population counts.

  Veil                                                               Origin, metaphysics, history, limits, detailed rules, exact enemy origins and
                                                                     hierarchy.

  Characters                                                         Exact Asher age/profile/voice; dual-Chosen decision; named leaders,
                                                                     teammates, mentors, civilians and antagonists.

  Ember                                                              Exact appearance, birthplace, family/pack, first meeting, thresholds, growth
                                                                     schedule, animations and implementation.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                                  Page 11
<PARSED TEXT FOR PAGE: 12 / 13>
  Area                                                             Not decided / not verified

  Faith / Armor                                                    Prayer interaction/outcomes; Armor stats/acquisition order; Sword/Shield
                                                                   mechanics; exact Scripture placement.

  Church / HCI                                                     Direct HCI representation; exact service order; KITFIT expansion; named
                                                                   leadership/congregations.

  Presentation                                                     Final visual bible; exact UI/HUD layout; audio/music direction; accessibility
                                                                   settings; camera and control scheme.

  Platform                                                         Final Android/PC minimum specs; input model; performance budgets; save
                                                                   sync; store/distribution plan.

  Production                                                       Vertical-slice scope; acceptance criteria; milestone dates; budget; external
                                                                   asset/tool costs.



9.1 No invented numerical canon
There are currently no approved numerical enemy stat rows, combat coefficients, encounter weights, status-effect
magnitudes/durations, drop probabilities, XP curves, item prices or progression thresholds in the inspected source set. Mavis
should build the schema, test harness and simulation framework with null/unknown inputs, then create separately labelled
PROPOSED parameter sets only when a useful test requires them.

9.2 Reserved creator decisions
Do not independently settle story/character/Christian-identity decisions, direct HCI representation, dual-Chosen structure, Veil
metaphysics, named major characters, final visual/UI/audio/accessibility direction or the final combat feel. Mavis may prepare
alternatives and trade-off analyses for the human.


10. HANDOFF PRIORITIES
Priority 1 — Read-only source and repository audit
Inventory every supplied BTV document and repository file, extract source versions and authority, detect contradictions, and
produce a machine-readable canon/status register before implementation; the project folder and current integration state are not
yet verified.

Priority 2 — Data schemas and a simulation-ready balance workbook
Create validated JSON Schemas/CSV templates for enemies, abilities, status effects, encounters, missions, rewards, items and
progression, with all undecided numeric fields null; build a Python simulation harness that can compare clearly labelled
PROPOSED parameter sets without contaminating canon.

Priority 3 — A small browser-playable core-loop prototype, only after the human
approves a proposed combat direction
Build a self-contained HTML/CSS/JS prototype to test interaction, readability and pacing, but keep it explicitly experimental and
do not treat its combat numbers, UI or feel as approved BTV design.
   Thin-spec warning: The current BTV specification is too thin to build a faithful final combat system, enemy roster,
   progression curve, status-effect catalogue, encounter director, economy balance or complete mission campaign. Mavis
   can build schemas, test harnesses and isolated prototypes; these systems need creator-approved numerical and
   experiential decisions before production implementation.


Appendix A — Source documents consulted
• BTV_Master_Canon_v1.0.md — primary content canon; includes creator-approved economy/progression and
production-discipline addendum dated 11 Oct 2026.

• BTV_Story_and_Lore_Bible_v1.0.md — narrative authority and story/lore unknown register.

• BTV_Character_Bible_v1.0.md — Asher, Chosen, Covenant character boundaries and character unknowns.

• BTV_Faith_Prayer_Armor_of_God_Bible_v1.0.md — faith, prayer, Armor and theological boundaries.

• BTV_Church_HCI_Service_Communion_Bible_v1.0.md — church, HCI, KITFIT, giving and Communion boundaries.




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                                             Page 12
<PARSED TEXT FOR PAGE: 13 / 13>
• BTV_Veil_Enemy_Encyclopedia_v1.0.md — Veil/enemy taxonomy and supernatural unknowns.

• BTV_World_NPC_Bible_v1.0.md — world, population and NPC principles.

• BTV_Mission_Progression_Economy_Bible_v1.0.md — mission, progression, rewards and economy.

• BTV_Foundation_11_Ember_Companion_Bible_v1.0.pdf — Ember foundation and open implementation details.

• BTV_Economy_Progression_and_Production_Readiness_v1.0.md — status vocabulary and production evidence gates.


Appendix B — Acceptance checklist for Mavis
• No UNKNOWN or RESERVED detail was silently promoted to canon.

• All proposed numeric values are labelled PROPOSED and stored separately.

• Every numeric field has a data type and unit or an explicit UNKNOWN marker.

• Every formula names all constants and defines rounding/clamping behavior.

• Enemy, encounter and status-effect data are structured and machine-readable.

• Simulation scripts record seed, trial count, assumptions and output files.

• Browser prototype is isolated and runs in headless Chromium with repeatable tests.

• No destructive repository or publishing action was taken.

• All editor/device tasks are marked [REQUIRES_EDITOR].

• Documentation, implementation, integration, verification and acceptance are reported separately.

END OF HANDOFF SPECIFICATION




BTV | Mavis / MCode handoff | v1.0 | 02 Nov 2026                                                                Page 13
