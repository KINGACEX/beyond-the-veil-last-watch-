# BTV Wildlife Candidate Catalogue Research 001

**Status:** Evidence-backed research candidates only; not a final species roster or production placement approval.  
**Scope:** Ghana reference habitats, selected international ecosystems and separated palaeo-ecosystem records.  
**Engine target:** Godot 4.7.2; data-contract validation is in `scripts/wildlife_species_profile.gd`.

## 1. Rules for interpreting this catalogue

1. A reserve-level checklist establishes a candidate reference, not guaranteed encounter frequency or local presence in every part of that reserve.
2. Common-name groups remain group-level until a taxonomic authority verifies the scientific name and accepted taxonomy.
3. A species can only enter a species resource after its range, habitat, locality, evidence, seasonality and conservation status have been checked against dated sources.
4. A shared biome label does not prove that species co-occur. For palaeo records, compatible geological age, locality/formation and depositional context are required.
5. Extant, reintroduced, regionally extirpated, extinct and fossil-only records must remain distinct.
6. Colour, calls, social behaviour and detailed locomotion are marked uncertain when the source does not establish them.
7. All candidate wildlife remains observation/ecology-first and nonviolent. No hunting, attack, capture or injury behaviours are part of this catalogue.

## 2. Ghana reference habitats

### 2.1 Kakum moist evergreen forest

**Habitat evidence:** Ghana Forestry Commission describes Kakum as moist evergreen forest, with tall forest structure, trails and canopy habitat. It reports about 40 larger mammal species and roughly 200 bird species.

**Candidate groups recorded by the Forestry Commission:** elephants, bongo, red riverhog, primates and squirrels; birds include hornbills, African grey parrot and Senegal parrot.

**Data status:** group/common-name candidates. Do not assign exact scientific names to generic primate or squirrel groups. Verify taxon, current range and habitat layer before making individual species records. Forest canopy, understory, ground and river-edge niches should be separate habitat descriptors rather than one generic forest flag.

Source: https://fc.gov.gh/kakum-national-park-assin/

### 2.2 Mole Guinea savanna and riparian forest

**Habitat evidence:** Ghana Forestry Commission describes Guinea savanna with gallery forest along rivers and streams. It reports a large mammal and bird community and a strong wet/dry seasonal climate.

**Candidate groups/species named by the Forestry Commission:** elephants, buffalo, roan, kob, hartebeest, waterbuck, primates, lion, leopard and hyena.

**Data status:** candidates only. The presence of a species in the park-wide list does not establish its density or presence in every sub-habitat. Separate open savanna, woodland, river-edge and gallery-forest suitability profiles. Model seasonal resource variation only after source-backed seasonal data are available.

Source: https://fc.gov.gh/mole-national-park/

### 2.3 Bui woodland savanna and Black Volta riverine habitat

**Habitat evidence:** Ghana Forestry Commission describes woodland savanna bisected by the Black Volta, with gallery forest and riverine areas.

**Candidate groups/species named by the Forestry Commission:** hippopotamus, elephants, waterbuck, bushbuck, baboons, patas monkeys and green monkeys; more than 250 bird species are recorded at the park.

**Data status:** candidate reference set only. Keep aquatic/river-edge, gallery forest and woodland niches distinct. Do not copy the Mole roster into Bui merely because some habitat labels overlap.

Source: https://fc.gov.gh/bui-national-park/

### 2.4 Songor coastal wetland

**Habitat evidence:** Ramsar Site Information Service describes a coastal lagoon/wetland complex with mudflats, salt flats, saline marshes, mangroves, waterlogged grassland, riverine woodland and coastal savanna.

**Named waterbird candidates in the Ramsar Information Sheet:**
- Spotted Redshank (*Tringa erythropus*)
- Common Greenshank (*Tringa nebularia*)
- Ringed Plover (*Charadrius hiaticula*)
- Curlew Sandpiper (*Calidris ferruginea*)
- Sanderling (*Calidris alba*)
- Black-winged Stilt (*Himantopus himantopus*)

The information sheet describes migrant arrival from late August, a September–November peak and a marked reduction as dry-season lagoon areas dry. This is a seasonal wetland reference, not a year-round uniform population.

**Data status:** candidate taxa supported by the site information sheet. Verify current taxonomic treatment, assessment status and later count updates before production use. Population values in the site report are survey-context data, not fixed simulation population targets.

Source: https://rsis.ramsar.org/RISapp/files/RISrep/GH566RIS_2405_en.pdf

## 3. International palaeo reference tracks

### 3.1 Late Pleistocene Beringia / mammoth-steppe

The U.S. National Park Service describes a geographically extensive but internally varied Beringian ecosystem during the late Pleistocene. Its documented extinct fauna include woolly mammoth (*Mammuthus primigenius*), woolly rhinoceros (*Coelodonta antiquitatis*) and steppe bison (*Bison priscus*), among other taxa. The source also describes surviving species such as muskox and caribou, with distinct modern/reintroduction history for some populations.

**Implementation constraint:** keep localities and dated remains attached to each record. The source explicitly discusses differences in relative abundance between Siberia, northern Alaska and interior Alaska. Do not flatten Beringia into a single uniform species roster or assume every named species occupied the same place at the same time.

Source: https://www.nps.gov/articles/aps-17-1-4.htm

### 3.2 Pleistocene Queensland — Darling Downs fossil track

Queensland Museum documents Pleistocene fossil records from the Darling Downs, including:
- Diprotodon (*Diprotodon optatum*)
- Giant short-faced kangaroo (*Procoptodon goliah*)
- Giant monitor lizard (*Varanus priscus*)

The museum describes the Darling Downs fossil deposits as Pleistocene in age. It separately discusses tropical northern Queensland fossil discoveries, including South Walker Creek, and notes that the tropical north's Pleistocene megafauna record is distinct and still being studied.

**Implementation constraint:** do not merge Darling Downs and South Walker Creek into one scene roster. Retain formation/locality, stratigraphic and age evidence for each candidate. A broad Pleistocene label alone is not proof of direct co-occurrence.

Source: https://www.museum.qld.gov.au/collections-and-research/explore/megafauna

## 4. Required record fields before a candidate can be promoted

Every approved candidate record must provide:

- Stable ID, accepted scientific name, authority/taxonomy reference and common name.
- Temporal class and conservation/extinction status, with assessment date and source.
- Geographic range, exact reserve/locality or fossil formation, and habitat evidence.
- Geological interval and dated evidence for fossil-only records.
- Evidence type: modern observation, historical record, body fossil, trace fossil or palaeoenvironmental evidence.
- Diet, locomotion and social behaviour evidence notes, with confidence per field.
- Explicit uncertainty notes for colour, soft tissue, vocalisation, group structure and behaviour.
- Source URLs and access/assessment dates.
- Co-occurrence review against locality, age and ecological context.

The schema validator checks field completeness and allowed values; it does not independently verify scientific truth. A human source review remains mandatory before any candidate is approved.

## 5. Prototype selection recommendation

Do not attempt to ship every international biome or extinct ecosystem in the first playable prototype. First validate the ecology model with a very small, well-sourced Ghana reference set and a separate palaeo exhibit/educational test set. The global catalogue is a long-term content library; it must not force the core Ridgeview slice to carry unrelated ecosystems or new story canon.

## 6. Source register

- Ghana Forestry Commission — Kakum National Park: https://fc.gov.gh/kakum-national-park-assin/
- Ghana Forestry Commission — Mole National Park: https://fc.gov.gh/mole-national-park/
- Ghana Forestry Commission — Bui National Park: https://fc.gov.gh/bui-national-park/
- Ramsar Sites Information Service — Songor Ramsar Site: https://rsis.ramsar.org/RISapp/files/RISrep/GH566RIS_2405_en.pdf
- U.S. National Park Service — Pleistocene Megafauna in Beringia: https://www.nps.gov/articles/aps-17-1-4.htm
- Queensland Museum — Megafauna: https://www.museum.qld.gov.au/collections-and-research/explore/megafauna
