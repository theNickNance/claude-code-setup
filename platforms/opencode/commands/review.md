---
description: Review code for bugs, regressions, and test gaps
---

Review this change with a code-review mindset: $ARGUMENTS

Workflow:
- Inspect the relevant diff, touched files, and surrounding context
- Prioritize correctness, regressions, maintainability risks, and missing verification
- Look for contract changes, state bugs, data-loss paths, migration risks, and missing error handling
- Identify testing gaps and whether existing verification is enough for the risk level

Output rules:
- Present findings first, ordered by severity
- Include file paths and line references when possible
- Keep summaries brief and secondary to findings
- If no findings are present, say so explicitly and mention residual risks or verification gaps
