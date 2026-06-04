# Comparison To Other Agent Files

`agent-handoff-kit` is a coordination protocol. It is not a replacement for project-specific docs.

The recommended pattern is:

- Root instruction files, such as `AGENTS.md` and `CLAUDE.md`, stay short and standalone.
- They contain every-session behavior: startup, branch/git safety, surgical changes, verification, handoffs, and a reference map.
- Project facts live in task-relevant docs: README, architecture notes, verification docs, launch plans, security docs, or domain-specific references.
- Agents read broad project context only when the task needs it.

## `AGENTS.md`

`AGENTS.md` is usually the startup guide for Codex and other agents.

Use it for:

- What to read first
- Branching rules
- Safety rules
- Every-session repository rules
- Links to deeper docs

`agent-handoff-kit` can be referenced from `AGENTS.md`, but should not turn it into a long project reference.

## `CLAUDE.md`

`CLAUDE.md` is commonly Claude Code's startup guide.

Use it for:

- Claude-specific startup order
- Branching and git safety
- Handoff rules
- Verification expectations
- Links to deeper docs

Keep it standalone. Do not make it depend on `AGENTS.md`, and do not make `AGENTS.md` depend on it. If both files exist, duplicate the small set of every-session rules so either agent can operate safely after reading its own guide.

## Cursor Rules

Cursor rules are editor-integrated instructions.

Use them for:

- Editor behavior
- Codebase-specific conventions
- Patterns Cursor should apply during edits

Keep them. Add a short reference to `SESSIONS.md` and the handoff protocol if Cursor participates in branch-based agent work.

## `CONTINUE.md`

In this kit, `CONTINUE.md` is the **agent-switch relay surface**: the branch-local note one tool leaves for another when continuing the same branch mid-work (see [agent-switch-handoff.md](./agent-switch-handoff.md)).

Use it for:

- One active focus and the immediate next step
- What the incoming tool should not redo
- Temporary branch-local state during a tool switch

Prefer `SESSIONS.md` for durable handoff history. Clear or delete `CONTINUE.md` once the incoming tool consumes it, so it never becomes a second stale log.

## What This Kit Owns

`agent-handoff-kit` owns:

- Session start order
- Branch-per-agent convention
- Chat handoff format
- Agent-switch handoff format (cross-tool relay via `CONTINUE.md`)
- Full handoff format
- Session log rotation
- Last-agent review
- Optional agent ownership map
- Conflict handling for session logs

Your project files still own:

- System design
- Build and test commands
- Product rules
- Security constraints
- Coding style
- Generated-file policy
