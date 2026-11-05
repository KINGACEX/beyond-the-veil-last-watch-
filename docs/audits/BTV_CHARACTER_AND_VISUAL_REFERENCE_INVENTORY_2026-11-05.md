# BTV CHARACTER & VISUAL REFERENCE INVENTORY AUDIT
## Asher Vance, Ember, named cast and related visual assets

**Date:** 5 November 2026  
**Status:** COMPLETED — read-only source discovery and visual-reference audit  
**Branch reviewed:** `btv/bootstrap-prototype-001`  
**Branch head at inspection:** `c36b05d5264d2a236334f00369d0304bed282ec4`  
**Scope:** Library character references, visual assets, character authority documents, and current repository source tree.  
**No game code, canon source, original Library file, or asset was modified. No tests or builds were run.**

---

## 1. Executive result

The Library contains a wider BTV visual archive than previously indexed. It includes multiple Asher-branded images, a character showcase sheet, an Asher infiltration/gameplay mockup, Covenant identity and equipment concepts, and other world/mission imagery.

The evidence does **not** establish that every image is an approved final gameplay reference. Image titles and folder placement are provenance clues, not approval records. All unverified artwork is therefore classified as **REFERENCE CANDIDATE — APPROVAL/PROVENANCE UNKNOWN**.

The strongest immediate Asher source is **Asher Vance Character Showcase Sheet.png**. It is a multi-angle character turnaround with expression studies and equipment details. Its printed age is “Early 20s”, which conflicts with the controlling vertical-slice presentation of age 18. It also lists approximate height and physical/build details that are not established canon. Treat those fields as unapproved concept metadata, not character facts.

A second asset, **Asher Vance: Veilbound Facility Infiltration.png**, is a gameplay-style screenshot/mockup. It visibly contains older or incompatible mechanics and UI. It must not be used as an implementation specification.

No confirmed BTV visual reference for the five named Logos Rhema leaders, Dorian Pike or Wren was established in the inspected results. An Ember-branded profile exists in an **Afterfall** subfolder and must not be assumed to depict BTV's Ember.

---

## 2. Controlling character facts

### Asher Vance — CONFIRMED / LOCKED

- Sole playable protagonist and Chosen.
- Human, never divine and never a replacement for Christ.
- Presented as age **18** in the locked vertical slice; broader canon age range 16–19.
- Covenant Agent/Specialist (one tier), Watcher branch.
- Trained field operative; can defend himself and protect civilians.
- Not a Team Leader in the slice; no promotion during the slice.
- Full biography, birthplace, family, detailed personality, exact appearance, detailed combat style and dialogue voice remain open unless a later explicit creator decision establishes them.

### Ember — CONFIRMED / LOCKED WITH RECONCILIATION

- Asher's intelligent animal companion and field partner, not a weapon or spiritual authority.
- Foundation #11 — Ember Companion Bible v1.0 locks a rare original naturally occurring canid lineage and a remote-wilderness origin associated with long-standing Veil disturbances.
- Exact appearance and breed characteristics remain open.
- Limited Veil sensitivity; not omniscient and does not speak for God or replace the Holy Spirit.
- Official commands: Attack, Protect, Scout, Track, Retrieve, Hold, Regroup. “Stay” is legacy wording for Hold; Follow and Guard are not official commands.
- Abilities: Veil Sight, Guardian Instinct, Veil Energy, Tracking Sense, Spirit Guidance.
- Character Bible v1.0 and older Master Canon exports contain stale UNKNOWN entries for species/origin; the later Foundation #11 lock supersedes those entries where they conflict.

### Locked named human cast — VERTICAL-SLICE SCOPE

**Logos Rhema Temple**
- Pastor Elias Warrick — Senior Pastor, 61; unhurried, dry humor, former history teacher.
- Pastor Maribel Santos — Associate Pastor, 38; warm and direct, former hospital nurse.
- Tobias Reed — Worship Leader, 29; gentle and earnest, former session musician.
- Deacon Amos Whitaker — Communion Steward, 72; quiet and precise, retired baker.
- Leah Okoye — Youth and Community Ministry Leader, 26; energetic, grew up in the church's youth group.

These are original fictional characters and do not portray real HCI people.

**Ridgeview**
- Dorian Pike — local leader; calm, reasonable, persuasive; not a one-dimensional villain. Slice details place him in his mid-fifties and formerly responsible for supply/logistics.
- Wren — frightened resident who wants out; in her twenties in slice design; partial knowledge, fear and uncertainty; not an exposition device.

**Unnamed by design**
- Scout who gathered and sent the report.
- Covenant duty officer.
- Visitor at Logos Rhema.
- Ridgeview repairman.

Do not assign names or identities without approval.

**Reserved**
- Ayla, the human Covenant Shepherd, and other teammates are outside the vertical slice. Ayla must not be introduced as an implemented or locked slice character.

### Wider story direction — CONFIRMED STORY DIRECTION / DETAILS OPEN

- Marek Sloane is the central human antagonist and architect of a covert crisis-manipulation network provisionally named the Concordance.
- Sloane is human; he exploits Veil incidents but does not create or command the Veil.
- Concordance membership, full hierarchy, named lieutenants, and final legal outcome remain UNKNOWN.
- The Ridgeview slice must not identify or hint at the Devourers or establish a Ridgeview–Concordance connection.

### Other character categories — UNKNOWN

Named Covenant leadership, permanent teammates, mentors, wider civilian roster, regional leaders and recurring NPCs are not established by the reviewed Character Bible. Do not promote concept art or placeholder names into canon.

---

## 3. Asher Vance visual references discovered

| Asset | Provenance / observed content | Status and handling |
|---|---|---|
| `Asher Vance Character Showcase Sheet.png` | Root Library image. Front/side/back turnaround, portrait, four expressions, necklace, harness/strap, fabric, backpack, boots and glove details. Printed character info says “Protagonist / Chosen”, “Early 20s”, athletic/functional, approx. 1.85 m, tactical/adventure/survival, calm/brave/compassionate. | **REFERENCE CANDIDATE.** Useful for continuity study. Printed age conflicts with age-18 slice presentation. Height/build/attitude and specific accessories are not established canon. Do not treat as final approved model sheet until provenance/approval is confirmed. |
| `Asher Vance: Veilbound Facility Infiltration.png` | Root Library image. Third-person gameplay-style mockup with Asher, a canine companion, Covenant Credits/Aces, level display, weapon/ammunition UI, enemy health bar, objective list and companion controls. | **HISTORICAL MOCKUP — NOT A SPEC.** Conflicts with current slice scope and/or current command/UI direction. Do not implement its levels, weapon loadout, ammo, objective HUD, ability icons or companion commands from this image. |
| `Asher Vance: Beyond the Veil.png` | Library image under Game Development folder. Search/read returned the asset, but raw-byte materialization was not authorized in this pass. | **REFERENCE CANDIDATE — NOT VISUALLY VERIFIED IN THIS PASS.** |
| `Beyond the Veil: Asher Vance.png` | Library image under Game Development folder. Search/read returned the asset, but raw-byte materialization was not authorized in this pass. | **REFERENCE CANDIDATE — NOT VISUALLY VERIFIED IN THIS PASS.** |
| `Beyond the Veil: Last Watch Showcase.png` | Root Library image. Extracted visible text describes a main-menu/character/gear UI mockup, Asher “Chosen + Field Member”, Level 12, XP bar, health/stamina/damage/armor stats, Armor of God equipment tiles, inventory/crafting/loadout, currencies and an alert. | **HISTORICAL UI MOCKUP — NOT A SPEC.** Level/XP/stat/equipment/ability presentation must not override current canon or approved slice design. |
| `Cinematic Asher Game HUD Visual Bible.png` | Root Library image; title suggests an Asher/HUD concept. | **REFERENCE CANDIDATE — NOT YET VISUALLY VERIFIED.** |
| `Beyond the Veil: The Last Watch.png`, `Beyond the Veil: The Last Watch(1).png`, `Beyond the Veil: The Last Watch(2).png`, `Beyond the Veil App Showcase.png`, `Beyond the Veil: Game App Screens.png` | Root Library images with BTV/game showcase naming. | **POTENTIAL UI / PROMOTIONAL REFERENCES.** Their canon and implementation status are not established by filenames alone. |

### Asher screenshot conflict notes

The infiltration mockup includes:
- “Lv. 17” and Ember “Lv. 5”.
- A companion control row reading Follow / Guard / Attack / Stay.
- A firearm and ammunition counter.
- An objective list and minimap/marker.
- A “Deceiver” enemy health bar.
- Ability icons and key bindings.
- Covenant Credits and Aces displayed as HUD counters.

These are visible in the image, but their presence does not establish that they are approved or implemented. The current official companion commands are Attack, Protect, Scout, Track, Retrieve, Hold and Regroup. The current slice is investigation-led and does not specify this full combat/weapon/HUD feature set. Treat this screenshot as a legacy concept requiring redesign/reconciliation before any reuse.

---

## 4. Ember and other character-related visual assets discovered

| Asset | Library location / evidence | Status |
|---|---|---|
| `Ember: Afterfall Companion Profile.png` | Located in the Game Development folder alongside Afterfall character profiles. | **NOT CONFIRMED AS BTV EMBER.** The “Afterfall” project context means it must not be adopted as BTV canon without explicit provenance. |
| `Covenant Faith-Military Character Design Board.png` | Root Library image. | **COVENANT VISUAL REFERENCE CANDIDATE.** Must be checked against white base, restrained gold, cross-centered insignia, believable contemporary clothing and branch/rank context. |
| `Stephen: Covenant Field Agent Profile.png` | Located in the Game Development folder. | **NOT CONFIRMED AS A BTV CHARACTER.** “Stephen” is not in the locked slice cast; no evidence here establishes him as a canon teammate. |
| `Covenant Guardian Equipment Screen.png` | Root Library image. | Equipment/UI concept, not character canon. |
| `Covenant Assault in the Purple Storm.png` | Root Library image. | Environment/action concept, not a character identity source. |
| `Covenant Mission Briefing at Sunset.png` | Root Library image. | Scene concept; no character identities established. |
| `Covenant Outpost with Wolf Companion.png` | Root Library image. | Companion/world concept candidate; cannot establish Ember's exact design. |
| `Covenant Watch Over the City.png`, `The Covenant: Faith in Action.png`, `The Covenant: Faith, Purpose, Together.png` | Root/Game Development image assets. | Faction/world concepts; not a verified roster or individual character canon. |
| `Devourers at Ridgeview Outpost.png` | Root Library image. | **RESTRICTED FROM SLICE USE.** The Devourers must not be named or identified to the player anywhere in the Ridgeview slice. This image is not permission to reveal them in slice UI, dialogue, objectives or reports. |

Other root visual assets found include `Riverside Market: Covenant City Mission.png`, `Neon Rain at Covenant Facility.png`, `Rainy Covenant Facility Infiltration.png`, and `Veil Disturbance: Riverside Café Investigation.png`. They are environment/mission references, not proof of character identities or approved production art.

---

## 5. Source conflicts and stale records

1. **Character Bible v1.0 is stale in several fields.** It says Asher's exact age is unknown and retains the dual-Chosen question; current decisions establish sole playable Asher presented as 18.
2. **Character Bible v1.0 Ember entry is stale.** It calls species and origin unknown; Foundation #11 locks a rare naturally occurring canid lineage and remote-wilderness origin. Exact appearance remains open.
3. **Asher Showcase Sheet age conflicts.** It says “Early 20s”; current slice presentation is 18.
4. **Asher Showcase Sheet measurements and traits are not canon.** Approximate height, build and attitude are visual-concept metadata only.
5. **Infiltration screenshot commands conflict.** Follow/Guard are not official commands; Stay is legacy wording for Hold.
6. **Infiltration screenshot systems are not approved by the slice spec.** Levels, XP, ammunition, firearm loadout, combat HUD and ability icons are not authorization to implement those systems.
7. **Afterfall assets are cross-project contamination risks.** Do not import Afterfall's Ember or Stephen as BTV characters.
8. **No approved-reference manifest was located in the reviewed sources.** Asset approval status remains UNKNOWN. This is a provenance gap, not proof that no approval exists elsewhere.

---

## 6. Character production requirements / next work

### P0 — Provenance and canon reconciliation
- Establish one authoritative Asher model/visual baseline. Use age 18 presentation.
- Identify whether the Character Showcase Sheet is approved, draft, or superseded.
- Separate Asher's character model from equipment/loadout variations so clothing changes do not silently change face, hair, proportions or age.
- Confirm whether the GLB package `Asher_Vance_Godot_Ready.zip` is the intended production model; its prior inspection found a GLB plus a minimal scene wrapper, not a complete Godot project.
- Create an approved-reference manifest with asset ID, original filename, hash, creator/source, date, approval status, canon fields represented, known conflicts and allowed uses.
- Keep the Afterfall Ember and Stephen assets isolated unless the creator explicitly identifies them as BTV assets.

### P1 — Character dossiers
Create source-grounded dossiers, without inventing unknown details, for:
1. Asher Vance.
2. Ember.
3. Elias Warrick.
4. Maribel Santos.
5. Tobias Reed.
6. Amos Whitaker.
7. Leah Okoye.
8. Dorian Pike.
9. Wren.
10. Marek Sloane.

Each dossier should distinguish locked facts, approved slice-only details, proposals, unknowns, visual evidence and knowledge boundaries. Keep the Scout, duty officer, visitor and repairman unnamed.

### P2 — Visual production
- Asher: face/hair/proportion reference, neutral front/side/back turnaround, expression sheet, equipment variants, silhouette and age-consistency checks.
- Ember: grounded canid silhouette and anatomy; no fantasy anatomy; exact lineage appearance awaits approval.
- Logos Rhema leaders: distinct everyday church/community clothing, not Covenant uniforms.
- Ridgeview cast: grounded civilian identities; no accidental Devourer labels or supernatural certainty.
- Covenant roster: branch/rank variation built on the white/gold/cross-centered identity without luxury fashion or rank-as-holiness cues.

### P3 — Integration and QA
- Add only approved assets to the Godot project.
- Verify scale, skeleton/rig, materials, texture import, animation compatibility, mobile memory/performance and scene integration.
- Do not claim a character is implemented until the model is in the project and verified in-engine.
- Do not run broad asset conversion or replace existing character scenes until the selected model and target Godot import path are confirmed.

---

## 7. Scope and evidence limitations

- Library image inventory was browsed in two pages of image-file metadata; the returned set included 183 image items in total across the two pages. The relevant filenames above were filtered by BTV/character-related terms. This is a Library metadata inventory, not a full semantic audit of every image's pixels.
- Raw-byte access was authorized for the Asher Character Showcase Sheet and the Asher infiltration mockup only. Other attempted materializations were denied by the Library authorization layer; no bypass was attempted.
- Other images with BTV-like names were located by metadata and/or search snippets but not all were visually inspected.
- The repository branch tree was inspected read-only. No character model or Ember scene was identified in the currently reviewed source tree; the tree does contain the Godot prototype and design documents. This is limited to the inspected branch tree.
- No Godot editor import, model render, runtime test, Android export or device test was performed.
- No canon decision was made and no code was changed.

---

## 8. Immediate recommended sequence

1. Finish visual inspection of the remaining BTV-named image assets that can be accessed through authorized Library reads.
2. Reconcile all character names/statuses against the latest Master Canon, Character Bible, Vertical Slice v1.0, Canon Reconciliation v1.1 and Mystery Register v0.3.
3. Build the approved-reference manifest and character dossier set as documentation-only deliverables.
4. Compare the approved Asher asset package with the selected visual baseline once authorized binary access and a suitable renderer are available.
5. Only then prepare an implementation ticket for Asher and Ember integration.

**Final audit state:** Documentation discovery COMPLETED for the inspected sources; complete visual approval provenance UNKNOWN; remaining image inspection and asset-to-model comparison BLOCKED by access/verification limits; no implementation claimed.
