# agent-handoff-kit

A Git-native handoff protocol for teams using multiple coding agents in the same project.

`agent-handoff-kit` gives Codex, Claude Code, Cursor, Aider, and other coding agents a shared way to start work, review the last agent, hand off context, rotate session logs, and leave branches ready for human review.

It complements existing project docs. It gives root instruction files a concise every-session shape and points agents to deeper docs only when the task needs them.

## What This Adds

- A small active session log agents read first: `SESSIONS.md`
- An archive for older entries: `SESSIONS_ARCHIVE.md`
- Branch-per-agent workflow with default prefixes: `codex/`, `claude/`, `cursor/`, `aider/`
- Two handoff modes: chat handoff and full handoff
- Last-agent review commands for quickly continuing another agent's branch
- Conflict rules for concurrent agent branches
- Concise standalone `AGENTS.md` and `CLAUDE.md` templates
- Agent-installable instructions in `INSTALL_FOR_AGENTS.md`
- Optional dependency-free installer script

## When To Use It

Use this kit when:

- More than one coding agent touches the same repository.
- Agent sessions often continue across chats.
- A human wants to review and merge agent branches into the stable branch.
- Session notes are getting too long for every new agent to reread.

You may not need it for a single-agent side project or a repo where agents never commit work.

## Repository Layout

```text
agent-handoff-kit/
  README.md
  QUICKSTART.md
  INSTALL_FOR_AGENTS.md
  LICENSE
  CONTRIBUTING.md
  CODE_OF_CONDUCT.md
  SECURITY.md
  CHANGELOG.md
  templates/
  snippets/
  examples/
  docs/
  scripts/
  .github/
```

## Install

Fast path:

```bash
git clone https://github.com/YOUR_ORG/agent-handoff-kit.git
cd your-project
../agent-handoff-kit/scripts/install.sh --target .
```

Agent path:

> Install `agent-handoff-kit` in this repo. Follow `INSTALL_FOR_AGENTS.md`. Preserve existing project-specific agent instructions and do not overwrite files unless the install guide explicitly says it is safe.

See [QUICKSTART.md](./QUICKSTART.md) and [INSTALL_FOR_AGENTS.md](./INSTALL_FOR_AGENTS.md).

## Core Model

Each agent works on its own branch:

```text
codex/YYYY-MM-DD-short-scope
claude/YYYY-MM-DD-short-scope
cursor/YYYY-MM-DD-short-scope
aider/YYYY-MM-DD-short-scope
```

`SESSIONS.md` keeps only the latest 4 full handoff entries by default. Older entries move to `SESSIONS_ARCHIVE.md`, newest first.

The human owner merges reviewed branches into the main branch.

## Documentation

- [QUICKSTART.md](./QUICKSTART.md): install and use the kit in a few minutes
- [INSTALL_FOR_AGENTS.md](./INSTALL_FOR_AGENTS.md): exact instructions an agent can follow
- [docs/protocol.md](./docs/protocol.md): full handoff protocol
- [docs/last-agent-review.md](./docs/last-agent-review.md): review previous agent work
- [docs/chat-handoff.md](./docs/chat-handoff.md): continue work in a new chat
- [docs/full-handoff.md](./docs/full-handoff.md): prepare a branch for review and merge
- [docs/session-log-rotation.md](./docs/session-log-rotation.md): active log and archive rules
- [docs/conflict-handling.md](./docs/conflict-handling.md): merge conflict rules
- [docs/comparison.md](./docs/comparison.md): comparison to `AGENTS.md`, `CLAUDE.md`, Cursor rules, and `CONTINUE.md`

## License

MIT. See [LICENSE](./LICENSE).
