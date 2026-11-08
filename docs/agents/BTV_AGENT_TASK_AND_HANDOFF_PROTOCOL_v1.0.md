# BTV Agent Task & Handoff Protocol v1.0

## 1. Task record

Every cross-platform task must begin with a written record containing:

- Task ID and concise title.
- Requesting authority and accountable owner.
- Assigned platform/agent and reviewer.
- Objective and explicitly excluded scope.
- Status and priority.
- Authoritative source paths and versions.
- Inputs, references and available assets.
- Required output format and destination branch/path.
- Acceptance criteria and test method.
- Cost/credit implications and approval state.
- Dependencies, risks and due point if one exists.

## 2. Lifecycle

1. **INTAKE:** Coordinator restates the requested outcome and scope.
2. **SOURCE CHECK:** Read relevant canon/specifications and note conflicts.
3. **ASSIGN:** One owner receives a bounded task and acceptance criteria.
4. **ACKNOWLEDGE:** Owner confirms understanding, access and blockers.
5. **EXECUTE:** Work only within the assigned branch and permission scope.
6. **HANDOFF:** Owner returns deliverables and evidence using section 3.
7. **REVIEW:** Independent reviewer checks correctness and acceptance criteria.
8. **CREATOR DECISION:** Creator approves, requests changes, rejects or leaves proposed.
9. **RECORD:** Update activity and decision logs; link commit/PR where applicable.

## 3. Handoff format

Every handoff must include:

- Task ID, owner/platform, reviewer and status.
- Branch, commit SHA and exact changed paths (or state that no repository changes were made).
- Summary of work and design/implementation rationale.
- Sources consulted and relevant sections.
- Tests/reviews performed, exact commands or method, and observed results.
- Visuals/assets actually produced and their provenance/licence status.
- Known defects, limitations, assumptions and unresolved questions.
- Cost/credits used or confirmed zero; if unknown, say unknown.
- Acceptance criteria: PASS / FAIL / NOT TESTED with evidence.
- Requested next action and whether creator approval is required.

## 4. Cross-agent review

- Claude's visual brief is reviewed for canon and implementability before MiniMax builds it.
- MiniMax's implementation is reviewed against the accepted visual brief and technical acceptance tests.
- Claude may critique implementation screenshots or outputs but cannot unilaterally redefine the approved brief.
- ChatGPT checks source traceability, scope, implementation evidence and cross-discipline consistency.
- If agents disagree, preserve both positions, cite evidence and escalate. Do not average conflicting claims into a false consensus.

## 5. Change control

A changed requirement creates a new task revision. Do not silently expand scope. A creator-approved design change must be recorded before implementation. If implementation reveals a necessary change, stop at the boundary and request a decision.

## 6. Failure and rollback

Stop and report if a task encounters unexpected destructive changes, credential exposure, security warnings, canon conflicts, unapproved costs, missing source files or unexplained test failures. Do not attempt cleanup by deleting files or rewriting history. Preserve evidence and request direction.

## 7. Minimal task status

**PROPOSED → READY → IN PROGRESS → REVIEW → AWAITING CREATOR → APPROVED / REJECTED / BLOCKED → RECORDED**

A status transition must reflect an actual event, not an agent's intention.
