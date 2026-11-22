#!/usr/bin/env bash
# Stop gate: if task_plan phases incomplete, ask agent to continue (loop_limit in hooks.json).
set -euo pipefail

ROOT="${CURSOR_PROJECT_DIR:-$(pwd)}"
cd "$ROOT" 2>/dev/null || true

SKILL=""
for c in \
  "$ROOT/.cursor/skills/project-memory" \
  "$HOME/.cursor/skills/project-memory"
do
  if [[ -f "$c/scripts/check-complete.sh" ]]; then
    SKILL="$c"
    break
  fi
done

if [[ -z "$SKILL" ]]; then
  printf '%s\n' '{}'
  exit 0
fi

set +e
OUT="$(bash "$SKILL/scripts/check-complete.sh" 2>/dev/null)"
RC=$?
set -e

if [[ "$RC" -eq 2 ]]; then
  MSG="任务规划尚未完成全部阶段。请继续推进当前 task_plan.md，更新 Status，不要假装收工。若用户明确要求停止，则尊重用户。完成后运行 complete-task-plan.sh，并沉淀知识到 .memory/KNOWLEDGE.md。详情: $OUT"
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys; print(json.dumps({"followup_message": sys.argv[1]}))' "$MSG"
  else
    printf '{"followup_message":"%s"}\n' "task-plan incomplete"
  fi
  exit 0
fi

# complete or no plan: if complete, nudge logging once via followup only when marker missing — keep silent to avoid loops
printf '%s\n' '{}'
