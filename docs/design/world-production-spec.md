# BTV World Production Specification

**Version:** 0.1  
**Status:** Approved design direction; production implementation and performance validation pending

## 1. World goals

Build an interconnected, readable world that supports exploration, investigation, NPC interaction and mission progression while remaining feasible for an Android-first Roblox experience.

## 2. Region plan

### Temple
- Recognizable approach and entrance.
- Clear player navigation and interaction area.
- Distinct interior/exterior landmarks.
- Controlled lighting and readable sightlines.
- A clear opening-mission start and transition path.

### Ridgeview
- Settlement entrance.
- Central gathering area.
- Residential spaces.
- Community and service spaces.
- Investigation locations.
- Camp area.
- Ridge trail and surrounding wilderness.

The existing prototype's Ridgeview transition has been described as a same-place transition. Do not claim separate-place streaming or a cinematic transition unless implemented and verified.

### Extended wilderness
- Distinct biomes and navigational landmarks.
- Exploration routes with deliberate pacing.
- Mission-gated points of interest.
- Environmental clues that support, but do not replace, attributed evidence.

## 3. NPC population and roles

Recommended NPC groups:
- Residents and civilians.
- Covenant agents.
- Community leaders.
- Mission-specific investigative characters.
- Background civilians and ambient life.

Public community spaces should feel civilian-led rather than dominated by Covenant agents. NPC presence must serve the location and story rather than exist only as decoration.

## 4. Environmental storytelling

Use:
- abandoned or disused spaces,
- landscape and weather clues,
- physical records and objects,
- ambient sound and lighting,
- traces of recent activity,
- changes that reflect mission progression.

Environmental clues should not automatically establish an interpretation. Preserve the distinction between what the player sees and what the player concludes.

## 5. Production architecture

Proposed practices:
- Modular environment kits.
- Reusable material and prop sets.
- Region-specific asset budgets.
- Streaming-aware placement and lifecycle.
- Event-driven NPC routines.
- Shared interaction contracts rather than duplicated local scripts.
- Stable identifiers for mission-relevant objects.
- Clear ownership of shared map and service files between agents.

## 6. Android performance direction

Design targets, not measured results:
- Target 30 FPS on the minimum supported device.
- Limit simultaneous active NPC routines.
- Use dynamic lights selectively.
- Control particles, transparency and overdraw.
- Stream or deactivate distant region content.
- Avoid expensive per-frame scripts where event-driven updates suffice.
- Profile real Android devices before declaring optimization complete.

## 7. Parallel workstream boundaries

Suggested ownership:
- **Temple Agent:** Temple blockout, landmarks and opening interaction spaces.
- **Ridgeview Agent:** settlement, camp and investigation layout.
- **Environmental Storytelling Agent:** non-overlapping props, clues and ambient details.
- **Optimization Agent:** profiling and evidence-based performance recommendations.

Before assigning work, declare exact file and map ownership. Shared scripts, spawn systems, mission gates and common world roots require a single owner or explicit integration window.

## 8. World acceptance checklist

- [ ] Temple navigation and opening interaction work.
- [ ] Ridgeview entry, settlement and camp are navigable.
- [ ] Investigation points are readable without excessive UI guidance.
- [ ] Mission-relevant objects have stable IDs and server validation.
- [ ] NPCs have bounded lifecycle and cleanup.
- [ ] Region transitions do not leave stale prompts or actors.
- [ ] World content streams or deactivates safely.
- [ ] Mobile performance is profiled on representative devices.
- [ ] Environmental clues preserve evidence attribution and uncertainty.

## 9. Status discipline

Greybox Parts and scripted blockouts are valid prototype material, but they are not production art. Do not describe the world as final, asset-complete or mobile-optimized without corresponding evidence.
