# CLAUDE.md - Claude Code Guide

This file is a short operating guide for Claude Code. It should contain only rules useful in every session. Read project details from linked docs only when the task needs them.

---

## Start

1. Run `git status --short --branch`.
2. Read the newest entry in [SESSIONS.md](./SESSIONS.md). Do not read [SESSIONS_ARCHIVE.md](./SESSIONS_ARCHIVE.md) unless investigating older decisions or regressions.
3. If starting new work, branch before editing:

```bash
git checkout <MAIN_BRANCH>
git pull --ff-only
git checkout -b claude/YYYY-MM-DD-short-scope
```

If the human owner asks you to continue an existing branch, stay on it after confirming the branch and worktree state.

---

## How To Work

- Think before coding. State assumptions, surface tradeoffs, and ask when intent is unclear.
- Keep it simple. Implement the minimum solution requested; do not add speculative features or abstractions.
- Make surgical changes. Touch only files and lines needed for the task; mention unrelated issues instead of fixing them.
- Clean up only your own mess. Remove unused code introduced by your changes; do not delete pre-existing dead code unless asked.
- Define success before editing. For multi-step work, use a brief plan with a verification check for each step.
- Verify before handoff. Run the smallest relevant checks and report anything not run.

---

## Git Rules

- Never commit directly to `<MAIN_BRANCH>`.
- Work on one session branch unless the human owner redirects.
- Before every commit or handoff, run `git status --short --branch`.
- Stage only intentional paths. Do not use `git add -A` unless every changed and untracked file belongs to this task.
- Use logical commits with clear messages.
- Do not push or update session logs unless the human owner asks for full handoff.

---

## Handoffs

Use the detailed protocol in [docs/agent-handoff-kit.md](./docs/agent-handoff-kit.md) when needed.

**Chat handoff** is for continuing in a new chat. Do not update session logs, push, or print merge commands. Provide one self-contained continuation block with branch, HEAD, worktree state, commits, changed areas, checks run, open items, next steps, and intentionally uncommitted files.

**Full handoff** is for review/merge. Commit remaining intentional work, update [SESSIONS.md](./SESSIONS.md), rotate older entries to [SESSIONS_ARCHIVE.md](./SESSIONS_ARCHIVE.md) if needed, commit the log update, push the branch, and print merge commands for the human owner.

If session-log conflicts happen, preserve every entry and order them newest-first.

---

## What Not To Do

- Do not update `SESSIONS.md` or `SESSIONS_ARCHIVE.md` except during explicit full handoff.
- Do not add build tools, dependencies, formatting churn, or broad refactors unless explicitly requested.
- Do not add production debug logging unless debugging a specific reported issue.
- Do not rely on project facts from memory. Inspect current files or task-relevant docs.

---

## Reference Map

- Current state: [SESSIONS.md](./SESSIONS.md)
- Handoff protocol: [docs/agent-handoff-kit.md](./docs/agent-handoff-kit.md)
- Project overview: `<PROJECT_OVERVIEW_DOC>`
- Build/test docs: `<PROJECT_VERIFY_DOCS>`
- Technical/domain notes: `<PROJECT_REFERENCE_DOCS>`
