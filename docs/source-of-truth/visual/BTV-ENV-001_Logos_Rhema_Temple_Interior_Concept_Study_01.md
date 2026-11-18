# BTV-ENV-001 — Logos Rhema Temple Interior
## Visual Concept Study 01

**Status:** PROPOSED VISUAL CONCEPT — NOT APPROVED / NOT CANON-LOCKED  
**Asset:** `assets/concepts/environments/BTV-ENV-001_logos-rhema-temple-interior_concept-v01.svg`  
**Source project:** Beyond the Veil: The Last Watch  
**Purpose:** Explore a possible visual treatment for the established fictional church interior.

---

## 1. Source-grounded constraints

The controlling Vertical Slice Specification v1.0 establishes:
- Logos Rhema Temple is a fictional in-game church.
- It is a living community space, not a Covenant base, faction menu, reward station, or buff location.
- The congregation does not know Asher is Covenant.
- The church service has flexible, approved phases; its exact world activity must not be reduced to a linear checklist.
- Ember accompanies Asher but waits at a designated spot under Hold and does not disrupt worship or Communion.
- Public/community spaces should contain substantially more civilians and worshippers than Covenant personnel.

The Church/HCI/Service/Communion Bible establishes that real HCI is inspiration only. No real HCI identity, official branding, leadership, or institutional representation is depicted here.

## 2. Existing reference inspected

The Library contains `chapel_actual_render.png`, a simple untextured greybox-style chapel interior. It was inspected as a reference candidate. It shows a central aisle, paired seating, raised front platform, lectern, cross, windows, and ceiling structure.

The reference's approval status is not established by its filename. This concept uses the broad spatial arrangement as a starting point; it does not claim that every architectural detail is locked.

## 3. Concept exploration

The SVG study explores:
- a symmetrical central aisle and readable seating layout;
- a modest raised platform and simple lectern;
- a clearly visible but restrained cross;
- practical daylight from side windows;
- warm timber and neutral wall/floor materials;
- a welcoming, contemporary community-church atmosphere;
- three camera studies: central establishing view, side seating view, and platform detail.

The concept intentionally avoids cathedral scale, overt military styling, supernatural effects, and real-world church branding.

## 4. What is not established by this concept

The following remain open and must not be treated as canon:
- exact building footprint, location, regional architecture, exterior design, dimensions, materials, colour palette, furniture count, windows, ceiling height, stage design, lighting fixtures, plants, signage, and decoration;
- whether the existing greybox render is the final layout;
- final lighting/time-of-day state;
- final NPC placement, population, or service staging.

No character appearance is defined by this asset.

## 5. Review gates

| Gate | Result |
|---|---|
| Canon conflict scan | PASS — no intentional conflict identified |
| HCI representation boundary | PASS — no real HCI branding or identity |
| Visual originality | PASS — original BTV concept study |
| Layout provenance | PARTIAL — based on a Library reference candidate |
| Creator approval | PENDING |
| Runtime implementation | NOT IMPLEMENTED |
| Godot / Android verification | NOT TESTED |

## 6. Intended next use

If accepted, this study can guide a detailed environment reference package and later greybox refinement. Before implementation:
1. Compare with the current Godot chapel greybox and controlling slice.
2. Confirm which layout details should remain.
3. Create an approved exterior/interior reference set.
4. Prepare mobile-scale sightline, NPC density, and navigation checks.
5. Only then derive modular environment assets.

## 7. Provenance

- Existing reference: ChatGPT Library file `chapel_actual_render.png` (reference candidate; not copied into repository).
- Vector concept: original SVG authored for this BTV workstream.
- Separate raster concept preview was generated during this session but is not committed; the current GitHub connector's file-write action supports UTF-8 text files only. The SVG is the durable, repository-stored visual deliverable.
- No external image, real church photograph, HCI branding, or third-party asset is embedded.

**Decision:** Keep as PROPOSED VISUAL CONCEPT until creator review.

**End — BTV-ENV-001 Concept Study 01.**
