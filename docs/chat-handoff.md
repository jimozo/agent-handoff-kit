# Chat Handoff

Chat handoff is for continuing work in a new agent chat on the same branch.

Use it when:

- The conversation is getting long.
- Another agent chat should continue the same branch.
- Work is not ready for human review.
- You need a compact continuation prompt without changing repo history.

## Rules

Do not:

- Update `SESSIONS.md`
- Update `SESSIONS_ARCHIVE.md`
- Push
- Print merge commands

Do:

- Report current branch and HEAD.
- Report clean or dirty worktree state.
- List commits already made on the branch.
- List changed files and why they matter.
- List tests/checks run.
- List open items.
- Give exact next steps.
- Name any files intentionally left uncommitted.

## Gather

```bash
git status --short --branch
git log --oneline main..HEAD
git diff main...HEAD --stat
```

Use the project main branch if it is not `main`.

## Output Template

```markdown
# Chat Handoff - <PROJECT_NAME>

Branch: `<branch-name>`
HEAD: `<short hash> <subject>`
Worktree: clean/dirty

Commits:
- `<short hash>` <subject>

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

Prompt for next chat:
Continue work in this repository on branch `<branch-name>`. Read the project startup instructions, the top of `SESSIONS.md`, and relevant project reference sections. Do not restart strategy. First inspect `git status --short --branch`, `git log --oneline main..HEAD`, and `git diff main...HEAD --stat`, then continue from the Next steps above.
```
