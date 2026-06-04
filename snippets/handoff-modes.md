# Handoff Modes Snippet

Chat handoff:

- Continue work in a new chat on the same branch, same tool.
- Do not update session logs.
- Do not push.
- Include branch, HEAD, worktree state, changed files, tests, open items, and next steps.
- Make it self-contained so it can be pasted alone into a new chat.

Agent-switch handoff:

- Continue the same branch in a different tool (for example Claude to Codex), mid-work.
- Commit work first so the tree is clean; the next tool starts cold and cannot read in-memory state.
- Write a relay note to `CONTINUE.md` (from/to agent, branch, HEAD, focus, next step, do-not-redo).
- Do not update session logs, push, or print a merge block.
- Name which startup file the incoming tool reads first (Codex: `AGENTS.md`, Claude: `CLAUDE.md`).
- If dirty files must remain, use an explicit dirty override and list every intentionally dirty path.

Full handoff:

- Use when ready for human review.
- Commit remaining intentional changes.
- Add one entry to the top of `SESSIONS.md`.
- Keep only the latest 4 full entries active.
- Move older entries to `SESSIONS_ARCHIVE.md`.
- Commit session logs separately.
- Push the branch.
- Print merge commands for the human reviewer.
