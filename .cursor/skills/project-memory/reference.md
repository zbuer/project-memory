# project-memory reference

## File map (consumer project)

```text
.memory/                 # recommend git-tracking
  CHARTER.md?            # optional 章程
  KNOWLEDGE.md           # 知识（只追加）
  TASK_INDEX.md          # 任务目录（注入/开场用）
  TASK_LOG.md            # 任务详情日志
task_plan.md             # current task-plan (or under .planning/<slug>/)
findings.md
progress.md
.planning/
  .active_plan           # optional active slug
  <slug>/                # parallel task-plans
```

## Token policy

- sessionStart / 开场: CHARTER 一句 + TASK_INDEX 近况 + task_plan 头部  
- Never inject full KNOWLEDGE.md or full TASK_LOG.md  
- Read LOG/KNOWLEDGE on demand by anchor or search  

## Host support

| | 说明 |
|--|------|
| 任意 Agent Skills 宿主 | 加载 `skills/project-memory`，执行 scripts |
| Cursor | 可选 hooks + `/task-plan` `/charter`（本仓库 `.cursor/`） |
| 其它 IDE | 不强制专用插件；能跑 skill 即可 |

## Env vars

| Variable | Meaning |
|----------|---------|
| `PM_PLAN_ROOT` | Absolute project root for plans/memory |
| `PLAN_ID` | Active slug under `.planning/` |
| `PM_SKILL_DIR` | Override skill install path |

`PWF_PLAN_ROOT` 若存在可作 `PM_PLAN_ROOT` 的别名（兼容旧环境变量名），不要求安装其它规划技能。
