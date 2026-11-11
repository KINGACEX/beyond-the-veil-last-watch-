# BTV Dynamic Ancient Languages and Textual Research System

**Date:** 2026-11-05  
**Branch:** `btv/bootstrap-prototype-001`  
**Status:** PROPOSED — approved design direction; not implemented  
**Owner:** BTV design and technical coordination  
**Related design:** `docs/implementation/CROSS_PLATFORM_INPUT_AND_FIRST_EXPERIENCE_2026-11-05.md`

## 1. Executive decision

BTV should build a data-driven, extensible **Dynamic Ancient Languages and Textual Research System**. It must support more than one language without hard-coding language-specific logic into the player controller, journal, puzzle scripts, or UI.

Initial language modules:

1. **Biblical Hebrew** — initial focus for relevant Old Testament texts, inscriptions, names, and historical investigation.
2. **Koine Greek** — New Testament language research and relevant historical/textual material.
3. **Biblical Aramaic** — relevant biblical passages, inscriptions, and historical material.

These are distinct languages and textual traditions. Do not treat them as interchangeable or imply that every biblical passage was originally written in one of them. Additional historically justified languages may be added later through content modules.

The player-selected approach is **C**:
- Asher learns languages within the story.
- The player can also learn real vocabulary, script, pronunciation, grammar, and context.
- Educational material remains optional and does not turn the game into a compulsory language course.

## 2. Core design principles

- **Research, not magic:** knowledge comes from study, evidence, instruction, and appropriate tools.
- **Truth is not paywalled behind language skill:** players can access reliable translations, contextual explanations, and alternate routes when they cannot read an original text.
- **Evidence before interpretation:** distinguish the source text, literal/working translation, scholarly interpretation, and fictional narrative inference.
- **No invented biblical authority:** never present invented wording, unsupported etymology, fabricated quotations, or speculative interpretations as Scripture or established scholarship.
- **Dynamic and extensible:** add a language by supplying validated content data and presentation metadata, not by rewriting core gameplay systems.
- **Respectful Christian treatment:** Scripture is not a collectible power-up, spell, currency, or mechanism for purchasing spiritual favour.
- **Accessible by design:** language puzzles must support readable presentation, adjustable text, optional transliteration/audio where verified, and alternate ways to progress.
- **Small-team scope:** build a narrow, high-quality Hebrew learning slice before populating all three languages at scale.

## 3. Language module scope

### 3.1 Biblical Hebrew

Initial language module and first educational prototype. Include verified script presentation, transliteration, vocabulary, contextual meaning, morphology/grammar notes where reviewed, and reliable references.

### 3.2 Koine Greek

Separate module with its own script, transliteration conventions, vocabulary, grammar, and references. Do not reuse Hebrew-specific assumptions or data.

### 3.3 Biblical Aramaic

Separate module. Clearly identify which material is Biblical Aramaic and avoid treating all historical Aramaic varieties as identical.

### 3.4 Future languages

The system may later support other languages where the story and historical context justify them. Every proposed addition must have:
- a clear narrative purpose;
- credible reference material;
- a qualified review path;
- sufficient content to justify the UI and maintenance cost.

Do not add languages merely to make the feature list larger.

## 4. How players acquire the ability to use a language

Language understanding is supported by resources and practice, not by an arbitrary XP meter.

Possible in-world resources:
- manuscripts, inscriptions, letters, and historical records;
- introductory books and reference manuals;
- dictionaries and lexicons;
- grammar guides and research notes;
- qualified teachers, translators, archivists, or scholars;
- audio lessons and pronunciation references;
- contextual evidence from locations, objects, and conversations.

Resources should be earned or discovered through exploration, missions, conversations, and research. Do not require real-money purchases, premium currency, or repetitive grinding to access essential learning material.

A resource provides a capability or reference; it does not instantly grant fluency. For example, finding a lexicon allows Asher to look up words but does not mean he can independently read a complex manuscript.

### 4.1 Proficiency states

Use descriptive states rather than numerical language XP:

1. **Unfamiliar** — Asher cannot independently recognize the language. He may still use a translation, ask for assistance, or consult a guide.
2. **Recognition** — he recognizes the script, recurring words, and familiar forms.
3. **Guided reading** — he can interpret selected material with a dictionary, notes, or mentor guidance.
4. **Independent interpretation** — he can work through suitable passages with less assistance. Complex, damaged, ambiguous, or specialized texts may still require research.

These states represent game progression, not a real-world fluency certification. Avoid claims that a player or Asher has mastered an entire language after a small number of lessons.

### 4.2 Two parallel learning tracks

Keep the character's fictional knowledge separate from the player's actual learning record.

- **Asher's story knowledge:** controls narrative dialogue, available investigation actions, and which research assistance he can plausibly use.
- **Player learning record:** stores optional vocabulary discoveries, script lessons, pronunciation practice, and explanations for later review.

A player may understand a word before Asher does, or Asher may have story knowledge the player has not personally studied. Do not silently conflate the two.

## 5. Research loop

Use this repeatable loop:

1. **Encounter** — discover a text, inscription, name, symbol, or historical reference.
2. **Identify** — determine the likely language and source type; do not guess with false certainty.
3. **Acquire resources** — find or consult appropriate books, notes, tools, or a qualified character.
4. **Investigate** — inspect the original, transliteration, vocabulary, grammar, and context.
5. **Compare** — consult available translations or interpretations and note meaningful differences.
6. **Conclude** — record what is supported, what is inferred, and what remains unresolved.
7. **Apply** — use the finding in dialogue, exploration, a puzzle, or a mission decision.

Not every discovery needs all seven steps. Small discoveries can be brief; major investigations can use the full loop.

## 6. Journal and evidence model

The investigation journal should hold language discoveries and general case evidence in one searchable system.

Each entry should support:
- unique entry ID;
- language module ID;
- source type and source identifier;
- original script text, if verified and appropriate;
- transliteration, with its convention identified;
- working translation and translation attribution;
- vocabulary entries and grammatical notes;
- historical and literary context;
- source references and review status;
- Asher knowledge state;
- player learning state;
- confidence or uncertainty notes;
- related clues, locations, characters, and missions;
- accessibility presentation options.

### 6.1 Evidence labels

Use explicit labels:

- **SOURCE TEXT** — the original text as represented by a documented source.
- **TRANSLATION** — a named translation or clearly labelled working translation.
- **SUPPORTED CONTEXT** — contextual information supported by the cited reference.
- **INTERPRETATION** — a reasoned reading, not a certainty.
- **FICTIONAL CLUE** — invented BTV narrative content, clearly distinguished from real Scripture or historical evidence.
- **UNRESOLVED** — insufficient evidence to conclude.

Do not use the project's ordinary task statuses (CONFIRMED/PROPOSED/UNKNOWN/BLOCKED/COMPLETED) as a substitute for scholarly source attribution inside the game. They serve different purposes.

## 7. Translation, Scripture, and historical accuracy safeguards

This is a critical content gate.

- Never fabricate a Bible quotation or attribute fictional wording to a biblical author.
- Never invent a Hebrew, Greek, or Aramaic translation and present it as established fact.
- Never claim that a single word has one universal meaning independent of grammar and context.
- Distinguish spelling, transliteration, pronunciation, lexical gloss, grammatical function, and contextual translation.
- Where credible sources disagree, show that disagreement fairly and explain its scope; do not manufacture certainty.
- Preserve the distinction between the biblical text, historical claims, scholarly interpretation, and BTV's fictional lore.
- Any educational entry presented as factual requires source attribution and review before release.
- Any Scripture quotations must follow the project's chosen Bible translation permissions and quotation limits. Prefer references and short excerpts where licensing is uncertain.
- Do not use language puzzles to imply that ordinary Bible translations conceal God's truth or that salvation depends on learning ancient languages.
- Never turn prayer, faith, holiness, divine favour, or salvation into a language-system reward.

## 8. Puzzle and progression safeguards

Language knowledge may deepen investigation, but it must not create unfair or irreversible progression locks.

- Some puzzles may **prefer** a perspective or a language skill.
- A small number of story-authentic interactions may **require** a specific tool or level of understanding, but must provide a fair route to acquire it.
- Essential story progress must have a translation, mentor, contextual clue, alternate route, or other accessible solution.
- Optional discoveries may reward deeper study without blocking the main story.
- Missing one inscription or vocabulary entry must not permanently break a mission.
- Avoid brute-force alphabet substitution and arbitrary word guessing as the default puzzle design.
- Do not let first-person camera access expose information through walls or bypass intended spatial constraints.
- Camera perspective and language knowledge are separate systems: changing perspective must not magically grant linguistic understanding.

## 9. Technical architecture — data-driven modules

Implement the system as reusable services and data resources, not a large collection of one-off puzzle scripts.

Proposed logical components (names are provisional):
- **LanguageRegistry** — registers available language modules and their metadata.
- **LanguageModule** — describes a language's script, direction, transliteration convention, font requirements, and content references.
- **LexiconEntry** — stores reviewed vocabulary and grammatical/contextual information.
- **TextArtifact** — represents an inscription, manuscript, document, or excerpt.
- **TranslationRecord** — stores a translation, attribution, version, and review metadata.
- **ResearchResource** — represents books, dictionaries, notes, lessons, and mentor assistance.
- **LanguageProgress** — stores Asher's narrative capability separately from player learning progress.
- **ResearchJournal** — records discoveries, evidence labels, links, and unresolved questions.
- **PuzzleEvidenceLink** — connects a verified clue to a puzzle or mission without embedding linguistic rules inside the puzzle.

Use stable IDs and versioned content. A language module should be addable without changing player movement, camera, combat, or general interaction code.

### 9.1 Script and UI support

The UI must support:
- right-to-left Hebrew and Aramaic presentation where appropriate;
- left-to-right Greek and English presentation;
- Unicode text and combining marks;
- correct font coverage and text shaping;
- separate original-script and transliteration display;
- adjustable text size and contrast;
- keyboard, touch, and controller navigation;
- graceful fallback if a font or optional audio asset is unavailable.

Do not assume that ordinary left-to-right labels, punctuation, or mixed-language text will render correctly. Verify the actual Godot version, font stack, shaping behaviour, and target Android devices before committing to a rendering implementation.

### 9.2 Content pipeline

Each content item must be reviewable before it enters a release build:
1. Author the entry from a traceable reference.
2. Record exact source, edition/version, and relevant location/page/verse.
3. Add translation/transliteration and explain editorial choices.
4. Mark uncertainties and variant readings.
5. Obtain qualified linguistic/biblical review for factual teaching content.
6. Check Scripture and source licensing.
7. Run content validation for missing metadata, broken IDs, and unsupported claims.
8. Approve the content version for inclusion.

Do not generate unreviewed language entries dynamically with an AI model during gameplay. AI may assist internal drafting or research, but released factual content must be curated and reviewed. The game should work offline with its approved content pack.

## 10. Privacy, accessibility, and player choice

- Store learning progress locally unless a future, explicitly approved account feature requires otherwise.
- Do not collect sensitive religious beliefs, prayer choices, confession content, or inferred faith data for analytics.
- Do not grade the player's faith, intelligence, or spiritual worth.
- Let players hide transliteration, show it, or reveal it progressively.
- Provide optional pronunciation audio only when sourced and reviewed.
- Provide subtitles and text alternatives for all essential audio instruction.
- Make puzzle text readable on small Android screens and desktop displays.
- Do not make rapid reading, precise tapping, or perfect pronunciation a requirement for essential progression.

## 11. Development sequence

### L0 — Design and source validation
- Confirm the exact first language-learning use case in BTV's story.
- Identify reliable, accessible reference sources and licensing constraints.
- Define the initial Hebrew content list with a reviewer.
- Confirm Godot text direction, font, Unicode, and Android rendering feasibility.
- No gameplay code changes.

### L1 — Data and journal prototype
- Implement language registry and data structures for one small Hebrew sample.
- Show original script, transliteration, reviewed meaning, context, and source.
- Add journal discovery and save/load tests.
- Keep the content sample small and fully reviewed.

### L2 — Learning and resource loop
- Add research resources and the four descriptive proficiency states.
- Keep Asher's state separate from player learning progress.
- Test that acquiring a book or dictionary does not instantly grant fluency.
- Test that optional learning can be skipped without blocking the story.

### L3 — Investigation and puzzle integration
- Connect journal evidence to one optional investigation.
- Add perspective-aware inspection only where it genuinely helps.
- Provide an accessible alternate path for required story progress.
- Test missing clues, incorrect assumptions, and unresolved evidence.

### L4 — Additional language modules
- Add Koine Greek and Biblical Aramaic as separate content modules.
- Verify script rendering, transliteration conventions, and source review independently.
- Add further languages only when story value and review capacity justify them.

### L5 — Content expansion and quality assurance
- Expand the reviewed vocabulary and artifact catalogue.
- Test Android and desktop layouts, saves, font fallbacks, accessibility, offline operation, and content validation.
- Obtain linguistic/biblical review for all educational material before release.

## 12. Acceptance criteria

The system is not complete until tests demonstrate:

1. A new language can be registered through content data without rewriting core gameplay code.
2. Hebrew, Greek, and Aramaic are distinct module IDs with independent metadata.
3. Original script, transliteration, and translation are displayed as separate fields.
4. Right-to-left and left-to-right scripts render correctly, including mixed-language text, punctuation, and combining marks on target devices.
5. Missing fonts or optional audio do not crash the journal.
6. Journal discoveries persist across save/load.
7. Asher's language progression and the player's learning record remain separate.
8. Finding a reference book or lexicon grants access to that tool, not automatic fluency.
9. Every factual learning entry has traceable references and a review status.
10. Fictional BTV clues cannot be mistaken for quotations from Scripture or verified historical documents.
11. Essential story progress remains possible without completing optional language lessons.
12. Missing clues, incomplete vocabulary, or a failed optional puzzle do not create a permanent softlock.
13. The system works offline with approved content.
14. No sensitive religious analytics or spiritual scoring is introduced.

## 13. Explicit non-goals and scope controls

Not part of the first implementation:
- teaching complete Hebrew, Greek, or Aramaic fluency;
- unrestricted AI-generated translations during gameplay;
- machine translation as the authoritative source of biblical interpretation;
- a large academic grammar textbook inside the game;
- language-based spiritual ranking or rewards;
- mandatory language lessons before players can understand the central Gospel message;
- a separate language mini-game for every inscription;
- paid content or premium currency gates for essential research tools.

## 14. Mavis handoff — after baseline verification

**Task:** L0 technical feasibility investigation only.

**Objective:** Determine how the proposed language/journal system can be implemented safely in the current Godot project.

**Current verified context:** BTV is a Godot 4 project with a third-person greybox player and an existing cross-platform input/first-experience specification. This document is a proposal, not implementation authorization for the entire system.

**Allowed scope:**
- Inspect project structure, current journal/inventory/save architecture, Godot version, font assets, and existing UI patterns.
- Create a small disposable or isolated rendering test only if it does not modify production scenes or overwrite existing work.
- Investigate RTL, Unicode, font shaping, and mixed-script support on the available runtime.
- Report candidate data structures and test strategy.

**Restrictions:**
- First report the local branch, HEAD, working tree, Godot version, and current test state.
- Do not overwrite or reset existing work.
- Do not implement the full language system.
- Do not add dependencies, paid services, AI runtime translation, or unreviewed language content.
- Do not alter canon or quote Scripture without an approved source.
- Do not merge to main or deploy.

**Deliverables:**
- Exact environment and repository evidence.
- Feasibility findings for Hebrew/Greek/Aramaic rendering.
- Recommended Godot data/resource architecture.
- Smallest safe L1 implementation plan.
- Risks, unknowns, exact files proposed for future change, and test commands/results.

**Escalation:** Stop and report if the project state is dirty, the target branch differs, a proposed change risks existing work, font/rendering support is uncertain, or any paid or external service is required.

## 15. Status

- **CONFIRMED:** User supports a dynamic system covering Hebrew, Greek, and Aramaic; player and character learning together; and the previously proposed dual-perspective and investigation safeguards.
- **PROPOSED:** The architecture, progression states, resource loop, journal model, content pipeline, and milestones in this document.
- **UNKNOWN:** Availability and licensing of suitable language datasets, exact Godot RTL/shaping behaviour on target Android devices, and qualified review capacity.
- **BLOCKED:** Full implementation until L0 feasibility and source/content review are complete.
- **COMPLETED:** Design specification drafted. No gameplay code or language-learning content has been implemented by this document.
