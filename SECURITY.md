# Security

`agent-handoff-kit` is Markdown-first and dependency-free. The optional installer is a shell script that copies template files into a target repository.

## Reporting A Vulnerability

Please open a private security advisory on GitHub if available, or contact the maintainers through the repository's published security contact.

Include:

- Affected file or workflow
- Reproduction steps
- Expected behavior
- Actual behavior
- Suggested fix, if known

## Security Design

- The installer does not fetch remote code.
- The installer does not install packages.
- Existing files are skipped by default.
- `--force` is required to overwrite existing files.
- Templates are intended to avoid personal paths, secrets, and private project details.

## Sensitive Data

Do not put secrets, tokens, personal machine paths, customer names, or private project notes into reusable templates, examples, or public docs.
