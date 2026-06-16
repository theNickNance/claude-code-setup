# AGENTS.md — Project (Next.js Web App)

Pairs with the platform's global `AGENTS.md`. Covers stack, docs structure, tests, and maintainability for an AI-written Next.js codebase.

## Session Start (Web App Specifics)

After reading this file, also:

1. Read [[ARCHITECTURE]] (`docs/ARCHITECTURE.md`) if it exists.
2. Check `docs/plans/` for plans with status "In Progress."
3. Check [[TASKS]] (`docs/TASKS.md`) for P0 or Blocked tasks. Surface them immediately.
4. Read [[design_system]] (`design_system.md`) if frontend work is involved.

## Stack

- Next.js (App Router), TypeScript strict, Tailwind, shadcn/ui
- React Server Components by default; client components only for interactivity
- PostgreSQL + Prisma (or Drizzle — match the project)
- pnpm, Vercel, Vitest + React Testing Library + Playwright

## Test Commands

- Targeted file: `pnpm test -- [file]`
- Full unit/integration suite: `pnpm test`
- Full suite + E2E (before completing a plan): `pnpm test && pnpm test:e2e`

## Code Style

- Files: `kebab-case.tsx`. Components: `PascalCase`.
- Named exports. Default exports only for Next.js pages/layouts/route handlers.
- `interface` for object shapes. `type` for unions/intersections. No enums — use `as const` objects.
- Explicit return types on exported functions. Inferred for internal functions.
- No `any` without a comment explaining why.
- Import order: React/Next → external packages → `@/` aliases → relative. Blank line between groups.
- Comments explain WHY, not WHAT. No commented-out code in commits.
- Handle errors explicitly. Never swallow silently. Use typed error boundaries for UI.

## Component Rules

- One component per file. Exception: tightly coupled parent/child (Tabs/TabPanel).
- Composition over configuration: `<Card><CardHeader>` not `<Card title="...">`.
- `"use client"` only when needed. Keep the boundary small.
- Every list/table has a loading state (skeleton, not spinner) and an empty state.

## Frontend — Design System

Before writing any frontend code, read [[design_system]].

- No raw Tailwind colors (`bg-blue-500`). Only semantic tokens.
- No fonts, colors, or spacing values outside the design system.
- No default shadcn/ui styling without checking it against the design system.
- No "AI generic" UI: flat white cards, purple accents, Inter font.
- Use realistic domain content (company names, role titles, workflow names). No "Lorem ipsum."
- If no [[design_system]] exists, ask before making visual decisions.

## Documentation Structure

```
docs/
  ARCHITECTURE.md     # System state
  TASKS.md            # Task tracking
  CHANGELOG.md        # Curated log of significant changes
  plans/              # Change plans (never deleted)
  decisions/          # ADRs (never deleted)
  design/             # Reference screenshots
  runbooks/           # Setup, deployment, operational procedures
```

Use `/init-docs` to scaffold.

- Docs ship in the same commit as the code they describe.
- [[ARCHITECTURE]] is always current. Update it when adding entities, services, integrations, or changing the data model.
- [[CHANGELOG]] gets an entry for any change that has a plan.
- Never delete plans or ADRs.

### When Plans Are Required (Web-App Specifics)

The global gating applies. For this project also:

- Touches more than 3 files
- Adds/changes data model entities
- Changes an API contract

## Pre-Commit Checklist

Before every `git commit`, in order:

1. `pnpm test`. Fix failures before continuing.
2. Update [[ARCHITECTURE]] if data model, services/integrations, or API patterns changed.
3. Update [[CHANGELOG]] if this commit completes a plan.
4. Update [[TASKS]] if this commit changes task status.
5. Update the plan doc if this commit advances or completes a plan.

Then stop. Present to the user and wait for approval:

- Summary of what changed
- Which docs were updated and what changed in them
- Manual test plan: specific things to verify in browser/terminal
- Risks or things to watch for

Docs ship in the same commit as the code. No follow-up doc commits.

## Test-Driven Development

Tests are written before implementation. Use `/tdd`.

### What Must Be Tested

- Business logic and data transformations
- CRUD operations and data model constraints
- API endpoints: validation, response shape, auth, error cases
- State transitions (valid and invalid)
- Edge cases: empty inputs, null, boundaries
- Error paths the user can hit
- Component behavior: interactions that trigger logic
- Every bug fix: a test that reproduces the bug first

### When to Run Tests

| When | Command |
|------|---------|
| After writing tests/implementation | `pnpm test -- [file]` |
| After refactor / before committing | `pnpm test` |
| Before completing a plan | `pnpm test && pnpm test:e2e` |

If a test fails: stop and fix. Never skip or disable.

### Anti-Patterns

- Tests after implementation
- Mocking your own business logic
- Snapshot tests
- `test.skip` without a linked plan
- Commits with failing tests

### Test File Placement

Tests live next to the code: `scoring.ts` → `scoring.test.ts`.

```
src/lib/scoring.ts              → src/lib/scoring.test.ts
src/components/card.tsx         → src/components/card.test.tsx
src/app/api/workflows/route.ts  → src/app/api/workflows/route.test.ts
```

Shared fixtures and helpers in `tests/`:

```
tests/
  fixtures/   # Factory functions for mock data
  helpers/    # render-with-providers, mock utilities
  setup.ts    # Global test setup
```

## Maintainability

This codebase is primarily AI-written. The rules below exist because no human holds the full mental model.

### Reuse Before Creating

Search the codebase before writing new code:

- New hook → `src/hooks/`
- New utility → `src/lib/`
- New UI component → `src/components/ui/`
- New dependency → `package.json`. Ask before adding any new dependency.

If an existing pattern doesn't quite fit, extend it. Never create a parallel one.

### Code Comments

- Every file gets a 2-3 line top-of-file comment: what it does, what uses it, why it exists separately.
- Every non-obvious function gets a "why" comment: why this approach, what would break if it changed.
- Mark integration boundaries with a comment explaining the contract.

`Why:` AI-written code needs more "why" documentation than human-written code.

### Approved Dependencies

Use only packages already in `package.json` unless a plan approves adding one. A plan proposing a new dependency must include:

- Why an existing dependency can't do the job
- The package's maintenance status (last publish, weekly downloads, open issues)
- What it would take to remove it later

### Pattern Registry

[[ARCHITECTURE]]'s "Key Patterns" section documents the ONE approved way to do each of:

- Data fetching (RSC vs. client, caching)
- Form handling (library, validation)
- Error handling (boundaries, API errors)
- Auth check (middleware vs. per-route)
- State management (context vs. lifting)

Use the documented pattern. Don't invent a new one.

### Human Review Checkpoints

Present the plan and wait for approval before implementing if the change touches:

- Data model or database schema
- A new external integration or API dependency
- Auth or permissions logic
- A pattern documented in [[ARCHITECTURE]]
- More than 5 files (or any P0 plan)

### Periodic Health Checks

Weekly or at the end of each plan, review:

- Duplicate abstractions
- Unused exports or dead code paths
- Modules diverging from [[ARCHITECTURE]]
- `// TODO` or `// HACK` comments older than 2 weeks
- Test coverage that hits lines but not behavior

Surface findings as tasks in [[TASKS]].
