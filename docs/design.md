# Design notes

## 定位

面向**任意**支持 Agent Skills（或等价 SKILL.md）的 coding agent。  
Cursor hooks / 斜杠命令是参考实现，**不是**唯一用法。不做 60+ IDE 适配矩阵。

## 定稿摘要

1. 项目记忆始终可自动创建；无章程时记忆 = 知识 + 任务史册。  
2. 层次：`章程? → task-plan`；知识横切沉淀。无独立 epic 层。  
3. 史册：`TASK_INDEX.md` + `TASK_LOG.md`（开场优先 INDEX，省 token）。  
4. 命令：`/task-plan`、`/charter`；避免 `/plan`（Cursor Plan 模式冲突）。  
5. 文档与说明**自洽**：不假定读者已知 planning-with-files（PWF）。文件布局相近仅作兼容说明。  
6. task-plan 中的 task ≠ 敏捷最小 Task；中文称「任务规划」。

## 章程工作流

- 新项目：对话澄清 → `ensure-memory.sh --with-charter` → 填写 CHARTER。  
- 旧项目：同样命令创建缺失文件；已有则修订，禁止空白覆盖。  
