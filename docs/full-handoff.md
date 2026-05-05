# Full Handoff

Full handoff is for preparing an agent branch for human review and merge.

Use it when:

- The requested work is complete enough for review.
- Remaining changes are intentionally committed.
- Open risks are known and written down.
- The human owner should merge later.

## Rules

- Commit work in logical chunks.
- Stage intentional files only.
- Add one new session entry at the top of `SESSIONS.md`.
- Keep only the latest 4 full entries in `SESSIONS.md` by default.
- Move older entries to `SESSIONS_ARCHIVE.md`.
- Commit the session-log update separately.
- Push the branch.
- Print merge commands for the human owner.

## Steps

```bash
git status --short --branch
git add <intentional files only>
git commit -m "type(scope): short description"
```

Skip this commit if there are no remaining uncommitted work changes.

Update session logs:

```bash
git add SESSIONS.md SESSIONS_ARCHIVE.md
git commit -m "chore: session log - <one-line scope>"
```

Push:

```bash
git push origin <branch-name>
```

## Session Entry

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
**Next:** <which agent or human should do what next>
```

## Human Merge Block

```text
SESSION DONE - run these commands in terminal:

cd <repo-root>
git checkout main
git pull --ff-only
git merge --no-ff <branch-name>
git push origin main

Then open SESSIONS.md to see what's next.
```

If the project main branch is not `main`, substitute the project default branch.
