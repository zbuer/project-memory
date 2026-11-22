# Design notes

定稿摘要（来自产品讨论）：

1. 项目记忆始终自动创建；无章程时记忆 = 知识 + 任务史册。
2. 层次：`章程? → task-plan`；知识横切沉淀。无独立 epic 层。
3. 完成史册：`TASK_INDEX.md` + `TASK_LOG.md`（省 token：开场只碰 INDEX）。
4. 命令：`/task-plan`；Cursor 侧去掉 `/plan`。
5. 与 PWF：软 fork / 衍生，兼容文件布局；不依赖用户另装 PWF。
6. task-plan 中的 task ≠ 敏捷最小 Task；中文称「任务规划」。
