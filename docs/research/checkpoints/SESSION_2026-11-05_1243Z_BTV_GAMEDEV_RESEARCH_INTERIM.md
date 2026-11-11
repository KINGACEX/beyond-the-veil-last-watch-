# BTV GAME DEVELOPMENT RESEARCH — INTERIM CHECKPOINT
**Session ID:** 2026-11-05_1243Z_BTV_GAMEDEV_RESEARCH  
**Date:** 5 November 2026  
**Work window:** 12:43:09–12:43:35 UTC (26 seconds; exact timestamps from tool/runtime records)  
**Status:** INTERIM — research programme opened; synthesis incomplete  
**Project:** Beyond the Veil: The Last Watch  
**Branch:** `btv/test-first-contracts-001` (branch state must be reverified before any later write)  
**Research thread:** [Consensus thread](https://consensus.app/search/research-brief-for-beyond-the-veil-the-last-watch-/tWJBRgl1RDCoKJqFlG2WEw/)

## 1. User intent and constraints
User requested a full research programme into how game developers build games, including game scenes and the complete production process. Research should combine Consensus and sources other than Scholar, plus current web research. User asked for a Perplexity plugin to provide up-to-date research.
Carry forward BTV constraints:
- Godot 4.x; Android-first with later PC scalability.
- Free/low-cost tools first; no purchases or paid API commitments without approval.
- Preserve existing work and canon. Research findings are not BTV canon until explicitly approved.
- Distinguish evidence from practitioner opinion and from proposed BTV recommendations.
- Do not claim the full research is complete; only the first research phase has started.
- Discuss combat/gameplay at safe, high-level design/readability/QA level; no real-world weapon-use or attack replication detail.

## 2. Workstreams and status

### A. Industry and practitioner research
**Status: IN PROGRESS**
Initial Firecrawl search surfaced:
- GDC Vault as a large archive of developer talks and training sessions.
- GDC level-design workshop: https://gdcvault.com/play/1025176/Level-Design-Workshop-An-Architectural
- GDC talk on level-design histories/futures: https://gdcvault.com/play/1022109/Level-Design-in-a-Day
- GDC 2025 developer talk on layered game design: https://www.youtube.com/watch?v=UTE_bVUeHCQ
- GDC 2026 attendee report describing a small-team RPG production/vertical-slice case study. This is an attendee account, not an official transcript; treat as a lead, not authoritative proof: https://www.invisiblefriends.net/gdc-2026-a-personal-account/

### B. Current industry trends
**Status: INITIAL SOURCE REVIEWED; deeper triangulation required**
Unity's 2026 Game Development Report was scraped from https://unity.com/resources/gaming-report.
Key report claims (survey of 300 developers, fielded 16 Sep–3 Oct 2025; Unity internal platform data also used):
- 52% of surveyed developers said their teams were focusing on smaller, more manageable projects.
- 48% reported becoming more selective about prototypes; 26% increased low-fidelity prototyping; 17% shortened prototyping to reduce cost/risk.
- 46% reported prototyping for 1–3 months; 21% under a month.
- Respondents reported AI use in coding assistance (62%), narrative/writing (44%), NPC behaviour (40%), market research (37%), automated playtesting (35%), concept art/assets (35%), and code QA (28%).
- The report states the survey sample was 300 developers across AMER, APAC, EMEA and SAMER, with +/-5.66% margin of error at 95% confidence.
Limitations: Unity-sponsored report; small survey sample; respondents do not represent every studio or engine. These percentages are descriptive, not universal prescriptions. Unity report is not Godot-specific.

### C. Current industry context
**Status: INITIAL SOURCE REVIEWED**
GDC 2026 State of the Game Industry report article: https://gdconf.com/article/gdc-2026-state-of-the-game-industry-reveals-impact-of-layoffs-generative-ai-and-more/
The article reports responses from more than 2,300 industry professionals. It reports engine and AI-use trends, including Godot use among newer indie developers. Need inspect the original report and separate platform, role and studio-size subsets before using statistics in BTV planning.

### D. Academic evidence
**Status: IN PROGRESS**
Consensus research thread dispatched at 12:43:09 UTC in Pro mode:
https://consensus.app/search/research-brief-for-beyond-the-veil-the-last-watch-/tWJBRgl1RDCoKJqFlG2WEw/
Scope includes production lifecycle, prototyping, vertical slices, level/mission design, navigation, pacing, environmental storytelling, scene staging, camera/lighting, modular world construction, character animation, companion AI, architecture, save/load, audio, UI/UX, accessibility, mobile optimisation, QA and production failure modes.
At 12:43:35 UTC, Consensus still reported status `running`; no findings are yet available. Poll only after the tool's required wait interval. Preserve the generated document and all inline citation markers exactly when complete.

### E. Perplexity integration
**Status: BLOCKED — no matching plugin surfaced**
Plugin directory search for Perplexity returned no available plugins. Do not claim Perplexity is connected or installable in this environment.
Perplexity official API platform: https://www.perplexity.ai/api-platform
Its API offers search and agent APIs, but API use is a separate integration requiring credentials and may incur usage charges. Do not create keys, configure an API integration, or incur costs without explicit user approval.
Firecrawl is already installed and can be used for current web search and page extraction. It is a research alternative, not a Perplexity connector.

## 3. Initial evidence and references
- Unity 2026 Game Development Report: https://unity.com/resources/gaming-report
- GDC 2026 State of the Game Industry: https://gdconf.com/article/gdc-2026-state-of-the-game-industry-reveals-impact-of-layoffs-generative-ai-and-more/
- Godot Android export documentation: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- Perplexity API Platform: https://www.perplexity.ai/api-platform
- OpenAI plugin directory help: https://help.openai.com/en/articles/20001256-plugins-in-chatgpt

## 4. Completed in this window
- [x] Confirmed existing BTV continuity protocol and read it before continuing.
- [x] Defined the broad research scope and dispatched one comprehensive Consensus research brief.
- [x] Searched the available plugin directory for Perplexity; no matching plugin found.
- [x] Confirmed Firecrawl is already installed.
- [x] Located initial industry reports, developer-talk archives and Godot documentation.
- [x] Reviewed the Unity 2026 report and captured its methodology limitations.

## 5. Not completed / not verified
- [ ] Consensus synthesis — still running at checkpoint time.
- [ ] Deep review of developer postmortems and GDC talks — not complete.
- [ ] Godot scene/node/resource/animation/navigation architecture review — not complete.
- [ ] Scene composition, environment art, camera, lighting, audio and UI production breakdown — not complete.
- [ ] Character/companion animation and AI production workflow review — not complete.
- [ ] Mobile performance and device constraints — not complete; target device remains unverified.
- [ ] BTV-specific recommendations and implementation mapping — not complete.
- [ ] Repository branch head and latest CI re-verification — not performed in this research window.
- [ ] No code, game scenes, assets, canon or architecture were changed.

## 6. Next actions
1. Poll Consensus after its required wait; when idle, preserve its full document exactly in an artifact/file and provide only a short summary plus its thread link in chat.
2. Continue industry research using GDC Vault, developer postmortems, official engine docs and studio technical breakdowns. Prioritise original talks/transcripts and primary sources over secondary summaries.
3. Research the Godot-specific production workflow: project structure, scenes/nodes, resources, signals, animation, navigation, import pipeline, profiling and Android export. Keep device-specific claims marked unknown until target hardware is identified.
4. Build a comparison matrix of professional practices: what it solves, team size/context, cost/complexity, evidence strength, suitability for BTV, and failure modes.
5. Translate findings into proposed BTV workflows only after cross-checking against the recovered source-of-truth documents and existing branch implementation.
6. Create a new checkpoint after the next major research milestone and a final checkpoint when the research phase is genuinely complete.

## 7. Exact resume point
Continue the BTV Game Development Research Programme. First retrieve the completed Consensus interaction (thread ID `tWJBRgl1RDCoKJqFlG2WEw`, interaction ID `di3c3m2BT8uW5eSb0nv1TA`) after its wait interval. Then continue primary-source developer research and Godot-specific technical research. Do not repeat the initial Unity report scrape or Perplexity plugin search unless verification indicates a material change.

## 8. Reconciliation checklist
- [ ] Reverify current branch and commit before repository changes.
- [ ] Recheck latest CI before making any test claims.
- [ ] Preserve Consensus citation markers and source links.
- [ ] Distinguish survey findings, academic evidence, practitioner opinion and BTV proposals.
- [ ] No unapproved canon or architecture changes.
- [ ] No paid API, credits, subscriptions or purchases.
- [ ] No Android-readiness claims without device validation.
