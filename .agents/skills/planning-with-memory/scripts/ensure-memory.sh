#!/usr/bin/env bash
# Ensure project memory exists. Knowledge layer is always created.
# Charter is optional (created only with --with-charter).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT="${PM_PLAN_ROOT:-${PWF_PLAN_ROOT:-$(pwd)}}"
MEM="$ROOT/.memory"
TPL="$SKILL_DIR/templates"
WITH_CHARTER=0

for arg in "$@"; do
  case "$arg" in
    --with-charter) WITH_CHARTER=1 ;;
  esac
done

mkdir -p "$MEM"

copy_if_missing() {
  local name="$1"
  if [[ ! -f "$MEM/$name" ]]; then
    cp "$TPL/$name" "$MEM/$name"
    echo "[planning-with-memory] created .memory/$name"
  fi
}

copy_if_missing "KNOWLEDGE.md"
copy_if_missing "TASK_INDEX.md"
copy_if_missing "TASK_LOG.md"

if [[ "$WITH_CHARTER" -eq 1 ]]; then
  copy_if_missing "CHARTER.md"
fi

echo "[planning-with-memory] memory ready at $MEM"
