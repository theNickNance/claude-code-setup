---
description: View or manage tasks in docs/TASKS.md
---

Operate on [[TASKS]] (`docs/TASKS.md`) using this request: $ARGUMENTS

Supported intents:
- `/tasks` with no arguments: show all open tasks grouped by priority.
- `/tasks add [description]`: add a new task.
- `/tasks done [id]`: mark a task as completed.
- `/tasks update [id] [field] [value]`: update priority or plan link.
- `/tasks clean`: move completed tasks to the Archive section.

Tasks live in `docs/TASKS.md`. If it does not exist, create it on first use.

File format:
- Tasks use a compact list-based format, not a table.
- Each task is its own block, separated by a blank line.
- Each task has a heading, metadata line, and description.

Example:

```markdown
# Tasks

## Active

### T-001 — Set up auth with Clerk [P1]
@nickhandle · 2025-03-14 · [[PLAN-003-auth-setup]]
Implement sign-up, login, and session management using Clerk.
Protect all routes under the (auth) route group.

---

## Archive

### T-000 — Scaffold project docs [P2] ✓
@nickhandle · 2025-03-12 · completed 2025-03-12
```

Fields:
- ID: `T-001`, `T-002`, etc. Auto-increment and never reuse.
- Title: short summary on the heading line.
- Priority: `[P0]`, `[P1]`, `[P2]`, `[P3]`.
- Creator: `@githubusername`.
- Date: `YYYY-MM-DD`.
- Plan: `[[PLAN-NNN-slug]]`, omitted if none.
- Description: 1-3 sentences.

Rules:
- IDs are permanent. Never renumber.
- Every task has a description.
- Creator is always populated.
- Link plans to tasks.
- Task status in [[TASKS]] is authoritative.
- Keep tasks flat. If a task needs subtasks, it needs a `/plan`.
- Archive completed tasks instead of deleting them.
- When marking a task Done, move it to Archive, add `✓` after the priority tag, and append `· completed YYYY-MM-DD` to the metadata line.
- When reading [[TASKS]] at session start, surface any P0 tasks immediately.
