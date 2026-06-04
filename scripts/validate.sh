#!/usr/bin/env sh
set -eu

# validate.sh - dependency-free doctor for an agent-handoff-kit install.
# Checks for unfilled bindings, oversized session logs, incomplete entries,
# and a dirty main branch.

TARGET="."
ACTIVE_ENTRY_LIMIT="4"
MAIN_BRANCH="main"
PROTOCOL_DOC_NAME="agent-handoff-kit.md"

usage() {
  cat <<'USAGE'
Usage: validate.sh [options]

Options:
  --target PATH              Repo to validate (default: .)
  --active-entry-limit N     Max active SESSIONS.md entries (default: 4)
  --main-branch NAME         Default: main
  --protocol-doc-name NAME   Protocol filename under docs/ (default: agent-handoff-kit.md)
  -h, --help                 Show this help

Exit code is non-zero if any hard check fails.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --active-entry-limit) ACTIVE_ENTRY_LIMIT="$2"; shift 2 ;;
    --main-branch) MAIN_BRANCH="$2"; shift 2 ;;
    --protocol-doc-name) PROTOCOL_DOC_NAME="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [ ! -d "$TARGET" ]; then
  echo "Target does not exist: $TARGET" >&2
  exit 1
fi

errors=0
warnings=0

fail() { echo "FAIL: $1"; errors=$((errors + 1)); }
warn() { echo "WARN: $1"; warnings=$((warnings + 1)); }
ok()   { echo "ok:   $1"; }

PROTOCOL_DOC="$TARGET/docs/$PROTOCOL_DOC_NAME"
SESSIONS="$TARGET/SESSIONS.md"

# 1. No leftover ALL-CAPS binding placeholders.
placeholder_hit=0
for f in "$TARGET/AGENTS.md" "$TARGET/CLAUDE.md" "$PROTOCOL_DOC" "$TARGET/CONTINUE.md"; do
  [ -f "$f" ] || continue
  hits=$(grep -nE '<[A-Z][A-Z_]+>' "$f" || true)
  if [ -n "$hits" ]; then
    placeholder_hit=1
    fail "unfilled binding placeholder(s) in $f:"
    echo "$hits" | sed 's/^/      /'
  fi
done
[ "$placeholder_hit" -eq 0 ] && ok "no unfilled binding placeholders"

# 2 + 3. SESSIONS.md size and entry completeness.
if [ -f "$SESSIONS" ]; then
  entries=$(grep -cE '^## ' "$SESSIONS" || true)
  if [ "$entries" -gt "$ACTIVE_ENTRY_LIMIT" ]; then
    fail "SESSIONS.md has $entries active entries (limit $ACTIVE_ENTRY_LIMIT); rotate older ones to SESSIONS_ARCHIVE.md"
  else
    ok "SESSIONS.md active entries: $entries (limit $ACTIVE_ENTRY_LIMIT)"
  fi

  if [ "$entries" -gt 0 ]; then
    for label in Branch Scope Changes Tests Open Next; do
      count=$(grep -cE "^\*\*$label:" "$SESSIONS" || true)
      if [ "$count" -lt "$entries" ]; then
        warn "SESSIONS.md: '$label' appears $count time(s) for $entries entr(y/ies); some entries may be missing it"
      fi
    done
  fi
else
  warn "no SESSIONS.md found at $SESSIONS"
fi

# 4. Dirty main branch.
if git -C "$TARGET" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$TARGET" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  if [ "$branch" = "$MAIN_BRANCH" ]; then
    if [ -n "$(git -C "$TARGET" status --porcelain 2>/dev/null)" ]; then
      warn "working tree is dirty on the main branch ($MAIN_BRANCH); agents should work on a branch"
    else
      ok "on $MAIN_BRANCH with a clean tree"
    fi
  else
    ok "on working branch '$branch' (not $MAIN_BRANCH)"
  fi
fi

echo
echo "validate.sh: $errors error(s), $warnings warning(s)."
[ "$errors" -eq 0 ] || exit 1
