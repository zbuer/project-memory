# Task Plan: [Brief Description]

> 任务规划（task-plan）：多步骤任务的磁盘执行规划。  
> **不是** Cursor 的 Plan 模式（模式切换 / Shift+Tab）。

## Goal

[One sentence describing the end state]

## Next Step

[The single next action. Update whenever phase status changes.]

## Current Phase

Phase 1

## Phases

Use only `pending`, `in_progress`, or `complete` for each **Status**.

### Phase 1: Requirements & Discovery

- [ ] Understand user intent
- [ ] Identify constraints and requirements
- [ ] Document findings in findings.md
- **Status:** in_progress

### Phase 2: Planning & Structure

- [ ] Define technical approach
- [ ] Create project structure if needed
- [ ] Document decisions with rationale
- **Status:** pending

### Phase 3: Implementation

- [ ] Execute the plan step by step
- [ ] Write code to files before executing
- [ ] Test incrementally
- **Status:** pending

### Phase 4: Testing & Verification

- [ ] Verify all requirements met
- [ ] Document test results in progress.md
- [ ] Fix any issues found
- **Status:** pending

### Phase 5: Delivery

- [ ] Capture durable knowledge into `.memory/KNOWLEDGE.md` (沉淀)
- [ ] Complete task-plan logging (INDEX + LOG)
- [ ] Deliver to user
- **Status:** pending

## Key Questions

1. [Question to answer]

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| | |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| | 1 | |

## Notes

- Update phase status: `pending` → `in_progress` → `complete`.
- Re-read Goal and Next Step before major decisions.
- Log errors so failed approaches are not repeated.
- On full completion: run `complete-task-plan` / follow skill completion steps before starting a new task-plan.
