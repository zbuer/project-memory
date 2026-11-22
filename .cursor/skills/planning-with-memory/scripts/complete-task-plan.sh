#!/usr/bin/env bash
# Append TASK_INDEX + TASK_LOG entries for the current task-plan, then optionally archive slug.
# Usage: complete-task-plan.sh [--status complete|cancelled|partial] [--title "..."]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="${PM_PLAN_ROOT:-${PWF_PLAN_ROOT:-$(pwd)}}"
"$SCRIPT_DIR/ensure-memory.sh"

STATUS="complete"
TITLE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --status)
      STATUS="${2:-complete}"
      shift 2
      ;;
    --title)
      TITLE="${2:-}"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

PLAN_DIR="$("$SCRIPT_DIR/resolve-plan-dir.sh")"
PLAN="$PLAN_DIR/task_plan.md"
MEM="$ROOT/.memory"
DATE="$(date +%Y-%m-%d)"

if [[ ! -f "$PLAN" ]]; then
  echo "[planning-with-memory] no task_plan.md to complete" >&2
  exit 1
fi

if [[ -z "$TITLE" ]]; then
  TITLE="$(grep -E '^# Task Plan:' "$PLAN" | head -1 | sed 's/^# Task Plan:[[:space:]]*//' || true)"
  [[ -z "$TITLE" ]] && TITLE="$(basename "$PLAN_DIR")"
fi

# slug for anchor
ANCHOR="$(echo "$DATE-$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/^-{0,}//')"
ANCHOR="$(echo "$ANCHOR" | cut -c1-60)"

GOAL="$(awk '/^## Goal/{flag=1; next} /^## /{flag=0} flag && NF{print; exit}' "$PLAN" || true)"
GOAL="$(echo "$GOAL" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

REL_PLAN="${PLAN#"$ROOT"/}"

# Index row (skip if same date+title already present)
if grep -q "| $DATE | .* | $TITLE |" "$MEM/TASK_INDEX.md" 2>/dev/null; then
  echo "[planning-with-memory] index already has this title for $DATE — updating log only skipped if duplicate"
else
  # Remove template example row if still present
  if grep -q '_(example — delete when real entries exist)_' "$MEM/TASK_INDEX.md"; then
    grep -v '_(example — delete when real entries exist)_' "$MEM/TASK_INDEX.md" > "$MEM/TASK_INDEX.md.tmp"
    mv "$MEM/TASK_INDEX.md.tmp" "$MEM/TASK_INDEX.md"
  fi
  echo "| $DATE | $STATUS | $TITLE | #$ANCHOR |" >> "$MEM/TASK_INDEX.md"
fi

{
  echo ""
  echo "## $DATE — $TITLE {#$ANCHOR}"
  echo ""
  echo "- **状态:** $STATUS"
  echo "- **目标:** ${GOAL:-"(see task_plan)"}"
  echo "- **摘要:** （请 Agent 或用户补全 5–15 行：做了什么、结果如何）"
  echo "- **关键沉淀:** （可选）"
  echo "- **计划路径:** $REL_PLAN"
  echo ""
} >> "$MEM/TASK_LOG.md"

echo "[planning-with-memory] logged to TASK_INDEX.md and TASK_LOG.md (#$ANCHOR)"
echo "[planning-with-memory] Capture durable findings into .memory/KNOWLEDGE.md before overwriting the task-plan."
