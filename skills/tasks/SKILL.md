# /tasks — View and Manage Project Tasks

When invoked, read, create, or update tasks in [[TASKS]] (`docs/TASKS.md`).

## Commands

- `/tasks` — Show all open tasks grouped by priority
- `/tasks add [description]` — Add a new task
- `/tasks done [id]` — Mark a task as completed
- `/tasks update [id] [field] [value]` — Update a task's priority, status, or assignee
- `/tasks clean` — Move completed tasks to the Archive section

## File Location

Tasks live in `docs/TASKS.md`. If it doesn't exist, create it on first use.

## File Format

```markdown
# Tasks

## Active

| ID | Task | Priority | Status | Owner | Created | Plan |
|----|------|----------|--------|-------|---------|------|
| T-001 | Set up auth with Clerk | P1 | In Progress | Nick | 2025-03-14 | [[PLAN-003-auth-setup]] |
| T-002 | Add workflow export to CSV | P2 | Todo | — | 2025-03-14 | — |
| T-003 | Fix sidebar nav active state | P3 | Todo | — | 2025-03-14 | — |

## Archive

| ID | Task | Priority | Completed | Plan |
|----|------|----------|-----------|------|
| T-000 | Scaffold project docs | P2 | 2025-03-12 | — |
```

## Fields

| Field | Values | Notes |
|-------|--------|-------|
| ID | T-001, T-002, ... | Auto-increment. Never reuse IDs. |
| Priority | P0, P1, P2, P3 | P0 = blocking/urgent. P1 = current sprint. P2 = next up. P3 = backlog. |
| Status | Todo, In Progress, Blocked, Done | Only one task per owner should be "In Progress" at a time. |
| Owner | Name or "—" | Who's responsible. "—" means unassigned. |
| Plan | `[[PLAN-NNN-slug]]` or "—" | Wiki-link to the plan doc if one exists. |

## Rules

- **IDs are permanent.** Never renumber. Next ID = highest existing + 1.
- **Link plans to tasks.** When `/plan` creates a plan, also add a task (or tasks)
  here referencing that plan with a `[[PLAN-NNN-slug]]` link. When a plan is
  completed, mark linked tasks Done.
- **One source of truth.** Task status in [[TASKS]] is authoritative. Don't track
  status in plan docs separately — the plan's task breakdown is for sequencing
  work, [[TASKS]] is for tracking status.
- **Keep it flat.** No subtasks, no nested hierarchies. If a task needs subtasks,
  it needs a `/plan` and the subtasks are the plan's task breakdown.
- **Archive regularly.** Use `/tasks clean` to move Done tasks to the Archive
  section. Don't delete them.
- **Session start integration.** When reading [[TASKS]] at session start, surface
  any P0 or "Blocked" tasks to the user immediately.
