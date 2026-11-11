# BTV Vertical Slice Parts 1–2 vs Merged v1.0 — Delta Audit
Date: 2026-11-05
Status: COMPLETED — documentation comparison only

## Sources and authority
Compared the archived Part 1 and Part 2 DOCX text extracts with the full Library copy of `BTV_Vertical_Slice_Specification_v1.0.md` and repository draft `docs/source-of-truth/vertical-slice/BTV_Vertical_Slice_Specification_v0.2.md`.

Authority remains: latest explicit creator decision → Master Canon / reconciliation → specialist bible → merged slice specification for slice-scoped decisions → older drafts and handoffs. This report makes no new canon decisions.

## Part 1 — Sunday at Logos Rhema Temple

| Subject | Early draft state | Merged v1.0 state |
|---|---|---|
| First Sunday Communion | Initially an assumption, later recorded as a creator decision | LOCKED: first Sunday; Communion Set only in CommunionContextZone; no reward or buff |
| Scripture | Philippians 4:13 NIV selected | LOCKED; contextual use, not a declaration mechanic |
| Offering | Optional Aces, no reward or social comparison | LOCKED: voluntary, no leaderboard, pressure, guilt, reward, penalty or visible amount |
| Ember at church | Creator decision: attends grounds and does not disrupt | LOCKED; waits under Hold and is not framed as a worshipper or spiritual authority |
| Visitor seed | Unnamed visitor's relative, uncertainty preserved | LOCKED: female visitor mentions a relative who went to work remotely and missed check-ins; no Ridgeview name or Covenant secrets |
| Church design | Original, warm, community-oriented; no copying HCI | Retained as slice design |
| Five leadership characters | Listed in early document, but marked proposed pending confirmation | LOCKED in merged v1.0: Elias Warrick, Maribel Santos, Tobias Reed, Amos Whitaker and Leah Okoye |
| Congregation's knowledge | Early document called it an unconfirmed default | LOCKED in merged v1.0: congregation does not know Asher is Covenant |
| Population balance | 10:1 or higher proposed | Retained as a tunable slice value, not global canon |

**Important:** Do not read Part 1's opening proposal without its later decision record and merged v1.0. The merged document records the final slice status of these items.

## Part 2 — Scout Report

| Subject | Early draft state | Merged v1.0 state |
|---|---|---|
| Report source | Scout gathers and sends; duty officer may forward | LOCKED: Scout remains the source |
| Confidence labels | Observed, Reported, Inferred, Unconfirmed; Unverified only for player-created links | LOCKED with the same distinction |
| Trader's inaccurate claim | Second-hand claim that outpost was shut for weeks is false | LOCKED |
| Devourer disclosure | Report must not name or hint at them | LOCKED and extended across dialogue, UI, classification and Asher's report |
| Church alert | Queued until service ends; quiet vibration; Asher opens by choice | LOCKED context gate; congregation does not see it |
| Visitor connection | Only if Asher listened; Unverified until supported | Retained as evidence-board rule |
| Companion | No human Shepherd; Ember accompanies Asher | LOCKED |
| Travel | Practical Covenant vehicle, then on foot | LOCKED |
| Lingering | No penalty | LOCKED |
| Veil progression | Approach hint proposed as Disturbed | Merged v1.0 defines approach as Disturbed and settlement/camp as Influenced |

The old Part 2 request for approval of slice-scoped companion, communication and world-state stubs is superseded by merged v1.0, which defines those three stubs as approved slice design. It is not a current open approval request.

## Earlier v0.2 draft — status interpretation
The repository's `BTV_Vertical_Slice_Specification_v0.2.md` is an earlier foundation draft dated 2026-11-01. It treats the repository as empty and leaves Communion, Ember and detailed slice content open or optional. These statements reflect that draft's earlier assumptions; they do not supersede the later merged v1.0 slice locks.

Separately, actual implementation status must be verified against the current branch and CI. A design document does not prove implementation or successful testing.

## Guardrails to preserve
1. Philippians 4:13 is used contextually; no declaration mechanic.
2. Communion is contextual and non-transactional.
3. Giving cannot affect progression, standing or rewards.
4. The congregation remains unaware of Asher's Covenant affiliation.
5. The Scout Report remains uncertain and does not reveal the Devourers.
6. Scout confidence labels remain historical provenance; Asher's later assessment is stored separately.
7. Ember provides limited observations, not answers or an oracle.
8. Prayer, Scripture and the Holy Spirit are not navigation or clue-solving systems.
9. The repairman's status remains unresolved within the slice.
10. Ridgeview content follows the approved non-graphic presentation boundary.
11. The five approaches and outcome flags are not morality or faith scores.
12. Slice stubs remain replaceable and do not define the future full systems.

## Open items retained
- Psalm 23 translation.
- Actual Android baseline device and performance budgets.
- Names of the Scout, duty officer, visitor and repairman.
- Renderer and external test framework selection, subject to the technical plan's approval/evidence gates.
- Any creator correction made after merged v1.0.

## Outcome
- **COMPLETED:** Parts 1–2 compared with merged v1.0 and earlier v0.2 draft.
- **COMPLETED:** Superseded open questions and status differences recorded.
- **NO CANON CHANGE:** Existing decisions only.
- **NO CODE CHANGE:** No scripts, scenes, assets or project configuration modified.
- **NO TEST CLAIM:** No Godot, Android, device, performance or gameplay tests were run.

## References
- `docs/source-of-truth/legacy-extracts/BTV_Vertical_Slice_Part_1_Sunday_at_Logos_Rhema_legacy.extracted.md`
- `docs/source-of-truth/legacy-extracts/BTV_Vertical_Slice_Part_2_Scout_Report_legacy.extracted.md`
- `docs/source-of-truth/vertical-slice/BTV_Vertical_Slice_Specification_v0.2.md`
- Library source: `BTV_Vertical_Slice_Specification_v1.0.md`
- Master Canon and Canon Reconciliation v1.1
