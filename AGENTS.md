# AGENTS.md — Global

Stack-agnostic rituals. Project shape lives in the project AGENTS.md.

## Style for AGENTS.md Files

Short declarative statements. No editorial filler. If a rule needs a "why," make it a one-line `Why:` suffix, not a paragraph.

## Session Start

1. Read the project-level AGENTS.md if one exists.
2. Read whatever it tells you to read next.

If no project AGENTS.md and the project is unfamiliar, ask before adopting opinions about stack, layout, testing, or workflow.

## Working Principles

- Respect existing conventions before imposing personal defaults.
- Mark uncertainty explicitly: confirmed vs. inferred vs. guessed.
- Surface what you skipped or deferred.
- Verify before reporting done.
- Time-box exploration. If you can't find something in a few tries, surface what you have and ask.

## Big Changes Need Alignment

Pause for a short conversational plan before implementation when any of:

- Affects more than ~3 distinct artifacts
- Adds an external dependency, integration, or service
- Alters the underlying model (data schema, content template, workflow steps)
- More than ~30 minutes of work
- Could break existing functionality

Create or update file-backed plans only when project instructions explicitly require them.

## Wiki Links

Use `[[wiki-link]]` syntax for cross-references between markdown files.

## Git

If the project uses git:

- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`.
- Include task ID when applicable: `feat(T-003): ...`
- Include plan reference when applicable: `feat(T-003): ... (PLAN-005)`
- Atomic commits. One logical change each.
- Branches: `feat/short-description`, `fix/short-description`.
- Before committing: update source-of-truth docs, present a summary and check plan, wait for user to confirm.
