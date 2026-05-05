# Multi-Agent Startup Snippet

This repo uses `agent-handoff-kit`.

At the start of every agent session:

1. Read the top entry in `SESSIONS.md`.
2. Read task-relevant project docs only when the work needs them.
3. Create an agent branch before editing:

```bash
git checkout main
git pull --ff-only
git checkout -b codex/YYYY-MM-DD-short-scope
```

Use the appropriate prefix for the agent: `codex/`, `claude/`, `cursor/`, or `aider/`.

Do not read `SESSIONS_ARCHIVE.md` unless older decisions or regression history are needed.
