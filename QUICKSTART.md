# Quickstart

This guide installs the handoff protocol into an existing repository.

## 1. Copy The Kit

From the project where you want the protocol installed:

```bash
../agent-handoff-kit/scripts/install.sh --target .
```

The installer is conservative:

- It creates missing handoff files.
- It skips existing files by default.
- It writes the handoff protocol to `docs/agent-handoff-kit.md`.
- It does not replace existing `AGENTS.md`, `CLAUDE.md`, Cursor rules, or `CONTINUE.md` unless you pass `--force`.

Manual install is also fine: copy files from `templates/` into your repo root and copy `docs/protocol.md` into your repo docs.

## 2. Fill Placeholders

Edit installed templates and replace:

- `<PROJECT_NAME>`
- `<MAIN_BRANCH>`; default: `main`
- `<ACTIVE_ENTRY_LIMIT>`; default: `4`
- `<PROJECT_OVERVIEW_DOC>`
- `<PROJECT_VERIFY_DOCS>`
- `<PROJECT_REFERENCE_DOCS>`

Keep root instruction files short and focused on every-session behavior. Put architecture, commands, product facts, security notes, and long templates in task-relevant docs, then link to those docs from the reference map. Keep private machine paths, personal notes, and secrets out of shared agent files.

## 3. Start Each Agent Session

Agents begin from the stable branch and create a scoped branch:

```bash
git checkout main
git pull --ff-only
git checkout -b codex/YYYY-MM-DD-short-scope
```

Use the right prefix for the agent:

```text
codex/
claude/
cursor/
aider/
```

## 4. Continue Work From Another Agent

Before editing, gather:

```bash
git status --short --branch
git log --oneline main..HEAD
git diff main...HEAD --stat
git diff main...HEAD --name-only
```

Read the top entry of `SESSIONS.md`, then inspect only the files relevant to the task.

## 5. Choose A Handoff Mode

Use chat handoff when work continues in a new chat on the same branch:

- Do not update `SESSIONS.md`.
- Do not push.
- Include branch, HEAD, worktree state, commits, changed files, tests, open items, and exact next steps.
- Make the handoff self-contained so it can be pasted alone into a new chat.

Use full handoff when work is ready for human review:

- Commit remaining intentional work.
- Add one entry to the top of `SESSIONS.md`.
- Keep only the latest 4 full entries active.
- Move older entries to `SESSIONS_ARCHIVE.md`.
- Commit the session-log update separately.
- Push the branch.
- Print merge commands for the human reviewer.
