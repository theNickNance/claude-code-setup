# CLAUDE.md — Global

## Session Start (Do This First)

1. Read the project-level `CLAUDE.md` if one exists.
2. Read [[ARCHITECTURE]] if it exists — this is the system's current state.
3. Check `docs/plans/` for any plans with status "In Progress."
4. Check [[TASKS]] for any P0 or Blocked tasks. Surface them immediately.
5. Read [[design_system]] if it exists and frontend work is involved.

Do not start implementation without completing these steps.

## Stack Defaults

Use these unless a project-level CLAUDE.md specifies otherwise:

- Next.js (App Router), TypeScript strict, Tailwind CSS, shadcn/ui
- React Server Components by default; client components only for interactivity
- PostgreSQL + Prisma (or Drizzle — match the project)
- pnpm, Vercel, Vitest + React Testing Library + Playwright

## Code Style

- Files: `kebab-case.tsx`. Components: `PascalCase`.
- Named exports. Default exports only for Next.js pages/layouts/route handlers.
- `interface` for object shapes. `type` for unions/intersections. No enums — use `as const` objects.
- Explicit return types on exported functions. Inferred for internal functions.
- No `any` without a comment explaining why.
- Import order: React/Next → external packages → `@/` aliases → relative. Blank line between groups.
- Comments explain WHY, not WHAT. No commented-out code in commits.
- Errors: handle explicitly, never swallow silently, use typed error boundaries for UI.

## Component Rules

- One component per file (exception: tightly coupled parent/child like Tabs/TabPanel).
- Composition over configuration: `<Card><CardHeader>` not `<Card title="...">`.
- `"use client"` only on components that need it. Keep the boundary small.
- Every list/table must have a loading state (skeleton, not spinner) and an empty state.

## Frontend — Design System Enforcement

**Before writing ANY frontend code, read [[design_system]].** Non-negotiable.

- NEVER use raw Tailwind colors (`bg-blue-500`). Only semantic tokens from the design system.
- NEVER choose fonts, colors, or spacing values not in the design system.
- NEVER use default shadcn/ui styling without checking it against the design system.
- NEVER produce "AI generic" UI — flat white cards, purple accents, Inter font.
- Use realistic domain content in UI (company names, role titles, workflow names), not "Lorem ipsum."
- If no [[design_system]] exists, ask before making visual decisions.

## Git

- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`.
- **Include task ID in every commit**: `feat(T-003): add workflow export to CSV`
- **Include plan reference when applicable**: `feat(T-003): add auth setup (PLAN-005)`
- Atomic commits. One logical change each.
- Branches: `feat/short-description`, `fix/short-description`.

### Pre-Commit Checklist (Do Not Skip)

**Before every `git commit`, complete ALL of these steps in order:**

1. Run `pnpm test` — if any test fails, fix before continuing.
2. Update [[ARCHITECTURE]] if this commit changes the data model, adds a
   service/integration, or changes an API pattern.
3. Update [[CHANGELOG]] if this commit completes a plan.
4. Update [[TASKS]] if this commit completes or changes the status of a task.
5. Update the plan doc if this commit completes or advances a plan.

**Then STOP. Do not commit yet.** Present the following to the user and wait
for explicit approval:

- Summary of what changed (files modified, features added/changed)
- Which docs were updated and what changed in them
- A manual test plan: specific things the user should verify in the browser
  or terminal before committing (e.g., "navigate to /workflows, create a new
  workflow, verify it appears in the list")
- Any risks or things to watch for

**Wait for the user to confirm before committing.** If the user reports issues,
fix them and re-run this checklist. Only commit after explicit go-ahead.

**Do not batch doc updates as a separate commit.** Docs ship in the same
commit as the code they describe.

---

## Documentation

Every project maintains a `docs/` directory committed with the code:

```
docs/
  ARCHITECTURE.md     # System state — the most important doc
  TASKS.md            # Task tracking with priorities and status
  CHANGELOG.md        # Curated log of significant changes
  plans/              # Change plans (never deleted)
  decisions/          # Architecture Decision Records (never deleted)
  design/             # Reference screenshots
  runbooks/           # Setup, deployment, operational procedures
```

Use `/init-docs` to scaffold this structure for a new project.

### Rules

- Docs update in the SAME COMMIT as the code change. Not as a follow-up.
- [[ARCHITECTURE]] is always current. Update it when adding entities, services,
  integrations, or changing the data model. If it conflicts with code, fix it immediately.
- [[CHANGELOG]] gets an entry for any change that has a plan.
- Never delete plans or ADRs. They are the permanent historical record.

### Cross-Referencing

Use `[[wiki-link]]` syntax to connect documents:
- In [[TASKS]]: link to plans with `[[PLAN-003-auth-setup]]`
- In plans: link to related decisions with `[[ADR-002-database-choice]]`
- In ADRs: link to superseding ADRs with `[[ADR-005-migration]]`
- Anywhere: link to [[ARCHITECTURE]], [[TASKS]], [[CHANGELOG]]

This enables navigation in Obsidian and is readable in any markdown viewer.

### When Plans Are Required

Any change that meets ONE OR MORE of these requires a plan (use `/plan`):
- Touches more than 3 files
- Adds/changes data model entities
- Introduces a new external dependency
- Changes an API contract
- Estimated at more than ~30 minutes of work
- Could break existing functionality

**Workflow:** `/plan` → approval → write tests (`/tdd`) → implement → update docs → commit.

---

## Test-Driven Development

Tests are written BEFORE implementation. Use `/tdd` for the full workflow and patterns.

### What Must Be Tested

- All business logic and data transformations
- All CRUD operations and data model constraints
- All API endpoints: validation, response shape, auth, error cases
- All state transitions (valid and invalid)
- Edge cases: empty inputs, null values, boundaries
- Error paths the user can hit
- Component behavior: interactions that trigger logic
- Every bug fix includes a test that reproduces the bug first

### Running Tests

| When | Command |
|------|---------|
| After writing tests / implementation | `pnpm test -- [file]` |
| After any refactor or before committing | `pnpm test` |
| Before completing a plan | `pnpm test && pnpm test:e2e` |

If a test fails: STOP. Fix before continuing. Never skip or disable a failing test.

### Anti-Patterns

- Never write tests after implementation. Tests come first.
- Never mock your own business logic. Mock external boundaries only.
- Never use snapshot tests.
- Never use `test.skip` without a linked plan.
- Never commit with failing tests. Main is always green.

---

## Maintainability

This codebase is primarily AI-written. That requires specific discipline to keep
it understandable and maintainable over time.

### Reuse Before Creating

Before writing new code, search the codebase for existing patterns:
- Before creating a new hook, check `src/hooks/` for one that already does this.
- Before creating a new utility, check `src/lib/` for existing helpers.
- Before creating a new component, check `src/components/ui/` for one to extend.
- Before adding a package, check `package.json` — if something similar is already
  installed, use it. **Ask before adding any new dependency.**

If the existing pattern doesn't quite fit, extend it — don't create a parallel one.
The worst outcome is two abstractions for the same problem.

### Code Comments for Humans

AI-written code needs MORE comments than human-written code, not fewer.
Specifically:

- **Every file gets a top-of-file comment** (2-3 lines): what this module does,
  what it's used by, and why it exists as a separate module.
- **Every non-obvious function gets a "why" comment**: not what it does (the code
  shows that), but why this approach was chosen and what would break if it changed.
- **Mark integration boundaries**: where this module talks to external services,
  databases, or other major modules, add a comment explaining the contract.

### Approved Dependencies

Only use packages already in `package.json` unless a plan explicitly approves
adding a new one. When a plan proposes a new dependency, it must include:
- Why an existing dependency can't do the job
- The package's maintenance status (last publish, weekly downloads, open issues)
- What it would take to remove it later if needed

### Pattern Registry

[[ARCHITECTURE]] must include a "Key Patterns" section that documents the
ONE approved way to do each common task:

- Data fetching pattern (RSC vs. client, caching strategy)
- Form handling pattern (library, validation approach)
- Error handling pattern (boundaries, API error responses)
- Auth check pattern (middleware vs. per-route)
- State management pattern (when to use context, when to lift state)

When Claude encounters a task that fits one of these patterns, it MUST use the
documented pattern, not invent a new one.

### Human Review Checkpoints

Not everything needs human review, but these do:
- Any change to the data model or database schema
- Any new external integration or API dependency
- Any change to auth or permissions logic
- Any change to the patterns documented in [[ARCHITECTURE]]
- Any plan rated P0 or that touches more than 5 files

For these, Claude presents the plan and waits for explicit approval before
implementing. For everything else, Claude can proceed with the normal
plan → test → build workflow.

### Periodic Health Checks

On a regular cadence (weekly or at the end of each plan), review:
- Are there duplicate abstractions? (two hooks/utils doing similar things)
- Are there unused exports or dead code paths?
- Do all modules still match what [[ARCHITECTURE]] describes?
- Are there `// TODO` or `// HACK` comments older than 2 weeks?
- Is test coverage meaningful? (testing behavior, not just hitting lines)

Surface findings as tasks in [[TASKS]] with appropriate priority.

---

## Skills Reference

| Command | What it does |
|---------|-------------|
| `/init-docs` | Scaffold the `docs/` directory for a new project |
| `/plan` | Create a change plan before implementation |
| `/tasks` | View, add, update, and complete tasks in [[TASKS]] |
| `/adr` | Record an architecture decision with alternatives and tradeoffs |
| `/tdd` | Test-driven development workflow with patterns and examples |
| `/design-ingest` | Extract design tokens from screenshots into [[design_system]] |
