---
description: Create an architecture decision record
---

Create a new ADR for this decision: $ARGUMENTS

Use `/adr` when choosing between technologies, data model designs, API patterns,
auth strategies, or any decision where someone might later ask "why did we do it
this way?" Plans ([[PLAN-NNN-slug]]) describe WHAT we're doing; ADRs explain WHY
we chose this approach.

Workflow:
- Look at `docs/decisions/` to determine the next ADR number (ADR-001, ADR-002, etc.). If `docs/decisions/` does not exist, create it.
- Ask the user to describe the decision context if they have not already.
- Create the ADR file at `docs/decisions/ADR-[NNN]-[slug].md`.
- Fill in all sections based on the discussion. Research the alternatives genuinely; do not list straw men.
- Present to the user. Once accepted, update Status to "Accepted."

Use this structure:

```markdown
# ADR-[NNN]-[slug]

**Date**: [today's date]
**Status**: Proposed
**Related**: [[PLAN-NNN-slug]] | [[ADR-NNN-slug]] (if applicable)

## Context

What situation or problem prompted this decision?

## Decision

What did we decide? One clear sentence, then elaboration.

## Alternatives Considered

| Alternative | Pros | Cons | Why not chosen |
|------------|------|------|----------------|
| | | | |

## Consequences

**Positive:**
-

**Negative / tradeoffs we're accepting:**
-

**What this makes easier or harder in the future:**
-
```

Rules:
- ADRs are never deleted. If a decision is reversed, create a new ADR with Status "Superseded by [[ADR-NNN-slug]]" and update the old ADR to note "**Status**: Superseded by [[ADR-NNN-slug]]".
- The Alternatives section must include at least 2 real alternatives with honest pros and cons.
- Keep Context and Decision sections concise. The value is in Alternatives and Consequences.
- Link to related plans with `[[PLAN-NNN-slug]]` and to related decisions with `[[ADR-NNN-slug]]` in the Related field.
