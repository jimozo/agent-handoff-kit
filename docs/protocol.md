# Protocol

`agent-handoff-kit` keeps multi-agent collaboration small enough for every new agent chat to load quickly.

Root instruction files should stay small. Use `AGENTS.md`, `CLAUDE.md`, Cursor rules, or similar files for every-session behavior: startup order, branch safety, handoff rules, verification expectations, and links to deeper docs. Keep architecture, product facts, release history, security details, and long templates in task-relevant docs.

## Concepts

- Stable branch: the branch humans merge into, usually `main`.
- Agent branch: one branch owned by one agent session.
- Active log: `SESSIONS.md`, newest entries first.
- Archive: `SESSIONS_ARCHIVE.md`, older entries preserved verbatim.
- Chat handoff: continue work in a fresh chat without pushing.
- Full handoff: prepare a branch for human review and merge.

## Session Start

Every agent starts by reading:

1. Project startup instructions, such as `AGENTS.md`
2. Top entry in `SESSIONS.md`
3. Current branch status and recent commits, if continuing work
4. Task-relevant docs or source files

Then create a branch:

```bash
git checkout main
git pull --ff-only
git checkout -b codex/YYYY-MM-DD-short-scope
```

Use the matching prefix for the agent: `codex/`, `claude/`, `cursor/`, or `aider/`.

## During Work

Agents should:

- Stay on their branch.
- Commit logical checkpoints.
- Stage intentional files only.
- Avoid unrelated refactors.
- Preserve user and agent changes they did not make.
- Record open questions in chat until full handoff.

Before every commit:

```bash
git status --short --branch
```

## Chat Handoff

Use chat handoff when context is getting long or another chat should continue the same branch.

Do not:

- Update `SESSIONS.md`
- Update `SESSIONS_ARCHIVE.md`
- Push
- Print merge commands

Include:

- Branch and HEAD commit
- Clean or dirty worktree state
- Commits on the branch
- Changed files and why they matter
- Tests/checks run
- Open risks or blockers
- Exact next steps
- Any files intentionally left uncommitted
- A self-contained continuation prompt that can be pasted alone into a new chat

## Full Handoff

Use full handoff when work is ready for human review.

Steps:

1. Run `git status --short --branch`.
2. Commit remaining intentional changes.
3. Add a new entry to the top of `SESSIONS.md`.
4. Keep only the latest 4 full entries in `SESSIONS.md`.
5. Move older entries to `SESSIONS_ARCHIVE.md`.
6. Commit session-log changes separately.
7. Push the branch.
8. Print merge commands for the human reviewer.

## Handoff Entry

```markdown
## YYYY-MM-DD - <Agent> - <one-line scope>
**Branch:** <branch-name>
**Merged:** pending (human merges after review)
**Scope:** <what was done and why>
**Changes:**
- <file or area>: <what changed>
**Commits:** <short hash and subject>
**Tests:** <what was tested, or "none - gap">
**Open:** <anything unresolved or known broken>
**Next:** <which agent or human should do what next>
```
