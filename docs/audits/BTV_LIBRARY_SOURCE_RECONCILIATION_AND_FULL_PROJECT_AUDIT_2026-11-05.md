# BTV Library Source Reconciliation & Whole-Project Design Audit

**Audit date:** 2026-11-05  
**Project:** Beyond the Veil: The Last Watch (BTV)  
**Repository:** KINGACEX/beyond-the-veil-last-watch-  
**Branch:** btv/bootstrap-prototype-001  
**Audit type:** Library source recovery, canon reconciliation, cross-domain design review, loophole/risk review  
**Code changes:** None  
**Source-document restoration:** 22 Markdown documents / 10,736 lines imported from the ChatGPT Library  
**Overall result:** SOURCE RECOVERY COMPLETED; DESIGN RECONCILIATION PARTIALLY COMPLETED; IMPLEMENTATION AND TEST CERTIFICATION NOT CLAIMED.

---

## 1. Executive conclusion

The original BTV design material was not absent. It was distributed across the ChatGPT Library, including the dedicated /BTV folder, the Game Development folder, root-level BTV files, older DOCX/PDF handoffs, visual concept images and a Godot-ready Asher asset package.

The previous repository-only audit was correct that these documents were missing from the GitHub tree, but its conclusion that the original sources were unavailable was incomplete. The Library search recovered the current Master Canon, the Story & Lore Bible, the Character Bible, Covenant Bible, Faith/Prayer/Armor Bible, Church/HCI Bible, Veil/Enemy Encyclopedia, World/NPC Bible, Mission/Progression/Economy Bible, Master Development Handoff, visual/UI references, the vertical-slice and Ridgeview design, investigation/evidence design, NLI specification and related production documents.

**The recovered Markdown source documents have now been copied into the repository** under docs/source-of-truth/. They were imported as source text, not rewritten summaries. The source index is [docs/source-of-truth/README.md](../source-of-truth/README.md).

The most important result of reading the sources is that BTV has several **known cross-document conflicts and stale records**. These are not reasons to discard the project. They are reasons to apply the correct authority order and update lower-authority documents and visual mockups before implementation.

### Overall status

- **COMPLETED:** Located and restored 22 relevant Markdown source documents from the ChatGPT Library.
- **COMPLETED:** Reviewed the current canon hierarchy and major cross-domain decisions; identified specific stale or contradictory source records.
- **CONFIRMED:** Canon Reconciliation & Story/Veil Decisions v1.1 is the controlling reconciliation addendum for the decisions it explicitly resolves.
- **CONFIRMED:** The current source set distinguishes CANON, APPROVED DESIGN, CANON DIRECTION, PROPOSED, RESERVED, UNKNOWN and CONFLICT. These states must not be collapsed into one generic “approved” label.
- **PROPOSED:** The feature-level universal loophole gate and acceptance matrix in this report.
- **BLOCKED:** Final canon certification of every legacy DOCX/PDF/image and complete resolution of all open decisions. Some legacy files and visual assets were sampled and compared; not every binary Library item was examined line by line.
- **BLOCKED:** Gameplay acceptance, Android/PC readiness, save/load correctness, performance, accessibility and release readiness. This is a document audit; no game build or device test was run in this task.
- **NOT CLAIMED:** Zero loopholes, complete theological correctness, complete historical/language accuracy, a completed vertical slice or a production-ready game.

---

## 2. Audit method and coverage

### 2.1 Sources inspected

The audit used:

1. Semantic search of the ChatGPT Library for BTV canon, story, design, technical, visual, handoff and proposal material.
2. Recursive inventory of the Library's /BTV and Game Development folders.
3. Full-text retrieval of the 22 Markdown documents imported below. The most consequential sections—authority, status, open registers, cross-document decisions, feature boundaries and acceptance criteria—were compared directly.
4. Selected legacy DOCX records, including the older consolidated master-canon and recent-additions/visual-uniform records.
5. Selected concept images: Asher character sheet, Faith Codex, app screens, app showcase and Last Watch showcase.
6. Inspection of Asher_Vance_Godot_Ready.zip.

This method supports a substantial source reconciliation. It does not mean every old PDF, DOCX, generated image, video, asset or previous chat attachment in the entire Library has been individually certified.

### 2.2 Restored source-document inventory

All paths below are in docs/source-of-truth/ on the audited branch.

| Domain | Restored source |
|---|---|
| Primary canon | [Master Canon v1.0](canon/BTV_Master_Canon_v1.0.md) |
| Canon reconciliation | [Canon Reconciliation & Story/Veil Decisions v1.1](canon/BTV_Canon_Reconciliation_and_Story_Veil_Decisions_v1.1.md) |
| Development governance | [Master Development Handoff](governance/BTV_Master_Development_Handoff.md) |
| Story | [Story & Lore Bible v1.0](story/BTV_Story_and_Lore_Bible_v1.0.md) |
| Character | [Character Bible v1.0](characters/BTV_Character_Bible_v1.0.md) |
| Covenant | [Covenant Bible v1.0](covenant/BTV_Covenant_Bible_v1.0.md) |
| Faith | [Faith, Prayer & Armor of God Bible v1.0](faith/BTV_Faith_Prayer_Armor_of_God_Bible_v1.0.md) |
| Church | [Church/HCI/Service/Communion Bible v1.0](church/BTV_Church_HCI_Service_Communion_Bible_v1.0.md) |
| Veil/enemies | [Veil & Enemy Encyclopedia v1.0](veil/BTV_Veil_Enemy_Encyclopedia_v1.0.md) |
| Veil rules | [Veil Rules & Metaphysics Bible v0.1](veil/BTV_Veil_Rules_and_Metaphysics_Bible_v0.1.md) |
| World/NPC | [World & NPC Bible v1.0](world/BTV_World_NPC_Bible_v1.0.md) |
| Missions/economy | [Mission/Progression/Economy Bible v1.0](missions/BTV_Mission_Progression_Economy_Bible_v1.0.md) |
| Gameplay | [Core Gameplay Specification v1.0](gameplay/BTV_Core_Gameplay_Specification_v1.0.md) |
| Vertical slice | [Vertical Slice Specification v0.2](vertical-slice/BTV_Vertical_Slice_Specification_v0.2.md) |
| Ridgeview | [Ridgeview Case Design v0.2](vertical-slice/BTV_Ridgeview_Case_Design_v0.2.md) |
| Investigation | [Investigation & Evidence Bible v0.1](investigation/BTV_Investigation_and_Evidence_Bible_v0.1.md) |
| Mystery control | [Mystery & Revelation Register](investigation/BTV_Mystery_and_Revelation_Register_v0.3.md) |
| NLI | [Natural Language Interaction System Spec v0.1](systems/BTV_Natural_Language_Interaction_System_Spec_v0.1.md) |
| Production | [Economy/Progression/Production Readiness v1.0](production/BTV_Economy_Progression_and_Production_Readiness_v1.0.md) |
| Visual/UI | [Foundation #12 Visual/UI/HUD Bible v1.0](visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.0.md) |
| Visual consistency | [Foundation #12 Visual/UI/HUD Bible v1.1](visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.1_Consistency_Lock.md) |
| Work handoff | [Work Session Handoff — 2026-11-01](handoffs/BTV_Work_Session_Handoff_2026-11-01.md) |

**Import total:** 22 Markdown documents, 10,736 source lines. One duplicate Library copy of the Investigation & Evidence Bible had identical content and was not imported a second time.

### 2.3 Other Library materials found

The Library also contains:

- PDF exports of Master Canon, Story & Lore, Character, Covenant, Faith/Prayer/Armor, World/NPC, Mission/Progression/Economy, Visual/UI/HUD, Master Development Handoff and Ember Companion references.
- Older DOCX records, including:
  - Beyond_the_Veil_FULLY_VERIFIED_MASTER_CANON_AI_DEVELOPMENT_BIBLE.docx
  - Beyond_the_Veil_The_Last_Watch_MASTER_CANON_v2.docx
  - Beyond_the_Veil_Canon_Update_and_Covenant_Uniform_Design.docx
  - Beyond_the_Veil_Recent_Additions_Addendum.docx
  - Beyond_the_Veil_Recent_Additions_and_Covenant_Uniform_Canon.docx
  - Beyond_the_Veil_The_Last_Watch_Full_Game_Description.docx
  - Beyond_the_Veil_The_Last_Watch_Master_AI_Game_Bible.docx
  - Beyond_the_Veil_The_Last_Watch_Master_Game_Bible.docx
  - Beyond_the_Veil_MASTER_AI_HANDOFF_and_CHARACTER_AI_BIBLE.docx
- BTV_AI_Development_Stack.pdf and earlier development handoffs.
- Visual references including Asher Vance Character Showcase Sheet, Beyond the Veil Faith Codex, Beyond the Veil App Showcase, Beyond the Veil: Game App Screens, Beyond the Veil: Last Watch Showcase and other title/character/environment images.
- Asher_Vance_Godot_Ready.zip.

These are useful historical or visual references, but they are not automatically current canon. The imported Markdown source set is the working source baseline; the legacy binary material should be reconciled and selectively archived in a later pass.

---

## 3. Authority and status rules

### 3.1 Current source authority

Use the authority order stated in Canon Reconciliation v1.1:

1. The creator's latest explicit instruction or correction.
2. The Master Canon as reconciled by accepted creator decisions.
3. Specialized Bibles within their own domains.
4. The Vertical Slice Specification for its explicitly locked slice details; it cannot silently rewrite global canon.
5. Older handoffs, prompts, prototypes, mockups and generated assets.

When sources conflict, do not blend them into a new third version. Record the conflict, follow the higher-authority source and create a correction task for the lower-authority source.

### 3.2 Keep canon status separate from delivery status

The source documents use several canon/design labels:

- **CANON:** established and protected.
- **APPROVED DESIGN:** approved design direction; not proof of implementation or testing.
- **CANON DIRECTION:** firm creative direction with details still open.
- **RESERVED:** deliberately deferred; do not implement prematurely.
- **PROPOSED:** recommendation awaiting approval.
- **UNKNOWN / CREATOR DECISION REQUIRED:** not established; do not invent.
- **CONFLICT:** inconsistent with a higher-authority source.

The project's delivery tracking labels are separate:

- **CONFIRMED:** supported by a source or direct observation.
- **PROPOSED:** recommended next design or implementation step.
- **UNKNOWN:** not established.
- **BLOCKED:** a dependency, decision, access or test is missing.
- **COMPLETED:** acceptance criteria are met and evidence is recorded.

A feature can be CANON but not implemented. It can be APPROVED DESIGN but not integrated. It can be implemented in source but not engine-verified. Never collapse these states.

---

## 4. Canon reconciliation: decisions that must govern all BTV work

The following decisions are explicit in Canon Reconciliation & Story/Veil Decisions v1.1. They supersede inconsistent older documents and mockups within the scope they address.

### 4.1 Asher and the Chosen structure

**Current rule:**
- Asher Vance is the sole playable protagonist and the Chosen.
- He is presented as 18, within the established 16–19 range.
- He is human and never divine.
- He begins as an Agent/Specialist in the Watcher branch.
- Agent/Specialist is one tier; Agent and Specialist describe function, not separate ranks.
- Advancement to Team Leader, Commander and General is earned through service, judgment, responsibility and consequences, not spiritual superiority or XP grinding.
- The former selectable male/female dual-Chosen concept is retired from active canon.

**Conflict found:** Older Master Canon and Story & Lore records still list the dual-Chosen question as open. Older app showcase imagery presents a male/female Chosen pair. The Asher character showcase sheet says “Early 20s,” which conflicts with the current 18 presentation and the 16–19 range.

**Required correction:** Update the stale open registers and mark the old dual-Chosen and Early-20s visual treatments as superseded references. Do not build character selection or present Asher as older based on those mockups.

### 4.2 Logos Rhema Temple and HCI

**Current rule:**
- Harvest Chapel International (HCI) is real-world inspiration/reference only.
- HCI does not appear in-game under its real name.
- Logos Rhema Temple is the fictional in-game church.
- Logos Rhema must have original characters, dialogue, architecture and presentation.
- Real HCI pastors are not in-game characters.
- KITFIT is a Logos Rhema segment; its acronym expansion remains UNKNOWN.
- The church is a living community space, not a Covenant base.
- Church members do not automatically know Asher's Covenant affiliation.
- Giving is voluntary; it cannot purchase faith, divine favour, status or gameplay advantage.
- Communion remains contextual and is not a buff or stat system.

**Conflict found:** Older Church/HCI material and several app/faith mockups depict HCI itself as the in-game chapel or organization. The older Church/HCI Bible is therefore stale in this area.

**Required correction:** Preserve the old source as history, but update the current Church Bible and all mockups/UI labels to Logos Rhema Temple. Do not publish or implement real HCI identity as an in-game institution without a new explicit creator decision.

### 4.3 Covenant

**Current rule:**
- Rank order: Recruit → Agent/Specialist → Team Leader → Commander → General.
- Branches: Guardians, Messengers, Watchers, Shepherds, Scouts and Keepers.
- The Covenant is a hidden service/protection organization, not a government agency and not a replacement for the Church.
- Rank represents responsibility and trust, never spiritual superiority or closeness to God.
- The established oath remains exact.

**Required correction:** Update any old list that treats Agent and Specialist as separate ranks. Covenant logistics, supply authority, information access and promotions need their own bounded permissions and acceptance tests.

### 4.4 Ember

**Current rule:**
- Ember is Asher's intelligent animal companion and field partner, not a weapon or omniscient guide.
- Official commands: Attack, Protect, Scout, Track, Retrieve, Hold, Regroup.
- “Stay” is legacy/informal wording for Hold; Follow and Guard are not official commands.
- Established ability names: Veil Sight, Guardian Instinct, Veil Energy, Tracking Sense and Spirit Guidance.
- These names do not establish Ember's species, origin or ultimate nature.
- Ember's species, exact origin, history and full relationship to the Veil remain UNKNOWN.

**Required correction:** Use the seven official commands consistently in UI, dialogue, NLI schemas, tutorials and tests. Do not infer detailed ability mechanics from names alone. Spirit Guidance must not become a controllable Holy Spirit meter or oracle.

### 4.5 Enemies and Ridgeview

**Current rule:**
- Main functional enemy classes: Destroyers, Persuaders, Deceivers and Commanders/Bosses.
- These are roles/functions, not a complete species taxonomy or metaphysical hierarchy.
- Devourers are a rare, disturbing, choice-driven crisis group associated with Ridgeview.
- In the vertical slice, the group is not named to the player. Do not reveal the label in dialogue, objectives, UI, Covenant classification or Asher's report.
- Being outside the Covenant, being a civilian or being a non-believer does not make a person evil.
- Encounters may support investigation, dialogue, warning, preaching, de-escalation, rescue, defense, retreat or combat. Conversion is never a percentage, guaranteed outcome or reward condition.

### 4.6 Story direction: Marek Sloane and the Concordance

**Current status:** APPROVED STORY DIRECTION in Canon Reconciliation v1.1.

- Marek Sloane is the central human antagonist.
- The Concordance is a provisional name for his covert crisis-manipulation network.
- His method is controlling information, redirecting reports, exploiting institutional weaknesses, pressuring witnesses and taking advantage of Veil incidents.
- He does not create the Veil or command it at will.
- He is not the Antichrist, Satan, God or a substitute for a final supernatural explanation.
- His network is not morally uniform; some members may be opportunists, misled, coerced or capable of withdrawing.
- Full biographies, membership, hierarchy and named lieutenants remain open.

**Conflict found:** The Story & Lore Bible v1.0 still lists the main antagonist identity as UNKNOWN. The Master Canon v1.0 open-decision section is also older than this reconciliation.

**Required correction:** Update the Story & Lore unknown register and cross-reference the accepted Sloane/Concordance direction. Do not use this decision to connect Ridgeview to the Concordance without a separate evidence chain and approval.

### 4.7 Seven Deadly Sins and Antichrist material

**Current status:** RESERVED.

- The Seven Deadly Sins are thematic lenses for temptation, harm, habits and social consequences—not seven mandatory boss monsters.
- Antichrist-related material is reserved.
- Sloane is not the Antichrist.
- Do not present speculative end-times claims as unquestionable biblical fact.
- Redemption is possible but not guaranteed, instant, consequence-free or tied to a hidden conversion score.

### 4.8 Veil operational rules and six incident states

**Current status:** APPROVED DESIGN in Canon Reconciliation v1.1; ultimate origin and complete metaphysics remain UNKNOWN.

The Veil is a mysterious supernatural boundary-condition that can disrupt perception, information, environments and events. It is not a conventional portal, simple alternate dimension, morality meter or replacement for God, Christ, Scripture, prayer or the Holy Spirit.

Approved operational laws:
1. Coherence.
2. Locality.
3. Evidence.
4. Limited reach.
5. Agency.
6. Escalation.
7. Counterplay.
8. Human exploitation.
9. Faith boundary.
10. Ember boundary.
11. Civilian continuity.
12. Resolution.

Approved six incident states:
1. Normal.
2. Disturbed.
3. Influenced.
4. Veil-Touched.
5. Veil Breach.
6. Critical / Endgame-Level.

These are incident states, not RPG levels, moral states or a guaranteed linear ladder. An incident can stabilize, recede, change form or be interrupted before reaching a later state. Reports must distinguish observation from inference.

**Conflict found:** Veil Rules & Metaphysics Bible v0.1 labels its operational rules and additional consistency constraints as PROPOSED, while Reconciliation v1.1 explicitly approves the twelve operational laws and six-state incident scale. The Veil Bible's other proposals and unknowns do not become approved merely because some related rules were approved.

**Required correction:** Add a status note to the Veil Bible clarifying which exact laws/states were approved by v1.1 and which additional constraints remain PROPOSED/OPEN. Do not promote the Veil's ultimate origin, creator, complete limits or metaphysics.

### 4.9 Vertical-slice locks

The reconciled slice sequence is:
1. Asher's first Sunday Communion at Logos Rhema Temple.
2. Covenant alert.
3. Scout Report.
4. Evidence review.
5. Journey.
6. Ridgeview investigation.
7. Player response.
8. Final report.

Psalm 23 appears in the authored Ridgeview scene. It is not a spell, attack, stat buff or universal solution. No choice in the slice awards XP or a morality score. Locked slice characters and boundaries remain governed by the current Vertical Slice Specification.

The Ridgeview Case Design v0.2 has a limited APPROVED DESIGN status under the time-bounded delegation recorded in that document. It does not become global canon. The private case truth, exact timeline, clue content and outcome details remain bounded by that approval. Its own status ledger still marks final dialogue and implementation BLOCKED pending cross-checks.

### 4.10 Currency and reward design

**Current rule:**
- Aces are general-world currency.
- Covenant Credits are Covenant-focused currency.
- They remain distinct.
- Approved reward categories are ordinary money, Covenant resources/authorized supplies and non-monetary outcomes.
- Practical capability, Covenant responsibility, Ember growth, contextual relationships and world recovery are separate progression dimensions.
- No universal morality/reputation meter.
- No spiritual worth, salvation, prayer, grace, divine favour or Holy Spirit resource can be purchased, farmed or traded.

Exact prices, XP curves, skill trees, crafting, durability, reward tables, rank timing and economy formulas remain OPEN unless separately approved.

---

## 5. Document-level conflicts, stale records and version defects

| ID | Finding | Evidence | Required action |
|---|---|---|---|
| DOC-01 | Master Canon v1.0 open-decision section is stale | It still asks whether Asher is fixed or dual-Chosen, whether HCI appears directly and whether Ember commands are confirmed | Preserve v1.0 history; point its index to Reconciliation v1.1 as the accepted decision layer |
| DOC-02 | Story & Lore unknown register is stale | It still lists female Chosen, main antagonist identity, HCI representation and Veil rules as unresolved | Update the register with v1.1 outcomes while preserving genuinely unknown details |
| DOC-03 | Church/HCI Bible has an outdated real-world naming frame | It still describes HCI as the real-world inspiration and leaves direct representation open | Add Logos Rhema Temple as the in-game church and HCI as inspiration-only |
| DOC-04 | Mystery register filename/body version mismatch | Library filename is v0.3, document heading and ending say v0.2 | Choose and apply one version label; retain changelog |
| DOC-05 | Investigation & Evidence Bible duplicate | Two Library copies have identical content hash and size | Maintain one canonical source copy; do not fork edits between duplicates |
| DOC-06 | Veil proposal/approval boundary is unclear | Veil Rules v0.1 calls rules proposed; Reconciliation v1.1 approves a specific twelve-law set and six incident states | Add exact status mapping and cross-links |
| DOC-07 | Ridgeview v0.2 has mixed approval states | Some design direction is APPROVED DESIGN under delegation; it explicitly says NOT global canon and final dialogue/implementation remain BLOCKED | Preserve scoped approval; never treat the entire document as global canon |
| DOC-08 | Old visual assets contradict newer canon | Asher sheet says Early 20s; app mockups show HCI and dual-Chosen imagery | Mark as historical visual references; create corrected assets only through normal review |
| DOC-09 | Older DOCX documents use earlier project framing | Some older records distinguish Beyond the Veil from Last Watch or use older HCI/Chosen/faith wording | Keep as historical source; current title and canon decisions come from the newer Master Canon and Reconciliation |
| DOC-10 | Status vocabulary varies across files | Older files use CANON/PROPOSED/UNKNOWN; later files add APPROVED DESIGN/RESERVED and operational delivery labels | Keep the two status systems separate and define them in the source index |

---

## 6. Visual and asset audit

Visuals are useful references, but generated images and mockups are not canon authority. They must pass the current canon and visual consistency checks.

### 6.1 Asher Vance Character Showcase Sheet

The sheet identifies Asher as “Early 20s.” This conflicts with the current canon presentation of 18 within the 16–19 range.

**Status:** CONFLICTING VISUAL REFERENCE.  
**Action:** Do not use the age label or apparent older-age presentation as the current Asher baseline. The v1.1 visual consistency lock requires improvements without reinvention, but it cannot override the current age decision.

### 6.2 Beyond the Veil: Game App Screens

The mockup includes an “HCI Chapel” update and presents an XP-based Covenant rank bar.

**Conflicts/risks:**
- HCI is inspiration-only; the in-game church is Logos Rhema Temple.
- Rank advancement is story-earned through service, judgment, responsibility and consequences, not XP grinding.
- A generic “eliminate threats and collect intel” mission objective must not become the default mission pattern or erase non-combat approaches.
- Armor and weapon inventory presentation is not proof that exact equipment mechanics are approved.

**Status:** HISTORICAL UI CONCEPT; REQUIRES CANON CORRECTION BEFORE REUSE.

### 6.3 Beyond the Veil App Showcase

The mockup shows HCI as a district church and presents “Chosen (Male)” selection. Both conflict with Reconciliation v1.1.

**Status:** SUPERSEDED CONCEPT.  
**Action:** Do not use its HCI or selectable-Chosen structure as current implementation guidance.

### 6.4 Beyond the Veil Faith Codex image

The image contains several compatible principles, including Asher's 16–19 range, the distinction between faith and a magic power system, and the six Armor of God elements. It still uses HCI naming and should not be treated as the current church representation authority.

**Status:** REFERENCE IMAGE; PARTIALLY CONSISTENT, NOT AUTHORITATIVE.

### 6.5 Beyond the Veil: Last Watch Showcase

The image includes the correct seven Ember commands and the distinct Aces/Covenant Credits labels. It also displays character level/XP, weapon slots and equipment systems whose exact rules remain open or reserved.

**Status:** VISUAL PROPOSAL; SOME ELEMENTS CONSISTENT, NUMERIC/GEAR SYSTEMS NOT APPROVED BY IMAGE ALONE.

### 6.6 Asher_Vance_Godot_Ready.zip

The ZIP contains four entries:
- Asher_Vance.glb
- Asher_Vance.tscn
- README.txt
- Asher_Vance.glb.import

It does **not** contain project.godot and is not a complete Godot game project. It is a character asset/scene package. Its existence must not be reported as proof that the BTV project or playable build is complete.

### 6.7 Asset provenance gate

Before any visual or 3D asset enters a distributable build, record:
- source file and creator/tool;
- generation or acquisition date;
- license/usage rights and redistribution permission;
- whether it depicts a real person, real institution, real brand or recognizable third-party design;
- canon status and approved reference;
- target format, import settings and technical validation;
- whether it is placeholder, approved concept or production asset.

Do not let a mockup silently settle age, character selection, HCI representation, combat mechanics, equipment, HUD layout or progression.

---

## 7. Whole-project feature audit

This section applies the universal loophole review to every BTV feature domain, not only the latest language or camera proposal.

### 7.1 Story, lore and narrative

**Established:** modern Christian action-adventure survival RPG; not a direct Bible retelling; human stakes, service, truth, deception, fear, community protection and redemption; accepted Sloane/Concordance story direction.

**Open:** complete chronology, final ending details, full antagonist network, named lieutenants, named Covenant leadership, world history, unresolved Veil mysteries.

**Risks:** stale documents reintroduce retired dual-Chosen or HCI decisions; a local incident is connected to the Concordance without evidence; a villain is treated as a supernatural final explanation; the player is given certainty before the evidence supports it.

**Acceptance tests:**
- Every major story decision links to its authority and status.
- Character knowledge has a plausible source.
- Every reveal is supported by clues introduced before the reveal.
- Unresolved questions remain visibly UNKNOWN/RESERVED.
- No proposal is promoted to canon by appearing in a mockup, generated handoff or dialogue draft.

### 7.2 Characters and NPC knowledge

**Established:** Asher is sole playable protagonist, 18 presentation, human, Agent/Specialist, Watcher; characters must be people before mechanics; NPC knowledge is bounded.

**Risks:** age drift in art; old female-Chosen assets reappear; NPCs know private facts without a source; NPC dialogue becomes objective evidence; companions or NPCs act as omniscient quest solvers.

**Acceptance tests:**
- Character records include identity, status, role, knowledge sources, limits, relationships and continuity constraints.
- A character cannot report an event they did not observe, hear or receive through a traceable communication chain.
- Dialogue claims remain attributed testimony, not confirmed truth.
- Character model/voice/age/gear remain consistent across scenes and images.
- Missing, unavailable or deceased NPCs cannot silently satisfy an interaction.

### 7.3 Covenant organization and authority

**Established:** six branches; five rank tiers with Agent/Specialist as one tier; service/protection organization; not a church or government agency.

**Risks:** rank implies holiness; an Agent can authorize something beyond their scope; a report reaches every station instantly despite signal limits; Covenant personnel have unexplained access to information; resource spending bypasses command accountability.

**Acceptance tests:**
- Every command, resource and information action has a rank/branch permission.
- Delegation, denial, escalation and audit trail are defined.
- Reports retain source, timestamp, route and confidence.
- Rank progression is story-earned and does not use spiritual worth or simple kill/XP totals.
- Church membership and Covenant membership remain separate.

### 7.4 Church, Scripture, prayer, evangelism and Communion

**Established:** Logos Rhema Temple is fictional; HCI is inspiration-only; prayer is not transactional; Scripture is not a magic password; Communion Set is contextual and restricted to CommunionContextZone; First Sunday Communion has no stat reward; giving is voluntary.

**Risks:** real HCI identity leaks into UI; Communion is used as a buff or ordinary consumable; Scripture is quoted inaccurately or detached from context; prayer becomes a guaranteed clue detector; evangelism becomes a conversion counter or coercive minigame; giving buys blessing or status.

**Acceptance tests:**
- Every Scripture quotation has translation/source, context, exact wording review and license/copyright check.
- Prayer outcomes are not guaranteed by a hidden prayer score or resource.
- No gameplay system awards salvation, faith, holiness, divine favour or conversion points.
- Communion can only be used in the defined context and never changes health, XP, stats or combat.
- HCI is not named as an in-game institution; Logos Rhema uses original fictional characters and presentation.
- Church participation remains contextual and is not required to unlock essential progression unless the slice's authored story requires a specific event.

### 7.5 Veil, supernatural abilities and spiritual conflict

**Established:** Veil has coherent operational rules and six incident states; ultimate origin/metaphysics remain unknown; Ember ability names exist but details are not fully specified.

**Risks:** Veil changes rules for plot convenience; a six-stage state becomes an RPG level or linear escalation ladder; Veil Sight reveals every clue; Spirit Guidance becomes a controllable sensor; an enemy class is mistaken for species or complete hierarchy; supernatural effects imply control of God or the Holy Spirit.

**Acceptance tests:**
- Every incident has observable evidence, locality, scope, counterplay and a source trail.
- Incident states can stabilize, recede or be interrupted where story supports it.
- No universal detector or universal supernatural solution.
- Ability contracts define exact scope, false positives, failure, limits, availability and knowledge boundaries.
- Prayer, Scripture, God, Christ and the Holy Spirit are never represented as controllable game resources.

### 7.6 Enemies and combat

**Established:** Destroyers, Persuaders, Deceivers and Commanders/Bosses are functional categories; combat is important but not the answer to every problem; Devourers remain unnamed to the player in the slice.

**Risks:** every mission defaults to kill/collect; non-combat options are cosmetic; civilian harm has no consequence; enemies gain unexplained knowledge; difficulty or damage values are not readable; a boss ignores the approved Veil rules.

**Acceptance tests:**
- Each encounter has a narrative function, knowledge source, behavior limits, civilian impact and at least one fair response.
- Combat is readable and supports defense, retreat or protection where context permits.
- Mission objectives cannot require naming the Devourers to the player in Ridgeview.
- Enemy abilities and weaknesses are documented before implementation.
- Difficulty changes do not silently change canon facts or make optional clues mandatory.

### 7.7 Missions, choices and consequences

**Established:** rescue, investigation, outreach, restoration, battle operations, scout operations, community help and Veil investigations; Ridgeview supports five approaches: Speak/Preach, Investigate, Rescue, Defend and Withdraw.

**Risks:** a missed optional clue softlocks the mission; NPC leaves before required conversation; choices have no actual consequence; hidden consequence is unforeseeable; failed interaction blocks all progress; save/reload duplicates rewards or resets choices.

**Acceptance tests:**
- Mission state diagram defines entry, objective, prerequisites, optional/critical branches, fail-forward, failure, retreat, completion and re-entry.
- Every critical conclusion has more than one fair evidence route where practical.
- Optional content cannot accidentally block essential progress.
- Every choice has a traceable state consequence or is clearly presentation-only.
- Branches are tested after pause, quit, reload and missing evidence.
- Ridgeview's repairman fate and Ridgeview–Concordance link remain UNKNOWN unless separately decided.

### 7.8 World, regions, exploration and NPC simulation

**Established:** large interconnected/semi-open world; ordinary life continues; civilians substantially outnumber Covenant personnel in public spaces; world response should be contextual.

**Open:** exact map, countries/cities, regions, named settlements, government structures, vehicles, weather/calendar and streaming architecture.

**Risks:** world scope exceeds mobile performance; NPC simulation becomes omniscient; distant routines consume unnecessary resources; travel and communication ignore geography; the whole world becomes a permanent war zone.

**Acceptance tests:**
- Every region has defined boundaries, purpose, population profile, services and traversal assumptions.
- NPC simulation tiers have measurable CPU/memory budgets.
- Distant NPCs use simplified simulation without losing critical authored state.
- Communication respects range, relays, outages and dead zones.
- Ordinary areas remain ordinary outside authored incidents.
- Streaming and re-entry do not duplicate NPCs, rewards or world events.

### 7.9 Economy, inventory and progression

**Established:** Aces and Covenant Credits are distinct; three reward categories; contextual relationships; practical capability; Covenant responsibility; Ember development; world recovery; no universal morality meter.

**Open:** exact prices, earning/sinks, limits, crafting, durability, inventory capacity, XP formulas, skill trees, loot and difficulty curves.

**Risks:** repeatable reward exploits; duplicated payouts after reload; essential mission access blocked by spending; Covenant Credits and Aces become interchangeable without rules; rank becomes XP grind; generosity purchases divine favour.

**Acceptance tests:**
- Every transaction has one authoritative owner, unique transaction ID and idempotent result.
- Repeated completion, rollback, save reload and interrupted transactions cannot duplicate rewards.
- Negative, overflow, missing and malformed values are rejected safely.
- Essential progression has a fair recovery route.
- No currency or reward implies spiritual status.
- Rank changes are authorized and story-grounded.

### 7.10 Ember and companion behavior

**Established:** intelligent animal companion and field partner; seven official commands and five named ability concepts.

**Open:** species, origin, exact ability contracts, animation, pathfinding, cooldowns, range, AI decision rules and availability in the first slice.

**Risks:** command reports success before Ember can act; duplicate commands; pathfinding traps; Ember solves every clue; Ember detects every Veil event; abilities become unexplained supernatural powers.

**Acceptance tests:**
- Separate parsed, validated, queued, accepted, executing, completed, rejected and failed command states.
- Ember owns the acceptance/execution response; UI cannot claim execution from parser validation.
- Commands are idempotent and have cancellation/timeout behavior.
- Ability limits and false-positive behavior are explicit.
- Ember cannot reveal unknown origin/metaphysics or act as an omniscient oracle.
- Every official command has unavailable/failure feedback and a player fallback.

### 7.11 Ancient-language research system

**Status:** PROPOSED design direction; not implemented or academically certified.

The language work should remain modular:
- Biblical Hebrew.
- Koine Greek.
- Biblical Aramaic.

Asher's in-world learning and the player's optional learning are separate tracks. Do not assume language learning is required for salvation, Gospel access or essential progression.

**Risks:** confusing language, script, period, dialect, transliteration and translation; false certainty about variant readings; AI-generated translation presented as scholarship; RTL/mixed-script display failures; essential progression locked behind language knowledge.

**Acceptance tests:**
- Each entry records language, period/dialect, script, source edition, transliteration convention, gloss, translation, context and uncertainty.
- Scholarly source and qualified review are recorded for factual content.
- Variant readings are visible where relevant.
- RTL, mixed-script punctuation, vowel marks, fonts, scaling, screen readers and Android rendering are tested.
- The player has an alternate route for every essential mission gate.
- No unreviewed AI translation is shipped as factual content.
- A small content set is not described as fluency.

### 7.12 Visual, UI, camera and input

**Established:** overall visual direction and contextual HUD principles; v1.1 consistency lock says improve, do not reinvent.

**Open:** exact fonts, color tokens, final HUD layouts, UI framework, renderer, camera implementation, input architecture and final accessibility behavior.

**Risks:** old mockups silently determine HCI/Chosen/age; fixed pixel layouts clip; camera reveals information through walls; touch interruption leaves actions pressed; UI says an action succeeded before game state accepts it; essential clue is only visual/audio/color-coded.

**Acceptance tests:**
- Camera and movement use one authoritative state model.
- Perspective changes cannot bypass collision or reveal hidden information.
- Touch actions clear on focus loss, pause, scene transition, cancellation and app resume.
- UI respects safe areas, aspect ratios, scaling and keyboard/touch/controller navigation.
- Every interaction has prompt, target validity, range, line-of-sight, priority, cooldown and result feedback.
- Essential information has non-color and non-audio alternatives.
- All new visual content passes the current age, church, Covenant and Ember continuity checks.

### 7.13 Save/load and persistence

**Status:** NOT IMPLEMENTED in the audited design/source baseline.

**Risks:** corrupt or incompatible saves; duplicate rewards; lost choices; journal/evidence inconsistency; partial writes; schema changes break old saves.

**Acceptance tests before production persistence:**
- Versioned schema and migration policy.
- Atomic write and backup/recovery behavior.
- Corrupt/partial file handling.
- Duplicate transaction and replay tests.
- Pause/quit/power-loss interruption tests.
- Settings, accessibility, journal, mission and progression data have clear ownership.
- Offline local save is a baseline; cloud sync is a separate security/privacy decision.

### 7.14 AI/NLI, privacy, security and cost

**Established:** current NLI spec is deterministic and marked PROPOSED/not implemented or tested. Any future generative model is out of scope until separately approved.

**Risks:** false NPC knowledge; source allowlist without actual source validation; prompt injection; arbitrary state mutation; premature command acceptance; cost/latency/network dependency; collection of sensitive religious or voice data.

**Acceptance tests:**
- Authoritative gameplay state remains deterministic and outside any language model.
- NLI can only call typed, allowlisted, game-validated actions.
- Every NPC factual response links to an existing source record and approved wording.
- Dialogue itself is not evidence.
- Player/NPC/external text is untrusted input.
- No arbitrary file, network, save, mission, inventory, relationship or economy mutation.
- Essential gameplay works with NLI unavailable/offline.
- No collection or inference of religion, prayer, confession, salvation view or spiritual state.
- Voice recording/transcription is off by default.
- Cost, rate, latency, retention, deletion and consent are explicit before any cloud AI or account system.

### 7.15 Build, CI, platform and release

**Established from the repository audit:** the prototype has a narrow headless CI path. It does not establish visual behavior, physical touch usability, Android export/install, performance or PC readiness.

**Acceptance tests:**
- Source/format validation.
- Godot import/parse.
- Unit and headless integration tests.
- Manual editor interaction.
- Android export and installation on a named device/OS.
- Physical Android touch, safe-area, resume and performance tests.
- Desktop keyboard/mouse and controller tests if supported.
- Accessibility and localization review.
- Narrative/theological review.
- Release regression, backup and rollback procedure.

Every result must include commit, engine version, platform, exact command/manual steps and observed result. Empty CI status is not a pass.

---

## 8. Consolidated high-priority risk register

This register combines the source reconciliation findings with the earlier repository-level review. “Risk” does not mean a confirmed runtime defect unless explicitly marked as a source finding.

| ID | Priority | Finding | Current state | Required closure |
|---|---|---|---|---|
| R-01 | P0 Critical | Source-of-truth and stale cross-document decisions | Source docs restored; reconciliation incomplete | Update stale registers and add decision links |
| R-02 | P0 Critical | Asher/dual-Chosen/HCI visual drift | Conflicts confirmed in source/mockups | Correct old registers and future art/UI |
| R-03 | P0 Critical | Theology/Church/Communion integrity | Strong principles exist; feature-level acceptance needed | Apply theological review gate per feature |
| R-04 | P0 Critical | Veil and Ember ability boundaries | Names/rules partly approved; ability details open | Write bounded ability contracts before implementation |
| R-05 | P0 Critical | Save/load and transaction integrity | Not implemented | Define versioned save/state ownership before persistence |
| R-06 | P0 High | Mavis current branch/worktree state | UNKNOWN in this audit | Obtain read-only M0 status before shared edits |
| R-07 | P1 High | NLI false acceptance/handoff semantics | Prior repository source finding | Separate validated/handoff-ready from accepted/executed |
| R-08 | P1 High | NLI source registry/provenance | Partial allowlists only | Require real source records and traceable attribution |
| R-09 | P1 High | Mission state/fail-forward/softlocks | Design exists; runtime not verified | State diagrams and branch/reload tests |
| R-10 | P1 High | Camera/perspective/input architecture | Design proposed; implementation incomplete | One input/camera authority and anti-exploit acceptance |
| R-11 | P1 High | Touch interruption/focus-loss | Test coverage not established | Multi-touch, pause/resume and focus-loss tests |
| R-12 | P1 High | Interaction policy and feedback | Prototype interaction is minimal | Range/LOS/priority/cooldown/result tests |
| R-13 | P1 High | Visual age/Church/Chosen consistency | Contradictory old references found | Mark superseded and approve corrected baseline |
| R-14 | P1 High | Evidence vs testimony vs hypothesis | Proposed evidence architecture exists | Distinct data types and source provenance |
| R-15 | P1 High | Ancient-language scholarly and RTL accuracy | PROPOSED only | Source-reviewed pilot and RTL/accessibility test |
| R-16 | P1 High | Economy duplicate/replay exploits | Exact rules remain open | Transaction IDs, idempotency and rollback tests |
| R-17 | P1 High | Privacy/data inventory | Incomplete | Data-flow, retention, consent and SDK review |
| R-18 | P1 High | Accessibility and localization | Principles exist; acceptance matrix absent | Testable matrix across input, UI and language |
| R-19 | P2 High | World/NPC scale and streaming | Design direction only | Simulation budgets and streaming/re-entry tests |
| R-20 | P2 High | Combat/survival rules and fair alternatives | Major formulas remain open | Design and test before implementation |
| R-21 | P2 High | Visual asset provenance/licensing | Asset set exists; register incomplete | Provenance and license ledger |
| R-22 | P2 Medium | Mystery register version mismatch | Confirmed | Correct version header and filename |
| R-23 | P2 Medium | Duplicate Library investigation file | Confirmed identical duplicate | Maintain one source and redirect references |
| R-24 | P2 Medium | CI coverage narrower than full product | Confirmed limitation | Add separate device, visual, accessibility and release gates |

---

## 9. Universal loophole review — mandatory for every feature

No feature should be implemented merely because the idea sounds good. Before implementation, its design record must answer all of the following.

### A. Authority and purpose
- What player value does it add?
- Which source authorizes it?
- Is it CANON, APPROVED DESIGN, CANON DIRECTION, PROPOSED, RESERVED or UNKNOWN?
- What is explicitly out of scope?
- Who owns the authoritative state?

### B. State and flow
- What are the preconditions and postconditions?
- What happens on repeat, out-of-order action, pause, quit, reload and scene transition?
- What if the target, source, NPC, resource or dependency is missing?
- What if information is stale, contradictory or invalid?
- What happens on failure, timeout, cancellation and retry?

### C. Exploits and recovery
- Can a prerequisite be bypassed?
- Can an action or reward be duplicated?
- Can a player become permanently stuck?
- Can camera, input, physics, dialogue or UI expose unintended information?
- Can an optional failure block essential progress?
- Is there a fair recovery path?

### D. Canon, theology and human impact
- Can it contradict canon, Scripture, character knowledge or a locked slice detail?
- Can it imply spiritual worth, divine favour or salvation is earned?
- Does it coerce religious participation?
- Does it misrepresent Church, HCI, Logos Rhema or Covenant authority?
- Does it affect civilians or vulnerable characters in an unintended way?
- Does it create a misleading or exploitative presentation?

### E. Platform, privacy and cost
- Does it work on supported Android/PC input and screen layouts?
- Is it accessible?
- Does it persist safely?
- Does it collect or infer sensitive information?
- Does it require a network, external service, paid API or recurring credit?
- Is there a deterministic offline fallback?

### F. Verification and rollback
- What exact acceptance criteria prove success?
- Which automated tests cover the edge cases?
- Which manual device/editor checks are required?
- What evidence will be recorded?
- What is the rollback path?
- Who approves canon changes, paid services, public release or destructive operations?

**Pass rule:** A feature passes only when its important risks have explicit boundaries and acceptance tests demonstrate those boundaries. A checklist filled with “not applicable” requires a reason, not a blank.

---

## 10. Priority work plan

### P0 — Complete source governance before new feature expansion

1. Keep the 22 restored source documents and source index as the repository baseline.
2. Update stale Master Canon and Story & Lore open registers so they point to Reconciliation v1.1 for resolved decisions.
3. Update the Church/HCI Bible to the Logos Rhema fictional-church rule.
4. Clarify Veil Rules v0.1 status against the approved twelve laws and six incident states.
5. Correct Mystery Register version metadata.
6. Mark the old Asher Early-20s, dual-Chosen and HCI-in-game mockups as superseded references.
7. Obtain Mavis's read-only M0 report: repo, branch, HEAD, remote match, git status, Godot version, test commands/results and uncommitted work.

### P1 — Close architecture and interaction foundations

1. Correct the NLI command result contract so validation cannot be displayed as companion acceptance or execution.
2. Define a source registry and NPC knowledge provenance.
3. Define camera, perspective, movement and input ownership.
4. Add interaction prompt/result and target validation contracts.
5. Define save-state ownership and versioned schema before persistence.
6. Define mission state, fail-forward and idempotent reward contracts.

### P2 — Build one small, verifiable gameplay path

1. Use the already scoped first-session/vertical-slice journey.
2. Implement only the minimum player traversal and interaction needed for that path.
3. Add a minimal journal/evidence record only after evidence categories and provenance are approved.
4. Keep combat, economy, Ember abilities and wider world simulation outside the slice until their contracts are approved.
5. Test Android and desktop separately; do not infer one from the other.

### P3 — Validate optional learning and content systems

1. Prototype one reviewed Hebrew entry.
2. Validate RTL and mixed-script rendering.
3. Keep Greek and Aramaic modules separate and extensible.
4. Preserve an alternate route for essential story progression.
5. Do not add AI-generated factual translations without scholarly review.

### P4 — Expand only after gates pass

Add larger mission branches, combat, survival, economy, Ember behaviors, world/NPC simulation, broader regions, advanced UI and AI/NLI only after their own source, failure, exploit, accessibility and acceptance gates pass.

---

## 11. Immediate correction queue

These are the first document tasks I recommend. They are documentation corrections, not canon changes:

| Task | Target | Change |
|---|---|---|
| C-01 | Story & Lore Bible | Replace stale antagonist/Chosen/HCI/Veil unknown entries with v1.1 decisions; preserve remaining unknowns |
| C-02 | Master Canon index | Add a clear link to Reconciliation v1.1 and identify superseded open-decision items |
| C-03 | Church/HCI Bible | State Logos Rhema Temple is the fictional in-game church; HCI is inspiration-only |
| C-04 | Veil Rules Bible | Map each section to APPROVED DESIGN, PROPOSED or UNKNOWN based on v1.1 |
| C-05 | Mystery Register | Rename internal title to v0.3 or revert filename; update changelog and cross-references |
| C-06 | Visual reference register | Mark Early-20s Asher, dual-Chosen and in-game HCI mockups as superseded |
| C-07 | Source index | Add legacy DOCX/PDF and visual asset register with explicit historical/reference status |
| C-08 | Feature review template | Make the universal loophole gate mandatory for all new feature proposals |

No creator-level canon change is made by this audit. Where a correction could alter meaning rather than simply align stale wording, it must be escalated.

---

## 12. What this audit does not prove

This document does not prove:
- that every file in the ChatGPT Library has been individually reviewed;
- that every legacy PDF/DOCX has been imported with original formatting;
- that every image or 3D asset is licensed or canon-approved;
- that every contradiction in every historical conversation has been resolved;
- that all 24 risk items have been closed;
- that a Godot project builds or runs on a physical device;
- that Android export, desktop behavior, camera, touch, interaction, NLI, save/load, combat, economy or missions pass tests;
- that Mavis's local worktree is synchronized or clean;
- that the vertical slice is complete;
- or that the game is production-ready.

The Asher asset ZIP was checked and is only a GLB/TSCN asset package; it is not a full game project. The audit did not run Godot or execute gameplay tests.

---

## 13. Audit result and evidence

**COMPLETED**
- Library source discovery and recovery.
- Import of 22 Markdown source documents (10,736 lines).
- Repository source index.
- Cross-document reconciliation of the highest-impact canon decisions.
- Identification of stale documents, version issues and conflicting visual references.
- Whole-project loophole review domains, acceptance criteria and prioritized risk register.

**CONFIRMED**
- The original design sources are now available to collaborators in the repository under docs/source-of-truth/.
- Canon Reconciliation v1.1 resolves several previously open or conflicting decisions.
- Multiple old source files and visual mockups require updates before reuse.

**PROPOSED**
- Immediate correction queue and priority work plan.

**BLOCKED**
- Final review of every legacy binary source and visual asset.
- Mavis's current M0 worktree report.
- Runtime/device verification and feature acceptance.

**Code changes:** None.  
**Tests run in this task:** None.  
**Implementation claims:** None.

**Final rule:** BTV does not accept a feature because it is impressive, convenient or easy to implement. It must be authorized by the correct source, bounded, failure-aware, exploit-reviewed, accessible, testable and supported by evidence.
