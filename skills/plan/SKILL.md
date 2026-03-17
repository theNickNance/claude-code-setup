# /plan — Create a Change Plan

When invoked, create a new plan document for the proposed change.

## Steps

1. Look at `docs/plans/` to determine the next plan number (PLAN-001, PLAN-002, etc.).
   If `docs/plans/` does not exist, create it.

2. Ask the user to describe the change if they haven't already.

3. Create the plan file at `docs/plans/PLAN-[NNN]-[slug].md` with the following structure:

```markdown
# PLAN-[NNN]-[slug]

**Status**: Draft
**Created**: [today's date]
**Completed**: —
**Tasks**: [[TASKS]] — T-[xxx]

## Problem

What problem are we solving? Why now? One paragraph max.

## Approach

How will we solve it?
- Files to create or modify
- Data model changes (if any) — update [[ARCHITECTURE]] when implemented
- API changes (if any)
- New dependencies (if any) — consider an [[ADR-NNN-slug]] if significant

## Scope

**In scope:**
-

**Out of scope:**
-

## Risks & Open Questions

| # | Question | Status |
|---|----------|--------|
| 1 | | Open |

## Task Breakdown

- [ ] Write tests for [feature/function]
- [ ] Implement [feature/function]
- [ ] Integration tests
- [ ] Update [[ARCHITECTURE]]
- [ ] Update [[CHANGELOG]]
- [ ] Full test suite passes

## Test Strategy

What tests verify this works? What regressions to guard against?

## Outcome

_Fill in after completion._ What happened vs. what was planned. Deviations and why.
```

4. Fill in the Problem, Approach, Scope, Risks, Task Breakdown, and Test Strategy
   sections based on the user's description and your analysis of the codebase.

5. Present the plan to the user for approval BEFORE writing any implementation code.

6. After approval, add a task to [[TASKS]] linked to this plan.
   Use the next available task ID and set the Plan column to link back
   (e.g., `[[PLAN-003-auth-setup]]`). If the plan covers multiple distinct
   deliverables, create one task per deliverable.

## Rules

- Every task in the breakdown should be small enough to be a single commit.
- Task breakdowns always include test steps BEFORE implementation steps.
- Always include "Update [[ARCHITECTURE]]" and "Update [[CHANGELOG]]" as tasks.
- Plans are never deleted, even after completion. They are the historical record.
- When implementation is complete, update the Status to "Completed," fill in
  the Completed date and Outcome section in the same commit as the final code change.
- When completing a plan, also mark all linked tasks in [[TASKS]] as Done.
