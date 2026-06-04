# Agent-Switch Handoff

Agent-switch handoff continues the **same branch** in a **different tool** (for example Claude Code to Codex) mid-work, before the branch is ready for human review.

It sits between the other two modes:

- Chat handoff assumes the same tool and can lean on in-memory continuity. A different tool starts cold, so that is not safe here.
- Full handoff commits, updates `SESSIONS.md`, pushes, and prints a merge block. That is too much when you are not merging yet.

Agent-switch handoff is the middle path: commit a checkpoint, leave a durable branch-local relay note, switch tools, keep going.

## When To Use

- You want to move work from one coding agent to another without merging.
- The branch is mid-task, not review-ready.
- The incoming tool needs to know exactly where to pick up and what not to redo.

## Rules

Do:

- Commit work in progress so the tree is clean and readable:
  ```bash
  git status --short --branch
  git add <intentional files only>
  git commit -m "chore(handoff): switch checkpoint"
  ```
  A `wip(scope): ...` subject is also fine. The point is that the next tool reads committed state, not uncommitted memory.
- Write the relay note to `CONTINUE.md` (template below).
- Name which startup file the incoming tool reads first: Codex reads `AGENTS.md`, Claude reads `CLAUDE.md`.
- If the project defines an Agent Ownership Map, point the incoming tool at the paths it owns.

Do not:

- Update `SESSIONS.md` or `SESSIONS_ARCHIVE.md`.
- Push or print a human merge block, unless you also want a full handoff.
- Rotate session logs.
- Leave a dirty worktree unless the dirty files are intentionally out of scope and explicitly listed in `CONTINUE.md`.

## Gather

```bash
git status --short --branch
git log --oneline <MAIN_BRANCH>..HEAD
git diff <MAIN_BRANCH>...HEAD --stat
```

`scripts/handoff.sh --mode switch` gathers these and prints a pre-filled relay note. It refuses a dirty worktree by default; use `--allow-dirty` only for deliberate out-of-scope dirty files and list each one in the relay note.

## Relay Note (`CONTINUE.md`)

```markdown
# CONTINUE - <PROJECT_NAME>

From: <agent> -> To: <agent>
Branch: `<branch-name>`
HEAD: `<short hash> <subject>`  (WIP checkpoint committed)
Worktree: clean/dirty

## Focus
- <the one active task>

## Immediate Next Step
1. <the next action for the incoming tool>

## Do Not Redo
- <work already done; do not revert or re-derive>

## Intentionally Dirty
- <path or "none">

Incoming tool reads first: <AGENTS.md for Codex / CLAUDE.md for Claude>, then this file.
```

## After The Switch

The incoming tool should:

1. Read its own startup file (`AGENTS.md` or `CLAUDE.md`), then `CONTINUE.md`.
2. Confirm branch and HEAD match the relay note.
3. Continue from the next step; do not redo listed work.
4. Clear or delete `CONTINUE.md` once consumed, so it never becomes a second stale log.

When the branch later becomes review-ready, switch to [full-handoff.md](./full-handoff.md).
