#!/usr/bin/env sh
set -eu

TARGET="."
FORCE=0
MAIN_BRANCH="main"
ACTIVE_ENTRY_LIMIT="4"

usage() {
  cat <<'USAGE'
Usage: install.sh [--target PATH] [--force] [--main-branch NAME] [--active-entry-limit N]

Installs agent-handoff-kit templates into a target repository.

Defaults:
  --target .
  --main-branch main
  --active-entry-limit 4

Existing files are skipped unless --force is provided.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      TARGET="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --main-branch)
      MAIN_BRANCH="$2"
      shift 2
      ;;
    --active-entry-limit)
      ACTIVE_ENTRY_LIMIT="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
KIT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TEMPLATE_DIR="$KIT_DIR/templates"

if [ ! -d "$TARGET" ]; then
  echo "Target does not exist: $TARGET" >&2
  exit 1
fi

mkdir -p "$TARGET/docs"

created=""
skipped=""
overwritten=""

install_template() {
  src="$1"
  dest="$2"
  tmp="$dest.tmp.agent-handoff-kit"

  sed \
    -e "s/<MAIN_BRANCH>/$MAIN_BRANCH/g" \
    -e "s/<ACTIVE_ENTRY_LIMIT>/$ACTIVE_ENTRY_LIMIT/g" \
    "$src" > "$tmp"

  if [ -f "$dest" ] && cmp -s "$tmp" "$dest"; then
    rm -f "$tmp"
    skipped="$skipped
  $dest (already current)"
    return
  fi

  if [ -f "$dest" ] && [ "$FORCE" -ne 1 ]; then
    rm -f "$tmp"
    skipped="$skipped
  $dest (exists; use --force to overwrite)"
    return
  fi

  if [ -f "$dest" ]; then
    mv "$tmp" "$dest"
    overwritten="$overwritten
  $dest"
  else
    mv "$tmp" "$dest"
    created="$created
  $dest"
  fi
}

install_template "$TEMPLATE_DIR/AGENTS.md" "$TARGET/AGENTS.md"
install_template "$TEMPLATE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
install_template "$TEMPLATE_DIR/SESSIONS.md" "$TARGET/SESSIONS.md"
install_template "$TEMPLATE_DIR/SESSIONS_ARCHIVE.md" "$TARGET/SESSIONS_ARCHIVE.md"
install_template "$TEMPLATE_DIR/CONTINUE.md" "$TARGET/CONTINUE.md"
install_template "$TEMPLATE_DIR/docs-agent-handoff-kit.md" "$TARGET/docs/agent-handoff-kit.md"

echo "agent-handoff-kit install complete."

if [ -n "$created" ]; then
  echo "Created:$created"
fi

if [ -n "$overwritten" ]; then
  echo "Overwritten:$overwritten"
fi

if [ -n "$skipped" ]; then
  echo "Skipped:$skipped"
fi

echo
echo "Next steps:"
echo "  1. Replace placeholders such as <PROJECT_NAME>, <PROJECT_OVERVIEW_DOC>, and <PROJECT_VERIFY_DOCS>."
echo "  2. If AGENTS.md or CLAUDE.md already existed, merge snippets manually instead of replacing project rules."
echo "  3. Run: git status --short --branch"
