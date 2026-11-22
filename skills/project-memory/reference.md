# project-memory reference

## File map (consumer project)

```text
.memory/                 # git-track recommended
  CHARTER.md?            # optional 章程
  KNOWLEDGE.md           # 知识（只追加）
  TASK_INDEX.md          # 任务目录（注入用）
  TASK_LOG.md            # 任务详情日志
task_plan.md             # current task-plan (or under .planning/<slug>/)
findings.md
progress.md
.planning/
  .active_plan           # optional active slug
  <slug>/                # parallel task-plans
```

## Token policy

- sessionStart: CHARTER one-liner + TASK_INDEX recent rows + task_plan head (~40 lines)
- Never inject full KNOWLEDGE.md or full TASK_LOG.md
- Read LOG/KNOWLEDGE on demand by anchor or search

## Upstream relationship

Soft fork of planning-with-files (PWF) **execution layout** (`task_plan` / `findings` / `progress`, phase statuses).  
Differentiator: always-on project memory, capture, INDEX+LOG, `/task-plan` only (no `/plan`).

Syncing upstream PWF is **manual / semi-automatic** (fork sync + resolve conflicts). Memory layer is maintained here.

## Env vars

| Variable | Meaning |
|----------|---------|
| `PM_PLAN_ROOT` / `PWF_PLAN_ROOT` | Absolute project root for plans/memory |
| `PLAN_ID` | Active slug under `.planning/` |
| `PM_SKILL_DIR` | Override skill install path |
