# <PROJECT_NAME>

This file is the shared project reference for Claude Code and other agents. Keep it focused on stable project context, not long session history.

## Project Facts

- Main branch: `<MAIN_BRANCH>`
- Primary language/framework: `<FILL_ME>`
- Run/test command: `<PRIMARY_COMMANDS>`
- Local dev command: `<FILL_ME>`
- Deploy/release notes: `<FILL_ME>`

## Architecture

Write the small map an agent needs before editing:

- Main entrypoints: `<FILL_ME>`
- Important modules/services: `<FILL_ME>`
- Data/storage/contracts: `<FILL_ME>`
- External APIs or credentials policy: `<FILL_ME>`

## Project Conventions

- Code style: `<FILL_ME>`
- Test expectations: `<FILL_ME>`
- Files or folders agents must not edit without explicit approval: `<DO_NOT_TOUCH_PATHS>`
- Generated files: `<FILL_ME>`
- Security/privacy constraints: `<PROJECT_RULES>`

## Multi-Agent Collaboration

This repo uses `agent-handoff-kit`. Git is the coordination system.

The loop:

1. The human owner starts an agent session and gives it a task.
2. The agent creates its own branch from `<MAIN_BRANCH>`.
3. The agent works and may make logical commits.
4. Chat handoff continues work in a new chat without pushing or updating session logs.
5. Full handoff commits remaining work, updates `SESSIONS.md`, rotates older entries into `SESSIONS_ARCHIVE.md`, pushes the branch, and prints merge commands.
6. The human owner reviews and merges into `<MAIN_BRANCH>`.

Branch naming:

```text
codex/YYYY-MM-DD-short-scope
claude/YYYY-MM-DD-short-scope
cursor/YYYY-MM-DD-short-scope
aider/YYYY-MM-DD-short-scope
```

Rules:

- Never commit directly to `<MAIN_BRANCH>`.
- Never push `<MAIN_BRANCH>`.
- Do not share one branch across agents unless the human owner explicitly asks.
- Do not revert or overwrite unrelated changes from another user or agent.
- Keep `SESSIONS.md` small: latest `<ACTIVE_ENTRY_LIMIT>` full entries only.
- Preserve older entries verbatim in `SESSIONS_ARCHIVE.md`.
- Read `SESSIONS_ARCHIVE.md` only when older context is actually needed.

## Handoff Entry Format

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
**Next:** <who should do what next>
```

## Fast Review Of Previous Agent Work

Before continuing another agent's branch, gather:

```bash
git status --short --branch
git log --oneline <MAIN_BRANCH>..HEAD
git diff <MAIN_BRANCH>...HEAD --stat
git diff <MAIN_BRANCH>...HEAD --name-only
```

Then read:

- Top `SESSIONS.md` entry
- Commit subjects from the branch
- Only changed files relevant to the task
- Test/check notes from the last handoff

Avoid rereading the whole archive unless the current bug or decision depends on older history.
