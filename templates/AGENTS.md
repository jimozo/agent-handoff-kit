# AGENTS.md

Read this before touching files.

This project uses `agent-handoff-kit`, a lightweight multi-agent handoff system for Codex, Claude Code, Cursor, Aider, and other coding agents.

## Start Of Every Session

1. Read the top entry in [SESSIONS.md](./SESSIONS.md).
2. Read the project-specific agent instructions for architecture, commands, and rules.
3. Read [docs/agent-handoff-kit.md](./docs/agent-handoff-kit.md) if you need handoff details.
4. Do not read [SESSIONS_ARCHIVE.md](./SESSIONS_ARCHIVE.md) unless you need older decisions, regression context, or history.
5. Create a branch before editing:

```bash
git checkout <MAIN_BRANCH>
git pull --ff-only
git checkout -b codex/YYYY-MM-DD-short-scope
```

Use your own agent prefix if you are not Codex, for example `claude/`, `cursor/`, or `aider/`.

## During The Session

- Work only on your branch. Never commit directly to `<MAIN_BRANCH>`.
- Commit logical checkpoints as you go.
- Do not update `SESSIONS.md`, `SESSIONS_ARCHIVE.md`, push, or print merge commands during normal mid-session work.
- Do not revert or overwrite unrelated user or agent changes.
- Before every commit or handoff, run:

```bash
git status --short --branch
```

- Stage only intentional files. Avoid `git add -A` unless every changed and untracked file belongs to this session.

## Check The Last Agent Quickly

Use this when taking over work:

```bash
git status --short --branch
git log --oneline <MAIN_BRANCH>..HEAD
git diff <MAIN_BRANCH>...HEAD --stat
git diff <MAIN_BRANCH>...HEAD --name-only
```

Then read only the relevant changed files and the top `SESSIONS.md` entry.

## Handoff Modes

Chat handoff:

- Use when work should continue in a fresh chat on the same branch.
- Do not update session logs.
- Do not push.
- Report branch, HEAD commit, clean/dirty state, commits, changed areas, tests, open items, exact next steps, and intentionally uncommitted files.
- Make the handoff self-contained. Assume the next chat receives only the handoff block.

Full handoff:

- Use only when the branch is ready for human review and merge.
- Commit remaining intentional work.
- Add one new entry to the top of `SESSIONS.md`.
- Keep only the latest `<ACTIVE_ENTRY_LIMIT>` full entries in `SESSIONS.md`.
- Move older entries to `SESSIONS_ARCHIVE.md`, preserving them verbatim and newest-first.
- Commit the session-log update separately.
- Push your branch.
- Print the human merge block from [docs/agent-handoff-kit.md](./docs/agent-handoff-kit.md).

## Hard Rules

- Never commit directly to `<MAIN_BRANCH>`.
- Never push `<MAIN_BRANCH>`.
- Never delete another agent's session entry.
- Never rewrite archived entries except to resolve duplicates or preserve conflict content exactly once.
- The human owner merges branches into `<MAIN_BRANCH>`.
