# CONTINUE - <PROJECT_NAME>

Branch-local relay note for an **agent-switch handoff**: continuing the same branch in a different tool (for example Claude to Codex), mid-work, before human review.

This is temporary. Delete or clear it once the incoming tool has consumed it. Use `SESSIONS.md` for durable handoff history, not this file.

---

From: `<agent>` -> To: `<agent>`
Branch: `<branch-name>`
HEAD: `<short hash> <subject>`  (WIP checkpoint committed)
Worktree: clean/dirty

## Focus

- `<the one active task>`

## Immediate Next Step

1. `<the next action for the incoming tool>`

## Do Not Redo

- `<work already done; do not revert or re-derive>`

## Intentionally Dirty

- `<path or "none">`

---

Incoming tool reads first: `<AGENTS.md for Codex / CLAUDE.md for Claude>`, then this file.
