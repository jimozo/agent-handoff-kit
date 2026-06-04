#!/usr/bin/env sh
set -eu

# handoff.sh - gather git facts and print a pre-filled handoff block.
# Modes: chat (same tool), switch (cross-tool relay), full (review/merge).

TARGET="."
MODE="chat"
MAIN_BRANCH=""
PROJECT_NAME=""
ALLOW_DIRTY_SWITCH=0

usage() {
  cat <<'USAGE'
Usage: handoff.sh [--mode chat|switch|full] [options]

Options:
  --mode MODE          chat (default), switch, or full
  --target PATH        Repo (default: .)
  --main-branch NAME   Base branch for diffs (default: auto-detect, then main)
  --project-name NAME  Default: repo folder name
  --allow-dirty        Allow --mode switch to print a relay note on a dirty tree
  -h, --help           Show this help

Prints a pre-filled handoff block to stdout. Fill the <...> blanks before use.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --mode) MODE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --main-branch) MAIN_BRANCH="$2"; shift 2 ;;
    --project-name) PROJECT_NAME="$2"; shift 2 ;;
    --allow-dirty) ALLOW_DIRTY_SWITCH=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

case "$MODE" in
  chat|switch|full) ;;
  *) echo "Invalid --mode: $MODE (use chat|switch|full)" >&2; exit 1 ;;
esac

if ! git -C "$TARGET" rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not a git repository: $TARGET" >&2
  exit 1
fi

g() { git -C "$TARGET" "$@"; }

REPO_ROOT=$(g rev-parse --show-toplevel)
[ -n "$PROJECT_NAME" ] || PROJECT_NAME=$(basename -- "$REPO_ROOT")

# Auto-detect base branch if not given: origin/HEAD, else main, else master.
if [ -z "$MAIN_BRANCH" ]; then
  MAIN_BRANCH=$(g symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##' || true)
  if [ -z "$MAIN_BRANCH" ]; then
    if g show-ref --verify --quiet refs/heads/main; then MAIN_BRANCH="main"
    elif g show-ref --verify --quiet refs/heads/master; then MAIN_BRANCH="master"
    else MAIN_BRANCH="main"
    fi
  fi
fi

BRANCH=$(g rev-parse --abbrev-ref HEAD)
HEAD_LINE=$(g log -1 --format='%h %s')
if [ -n "$(g status --porcelain)" ]; then WORKTREE="dirty"; else WORKTREE="clean"; fi
COMMITS=$(g log --oneline "$MAIN_BRANCH..HEAD" 2>/dev/null || true)
[ -n "$COMMITS" ] || COMMITS="(none ahead of $MAIN_BRANCH)"
DIFFSTAT=$(g diff "$MAIN_BRANCH...HEAD" --stat 2>/dev/null || true)
[ -n "$DIFFSTAT" ] || DIFFSTAT="(no committed diff vs $MAIN_BRANCH)"

if [ "$MODE" = "switch" ] && [ "$WORKTREE" = "dirty" ] && [ "$ALLOW_DIRTY_SWITCH" -ne 1 ]; then
  echo "Refusing agent-switch handoff on a dirty worktree." >&2
  echo "Commit a checkpoint first, or re-run with --allow-dirty and list the intentionally dirty paths in CONTINUE.md." >&2
  echo >&2
  g status --short --branch >&2
  exit 1
fi

print_chat() {
  cat <<EOF
# Chat Handoff - $PROJECT_NAME

Branch: \`$BRANCH\`
HEAD: \`$HEAD_LINE\`
Worktree: $WORKTREE

Commits ($MAIN_BRANCH..HEAD):
$COMMITS

Changed files:
$DIFFSTAT

Completed:
- <one-sentence summary>

Tests/checks:
- <command/result>

Open:
- <blocker/risk or "none">

Next:
1. <immediate next step>

Intentionally uncommitted:
- <path or "none">

Continuation prompt:
Continue work on branch \`$BRANCH\` (HEAD \`$HEAD_LINE\`, worktree $WORKTREE).
Read the project startup file and the top of SESSIONS.md first. Do not restart strategy.
Next: <immediate next step>.
EOF
}

print_switch() {
  if [ "$WORKTREE" = "dirty" ]; then
    head_note="dirty override used; list intentionally dirty paths below"
  else
    head_note="WIP checkpoint committed"
  fi
  cat <<EOF
# CONTINUE - $PROJECT_NAME

From: <agent> -> To: <agent>
Branch: \`$BRANCH\`
HEAD: \`$HEAD_LINE\`  ($head_note)
Worktree: $WORKTREE

## Focus
- <the one active task>

## Immediate Next Step
1. <the next action for the incoming tool>

## Do Not Redo
- <work already done; do not revert or re-derive>

## Intentionally Dirty
- <path or "none">

Incoming tool reads first: <AGENTS.md for Codex / CLAUDE.md for Claude>, then this file.
EOF
}

print_full() {
  TODAY=$(date +%Y-%m-%d)
  cat <<EOF
## $TODAY - <Agent> - <one-line scope>
**Branch:** $BRANCH
**Merged:** pending (human merges after review)
**Scope:** <what was done and why>
**Changes:**
$DIFFSTAT
**Commits:** $COMMITS
**Tests:** <what was tested, or "none - gap">
**Open:** <anything unresolved or known broken>
**Next:** <which agent or human should do what next>

---
Human merge block:

SESSION DONE - run these commands in terminal:

cd $REPO_ROOT
git checkout $MAIN_BRANCH
git pull --ff-only
git merge --no-ff $BRANCH
git push origin $MAIN_BRANCH

Then open SESSIONS.md to see what's next.
EOF
}

case "$MODE" in
  chat) print_chat ;;
  switch) print_switch ;;
  full) print_full ;;
esac
