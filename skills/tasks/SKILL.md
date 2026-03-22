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

Tasks use a **list-based format** (not a table). Each task is its own block,
separated by a blank line. This prevents merge conflicts when multiple people
add tasks on different branches.

```markdown
# Tasks

## Active

### T-001 — Set up auth with Clerk
- **Priority**: P1
- **Status**: In Progress
- **Assignee**: @nickhandle
- **Created**: 2025-03-14 by @nickhandle
- **Plan**: [[PLAN-003-auth-setup]]
- **Description**: Implement sign-up, login, and session management using Clerk.
  Protect all routes under the (auth) route group. Include role-based access
  for admin vs. member.

### T-002 — Add workflow export to CSV
- **Priority**: P2
- **Status**: Todo
- **Assignee**: —
- **Created**: 2025-03-14 by @nickhandle
- **Plan**: —
- **Description**: Users should be able to export a workflow's activities and
  metadata as a CSV file from the workflow detail view.

### T-003 — Research CRM integration options
- **Priority**: P2
- **Status**: Todo
- **Assignee**: @cofounderhandle
- **Created**: 2025-03-18 by @cofounderhandle
- **Plan**: —
- **Description**: Evaluate HubSpot, Salesforce, and Pipedrive APIs for pulling
  company and contact data into Ops Map. Document pros/cons and recommend one.

---

## Archive

### T-000 — Scaffold project docs ✓
- **Priority**: P2
- **Completed**: 2025-03-12 by @nickhandle
- **Plan**: —
```

## Fields

| Field | Values | Notes |
|-------|--------|-------|
| ID | T-001, T-002, ... | Auto-increment. Never reuse IDs. |
| Title | Short summary | After the ID on the `###` line. Keep under ~10 words. |
| Priority | P0, P1, P2, P3 | P0 = blocking/urgent. P1 = current sprint. P2 = next up. P3 = backlog. |
| Status | Todo, In Progress, Blocked, Done | Only one task per assignee should be "In Progress" at a time. |
| Assignee | `@githubusername` or "—" | GitHub username. "—" means unassigned. |
| Created | Date + `by @username` | Who created the task and when. Always populated. |
| Plan | `[[PLAN-NNN-slug]]` or "—" | Wiki-link to the plan doc if one exists. |
| Description | 1-3 sentences | What needs to happen and any relevant context. Required. |

## Rules

- **IDs are permanent.** Never renumber. Next ID = highest existing + 1.
- **Every task has a description.** The title is the summary, the description is
  the detail. Even simple tasks get a one-line description.
- **`Created by` is always populated.** Use the GitHub username of whoever is
  adding the task. This is how you tell who requested what.
- **Link plans to tasks.** When `/plan` creates a plan, also add a task here
  referencing that plan with a `[[PLAN-NNN-slug]]` link. When a plan is
  completed, mark linked tasks Done.
- **One source of truth.** Task status in [[TASKS]] is authoritative. Don't track
  status in plan docs separately.
- **Keep it flat.** No subtasks, no nested hierarchies. If a task needs subtasks,
  it needs a `/plan` and the subtasks are the plan's task breakdown.
- **Archive completed tasks.** When marking a task Done, move it to the Archive
  section. Add `✓` to the title line and replace Status with a `Completed` line
  showing date and who completed it.
- **Session start integration.** When reading [[TASKS]] at session start, surface
  any P0 or "Blocked" tasks to the user immediately.
- **Merge-friendly format.** Each task is its own `###` block separated by blank
  lines. Two people can add tasks on different branches and git will auto-merge
  cleanly as long as they don't edit the same task.

## For Non-Technical Contributors

Tasks can be added by editing `docs/TASKS.md` directly on GitHub:

1. Open `docs/TASKS.md` in the GitHub web UI
2. Click the pencil icon to edit
3. Add a new task block under `## Active` following the format above
4. Scroll down, select "Create a new branch and start a pull request"
5. Submit the PR — it will be reviewed and merged

This keeps all changes going through PRs so nothing gets overwritten.
