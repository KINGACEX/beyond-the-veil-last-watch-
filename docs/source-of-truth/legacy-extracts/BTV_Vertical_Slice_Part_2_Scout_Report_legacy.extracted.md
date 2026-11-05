# BTV Vertical Slice Spec, Part 2 — The Scout Report.docx

> **ARCHIVAL / NON-AUTHORITATIVE.** Earlier proposed Part 2 slice document. Later merged Vertical Slice Specification v1.0 and current creator-approved canon take precedence. Original DOCX remains in ChatGPT Library. Text extraction does not preserve full page layout or embedded graphics.














BTV Vertical Slice Specification v0.1

BTV Vertical Slice Specification v0.1
Stage 2, Part 2: The Scout Report
Status: PROPOSED design built on confirmed canon and your Part 1 decisions. Nothing here becomes canon until you approve it. Part 3 (Ridgeview Outpost) follows.
1. Purpose
The Scout Report is the bridge from a peaceful Sunday to the investigation. It must give Asher a real reason to go, without telling him what he will find. It also introduces BTV's information model: every piece of intelligence has a source, a confidence level and gaps, and none of it is magic.
2. Canon used
· Scout Reports may reveal threats, anomalies, missing people, suspicious activity or developing situations. The player decides whether to investigate, engage, prepare, rescue, gather information or continue elsewhere.
· Reports contain uncertainty and never reveal everything. Information has sources, limits and possible deception.
· Scouts handle reconnaissance, reporting and threat identification. Watchers help separate reliable information from deception.
· Ridgeview Outpost is an established Devourers mission setting: an isolated settlement, missing people, a leader to talk to, evidence to find, and a decision to make.
· Devourers are rare, disturbing and non-graphic. The report must not name or hint at them.
· Covenant Link, signal dead zones, the Evidence Board, photography as evidence, and the Journal are established systems.
· The Holy Spirit and prayer are never a navigation or answer tool.
· Church and Covenant stay distinct: the alert must not turn the church into a Covenant space.
3. Delivery: the Covenant alert
The alert is concerning, not an emergency, so it can wait. During the service the Covenant Link holds it in a queue and does not ring in the sanctuary or the Communion zone. It is delivered during Fellowship and Service (Phase 10 of Part 1), as a quiet vibration that only Asher notices. Asher chooses when to open it. Nothing forces him out of conversations, and no HUD marker appears until he does.
The congregation does not see the device or the report. This follows the default in Part 1 that the church does not know Asher is Covenant (still awaiting your confirmation).
4. Report anatomy
	Field
	Purpose
	Slice example

	Source
	Who observed it and how
	Scout, two days of distant observation, plus one roadside trader

	Area
	Approximate location, not an exact pin
	Ridgeview Outpost and its approach road

	Observed
	First-hand facts
	No traffic on the road; lights in one building only

	Reported
	Second-hand claims
	Supply delivery missed; two travelers overdue

	Alternatives
	Ordinary explanations the Scout lists
	Storm damage, power or radio failure, seasonal slowdown

	Gaps
	What the Scout could not confirm
	Did not enter; signal weak past the ridge

	Recommended
	A non-binding suggestion
	Closer investigation, careful approach, no engagement without cause

	Confidence
	A label on each claim
	Observed, Reported, Inferred, Unconfirmed


5. Sample report (PROPOSED authored text)
· Over two days no vehicles used the approach road to Ridgeview Outpost. The Scout observed this directly.
· Only one building showed lights at night. Observed. The Scout infers that people are staying in it. Inferred.
· A radio check was answered once by an unfamiliar voice that gave no name and ended the call. Observed.
· The outpost's regular supply delivery did not arrive, and the outpost "has been shut for weeks." Both come from a roadside trader. Reported. Unconfirmed.
· Two travelers expected at the outpost are overdue. Reported. Unconfirmed. One is described as a man on a repair contract.
· Birdsong and small wildlife are unusually absent near the outpost. Observed by the Scout; cause Unconfirmed.
· Ordinary explanations are listed: storm damage to the road, a power or radio failure, a seasonal slowdown.
· The Scout did not enter the outpost and cannot confirm anyone is in danger.
The tone is a professional field note: calm, specific, and honest about what is not known.
6. Built-in uncertainty
· One planted inaccuracy (PROPOSED). The trader says the outpost "has been shut for weeks." That claim is wrong, because people are present. Asher can discover this on site, so the player learns to weigh evidence rather than trust a report. The error is an honest second-hand mistake, not a Deceiver trick; Part 3 decides whether anything deeper is going on.
· No answers from faith mechanics. Prayer, Scripture and Ember's abilities do not reveal the report's missing pieces.
· Veil stage hint. The missing wildlife is a quiet signal that the approach may begin at a disturbed Veil stage. This is a hint only; Part 3 decides.
7. The link to the visitor
If Asher listened to the visitor in Part 1, the Evidence Board offers a connection between her relative (a man who went to work in a remote area and missed check-ins) and the overdue repairman in the report. It is a possible link, labelled Unverified, not a confirmed fact. If he did not listen, the report still works on its own; nothing is lost except the personal stake. The reward for listening is information only.
8. What Asher can do next
· Review. Read the report again, inspect the Evidence Board entry, and add a Journal note.
· Ask. Talk to the visitor again, to Pastor Maribel Santos, or to someone in the congregation. They know only what their roles allow and none of them knows Covenant secrets.
· Prepare. Check equipment and decide who goes. This is optional.
· Acknowledge and go. Reply to the Covenant contact and set out for Ridgeview.
There is no countdown and no penalty for lingering in the slice. The report shows how old it is, as a stamp only. Consequences of delay belong to the reserved world_states system, which is not built yet. Ember travels with Asher as his companion.
9. Systems involved (PROPOSED architecture, Godot 4, GDScript)
· ScoutReport resource: an id, source, area, claim entries (each with text, confidence enum, links), gaps, alternatives and a recommended action. Text-first and easy to author.
· CovenantLinkService: a notification queue with context gating. It holds non-urgent alerts while Asher is in a service phase or the CommunionContextZone, then delivers when the ServiceDirector ends the phase.
· Evidence Board and Journal: the report auto-creates linked entries; connections made by the player are flagged Unverified until confirmed.
· Contextual HUD: switches from church mode to investigation mode only when Asher opens the report.
· Android: a light text UI, no heavy assets, and saved state limited to read status and which claims have been verified.
10. Guardrails (must never appear)
No exact quest pin, no prayer or Holy Spirit marker, no reward for opening the report, no mention or hint of Devourers, no gore, no alert that interrupts worship, no Covenant takeover of the church space, and no all-knowing report.
11. Acceptance tests
1. The alert never fires during the service or in the Communion zone and arrives afterward.
1. Opening the report grants no XP, Aces, Credits or items.
1. Every claim in the report shows a confidence label.
1. The Evidence Board link to the visitor appears only if Asher listened to her, and is labelled Unverified.
1. The planted inaccuracy can be found and disproved on site in Part 3.
1. No part of the report or its UI names or implies Devourers.
1. Lingering at the church has no penalty.
1. The report works on a low-end Android device with no frame cost.
12. Creator decisions required
1. Asher's rank at the start of the slice (Recruit or Agent/Specialist). It sets who briefs him and how much authority he has.
1. Who sends the report: the Scout directly, or a Covenant duty officer. Any named person must be a new fictional character.
1. Companions: does the human Covenant Shepherd join the mission, or does Asher go with Ember only?
1. Approve the planted inaccuracy and the four confidence labels.
1. Travel method from the church to Ridgeview, since transport is a reserved system.
1. Approve no-penalty lingering for the slice.
13. Canon audit: PASS
No conflict with the Covenant hierarchy, Scout Report canon, Devourer treatment, church and Covenant separation, prayer and faith boundaries, or the Part 1 decisions. All report content, labels and architecture above are PROPOSED.
14. Decisions recorded for Part 2 (CANON UPDATED: Yes)
1. Rank. Asher starts the slice as Agent/Specialist (one tier). He is a trained field operative, not yet a Team Leader, and his progression is earned through story, judgment and responsibility, never XP grinding.
1. Source. The Scout who gathered the information sends the report through the Covenant's reporting system. A duty officer may receive or forward it but does not replace the Scout as the source.
1. Companion. No human Shepherd joins the field operation. Ember accompanies Asher with the official commands: Attack, Protect, Scout, Track, Retrieve, Hold, Regroup. A Shepherd may appear later as an NPC or be dispatched if Ridgeview needs one.
1. Planted error and labels. Approved. Confidence describes the strength of the available evidence, not absolute truth. The report separates what was observed, what was reported by another person, what was inferred, and what could not be confirmed. It never names or hints at Devourers.
1. Travel. A practical Covenant field vehicle for the main journey, with Ember, then on foot from an access point near Ridgeview. No forced loading-screen-only fast travel.
1. Lingering. Approved. Asher may stay at Logos Rhema with no penalty and the alert stays available.
Final flow: Logos Rhema Sunday, Communion, community interaction, visitor concern, service ends, Covenant alert, Scout Report, Asher reviews evidence, Covenant vehicle travel, Ridgeview approach, on-foot investigation.
Label reconciliation
Your decision says to keep the four proposed labels, but the four categories you describe use different words (observed, reported, inferred, could not be confirmed). I applied the categories you described: Observed, Reported, Inferred, Unconfirmed. Section 4 and the sample report in Section 5 are updated. "Unverified" now means only the status of a connection the player draws on the Evidence Board.
Flag: reserved systems
The Handoff lists companions, communication and world_states as reserved, to be built later. This slice needs small versions of all three: Ember as a companion, the Covenant Link alert as communication, and saved outcome flags as world state. Please approve slice-scoped minimal versions, or tell me to fake them with authored scripts instead.
Next
Once you answer Section 12, Part 3 is the Ridgeview Outpost investigation: arrival, the leader, the evidence, the five response options, and the consequences.
