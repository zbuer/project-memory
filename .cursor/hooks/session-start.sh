#!/usr/bin/env bash
# Inject compact planning-with-memory context at session start (Cursor additional_context).
set -euo pipefail

ROOT="${CURSOR_PROJECT_DIR:-${PM_PLAN_ROOT:-$(pwd)}}"
cd "$ROOT" 2>/dev/null || true

SKILL=""
for c in \
  "$ROOT/.cursor/skills/planning-with-memory" \
  "$HOME/.cursor/skills/planning-with-memory"
do
  if [[ -f "$c/scripts/ensure-memory.sh" ]]; then
    SKILL="$c"
    break
  fi
done

if [[ -n "$SKILL" ]]; then
  bash "$SKILL/scripts/ensure-memory.sh" >/dev/null 2>&1 || true
fi

MEM="$ROOT/.memory"
PLAN_DIR="$ROOT"
if [[ -n "$SKILL" ]]; then
  PLAN_DIR="$(bash "$SKILL/scripts/resolve-plan-dir.sh" 2>/dev/null || echo "$ROOT")"
fi

CONTEXT="[planning-with-memory] 任务规划(task-plan)≠Cursor Plan模式。开场只注入浓缩状态；知识详情按需读取。
"

if [[ -f "$MEM/CHARTER.md" ]]; then
  PURPOSE="$(awk '/^## 目的/{flag=1; next} /^## /{flag=0} flag && NF{print; exit}' "$MEM/CHARTER.md" 2>/dev/null || true)"
  if [[ -n "${PURPOSE:-}" ]]; then
    CONTEXT+="章程目的: ${PURPOSE}"$'\n'
  else
    CONTEXT+="章程: .memory/CHARTER.md 存在"$'\n'
  fi
fi

if [[ -f "$MEM/TASK_INDEX.md" ]]; then
  CONTEXT+=$'\n'"--- TASK_INDEX (recent) ---"$'\n'
  CONTEXT+="$(grep -E '^\|' "$MEM/TASK_INDEX.md" | tail -n 9 || true)"$'\n'
fi

if [[ -f "$PLAN_DIR/task_plan.md" ]]; then
  CONTEXT+=$'\n'"--- current task_plan (head) ---"$'\n'
  CONTEXT+="$(head -n 40 "$PLAN_DIR/task_plan.md")"$'\n'
else
  CONTEXT+=$'\n'"当前无 task_plan.md。多步骤任务请用 /task-plan 或运行 init-task-plan.sh。"$'\n'
fi

if command -v python3 >/dev/null 2>&1; then
  printf '%s' "$CONTEXT" | python3 -c 'import json,sys; print(json.dumps({"additional_context": sys.stdin.read()}))'
else
  printf '%s\n' '{}'
fi
