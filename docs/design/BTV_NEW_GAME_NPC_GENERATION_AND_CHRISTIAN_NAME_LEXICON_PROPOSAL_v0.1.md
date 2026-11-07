# BTV — New-Game NPC Generation & Christian-Oriented Name Lexicon Proposal v0.1

**Status:** PROPOSED DESIGN — creator direction recorded; system not implemented  
**Scope:** New-game NPC variation, authored character protection, name generation and world population  
**Authority:** Subordinate to Creator decisions, BTV Master Canon, Character Bible, World & NPC Bible, Global Character Naming & Cultural Representation Framework and all locked mission specifications.

## 1. Creator direction

BTV should generate a varied population of ordinary people when a player starts a **new game**. The generated population should make each playthrough feel somewhat different while preserving the authored story, important relationships and established characters.

Names should draw from a curated **Christian-oriented name lexicon**: biblical names, names with established Christian use, and virtue/faith-associated given names. The lexicon is a naming resource, not a declaration that every generated person is Christian.

Ghanaian and international names should be naturally distributed according to each character's regional and family context. Do not create a fixed Ghanaian/international split or nationality quota.

## 2. Three character-generation tiers

### Tier A — Fixed canon and locked story characters

**Never randomized.**

This tier includes:
- Asher Vance and Ember.
- Dorian Pike and Wren in the Ridgeview case.
- Any other creator-approved, canonized or locked mission character.
- Characters whose identity, dialogue, evidence, relationships or story outcomes are required for continuity.

Their names, roles, relationships, knowledge boundaries and authored story facts remain stable in every new game.

### Tier B — Curated recurring and story-support characters

**Authored by the narrative team; selected deliberately, not invented by the random generator.**

This tier includes characters who may recur across missions, regions, Covenant operations, family/community arcs or major world events, but whose details are not necessarily global canon yet.

The narrative team decides:
- which characters must remain fixed for story continuity;
- which characters may be selected from an approved pool for a particular playthrough;
- which characters may have controlled, prewritten variants;
- which characters should remain local to a particular region or story.

A curated character must have an approved character record, voice/knowledge boundaries, regional context and narrative purpose. A procedural selection may choose among approved alternatives only when that choice does not break story dependencies.

No new named Ridgeview character is introduced by this proposal. The Scout, duty officer, visitor and repairman remain as specified in the locked slice materials.

### Tier C — Procedurally generated ambient and low-stakes NPCs

**Eligible for new-game generation.**

Examples include:
- ordinary residents and passers-by;
- shop customers and workers;
- commuters and travellers;
- students and non-story school staff;
- visitors and temporary residents;
- background congregation members;
- local volunteers and service workers;
- non-critical Covenant support personnel, only where the location and role justify them.

These NPCs may receive generated names, appearance variants, occupations, routine schedules, simple relationships and limited personal details. They must not unexpectedly become the source of critical lore, mission evidence, secret identities or essential story decisions.

## 3. New-game seed and save continuity

At the start of a new game, the game may create a world-generation seed.

Proposed rules:
1. Generate the seed once when the new save is created.
2. Use it to produce consistent ambient NPC identities and initial population variation for that save.
3. Store the seed and generated NPC records in the save data.
4. Loading the same save must reproduce the same NPC identities and established relationships.
5. Ordinary schedule changes may occur through world simulation, but must not silently rename or replace an existing generated person.
6. Starting a separate new game creates a new seed and may generate a different ambient population.
7. A new game must not rewrite global canon or alter authored mission facts.
8. If a generated NPC later becomes story-important, promote them only through an authored, reviewed character record—not through an unreviewed procedural coincidence.

A seed should create controlled variation, not unrestricted randomness. The same seed and generator version should give reproducible results where practical. Save data should record a generation/schema version so later updates can migrate NPC records safely.

## 4. Christian-oriented name lexicon

The name system should use curated records rather than random strings or indiscriminate word combinations.

### 4.1 Lexicon categories

**A. Biblical given names**

Names with clear biblical usage, such as:
- Abigail
- Daniel
- David
- Esther
- Gabriel
- Hannah
- Isaac
- Jacob
- Joseph
- Lydia
- Micah
- Miriam
- Naomi
- Nathan
- Noah
- Rachel
- Rebecca
- Ruth
- Samuel
- Sarah
- Simon
- Thomas

This is an initial illustrative pool, not a complete approved global list. Local spelling, pronunciation and cultural usage require review.

**B. Christian-heritage given names**

Names widely used in Christian communities or traditions, subject to cultural and linguistic review. Examples may include:
- Maria
- Michael
- John
- Peter
- Paul
- Stephen
- Elizabeth
- Catherine
- Teresa
- Francis

Use these only where they plausibly fit the character's family and setting. A name does not prove the character's beliefs.

**C. Faith- and virtue-associated given names**

Possible examples:
- Grace
- Faith
- Hope
- Joy
- Mercy
- Charity
- Emmanuel
- Christian
- Blessing

These names should be used selectively. Do not make every NPC's name an overt theological statement or a sermon. Do not imply that a person with one of these names is more faithful, moral or spiritually mature.

**D. Regional and family naming pools**

Surnames, family names, additional given names, honorifics and naming order must come from regionally appropriate, researched pools. They must not be generated by mixing unrelated cultural lists at random.

For Ghanaian characters, the system may use appropriate Ghanaian naming structures and locally grounded names alongside biblical/Christian given names where that fits the character's actual family context. Akan day names and other local naming traditions are cultural naming practices; they must not be mislabeled as inherently Christian.

For international characters, build equivalent regional pools only after their locations and cultural contexts are established. Avoid treating a continent or country as one uniform naming tradition.

### 4.2 Name record fields

Each approved name entry should contain:
- stable name ID;
- displayed spelling;
- pronunciation guidance where needed;
- language or naming tradition;
- name category (biblical, Christian-heritage, virtue-associated, regional/family);
- verified meaning or reference, if available;
- regional suitability notes;
- source/review note;
- content restrictions or collision notes.

Do not invent meanings or etymologies. If a meaning has not been verified, leave it blank or mark it UNKNOWN.

## 5. Name assembly rules

The generator should not simply choose any first name and any surname.

It should:
1. Select a plausible regional/family naming profile based on the NPC's authored location and background.
2. Select a compatible given-name entry from the Christian-oriented lexicon where appropriate.
3. Select compatible family-name components from the same profile or a reviewed diaspora/mixed-family profile.
4. Respect local naming order, spelling and multi-part naming patterns.
5. Check for duplicate display names within the relevant world/save scope.
6. Avoid accidental matches with protected canon characters, public figures or inappropriate strings.
7. Preserve the generated name in the save after creation.

Not every generated NPC needs an explicitly biblical or virtue-associated name. The Christian orientation belongs to the curated name resource and the overall BTV identity; it must not erase credible regional naming practices or make every person sound symbolically named.

## 6. Faith and identity boundaries

- A Christian-oriented name does not establish a character's religion, church attendance, doctrine, morality or relationship with God.
- NPC beliefs and church participation must be authored or inferred only from credible character context, never from their name.
- Do not use names as a hidden holiness score, faction marker or moral alignment.
- Non-Christian, uncertain, secular, questioning or differently religious people may exist in the wider world where story and setting support them; treat them as full people, not caricatures.
- Do not turn the name generator into a device that labels every person as a Christian.
- Prayer, worship, giving, Communion and spiritual status remain outside procedural reward systems.

## 7. Population generation and diversity

Generation should reflect the location, not a global random mix:
- regional population context;
- settlement size and density;
- local work, education, commerce and services;
- visitors, travel and migration where plausible;
- age-appropriate family and social networks;
- time of day, weather and current world state;
- Covenant presence appropriate to the location.

Ghanaian and international characters should appear naturally throughout the game. The generator must not enforce a 50/50 split or any other fixed nationality ratio. It must also avoid making Ghanaian identity synonymous with one region, language, class, occupation or appearance.

## 8. Character relationships and knowledge

Generated NPCs may have small, plausible social links such as household membership, coworkers, neighbours or regular customers. Do not generate arbitrary complex family trees or relationship webs.

Each generated NPC's knowledge must be bounded by:
- what they personally witnessed;
- what their role would reasonably expose them to;
- what another identifiable person told them;
- where they have been;
- and when the information became available.

Procedural NPCs must not know Asher's private mission facts, Covenant secrets or Veil truths without a credible authored reason.

## 9. Anti-duplication and protection rules

- Reserve every protected canon and curated character name.
- Prevent generated NPCs from receiving the exact names of protected characters.
- Avoid excessive repetition in a local crowd.
- Do not reuse a generated person's identity for a different person after save/load.
- Do not delete a generated NPC simply because they leave the active region; use persistent records or a safe population abstraction.
- Do not generate random children in locations or missions where the approved content explicitly excludes them, including Ridgeview.
- Keep sensitive story roles, antagonists, victims, witnesses and mission-critical people authored rather than procedurally assigned.

## 10. Android-first implementation guidance

Start with a small data-driven generator:
- curated name lexicon data;
- regional naming profiles;
- deterministic seed utility;
- NPC record schema;
- duplicate-name validation;
- save/load persistence tests;
- population caps and region streaming.

Do not begin with a large simulation framework. Generate only the number of NPC records needed for the active region and its persistence requirements. Use lightweight schedule/state data rather than simulating every distant NPC continuously.

## 11. Acceptance tests

The design is acceptable for implementation only when tests demonstrate:
- fixed story characters remain unchanged across new games;
- separate new games can generate different ambient populations;
- the same save reloads with stable generated identities and names;
- no generated NPC replaces or duplicates a protected character;
- names are assembled from compatible regional profiles;
- Ghanaian and international populations are represented naturally without quotas;
- name choice does not assign religious belief or moral status;
- generated NPCs cannot leak mission-critical information;
- Ridgeview's locked exclusions and character boundaries remain intact;
- save migration and generator-version changes do not corrupt NPC identity.

## 12. Status register

**CREATOR-CONFIRMED DIRECTION**
- Generate random/varied ordinary people for each new game.
- Use a curated Christian-oriented name word list/lexicon.
- Preserve selected authored NPCs and story characters.
- Retain Ghanaian and international diversity without an artificial 50/50 split.

**PROPOSED DESIGN**
- Three-tier character model.
- Seeded generation and save persistence.
- Lexicon categories and name assembly rules.
- Android-first data-driven implementation approach.

**UNKNOWN / OPEN**
- Exact size and coverage of each regional name lexicon.
- Final list of supported regions and naming profiles.
- Exact NPC population counts and generation density.
- Which additional recurring supporting characters will be approved.
- Final save schema and generator versioning design.

**NOT IMPLEMENTED**
No NPC generator, name database, save schema or runtime system has been changed by this document.

**End of proposal v0.1.**
