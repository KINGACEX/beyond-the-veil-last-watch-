# GdUnit4 Compatibility Probe — Isolated Test Branch

## Status

- **[COMPLETED]** Created branch `test/gdunit4-compatibility-001` from `btv/bootstrap-prototype-001`.
- **[PROPOSED / UNDER TEST]** GdUnit4 v7.0.0 is checked out at fixed commit `ec29dc9b044afc3bac852bc3a680b898fbc61085` by a branch-scoped GitHub Actions workflow.
- **[UNKNOWN]** Compatibility with Godot 4.7.2. The upstream compatibility table lists Godot 4.7 and 4.7.1, but does not list 4.7.2. A successful probe would establish compatibility only for the exercised paths, not blanket compatibility.
- **[NOT INTEGRATED]** The addon is not added to the main BTV development branch and no merge is proposed by this probe.

## Purpose

Evaluate whether GdUnit4 adds enough value to BTV's testing workflow to justify its maintenance cost. Keep the existing 49-assertion NLI smoke suite as an independent regression check.

## Scope

The workflow:
1. Checks out the BTV compatibility branch.
2. Checks out the user's public GdUnit4 fork at an immutable commit.
3. Installs only the `addons/gdUnit4` plugin directory into the CI workspace.
4. Imports the Godot project with Godot 4.7.2.
5. Runs a small GdUnit4 test suite against the deterministic NLI parser.
6. Runs the existing NLI smoke suite.

The workflow does not change the active development branch, enable the plugin in the shipped game, export Android builds, publish releases, or alter game canon.

## Why this is the right next technical step

BTV already has a working headless smoke-test path. GdUnit4 should be adopted only if it provides useful assertion/test discovery without introducing incompatibility or disproportionate maintenance. This probe isolates that decision before any integration.

## Christian accuracy and canon governance

The game must distinguish biblical teaching from fictional worldbuilding. The following rules govern future faith-related implementation:

- Scripture, not invented game mechanics or an AI model, is the authority for claims presented as biblical teaching.
- Preserve literary, historical, and immediate textual context; do not turn isolated verses into universal promises.
- Distinguish direct biblical quotation, paraphrase, interpretation, denominational tradition, and fictional lore.
- Attribute quotations and use a verified translation; do not fabricate verses, citations, or statements by Jesus or biblical authors.
- Do not represent prayer as a transaction, faith as a purchasable resource, salvation as an XP path, or divine favour as a reward meter.
- Do not claim that a character's success, suffering, healing, loss, or mission outcome proves God's approval or rejection.
- Do not make the player, Asher, the Covenant, or any fictional character a replacement for Jesus Christ or a source of salvation.
- Evangelism must not be coercive or manipulative; NPCs retain agency and may disagree, ask questions, or decline.
- Keep supernatural rules and fictional institutions clearly labelled as fictional where they are not explicit biblical claims.
- When a theological question is disputed among Christians, record the interpretive range and the chosen project position transparently; do not present one contested view as universally settled.
- Human review is required before new doctrinal dialogue, Scripture quotations, or major theological claims are canon-locked. AI may assist research and consistency checks but cannot declare doctrine authoritative.

These are project governance safeguards, not a substitute for biblical scholarship or church accountability. Future doctrine-specific content must be checked against Scripture in context and reviewed before canon lock.
