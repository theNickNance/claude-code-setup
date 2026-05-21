# Claude Code System

A configuration system for [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
designed to give Claude persistent context across sessions without locking
you into one project shape.

The system is split into two layers:

- A **minimal global** config at `~/.claude/CLAUDE.md` covering only the
  universal rituals: session start, big-changes-need-a-plan, wiki links,
  and git conventions. It assumes nothing about your project — not even
  that it's a software project.
- A set of **profiles** under `profiles/` that you drop into a project to
  add everything project-specific: the docs structure to maintain, the test
  command, the code style, the maintainability rules, reuse locations,
  pattern registry. Each profile is a complete project `CLAUDE.md`.

This split lets you jump between projects of different shapes — web apps,
client workflows, research, ops — without dragging assumptions from one
into another. When you do start a new web app, your familiar conventions
are still one install command away.

## The Problem

Claude Code is powerful but stateless. Every new session starts from zero context.
Without structure, you end up with:

- Inconsistent patterns across sessions (three different hooks for the same thing)
- No record of *why* things were built a certain way
- AI-written work that drifts from your design and conventions
- Tests or quality checks that pass on paper but protect nothing
- A project that works but no human fully understands

This system solves these problems with markdown files committed alongside your work:
a minimal global `CLAUDE.md`, a project-specific `CLAUDE.md` installed from a
profile, a set of slash-command skills, and whatever doc structure that profile
prescribes.

## What's Included

```
CLAUDE.md                          ← Global config (loaded every session, stack-agnostic)
install.sh                         ← Install script (global + per-project profiles)
skills/
  plan/SKILL.md                    ← /plan — create change plans
  tasks/SKILL.md                   ← /tasks — track tasks with priorities
  adr/SKILL.md                     ← /adr — architecture decision records
  init-docs/SKILL.md               ← /init-docs — scaffold project docs
  tdd/SKILL.md                     ← /tdd — test-driven dev workflow
  design-ingest/SKILL.md           ← /design-ingest — extract design tokens (frontend)
profiles/
  nextjs-webapp/                   ← Next.js + TS + Tailwind + shadcn/ui + Prisma
    CLAUDE.md                      ← Stack, code style, component rules, test commands
    design_system.md               ← Design system template for new projects
  generic/                         ← Minimal placeholder, no stack assumptions
    CLAUDE.md
```

## Install

### Global config (one-time)

```bash
# Clone the repo
git clone https://github.com/theNickNance/claude-code-setup ~/.claude-code-setup
cd ~/.claude-code-setup
chmod +x install.sh

# Install global CLAUDE.md + skills to ~/.claude/
./install.sh
```

### Per-project profile

For each project, install a profile to drop a project-level `CLAUDE.md` (and
any companion files like `design_system.md`) into the project root:

```bash
# From the claude-code-setup repo:
./install.sh list                              # see available profiles
./install.sh profile nextjs-webapp ~/code/my-next-app
./install.sh profile generic ~/code/some-repo
```

The profile writes to `<target>/CLAUDE.md`. If a file already exists at the
destination, you'll be prompted before it gets overwritten. Commit the
installed file with your project — it's part of the repo, not your local
config.

## How It Works

### Two-layer config

| Layer | File | What it covers |
|-------|------|----------------|
| Global | `~/.claude/CLAUDE.md` | Session start, big-changes-need-a-plan, wiki link convention, git conventions, skills reference. ~60 lines. |
| Project | `<repo>/CLAUDE.md` | Everything else: what artifacts the project maintains, what counts as "done," stack, code style, test command, reuse locations, key patterns. |

The global is intentionally minimal and project-agnostic. It does not assume
the project is software. It tells Claude to read the project CLAUDE.md first
and ASK before adopting opinions about stack, file layout, testing, or
workflow when the project is unfamiliar.

### What gets loaded when

| File | When loaded |
|------|-------------|
| `~/.claude/CLAUDE.md` | Every session |
| Project `CLAUDE.md` | Every session in that project |
| Docs the project CLAUDE.md calls out | Every session (per the project's session-start rules) |
| Reference docs (e.g., `design_system.md`) | When the project CLAUDE.md calls them out |
| Skills | Only when invoked via slash command |

### Session Start

The global tells Claude to do two things at session start:

1. Read the project-level `CLAUDE.md` if one exists.
2. Read whatever it tells you to read next.

Each profile's `CLAUDE.md` defines what step 2 looks like for that project shape.
The `nextjs-webapp` profile, for example, points at `docs/ARCHITECTURE.md`,
in-progress plans, P0 tasks, and the design system. A different profile might
point at a brief template, a brand reference, or a research question doc.

No database, no API, no agent framework — just markdown files in git.

### Per-Project Structure

The structure of `your-project/` is up to the profile. The `nextjs-webapp`
profile prescribes a `docs/` directory with ARCHITECTURE/TASKS/CHANGELOG/plans/
decisions/runbooks (scaffolded by `/init-docs`); other profiles can prescribe
something different, or nothing at all.

### Cross-Referencing with Wiki-Links

The global recommends `[[wiki-link]]` syntax for cross-references between
markdown files. It makes docs navigable in [Obsidian](https://obsidian.md/)
(clickable links, backlink panels, graph view) while staying plain text
everywhere else. Profiles use it freely (e.g., the web profile links plans,
ADRs, ARCHITECTURE, and TASKS to each other).

## Profiles

A profile is a small bundle of project-level files that pairs with the global
config. Each profile sets the stack-specific knobs the global intentionally
leaves blank: file naming, test commands, reuse locations, key patterns.

### Shipped profiles

**`nextjs-webapp`** — Next.js App Router + TypeScript strict + Tailwind +
shadcn/ui + Prisma. Includes a `design_system.md` template. Use this for new
web apps you're starting from scratch.

**`generic`** — A placeholder `CLAUDE.md` with TODO sections for stack, test
commands, code style, reuse locations, and key patterns. Use this when picking
up an unfamiliar repo or starting a project whose shape doesn't match the
other profiles. Ask Claude to inspect the repo and propose drafts for the
TODO sections.

### Adding your own profile

Profiles are just directories under `profiles/`. To create one:

1. `mkdir profiles/<name>` in this repo.
2. Add a `CLAUDE.md` with the project-level conventions for that shape of project.
3. Add any companion files (e.g., a template `design_system.md`, a starter
   `.editorconfig`) at the same level — `install.sh profile` copies every
   file in the profile directory to the target.
4. Run `./install.sh profile <name> <target>` to use it.

## Skills

### `/init-docs` — Scaffold Project Documentation

Creates the `docs/` directory structure for a new project, including
ARCHITECTURE.md, TASKS.md, CHANGELOG.md, and runbooks. If the project has
existing code, it analyzes the codebase to pre-populate ARCHITECTURE.md.

### `/plan` — Create a Change Plan

Creates a numbered plan document before implementation begins. Plans include
problem statement, approach, scope, risks, task breakdown, and test strategy.
After approval, automatically creates linked tasks.

**Plans are required when a change** (per the global config):
- Affects more than ~3 distinct artifacts
- Introduces a new external dependency, integration, or service
- Alters the underlying model the project is built around (data schema,
  content template, workflow steps — whatever applies)
- Estimated at more than ~30 minutes of work
- Could break existing functionality

Profiles may add their own project-shaped versions of these criteria (the
`nextjs-webapp` profile adds "changes an API contract" and "changes the data
model entities").

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

Enforces a strict red-green-refactor cycle. The workflow and patterns are
language-agnostic; the exact test command comes from the project CLAUDE.md.

The workflow: write tests → confirm RED → implement → confirm GREEN → refactor →
run full suite.

### `/design-ingest` — Extract Design Tokens

Frontend-specific. Analyzes reference screenshots or URLs and extracts design
tokens (colors, typography, spacing, radii, shadows, component patterns) into
the project's `design_system.md`.

## The Development Workflow

### New Project Setup

```
# 1. Create your project (example: Next.js)
npx create-next-app@latest my-app --typescript --tailwind --app --src-dir
cd my-app

# 2. Install the appropriate profile
~/.claude-code-setup/install.sh profile nextjs-webapp .

# 3. Scaffold docs
/init-docs

# 4. (Frontend only) save reference screenshots to docs/design/, then:
/design-ingest

# 5. Design the architecture
"Let's design the architecture for this app. [describe it].
Write docs/ARCHITECTURE.md with the full system design."

# 6. Record key tech decisions
/adr

# 7. Break v1 into plans
/plan    # "Auth setup"
/plan    # "Core data model"

# 8. Check your backlog
/tasks
```

### Daily Development

```
# Claude reads ARCHITECTURE.md, TASKS.md, checks plans (automatic)

/tasks       # What's P1?
/tdd         # Write tests first, then implement

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
| Setting up a new project | profile install + `/init-docs` |
| Establishing design direction | `/design-ingest` with reference screenshots |

## Key Design Decisions

### Why Plain Markdown, Not a Database

Every piece of project context is a markdown file committed with the code. This
means: it's version-controlled, it survives across sessions, it's searchable,
it's human-readable, and it costs nothing. No API calls, no memory databases,
no agent frameworks to maintain.

### Why a Minimal Global

An earlier version of this system kept everything (rituals, Next.js
conventions, TDD, maintainability, docs structure) in a single global
CLAUDE.md. That worked great for web apps and poorly for everything else —
picking up a Python data project, a content workflow for a client, or a
research repo meant Claude still assumed `pnpm test`, RSCs, a `docs/`
directory, and "data model entities" that didn't apply.

The current split puts only the genuinely universal stuff in the global:
session start, big-changes-need-a-plan, wiki links, git conventions. The
project's shape — what artifacts it maintains, what counts as "done,"
whether it has tests at all — is the profile's job to declare. The global
never assumes a software project; the profile says so when it is one.

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

- **Global `CLAUDE.md`** — adjust the rituals, git conventions, or maintainability
  rules. Keep it stack-agnostic so it travels across projects.
- **Profiles** — clone `profiles/nextjs-webapp/` or `profiles/generic/` into a
  new directory under `profiles/`, then edit the `CLAUDE.md` for the new stack.
  Run `./install.sh profile <new-name>` to use it.
- **Skills** — modify templates, add new fields, change the workflow. Add your own
  skills for patterns specific to your work.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (Claude Max plan
  or API key)
- A project using git
- [Obsidian](https://obsidian.md/) (recommended for doc navigation, not required)

## License

MIT
