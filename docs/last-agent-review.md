# Last-Agent Review

Use last-agent review when continuing work that another agent started.

## Fast Commands

```bash
git status --short --branch
git log --oneline main..HEAD
git diff main...HEAD --stat
git diff main...HEAD --name-only
```

If the main branch is not `main`, substitute the project default branch.

For one changed file:

```bash
git diff main...HEAD -- path/to/file
```

## Read Order

1. Top entry in `SESSIONS.md`
2. Branch commit subjects
3. Changed file list
4. Relevant changed files
5. Test notes from the last handoff

Only read `SESSIONS_ARCHIVE.md` when older decisions are necessary.

## What To Look For

- Work already completed
- Files intentionally left dirty
- Tests already run
- Open risks
- Pending review comments
- Areas the previous agent explicitly avoided

## What To Avoid

- Restarting the strategy from scratch
- Reverting another agent's work because it is unfamiliar
- Reformatting unrelated files
- Sweeping unrelated changed files into a commit
- Reading the full archive by habit
