# BTV Lore Bridge v1.1 — Remediation and Acceptance Specification

**Status:** PROPOSED ENGINEERING SPECIFICATION  
**Date:** 2026-11-08  
**Input:** Static review of creator-supplied `btv-lore-bridge.zip`  
**Related audit:** `docs/audits/BTV_LORE_BRIDGE_STATIC_REVIEW_2026-11-08.md`  
**Owner proposal:** MiniMax Code (implementation); ChatGPT (coordination/review); creator (approval).

## 1. Objective

Make the Lore Bridge a safe, auditable, local-first knowledge service for BTV development. It must retrieve approved project knowledge with provenance and status, while preventing destructive rebuilds, configuration loss, accidental private-data ingestion and unsupported claims that code is implemented.

This document specifies the target behavior. It does not claim that any v1.1 changes have been implemented.

## 2. Non-goals

- No automatic canon approval or reconciliation.
- No ingestion of a complete personal ChatGPT export by default.
- No automatic edits to a user's live Claude, MiniMax or Codex configuration.
- No credentials stored in the corpus, source repository or logs.
- No automatic application of generated GDScript to the production project.
- No claim that keyword matching can determine semantic implementation completeness.
- No cloud sync, public endpoint or remote exposure in this version.

## 3. Data layout and destructive-operation boundary

Separate source material from generated output:

```text
btv-lore/
  sources/
    approved/
    proposals/
    research/
    synthetic-fixtures/
  generated/
    index/
    cache/
    reports/
  manifests/
    corpus-manifest.json
  server/
  lib/
  scripts/
  tests/
```

Rules:
1. `sources/` is never recursively deleted by an index rebuild.
2. Rebuild may replace only `generated/index/` and other explicitly enumerated generated outputs.
3. Generated paths must be resolved and checked to remain inside the project root before any write or removal.
4. The default rebuild is non-destructive and idempotent.
5. A destructive cleanup option, if retained, must be separately named, default off, require explicit confirmation and print exact targets.
6. A failed build must preserve the last known-good index or restore it atomically.
7. Never follow symlinks outside the project root during rebuild or cleanup.

## 4. Corpus record schema

Every indexed document/chunk must carry:

- `source_id`: stable unique identifier.
- `title` and `source_type`.
- `source_path` or original conversation/source reference.
- `source_hash`: digest of exact source bytes.
- `source_version` and optional `supersedes` / `conflicts_with`.
- `author_or_agent`.
- `created_at`, `updated_at`, `imported_at` where known.
- `authority_tier`.
- `status`.
- `scope_tags`.
- `privacy_classification`.
- `chunk_id` and source line/page boundaries where applicable.

Allowed status values:

- `APPROVED_CANON`
- `APPROVED_DESIGN`
- `PROPOSED`
- `OPEN_QUESTION`
- `CONFLICT`
- `REJECTED`
- `IMPLEMENTED_UNVERIFIED`
- `TESTED`
- `ARCHIVED_REFERENCE`

Allowed authority tiers:

1. `CREATOR_DECISION`
2. `MASTER_CANON`
3. `DOMAIN_BIBLE`
4. `APPROVED_DESIGN`
5. `RESEARCH_OR_PROPOSAL`
6. `AGENT_DRAFT`
7. `IMPLEMENTATION_EVIDENCE`

A digest verifies byte identity only. It does not establish truth, authority, approval, recency or permission.

## 5. Privacy-first ingestion

Default policy is allowlist, not denylist.

1. Accept only explicitly selected BTV source files and conversation IDs.
2. Raw ChatGPT export files remain outside the repository and outside MCP-accessible directories.
3. Never index unrelated personal conversations by default.
4. Add a pre-index review report showing every selected file and every excluded file.
5. Scan for likely secrets and sensitive personal data before indexing; block ingestion when uncertain.
6. Provide a manual approval manifest for sources that pass automated filtering.
7. Store only the approved excerpts needed for BTV work.
8. Ensure generated indexes, corpora, caches, logs and temporary exports are excluded from Git unless deliberately sanitized and approved.
9. Add tests proving that excluded sample conversations and synthetic secret strings never appear in the index or tool results.

## 6. Safe MCP client registration

Registration must be additive, reversible and fail-closed.

1. Never remove an existing server entry before replacement.
2. Read and parse the current configuration without mutating it.
3. If the file is malformed, stop and report the error; do not overwrite it with a minimal config.
4. Preserve all unrelated keys, server entries, environment variables and arguments.
5. Create a timestamped backup before any authorized write.
6. Write to a temporary file in the same directory, validate the new file, then atomically rename.
7. Re-read the resulting configuration and verify only the intended named entry changed.
8. Provide a rollback command that restores the exact backup.
9. Registration scripts must support dry-run mode and default to dry-run.
10. The test suite must use temporary fixture configs only; it must never read or modify a real user config.

## 7. MCP tool behavior

### `lore_search`
Return ranked matches with source ID, title, status, authority tier, source path, relevant line range, hash and a short excerpt. Filter by status and scope when requested. Do not silently hide conflicts.

### `lore_get`
Return the requested source/chunk with provenance and its full status metadata. If a source is superseded or conflicted, expose that state.

### `lore_list`
List sources by status, type, authority tier, scope and privacy classification. Do not list excluded or private raw exports.

### `lore_stats`
Report counts by source status, authority tier and source type. Clearly distinguish indexed files from indexed chunks.

### `repo_files`
Expose only paths within the configured repository root. Reject path traversal, absolute paths outside the root and symlink escapes. Return a bounded text excerpt rather than arbitrary file-system access.

### `lore_gap`
Must not return a binary "implemented/not implemented" verdict from keyword presence. It must return evidence tiers:

- `DOC_ONLY`
- `CODE_REFERENCE_FOUND`
- `TEST_PRESENT`
- `TEST_PASSED`
- `RUNTIME_OBSERVED`
- `NOT_FOUND`
- `CONFLICTING_EVIDENCE`

Every claim must include exact file paths and line ranges or test-run identifiers. A code reference is not proof of functional completeness. A test file is not proof that the test passed. A passing test is not proof of real-device runtime behavior.

## 8. Conversation export parsing

- Preserve the original node IDs and parent/child relationships.
- Enumerate all conversation branches rather than only the active leaf path.
- Record branch provenance and timestamps where present.
- Do not automatically merge conflicting branch statements into one accepted decision.
- Keep user messages, assistant outputs, tool outputs and quoted external content distinguishable.
- Exclude all non-BTV conversation nodes unless explicitly allowlisted.

## 9. Generated code handoff

Generated code must be emitted as a patch proposal with:
- task ID;
- source documents and status;
- target branch and file paths;
- assumptions and unresolved questions;
- diff;
- tests to run;
- known risks.

It must not be reported as implemented until the patch is applied to an isolated branch, reviewed, imported by the correct Godot version and passes relevant tests. Runtime claims require a recorded runtime test.

## 10. Client compatibility matrix

Claude Code, Claude mobile and MiniMax Code are separate client targets.

| Client | Required proof |
|---|---|
| MiniMax Code | MCP server starts, tools are discovered, search/get/list/stats return schema-valid results, repository access remains scoped. |
| Claude Code | Same MCP smoke tests plus handoff workflow and safe tool invocation. |
| Claude mobile | Explicit confirmation that the client supports the required MCP transport/runtime. A Claude Code shell script is not evidence of mobile support. |
| Codex / ChatGPT MCP host | Only claim compatibility after the exact host can connect and complete the same smoke tests. |

Do not change real client configurations until the disposable test passes and the creator explicitly approves the exact target client.

## 11. Required automated tests

At minimum:

- rebuild does not delete source files;
- rebuild is repeatable and produces deterministic manifest output;
- failed rebuild preserves the last good index;
- path traversal is rejected;
- symlink escape is rejected;
- malformed config is preserved unchanged;
- registration preserves unrelated config entries;
- backup is created before authorized mutation;
- rollback restores exact original bytes;
- dry-run performs no writes;
- private/unapproved sources are excluded;
- synthetic secret strings never enter index results;
- all conversation-tree branches are discoverable;
- conflicts remain visible;
- every MCP tool validates its response schema;
- `lore_gap` never upgrades a keyword match to TEST_PASSED or RUNTIME_OBSERVED;
- repository file reads remain within the configured root.

## 12. Acceptance gates

| Gate | Exit condition | Status |
|---|---|---|
| G1 — Architecture | Source and generated directories are separate; schema documented | NOT STARTED |
| G2 — Rebuild safety | Destructive scope tests pass | NOT STARTED |
| G3 — Config safety | Backup, additive merge, dry-run and rollback tests pass on fixtures | NOT STARTED |
| G4 — Privacy | Allowlist and sensitive-data exclusion tests pass | NOT STARTED |
| G5 — Provenance | Every returned record has source/status/authority metadata | NOT STARTED |
| G6 — Evidence tiers | Gap analysis cannot claim implementation from keywords | NOT STARTED |
| G7 — MCP smoke | All tools pass in a disposable environment | NOT STARTED |
| G8 — Client compatibility | Each intended client is tested independently | NOT STARTED |
| G9 — Creator approval | Exact connection scope approved before any live registration | NOT STARTED |

## 13. Implementation handoff

The first implementation task should address G1 and G2 only. Do not combine privacy ingestion, client registration and gap-analysis changes into one unreviewable patch.

The implementation agent must:
1. inspect the current source and tests;
2. create a dedicated feature branch;
3. add failing tests before changing rebuild behavior;
4. make the smallest non-destructive change;
5. run tests against synthetic fixtures;
6. provide diff, test commands, output and limitations;
7. stop before touching real client configuration or any real conversation export.

**Current disposition:** specification drafted; no Lore Bridge source code has been changed and no tests have been run.
