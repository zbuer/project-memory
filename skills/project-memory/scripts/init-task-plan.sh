#!/usr/bin/env bash
# Initialize task-plan files (PWF-compatible layout) and ensure project memory.
# Usage:
#   init-task-plan.sh ["Title"]
#   init-task-plan.sh --slug my-feature ["Title"]
#   init-task-plan.sh --force   # overwrite existing root trio (after warning)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT="${PM_PLAN_ROOT:-${PWF_PLAN_ROOT:-$(pwd)}}"
TPL="$SKILL_DIR/templates"
SLUG=""
FORCE=0
TITLE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug)
      SLUG="${2:-}"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --with-charter)
      "$SCRIPT_DIR/ensure-memory.sh" --with-charter
      shift
      ;;
    *)
      TITLE="$1"
      shift
      ;;
  esac
done

"$SCRIPT_DIR/ensure-memory.sh"

PLAN_DIR="$ROOT"
if [[ -n "$SLUG" ]]; then
  if [[ ! "$SLUG" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
    echo "[project-memory] invalid --slug" >&2
    exit 1
  fi
  # Prefer dated slug if user passed bare name without date
  if [[ ! "$SLUG" =~ ^[0-9]{4}- ]]; then
    SLUG="$(date +%Y-%m-%d)-$SLUG"
  fi
  PLAN_DIR="$ROOT/.planning/$SLUG"
  mkdir -p "$PLAN_DIR"
  echo "$SLUG" > "$ROOT/.planning/.active_plan"
fi

install_file() {
  local src="$1" dest="$2"
  if [[ -f "$dest" && "$FORCE" -ne 1 ]]; then
    echo "[project-memory] keep existing $(basename "$dest") (use --force to overwrite)"
    return
  fi
  cp "$src" "$dest"
  if [[ -n "$TITLE" && "$(basename "$dest")" == "task_plan.md" ]]; then
    # macOS sed
    sed -i '' "s/\[Brief Description\]/$TITLE/" "$dest" 2>/dev/null \
      || sed -i "s/\[Brief Description\]/$TITLE/" "$dest"
  fi
  echo "[project-memory] wrote $dest"
}

install_file "$TPL/task_plan.md" "$PLAN_DIR/task_plan.md"
install_file "$TPL/findings.md" "$PLAN_DIR/findings.md"
install_file "$TPL/progress.md" "$PLAN_DIR/progress.md"

if [[ -n "$SLUG" ]]; then
  echo "[project-memory] PLAN_ID=$SLUG"
  echo "[project-memory] plan dir=$PLAN_DIR"
else
  echo "[project-memory] plan dir=$PLAN_DIR (root task-plan)"
fi
echo "[project-memory] Reminder: /task-plan is NOT Cursor Plan mode."
