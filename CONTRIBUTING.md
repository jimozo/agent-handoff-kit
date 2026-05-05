# Contributing

Thanks for improving `agent-handoff-kit`.

## Project Principles

- Markdown-first.
- Dependency-free.
- Agent-installable without human copy/paste.
- Compatible with existing project instruction files.
- No private paths, personal names, secrets, or project-specific details in reusable content.
- Conservative defaults over clever automation.

## Suggested Contributions

- Clearer install flows for specific agents.
- Better conflict-handling examples.
- More examples for existing `AGENTS.md`, `CLAUDE.md`, Cursor rules, or `CONTINUE.md` setups.
- Small shell improvements that remain dependency-free and idempotent.

## Development

There is no build step.

Before opening a pull request, run:

```bash
find . -name '*.md' -print
sh -n scripts/install.sh
grep -R "TODO_PRIVATE\\|PRIVATE_PATH\\|SECRET_VALUE" .
```

The last command should not reveal private examples in public-facing files. Template placeholders are fine when they are intentional.

## Pull Request Checklist

- The change is dependency-free.
- Installer behavior is idempotent.
- Existing target repo instructions are preserved by default.
- Documentation and templates agree on defaults.
- Examples do not contain private or personal project details.
