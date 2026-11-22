---
description: 创建或重置任务规划（task-plan）。不是 Cursor Plan 模式。
---

按 **planning-with-memory** 技能执行任务规划初始化：

1. 运行 skill 内 `scripts/ensure-memory.sh`（确保 `.memory/`：KNOWLEDGE、TASK_INDEX、TASK_LOG）。
2. 运行 `scripts/init-task-plan.sh`；若用户给了标题则传入；并行任务用 `--slug <name>`。
3. 若当前已有未完成的 `task_plan.md`，先询问是否 `complete-task-plan` / 沉淀知识，再 `--force` 覆盖。
4. 打开并填写 Goal、Next Step、Phases；提醒：**任务规划 ≠ Cursor Plan 模式**，不要为此切换 Plan 模式。
5. 简短确认已创建的文件路径与下一步。
