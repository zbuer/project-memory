#!/usr/bin/env bash
# After Write/Edit: remind to update task-plan and capture knowledge when relevant.
set -euo pipefail

ROOT="${CURSOR_PROJECT_DIR:-$(pwd)}"
MSG=""
if [[ -f "$ROOT/task_plan.md" ]] || [[ -f "$ROOT/.planning/.active_plan" ]]; then
  MSG+="[project-memory] 若推进了任务：更新 task_plan.md 阶段状态；重要结论沉淀到 .memory/KNOWLEDGE.md。"
fi
if [[ -d "$ROOT/.memory" ]]; then
  :
else
  MSG+="[project-memory] 建议确保 .memory/ 存在（ensure-memory.sh）。"
fi

if [[ -z "$MSG" ]]; then
  printf '%s\n' '{}'
  exit 0
fi

if command -v python3 >/dev/null 2>&1; then
  python3 -c 'import json,sys; print(json.dumps({"additional_context": sys.argv[1]}))' "$MSG"
else
  printf '{"additional_context":"%s"}\n' "$MSG"
fi
