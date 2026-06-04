# Changelog

All notable changes to this project will be documented here.

This project follows a lightweight Keep a Changelog style and uses semantic versioning once releases begin.

## Unreleased

## v0.2.0 - 2026-06-04

- Added a third handoff mode: **agent-switch handoff** for continuing the same branch in a different tool (for example Claude to Codex) mid-work, with a `CONTINUE.md` relay note. New `docs/agent-switch-handoff.md`; `CONTINUE.md` template restructured as the relay surface.
- Reworked the installer to fill **all** bindings (not just main branch and entry limit): added `--project-name`, `--overview-doc`, `--verify-docs`, `--reference-docs`, and `--protocol-doc-name`; auto-detects the project name; stamps the installed protocol doc with a version/provenance line; and scans for leftover `<UPPER_CASE>` placeholders after install.
- Consolidated scattered placeholders into a single `## Project Bindings` table at the top of the protocol doc, with a single-source-of-truth header.
- Added `scripts/validate.sh` (doctor): flags unfilled placeholders, oversized `SESSIONS.md`, incomplete session entries, and a dirty main branch.
- Added `scripts/handoff.sh`: gathers git facts and prints a pre-filled block for chat, switch, or full handoff.
- Added an optional **Agent Ownership Map** convention (who edits which paths).
- Added `--upgrade` to refresh the installed protocol doc, plus guidance for vendoring the kit in-repo as read-only upstream.

## v0.1.2 - 2026-05-05

- Changed `AGENTS.md` and `CLAUDE.md` templates to concise standalone operating guides.
- Documented that project facts belong in task-relevant docs rather than root instruction files.
- Updated continuation prompts and install guidance to load broad context only when relevant.

## v0.1.0 - 2026-05-05

- Initial public scaffold.
- Added agent-installable instructions.
- Added dependency-free installer script.
- Added templates for `AGENTS.md`, `CLAUDE.md`, `SESSIONS.md`, `SESSIONS_ARCHIVE.md`, and `CONTINUE.md`.
- Added docs for chat handoff, full handoff, last-agent review, session log rotation, conflict handling, and comparison to other agent instruction files.
