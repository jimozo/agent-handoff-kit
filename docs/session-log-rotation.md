# Session Log Rotation

`SESSIONS.md` is intentionally small. It is a startup surface, not a complete project history.

## Default Limit

Keep the latest 4 full entries in `SESSIONS.md`.

Move older entries to `SESSIONS_ARCHIVE.md`, newest archived entry first.

## Rotation Rules

- Rotate only during full handoff.
- Preserve entries verbatim.
- Keep entries newest-first.
- Do not summarize older entries when archiving.
- Do not delete another agent's entry.
- Do not read the archive during normal session startup.

## Example

Before full handoff, `SESSIONS.md` has 4 entries.

During full handoff:

1. Add the new entry to the top.
2. `SESSIONS.md` now has 5 entries.
3. Move the oldest entry to the top of `SESSIONS_ARCHIVE.md`.
4. Commit both files together as the session-log update.

## Why This Works

New agents get recent context quickly. Older history remains available for regressions, disputed decisions, or archaeology without becoming default context for every chat.
