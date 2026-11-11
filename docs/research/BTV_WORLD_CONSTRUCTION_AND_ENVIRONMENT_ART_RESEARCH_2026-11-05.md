# BTV WORLD CONSTRUCTION AND ENVIRONMENT-ART PRODUCTION RESEARCH
**Date:** 5 November 2026  
**Status:** DEVELOPER CASE STUDIES + GDC MATERIAL + PROPOSED BTV WORKFLOW  
**Project:** Beyond the Veil: The Last Watch  
**Scope:** Open-world/region construction, level-art phases, modular vegetation, points of interest, wilderness/interstitial spaces and production constraints.

## 1. Case study: Diablo IV — The Art of Open World Sanctuary

**Official GDC session listing:** “Diablo IV: The Art of Open World Sanctuary,” GDC 2024. Speakers listed include Mahreen Fatima, Sam Gao and Justin Whitehead (Blizzard Entertainment).  
GDC Vault: https://gdcvault.com/browse/gdc-24/  
Microsoft GDC schedule: https://developer.microsoft.com/en-us/games/events/gdc/2024/

Accessible supporting slide material:
- Mahreen Fatima, GDC 2024 level-art slides: https://www.artstation.com/artwork/wred8Y
- Sam Gao, GDC 2024 environment-art presentation portfolio: https://fallbrumby.artstation.com/projects/1NQRL2

The accessible slide material shows a staged level-art process:
- **Blockout:** validate the basic space and its large-scale layout.
- **Presentable:** establish the terrain material palette, improve transitions between roads and wilderness, add decals and move the space toward a coherent visual target.
- **Shippable:** refine the full environment and respond to polish feedback.

The slides distinguish two broad open-world space types:
- **Points of interest (POIs):** authored destinations with a clear identity or purpose.
- **Wilderness/interstitial spaces:** the spaces between destinations that connect, pace and contextualise the journey.

The material also highlights making navigation boundaries readable, including navmesh edges, and treating transitions between terrain materials and adjacent spaces as deliberate art/design work rather than leftover gaps.

**Evidence limitation:** the full GDC video was not accessible in this review. The phase and space-type observations are based on the available speaker-associated slide material and official session metadata, not a full transcript. Do not overstate this as a complete reconstruction of Blizzard's pipeline.

## 2. Case study: modular vegetation under severe production constraints

**Primary practitioner talk:** Jobye Karmaker, “Approaching Modular Vegetation in Games,” Digital Dragons (2019).  
https://www.youtube.com/watch?v=NuBMKTFLBFE

The speaker describes work on five open-world levels in Middle-earth: Shadow of War, with one dedicated vegetation content artist responsible for the vegetation workstream. The talk is structured around:
- modular approach philosophy;
- trunk and bark creation;
- leaf and tree modelling;
- gameplay bushes;
- ground foliage and layout;
- tuning and final polish.

The talk description identifies the production challenge as creating trees, gameplay bushes and ground foliage across several open-world levels within a constrained schedule. The accessible transcript excerpt explains a modular separation of branch and leaf components, including a stated benefit of improving texture resolution and the resulting three-dimensional appearance. The talk explicitly discusses pros, cons and areas for improvement.

**BTV implication:** vegetation should be treated as a family of reusable asset types with distinct purposes—not as one generic foliage mesh. Trees, shrubs that affect player visibility/navigation, and ground cover have different gameplay, readability and performance requirements. This is a principle to test, not a reason to reproduce the exact Shadow of War system.

## 3. Case study: small environment team and modular production

**Official GDC session:** Aasim Zubair, Striking Distance Studios, “Building a Next Gen World with a Small Environment Team” (GDC 2023).  
https://gdcvault.com/play/1028977/Building-a-Next-Gen-World

The official session abstract describes building a AAA world on short deadlines with a small environment team, and identifies modularity, materials, scan data and marketplace assets as areas of the process. The session is members-only in the available GDC Vault view; the full presentation was not accessed.

**Evidence limitation:** only the official abstract is used here. It supports the fact that the talk covers those production topics, not detailed claims about the speaker's exact implementation or results. No marketplace purchase or asset download was made.

## 4. Synthesis: how a region should be constructed

The case studies support a layered approach to world construction. For BTV, the following is **PROPOSED**:

### Layer 1 — Region brief
Define:
- the region's narrative role and player purpose;
- environmental identity and time/weather;
- playable boundaries and excluded areas;
- required mission beats and POIs;
- traversal expectations and accessibility/readability needs;
- target hardware constraints once verified.

### Layer 2 — Macro layout
Define:
- major routes and alternate routes;
- POIs and the wilderness between them;
- sightlines, landmarks and orientation cues;
- entrances, exits, boundaries and return paths;
- safe/recovery spaces and optional exploration spaces;
- where players should naturally pause, observe or change direction.

### Layer 3 — Functional blockout
Use simple geometry and placeholder materials to validate:
- scale and traversal time;
- route readability;
- elevation changes and line of sight;
- player movement and interaction reach;
- AI/navigation boundaries;
- mission beat placement;
- unintended shortcuts, dead ends and softlocks.

### Layer 4 — Environment art
Create and integrate:
- modular architecture and structural kits;
- terrain and road materials;
- trees, shrubs and ground cover as separate asset classes;
- reusable props and set dressing;
- surface variation, decals and transition pieces;
- landmarks that reinforce spatial memory.

### Layer 5 — Lighting, atmosphere and audio
Use these systems to:
- distinguish spaces and time of day;
- establish mood;
- make important routes and points of interest readable;
- support environmental storytelling;
- avoid hiding essential traversal or interaction information.

### Layer 6 — Validation and polish
Test the region at blockout, presentable and shippable stages. Do not assume that art polish preserves the original layout's readability. Re-run traversal, navigation, accessibility and performance checks after significant visual changes.

## 5. POI and wilderness contract for BTV

A region should not be designed as a chain of equally dense attractions. The distinction between destinations and connective space can help control pacing and production scope.

For each proposed POI:
- state its purpose;
- define how it is discovered;
- identify what the player can do there;
- define entry/exit routes and re-entry behaviour;
- define whether it contains mission-critical information or optional content;
- define what remains if the player bypasses it.

For wilderness/interstitial space:
- define the travel purpose and intended duration;
- provide orientation cues without constant HUD dependence;
- avoid empty travel that adds only time;
- avoid overloading every route with combat or collectible distractions;
- use environmental changes to communicate proximity to the next destination;
- test whether the player can recover orientation after detours.

This is a planning framework, not a decision to make BTV open-world. BTV's approved world structure remains semi-open interconnected regions.

## 6. Vegetation and environment asset contracts

| Asset class | Functional questions | Required checks |
|---|---|---|
| Large trees | Landmark, occlusion, boundary or atmosphere? | Silhouette readability, collision, shadow and visibility cost |
| Shrubs/bushes | Can they conceal, block or guide the player? | Visibility, collision, navigation and interaction consistency |
| Ground foliage | Pure decoration or traversal cue? | Density, material transitions, clipping and overdraw |
| Rock/terrain modules | Structural boundary or decoration? | Walkability, collision, navmesh edge and scale |
| Architecture modules | Reusable structure or unique landmark? | Snapping, pivots, material consistency and route readability |
| Props | Storytelling, interaction or set dressing? | Provenance, interaction visibility and performance |
| Decals/material transitions | Surface storytelling and space definition? | Z-fighting, repetition, visual noise and readability |

## 7. Failure modes and loophole checks

| Failure mode | Risk | Acceptance evidence |
|---|---|---|
| POIs feel disconnected | Player loses spatial understanding | First-time route comprehension and return-path test |
| Wilderness is empty or overfilled | Pacing collapses | Travel-time and engagement review |
| Vegetation hides important cues | Players miss routes/interactables | Readability test at typical camera distance |
| Vegetation is purely decorative but too expensive | Performance spent without gameplay/story value | Asset cost versus purpose review |
| Navmesh boundary is visually unclear | Player/AI movement feels inconsistent | Visual boundary and traversal test |
| Art pass changes route width | Previously valid path becomes blocked | Re-run traversal and collision tests |
| Repeated modules look artificial | World loses visual identity | Repetition and silhouette review |
| Modular kit creates inconsistent scale | Assets do not fit together | Snap/scale/pivot validation |
| Scan data increases asset cost | Excessive memory or poor mobile fit | Texture/mesh budget and device profiling |
| Marketplace assets create provenance/licensing risk | Legal and visual inconsistency | License and provenance record before use |
| Terrain transitions are abrupt | Region reads as stitched assets | Transition review at walking speed |
| Boundaries are invisible | Players reach unintended out-of-bounds spaces | Boundary/return-path test |

## 8. BTV-specific constraints
- Do not expand BTV into a full open world; retain semi-open interconnected regions.
- Do not introduce POIs or wilderness details that conflict with the recovered Vertical Slice v1.0.
- Do not add mission-critical facts, church details or Veil lore through environment props without source review.
- Do not reveal Devourers in Ridgeview through environmental art.
- Do not infer Asher or Ember appearance from other games' art pipelines.
- No paid marketplace assets, scan libraries or subscriptions without approval.
- No renderer choice or Android readiness claim without target-device evidence.

## 9. References and evidence quality
- GDC 2024 “Diablo IV: The Art of Open World Sanctuary”: official session listing plus speaker-associated slide material. Full video not accessed.
- Jobye Karmaker, “Approaching Modular Vegetation in Games” (Digital Dragons, 2019): public developer talk and transcript. First-person practitioner evidence; one artist/project context.
- Aasim Zubair, “Building a Next Gen World with a Small Environment Team” (GDC 2023): official session abstract only; full session access restricted.
- Previously reviewed GDC Blockmesh and Lighting workshop and The Level Design Book remain relevant for functional layout and art-pass sequencing.

## 10. Next research
- Terrain workflows and region streaming in Godot 4.7.
- Navigation and boundary validation with NavigationServer3D/NavMesh.
- Mobile-friendly foliage/LOD/visibility strategy, validated against official Godot docs.
- Mission scripting, world-state persistence and region re-entry.
- Environment storytelling and narrative POI design.
