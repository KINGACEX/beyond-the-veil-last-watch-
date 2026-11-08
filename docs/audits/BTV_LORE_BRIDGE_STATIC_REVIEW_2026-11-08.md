# BTV Lore Bridge — Static Review

**Review date:** 2026-11-08  
**Artifact:** Creator-supplied `btv-lore-bridge.zip`  
**SHA-256:** `3c045fb5148b96caa7c71697ebff5bbed191b316e6094e7de0e191374245bb71`  
**Review type:** Source/archive inspection only  
**Execution status:** NOT EXECUTED  
**Recommendation:** RETAIN AS A PROMISING PROTOTYPE; DO NOT INSTALL OR TRUST IN A LIVE WORKSPACE UNTIL THE BLOCKERS BELOW ARE ADDRESSED.

## 1. Purpose and apparent architecture

The project aims to provide a shared BTV knowledge interface for MiniMax Code, Claude Code and Codex through a local Node.js MCP server.

Archive contents include:
- `README.md` — setup and usage documentation.
- `lib/corpus.mjs` — corpus parsing/build logic.
- `lib/search.mjs` — retrieval/search logic.
- `scripts/build_index.mjs` — index builder.
- `scripts/query.mjs` — query interface.
- `scripts/gap_analysis.mjs` — implementation-gap analysis.
- `server/server.mjs` — MCP server.
- `register.sh` — MCP registration helper.
- `btv-lore-claude.sh` — Claude-oriented workflow wrapper.
- `tests/mcp_smoke_test.mjs` and sample fixture.
- `package.json` and lockfile.

The MCP surface documented in the source includes:
- `lore_search`
- `lore_get`
- `lore_list`
- `lore_stats`
- `repo_files`
- `lore_gap`

The architecture is useful because it separates a project corpus and retrieval layer from each assistant's conversational context. It could reduce repeated handoffs and make canon references easier to retrieve. This is an architectural assessment, not evidence that the server works correctly.

## 2. Static review findings

### LRB-001 — Destructive rebuild scope

**Severity:** HIGH  
**Observation:** The rebuild flow appears to remove the entire Markdown corpus directory before rebuilding. That directory may contain manually authored or curated material as well as generated content.  
**Risk:** A normal rebuild could erase source documents or human corrections.  
**Required fix:** Separate immutable/source corpus from generated index output. Rebuild only a dedicated generated directory. Require an explicit destructive flag for any cleanup and print the exact paths before action. Add tests proving hand-authored files survive rebuild.

### LRB-002 — MCP registration is not safely additive

**Severity:** HIGH  
**Observation:** The registration helper can remove an existing server entry before re-adding it.  
**Risk:** Existing configuration, arguments, environment values or unrelated MCP servers could be lost.  
**Required fix:** Back up the config, parse and merge only the named server key, preserve all unrelated keys, write atomically, verify the result and provide rollback. Never delete the existing entry first.

### LRB-003 — Invalid MiniMax config handling may destroy configuration

**Severity:** HIGH  
**Observation:** The MiniMax registration path appears capable of replacing an invalid configuration with a minimal config.  
**Risk:** Existing user configuration could be overwritten in an error-recovery path.  
**Required fix:** Fail closed. Preserve the original file byte-for-byte, write a separate diagnostic report and require the user to repair or explicitly authorize a migration.

### LRB-004 — Keyword gap analysis is not implementation verification

**Severity:** HIGH  
**Observation:** `lore_gap` uses keyword-oriented matching.  
**Risk:** A keyword in a comment, test fixture or unrelated file may be interpreted as proof that a feature exists.  
**Required fix:** Return evidence classifications rather than binary claims:
- `DOC_ONLY`
- `CODE_REFERENCE_FOUND`
- `TEST_PRESENT`
- `TEST_PASSED`
- `RUNTIME_OBSERVED`
- `NOT_FOUND`
- `CONFLICTING_EVIDENCE`

Each result must identify exact paths and line ranges. Only test output can support TEST_PASSED; only an observed runtime check can support RUNTIME_OBSERVED. Human review remains required for semantic completeness.

### LRB-005 — Conversation export branch coverage

**Severity:** MEDIUM  
**Observation:** The parser may follow the current conversation branch rather than enumerate every branch in an exported conversation tree.  
**Risk:** Relevant decisions from alternate branches could be omitted from the knowledge corpus.  
**Required fix:** Preserve conversation node IDs and parent/child relationships. Enumerate all nodes, record branch provenance, and avoid flattening conflicting branches into a single decision.

### LRB-006 — Generated code is not validated implementation

**Severity:** MEDIUM  
**Observation:** The Claude-oriented pipeline drafts GDScript but does not automatically apply it or establish that Godot accepts it.  
**Risk:** A generated patch could be mistaken for implemented and tested code.  
**Required fix:** Keep generated output as a patch proposal. Require a human/agent review, feature branch, Godot parser/import check, targeted tests and recorded commit before marking implementation complete.

### LRB-007 — Privacy and corpus minimization

**Severity:** CRITICAL  
**Observation:** A full ChatGPT export may contain unrelated conversations, personal details and sensitive material. A local ignore rule does not itself filter content before indexing or prevent accidental sharing.  
**Risk:** Private unrelated content could be indexed, exposed through MCP tools or committed to Git.  
**Required fix:**
1. Use a BTV-only conversation/source allowlist.
2. Exclude unrelated conversations by default.
3. Add sensitive-data scanning and manual review.
4. Keep raw exports outside the repository and outside shared MCP exposure.
5. Never commit raw exports, generated private corpora, indexes or secrets.
6. Store only approved BTV excerpts with source IDs, provenance and canon status.
7. Provide a corpus manifest and a deletion/rebuild test that proves excluded data is absent.

### LRB-008 — Claude mobile compatibility is unverified

**Severity:** HIGH  
**Observation:** The supplied shell pipeline targets Claude Code.  
**Risk:** It may not run in Claude mobile, and local Node MCP server support depends on client and device environment.  
**Required fix:** Treat Claude Code and Claude mobile as separate targets. Test each explicitly. Do not claim mobile compatibility based on a shell script or local server design.

## 3. Required knowledge model

The bridge should not merge all retrieved text into one undifferentiated "lore" layer. Every item needs at least:

- stable source ID;
- title and source type;
- original source path or conversation identifier;
- created/updated/imported timestamps where available;
- author/agent identity;
- status: `APPROVED_CANON`, `APPROVED_DESIGN`, `PROPOSED`, `OPEN_QUESTION`, `CONFLICT`, `REJECTED`, `IMPLEMENTED_UNVERIFIED`, `TESTED`;
- authority tier;
- scope/permission tags;
- content hash and source version;
- supersedes/conflicts-with links;
- privacy classification.

A hash is evidence of byte identity only. It must never be treated as proof of truth, authority, approval or permission.

## 4. Minimum acceptance gates before use

| Gate | Required evidence | Status |
|---|---|---|
| A. Disposable test environment | Separate test directory and disposable config files | NOT RUN |
| B. Non-destructive corpus build | Rebuild leaves manually maintained files intact | NOT RUN |
| C. Registration safety | Existing config preserved; backup and rollback tested | NOT RUN |
| D. Privacy filter | BTV allowlist and sensitive-data exclusion tests pass | NOT RUN |
| E. MCP tool smoke test | Every advertised tool returns schema-valid results | NOT RUN |
| F. Retrieval provenance | Every answer includes source ID, status and exact file reference | NOT RUN |
| G. Gap-analysis accuracy | No implementation claim from keyword alone | NOT RUN |
| H. Agent compatibility | MiniMax Code and Claude target clients separately verified | NOT RUN |
| I. Godot validation handoff | Generated patch remains a proposal until import/tests pass | NOT RUN |
| J. Recovery | Backup restore and failed-registration rollback tested | NOT RUN |

## 5. Recommended v1.1 implementation order

1. Make corpus rebuild non-destructive.
2. Make MCP config registration additive, backed up and reversible.
3. Add strict BTV-only privacy filtering before indexing.
4. Add explicit status/authority/provenance fields to every corpus record.
5. Replace binary keyword gap claims with evidence-tier reporting.
6. Add conversation-tree traversal and conflict preservation.
7. Make code output a reviewable patch artifact with a test handoff.
8. Test Claude Code and Claude mobile independently.
9. Run the full suite only inside a disposable environment.
10. Document exact versions, commands, outputs and failure modes.

## 6. What this review does not establish

- The ZIP has not been installed or run.
- Dependencies have not been installed or audited dynamically.
- The MCP server has not been registered in any client.
- No configuration file has been modified.
- No private export has been ingested.
- No security penetration test has been performed.
- No Claude mobile or MiniMax Code connection has been verified.
- No source changes have been made to the external MiniMax project.

**Disposition:** Keep the artifact and its architecture. Treat all runtime, privacy, registration and compatibility claims as unverified until the acceptance gates are completed.
