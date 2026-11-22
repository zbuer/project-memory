# planning-with-memory

**项目记忆 + 任务规划（task-plan）**：让 AI coding agent 把「这个项目是干什么的、学到了什么、做过哪些事、当前做到哪」写在磁盘上，跨会话还能接着干——而不是指望聊天窗口自己记住。

适用于任何支持 [Agent Skills](https://agentskills.io)（或能加载 `SKILL.md`）的宿主。仓库里附带了 **Cursor** 的 hooks / 斜杠命令作为参考实现；**不**维护几十个 IDE 的专用适配，其它工具按「装 skill + 按 SKILL.md 做事」即可。

## 要解决什么问题

1. **会话之间默认没有对话记忆**——新开一个 Agent 对话，不会自动带着上次聊过的细节。  
2. **只把进度写在「当前任务草稿」里会丢**——下一板任务一覆盖，结论和试错就没了。  
3. **聊天记录太长、不适合当唯一真相**——细节可以以后再查对话；日常需要的是浓缩、可 git 的项目状态。

## 核心思路（一句话）

**上下文窗口 = 易失内存；项目里的 Markdown = 持久磁盘。**  
重要的东西写入文件；新会话先读浓缩状态，细节按需再打开。

## 两层东西

| 层 | 是什么 | 会不会被下一任务盖掉 |
|----|--------|----------------------|
| **项目记忆** `.memory/` | 章程（可选）、知识库、任务史册 | **不会**（只追加 / 少改章程） |
| **任务规划** task-plan | 当前这一板多步骤工作的目标、阶段、进度 | **可以**覆盖；结束前先记入史册 |

```text
章程 CHARTER.md?              ← 可选：目的、范围、硬约束
  └── 任务规划 task_plan.md   ← 当前在执行的一盘规划（可含多阶段）
项目记忆（始终建议存在）:
  KNOWLEDGE.md                ← 结论 / 调研 / 决策 / 试错（沉淀，只追加）
  TASK_INDEX.md               ← 任务目录（短，给开场扫一眼）
  TASK_LOG.md                 ← 每个已结束任务规划的摘要详情
```

未写章程时：仍有知识库 + 任务史册 + 当前任务规划，完全可用。

说明：这里的 **task** 指「一盘多步骤/长任务规划」，不是项目管理软件里最小的那张 Task 票。

## 典型用法

1. **装上本 skill**（见下）。  
2. 需要时说「按 planning-with-memory 建章程 / 任务规划」，或使用宿主支持的 **`/task-plan`**、**`/charter`**（Cursor 已附带这两个命令文件）。  
3. 干活时更新 `task_plan.md` 阶段状态；可复用的结论 **沉淀** 进 `KNOWLEDGE.md`。  
4. 这一板结束后运行 `complete-task-plan.sh`（写入 INDEX + LOG），再开下一板。

短问题、单文件小改：不必强开任务规划；有值得留下的结论仍可沉淀进知识库。

### 章程：新项目 vs 旧项目

| 场景 | 怎么做 |
|------|--------|
| **新项目** | 在对话里说清目的/范围/硬约束，让 Agent 执行 `ensure-memory.sh --with-charter`（或 `/charter`），再按模板填 `.memory/CHARTER.md`。可与第一板 `/task-plan` 一起做。 |
| **旧项目补章程** | 同样 `/charter` 或 `ensure-memory.sh --with-charter`：若文件尚不存在则从模板创建；若已存在则 **在对话里改内容，不要整文件空白覆盖**。Agent 应先扫仓库（README、结构、已有约定）再起草/补全「目的 / 范围 / 硬约束 / 非目标」。 |

章程是可选增强：不建也能用知识库 + 任务规划。

## 安装

### 通用（推荐心智）

把 `skills/planning-with-memory/` 装到你的 Agent 能发现的 skills 目录（例如用户级 `~/.agents/skills/`，或项目内约定路径），保证其中的 `scripts/*.sh` 可执行。然后在对话里引用本 skill，或让 Agent 按 `SKILL.md` 执行。

```bash
git clone https://github.com/zbuer/project-memory.git
# 按你使用的 Agent 文档，把 skills/planning-with-memory 链到或复制到 skills 搜索路径
chmod +x skills/planning-with-memory/scripts/*.sh
```

也可用（若你环境支持）：

```bash
npx skills add zbuer/project-memory --skill planning-with-memory
```

### Cursor（附带 hooks，可选）

在**目标项目**根目录：

```bash
REPO=https://github.com/zbuer/project-memory.git
git clone "$REPO" /tmp/project-memory

mkdir -p .cursor/skills .cursor/hooks .cursor/commands
cp -R /tmp/project-memory/skills/planning-with-memory .cursor/skills/
cp -R /tmp/project-memory/.cursor/hooks/. .cursor/hooks/
cp /tmp/project-memory/.cursor/commands/*.md .cursor/commands/
# 仅当还没有自己的 hooks.json 时：
cp /tmp/project-memory/.cursor/hooks.json .cursor/hooks.json
chmod +x .cursor/hooks/*.sh .cursor/skills/planning-with-memory/scripts/*.sh
```

若已有 `hooks.json`，合并其中的 `sessionStart` / `preToolUse` / `postToolUse` / `stop` 即可。  
其它 IDE：不必等本仓库提供专用插件；能加载 skill 并跑脚本就够。

### 在 Cursor 里注意命名

本技能入口是 **`/task-plan`**（任务规划）。  
请**不要**用 `/plan` 当作本技能命令，以免和 Cursor 的 **Plan 模式**（先出方案再 Build）或 CLI 的 `/plan` 混淆。

## 脚本一览

| 脚本 | 作用 |
|------|------|
| `ensure-memory.sh` | 创建/补齐 `.memory/`；加 `--with-charter` 可建章程模板 |
| `init-task-plan.sh` | 初始化 `task_plan.md` + `findings.md` + `progress.md` |
| `complete-task-plan.sh` | 结束后写入 TASK_INDEX + TASK_LOG |
| `check-complete.sh` | 检查阶段是否全部 complete |
| `resolve-plan-dir.sh` | 解析当前规划目录（root 或 `.planning/<slug>`） |

## 设计取舍

- **不**把完整聊天当记忆；对话细节用宿主自己的历史搜索即可。  
- **不**每轮注入整本知识库；开场优先短 INDEX + 当前规划头部。  
- **不**做 60+ IDE 的官方适配矩阵；Cursor hooks 是参考实现。  
- 文件布局与「三文件任务规划」思路和社区项目 planning-with-files 相近，**使用本技能不需要先了解或安装它**；细节见 [docs/design.md](docs/design.md)。

## License

MIT。致谢 planning-with-files 与「Markdown 作磁盘工作记忆」一类实践，见 `LICENSE`。

## 文档

- [skills/planning-with-memory/SKILL.md](skills/planning-with-memory/SKILL.md) — 给 Agent 的完整说明  
- [docs/design.md](docs/design.md) — 设计定稿  
- [skills/planning-with-memory/reference.md](skills/planning-with-memory/reference.md) — 文件与环境变量  
