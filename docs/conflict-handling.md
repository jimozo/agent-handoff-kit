# Conflict Handling

Concurrent agent branches most often conflict in session logs. Treat those conflicts as coordination data, not ordinary prose to rewrite.

## Principles

- Preserve every session entry.
- Keep newest entries first.
- Preserve archived entries verbatim.
- Avoid duplicate archived entries.
- Do not delete another agent's work.
- Do not edit another agent's session entry except to resolve exact duplicate conflict content.

## `SESSIONS.md` Conflicts

If two branches added top entries:

1. Keep both entries.
2. Order newest first by date and time if present.
3. If dates tie, keep the merge target's order unless one entry clearly happened later.
4. Apply the active log limit after preserving both entries.

## `SESSIONS_ARCHIVE.md` Conflicts

If both branches rotated older entries:

1. Keep every archived entry exactly once.
2. Preserve each entry's text.
3. Order newest archived entry first.
4. Remove only exact duplicates created by conflict resolution.

## Code Conflicts

For ordinary code conflicts:

- Read both sides.
- Preserve intentional behavior from both branches when possible.
- Ask the human owner if the conflict reveals incompatible product decisions.
- Do not use broad resets or checkout commands unless the user explicitly requests them.

## After Resolving

Run:

```bash
git status --short --branch
git diff --check
```

Then record the conflict resolution in the next full handoff entry.
