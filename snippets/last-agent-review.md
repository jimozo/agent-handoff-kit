# Last-Agent Review Snippet

Before continuing another agent's branch:

```bash
git status --short --branch
git log --oneline main..HEAD
git diff main...HEAD --stat
git diff main...HEAD --name-only
```

Then read:

- Top entry in `SESSIONS.md`
- Commit subjects on the branch
- Files relevant to the current task
- Test/check notes from the previous handoff

Avoid rereading the full archive unless the current issue depends on older history.
