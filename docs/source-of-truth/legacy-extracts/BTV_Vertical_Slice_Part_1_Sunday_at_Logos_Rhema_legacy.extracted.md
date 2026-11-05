# BTV Vertical Slice Spec, Part 1 — A Sunday at Logos Rhema Temple.docx

> **ARCHIVAL / NON-AUTHORITATIVE.** Earlier proposed Part 1 slice document. Later merged Vertical Slice Specification v1.0 and current creator-approved canon take precedence. Original DOCX remains in ChatGPT Library. Text extraction does not preserve full page layout or embedded graphics.

<PARSED TEXT FOR PAGE: 1 / 6>
BTV Vertical Slice Specification v0.1

Stage 2, Part 1: A Sunday at Logos Rhema Temple
Status: PROPOSED design built on confirmed canon. Nothing here becomes canon until you approve it.
Parts 2 (Scout Report) and 3 (Ridgeview Outpost) follow in later stages.


1. Purpose
The Sunday is the slice's opening. It must show, before any danger, that BTV is a living world: ordinary
people, a real church community, Asher as a young Covenant member among civilians, and the Christian
worldview as part of life, not a power system. It also plants the thread that leads into the Scout Report.


2. Canon used
    •   Logos Rhema Temple is the fictional in-game church (Stage 1, F1). Real HCI is inspiration only
        and never named in-game.
    •   Church is not the Covenant and not a gameplay faction. Services are world activities, not menus.
    •   Civilians, families, worshippers and volunteers substantially outnumber Covenant personnel.
    •   Service sequence (flexible): Arrival & Fellowship, Welcome, Praise & Worship, Prayer, Scripture
        Reading, KITFIT, Offering, Sermon, Response/Reflection, Communion when scheduled,
        Announcements, Closing Prayer, Fellowship & Service.
    •   KITFIT: Scripture, a short message on giving, voluntary offering. Aces may be used. Giving is
        never competitive or a measure of worth.
    •   Communion: first Sunday, Communion Set (bread and wine as one item), only inside the
        CommunionContextZone, no buffs of any kind.
    •   Prayer is non-transactional. The Holy Spirit is not a mechanic. Faith is never a stat.


3. Decision assumed for this draft
DECIDED: the slice Sunday is a first Sunday, so Communion and the CommunionContextZone are
tested. If you prefer an ordinary Sunday, Section 6, Phase 8 is simply removed and nothing else changes.


4. Cast (roles only, no names)
Logos Rhema's pastor, worship team, ushers, volunteers, teachers, children and youth, elderly
members, families, visitors, a few Covenant members including Asher. Names, faces and the pastor's
characterization are UNKNOWN and need your input. No real pastors or real HCI people are portrayed.
Ember's presence at the church is a Creator decision (Section 11).

PROPOSED population target: civilians to Covenant roughly 10 to 1 or higher in the sanctuary and
grounds, stored as a tunable data value, not hard-coded.
<PARSED TEXT FOR PAGE: 2 / 6>
5. Player role and agency
The player controls Asher as an ordinary attendee. There is no combat, no timer, no reward counter and
no objective marker pushing the player through the service. The player may arrive early, linger, talk, sit,
step outside quietly, or skip a segment, and nothing is penalized or rewarded for attending more. The
service continues around the player as a living scene.


6. The morning, phase by phase
Phase 1. Arrival & Fellowship (free exploration). NPCs arrive, greet each other, set up chairs and sound,
supervise children, help elderly members. Conversations vary by NPC. Asher can talk, help carry
something, or just observe. One conversation plants the thread (Section 7).

Phase 2. Welcome, Worship and Prayer. Seating, music, congregational prayer. HUD is reduced to near
nothing. Prayer here is communal and authored. It gives no buff and no outcome.

Phase 3. Scripture Reading. An authored reading. DECIDED: Philippians 4:13 (NIV). The verse is
referenced by book, chapter, verse and translation only; its text is not reproduced in this spec.

Phase 4. KITFIT. Scripture plus a short message on giving, as the Church Bible and Handoff describe.
Wording is authored later; it must say generosity is not measured by amount and wealth is not worth.

Phase 5. Offering. Optional and silent. Asher can give some Aces, any amount, or nothing. No amount
displayed to others, no reaction difference, no reward, no log entry that scores it.

Phase 6. Sermon. A short authored sermon, skippable by stepping away. No quiz, no point system.

Phase 7. Response and Reflection. A quiet optional prayer moment for Asher. Authored lines, no
outcome guaranteed, nothing granted.

Phase 8. Communion (first Sunday). Contextual sequence: Prepare, Receive, Reflect, Pray, Continue.
Asher uses the Communion Set inside the CommunionContextZone. Outside the zone the restriction line
is: "This is reserved for an appropriate Communion gathering." No health, XP, stats or protection. The
moment ends in reflection, not a result screen.

Phase 9. Announcements and Closing Prayer. Community information, which can carry small ordinary-
life news and serve as a natural place for world context.

Phase 10. Fellowship and Service. People mingle and clean up. The player may help, talk, or leave. The
Covenant Link alert arrives here (Section 7).


7. The thread into Part 2 (PROPOSED story seed)
During Phase 1 or Phase 10, a visitor mentions a relative who traveled toward a remote settlement and
has not been in contact. This is deliberately uncertain and can be dismissed as ordinary worry. Afterward
Asher receives a Scout Report. That report is Part 2. The settlement being Ridgeview Outpost is an
established mission setting; the visitor's identity and relationship are UNKNOWN placeholders.
<PARSED TEXT FOR PAGE: 3 / 6>
8. Systems involved (PROPOSED architecture, Godot 4, GDScript)
    •    ServiceDirector: a state machine for the service phases, emitting signals. Phases are data-driven
         resources, so special services can reorder them.
    •    NPC routines: schedule data per NPC role (arrive, greet, seat, worship, depart), local perception
         only, no omniscience.
    •    Interaction: the common interaction architecture already preferred in the Handoff.
    •    CommunionContextZone: a trigger area that gates the Communion Set and shows the
         restriction line elsewhere.
    •    Contextual HUD: church mode with minimal elements.
    •    Dialogue and Journal: conversation flow; an optional Faith Journal note after service.
    •    Reserved systems (not built here): world_states, economy, companions beyond what the slice
         needs.

Android budget (needs profiling, not canon): use tiered NPC simulation, with a small number of fully
scripted NPCs near the player and cheaper crowd behavior farther away; cap simultaneous animated
NPCs by device tier; stream audio rather than preloading the whole service.


9. Guardrails (must never appear)
No Faith points, no prayer buff, no Communion buff, no offering reward, no donation leaderboard, no
pressure or guilt on giving, no Covenant takeover of the church, no real HCI naming, no real pastors, no
invented Scripture text, no combat in the church.


10. Acceptance tests
    1.   A first-time player can reach the end of the Sunday without being forced through any segment.
    2.   Skipping or attending every segment produces identical stats and inventory.
    3.   Aces given or withheld produce no mechanical difference.
    4.   The Communion Set is blocked outside the CommunionContextZone with the correct line, and
         works inside it with no stat change.
    5.   Civilians visibly outnumber Covenant members at the target ratio.
    6.   No UI element anywhere shows a faith, prayer, grace or holiness value.
    7.   Service phases can be reordered by changing data only.
    8.   Frame rate and memory hold on the mid-tier Android target (target to be defined).


11. Creator decisions required
    1.   Confirm the first-Sunday assumption.
    2.   Choose the Scripture passage and translation for Phase 3, and for any other authored readings.
    3.   Provide or approve names and roles for Logos Rhema's pastor and key members (fictional only).
    4.   Is Ember present at the church, and if so, what is his behavior inside the building?
    5.   Do you want the visitor thread in Section 7, or a different way into the Scout Report?
    6.   Approve Logos Rhema's architecture and look as an original design, with no copying of real
         buildings.
<PARSED TEXT FOR PAGE: 4 / 6>
12. Canon audit: PASS
No conflict with Asher, the Covenant hierarchy, the Church/Covenant distinction, Communion rules,
prayer and faith boundaries, population balance, or the F1 decision that HCI is not in-game. All story
content in Section 7 and all numbers in Sections 4, 8 and 10 are PROPOSED, not canon.


13. Decisions recorded for Part 1 (CANON UPDATED: Yes)
    1. First Sunday. This is Asher's first Communion at Logos Rhema Temple, woven into the service
       per the Church Bible. It is a sacred narrative and reflection moment, never a reward, buff, stat,
       currency source or progression mechanic.
    2. Scripture. Philippians 4:13, NIV, used contextually and never as a combat mechanic.
    3. Leadership cast. Five original fictional leaders, none representing real HCI people (Section 14).
    4. Ember. Comes to the church grounds with Asher, never disrupts the service, and is not a
       worshipper, spiritual authority or religious symbol.
    5. Visitor seed. Kept, but it must not reveal the mystery. The Covenant alert and Scout Report
       supply the real lead.
    6. Logos Rhema's look. Approved in principle: original, warm and community-oriented, clearly
       Christian architecture that copies no real HCI building, regionally variable, never like a Covenant
       or military facility, never dominated by Covenant members.

Additional rule: no XP, Aces, Covenant Credits, equipment, buffs or forced objectives for attending. The
voluntary offering stays a choice to give, never a way to earn.

Flow: Sunday, worship, Communion, community interaction, visitor concern, Covenant alert, Scout
Report, Ridgeview Outpost.


Design adjustments that follow (PROPOSED)
    •   Scripture use. Philippians 4:13 is read in its context, which follows Paul's words on being content
        in every circumstance (Philippians 4:11-12), so it reads as endurance and contentment, not
        winning. No declaration mechanic. Because it is also on the rare cinematic list, any later battle
        use should be a deliberate callback to this Sunday; that is your call.
    •   Ember. He waits at a designated spot with a clear line to Asher, such as a covered side porch,
        under the Hold command. Children and members may greet him before and after the service
        only. NPCs treat him as an ordinary animal.
    •   Visitor. She mentions one relative who went to work in a remote area and has missed check-ins.
        She does not name Ridgeview or explain why she is worried beyond that. Part 2 lets the player
        connect her to a line in the report only if they listened.


14. Logos Rhema leadership cast (PROPOSED: names and details await your approval)
All five are original fictional characters. I cannot check them against real people, so please confirm none
resembles an actual HCI pastor or member.

Pastor Elias Warrick, Senior Pastor, 61.
<PARSED TEXT FOR PAGE: 5 / 6>
   •   Appearance: tall and broad-shouldered, close grey-white beard, reading glasses on a cord,
       sleeves rolled under a plain jacket.
   •   Personality: unhurried, dry humor, listens longer than he speaks.
   •   Background: thirty years as a high-school history teacher before pastoring; gathered Logos
       Rhema's first congregation in a rented hall.
   •   Tension: finds it hard to hand work to others and will not admit he is tired.
   •   Sunday role: leads the welcome and the short sermon, plainly and without theatrics.

Pastor Maribel Santos, Associate Pastor, 38.

   •   Appearance: medium height, dark hair in a practical braid, cardigan, small notebook always in
       hand.
   •   Personality: warm, direct, notices who is missing.
   •   Background: former hospital nurse who moved into pastoral care.
   •   Tension: carries other people's burdens and struggles to rest.
   •   Sunday role: greets newcomers including Asher, receives prayer requests, and may quietly
       follow up with the visitor.

Tobias Reed, Worship Leader, 29.

   •   Appearance: lean, curly light-brown hair, acoustic guitar over his shoulder, cables looped on his
       arm.
   •   Personality: gentle, earnest, doubts himself before every service.
   •   Background: former session musician who left touring after burning out.
   •   Tension: perfectionism.
   •   Sunday role: tunes up softly during arrival and sets the tone for worship.

Deacon Amos Whitaker, Communion Steward, 72.

   •   Appearance: slight and upright, white hair, neat grey vest, hearing aid, very steady hands.
   •   Personality: quiet, precise, formal, with a dry kindness.
   •   Background: retired baker and a widower; prepares the Communion bread by hand.
   •   Tension: rigid about procedure, and slowly learning to let younger helpers take part.
   •   Sunday role: guides the Communion sequence (Prepare, Receive, Reflect, Pray, Continue) in few
       words.

Leah Okoye, Youth and Community Ministry Leader, 26.

   •   Appearance: athletic, natural hair tied up, lanyard, church-event shirt and sneakers.
   •   Personality: energetic, quick to laugh, a natural encourager.
   •   Background: grew up in Logos Rhema's youth group; now runs weekend sports and the food-
       pantry drive.
   •   Tension: over-commits and runs on adrenaline.
   •   Sunday role: organizes children and volunteers, and has the easy community conversation with
       Asher.
<PARSED TEXT FOR PAGE: 6 / 6>
Still UNKNOWN: whether Logos Rhema's people know the Covenant exists, and how long Asher has
attended. PROPOSED default: the congregation does not know Asher belongs to the Covenant, and he
attends as an ordinary visitor.


New Creator decisions required
    1. Approve, rename or replace any of the five characters, and confirm none resembles a real
       person.
    2. Confirm or change the default that the congregation does not know about the Covenant.


Next
Once you answer Section 11, Part 2 is the Scout Report: what it contains, how uncertain it is, and the
choices Asher has before Ridgeview.
