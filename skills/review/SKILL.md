---
name: review
description: Review code for bugs, regressions, maintainability risks, and missing verification; use when the user invokes /review or asks for a code review.
---

# /review — Code Review

When invoked, review the requested change with a code-review mindset.

## Workflow

1. Inspect the relevant diff, touched files, and surrounding context.
2. Prioritize correctness, regressions, maintainability risks, and missing verification.
3. Look for contract changes, state bugs, data-loss paths, migration risks, and missing error handling.
4. Identify testing gaps and whether existing verification is enough for the risk level.

## Output Rules

- Present findings first, ordered by severity.
- Include file paths and line references when possible.
- Keep summaries brief and secondary to findings.
- If no findings are present, say so explicitly and mention residual risks or verification gaps.
