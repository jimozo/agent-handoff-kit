#!/usr/bin/env sh
set -eu

KIT_VERSION="0.2.1"

TARGET="."
FORCE=0
UPGRADE=0
MAIN_BRANCH="main"
ACTIVE_ENTRY_LIMIT="4"
PROJECT_NAME=""
OVERVIEW_DOC="README.md"
VERIFY_DOCS="README.md"
REFERENCE_DOCS="README.md"
PROTOCOL_DOC_NAME="agent-handoff-kit.md"

usage() {
  cat <<'USAGE'
Usage: install.sh [options]

Installs agent-handoff-kit templates into a target repository and fills the
project bindings so no <PLACEHOLDER> tokens are left behind.

Options:
  --target PATH              Target repo (default: .)
  --force                    Overwrite existing files
  --upgrade                  Render an upgraded protocol doc candidate without
                             overwriting the live doc unless --force is passed
  --main-branch NAME         Default: main
  --active-entry-limit N     Default: 4
  --project-name NAME        Project name (defaults to target folder name)
  --overview-doc PATH        Reference-map: project overview (default: README.md)
  --verify-docs PATH         Reference-map: build/test docs (default: README.md)
  --reference-docs PATH      Reference-map: technical notes (default: README.md)
  --protocol-doc-name NAME   Installed protocol filename under docs/
                             (default: agent-handoff-kit.md)
  -h, --help                 Show this help

Existing files are skipped unless --force is provided. Upgrade mode writes a
candidate file by default.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --force) FORCE=1; shift ;;
    --upgrade) UPGRADE=1; shift ;;
    --main-branch) MAIN_BRANCH="$2"; shift 2 ;;
    --active-entry-limit) ACTIVE_ENTRY_LIMIT="$2"; shift 2 ;;
    --project-name) PROJECT_NAME="$2"; shift 2 ;;
    --overview-doc) OVERVIEW_DOC="$2"; shift 2 ;;
    --verify-docs) VERIFY_DOCS="$2"; shift 2 ;;
    --reference-docs) REFERENCE_DOCS="$2"; shift 2 ;;
    --protocol-doc-name) PROTOCOL_DOC_NAME="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
KIT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TEMPLATE_DIR="$KIT_DIR/templates"

if [ ! -d "$TARGET" ]; then
  echo "Target does not exist: $TARGET" >&2
  exit 1
fi

# Default project name to the target repo folder name if not supplied.
if [ -z "$PROJECT_NAME" ]; then
  PROJECT_NAME=$(CDPATH= cd -- "$TARGET" && basename -- "$(pwd)")
fi

INSTALL_DATE=$(date +%Y-%m-%d)
STAMP="<!-- agent-handoff-kit v$KIT_VERSION - installed $INSTALL_DATE - single source of truth; do not fork rules into another live doc -->"

mkdir -p "$TARGET/docs"

created=""
skipped=""
overwritten=""

# Escape a string for safe use in a sed replacement (handles / & \).
sed_escape() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

E_PROJECT_NAME=$(sed_escape "$PROJECT_NAME")
E_MAIN_BRANCH=$(sed_escape "$MAIN_BRANCH")
E_LIMIT=$(sed_escape "$ACTIVE_ENTRY_LIMIT")
E_OVERVIEW=$(sed_escape "$OVERVIEW_DOC")
E_VERIFY=$(sed_escape "$VERIFY_DOCS")
E_REFERENCE=$(sed_escape "$REFERENCE_DOCS")
E_PROTOCOL_DOC=$(sed_escape "docs/$PROTOCOL_DOC_NAME")
E_STAMP=$(sed_escape "$STAMP")

# Render a template to an output file with all bindings filled.
render() {
  src="$1"
  out="$2"
  sed \
    -e "s/<PROJECT_NAME>/$E_PROJECT_NAME/g" \
    -e "s/<MAIN_BRANCH>/$E_MAIN_BRANCH/g" \
    -e "s/<ACTIVE_ENTRY_LIMIT>/$E_LIMIT/g" \
    -e "s/<PROJECT_OVERVIEW_DOC>/$E_OVERVIEW/g" \
    -e "s/<PROJECT_VERIFY_DOCS>/$E_VERIFY/g" \
    -e "s/<PROJECT_REFERENCE_DOCS>/$E_REFERENCE/g" \
    -e "s/docs\/agent-handoff-kit\.md/$E_PROTOCOL_DOC/g" \
    -e "s/<!-- agent-handoff-kit: version stamp added by installer -->/$E_STAMP/g" \
    "$src" > "$out"
}

install_template() {
  src="$1"
  dest="$2"
  tmp="$dest.tmp.agent-handoff-kit"

  render "$src" "$tmp"

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

PROTOCOL_DEST="$TARGET/docs/$PROTOCOL_DOC_NAME"

if [ "$UPGRADE" -eq 1 ]; then
  # Upgrade mode is non-destructive by default because the installed protocol
  # doc is the repo-specific source of truth. Generate a candidate for review;
  # only replace the live doc when the caller also passes --force.
  candidate="$PROTOCOL_DEST.upgrade-agent-handoff-kit"
  tmp="$PROTOCOL_DEST.tmp.agent-handoff-kit"
  render "$TEMPLATE_DIR/docs-agent-handoff-kit.md" "$tmp"

  if [ "$FORCE" -eq 1 ]; then
    mv "$tmp" "$PROTOCOL_DEST"
    rm -f "$candidate"
    echo "agent-handoff-kit upgrade complete (v$KIT_VERSION)."
    echo "Refreshed: $PROTOCOL_DEST"
    echo "AGENTS.md, CLAUDE.md, CONTINUE.md, and session logs were left untouched."
  elif [ -f "$PROTOCOL_DEST" ] && cmp -s "$tmp" "$PROTOCOL_DEST"; then
    rm -f "$tmp" "$candidate"
    echo "agent-handoff-kit upgrade complete (v$KIT_VERSION)."
    echo "No protocol changes needed: $PROTOCOL_DEST is already current."
    echo "AGENTS.md, CLAUDE.md, CONTINUE.md, and session logs were left untouched."
  else
    mv "$tmp" "$candidate"
    echo "agent-handoff-kit upgrade candidate generated (v$KIT_VERSION)."
    echo "Candidate: $candidate"
    echo "Live doc left unchanged: $PROTOCOL_DEST"
    echo "Review/merge repo-specific rules manually, or re-run with --upgrade --force to replace the live doc."
    echo "AGENTS.md, CLAUDE.md, CONTINUE.md, and session logs were left untouched."
  fi
else
  install_template "$TEMPLATE_DIR/AGENTS.md" "$TARGET/AGENTS.md"
  install_template "$TEMPLATE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
  install_template "$TEMPLATE_DIR/SESSIONS.md" "$TARGET/SESSIONS.md"
  install_template "$TEMPLATE_DIR/SESSIONS_ARCHIVE.md" "$TARGET/SESSIONS_ARCHIVE.md"
  install_template "$TEMPLATE_DIR/CONTINUE.md" "$TARGET/CONTINUE.md"
  install_template "$TEMPLATE_DIR/docs-agent-handoff-kit.md" "$PROTOCOL_DEST"

  echo "agent-handoff-kit install complete (v$KIT_VERSION)."
  [ -n "$created" ] && echo "Created:$created"
  [ -n "$overwritten" ] && echo "Overwritten:$overwritten"
  [ -n "$skipped" ] && echo "Skipped:$skipped"
fi

# Post-install: scan installed files for leftover ALL-CAPS binding placeholders.
echo
leftover=""
for f in "$TARGET/AGENTS.md" "$TARGET/CLAUDE.md" "$PROTOCOL_DEST" "$TARGET/CONTINUE.md" "$PROTOCOL_DEST.upgrade-agent-handoff-kit"; do
  [ -f "$f" ] || continue
  hits=$(grep -nE '<[A-Z][A-Z_]+>' "$f" || true)
  if [ -n "$hits" ]; then
    leftover="$leftover
  $f:
$hits"
  fi
done

if [ -n "$leftover" ]; then
  echo "WARNING: unfilled binding placeholders remain:$leftover"
  echo
  echo "Pass the matching --flag (see --help) and re-run with --force, or edit by hand."
else
  echo "No unfilled binding placeholders. Good to go."
fi

echo
echo "Next steps:"
echo "  1. Review the Reference Map links in AGENTS.md / CLAUDE.md (defaulted to README.md)."
echo "  2. If AGENTS.md or CLAUDE.md already existed, merge snippets manually instead of replacing project rules."
echo "  3. If upgrade mode produced a .upgrade-agent-handoff-kit file, manually merge it into the live protocol doc or delete it."
echo "  4. Run: scripts/validate.sh --target $TARGET"
echo "  5. Run: git status --short --branch"
