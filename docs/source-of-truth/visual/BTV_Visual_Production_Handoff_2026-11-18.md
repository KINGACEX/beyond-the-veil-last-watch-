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

- Work is documentation-only.
- No existing prototype branch files were edited.
- No source-of-truth canon documents were rewritten.
- No game code, scenes, runtime assets, or binary reference files were changed.
- No image/video generations were run.
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
