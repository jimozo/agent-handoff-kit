# Comparison To Other Agent Files

`agent-handoff-kit` is a coordination protocol. It is not a replacement for project-specific instruction files.

## `AGENTS.md`

`AGENTS.md` is usually the startup guide for Codex and other agents.

Use it for:

- What to read first
- Branching rules
- Safety rules
- Repository-specific must-follow instructions

`agent-handoff-kit` can be referenced from `AGENTS.md`, but should not erase the repo's existing instructions.

## `CLAUDE.md`

`CLAUDE.md` is commonly a deeper project reference for Claude Code.

Use it for:

- Architecture
- Commands
- Code style
- Product constraints
- Stable collaboration rules

`agent-handoff-kit` adds a reusable session protocol around it.

## Cursor Rules

Cursor rules are editor-integrated instructions.

Use them for:

- Editor behavior
- Codebase-specific conventions
- Patterns Cursor should apply during edits

Keep them. Add a short reference to `SESSIONS.md` and the handoff protocol if Cursor participates in branch-based agent work.

## `CONTINUE.md`

`CONTINUE.md` is useful for temporary continuation notes, especially in projects that already use it.

Use it for:

- One active focus
- Short next-step notes
- Temporary branch-local state

Prefer `SESSIONS.md` for durable handoff history. Avoid letting `CONTINUE.md` become a second long archive.

## What This Kit Owns

`agent-handoff-kit` owns:

- Session start order
- Branch-per-agent convention
- Chat handoff format
- Full handoff format
- Session log rotation
- Last-agent review
- Conflict handling for session logs

Your project files still own:

- Architecture
- Build and test commands
- Product rules
- Security constraints
- Coding style
- Generated-file policy
