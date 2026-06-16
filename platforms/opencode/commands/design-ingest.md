---
description: Extract design tokens from reference UI
---

Analyze reference screenshots or URLs and populate the project's [[design_system]]
(`design_system.md`) with extracted design tokens.

Request details: $ARGUMENTS

Workflow:
- Find references. Check `docs/design/` for screenshots. If none exist, ask the user to provide screenshots or a URL to reference.
- For every image or URL, extract colors, typography, spacing, borders, shadows, and distinctive component patterns.
- Format the extracted tokens as replacement values for the existing `design_system.md` section structure.
- Present the extracted tokens alongside the reference image so the user can verify accuracy. Call out anything uncertain.
- Once approved, update [[design_system]] with the approved tokens.
- If needed, update `tailwind.config.ts`, `globals.css`, and font imports in `layout.tsx`.

Extract:
- Colors: backgrounds, text, accent/brand, borders, semantic colors.
- Typography: heading vs. body font, size scale, weight usage, letter spacing.
- Spacing: card padding, grid gaps, page margins, max-width, section spacing, form spacing.
- Borders: radii, widths, colors, border vs. shadow elevation.
- Shadows: resting, hover, dropdown, modal treatments.
- Patterns: sidebars, tables, nav items, badges, buttons.

Rules:
- Always note what specific reference each token was extracted from.
- If two references conflict, flag it and ask which to use.
- Err on the side of slightly tighter spacing estimates. Agents tend to over-estimate padding.
- Check font identification carefully. If unsure, suggest the 2-3 most likely candidates and ask the user to confirm.
- This is a one-time process per project. Once tokens are set, they do not change without explicit approval.
