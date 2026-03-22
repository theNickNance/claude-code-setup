# Claude Code System

A configuration system for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that enforces consistent documentation, test-driven development, design system compliance, and long-term maintainability — especially for AI-written codebases.

## The Problem

Claude Code is powerful but stateless. Every new session starts from zero context.
Without structure, you end up with:

- Inconsistent code patterns across sessions (three different hooks for the same thing)
- No record of *why* things were built a certain way
- AI-written frontend that drifts from your design (wrong colors, spacing, fonts)
- Tests that hit coverage numbers but protect nothing
- A codebase that works but no human fully understands

This system solves these problems with a global `CLAUDE.md` config, a set of
slash-command skills, and a documentation structure that gives Claude persistent
project context across sessions — using plain markdown files committed to your repo.

## What's Included

```
CLAUDE.md                          ← Global config (loaded every session)
install.sh                         ← Install script (copies files to ~/.claude/)
skills/
  plan/SKILL.md                    ← /plan — create change plans
  tasks/SKILL.md                   ← /tasks — track tasks with priorities
  adr/SKILL.md                     ← /adr — architecture decision records
  init-docs/SKILL.md               ← /init-docs — scaffold project docs
  tdd/SKILL.md                     ← /tdd — test-driven dev workflow
  design-ingest/SKILL.md           ← /design-ingest — extract design tokens
templates/
  design_system.md                 ← Design system template for new projects
```

## Install

```bash
# Clone the repo
git clone <repo-url> ~/.claude-code-system
cd ~/.claude-code-system

# Make the install script executable (first time only)
chmod +x install.sh

# Run the install script
./install.sh
```

Or manually:

```bash
cp ~/.claude-code-system/CLAUDE.md ~/.claude/CLAUDE.md
cp -r ~/.claude-code-system/skills/* ~/.claude/skills/
```

The global CLAUDE.md loads every session. Skills load on-demand when you invoke them.

## How It Works

### Architecture: What Gets Loaded When

The system is designed around a token budget. Files that load every session are
kept small. Reference material loads only when a skill is invoked.

| File | When loaded | Size |
|------|------------|------|
| `~/.claude/CLAUDE.md` | Every session | ~1,400 words |
| Project `CLAUDE.md` | Every session in that project | Varies |
| `docs/ARCHITECTURE.md` | Every session (per startup rules) | Varies |
| `docs/TASKS.md` | Every session (per startup rules) | Small |
| `design_system.md` | Sessions involving frontend work | ~1,500 words |
| Skills | Only when invoked via slash command | 250–725 words each |

### Session Start

Every Claude Code session begins by reading context (defined in the global CLAUDE.md):

1. Read the project-level `CLAUDE.md`
2. Read `docs/ARCHITECTURE.md` — the system's current state
3. Check `docs/plans/` for any plans with status "In Progress"
4. Check `docs/TASKS.md` for any P0 or Blocked tasks
5. Read `design_system.md` if frontend work is involved

This is how the system replaces memory and maintains continuity across sessions.
No database, no API, no agent framework — just markdown files in git.

### Per-Project Structure

When you start a new project, `/init-docs` scaffolds this structure:

```
your-project/
  CLAUDE.md                        ← Project-specific context (domain, data model, conventions)
  design_system.md                 ← Design tokens (colors, typography, spacing, patterns)
  docs/
    ARCHITECTURE.md                ← System state — always current, always read first
    TASKS.md                       ← Task tracking (ID, priority, status, owner, linked plan)
    CHANGELOG.md                   ← Curated log of significant changes
    plans/                         ← Change plans (permanent record, never deleted)
      PLAN-001-auth-setup.md
      PLAN-002-data-model.md
    decisions/                     ← Architecture Decision Records (permanent, never deleted)
      ADR-001-database-choice.md
    domain/                        ← Business domain knowledge docs (optional)
    design/                        ← Reference screenshots for design system
    runbooks/                      ← Setup, deployment, operational procedures
```

### Cross-Referencing with Wiki-Links

All docs use `[[wiki-link]]` syntax for cross-references:

- In TASKS.md: `[[PLAN-003-auth-setup]]` in the Plan column
- In plans: `[[ADR-002-database-choice]]`, `[[ARCHITECTURE]]`
- In ADRs: `Superseded by [[ADR-005-migration]]`

This makes docs navigable in [Obsidian](https://obsidian.md/) (clickable links,
backlink panels, graph view) while staying readable in any markdown viewer.

**Recommended:** Open your project root as an Obsidian vault for searching and
navigating docs. `Cmd+O` for quick file open, `Cmd+Shift+F` for full-text search.

## Skills

### `/init-docs` — Scaffold Project Documentation

Creates the `docs/` directory structure for a new project, including
ARCHITECTURE.md, TASKS.md, CHANGELOG.md, and runbooks. If the project has
existing code, it analyzes the codebase to pre-populate ARCHITECTURE.md.

### `/plan` — Create a Change Plan

Creates a numbered plan document before implementation begins. Plans include
problem statement, approach, scope, risks, task breakdown, and test strategy.
After approval, automatically creates linked tasks in TASKS.md.

**Plans are required when a change:**
- Touches more than 3 files
- Adds/changes data model entities
- Introduces a new external dependency
- Changes an API contract
- Estimated at more than ~30 minutes of work
- Could break existing functionality

### `/tasks` — Task Tracking

List-based task tracking with priorities (P0–P3), status, assignees (`@github`
usernames), and plan links. Uses block format instead of tables to prevent merge
conflicts. Tasks are the single source of truth for "is this done?"

Commands: `/tasks` (view), `/tasks add`, `/tasks done T-003`, `/tasks clean`

### `/adr` — Architecture Decision Records

Documents significant technical decisions with context, alternatives considered
(with honest pros/cons), and consequences. ADRs are never deleted — if a decision
is reversed, a new ADR supersedes the old one.

### `/tdd` — Test-Driven Development

Enforces a strict red-green-refactor cycle. Includes Vitest configuration,
fixture patterns with realistic domain data, component testing helpers, and
API route test examples.

The workflow: write tests → confirm RED → implement → confirm GREEN → refactor →
run full suite.

### `/design-ingest` — Extract Design Tokens

Analyzes reference screenshots or URLs and extracts design tokens (colors,
typography, spacing, radii, shadows, component patterns) into `design_system.md`.
Also updates `tailwind.config.ts` and `globals.css`.

## The Development Workflow

### New Project Setup

```
# 1. Create your project
npx create-next-app@latest my-app --typescript --tailwind --app --src-dir
cd my-app

# 2. Scaffold docs
/init-docs

# 3. Save reference screenshots to docs/design/, then:
/design-ingest

# 4. Write the project-level CLAUDE.md with domain context

# 5. Design the architecture
"Let's design the architecture for this app. [describe it].
Write docs/ARCHITECTURE.md with the full system design."

# 6. Record key tech decisions
/adr

# 7. Break v1 into plans
/plan    # "Auth setup"
/plan    # "Core data model"
/plan    # "Dashboard page"

# 8. Check your backlog
/tasks
```

### Daily Development

```
# Claude reads ARCHITECTURE.md, TASKS.md, checks plans (automatic)

/tasks                           # What's P1?
/tdd                             # Write tests first, then implement

# Claude commits with traceability:
# feat(T-001): add company data model (PLAN-002)

# When a plan is done, Claude updates:
# - Plan status → Completed
# - TASKS.md → tasks marked Done
# - ARCHITECTURE.md → if anything changed
# - CHANGELOG.md → entry for the feature
```

### Choosing the Right Tool for Each Task

| Task | Tool |
|------|------|
| Quick question or command lookup | Claude Code, natural language |
| Planning a feature | `/plan` |
| Choosing between technologies | `/adr` |
| Building a feature | `/tdd` → implement |
| Checking what to work on | `/tasks` |
| Setting up a new project | `/init-docs` + `/design-ingest` |
| Establishing design direction | `/design-ingest` with reference screenshots |

## Key Design Decisions

### Why Plain Markdown, Not a Database

Every piece of project context is a markdown file committed with the code. This
means: it's version-controlled, it survives across sessions, it's searchable,
it's human-readable, and it costs nothing. No API calls, no memory databases,
no agent frameworks to maintain.

### Why Skills, Not a Bigger CLAUDE.md

The original version of this system was a 756-line monolithic CLAUDE.md. That's
~4,000 tokens loaded every session, most of which was templates and code examples
only relevant occasionally. The current CLAUDE.md is ~1,400 words (rules and
pointers). Skills load on-demand when invoked. Same total content, dramatically
lower per-session token cost.

### Why Wiki-Links

`[[wiki-link]]` syntax enables navigation in Obsidian (clickable links, backlinks,
graph view) at zero cost — it's just plain text that both Obsidian and Claude Code
understand. Plans link to tasks, tasks link to plans, ADRs reference each other.
The docs become a navigable knowledge graph for free.

### Maintainability of AI-Written Code

The system includes specific rules for long-term maintainability that go beyond
standard coding practices:

- **Reuse before creating**: Claude must search for existing patterns before writing
  new abstractions.
- **Dependency approval**: Claude must ask before adding any new package.
- **Pattern registry**: ARCHITECTURE.md documents the ONE approved way to do each
  common task (data fetching, form handling, error handling, etc.).
- **Human-oriented comments**: Every file gets a top-of-file comment explaining
  what it does and why it exists. AI-written code needs more "why" documentation
  than human-written code because no human holds the mental model of how it was built.
- **Human review checkpoints**: Data model changes, auth logic, new integrations,
  and architecture pattern changes require explicit human approval.

## Customization

Everything is just markdown files. Fork and customize:

- **CLAUDE.md**: Change the stack defaults, code style, component rules to match
  your preferences. Remove sections that don't apply.
- **Skills**: Modify templates, add new fields, change the workflow. Add your own
  skills for patterns specific to your work.
- **design_system.md template**: Adjust the token structure to match your design
  process.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (Claude Max plan
  or API key)
- A project using git
- [Obsidian](https://obsidian.md/) (recommended for doc navigation, not required)

## License

MIT
