# /design-ingest — Extract Design Tokens from Reference UI

When invoked, analyze reference screenshots or URLs and populate the project's
[[design_system]] (`design_system.md`) with extracted design tokens.

## Steps

1. **Find references.** Check `docs/design/` for screenshots. If none exist,
   ask the user to provide screenshots or a URL to reference.

2. **Analyze each reference.** For every image or URL, extract:

   **Colors:**
   - Background colors (page bg, card bg, sunken/elevated surfaces)
   - Text colors (primary, secondary, muted, inverse)
   - Accent/brand colors (primary action, hover states, subtle highlights)
   - Border colors
   - Semantic colors (success, error, warning, info) if visible

   **Typography:**
   - Heading font vs. body font (or if same)
   - Size scale: estimate px for each visible text level
   - Weight usage: where is bold, medium, normal used?
   - Letter spacing or tracking on headers

   **Spacing:**
   - Card inner padding
   - Grid gaps between cards
   - Page margins and max-width
   - Section spacing
   - Form field spacing

   **Borders:**
   - Border radius values (cards, buttons, inputs)
   - Border widths and colors
   - Whether the design uses borders or shadows for elevation

   **Shadows:**
   - Shadow values for resting cards, hover, dropdowns, modals
   - Whether the design is border-based or shadow-based (don't mix)

   **Distinctive patterns:**
   - Sidebar treatment (width, bg, border)
   - Table styling (headers, rows, hover, dividers)
   - Nav item styling (active, hover, selected)
   - Badge/tag/status indicator treatments
   - Button variants and sizing

3. **Format as [[design_system]] updates.** Output the extracted tokens as
   replacement values for the design_system.md template. Use the exact
   section structure from the existing [[design_system]].

4. **Present for review.** Show the extracted tokens alongside the reference
   image so the user can verify accuracy. Call out anything uncertain.

5. **Apply.** Once approved:
   - Update [[design_system]] with the approved tokens
   - Update `tailwind.config.ts` with the color/spacing extensions
   - Update `globals.css` with CSS variables
   - Update font imports in `layout.tsx` if fonts changed

## Rules

- Always note what specific reference each token was extracted from.
- If two references conflict (e.g., different card radii), flag it and ask
  which to use.
- Err on the side of slightly tighter spacing estimates. Claude tends to
  over-estimate padding.
- Check font identification carefully. If unsure, suggest the 2-3 most
  likely candidates and ask the user to confirm.
- This is a ONE-TIME process per project. Once tokens are set, they don't
  change without explicit approval.
