# BTV GitHub MCP & Branch Rules v1.0

**Status:** PROPOSED ACCESS POLICY — no GitHub settings or permissions changed by this document.

## 1. Purpose

Allow Claude, MiniMax Code and ChatGPT to collaborate through the BTV repository while limiting accidental or unauthorised changes.

## 2. Connection model

Each platform must be configured and authenticated separately by the account owner. A shared repository is a shared source of truth, not shared conversation memory. MCP endpoint availability, client compatibility and account entitlements must be verified in each platform.

- Never commit OAuth client secrets, personal access tokens, API keys, refresh tokens or private credentials.
- Never paste a secret into a task, issue, prompt, source file or activity log.
- Use the narrowest repository scope and permissions the provider supports.
- Prefer read access for review-only work; grant write access only where required for an approved task.
- Do not assume a connector is read-only or write-enabled without checking its actual permission screen.
- If a credential may have been exposed, stop using it and ask the account owner to revoke/rotate it through the provider's official controls.

## 3. Branch model

- Default branch: protected by policy; agents must not work directly on it.
- Feature branches: one task or tightly related task group per branch.
- Suggested names: `btv/agent-claude-<task-id>`, `btv/agent-minimax-<task-id>`, `btv/coord-<task-id>`.
- Do not force-push, rewrite shared history or overwrite another agent's branch.
- Do not delete branches or files without explicit creator approval.
- Use pull requests for review when the repository workflow supports them.
- A commit is not approval to merge.

## 4. Permission matrix

| Action | Default policy |
|---|---|
| Read approved project files | Allowed when connected |
| Search repository | Allowed when connected |
| Create isolated task branch | Allowed for an approved task |
| Add new files on task branch | Allowed within approved scope |
| Edit existing files on task branch | Allowed only within approved scope |
| Commit to task branch | Allowed for approved work |
| Open draft PR | Allowed after handoff is ready |
| Delete files or branches | Creator approval required |
| Change repository visibility/settings/security | Creator approval required; do not delegate by default |
| Change branch protection/rulesets/secrets/apps | Creator approval required; do not delegate by default |
| Merge or close PR as final | Creator approval required |
| Publish/release/deploy/upload publicly | Creator approval required |
| Spend money or paid credits | Explicit approval required |

## 5. MCP operating safeguards

Before a write, verify repository, branch, path, current file state and task approval. Never infer that a tool call succeeded without its returned result. Avoid parallel writes to the same path. After writing, fetch the file or inspect the commit to verify the final content. Stop on unexpected branch movement, permission escalation, conflicts or ambiguous target.

## 6. Scope of this policy

This file documents the intended policy only. It does not configure GitHub branch protection, create OAuth apps, generate credentials, install MCP servers, connect Claude or MiniMax, or guarantee that platform permissions enforce this policy. The creator must review actual provider settings separately.
