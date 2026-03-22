# /init-docs — Scaffold Project Documentation

When invoked, create the standard documentation structure for a new project.

## Steps

1. Check if `docs/` already exists. If it does, report what's already there
   and ask the user what's missing before overwriting anything.

2. Create the directory structure:

```
docs/
  ARCHITECTURE.md
  TASKS.md
  CHANGELOG.md
  plans/
  decisions/
  design/
  runbooks/
    setup.md
```

3. Populate [[ARCHITECTURE]] (`docs/ARCHITECTURE.md`) with this skeleton:

```markdown
# Architecture — [Project Name]

## Overview

One paragraph. What is this system, who uses it, what does it do.

## Tech Stack

Exact versions. Frameworks, databases, key libraries, deployment target.

## System Diagram

ASCII or Mermaid diagram showing major components and connections.
Update whenever a new component is added.

## Data Model

Core entities, relationships, and where they live.
For each entity: name, key fields, relationships, code location.

## Key Patterns

Routing strategy, API patterns, state management, error handling, auth flow.

## External Dependencies

Third-party services/APIs. For each: purpose, auth method, config location,
degradation behavior.

## Environment & Configuration

Required env vars, feature flags, config files. What's needed locally vs. production.

## Known Limitations & Tech Debt

| Date | Description | Severity | Plan to address |
|------|-------------|----------|-----------------|
| | | | |
```

4. Populate [[TASKS]] (`docs/TASKS.md`):

```markdown
# Tasks

## Active

<!-- Add tasks as ### blocks. See /tasks skill for format. -->

---

## Archive
```

5. Populate [[CHANGELOG]] (`docs/CHANGELOG.md`):

```markdown
# Changelog

## [today's date] — Project initialized

- Scaffolded documentation structure
- Created initial [[ARCHITECTURE]]
```

6. Populate `docs/runbooks/setup.md`:

```markdown
# Development Setup

## Prerequisites

- Node.js [version]
- pnpm
- [other requirements]

## Getting Started

1. Clone the repo
2. `pnpm install`
3. Copy `.env.example` to `.env.local` and fill in values
4. `pnpm dev`

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| | | |
```

7. If the project has existing code, analyze it and fill in as much of
   [[ARCHITECTURE]] as possible (tech stack, data model, patterns).
   If it's a brand new project, leave the skeleton for the user to fill in.

8. Remind the user to also create a project-level `CLAUDE.md` if one doesn't
   exist, and [[design_system]] if the project has a frontend.

## Rules

- Never overwrite existing docs without confirmation.
- If [[ARCHITECTURE]] already exists, offer to update/fill in missing sections instead.
- The setup runbook should reflect the ACTUAL project setup, not a generic template.
  Read package.json, .env.example, docker-compose.yml etc. to fill it in accurately.
