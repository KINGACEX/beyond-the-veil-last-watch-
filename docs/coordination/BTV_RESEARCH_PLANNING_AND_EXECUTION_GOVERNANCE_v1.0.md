# BTV Research, Planning and Execution Governance Standard v1.0

**Status:** STANDING PROJECT STANDARD  
**Applies to:** Every substantial BTV plan, feature, system, visual direction, technical change, production phase, external opportunity or release decision  
**Owner:** Project creator / product authority  
**Execution principle:** Research before commitment; plan before implementation; measure before claiming success.

## 1. Standing rule

A BTV plan is not ready to be implemented merely because an idea sounds feasible or a design document exists.

Before acting on a substantial plan, the team must:
1. Understand the actual problem, intended player outcome and project constraints.
2. Research the full relevant solution space and all reasonably accessible source categories.
3. Perform deep dives on high-risk, high-cost, foundational or uncertain areas.
4. Compare alternatives and explain why the selected approach is best for BTV.
5. Convert findings into an actionable, owned, sequenced plan.
6. Establish budget, tools, dependencies, risks, acceptance criteria, checkpoints and rollback/recovery options.
7. Obtain approval for decisions reserved to the project creator.
8. Execute in small increments, verify each increment and update the evidence.

This applies to the controls phase and the later visual, feel, graphics, physics, animation, abilities, level design, audio, performance and publishing phases. It also applies to documentation, research, partnerships, grants and production infrastructure when the decision is consequential.

## 2. Research depth levels

Classify every task before research begins.

### Level 1 — Quick verification
For small, reversible, low-risk work:
- verify current official documentation or source of truth;
- check compatibility with the current project;
- identify obvious alternatives and dependencies;
- record a concise result and test.

### Level 2 — Comparative research
For normal features and medium-impact decisions:
- inspect official documentation and implementation examples;
- compare at least three plausible approaches when three genuinely exist;
- check current community experience, known issues and platform limitations;
- compare cost, performance, maintainability, accessibility, licensing and integration;
- produce a decision record and testable implementation plan.

### Level 3 — Deep dive
Mandatory for foundational architecture, controls, rendering, physics, camera, player abilities, progression, monetisation, data/privacy, online systems, external services, asset pipelines, platform/export decisions, major narrative/canon decisions, partnerships, funding or any high-cost/irreversible choice.

A deep dive must include:
- primary-source research;
- independent secondary corroboration;
- implementation and compatibility investigation;
- real-world case studies or production lessons where available;
- failure modes, limitations, edge cases and unresolved uncertainty;
- at least two viable alternatives where possible, including the option to defer or build nothing;
- cost/effort estimates and resource constraints;
- a risk register and test strategy;
- explicit recommendation with evidence and confidence level.

Do not inflate research depth for trivial tasks. Do not under-research a foundational decision to save time.

## 3. Research discovery map — check all relevant places

For each plan, identify applicable categories below. Mark each **searched**, **not applicable**, **inaccessible**, or **not yet searched**. "All possible places" means a systematic sweep of all relevant and reasonably accessible source classes—not a false claim that every page, person or repository on the internet has been checked.

### A. Project-internal sources — always first
- Master Context Package and handoff documents.
- Canon, story, character, world, mission, Covenant, Ember and faith/church source-of-truth documents.
- Current technical specifications, architecture decisions, issue/PR history, checkpoints and known-defect registers.
- Current source code, scene/resource structure, tests, CI logs, import settings and project configuration.
- Existing assets, provenance, licences, naming conventions and performance observations.
- Previous research, rejected approaches, user-approved decisions and unresolved questions.

Resolve contradictions before implementation. Canon and explicit creator approvals outrank informal notes or third-party inspiration.

### B. Primary technical sources
- Official engine manuals, class/API references, release notes, migration guides and example projects.
- Engine source code, official demos, issue tracker, proposals and release discussions.
- Official platform documentation: Android, Google Play, device compatibility, input, graphics APIs, lifecycle, accessibility, privacy and distribution.
- Official SDK/tool documentation for version control, CI, build/export, profiling, art tools and middleware.
- Hardware/GPU vendor documentation where renderer or device behaviour matters.
- Standards and specifications relevant to formats, accessibility, input, security or performance.

Prefer version-matched documentation. Verify that a guide applies to Godot 4.7.2 and the chosen Android target rather than assuming a tutorial is current.

### C. Independent research and production evidence
- Peer-reviewed research and technical papers where useful.
- Reputable engineering postmortems, conference talks, developer blogs and production breakdowns.
- Open-source projects with inspectable code, tests, licences and active maintenance.
- Documented game-development case studies and measured benchmarks.
- Independent technical reviews and reproducible community reports.

Distinguish measured evidence from opinion, marketing claims and anecdote.

### D. Developer and player communities
Where relevant, search:
- Godot community forums, Q&A, issue discussions and official community spaces.
- Android developer and device-specific communities.
- Specialist graphics, physics, animation, audio, accessibility and UI communities.
- Game developer communities, postmortems and relevant player feedback.
- Reddit and other discussion forums for recurring real-world problems and usability reports.

Use community sources to discover failure modes and user experience, not as sole authority for technical facts. Cross-check important claims against primary sources or reproducible tests.

### E. Tools, services and ecosystem
- Free/open-source tools and their maintenance status.
- Paid services only as comparisons; default to free-first and no paid action without approval.
- Plugin/add-on compatibility, licence, dependency chain, update cadence, security posture and export implications.
- Alternatives that reduce device, credit, account or vendor lock-in.
- Whether an existing tool or workflow already solves the problem.

### F. Art, content and asset ecosystem
- Original art direction and production feasibility.
- Asset stores, open asset libraries, creator portfolios and procedural workflows where relevant.
- Exact licence, attribution, redistribution, modification and commercial-use terms for every candidate asset.
- Rigging, animation, texture, shader, material and import pipeline constraints.
- Cultural, theological and narrative suitability.
- Asset provenance and a record of source/author/licence.

Never use a reference as permission to copy protected characters, environments, logos, UI, music or distinctive expression. A visual reference may inform high-level craft only.

### G. External opportunities and support
For funding, grants, mentorship, challenges, publishers, events, showcases, studio networks and partnerships:
- official programme pages and current application calls;
- eligibility, Ghana/Africa access, age requirements, deadlines, required materials and ownership terms;
- organiser history, credibility, fees, exclusivity, IP clauses and reporting obligations;
- independent participant experiences and reputable industry coverage;
- contact routes and evidence that the opportunity is active.

Do not submit applications, share personal data, sign terms, accept funding or commit IP without explicit creator approval.

### H. Security, privacy, legal and safeguarding
When applicable:
- official privacy/security guidance and platform policy;
- data collection, retention, permissions and account access;
- licence and intellectual-property implications;
- age-appropriate design and user safety;
- moderation, abuse and threat models;
- credentials, secrets, build signing and release supply chain.

Do not expose secrets in source, prompts, logs or public issues. Do not broaden permissions for convenience.

## 4. Source quality and evidence ledger

Every substantial research task must maintain a source ledger with:
- source title and direct URL;
- publisher/author and source type;
- publication/update date and date accessed;
- relevant version/platform;
- key finding, limitation and exact decision it informs;
- evidence grade and confidence;
- conflicts with other sources.

Use this evidence hierarchy:
1. **Primary/authoritative:** official docs, source code, standards, direct measurements, signed licence terms.
2. **Strong independent:** peer-reviewed studies, reproducible benchmarks, reputable production postmortems.
3. **Useful corroboration:** maintained open-source projects, experienced practitioners, well-documented technical discussions.
4. **Exploratory only:** unverified posts, promotional material, anonymous claims, AI-generated summaries.

AI-generated summaries are discovery aids, not evidence. Open the source and verify the relevant claim. For fast-changing information, check current dates and availability. Cite every external factual claim in research reports.

## 5. Required deliverables before execution

For every Level 2 or Level 3 plan, produce the following project artefacts as appropriate:

1. **Problem and outcome brief:** player/user need, success definition, scope and non-goals.
2. **Current-state audit:** what exists, what works, known defects, technical baseline and constraints.
3. **Research report:** source ledger, findings, alternatives, deep dives, evidence quality and unknowns.
4. **Decision record:** chosen option, rejected alternatives, rationale, confidence, trade-offs and approval status.
5. **Work breakdown structure:** tasks, dependencies, sequencing, owners/agents and deliverables.
6. **Resource plan:** time/effort, tools, hardware, accounts, skills, costs and free alternatives.
7. **Risk register:** probability, impact, mitigation, trigger and contingency.
8. **Verification plan:** automated tests, manual/device tests, performance targets and acceptance criteria.
9. **Checkpoint plan:** commit boundaries, evidence snapshots, recovery points and rollback path.
10. **Change-control plan:** what can be done autonomously and what requires explicit approval.

A plan must clearly label **CONFIRMED**, **PROPOSED**, **UNKNOWN**, **BLOCKED** and **COMPLETED**. Estimates are not promises. An untested proposal is not a completed feature.

## 6. Execution and project management

- Inspect the current branch, working tree, source and project state before editing.
- Keep work isolated on a named feature branch. Avoid mixing unrelated features.
- Break work into small, reviewable tasks with one clear purpose.
- Identify prerequisites and resolve foundational blockers first.
- Use test-first or acceptance-test-first development where practical.
- Keep the source of truth updated when a decision changes.
- Record decisions, defects, research findings and rejected options.
- Use checkpoints before and after risky changes.
- Run the full relevant validation pipeline after meaningful code changes.
- Inspect CI logs, not just green badges. Verify the exact tested commit.
- Perform a final diff, generated-file, dependency and secret scan.
- Do not call a feature complete until its acceptance criteria pass.
- Do not start dependent work while a critical prerequisite is failed or unverified.
- If access, hardware, credentials or a required tool is missing, mark the work blocked and choose a safe alternative; never invent access or test results.

## 7. Resource and autonomy controls

Autonomous work may include research, comparison, documentation, isolated code changes, tests, local/CI validation and reversible project organisation within the approved scope.

Explicit approval is required before:
- paid services, purchases, subscriptions or credit consumption;
- public announcements, publishing, releases or distribution;
- merges, deletion, destructive migration or irreversible changes;
- credentials, secrets, permissions, account access or security-sensitive changes;
- signing, legal commitments, contracts, applications or IP transfer;
- canon changes, major story decisions or new supernatural rules;
- external contact or sharing personal/project-sensitive information;
- expanding project scope in a way that changes the agreed product.

Use free-first alternatives and state their limitations. Preserve existing work and make backups/checkpoints before migrations.

## 8. BTV-specific research gates

### Controls and Android input
Research Godot input/event propagation, multitouch ownership, Android lifecycle, safe areas, screen sizes, thumb ergonomics, accessibility and device-specific behaviour. Use headless regression tests plus real-device validation. Desktop simulation alone cannot establish Android readiness.

### Visuals and graphics
Research Godot 4.7.2 renderer capabilities, Android GPU/device coverage, shader/material costs, lighting, shadows, post-processing, texture formats, LOD, occlusion, asset import, memory, thermal behaviour and frame-time budgets. Compare target devices before choosing a visual target. Build a representative benchmark scene before committing to expensive art production.

### Physics and game feel
Research CharacterBody3D and physics behaviour, fixed timestep, collision shapes, slopes, stairs/steps, acceleration, braking, friction, camera response, animation blending and touch latency. Tune with a neutral test course and reproducible measurements before decorating levels.

### Powers, abilities and companion systems
Start from the approved canon and character/Ember bibles. Deep-dive player comprehension, accessibility, input mapping, animation readability, AI/state logic, balancing, edge cases and testability. Do not invent powers or supernatural rules to fill a design gap. Mark unresolved mechanics as UNKNOWN and request creator approval when canon changes are implicated.

### World and level layout
Research navigation, sightlines, pacing, environmental storytelling, encounter readability, streaming/performance, NPC density, interaction affordances and mobile camera framing. Greybox first; validate the route and player comprehension before final art.

### Audio and accessibility
Research device speakers/headphones, dynamic range, spatial audio cost, subtitles/captions, visual alternatives to audio cues, motion sensitivity, text scaling, contrast and touch-target usability.

## 9. Decision gates

A plan may proceed only when:
- the problem and intended outcome are clear;
- critical internal sources and canon have been checked;
- the applicable research map has been completed or explicit access gaps recorded;
- deep dives are complete for foundational/high-risk decisions;
- alternatives and trade-offs are documented;
- cost, resources, dependencies and risks are understood;
- acceptance criteria and verification methods exist;
- required creator approvals are obtained.

If any condition fails, the plan remains **PROPOSED** or **BLOCKED**. Research may continue, but implementation must not silently proceed past the gate.

## 10. Review and continuous learning

After each milestone:
- compare expected and actual outcomes;
- review defects, player experience, performance, cost and schedule;
- record new information and revise assumptions;
- update the source ledger and decision record;
- capture lessons learned;
- adjust the next phase and its research depth.

The standard itself should be reviewed when the project toolchain, platform, scope or governance changes. It is a working process, not paperwork for its own sake: research must reduce uncertainty and improve the resulting game.
