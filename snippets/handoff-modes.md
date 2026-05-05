# Handoff Modes Snippet

Chat handoff:

- Continue work in a new chat on the same branch.
- Do not update session logs.
- Do not push.
- Include branch, HEAD, worktree state, changed files, tests, open items, and next steps.

Full handoff:

- Use when ready for human review.
- Commit remaining intentional changes.
- Add one entry to the top of `SESSIONS.md`.
- Keep only the latest 4 full entries active.
- Move older entries to `SESSIONS_ARCHIVE.md`.
- Commit session logs separately.
- Push the branch.
- Print merge commands for the human reviewer.
