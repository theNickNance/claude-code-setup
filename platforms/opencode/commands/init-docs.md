---
description: Scaffold or repair the project docs structure
---

Scaffold or repair the standard project documentation structure.

Request details: $ARGUMENTS

Workflow:
- Check whether `docs/` already exists. If it does, report what is already there and ask what is missing before overwriting anything.
- Create missing directories and files for the standard docs structure.
- Populate missing docs with practical content based on the actual repo.
- If the project has existing code, analyze it and fill in as much of [[ARCHITECTURE]] as possible.
- If `design_system.md` is missing for a frontend project, create it from `~/.config/opencode/templates/design_system.md`.
- Remind the user to create project-level instructions if they do not exist.

Directory structure:

```text
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

[[ARCHITECTURE]] skeleton:

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

[[TASKS]] skeleton:

```markdown
# Tasks

## Active

<!-- Add tasks as ### blocks. See /tasks command for format. -->

---

## Archive
```

[[CHANGELOG]] skeleton:

```markdown
# Changelog

## [today's date] — Project initialized

- Scaffolded documentation structure
- Created initial [[ARCHITECTURE]]
```

`docs/runbooks/setup.md` skeleton:

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

Rules:
- Never overwrite existing docs without confirmation.
- If [[ARCHITECTURE]] already exists, offer to update or fill in missing sections instead.
- The setup runbook should reflect the actual project setup, not a generic template. Read `package.json`, `.env.example`, `docker-compose.yml`, and similar files to fill it in accurately.
- Use `~/.config/opencode/templates/design_system.md` for the installed OpenCode template path. Do not assume the source repo checkout still exists.
