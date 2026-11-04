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


## Review decision — 2026-11-04

**DECISION: RETAIN THE PROBE AS AN ISOLATED TEST BRANCH; DO NOT INTEGRATE THE ADDON INTO THE ACTIVE PROTOTYPE YET.**

### Evidence
- The corrected CI invocation executed the GdUnit4 CLI test suite rather than merely displaying its usage screen.
- The pinned GdUnit4 v7.0.0 parser suite completed **3/3 tests, 0 errors, 0 failures** in workflow run [41674587976](https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/41674587976), attempt 2.
- The same workflow independently ran the existing NLI regression harness; all 49 assertions passed.
- The addon is checked out at a fixed commit and copied into the CI workspace only. It is not committed to the active game branch or shipped with the game.

### Rationale
The probe establishes Godot 4.7.2 compatibility and a working test-discovery path, but its three tests cover only basic parser cases. The existing SceneTree harness currently exercises a broader set of NLI behaviours. Integrating a framework now would add maintenance and dependency surface without enough demonstrated coverage benefit.

### Reconsider adoption when
- The project has a larger set of reusable unit/integration tests that benefit from GdUnit4 fixtures, parameterization or richer reporting.
- The team can pin and review the addon version/license and keep CI runtime acceptable.
- A migration plan preserves the existing 49-assertion regression suite during and after adoption.

Until those conditions are met, keep the probe branch as compatibility evidence and keep the active branch dependency-free.
