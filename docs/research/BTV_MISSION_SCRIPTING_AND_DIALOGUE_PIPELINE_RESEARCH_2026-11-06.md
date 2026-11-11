# BTV MISSION SCRIPTING AND DIALOGUE PIPELINE RESEARCH
**Date:** 6 November 2026  
**Status:** OFFICIAL GODOT DOCUMENTATION + DEVELOPER CASE STUDY DESCRIPTIONS  
**Project:** Beyond the Veil: The Last Watch  
**Scope:** Authored mission data, branching dialogue authoring, narrative/audio pipeline, runtime state ownership and validation.

## 1. Executive findings

The strongest low-cost starting point for BTV is a **data-first, authored-content pipeline** built from Godot Resources and small, explicit runtime services—not a custom dialogue editor or a generative narrative engine.

Godot Resources provide typed, Inspector-editable, serializable data containers. GDC's Obsidian dialogue-tools session identifies three practical authoring needs: visualize dialogue structure, write/edit text efficiently, and integrate narrative with game scripting. Owlchemy Labs' VO pipeline case study shows that custom narrative/audio tooling was built in response to specific scoped production needs and iteration costs—not as a prerequisite for starting dialogue work.

For BTV, the proposed separation is:
1. authored definitions (mission, dialogue, evidence and objective data);
2. authoritative runtime state (what has actually happened);
3. presentation (dialogue UI, subtitles, reports and prompts);
4. validation/editor tooling (checks for missing references, unreachable nodes and invalid source provenance).

This is a proposed architecture direction, not approved or implemented.

## 2. Evidence from Godot Resources

### 2.1 Resources as authored data containers

Official Godot documentation distinguishes Nodes (runtime functionality and scene behavior) from Resources (data containers used by nodes). Scripted Resources can expose typed properties, methods and signals, serialize nested Resources, and be saved as version-control-friendly text files (`.tres`). The Inspector can edit custom Resource properties without a bespoke editor.

Source:
- Godot documentation, Resources: https://docs.godotengine.org/en/4.7/tutorials/scripting/resources.html
- Source mirror: https://github.com/godotengine/godot-docs/blob/master/tutorials/scripting/resources.rst

**BTV implication — PROPOSED:** use custom Resources for authored definitions where typed fields and Inspector editing are useful. Examples to evaluate:
- mission/episode definition;
- objective definition;
- dialogue node/choice definition;
- evidence definition and provenance reference;
- NPC knowledge record;
- response/outcome definition.

Do not create all of these classes immediately. First define the smallest data contracts required by the recovered Ridgeview slice specification.

### 2.2 Resource sharing is a runtime-state hazard

Godot documents that a Resource loaded from disk is reused when it is already in memory; loading the same resource again returns the same instance. Resources referenced by multiple scene instances may also be shared.

**Risk:** mutating a shared authored Resource to record one player's mission progress can leak state across actors, mission instances or scenes.

**BTV implication — PROPOSED:** treat authored Resource definitions as immutable during play. Store per-run progress in a separate runtime state object/service keyed by stable mission/objective/evidence IDs. If mutable copies are needed, duplicate deliberately and test nested-resource behavior. Never store authoritative player progress by casually editing a shared `.tres` definition.

### 2.3 Godot Resource strengths and limitations

Strengths:
- typed exported fields and Inspector editing;
- built-in serialization;
- nested data composition;
- text-based `.tres` files that can be reviewed in Git;
- no mandatory external narrative tool or paid runtime dependency.

Limitations:
- a Resource is a data container, not a complete mission-state machine;
- shared-resource caching requires clear immutability rules;
- large dialogue graphs may become awkward to author directly in Inspector fields;
- references and stable IDs still need validation;
- a custom visual editor adds maintenance cost and should be justified by actual content scale.

## 3. Dialogue authoring case study — Obsidian Entertainment

**GDC 2019:** Carrie Patel and David Szymczyk, “Technical Tools for Authoring Branching Dialogue.”

The official session description states that robust branching-dialogue tools should allow designers to:
- shape and view the structure of dialogue files;
- write and edit text seamlessly;
- integrate dialogue with game scripting.

The session describes Obsidian's internal OEI Tools dialogue editor, used by its writers over eight years.

Source:
- https://www.gdcvault.com/play/1025962/Technical-Tools-for-Authoring-Branching

**Access limitation:** the public session page and abstract were inspected. The full talk/video was not accessed; this report does not claim to reproduce its detailed implementation.

**BTV implication — PROPOSED:** when BTV dialogue content becomes large enough, authoring needs should include both a clear graph/flow view and direct text editing, plus explicit integration with mission and NPC knowledge data. A list of raw strings alone will not expose branch reachability, conditions, or missing references.

## 4. Narrative and voice-over pipeline case study — Owlchemy Labs

**GDC 2023:** Daniel Perry, “Tools Summit: Cosmonious High Case Study of Seret: Building a Custom VO System.”

The official session description says Owlchemy Labs scoped dialogue goals for Cosmonious High, then developed an internal narrative/audio pipeline tool to make iteration more efficient and automate repeated production processes.

Source:
- https://www.gdcvault.com/play/1029376/Tools-Summit-Cosmonious-High-Case

**Access limitation:** only the public session description was reviewed; full talk content was not accessed.

**BTV implication — PROPOSED:** do not build a custom narrative/VO pipeline merely because other studios have one. First measure the actual friction in BTV's authored content. Begin with plain-text/Resource-based data and automated validation. Add a dedicated editor or VO tool only when volume and repeated authoring costs justify it.

## 5. Proposed BTV content/runtime separation

The following is a proposed conceptual boundary, not a final schema:

| Layer | Owns | Must not own |
|---|---|---|
| Authored mission definitions | IDs, objectives, prerequisites, branches, permitted outcomes, references | Current player completion state |
| Authored dialogue definitions | Speaker, text, choices, conditions, next-node IDs, provenance/source links | Mission truth or evidence creation |
| Authored evidence definitions | Stable evidence ID, description, origin, permitted discovery context | Claim that player has collected it |
| Runtime mission-state service | Active stage, completed objectives, selected approach, acquired evidence IDs, validated outcomes | Editing authored definitions |
| NPC knowledge/NLI | Speaker-scoped approved statements, uncertainty and source provenance | Mission completion, evidence creation, world mutation |
| Presentation/UI | Display text, options, report summaries, subtitles and player feedback | Authoritative state transitions |
| Validation tooling | Missing IDs, invalid references, unreachable nodes, impossible conditions, source/provenance errors | Silent content rewriting |

**Important BTV rule:** dialogue is not evidence. A character saying something must not automatically create a discovered evidence record. Evidence acquisition must come from an explicitly authored, validated gameplay event.

## 6. Branching and fail-forward design

BTV's recovered Vertical Slice v1.0 requires five approaches: Speak/Preach, Investigate, Rescue, Defend and Withdraw. The mission should preserve coherent reporting across those approaches without introducing a hidden morality or spiritual score.

**PROPOSED implementation principles:**
- Separate player approach selection from objective completion.
- Distinguish mandatory objectives from optional evidence.
- Make prerequisites explicit and validate them before runtime.
- Ensure optional evidence can enrich a report but cannot silently become a hard progression gate.
- Preserve unresolved facts as unresolved; do not force a definitive branch outcome where canon leaves uncertainty.
- Use stable convergence points where appropriate so branch complexity remains bounded.
- Keep consequences observable and attributable to authored events, not invisible morality scoring.
- A failed or unavailable interaction should not be displayed as a successful objective.

No mission outcome, repairman fate, or reserved information is resolved by this report.

## 7. Validation and loophole matrix

| ID | Failure mode | Required validation |
|---|---|---|
| MS-001 | Duplicate or blank mission/objective/dialogue IDs | Stable-ID uniqueness scan |
| MS-002 | Choice points to missing dialogue node | Reference-integrity scan |
| MS-003 | Dialogue branch cannot be reached | Graph reachability validation |
| MS-004 | Mission has no valid terminal/report state | Mission graph validation |
| MS-005 | Optional evidence accidentally required for progression | Branch-path tests with optional evidence absent |
| MS-006 | Dialogue silently creates evidence | Contract test: only evidence service creates evidence records |
| MS-007 | NPC speaks outside approved knowledge scope | NLI source/profile validation |
| MS-008 | Shared Resource mutation leaks between runs | Two-instance isolation test |
| MS-009 | Conditions refer to missing mission/evidence IDs | Condition-reference validation |
| MS-010 | A choice displays despite unmet prerequisites | Runtime condition test |
| MS-011 | Player-facing text says an unseen action succeeded | Event-to-dialogue consistency review |
| MS-012 | Audio-only clue blocks progress | Subtitle/text equivalent and muted-audio test |
| MS-013 | Localization expansion clips choices or reports | Long-string/pseudolocalization test |
| MS-014 | A branch bypasses required source/canon review | Content provenance gate |

## 8. Minimum viable authoring pipeline — proposed

1. Freeze the first mission's approved data contract from Vertical Slice v1.0 and Ridgeview reconciliation.
2. Define stable IDs and explicit references before writing large amounts of dialogue.
3. Store authored definitions in typed Resources or a simple text format; choose based on Inspector needs and diff/review quality.
4. Keep runtime mission state in a separate authoritative service with explicit transitions.
5. Keep dialogue presentation separate from mission state and evidence acquisition.
6. Add automated checks for ID uniqueness, missing references, reachability, prerequisites and source provenance.
7. Author one small neutral test conversation and mission graph fixture before producing full Ridgeview dialogue.
8. Review whether a visual dialogue editor is actually needed; do not build one before the workflow demonstrates a bottleneck.

## 9. BTV-specific safeguards

- No procedural or LLM-generated runtime dialogue is proposed by this research. The current deterministic NLI remains a bounded knowledge/command system, not an unrestricted narrative author.
- Dialogue must not be treated as evidence or as authoritative mission-state mutation.
- NPCs only speak from their approved knowledge scope and preserve uncertainty.
- Do not turn prayer, Scripture, Communion or faith into a branch currency, reward score or guaranteed response mechanic.
- Do not resolve open canon questions (including reserved Ridgeview facts) by inventing dialogue outcomes.
- No new custom editor, paid plugin, runtime network dependency or voice-over service is authorized.

## 10. Status and source limitations

- **CONFIRMED:** Godot Resources are data containers, can be scripted/typed/serialized, support nested resources and are editable through the Inspector.
- **CONFIRMED:** Godot caches loaded Resources; repeated loads may return the same instance. Authored-data immutability is therefore a relevant BTV safeguard.
- **CONFIRMED:** GDC session descriptions identify dialogue graph visibility, text editing and game-script integration as authoring-tool needs.
- **CONFIRMED:** Owlchemy Labs described creating a custom narrative/audio pipeline in response to scoped production goals and iteration efficiency.
- **PROPOSED:** BTV data/runtime/presentation separation, validation matrix and minimum authoring pipeline.
- **UNKNOWN:** final mission schema, dialogue graph schema, custom editor requirement, VO scope, runtime subtitle system and localization target set.
- **NOT IMPLEMENTED:** no mission scripting, dialogue editor, VO pipeline, mission-state service or new Resources were added by this research.

The GDC pages were reviewed at abstract/session-description level only. The academic branching-quest search result was not used as a design authority because the full paper could not be accessed during this review.
