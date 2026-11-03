# GdUnit4 Compatibility Probe — Isolated Test Branch

## Status

- **[COMPLETED]** Created branch `test/gdunit4-compatibility-001`.
- **[CONFIRMED]** Godot 4.7.2 imported the pinned GdUnit4 v7.0.0 addon successfully.
- **[CONFIRMED]** GdUnit4 CLI launched on Godot 4.7.2.
- **[NOT YET CONFIRMED]** The first CI run exited successfully but displayed the CLI usage screen rather than executing test cases. The workflow omitted the required `-a test` argument. This was a false-positive invocation, not proof that tests ran.
- **[IN PROGRESS]** Workflow corrected to invoke the CLI directly with `-a test`, avoiding the wrapper's invalid `--remote-debug tcp://127.0.0.1:0` argument.
- **[NOT INTEGRATED]** The addon remains isolated from the main development branch.

## Purpose

Evaluate whether GdUnit4 adds useful test discovery and assertion facilities without disproportionate maintenance cost. Keep the existing NLI smoke suite as an independent regression check.

## Christian accuracy and canon governance

- Scripture, not invented mechanics or an AI model, is the authority for claims presented as biblical teaching.
- Preserve literary, historical and immediate textual context; do not turn isolated verses into universal promises.
- Distinguish direct quotation, paraphrase, interpretation, denominational tradition and fictional lore.
- Attribute quotations and use verified translations; never fabricate verses, citations or statements by Jesus or biblical authors.
- Prayer is not a transaction; faith is not purchasable; salvation, holiness and divine favour are not XP, currencies or reward meters.
- Do not claim that success, suffering, healing or loss proves God's approval or rejection.
- No fictional character, including Asher or members of the Covenant, replaces Jesus Christ or becomes a source of salvation.
- Evangelism must not be coercive or manipulative; NPCs retain agency.
- Clearly label supernatural systems and institutions that are fictional rather than explicit biblical teaching.
- Where Christians disagree, record interpretive ranges and the project's position transparently; do not falsely present a contested view as universal consensus.
- Human review is required before Scripture quotations, doctrinal dialogue or major theological claims are canon-locked. AI may assist research and consistency checks but cannot declare doctrine authoritative.

These are project safeguards, not a substitute for biblical scholarship or church accountability. Doctrine-specific content must be checked against Scripture in context and reviewed before canon lock.
