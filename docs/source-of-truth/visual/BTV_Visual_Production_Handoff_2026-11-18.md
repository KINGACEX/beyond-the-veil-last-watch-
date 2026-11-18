# BTV Visual Production Work Handoff
## 2026-11-18

**Branch:** `docs/btv-visual-production-001`  
**Base branch:** `btv/bootstrap-prototype-001`  
**Scope:** Documentation-only visual-production preparation  
**Status:** Draft documents saved; not merged.

---

## 1. Work completed in this branch

1. Added `BTV_Visual_Production_Bible_v1.0_DRAFT.md`.
   - Defines a repeatable production workflow for BTV visual development, cinematic shots, animation, channel videos, and QA.
   - Explicitly subordinates itself to Foundation #12 Visual/UI/HUD Bible v1.1.
   - Defines canon, rights, credit, continuity, and approval gates.
2. Added `BTV_Visual_Asset_Registry_v1.0_DRAFT.md`.
   - Records characters, environments, Covenant identity, HUD, and known reference candidates.
   - Separates canon status from asset approval and implementation state.
   - Records provenance warnings and next production dependencies.
3. Updated `docs/source-of-truth/README.md` with links to both documents and this handoff.

## 2. Repository sources inspected

- `AGENTS.md`
- `docs/source-of-truth/README.md`
- `docs/source-of-truth/characters/BTV_Character_Bible_v1.0.md`
- `docs/source-of-truth/visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.1_Consistency_Lock.md`
- `docs/source-of-truth/visual/BTV_Foundation_12_Visual_UI_HUD_Bible_v1.0.md`
- `docs/source-of-truth/canon/BTV_Canon_Reconciliation_and_Story_Veil_Decisions_v1.1.md`
- `docs/source-of-truth/production/BTV_Economy_Progression_and_Production_Readiness_v1.0.md`
- `docs/audits/BTV_CHARACTER_AND_VISUAL_REFERENCE_INVENTORY_2026-11-05.md`
- `docs/audits/BTV_VISUAL_REFERENCE_PROVENANCE_AUDIT_2026-11-05.md`

## 3. Important canon corrections applied

The earlier conversational draft had provisional assumptions that did not match the repository's controlling sources. The saved documents correct them:

- **Asher:** sole playable protagonist and Chosen; age 18 in the controlling slice; Agent/Specialist in the Watcher branch. The former dual-Chosen concept is retired from active canon.
- **Female Chosen:** not an active character/asset. Do not produce a second playable Chosen.
- **Ember:** rare original naturally occurring canid lineage is locked; exact appearance and breed characteristics remain OPEN. Do not describe the species/lineage as wholly unknown.
- **Logos Rhema Temple:** fictional in-game church. HCI is real-world inspiration/reference only.
- **Covenant visual identity:** white base, restrained gold, cross-centered insignia, practical tactical equipment.
- **Asher showcase sheet:** reference candidate only; printed “Early 20s” conflicts with age 18. Printed height/build/accessory details are not canon.
- **Afterfall Ember profile:** not confirmed as BTV Ember; keep it isolated.
- **Visual authority:** Foundation #12 v1.1 is controlling. The new production Bible is supplementary and cannot override it.

These are source reconciliation corrections, not new canon decisions.

## 4. Current production state

| Work item | State |
|---|---|
| Visual production workflow | DOCUMENTED — DRAFT |
| Asset registry | DOCUMENTED — DRAFT |
| Source-of-truth index links | UPDATED in this branch |
| Asher final approved reference manifest | BLOCKED / incomplete provenance |
| Ember final appearance sheet | BLOCKED / exact appearance open |
| Slice-cast reference sheets | NOT STARTED |
| Environment reference sheets | NOT STARTED |
| Pilot script/storyboard/animatic | NOT STARTED |
| Animation/video | NOT STARTED |
| Public channel release | NOT AUTHORIZED |

## 5. Safety and scope record

- Work includes documentation and proposed, editable SVG concept assets; no runtime game implementation.
- No existing prototype branch files were edited.
- No source-of-truth canon documents were rewritten.
- No game code, scenes, runtime assets, or binary reference files were changed.
- One raster environment concept preview was generated during the session but was not committed because the available GitHub write action supports UTF-8 text files only. The durable repository deliverables are editable SVG concept assets.
- No credits were spent and no trial/subscription was activated.
- No public post, schedule, release, deployment, or merge was performed.
- No Godot runtime, Android export, or physical-device verification was performed.

## 6. Next actions

1. Finish identifying the exact approved Asher gameplay references and record provenance.
2. Reconcile the showcase sheet's age conflict before deriving any model sheet.
3. Retrieve/verify Foundation #11 Ember Companion Bible source and keep exact appearance open until approved.
4. Prepare source-grounded visual briefs for Asher, Ember, and the vertical-slice cast.
5. Prepare Logos Rhema Temple and Ridgeview environment briefs from the controlling Vertical Slice Specification.
6. Only after reference and canon gates pass, storyboard a pilot sequence.
7. Test a low-cost/free-first production pipeline; verify current provider terms, usage rights, and credits before any generation.
8. Seek explicit approval before paid generation, publishing, merging, or changing canon.

**Handoff principle:** Preserve the source of truth, keep proposals visibly separate, and report only work supported by repository evidence.


## 7. Visual production update — 2026-11-18

### Completed

- Inspected the Library's `chapel_actual_render.png` as a possible Logos Rhema Temple greybox reference.
- Created and saved an original vector environment concept at `assets/concepts/environments/BTV-ENV-001_logos-rhema-temple-interior_concept-v01.svg`.
- Added [BTV-ENV-001 Concept Study 01](BTV-ENV-001_Logos_Rhema_Temple_Interior_Concept_Study_01.md), documenting source basis, design intent, unknowns, and review gates.
- Updated the Visual Asset Registry to track the concept and its proposed status.
- Confirmed the controlling slice says Asher is aged 16–19, presented as 18; the Character Bible leaves exact appearance unknown.
- Inspected two existing Asher images. They depict materially different identities and equipment; neither is selected as final.
- Inspected the fox companion preview; it is not evidence of Ember's final BTV appearance.

### Not completed

- No final Asher model sheet or Ember model sheet has been created. Their exact appearances are not sufficiently established by the controlling sources.
- No final chapel environment has been approved.
- No game scene, model, material, texture, rig, animation, lighting, navigation, or Android build has been implemented or tested.
- A separate raster concept preview was generated but could not be committed using the available GitHub text-file write action. The SVG is the repository-stored visual deliverable.

### Next production sequence

1. Review/approve or reject the Logos Rhema interior concept.
2. Retrieve the exact Asher/Ember controlling reference materials and resolve provenance conflicts.
3. Produce source-grounded character visual briefs before any character generation.
4. Prepare Ridgeview environmental concept work only from the approved slice geography and current reference inventory.
5. Build storyboard/animatic for the first Sunday sequence, respecting service order, Ember's Hold state, and the non-interruption rules.
6. Convert accepted concept art into modular Godot environment assets only after the engineering branch and project structure are verified.



## 8. Storyboard visual production — 2026-11-18

- Added the six-frame editable SVG storyboard at `assets/concepts/storyboards/BTV-STB-001_opening-sunday_storyboard-v01.svg`.
- Added [BTV-STB-001 storyboard brief](BTV-STB-001_Opening_Sunday_Storyboard_Exploration_01.md).
- The six frames cover establishing, fellowship, worship, Scripture/KITFIT teaching, voluntary offering, and Communion.
- The board uses generic silhouettes and objects only; no definitive Asher or Ember likeness is depicted.
- It preserves the slice rule that Ember remains at the designated Hold spot and does not interrupt worship or Communion.
- The board is a visual composition exploration, not an approved shot list, animatic, final script, or implemented scene.


## 9. Ridgeview environment visual study — 2026-11-18

- Added the proposed three-zone environment SVG at `assets/concepts/environments/BTV-ENV-003_ridgeview_environment_concept-v01.svg`.
- Added [Ridgeview Environment Concept Study 01](BTV-ENV-003_Ridgeview_Environment_Concept_Study_01.md).
- The board covers the late-afternoon approach, inhabited settlement, and outlying work camp.
- It preserves slice constraints: no children at Ridgeview, no graphic content, no visible/named Devourers, and no explicit Veil explanation.
- Exact geography, architecture, evidence placement, and navigation remain proposed pending comparison with the existing greybox and investigation design.


## 10. Character reference work — 2026-11-18

- Added [Asher Vance Visual Reference Brief](BTV-CHR-001_Asher_Vance_Visual_Reference_Brief.md). It records the locked role/age range and the unresolved appearance. Three existing images were inspected; their identities and equipment conflict, so none is selected as the master reference. Final Asher art remains BLOCKED pending a creator decision.
- Retrieved and reviewed Foundation #11 — Ember Companion Bible v1.0 from the Library. It confirms the rare original wild-dog/canid lineage, natural origin, believable athletic anatomy, and open exact visual breed characteristics.
- Added [Ember Silhouette Study 01](BTV-PET-001_Ember_Visual_Silhouette_Study_01.md) and its three-option SVG asset. The options are proposals only; no option is selected.
- Explicitly excluded the stylized fox companion preview as an authoritative BTV Ember reference.



## 11. Repository write-safety correction — 2026-11-18

One Ember SVG creation call omitted the feature-branch argument and briefly created the file on `main`. This was detected immediately. The exact file was deleted from `main`, verified absent there, and recreated on `docs/btv-visual-production-001`. No existing project file was overwritten or modified. The add/delete commits remain in `main` history; no history rewrite was attempted. The final asset is present and verified on the feature branch.



## 12. Full opening Sunday storyboard — 2026-11-18

- Added storyboard v0.2 with 12 visual frames covering the approved service phases in order.
- The board includes the Covenant alert only after service ends and preserves the congregation's ignorance of Asher's Covenant identity.
- Ember's designated Hold location remains outside the worship flow; he does not interrupt worship or Communion.
- The storyboard uses generic silhouettes and objects. It is not a final character design, timed animatic, dialogue script, or approved cinematic.
- v0.1 remains available as an earlier six-frame study.

