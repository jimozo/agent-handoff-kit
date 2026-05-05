# Agent Handoff Kit

Reusable rules for projects where Codex, Claude Code, Cursor, Aider, or other coding agents work in the same repo and a human owner merges to the stable branch.

Defaults:

- Main branch: `<MAIN_BRANCH>`
- Active session log limit: `<ACTIVE_ENTRY_LIMIT>`
- Branch prefixes: `codex/`, `claude/`, `cursor/`, `aider/`

## Core Model

- Agents work on isolated branches.
- The human owner merges branches into `<MAIN_BRANCH>`.
- `SESSIONS.md` is the token-light active handoff surface.
- `SESSIONS_ARCHIVE.md` preserves older entries without forcing every new chat to read them.
- Chat handoff is for continuing work in a new chat.
- Full handoff is for review, push, and eventual merge.

## Start Session

Before touching files:

```bash
git checkout <MAIN_BRANCH>
git pull --ff-only
git checkout -b <agent>/YYYY-MM-DD-short-scope
```

Do not share one branch between agents unless the human owner explicitly asks.

## Optimized Context Loading

At session start, read in this order:

1. Project startup instructions, such as `AGENTS.md`
2. Top entry in `SESSIONS.md`
3. Relevant project reference sections, such as `CLAUDE.md` or Cursor rules
4. Files changed by the active branch, if continuing prior work

Do not read `SESSIONS_ARCHIVE.md` by default.

## Check Previous Agent Work

Use this when taking over another agent's branch:

```bash
git status --short --branch
git log --oneline <MAIN_BRANCH>..HEAD
git diff <MAIN_BRANCH>...HEAD --stat
git diff <MAIN_BRANCH>...HEAD --name-only
```

If you need detail for one file:

```bash
git diff <MAIN_BRANCH>...HEAD -- path/to/file
```

Read commits and diffs before editing. Do not redo or revert another agent's work unless the user asks.

## Chat Handoff

Use when work should continue in a fresh chat on the same branch.

Do not update `SESSIONS.md`, do not update `SESSIONS_ARCHIVE.md`, do not push, and do not print merge commands.

Gather:

```bash
git status --short --branch
git log --oneline <MAIN_BRANCH>..HEAD
git diff <MAIN_BRANCH>...HEAD --stat
```

Output:

```markdown
# Chat Handoff - <PROJECT_NAME>

Branch: `<branch-name>`
HEAD: `<short hash> <subject>`
Worktree: clean/dirty

Completed:
- <what changed>

Changed files:
- `<path>`: <why it matters>

Tests/checks:
- <command/result>

Open:
- <blocker/risk>

Next:
1. <immediate next step>
2. <next step>

Intentionally uncommitted:
- <path or "none">

Continuation prompt:
Continue work in this repository on branch `<branch-name>`.

Current state:
- HEAD: `<short hash> <subject>`
- Worktree: clean/dirty
- Completed: <one-sentence summary>
- Open: <blocker/risk or "none">
- Next: <immediate next step>

Start by reading the project startup instructions, the top of `SESSIONS.md`, and relevant project reference sections. Do not restart strategy. First inspect `git status --short --branch`, `git log --oneline <MAIN_BRANCH>..HEAD`, and `git diff <MAIN_BRANCH>...HEAD --stat`.
```

The whole block is the handoff. It must be safe to paste by itself into a new chat.

## Full Handoff

Use when the branch is ready for human review and merge.

1. Run `git status --short --branch`.
2. Commit remaining intentional changes.
3. Add one new entry to the top of `SESSIONS.md`.
4. Keep only the latest `<ACTIVE_ENTRY_LIMIT>` full entries in `SESSIONS.md`.
5. Move older entries to `SESSIONS_ARCHIVE.md`, preserving them verbatim and newest-first.
6. Commit the session-log update separately.
7. Push the branch.
8. Print the human merge block.

Session entry:

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

Human merge block:

```text
SESSION DONE - run these commands in terminal:

cd <repo-root>
git checkout <MAIN_BRANCH>
git pull --ff-only
git merge --no-ff <branch-name>
git push origin <MAIN_BRANCH>

Then open SESSIONS.md to see what's next.
```

## Conflict Rules

- Preserve every session entry.
- Newest entries go first.
- If two branches add `SESSIONS.md` entries, keep both.
- If both branches rotate into `SESSIONS_ARCHIVE.md`, preserve every archived entry exactly once.
- Do not delete another agent's entry.
- Do not rewrite history prose except to resolve duplicate archived entries.
