# BTV Session Checkpoint — Mission Registry Validator Phase 1 and AI Agent Alternatives

**Date:** 6 November 2026  
**Observed execution window:** Approximately 08:36–08:43 UTC. Exact assistant-session start time was not separately captured.  
**Branch:** btv/test-first-contracts-001  
**Last verified code/documentation checkpoint:** c91094d99b5462d8b69f249ba579e8316dc09137  
**Last verified CI:** 42189615410 — SUCCESS on that exact commit.  
**Latest README-only commit after that CI:** 0502b8d78d66e56eb4dbac2146407b7c9e9b95e7. Its own CI result must be checked before calling that newer commit verified.

## 1. Mission data validator — Phase 1 completed

Added:
- scripts/mission/mission_data_validator.gd
- tests/mission_data_validator_test.gd
- CI step in .github/workflows/godot-validation.yml

The validator is intentionally a neutral typed-registry utility, not a final mission Resource schema. It checks:
- record dictionaries and non-empty namespace/ID values;
- duplicate IDs within typed namespaces;
- reference owner resolution;
- reference target resolution;
- ambiguous owner/target references;
- whitespace trimming with case-sensitive IDs;
- stable diagnostic codes and source-path provenance.

Test-first evidence:
- Placeholder implementation failed 11 assertions on CI run 42189010979.
- First implementation attempt failed because the GDScript identifier namespace was reserved/invalid in the engine version; the actual parse issue was resolved by renaming identifiers.
- Additional provenance test initially failed because reference diagnostics did not retain the owning file path.
- The fix added owner-path propagation to reference diagnostics.

**Green evidence:** CI run 42189489572 passed on commit 13a1064de42857efc7d507f9799c9d83e5382944.  
**Further green evidence:** CI run 42189615410 passed on commit c91094d99b5462d8b69f249ba579e8316dc09137. It passed:
- Godot 4.7.2 version check;
- headless project import/parsing;
- NLI smoke tests;
- NLI handoff/source-registry contract tests;
- neutral mission validator tests;
- core interaction acceptance tests;
- 10-frame main-scene launch.

Run: https://github.com/KINGACEX/beyond-the-veil-last-watch-/actions/runs/42189615410

The validator's namespace and ID normalization policy is an implementation choice for this neutral registry fixture only. It does not finalize global BTV Resource identity conventions.

## 2. Mission validation contract updated

Updated:
docs/implementation/MISSION_DATA_VALIDATION_CONTRACT_001.md

It now records Phase 1 as completed and explicitly leaves these unimplemented:
- mission/objective graph validation;
- dialogue graph validation;
- evidence/claim semantic validation;
- final Resource schema;
- mission-state service;
- Ridgeview mission content.

No story facts, Ridgeview dialogue, or canon decisions were changed.

## 3. AI agent alternatives research

Created:
docs/research/BTV_AI_CODING_AGENT_ALTERNATIVES_2026-11-06.md

Assumption: the user's word "actors" meant AI coding agents/tools for BTV engineering. If it meant in-game NPC/companion actors, this is a different workstream and the comparison should be redone for runtime actor architecture.

Shortlist findings:
- **OpenCode:** best candidate for a read-only phone-first feasibility test because its product currently lists mobile, desktop and terminal clients plus free-model options. External provider/model use may cost money.
- **Kilo Code:** strong desktop alternative; individual platform is free and Auto Free/local routes are available. Cloud compute and paid inference are separate and should remain disabled.
- **Cline:** free interface/open source, but model inference is separately billed except for limited rotating free offers.
- **Goose:** open-source general agent with desktop/CLI/API and MCP extensions; no clear phone-first advantage.
- **GitHub Copilot Free:** limited free completions and agent/chat usage; possible fallback, not a replacement for the existing GitHub connector.
- **Mistral Vibe:** supports local and OpenAI-compatible provider routes; pricing depends on the selected model/provider.
- **vidIQ:** creator/YouTube research and analytics tool with an MCP integration. Its free plan currently lists 150 AI credits/month; useful for BTV's creator/YouTube workstream, not as a coding agent, Godot runtime or NPC/companion actor.

Official reference links are included in the research document. No tool was installed, no account connected, no repo permissions changed and no paid usage enabled.

**Proposed minimal approach:** keep ChatGPT + GitHub connector as primary; evaluate OpenCode read-only first if mobile repo access can be demonstrated without cost; consider Kilo Auto Free only if desktop access is available. Do not add all alternatives.

## 4. NLI state

No NLI runtime code changed in this session. Previously verified:
- canonical request IDs at service boundary;
- distinct synchronous knowledge-query and pending companion-action semantics;
- cancellation limited to pending requests;
- no claim of actor acceptance or execution.

Still unimplemented:
- companion actor adapter;
- actor-owned accepted/rejected/executing/executed transitions;
- callback correlation, timeout, expiry and stale callback handling;
- persistent lifecycle across pause/quit/reload;
- cryptographic source hash verification and source versioning/withdrawal.

Do not implement an actor adapter until the existing companion stub/interface and current runtime ownership are inspected. The mission progression bible specifies a slice-scoped CompanionBase interface and signals; the implementation must be reconciled against that source rather than inventing a new API.

## 5. Current repository state and boundaries

- Godot remains the active engine.
- Unity evaluation branch remains on hold.
- No merge to main.
- No Android export or physical-device QA.
- No playable vertical slice claim.
- No paid service, deployment, public release or permission change.
- AI coding-agent research is separate from the in-game companion actor runtime.
- Current verified CI proves headless checks only, not Android readiness.

## 6. Exact resume point

The latest README-only commit is 0502b8d78d66e56eb4dbac2146407b7c9e9b95e7. First check its CI run. The last verified code checkpoint remains c91094d99b5462d8b69f249ba579e8316dc09137.

Next steps:
1. Verify the README-only commit's CI.
2. Add the next neutral mission-validation test layer: graph reachability, missing objective references, dependency cycles and terminal-state checks. Keep the fixture schema neutral.
3. Continue NLI actor lifecycle contract design against the existing companion stub interface and companion-related source docs. Do not implement an adapter until ownership and callback semantics are established.
4. If the user confirms "actors" meant game actors, switch from coding-agent tool research to a bounded NPC/companion runtime comparison. Otherwise, OpenCode remains only a proposed read-only mobile feasibility test.

Do not install tools, connect accounts, grant new permissions, purchase credits, merge, alter canon or create Unity branch without the applicable approval.
