# BTV Wildlife, Biodiversity and Ecosystem Simulation Research 001

**Date:** 2026-11-10  
**Engine target:** Godot 4.7.2  
**Platform:** Android-first, PC later  
**Status:** Research and prototype architecture. Species roster, habitats, animal behaviours and population numbers are proposals; none are locked as canon.

## 1. Design objective

Create wildlife that appears to belong to a living ecosystem rather than acting as scattered ambient props. The system should support animal observation, habitat identity, daily routines, environmental responses, migration/seasonal presence, sound and nonviolent player interaction.

The initial simulation should be deterministic, data-driven and inexpensive. Avoid simulating every animal at full fidelity. Use a tiered model:
- **Near field:** a small number of fully animated animals with simple movement and perception.
- **Mid field:** simplified agents with reduced update frequency and less animation.
- **Far field:** population counts, habitat occupancy and migration/seasonal presence without individual scene nodes.
- **Off-screen:** update population summaries and time budgets, not every animal's full physics.

The wildlife system is separate from combat and does not implement hunting, attacks, injury, capture, or weapon interactions. Animals should have space to avoid the player and each other; observation is the primary interaction.

## 2. Ghanaian ecological reference set

These references are ecological inspiration, not a mandate to copy a real protected area or claim that a BTV location is a real Ghanaian reserve.

### Moist evergreen / rainforest
Kakum's official Forestry Commission description records rainforest, tall hardwood canopy, elephants, bongo, red river hogs, primates, squirrels, hornbills, African grey parrots and a high diversity of butterflies. This supports a layered canopy ecosystem: emergent trees, mid-storey, understory, forest floor, streams and clearings.

### Guinea savanna and gallery forest
Mole's official profile describes Guinea savanna with gallery forest along rivers and streams, and records elephants, buffalo, roan, kob, hartebeest, waterbuck, primates and diverse birds. The dry season and rainy season create a strong basis for seasonal water, vegetation and animal distribution differences.

### Woodland savanna and river corridors
Bui's official profile describes woodland savanna, gallery forest, the Black Volta river system and a resident hippo population, alongside elephants, waterbuck, bushbuck, baboons, patas and green monkeys and numerous birds. This gives the design a strong riverbank/wetland interface.

### Coastal wetland and migratory shorebirds
The Songor Biosphere Reserve reference describes coastal/marine zones, lagoons, marshes, mangroves, waterlogged grassland and lower Volta freshwater habitats. It documents feeding/roosting areas for herons, egrets, cormorants, greenshanks, stilts and terns, plus coastal turtle nesting beaches. This is a reference for a distinct coastal/wetland biome, not an assumption that all species occur together.

### Important ecological constraint
Species should only be placed in habitats supported by credible range/habitat evidence. Do not build a single mixed "African wildlife" zone with all iconic animals together. Distinguish geographic range, habitat, water dependence, social grouping, activity period, diet and seasonal presence. Verify individual species records before locking the roster.

## 3. Proposed BTV biome layers

| Biome template | Habitat layers | Candidate wildlife categories | Key simulation signals |
|---|---|---|---|
| Moist forest | Canopy, mid-storey, understory, forest floor, stream | Primates, forest ungulates, birds, butterflies, small mammals | canopy cover, fruit/seed availability, water, cover, light |
| Savanna | Grassland, scrub, woodland islands, seasonal pools | Grazers, browsers, small mammals, ground/nesting birds | grass availability, shade, water, temperature, season |
| Gallery forest | Riverbank, dense riparian vegetation, open water | Water-dependent mammals, primates, fish-eating birds | water level, bank cover, river flow, safe roosts |
| Wetland/coast | Mudflat, marsh, mangrove, lagoon, beach | Waders, waterbirds, fish, crabs, coastal species | tide/water level, salinity, mudflat exposure, nesting/roosting |
| Highland/rocky | Rock faces, grass patches, woodland pockets | Cliff/rock-associated birds, small mammals | ledges, crevices, thermal exposure, vegetation pockets |

These are reusable biome templates. Actual BTV geography, names and species placement remain to be designed against the canon world map.

## 4. Animal agent model

### Data fields
A species profile should define:
- stable species ID and display name;
- habitat weights and biome tags;
- activity period (diurnal/nocturnal/crepuscular);
- social grouping (solitary/pair/family/flock/herd/colony);
- diet category (herbivore/frugivore/omnivore/insectivore/nectarivore/aquatic filter feeder, as evidence supports);
- preferred movement mode and speed range;
- perception radius and flight/avoidance distance;
- animation set and audio profile;
- conservation/rareness and spawn-density budget;
- seasonal availability and water/food requirements.

An individual agent should hold:
- stable agent ID and species ID;
- position, orientation and current locomotion state;
- hunger, thirst and energy (abstract normalized needs);
- current behaviour and target habitat patch;
- alertness/avoidance state;
- group membership;
- simulation LOD tier and last update tick.

Need values are internal simulation variables only; they should not become player-facing punishment systems.

### Behaviour state model

Initial nonviolent states:
1. **Idle/observe** — pauses and scans surroundings.
2. **Roam** — follows a local, habitat-valid wander target.
3. **Forage** — searches/feeds at an appropriate resource patch.
4. **Drink** — visits a valid water source when water access and thirst conditions permit.
5. **Rest** — recovers energy in a suitable safe place.
6. **Shelter** — moves under cover during severe weather.
7. **Social** — maintains simple spacing/group cohesion.
8. **Avoid** — increases distance from disturbance without attacking.

The initial prototype implements only habitat scoring, shelter/drink/forage/rest/roam selection, needs updates and deterministic ambient wandering. Social behaviour, perception, navigation, animation and avoidance remain subsequent work.

## 5. Habitat and population model

Habitat suitability is a weighted function of normalized environmental features, such as canopy, food access, water access and cover. A suitability score is not a guarantee of animal presence. Population distribution also depends on:
- habitat patch size and connectivity;
- food/water carrying capacity;
- seasonal availability;
- disturbance and refuge;
- species-specific group sizes;
- migration/dispersion;
- authored conservation and story constraints.

Do not spawn animals uniformly across the whole map. Use habitat patches and density budgets. Use soft caps and deterministic sampling to avoid population spikes.

### Population tiers
- Near: fully animated agents.
- Mid: simplified agents with coarse movement and fewer updates.
- Far: aggregate counts and occupancy per habitat patch.
- Dormant: no per-animal update; only coarse seasonal/population state.

This LOD approach reduces CPU and memory load on Android and avoids creating hundreds of physics actors.

## 6. Weather, light and seasonal coupling

Weather and wildlife should communicate through a shared environmental state, but wildlife must not become coupled to rendering effects.

Examples:
- Rain can increase surface wetness and alter access to temporary water patches after a delay.
- Dry periods can lower temporary water availability and shift animal occupancy toward persistent water sources.
- Wind changes vegetation and sound presentation; it should not forcibly push animals around.
- Dawn/dusk can shift activity weights for diurnal and crepuscular species.
- Severe weather can trigger shelter behaviour.
- Cloud/fog visual settings must not change animal navigation or habitat suitability directly.

Use a simulation clock and explicit season/weather inputs. Keep the first version deterministic and avoid real-time meteorological complexity.

## 7. Godot implementation approach

- Represent species definitions as Resources or structured data assets, not hard-coded scene-specific logic.
- Keep pure simulation calculations in RefCounted scripts so they can be tested headlessly.
- Use reusable animal scenes with separate animation, navigation and audio components.
- Use NavigationAgent3D only for near/mid-field agents that need path-following. Godot documents that the agent computes path information but does not move its parent; movement remains the controller's responsibility.
- Navigation avoidance is a separate optional feature. It only considers registered avoidance agents/obstacles and does not understand navigation mesh geometry by itself.
- Use AnimationTree state machines for animation transitions, not for ecological decision-making.
- Use MultiMesh/instancing for distant static flocks or repeated ambient visuals where appropriate.
- Do not run full navigation, perception and animation on all animals every frame.
- Keep species count, animation complexity, particle effects and active agents behind quality budgets.

## 8. Prototype simulation implemented in this branch

Initial pure module: `scripts/wildlife_ecology_sim.gd`.

It provides:
- weighted habitat suitability;
- habitat viability threshold;
- deterministic behaviour selection for shelter, drink, forage, rest and roam;
- bounded hunger/thirst/energy updates;
- stable deterministic wander direction derived from agent ID and simulation step.

Automated tests: `tests/wildlife_ecology_sim_test.gd`.

The prototype deliberately does not include attacks, hunting, capture, injury, or combat. It also does not yet include individual species resources, navigation, animation or population spawning.

## 9. Validation plan

1. Unit-test habitat scoring, threshold boundaries and missing data.
2. Test behaviour priority under storm, thirst, hunger, low energy and stable conditions.
3. Test needs clamping, zero/negative delta and large delta.
4. Test deterministic wander outputs for repeatability and agent variation.
5. Add species profile schema validation and habitat compatibility tests.
6. Build a separate wildlife validation scene with primitive placeholder shapes and debug labels.
7. Add group spacing and simple avoidance tests.
8. Add LOD/population-budget tests before large-scale spawning.
9. Add navigation/animation integration only after the data simulation is stable.
10. Profile on actual Android hardware before selecting active-agent and draw-distance budgets.

## 10. Approval and canon gates

- This research does not approve a final species roster, region names, population densities or story encounters.
- Real species distribution must be checked before any final species is placed.
- Animal companionship or Ember interactions must not override established Ember canon.
- Do not introduce animal harm or hunting systems.
- Keep wildlife observation and nonviolent interaction as the baseline.
- No production-region integration until the separate lab passes tests and device profiling.

## 11. Sources

- Forestry Commission — Kakum National Park & Assin: https://fc.gov.gh/kakum-national-park-assin/
- Forestry Commission — Mole National Park: https://fc.gov.gh/mole-national-park/
- Forestry Commission — Bui National Park: https://fc.gov.gh/bui-national-park/
- Forestry Commission — Wildlife Division: https://fc.gov.gh/the-wildlife-division/
- Ghana Commission for UNESCO — Preserving Flora and Fauna at Biosphere Reserves (Songor): https://unescoghana.gov.gh/publication/preserving-flora-and-fauna-at-biosphere-reserves/
- Ghana Forest and Wildlife Policy: https://faolex.fao.org/docs/pdf/gha144198.pdf
- Godot 4.7 — NavigationAgents: https://docs.godotengine.org/en/4.7/tutorials/navigation/navigation_using_navigationagents.html
- Godot 4.7 — AnimationTree: https://docs.godotengine.org/en/4.7/tutorials/animation/animation_tree.html
- Godot 4.7 — Node/scene concepts: https://docs.godotengine.org/en/4.7/getting_started/introduction/key_concepts_overview.html
