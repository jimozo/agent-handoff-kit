# Install For Agents

These instructions are written for coding agents. Follow them when a user says:

> Install `agent-handoff-kit` in this repo.

## Goal

Install a lightweight, dependency-free multi-agent handoff protocol into the target repository without removing or replacing project-specific instructions.

## Rules

- Preserve existing `AGENTS.md`, `CLAUDE.md`, Cursor rules, `CONTINUE.md`, and other agent files.
- Do not overwrite files unless the user explicitly asks or you are using `scripts/install.sh --force`.
- Do not include personal names, private paths, secrets, or machine-specific details in installed public-facing files.
- Keep the active session log limit at `4` unless the user asks for a different value.
- Use branch prefixes `codex/`, `claude/`, `cursor/`, and `aider/` unless the project already has a stronger convention.
- Leave the project dependency-free. Do not add package managers, build tools, or generated lockfiles.

## Preferred Install

From inside the target repository:

```bash
../agent-handoff-kit/scripts/install.sh --target .
```

If the kit is checked out in the target repository as a subdirectory:

```bash
./agent-handoff-kit/scripts/install.sh --target .
```

## Manual Install

If the script is unavailable, copy these files from `templates/` into the target repo:

```text
templates/AGENTS.md              -> AGENTS.md, if missing
templates/CLAUDE.md              -> CLAUDE.md, if missing
templates/SESSIONS.md            -> SESSIONS.md, if missing
templates/SESSIONS_ARCHIVE.md    -> SESSIONS_ARCHIVE.md, if missing
templates/CONTINUE.md            -> CONTINUE.md, if missing or desired
templates/docs-agent-handoff-kit.md -> docs/agent-handoff-kit.md
```

If the target repo already has `AGENTS.md` or `CLAUDE.md`, do not replace it. Instead:

1. Read the existing file.
2. Add a short pointer to `docs/agent-handoff-kit.md`.
3. Add the relevant snippet from `snippets/` if it fits the existing style.
4. Keep project-specific rules intact.

## After Install

Fill placeholders in the installed files:

- `<PROJECT_NAME>`
- `<MAIN_BRANCH>`
- `<ACTIVE_ENTRY_LIMIT>`
- `<PRIMARY_COMMANDS>`
- `<PROJECT_RULES>`
- `<DO_NOT_TOUCH_PATHS>`

Then run:

```bash
git status --short --branch
```

Report:

- Files created
- Files skipped because they already existed
- Placeholders still needing project-specific values
- Any existing agent files that should be manually merged

## Do Not

- Do not rewrite the project's architecture notes.
- Do not move older project-specific handoff logs unless the user asked for migration.
- Do not push, commit, or open a pull request unless the user asked for that as part of the install.
- Do not add private local paths or user names to installed templates.
