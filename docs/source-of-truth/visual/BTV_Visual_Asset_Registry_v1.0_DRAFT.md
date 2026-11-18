# BEYOND THE VEIL: THE LAST WATCH
## Visual Asset Registry v1.0

**Document status:** DRAFT — production control register  
**Authority:** Subordinate to the BTV Master Canon and Foundation #12 Visual/UI/HUD Bible v1.1  
**Canon effect:** NONE. A registry entry does not approve a design or asset.  
**Last reviewed against repository sources:** 2026-11-18  
**Branch:** `docs/btv-visual-production-001`

---

## 1. Purpose

This register tracks visual assets, source authority, provenance, approval, and production readiness. It is designed to prevent character drift, cross-project contamination, unlicensed use, and accidental promotion of generated concepts into canon.

**Important:** The repository already contains substantial BTV source-of-truth documents and visual audits. This register supplements them; it does not replace them.

## 2. Status vocabulary

| Status | Meaning |
|---|---|
| CONFIRMED / LOCK | Established by a controlling source. |
| APPROVED DESIGN | Approved design direction; not proof of implementation. |
| PROPOSED | A production recommendation awaiting approval. |
| UNKNOWN | Not established; do not invent. |
| CONFLICT | Conflicts with a higher-authority source. |
| REFERENCE CANDIDATE | Existing material with unverified approval/provenance. |
| BLOCKED | Cannot safely proceed until a dependency is resolved. |
| IN PRODUCTION | Work is underway. |
| REVIEW | Awaiting QA or approval. |
| APPROVED FOR USE | The exact asset has been reviewed and accepted for a specified use. |
| ARCHIVED | Retained for history/reference; not active production material. |

Also track evidence states separately:
- DOCUMENTED
- IMPLEMENTED
- VERIFIED
- ACCEPTED

## 3. Authority and source-of-truth links

1. Creator's latest explicit decisions.
2. Master Canon as reconciled by accepted creator decisions.
3. Specialized Bibles in their domains.
4. Vertical Slice Specification for slice-specific locks.
5. Visual/UI/HUD Bible v1.1 for visual continuity.
6. Character and visual-reference audits for asset provenance.
7. This registry for tracking only.
8. Older mockups and unverified generated/reference assets.

Primary references:
- [Master Canon](../canon/BTV_Master_Canon_v1.0.md)
- [Canon Reconciliation v1.1](../canon/BTV_Canon_Reconciliation_and_Story_Veil_Decisions_v1.1.md)
- [Character Bible v1.0](../characters/BTV_Character_Bible_v1.0.md)
- [Foundation #12 Visual/UI/HUD Bible v1.1](BTV_Foundation_12_Visual_UI_HUD_Bible_v1.1_Consistency_Lock.md)
- [Character & Visual Reference Inventory Audit](../../audits/BTV_CHARACTER_AND_VISUAL_REFERENCE_INVENTORY_2026-11-05.md)
- [Visual Reference Provenance Audit](../../audits/BTV_VISUAL_REFERENCE_PROVENANCE_AUDIT_2026-11-05.md)

## 4. Character asset register

| Asset ID | Character | Canon/source status | Visual reference status | Production state | Notes |
|---|---|---|---|---|---|
| BTV-CHR-001 | Asher Vance | CONFIRMED / LOCK; sole playable protagonist and Chosen; age 18 in controlling slice; Agent/Specialist, Watcher branch | Approved gameplay references establish baseline; exact reference manifest still incomplete. Showcase sheet is REFERENCE CANDIDATE and has printed age conflict (“Early 20s”) | BLOCKED for final model-sheet approval | Do not use showcase sheet's age, height, build, or accessories as canon. See provenance audit. |
| BTV-PET-001 | Ember | CONFIRMED / LOCK; rare naturally occurring canid lineage; Asher's companion/field partner | Exact appearance/breed characteristics OPEN; Afterfall profile is NOT CONFIRMED as BTV Ember | BLOCKED for final model-sheet approval | No wings, demonic anatomy, cybernetics, angelic transformation, or human speech. |
| BTV-CHR-002 | Pastor Elias Warrick | CONFIRMED slice character | No approved visual reference established in reviewed repository sources | PROPOSED reference package; appearance not to be invented as canon | Senior Pastor, 61; use slice Character Bible for approved characterization. |
| BTV-CHR-003 | Pastor Maribel Santos | CONFIRMED slice character | No approved visual reference established in reviewed repository sources | PROPOSED reference package; appearance not to be invented as canon | Associate Pastor, 38; former hospital nurse per slice inventory. |
| BTV-CHR-004 | Tobias Reed | CONFIRMED slice character | No approved visual reference established in reviewed repository sources | PROPOSED reference package; appearance not to be invented as canon | Worship Leader, 29; former session musician per slice inventory. |
| BTV-CHR-005 | Deacon Amos Whitaker | CONFIRMED slice character | No approved visual reference established in reviewed repository sources | PROPOSED reference package; appearance not to be invented as canon | Communion Steward, 72; retired baker per slice inventory. |
| BTV-CHR-006 | Leah Okoye | CONFIRMED slice character | No approved visual reference established in reviewed repository sources | PROPOSED reference package; appearance not to be invented as canon | Youth and Community Ministry Leader, 26. |
| BTV-CHR-007 | Dorian Pike | CONFIRMED slice character | No approved visual reference established in reviewed repository sources | PROPOSED reference package; appearance not to be invented as canon | Ridgeview local leader; use slice-specific characterization. |
| BTV-CHR-008 | Wren | CONFIRMED slice character | No approved visual reference established in reviewed repository sources | PROPOSED reference package; appearance not to be invented as canon | Ridgeview resident; do not turn her into an exposition device or grant her knowledge she does not have. |
| BTV-CHR-009 | Marek Sloane | CONFIRMED story direction / detail limits remain | No approved visual reference established in reviewed repository sources | BLOCKED pending approved story need | Central human antagonist; no unapproved biography, appearance, lieutenants, or complete faction roster. |

### Character exclusions and safeguards

- The selectable male/female dual-Chosen concept is retired from active canon. Do not create a female Chosen protagonist asset.
- Do not assign names to the unnamed Scout, Covenant duty officer, visitor, or Ridgeview repairman.
- Do not introduce reserved characters such as Ayla into the vertical slice unless the relevant scope is explicitly approved.
- Do not adopt Stephen or an Ember profile from the Afterfall folder as BTV characters.
- Use the Character Bible, reconciliation document, and current Vertical Slice Specification for character facts. This table is not a replacement character dossier.

## 5. Environment register

The following are environment work packages, not claims that final artwork exists.

| Asset ID | Environment | Setting status | Visual asset status | Production state | Guardrails |
|---|---|---|---|---|---|
| BTV-ENV-001 | Logos Rhema Temple | CONFIRMED fictional in-game church | No approved environment reference identified in reviewed sources | PROPOSED package | Living community; not HCI's real building/branding; not a Covenant base. |
| BTV-ENV-002 | Covenant facility | CONFIRMED setting category | No single final facility concept approved in this register | PROPOSED package | Functional operational space; preserve Christian identity and practical contemporary design. |
| BTV-ENV-003 | Ridgeview | CONFIRMED vertical-slice location | Reference images require slice/canon audit before use | PROPOSED package | Follow Vertical Slice Specification; do not name/reveal restricted Devourer label to player or imply Ridgeview–Concordance connection. |
| BTV-ENV-004 | Contemporary urban district | WORLD CATEGORY | Specific named district UNKNOWN | PROPOSED package | Civilian life and infrastructure must feel plausible. |
| BTV-ENV-005 | School environment | WORLD CATEGORY / exact location UNKNOWN | No approved reference established | PROPOSED package | Do not invent a named school or claim a real institution. |
| BTV-ENV-006 | Hospital environment | WORLD CATEGORY / exact location UNKNOWN | No approved reference established | PROPOSED package | Respect medical setting and avoid using a real hospital identity without approval. |
| BTV-ENV-007 | Wilderness / Ember origin context | CANON DIRECTION | Exact location and final concept UNKNOWN | PROPOSED package | Ember's rare natural canid lineage and remote-wilderness origin; exact geography remains open. |
| BTV-ENV-008 | Veil-affected location | Veil operational rules APPROVED DESIGN | Specific visual treatment scene-dependent | PROPOSED package | Follow the operational laws; do not define ultimate Veil origin. |

## 6. Faction, uniform, props, and UI assets

| Asset ID | Asset group | Source status | Production state | Constraints |
|---|---|---|---|---|
| BTV-CLO-001 | Covenant field uniform family | LOCK / DIRECTION | PROPOSED detailed variants | White base, restrained gold, cross-centered insignia, practical tactical equipment. |
| BTV-LOG-001 | Covenant insignia | LOCK / DIRECTION | Exact approved master artwork must be retrieved | Do not redesign or replace the cross-centered identity without approval. |
| BTV-UI-001 | BTV HUD family | LOCK / DIRECTION | Foundation #12 v1.1 is controlling; exact layouts/tokens OPEN | Restrained blue/white/gold, dark/translucent panels, contextual states. |
| BTV-UI-002 | Ember companion UI | LOCK / DIRECTION | Exact component implementation OPEN | Must reflect current Ember canon and official commands. |
| BTV-LOG-002 | BTV game/channel logo | UNKNOWN unless a separately approved master asset is identified | BLOCKED for final branding | Do not assume an old mockup is official. |
| BTV-THM-001 | BTV colour tokens | Direction exists; exact values OPEN | PROPOSED specification | Do not publish exact colour values as canon before approval. |
| BTV-AUD-001 | Audio identity / score | UNKNOWN | PROPOSED | Original or appropriately licensed audio only. |

## 7. Existing reference asset register

| Reference ID | Existing asset | Current classification | Permitted handling |
|---|---|---|---|
| BTV-REF-001 | Asher Vance Character Showcase Sheet.png | REFERENCE CANDIDATE; printed age conflicts | Preserve original; use only for provisional visual study. Do not use printed age/height/build/accessory metadata as canon. |
| BTV-REF-002 | Asher Vance: Veilbound Facility Infiltration.png | HISTORICAL MOCKUP — NOT A SPEC | Do not implement its levels, XP, weapons/ammo, HUD, or legacy companion controls from the image. |
| BTV-REF-003 | Beyond the Veil: Last Watch Showcase.png | HISTORICAL UI MOCKUP — NOT A SPEC | Do not treat its level/XP/stat/loadout presentation as current system authority. |
| BTV-REF-004 | Ember: Afterfall Companion Profile.png | CROSS-PROJECT ASSET — NOT CONFIRMED AS BTV | Keep isolated from BTV references. |
| BTV-REF-005 | Covenant Faith-Military Character Design Board.png | REFERENCE CANDIDATE | Compare against Foundation #12 before any use. |
| BTV-REF-006 | Covenant Outpost with Wolf Companion.png | REFERENCE CANDIDATE | Does not establish Ember's exact appearance. |
| BTV-REF-007 | Other BTV-named showcase/HUD/environment images | REFERENCE CANDIDATE unless individually verified | Filenames and folders do not establish approval. See inventory audit. |

**Binary asset note:** The referenced Library images are not copied into this branch by this commit. Their original Library copies remain separate. This register records discovery and handling rules only.

## 8. Required fields for every future asset

Each new asset record must include:

- Asset ID;
- title and category;
- current status;
- source-of-truth dependency;
- exact source file(s);
- creator/source/provider;
- original filename and immutable location;
- hash/checksum when bytes are available;
- creation/acquisition date;
- licence and usage terms;
- intended use and prohibited uses;
- prompt/reference IDs for generated content;
- provider/model/version/settings;
- credit cost;
- review evidence;
- approval owner and date;
- version and change history.

If provenance, licence, or approval is unknown, mark it UNKNOWN or BLOCKED. Do not ship it.

## 9. Minimum reference package

### Asher
- Confirm the exact approved gameplay references and preserve their provenance.
- Reconcile the Character Showcase Sheet's age conflict before deriving a final model sheet.
- Create front/side/back, face, expression, silhouette, and justified equipment-variant references.
- Keep age presentation at 18 for the controlling slice.
- Do not infer height or other unapproved physical measurements.

### Ember
- Preserve rare natural canid lineage.
- Create a grounded canid anatomy and silhouette reference only after source review and creator approval of exact appearance.
- Keep exact breed/appearance OPEN.
- Do not use Afterfall reference art as a substitute.

### Slice cast
- Prepare source-grounded character briefs before visual generation.
- Keep church characters visually distinct from Covenant personnel.
- Keep Dorian Pike and Wren consistent with slice-specific characterization.
- Do not add unnamed characters' identities without approval.

### Environments
- Start with Logos Rhema Temple and the slice's actual Ridgeview locations only after reviewing the controlling slice spec and any available reference provenance.
- Build Covenant facility and wider world packages as separate work only when required by an approved sequence.

## 10. Quality and approval gates

For each asset, record:
1. **Canon gate:** no contradiction with current authority.
2. **Reference gate:** identity and reference provenance are known.
3. **Rights gate:** original or appropriately licensed.
4. **Technical gate:** correct format, resolution, rig/material/import where relevant.
5. **Continuity gate:** matches approved character/location/faction references.
6. **Accessibility gate:** readable and usable at target display sizes.
7. **Human approval gate:** exact asset accepted for a defined purpose.

A prompt, generation, or draft image does not pass the approval gate automatically.

## 11. Immediate work queue

| Priority | Task | Dependency | Status |
|---|---|---|---|
| P0 | Retrieve and identify approved Asher gameplay references | Library/reference access and provenance | BLOCKED / IN PROGRESS |
| P0 | Reconcile showcase sheet's age conflict and define allowed use | Creator/source confirmation | BLOCKED |
| P0 | Retrieve Foundation #11 Ember Companion Bible and register its exact source | Source library | DOCUMENTED in visual audit; exact image appearance OPEN |
| P1 | Prepare source-grounded Asher and Ember visual briefs | P0 source verification | QUEUED |
| P1 | Prepare Logos Rhema Temple and Ridgeview environment briefs | Vertical Slice Specification and provenance | QUEUED |
| P2 | Storyboard a pilot sequence | Approved cast, references, script | QUEUED |
| P2 | Test a low-cost/free generation and editing pipeline | Rights/terms and asset references | QUEUED |
| P3 | Produce, QA, and seek approval for the pilot | All prior gates | NOT READY |

## 12. Current verified state (2026-11-18)

- Repository `KINGACEX/beyond-the-veil-last-watch-` is accessible with push permission.
- Documentation branch `docs/btv-visual-production-001` was created from `btv/bootstrap-prototype-001`.
- Existing Foundation #12 Visual/UI/HUD Bible v1.1, Character Bible, Canon Reconciliation v1.1, and visual-reference audits were inspected.
- The registry is documentation-only. No runtime code, game scene, asset binary, canon source, or existing project file is changed by this document.
- No image/video generation, credits, trial activation, paid service, public publishing, Godot test, Android build, or device test occurred as part of this registry.

## 13. Final rule

**A reference is not automatically approved. A generated asset is not automatically canon. A documented asset is not automatically implemented.**

Maintain one source of truth, preserve originals, record provenance, and improve BTV without reinventing it.

**End — Visual Asset Registry v1.0 (Draft).**
