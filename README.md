# project-memory

**项目记忆 + 任务规划（task-plan）** for Cursor agents.

- 跨会话记住「知识」与「做过哪些任务」，而不是整段聊天记录  
- 多步骤 / 长任务用磁盘上的 `task_plan.md`（兼容 [planning-with-files](https://github.com/OthmanAdi/planning-with-files) 文件布局）  
- 命令：**`/task-plan`**（**不是** Cursor 的 Plan 模式，也**没有** `/plan`）

## 为什么

Agent 会话默认不共享对话记忆。重要结论若写在可被下一任务覆盖的执行文件里，会丢。  
本技能把 **项目记忆**（知识 + 任务索引/日志）与 **当前任务规划** 分开：执行板可覆盖，记忆只追加。

## 层次

```text
章程 (.memory/CHARTER.md)?     ← 可选
  └── 任务规划 (task_plan.md)  ← 当前执行
项目记忆（始终）:
  KNOWLEDGE.md                 ← 结论 / 调研 / 决策 / 试错（沉淀）
  TASK_INDEX.md + TASK_LOG.md  ← 每个 task-plan 结束后的史册
```

## 快速安装（Cursor 项目）

```bash
# 替换为你的 clone URL
REPO=https://github.com/zbuer/project-memory.git
git clone "$REPO" /tmp/project-memory

mkdir -p .cursor/skills .cursor/hooks .cursor/commands
cp -R /tmp/project-memory/skills/project-memory .cursor/skills/
cp -R /tmp/project-memory/.cursor/hooks/. .cursor/hooks/
cp /tmp/project-memory/.cursor/commands/task-plan.md .cursor/commands/
# 若项目还没有 hooks.json：
cp /tmp/project-memory/.cursor/hooks.json .cursor/hooks.json
chmod +x .cursor/hooks/*.sh .cursor/skills/project-memory/scripts/*.sh
```

若已有 `hooks.json`，请把本仓库 `.cursor/hooks.json` 里的 `sessionStart` / `preToolUse` / `postToolUse` / `stop` 条目合并进去。

## 使用

1. 在 Agent 输入 **`/task-plan`**（或让 Agent 按 skill 初始化）  
2. 填写 Goal / Phases，开始干活；重要结论 **沉淀** 进 `.memory/KNOWLEDGE.md`  
3. 全部阶段完成后运行 `complete-task-plan.sh`（写 INDEX + LOG），再开下一板  

可选：`ensure-memory.sh --with-charter` 创建章程。

## Hooks（Cursor）

| Hook | 作用 |
|------|------|
| sessionStart | 确保 `.memory/`；注入 INDEX 近况 + 当前 task_plan 头部 |
| postToolUse | 提醒更新规划 / 沉淀 |
| stop | 阶段未完成时可 follow-up（`loop_limit: 3`） |

## 与 PWF

本仓库是 PWF 执行思路的 **软 fork / 衍生**：布局兼容，默认带项目记忆；**不**要求先安装 PWF。  
上游更新 **不会**自动进入本仓；可用 fork sync / 手工合并执行核（半自动）。

## License

MIT. Attribution to planning-with-files and the Manus-style disk working-memory pattern — see `LICENSE`.

## 文档

- [skills/project-memory/SKILL.md](skills/project-memory/SKILL.md) — Agent 主说明  
- [docs/design.md](docs/design.md) — 设计定稿  
- [skills/project-memory/reference.md](skills/project-memory/reference.md) — 文件与环境变量  
