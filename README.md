# Agent Config Setup

A unified configuration repo for Claude Code, Codex, and OpenCode.

The goal is one source of truth for durable agent behavior:

- shared global rituals
- shared project profiles
- shared templates
- platform-specific install adapters

## Repository Shape

```text
AGENTS.md                         # Shared global rules for AGENTS.md platforms
CLAUDE.md                         # Shared global rules for Claude Code
install.sh                        # Installer for Claude, Codex, OpenCode, or all
skills/                           # Shared agent skills / slash workflows
  plan/SKILL.md
  tasks/SKILL.md
  adr/SKILL.md
  review/SKILL.md
  init-docs/SKILL.md
  tdd/SKILL.md
  design-ingest/SKILL.md
templates/
  design_system.md                # Shared frontend design-system template
profiles/
  generic/
    AGENTS.md
    CLAUDE.md
  nextjs-webapp/
    AGENTS.md
    CLAUDE.md
    design_system.md
platforms/
  codex/
    config.snippet.toml
  opencode/
    opencode.json
    commands/*.md
    templates/design_system.md
```

## Install

Install one platform:

```bash
./install.sh claude
./install.sh codex
./install.sh opencode
```

Install everything:

```bash
./install.sh all
```

Preview or verify:

```bash
./install.sh --dry-run all
./install.sh --verify all
./install.sh --sync all
```

Default behavior is backward-compatible:

```bash
./install.sh
```

This installs the Claude Code setup.

## Install Targets

| Target | Destination |
|--------|-------------|
| Claude global rules | `~/.claude/CLAUDE.md` |
| Claude templates | `~/.claude/templates/` |
| Codex global rules | `~/.codex/AGENTS.md` |
| Codex templates | `~/.codex/templates/` |
| Codex config merge | `~/.codex/config.toml` |
| OpenCode global rules | `~/.config/opencode/AGENTS.md` |
| OpenCode config | `~/.config/opencode/opencode.json` |
| OpenCode templates | `~/.config/opencode/templates/` |

Codex config is merged instead of replaced. The managed setting is:

```toml
project_doc_fallback_filenames = ["CLAUDE.md"]
```

This lets Codex read older project-level `CLAUDE.md` files when no `AGENTS.md`
exists.

## Project Profiles

Profiles install project-level instruction files and companion templates.

```bash
./install.sh list
./install.sh profile generic ~/code/some-repo
./install.sh profile nextjs-webapp ~/code/my-app
```

By default, profiles install both `AGENTS.md` and `CLAUDE.md`.

Choose one instruction file type when needed:

```bash
./install.sh profile nextjs-webapp ~/code/my-app agents
./install.sh profile nextjs-webapp ~/code/my-app claude
```

Commit installed profile files with the project. They are project source of
truth, not machine-local state.

## Workflow Source Files

| Command | Purpose |
|---------|---------|
| `/init-docs` | Scaffold project docs |
| `/plan` | Create a change plan |
| `/tasks` | Track tasks |
| `/adr` | Record an architecture decision |
| `/review` | Review code for bugs and regressions |
| `/tdd` | Test-driven development workflow |
| `/design-ingest` | Extract design tokens from references |

Workflow files are source material for project-specific setup.

They are not installed globally by default. This prevents tools like Codex from
seeing `/plan`, `/tasks`, `/adr`, and similar workflows in every unrelated
session.

Claude and Codex workflow source files live under `skills/*/SKILL.md`.

OpenCode command source files live under `platforms/opencode/commands/*.md`.

## Working Model

The global files stay intentionally small and stack-agnostic.

Project shape belongs in project profiles:

- what to read at session start
- what counts as done
- test commands
- code style
- docs to maintain
- reuse locations
- approved patterns

Use `AGENTS.md` for Codex and OpenCode projects. Keep `CLAUDE.md` for Claude
Code compatibility. During migration, both can exist.

## Migration From Separate Repos

This repo supersedes the separate `open-code-setup` repo.

Imported OpenCode assets:

- `opencode.json`
- `commands/*.md`
- `templates/design_system.md`
- AGENTS-style global rules

The command files are retained as source material, not installed globally by
default.

The old OpenCode repo can remain as an archive after this repo is pushed and
installed successfully.

## Verification

Run:

```bash
bash -n install.sh
./install.sh --dry-run all
./install.sh --verify claude
./install.sh --verify codex
./install.sh --verify opencode
```

`--verify` reports `OK`, `DRIFT`, or `MISSING` for managed files.
