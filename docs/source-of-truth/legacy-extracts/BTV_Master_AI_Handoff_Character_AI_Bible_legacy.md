# Historical Library extraction — Beyond_the_Veil_MASTER_AI_HANDOFF_and_CHARACTER_AI_BIBLE.docx

> **ARCHIVAL / NON-AUTHORITATIVE.** Older AI handoff and character-AI source preserved for historical traceability. Reconcile all claims against current creator decisions and current canon before use. Original DOCX remains in ChatGPT Library. Formatting, tables and embedded visuals may not be preserved exactly.

<PARSED TEXT FOR PAGE: 1 / 18>
BEYOND THE VEIL
MASTER AI HANDOFF + CHARACTER AI BIBLE
Current consolidated canon • Development direction • Living-world AI • Character behavior
STATUS: APPROVED CANON / BUILD FROM THIS DOCUMENT FIRST
0. MASTER INSTRUCTION FOR THE DEVELOPMENT AI
COPY-PASTE THIS SECTION INTO THE DEVELOPMENT AI BEFORE IMPLEMENTATION:
You are the lead game-development AI for BEYOND THE VEIL. Treat this document as the current canon and 
implementation authority.
Do not invent, merge, rename, remove, or silently reinterpret established canon. Do not mix Beyond the Veil with the 
separate games After Four/Afterfall or Last Watch. If a feature is marked DEFERRED, preserve the placeholder and wait 
for its dedicated design pass rather than filling the gap with guesses.
Build Beyond the Veil as a polished Christian-oriented third-person supernatural action-adventure/survival experience 
with an open, living world, strong human storytelling, exploration, investigation, combat, relationships, transportation, 
wildlife, technology, settlements and Covenant operations.
God is supreme within the game's Christian worldview. Prayer, Scripture, Christian service and discernment must be 
treated as meaningful systems, not as collectible magic spells. The game uses the Bible as the current Scripture source; 
the previously discussed Faith of Life devotional is removed from the current canon.
The world must feel alive even when the player is not present: NPCs have schedules, jobs, homes, social behavior, 
hobbies, travel, commerce, worship and reactions to danger. Character AI must use memory, relationships, perception, 
knowledge boundaries, personality, schedules and consequences. NPCs must not know information they could not 
plausibly know.
Combat AI must be intelligent but fair. Enemy knowledge spreads through actual observation, survivors, reports and 
communication—not magically across the entire enemy faction. A Destroyer who did not witness a tactic should not 
automatically know it. Survivors can adapt or report what they personally experienced.
Core companions and core story characters receive narrative protection appropriate to their role. Ordinary NPCs, non￾core characters and much of the wildlife remain subject to world consequences.
Use original names, brands, devices, symbols and visual designs. Real-world references supplied by the creator are design
references only and must not be copied into the game. The Covenant must be recognizably Christian, original, practical 
and visually coherent.
Create modular, data-driven systems so future updates can add regions, NPCs, devices, animals, clothing, establishments 
and missions without rewriting the whole game.
Before implementing a major system, create/maintain the corresponding design Bible/database and validate it against 
this canon. When uncertain, flag the conflict rather than guessing.
<PARSED TEXT FOR PAGE: 2 / 18>
Development priority:
1. Core architecture and data-driven foundations.
2. Protagonist + movement + camera + inventory.
3. Living-world NPC AI.
4. Covenant/world/settlement systems.
5. Investigation and device systems.
6. Companion/animal AI.
7. Combat and enemy adaptation.
8. Economy, mounts and logistics.
9. Story/content integration.
10. Polish, accessibility, QA and optimization for the target platforms.
The result should feel authored, believable, cinematic and original—not like a collection of unrelated mechanics.
1. PROJECT IDENTITY
Field Canon
Title Beyond the Veil
Core genre Third-person supernatural action-adventure / 
survival / exploration
World structure Open-world or semi-open-world architecture with 
expandable regions
Core tone Suspenseful, human, adventurous, spiritual, 
grounded, hopeful and sometimes dangerous
Faith framework Christian-oriented; God, Scripture, prayer, service, 
discernment and Christian community are central
Primary organization The Covenant
Important Christian institution HCI and its churches/chapels, including an important 
temple/church represented by an original fictional 
counterpart
Currency Ace
Protagonist Kael
Core dog Shepherd
2. DESIGN PILLARS
 A living world: people work, travel, worship, trade, rest, socialize and respond to events.
 Human-first storytelling: relationships and consequences matter as much as combat.
 Investigation: photographs, journals, devices, witnesses and physical evidence form a real evidence chain.
 Faith in action: Scripture and prayer are integrated respectfully and never reduced to random loot.
 Fair intelligence: AI adapts from information it actually possesses.
 Originality: inspirations guide quality and structure; names, brands, symbols, characters and designs are 
original.
 Expandable scope: a manageable foundation supports future updates rather than an unmaintainable mega￾system.
 Core protection: key companions and story characters are protected from arbitrary simulation outcomes.
3. WORLD & REGIONS
Region World behavior and content
<PARSED TEXT FOR PAGE: 3 / 18>
Urban Dense settlements, commerce, offices, churches, 
workshops, stations, markets, apartments, social 
activity and technical services.
Mountainous Cliffs, highlands, difficult routes, caves, remote 
communities, specialized travel and mountain 
wildlife.
Snowy / Arctic Cold survival, snow-adapted wildlife, reduced 
visibility, cold-weather clothing, shelters and 
specialized mounts.
Desert Heat, water scarcity, long travel, desert settlements, 
caravans, region-specific wildlife and equipment.
Riverside Fishing communities, docks, boats, river transport, 
markets, farms and water-dependent wildlife.
Coastal Ports, fishing, boats, coastal commerce, storms, 
settlements and coastal wildlife.
These six broad region families are the base. Future updates may expand them without forcing the project to 
create dozens of disconnected biome systems.
4. LIVING NPC WORLD
 NPCs have daily schedules, occupations, locations, relationships, needs, interests and personal priorities.
 Jobs include merchants, farmers, fishers, craftsmen, traders, transport workers, guards, healers, teachers, 
technical staff, religious workers and other ordinary professions.
 Hobbies and downtime can include fishing, walking, socializing, gathering, local recreation and region￾specific activities.
 The player can see fishing boats with groups, lone fishers, merchants selling, customers buying, workers 
repairing things, travelers arriving and people returning home.
 Weather, time, danger, holidays/events, personal relationships and settlement security can alter routines.
 NPCs can witness events and later discuss or report them. Their knowledge is limited by what they saw, 
heard or were told.
 Important NPCs may have bespoke schedules and dialogue while ordinary NPCs use scalable simulation.
 NPCs should not all react identically; personality, courage, training, faith, occupation and relationship affect 
responses.
5. NPC MEMORY & KNOWLEDGE RULE
This is a major AI rule. Every meaningful NPC has a knowledge state.
Memory type Examples AI consequence
Direct observation Saw Kael enter a location; 
witnessed a combat move
Can remember and react to the 
observed fact.
Witness report A colleague told them about an 
incident
Can know it with lower certainty 
depending on source reliability.
Rumor Local hearsay May be incomplete, distorted or 
wrong.
Professional knowledge Merchant knows prices; technician
knows device systems
Can provide relevant help without 
omniscience.
Personal memory Relationship events, favors, 
arguments, promises
Changes trust, dialogue and 
behavior.
Unknown Information never AI must not act as if it knows it.
<PARSED TEXT FOR PAGE: 4 / 18>
seen/heard/learned
Enemy tactics follow the same principle: defeating one Destroyer does not globally teach every other Destroyer. 
Survivors or informed enemies can carry information forward.
6. PROTAGONIST — KAEL
 Kael is the player-controlled protagonist and the center of the main narrative.
 The player should experience his growth through choices, relationships, skills, equipment, investigation, 
faith and responsibilities.
 Kael can fight, explore, investigate, communicate, use technology, travel on foot or by mount, interact with 
settlements, help people and pray.
 Kael can have a journal obtained near the beginning; the journal supports investigation, memories, 
objectives and reflection.
 Kael can use a smartphone and/or dedicated digital camera to document evidence and take photographs.
 Kael can use laptops and communication devices when needed.
 Kael can use watches with utility functions.
 Kael has a backpack/load system based on practical capacity ranges.
 Kael can use a sniper-rifle class weapon that is powerful but maintainable and balanced within the wider 
equipment system.
 Kael may use a double-jump/climbing assistance option where appropriate to the final movement design.
 Kael can pray during and after situations; the established prayer phrase is 'God, your will be done.'
 Kael can have a spouse/lover and a best friend as core relationship characters; core relationships are 
protected narrative layers.
7. CHARACTER AI: CORE ARCHITECTURE
Every named or important character uses a layered AI model rather than a single scripted state machine.
AI layer Function
Identity Name, age band, role, background, affiliations and 
immutable traits.
Personality Temperament, courage, patience, humor, empathy, 
discipline, ambition, faith orientation and other 
authored traits.
Needs Rest, food, safety, work, social contact and other 
appropriate needs.
Schedule Daily/weekly routines with priority rules and 
interruptions.
Relationships Trust, affection, respect, fear, rivalry, loyalty and 
history toward other characters.
Knowledge Facts personally known, confidence levels, sources 
and timestamps.
Perception Sight/hearing/proximity/environmental awareness 
with believable limits.
Decision system Chooses the highest-priority action compatible with 
personality, safety, knowledge and current goals.
Memory Stores important events and forgettable routine 
events at different strengths.
Emotion Short-term state such as calm, alert, worried, joyful, 
<PARSED TEXT FOR PAGE: 5 / 18>
angry or grieving; never replaces authored 
personality.
Dialogue Contextual responses based on knowledge, 
relationship, location, time and current objective.
Consequences Past actions can alter future schedules, trust, access, 
prices, assistance and missions.
Fail-safe AI falls back to a safe routine when pathfinding, 
schedule or information is unavailable.
8. CHARACTER AI DECISION LOOP
1. Perceive the environment and current situation.
2. Check immediate safety and urgent responsibilities.
3. Retrieve relevant memories and known information.
4. Evaluate relationships and current emotional state.
5. Check scheduled responsibilities and personal goals.
6. Generate a small set of plausible actions.
7. Score actions using personality, priorities, knowledge, risk and relationships.
8. Choose an action without using hidden player/game information.
9. Perform the action and record important consequences.
10. Update memory and relationships when something meaningful occurs.
11. Return to routine when the interruption ends.
9. CORE CHARACTER AI PROFILES
9.1 Kael — Player Character AI
Component Implementation
Goals Player-directed objectives plus authored main-story 
priorities.
Autonomy Low during direct control; high during contextual 
animations, companions, cutscenes and non-player 
moments.
Memory Persistent journal/evidence/relationship records.
Faith Prayer and Scripture interaction are player-directed 
systems, not an autonomous 'faith score' that replaces
player choice.
Equipment Dynamic loadout, backpack ranges, devices, weapons,
clothing, watches and mount logistics.
Investigation Photographs, notes, witnesses, devices and physical 
evidence feed a case/evidence structure.
9.2 Shepherd — Core Companion AI
Component Implementation
Status Protected core companion.
Role Battle support, detection/support, exploration 
companion, emotional bond and story presence.
Combat Trained working-dog behavior; attacks/supports 
according to commands, threat assessment and 
condition.
<PARSED TEXT FOR PAGE: 6 / 18>
Behavior Stays near Kael unless ordered, distracted by 
plausible stimuli, can search/alert/track where 
trained.
Bond Bond develops through care, commands, shared 
experiences and story moments.
Protection Core narrative protection; normal combat danger still
affects condition and requires care.
Story purpose His deeper relationship to Kael's calling and the Veil 
remains a later dedicated lore pass.
Name Shepherd — LOCKED.
9.3 Spouse / Lover — Core Relationship AI
 A core relationship character with authored personality, independent schedule and believable personal 
goals.
 Not a permanently attached follower; can work, travel, rest, worship, socialize and have their own 
responsibilities.
 Relationship state changes through trust, communication, choices, support, conflict resolution and shared 
experiences.
 Core protection applies: the character should not be casually removed by random background simulation.
 Mission involvement occurs when narratively appropriate rather than forcing the character into every 
combat encounter.
9.4 Best Friend — Core Relationship AI
 Independent personality and schedule; capable of joking, disagreeing, advising and helping.
 Can accompany Kael in selected missions and has their own skills.
 Remembers favors, disagreements and important shared events.
 Core protection applies while still allowing meaningful story consequences.
9.5 Adom — High-Importance Companion/Contact AI
 A wealthy, influential contact/companion who can be contacted occasionally.
 May have royal/princely background within the final story, with a living father whom Kael can later meet.
 Not always physically present; communication and occasional encounters are part of his identity.
 Has access, knowledge and resources that differ from Kael's, but he is not an omniscient solution.
 His relationship with Kael is driven by trust, shared events and his own responsibilities.
9.6 Covenant Leadership & Clergy AI
 Leadership characters have schedules, responsibilities, doctrine/role knowledge, relationships and decision 
authority.
 Pastors/preachers can conduct services, counsel people, preach, bless/encourage and manage community 
responsibilities.
 An important HCI church/temple includes a principal pastor character based on the approved fictionalized 
concept; final original in-game name remains a canon naming task.
 A pastor's wife may preach occasionally, not constantly, and has her own work, schedule and social identity.
 No real person's identity should be copied into the final game; the fictional characters must be original 
counterparts.
<PARSED TEXT FOR PAGE: 7 / 18>
9.7 Ordinary NPC AI
Ordinary NPCs use scalable archetypes: merchant, farmer, fisher, worker, guard, healer, traveler, student, 
technician, worshipper, craftsman, parent, child/teen where age-appropriate, etc. Archetypes share systems but 
receive individual personality seeds so the world does not feel cloned.
10. COMPANION AI COMMAND & SUPPORT SYSTEM
 Companions can receive context-appropriate commands rather than a giant menu of arbitrary actions.
 Commands should include follow, stay, investigate/search, alert, assist, defend, regroup and return.
 Companion AI must consider line of sight, terrain, stamina/condition, threat level and distance.
 Companions can independently choose sensible actions when the player has not issued a command.
 Core companions can disagree with reckless actions through dialogue, but gameplay authority remains with 
the player where intended.
11. DESTROYER / ENEMY AI
System Rule
Perception Enemies detect using believable sight, sound, 
proximity, evidence and communication.
Combat role Different Destroyers have distinct specialties and 
behavior patterns.
Tactical memory Only information actually observed, learned or 
communicated is available.
Survivor learning A survivor can report Kael's tactics, weaknesses, 
routes or equipment that they actually witnessed.
No magical hive mind Other Destroyers do not instantly know a battle they 
never experienced.
Adaptation Enemies may alter formations, spacing, pursuit or 
defenses after receiving credible information.
Uncertainty Enemy reports can be incomplete or wrong, 
especially when a witness had poor visibility or was 
under pressure.
Character individuality Important Destroyers retain distinct personalities, 
tactics, motives and preferred approaches.
12. SEVEN DEADLY SINS / MAJOR ANTAGONISTIC ARC
The Seven Deadly Sins arc remains distinct from the prayer/blessing system. Do not collapse the two into one 
mechanic. Major antagonistic characters such as the Destroyer, later-order antagonists and the Antichrist belong
to the story/lore architecture and receive bespoke AI rather than generic enemy behavior.
The deeper Veil hierarchy, later spiritual lore and final battle-recitation mechanics are DEFERRED for a 
dedicated design pass.
13. FAITH, PRAYER & SCRIPTURE — CURRENT CANON
 The Bible is the current and only Scripture source in the game. The Faith of Life devotional is removed until 
a future update.
 A physical Bible is a tangible book object in the world and inventory.
<PARSED TEXT FOR PAGE: 8 / 18>
 Bibles should be intentionally placed rather than randomly spawned everywhere.
 Churches/chapels should contain more copies than Covenant outposts, while outposts receive only a small 
deliberate number (the approved concept was roughly two per outpost).
 Covenant stations/outposts and other appropriate Christian locations can contain Bibles as part of their 
supplies or worship spaces.
 The Bible can support reading, reference, prayer, investigation context and story interactions as designed 
later.
 The final Scripture database, reading interface and battle recitations are deferred for later refinement.
 Prayer can occur during and after battle or difficult situations. The established line is 'God, your will be 
done.'
 The game must not treat prayer as a vending machine; outcomes can be immediate, delayed, indirect or 
absent from the player's immediate view.
14. HCI / KITFIT SERVICE STRUCTURE
KITFIT is a distinct established church-service mechanic within the Christian community system. It is not merely
a shop or payment screen.
12. Early morning Bible Study / devotion: 8:00–9:00 for people who arrive early.
13. 5Ps light prayer: Praise, Pardon, Provision, Protection, Praise.
14. KITFIT: Scripture-based teaching about giving/offering followed by the offering service. Giving is explicitly 
optional; the player is told that whether and how much to give is their choice.
15. Sermon: the main Gospel preaching/message.
16. Benediction by the preacher.
17. Closing and sharing the Grace / recitation.
Other churches may use the same or related service structure, but the above service remains one of the 
important modeled services. The game should portray congregations as communities with variation rather than 
every church as an identical scripted room.
15. COVENANT — ORGANIZATION & HIERARCHY
The Covenant is a major Christian-oriented organization with a recognizable identity, hierarchy, branches and 
field roles. Rank indicates responsibility and authority; branch indicates specialization. A character's 
calling/purpose is not automatically equivalent to rank.
Layer Examples / rule
Rank Recruit Agent Specialist Team Leader → → → →
Commander General (current streamlined →
hierarchy).
Branch Guardian, Messenger, Watcher, Shepherd, Keeper 
and other approved specialist branches as needed.
Role Combat/frontline, communication/diplomacy, 
reconnaissance/intelligence, support/community, 
logistics/engineering, leadership, etc.
Chosen One A rare calling/status that can exist at different ranks 
and is not itself a rank.
Regional variation Same Covenant identity can appear in different 
climate/cultural adaptations.
<PARSED TEXT FOR PAGE: 9 / 18>
Uniform variation Standard, tactical, stealth, ceremonial/ancient and 
regional variants use shared design language.
16. COVENANT UNIFORM — FULL DESIGN CANON
The supplied uniform images are approved visual references for quality, silhouette, layering, Christian 
symbolism, modularity and formal/tactical contrast. They are NOT to be copied as costumes. The final game must
create an original Covenant clothing system.
16.1 Core visual identity
 Recognizable Christian-oriented identity built around faith, watchfulness, protection and service.
 White/ivory is the principal formal Covenant foundation; gold/metallic accents are restrained and 
purposeful.
 Cross imagery and Covenant insignia are integrated into collars, chest panels, buckles, shoulder patches, 
pendants, clasps and other garment hardware.
 Branch and rank indicators are visible without turning every uniform into a costume covered in symbols.
 A consistent silhouette lets the player recognize Covenant personnel from a distance.
16.2 Three recognition distances
 Far distance: identify Covenant.
 Medium distance: identify branch/role and broad rank family.
 Close distance: identify rank insignia, equipment, craftsmanship, repairs and personal/regional details.
16.3 Uniform families
Family Purpose
Standard Everyday Covenant identity, settlement work, travel 
and general duty.
Tactical Combat-ready, modular protection, pouches, armor 
interfaces and field mobility.
Stealth / reconnaissance Reduced visibility, quieter materials and 
reconnaissance-focused equipment.
Ceremonial / formal Services, inductions, leadership events and major 
Covenant occasions.
Ancient / God-given garments Rare historic/spiritual garments discovered through 
approved story systems; purpose-specific rather than 
common uniforms.
Regional Climate-adapted materials, cuts and layers while 
preserving Covenant identity.
16.4 Modular components
 Base garment or tunic/coat.
 Optional robe or long outer layer.
 Optional cloak/hood.
 Belt and modular pouches.
 Shoulder patch/branch insignia.
 Rank insignia.
 Boots appropriate to terrain.
 Optional helmet or head covering.
 Protective armor modules.
<PARSED TEXT FOR PAGE: 10 / 18>
 Covenant pendant, buckle, ring or other personal identifiers.
 Field backpack/pack.
16.5 Material language
 Durable woven cloth, leather or equivalent in-world materials.
 Weather-resistant outer layers.
 Protective composite/armor where justified.
 Metal details used for function and identity.
 Visible wear, repairs and regional adaptation so uniforms belong to people rather than mannequins.
Design rule: clothing communicates identity and duty, but clothing alone must not equal supernatural power.
17. COVENANT ESTABLISHMENTS & SERVICES
 Covenant stations: larger operational centers with broader services and guaranteed technical personnel.
 Covenant outposts: smaller field locations with limited staffing and supplies; not every outpost has a 
technical specialist.
 Chapels: prayer, worship, Scripture, community and service functions.
 HCI churches/temples: larger worship/community locations with structured services.
 Workshops/repair facilities: maintenance of devices, watches, gear and other equipment.
 Medical/healing facilities where appropriate.
 Training/briefing spaces.
 Markets and merchants around settlements.
 Stables/farms for mounts and domestic animals.
 Fishing docks/boats and riverside/coastal commerce.
 Technical offices/labs at selected Covenant stations.
 Safehouses or mission staging locations where appropriate.
18. TECHNICAL PERSONNEL AI
Every Covenant station has at least one technical-capable staff member or accessible technical function. Not 
every Covenant outpost has one. The technical personnel are deliberately broad specialists so Kael does not 
travel to a station for a single narrow task only to be told 'wrong person.'
 Core expertise: communications, device diagnostics, signal analysis, digital investigation, tracking/locating 
unknown numbers where the story and infrastructure permit, battery/repair diagnostics, basic 
network/security knowledge, mapping and field electronics.
 Limits: they cannot magically locate every person, bypass every security system, recover every deleted file 
or solve every investigation without evidence.
 Availability: schedules, workload, damaged infrastructure, signal coverage and emergencies can affect 
service.
 Skill tiers: ordinary technician senior field technician specialist, without making every station an elite → →
laboratory.
 They can teach or explain enough to help Kael understand a problem rather than acting as a black-box quest
button.
<PARSED TEXT FOR PAGE: 11 / 18>
19. TECHNOLOGY SYSTEM
19.1 Cameras
 Kael can own a dedicated digital camera and use a smartphone camera.
 Photographs can become evidence in investigations, records, memories and mission documentation.
 Camera quality affects clarity, low-light performance, zoom and storage—not story truth itself.
 Evidence systems should preserve the original image/context so the player can revisit it.
19.2 Smartphones
 Original in-world brands and model families only.
 Device classes: common, premium and flagship, with manageable model counts.
 Phones can be bought, sold, repaired and upgraded.
 Differences can include battery, camera, storage, durability, signal handling and supported applications.
 Do not use real iPhone/Samsung model names in the game; those references are translated into original 
equivalents.
19.3 Covenant app / communications
 An original Covenant communications app provides messaging, groups, mission/community channels and 
organizational communication.
 Possible group categories: settlement members, field members/colleagues, outpost teams, station teams and 
ordinary private chats.
 The app must not simply be a copy of a real social platform; use original interface language and features.
 Messages can influence missions, rumors, schedules and relationships.
19.4 Field communication device
A rugged dedicated communication device fills the role of a walkie-talkie without simply copying a real product. 
It can support short-range/team communication when appropriate, with range and signal limits.
19.5 Laptops
 Original brands/model families with common professional high-end/technical tiers. → →
 Uses include research, document handling, evidence analysis, communications, technical work and mission 
preparation.
 Laptops have battery/repair/storage constraints and can be stolen, damaged or serviced.
 Access permissions depend on the device and account; ownership does not automatically grant every piece 
of information.
20. WATCH SYSTEM
Class Examples of functions
Common Time/date, basic alarm, limited utility.
Field Time, compass/navigation support, light, emergency 
signaling, rugged construction and practical alerts.
Luxury Premium materials, strong utility, status/social value 
and advanced but plausible features.
Specialized Mission-specific functions when justified by the 
world; never a universal magic device.
<PARSED TEXT FOR PAGE: 12 / 18>
Emergency signals require an actual communication path or suitable signaling mechanism. A watch cannot 
summon help from nowhere. Compass functionality can use an appropriate sensor/mechanical equivalent 
depending on the device. Light drains battery.
21. BACKPACK & CAPACITY
 Capacity uses manageable ranges rather than obsessive item-by-item weight simulation.
 Backpack classes differ in practical carrying range, organization and durability.
 Items occupy capacity categories/slots; oversized objects require dedicated handling.
 Mounts can extend effective expedition capacity.
 The system supports planning without turning inventory management into the main game.
22. HORSES & MOUNTS
 Horses are meaningful transportation and economic assets.
 Horse types include Mustang-type horses and other suitable breeds/types.
 Horses can be bought, sold, gifted and bred.
 Individual mounts have traits such as speed, endurance, temperament, carrying ability and environmental 
suitability.
 Mount needs include food, water, rest, care, equipment and condition.
 Mount capacity connects to backpack/load planning.
 Horse AI includes grazing/resting, following, reacting to danger, returning to stable/handler, navigation and 
bonding.
23. ECONOMY
Ace is the primary currency. The economy links ordinary life to the systems already established.
Economic area Connected systems
Food/water Kael, NPCs, mounts, settlements and travel.
Technology Phones, cameras, laptops, batteries and repairs.
Transportation Horses, boats, regional travel and services.
Clothing Ordinary clothing, Covenant uniforms, field gear and 
regional wear.
Animals Buying/selling/breeding/gifting mounts and 
appropriate domestic animals.
Services Repair, technical assistance, lodging, transport and 
specialist work.
Commerce Merchants, customers, markets, fishing and farming.
Covenant support Some services/resources may be mission-linked 
rather than purely commercial.
Prices should respond to region, scarcity, condition, reputation and supply without becoming a full economic 
simulator.
24. WILDLIFE AI
 The wildlife system is an ecosystem, not a deer-only feature.
 Species are selected by region and realistic habitat.
 Examples of dangerous predators include lions, mountain lions, wolves and crocodiles.
<PARSED TEXT FOR PAGE: 13 / 18>
 Animals can flee, observe, defend territory, hunt, attack or ignore Kael depending on species, individual 
state and context.
 Predators may attack when hunting, threatened, cornered or protecting territory/young.
 Mothers/females can protect offspring when realistic, but not every mother automatically attacks; some flee 
or use warning behavior.
 Animals respond to gunfire/combat, weather, food, humans and other animals.
 The player can bond with many animals, with insects and similar small categories excluded from the 
intended bonding system.
 NPCs can independently encounter wildlife; not every animal encounter is a quest.
25. DOMESTIC ANIMAL AI
 Cats and dogs appear in settlements.
 Farms can contain cows and other appropriate livestock.
 Domestic animals have routines such as feeding, resting, wandering, working, returning to shelter and 
reacting to strangers.
 Domestic animals contribute to settlement life rather than existing only as loot/resources.
26. SHEPHERD'S BATTLE ROLE
 Shepherd was sent to aid in battles and therefore has a credible combat-support purpose.
 He is not a supernatural replacement for human companions or God.
 His strengths should emerge through play rather than being dumped on the player as a stat list.
 He can distract, pursue, alert, assist, defend and attack within believable trained-dog limits.
 His condition matters; he can tire and require care.
 His AI prioritizes Kael, immediate threats and commands while retaining animal instincts.
27. INVESTIGATION SYSTEM
Evidence source AI/gameplay role
Photographs Visual evidence, comparison, memory and case 
records.
Physical objects Collectable/inspectable evidence where appropriate.
Journal Kael's notes, leads, reflections and organized case 
information.
Witnesses NPC testimony filtered through their memory, 
honesty and knowledge.
Phone Messages, calls, photos, contacts and relevant 
applications.
Laptop Research, analysis, documents and technical 
investigation.
Technical personnel Assistance when the case requires expertise Kael 
lacks.
Environmental clues Footprints, disturbed objects, sounds, locations and 
other contextual evidence.
No single device should solve an investigation automatically. The player connects evidence and makes 
judgments.
<PARSED TEXT FOR PAGE: 14 / 18>
28. WEAPONS & FIELD EQUIPMENT
 The protagonist has a broad but manageable equipment sandbox.
 A powerful sniper-rifle class weapon exists and must be maintainable, balanced and integrated into the 
setting.
 Weapons have condition/maintenance considerations rather than infinite perfect reliability.
 Field gear can include protective clothing, packs, communication equipment, watches and practical tools.
 Rare/ancient equipment belongs to story/lore systems and must not erase ordinary equipment progression.
29. RELATIONSHIPS & SOCIAL AI
 Core companions and spouse are distinct from ordinary NPC social interactions.
 NPC relationships use trust, familiarity, respect, fear, gratitude, rivalry and other appropriate variables.
 Actions can change access, assistance, dialogue and future behavior.
 Core story characters have plot protection; ordinary NPCs can experience world consequences.
 Animal bonding is separate from human relationship systems.
30. CORE STORY/LORE FRAMEWORK
 The Veil is a major mystery and supernatural framework; its deeper rules are intentionally deferred.
 The Covenant is a major force for faith, protection, service and organized response.
 The Destroyer and later antagonistic forces create escalating danger.
 The Seven Deadly Sins arc is distinct from divine prayer/blessing mechanics.
 The protagonist's calling, Shepherd's deeper purpose and the ultimate Veil revelations are reserved for 
dedicated lore design.
 The game can include divine guidance and rare events, but God remains supreme and is not converted into a
player-controlled stat system.
31. CHARACTER AI CONTENT PIPELINE
18. Create a Character Bible entry for every named character.
19. Assign immutable identity facts and authored personality traits.
20. Define schedule and occupation.
21. Define relationships to every important character, using only meaningful links.
22. Define knowledge sources and what the character must not know.
23. Define perception limits and preferred environments.
24. Define combat/non-combat capabilities where applicable.
25. Define dialogue topics and memory triggers.
26. Define reactions to danger, prayer, community events, loss and major story beats.
27. Define what is protected by canon and what can be simulated.
28. Test the character alone in a settlement before placing them into missions.
29. Run continuity tests so the character cannot learn impossible information or contradict established history.
32. CHARACTER AI DATA TEMPLATE
Field Required content
Character ID Unique internal ID.
Display name Final approved original name.
<PARSED TEXT FOR PAGE: 15 / 18>
Role Story/world role.
Faction Covenant, settlement, independent, antagonist, etc.
Rank/branch Only if applicable.
Core status Core / important / ordinary / background.
Personality Short authored trait set.
Needs Relevant physical/social needs.
Schedule Routine and priority changes.
Skills Combat, technical, medical, trade, social, etc.
Knowledge Facts, sources, confidence.
Relationships Trust/affection/respect/rivalry etc.
Memory Important event retention rules.
Dialogue Topics, tone, contextual responses.
Combat AI Role, preferred distance, tactics and retreat rules.
Consequences What changes after key events.
Protection What cannot happen through ordinary simulation.
Quest hooks Potential missions/interactions.
Canon status LOCKED / DEFERRED / PROVISIONAL.
33. AI FAIRNESS & ANTI-CHEATING RULES
 No NPC may use information the character could not plausibly obtain.
 No enemy receives global knowledge because another enemy fought Kael.
 No merchant knows Kael's entire inventory unless they inspected it or were told.
 No technical worker can solve a problem outside their expertise without an appropriate referral or 
investigation path.
 No animal knows human plans; animal behavior comes from senses, conditioning and species behavior.
 No companion automatically knows a secret the protagonist has not communicated or revealed through a 
visible event.
 AI difficulty should come from better decisions, not hidden information.
34. PERFORMANCE / SCALABILITY DIRECTION
 Use simulation tiers: full AI near the player, reduced simulation at medium distance, schedule/statistical 
simulation far away.
 Only important characters require deep persistent memory; background NPCs use compressed memories.
 Use event-driven updates for routines and world changes instead of running every decision every frame.
 Keep AI data separate from visual character assets so one system can drive many appearances.
 Use modular clothing, devices, mounts and animal data to prevent content explosion.
 Build with mobile/desktop scalability in mind and allow graphical/AI simulation quality tiers.
35. QA TEST PLAN FOR CHARACTER AI
Test Pass condition
Routine test NPC reaches work, rest and home locations reliably.
Interruption test Danger or urgent event temporarily overrides 
routine.
Knowledge test NPC only reacts to information they could know.
Memory test Important events influence later behavior.
Relationship test Trust/relationship changes persist correctly.
<PARSED TEXT FOR PAGE: 16 / 18>
Combat test Enemy adapts only after actual observation/report.
Companion test Shepherd follows commands and returns to safe 
behavior.
Animal test Wildlife flees/defends/attacks according to 
species/context.
Economy test Buying/selling/repair services affect inventory and 
money correctly.
Device test Battery, repair and communication limitations work.
Bible placement test Physical Bibles appear intentionally by location rules,
not random spawning.
Core protection test Core characters are not accidentally removed by 
ordinary simulation.
36. LOCKED VS DEFERRED
Status Items
LOCKED / CURRENT Kael; Shepherd; living NPC routines; jobs/hobbies; six 
region families; wildlife ecosystem; domestic animals;
horses; backpack/capacity ranges; Ace economy; 
cameras; phones/laptops; Covenant communications; 
watches; technical personnel rules; Covenant 
hierarchy; Covenant uniform direction; HCI/KITFIT 
service structure; physical Bible concept; enemy 
knowledge rule; sniper-rifle class; investigation 
evidence system.
DEFERRED Final Veil rules; deeper spiritual hierarchy; final 
battle recitations; detailed Scripture-reading 
database/UI; some rare divine-item mechanics; final 
exact original device brands/model catalogue; final 
exact Covenant logo geometry; some final character 
names; detailed horse breed/stat roster.
37. ESTABLISHED CHARACTER ROSTER — IMPLEMENTATION STATUS
Character/category AI implementation status
Kael CORE — player character; full systems integration.
Shepherd CORE — protected companion; full companion AI.
Spouse / lover CORE — protected relationship AI.
Best friend CORE — protected relationship AI.
Adom IMPORTANT — contact/companion AI with 
independent life.
Covenant leaders IMPORTANT — leadership/service/schedule AI.
Important HCI pastor counterpart IMPORTANT — worship/community/leadership AI; 
final original name to be locked.
Pastor's wife counterpart IMPORTANT — occasional preacher + independent 
civilian/professional AI; final original name to be 
locked.
Destroyers ENEMY — individual combat AI + knowledge 
propagation.
Seven Deadly Sins / major antagonists BESPOKE — dedicated antagonist AI; deeper lore 
deferred.
Antichrist / later major antagonist BESPOKE — story-driven AI; final implementation 
<PARSED TEXT FOR PAGE: 17 / 18>
later.
Ordinary NPCs SCALABLE — archetype + personality + schedule AI.
Wildlife ECOLOGICAL — species/individual/context AI.
Domestic animals SIMULATED — settlement/farm AI.
38. ESTABLISHED WORLD EXPERIENCE
A typical player journey should be capable of naturally combining systems: Kael travels through a living 
settlement; sees merchants and customers; notices a fisher leaving a dock; receives a message; visits a Covenant 
station; speaks with a technical worker; repairs a phone; buys supplies; checks a watch; reads or carries a 
physical Bible; photographs evidence; travels with Shepherd or a horse; encounters wildlife; returns to a chapel; 
participates in a service; and later uses gathered information to make a story decision. No single system should 
feel isolated.
39. ORIGINALITY & COPYRIGHT-SAFETY RULE
 Real products, organizations, public figures and clothing references supplied as inspiration are not to be 
copied into the game.
 Create original in-world names, logos, interfaces, uniforms, brands and character identities.
 Christian Scripture can be incorporated according to the project's later Bible/Scripture implementation plan, 
but the game should not copy unrelated copyrighted devotional materials.
 The supplied uniform references are visual direction only; production assets must be original.
40. FINAL DEVELOPMENT DIRECTIVE
Build Beyond the Veil as one coherent world, not a pile of features. Every mechanic should connect to the living 
world, the protagonist's responsibilities, investigation, relationships, faith, survival, travel or story. Every AI 
character must have a reason for what it knows, where it goes, what it wants and how it reacts. Protect the core 
canon, keep deferred systems deferred, and prefer modular systems that can grow through future updates.
ONE WORLD. ONE CANON. ORIGINAL. LIVING. FAITH IN ACTION.
APPENDIX — QUICK AI HANDOFF CHECKLIST
 Read this entire document before coding.
 Create the Character Bible/data schema before authoring large numbers of characters.
 Create world/establishment/animal/device/economy data tables before hard-coding content.
 Do not mix Beyond the Veil with After Four/Afterfall or Last Watch.
 Do not silently replace approved canon.
 Do not use omniscient AI.
 Do not make every NPC a quest giver.
 Do not make every animal hostile.
 Do not make every Covenant member identical.
 Do not make every church service identical.
 Do not turn prayer into guaranteed transactional magic.
 Do not randomly spawn physical Bibles everywhere.
 Do not copy real-world brands or the supplied uniform references.
<PARSED TEXT FOR PAGE: 18 / 18>
 Keep core companions/story characters protected.
 Keep the Veil's deferred systems clearly marked until their dedicated design pass.
