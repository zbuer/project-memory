#!/usr/bin/env bash
# Check phase completion in task_plan.md (### Phase headings + Status).
# Exit 0 if complete or no plan; exit 2 if incomplete.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLAN_DIR="$("$SCRIPT_DIR/resolve-plan-dir.sh")"
PLAN="$PLAN_DIR/task_plan.md"

if [[ ! -f "$PLAN" ]]; then
  echo "no_plan"
  exit 0
fi

# Count ### Phase / ### 阶段 headers and complete statuses in those sections — simple scan
total=$(grep -E -c '^### (Phase|阶段) ' "$PLAN" || true)
complete=$(grep -E -c '\*\*Status:\*\* complete|\*\*状态：\*\* complete|\*\*状态:\*\* complete' "$PLAN" || true)
# Also accept [complete] style
complete2=$(grep -E -c '\[complete\]' "$PLAN" || true)
# Prefer Status lines; if both formats used, take max
if [[ "$complete2" -gt "$complete" ]]; then
  complete="$complete2"
fi

echo "phases_total=$total phases_complete=$complete plan=$PLAN"

if [[ "$total" -eq 0 ]]; then
  echo "no_phases"
  exit 0
fi

if [[ "$complete" -ge "$total" ]]; then
  echo "complete"
  exit 0
fi

echo "incomplete"
exit 2
