# Design System — [Project Name]

> **This file is the single source of truth for all visual decisions.**
> Every color, spacing value, font, radius, shadow, and layout pattern in this project
> must come from this file. No improvisation. No defaults. If it's not here, ask before using it.

## Reference

<!-- 
HOW TO USE THIS SECTION:
When starting a new project, populate this section with your visual references.
Claude Code can read image files, so save screenshots to the repo.

For each reference, note WHAT you like about it — not just "I like this."
Be specific: "I like the density of the sidebar nav" or "I want this exact card shadow treatment."
-->

**Primary reference**: <!-- e.g., screenshots/reference-dashboard.png — "Linear's project view. I want this level of density and the muted color approach." -->

**Secondary references**: <!-- Additional screenshots or URLs with specific callouts -->

**Mood**: <!-- One sentence. e.g., "Dense, professional, slightly dark. Think Linear meets Notion, not Stripe marketing page." -->

---

## Tokens

### Colors

<!-- 
INSTRUCTIONS FOR POPULATING:
Extract colors from your reference UI. Use a color picker on your screenshots.
Define semantic names, not raw values. Claude must use ONLY these names in code.
Map these to Tailwind config extensions and CSS variables.
-->

```css
/* --- CSS Variables (put in globals.css) --- */
:root {
  /* Backgrounds */
  --bg-base:              #FFFFFF;     /* Main page background */
  --bg-surface:           #F8F9FA;     /* Cards, panels, secondary surfaces */
  --bg-surface-elevated:  #FFFFFF;     /* Modals, dropdowns, popovers */
  --bg-surface-sunken:    #F1F3F5;     /* Inset areas, code blocks, table stripes */
  --bg-inverse:           #1A1A2E;     /* Dark surfaces, dark mode base */

  /* Text */
  --text-primary:         #111827;     /* Headings, primary content */
  --text-secondary:       #6B7280;     /* Descriptions, helper text, metadata */
  --text-tertiary:        #9CA3AF;     /* Placeholders, disabled text */
  --text-inverse:         #F9FAFB;     /* Text on dark backgrounds */
  --text-link:            #2563EB;     /* Links — must pass WCAG AA on bg-base */

  /* Brand / Accent */
  --accent-primary:       #2563EB;     /* Primary buttons, active states, key actions */
  --accent-primary-hover: #1D4ED8;     /* Hover state for primary accent */
  --accent-primary-subtle:#EFF6FF;     /* Light accent bg — tags, badges, highlights */
  --accent-secondary:     #7C3AED;     /* Secondary accent — less dominant than primary */

  /* Semantic */
  --color-success:        #059669;
  --color-success-subtle: #ECFDF5;
  --color-warning:        #D97706;
  --color-warning-subtle: #FFFBEB;
  --color-error:          #DC2626;
  --color-error-subtle:   #FEF2F2;
  --color-info:           #2563EB;
  --color-info-subtle:    #EFF6FF;

  /* Borders */
  --border-default:       #E5E7EB;     /* Standard borders */
  --border-subtle:        #F3F4F6;     /* Very subtle dividers */
  --border-strong:        #D1D5DB;     /* Emphasized borders, focus rings */
  --border-accent:        #2563EB;     /* Active/selected borders */
}

/* --- Dark mode overrides (if applicable) --- */
[data-theme="dark"], .dark {
  --bg-base:              #0F0F1A;
  --bg-surface:           #1A1A2E;
  --bg-surface-elevated:  #252540;
  --bg-surface-sunken:    #0A0A15;
  --text-primary:         #F0F0F5;
  --text-secondary:       #8888A0;
  --text-tertiary:        #555570;
  --border-default:       #2A2A40;
  --border-subtle:        #1F1F35;
  --border-strong:        #3A3A55;
  /* ...override all tokens that change in dark mode */
}
```

**Tailwind config mapping** — extend in `tailwind.config.ts`:
```ts
// tailwind.config.ts
const config = {
  theme: {
    extend: {
      colors: {
        bg: {
          base: 'var(--bg-base)',
          surface: 'var(--bg-surface)',
          'surface-elevated': 'var(--bg-surface-elevated)',
          'surface-sunken': 'var(--bg-surface-sunken)',
          inverse: 'var(--bg-inverse)',
        },
        text: {
          primary: 'var(--text-primary)',
          secondary: 'var(--text-secondary)',
          tertiary: 'var(--text-tertiary)',
          inverse: 'var(--text-inverse)',
          link: 'var(--text-link)',
        },
        accent: {
          primary: 'var(--accent-primary)',
          'primary-hover': 'var(--accent-primary-hover)',
          'primary-subtle': 'var(--accent-primary-subtle)',
          secondary: 'var(--accent-secondary)',
        },
        semantic: {
          success: 'var(--color-success)',
          'success-subtle': 'var(--color-success-subtle)',
          warning: 'var(--color-warning)',
          'warning-subtle': 'var(--color-warning-subtle)',
          error: 'var(--color-error)',
          'error-subtle': 'var(--color-error-subtle)',
          info: 'var(--color-info)',
          'info-subtle': 'var(--color-info-subtle)',
        },
        border: {
          DEFAULT: 'var(--border-default)',
          subtle: 'var(--border-subtle)',
          strong: 'var(--border-strong)',
          accent: 'var(--border-accent)',
        },
      },
    },
  },
}
```

**Usage in code** — ALWAYS use semantic names:
```tsx
// ✅ CORRECT
<div className="bg-bg-surface text-text-primary border border-border">
<button className="bg-accent-primary hover:bg-accent-primary-hover text-text-inverse">

// ❌ WRONG — raw Tailwind colors
<div className="bg-gray-50 text-gray-900 border border-gray-200">
<button className="bg-blue-600 hover:bg-blue-700 text-white">
```

### Typography

```css
:root {
  /* Font families — NEVER change these without explicit approval */
  --font-display:     'Inter', sans-serif;      /* Headings, titles */
  --font-body:        'Inter', sans-serif;      /* Body text, UI */
  --font-mono:        'JetBrains Mono', monospace; /* Code, data, IDs */

  /* Type scale — based on a 1.25 ratio (Major Third) */
  --text-xs:    0.75rem;    /* 12px — Captions, fine print */
  --text-sm:    0.875rem;   /* 14px — Secondary text, table cells, metadata */
  --text-base:  1rem;       /* 16px — Body text, form inputs */
  --text-lg:    1.125rem;   /* 18px — Emphasized body, card titles */
  --text-xl:    1.25rem;    /* 20px — Section headers */
  --text-2xl:   1.5rem;     /* 24px — Page section titles */
  --text-3xl:   1.875rem;   /* 30px — Page titles */
  --text-4xl:   2.25rem;    /* 36px — Hero/dashboard titles (rare) */

  /* Line heights */
  --leading-tight:   1.25;  /* Headings */
  --leading-normal:  1.5;   /* Body text */
  --leading-relaxed: 1.625; /* Long-form reading */

  /* Font weights */
  --weight-normal:   400;
  --weight-medium:   500;   /* UI labels, table headers, subtle emphasis */
  --weight-semibold: 600;   /* Headings, buttons, strong emphasis */
  --weight-bold:     700;   /* Sparingly — page titles only */
}
```

**Type pairings** — use these exact combinations:
| Context | Size | Weight | Leading | Font |
|---------|------|--------|---------|------|
| Page title | text-3xl | semibold | tight | display |
| Section title | text-xl | semibold | tight | display |
| Card title | text-lg | medium | tight | display |
| Body | text-base | normal | normal | body |
| Secondary/meta | text-sm | normal | normal | body |
| Caption/badge | text-xs | medium | normal | body |
| Code/data | text-sm | normal | normal | mono |
| Button | text-sm | medium | tight | body |
| Input label | text-sm | medium | normal | body |
| Input value | text-base | normal | normal | body |

### Spacing

Use a **4px base unit**. All spacing must be a multiple of 4px.

| Token | Value | Tailwind | Use for |
|-------|-------|----------|---------|
| space-0 | 0px | `0` | — |
| space-1 | 4px | `1` | Inline icon gaps, tightest spacing |
| space-2 | 8px | `2` | Between related elements (label↔input, icon↔text) |
| space-3 | 12px | `3` | Inner padding on compact components (badges, pills) |
| space-4 | 16px | `4` | Default inner padding (cards, table cells, inputs) |
| space-5 | 20px | `5` | — |
| space-6 | 24px | `6` | Section padding, gap between cards in a grid |
| space-8 | 32px | `8` | Between major sections on a page |
| space-10 | 40px | `10` | — |
| space-12 | 48px | `12` | Page-level vertical padding |
| space-16 | 64px | `16` | Large section breaks |

**Rules:**
- Card inner padding: `p-4` (compact) or `p-6` (standard). Never `p-3` or `p-5`.
- Gap between cards in a grid: `gap-4` (compact) or `gap-6` (standard). Pick one per page, don't mix.
- Page horizontal padding: `px-6` on desktop, `px-4` on mobile.
- Space between a heading and its content: `mb-4` or `mb-6`. Never `mb-2` for headings.
- Consistent vertical rhythm: within a section, use ONE spacing value for gaps between siblings.

### Border Radius

| Token | Value | Tailwind | Use for |
|-------|-------|----------|---------|
| radius-sm | 4px | `rounded-sm` | Badges, pills, inline tags |
| radius-md | 6px | `rounded-md` | Buttons, inputs, selects |
| radius-lg | 8px | `rounded-lg` | Cards, modals, dropdowns |
| radius-xl | 12px | `rounded-xl` | Hero cards, featured sections |
| radius-full | 9999px | `rounded-full` | Avatars, circular indicators |

**Rule:** Pick ONE radius for cards across the entire app. Don't mix `rounded-lg` and `rounded-xl` on different cards.

### Shadows

```css
:root {
  --shadow-sm:   0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md:   0 4px 6px -1px rgba(0, 0, 0, 0.07), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
  --shadow-lg:   0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -4px rgba(0, 0, 0, 0.04);
  --shadow-xl:   0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.04);
}
```

| Context | Shadow |
|---------|--------|
| Cards (resting) | `shadow-sm` or no shadow (border only) — pick one approach for the project |
| Cards (hover, if interactive) | `shadow-md` |
| Dropdowns, popovers | `shadow-lg` |
| Modals, command palette | `shadow-xl` |

**Rule:** Never combine a border AND a heavy shadow. Pick one elevation strategy: border-based (subtle, Linear-style) or shadow-based (Material-style). Don't mix.

---

## Component Patterns

### Cards

```tsx
// Standard card — the most common surface in the app
<div className="bg-bg-surface-elevated border border-border rounded-lg p-6">
  <h3 className="text-lg font-medium text-text-primary mb-1">Card Title</h3>
  <p className="text-sm text-text-secondary mb-4">Description or metadata</p>
  {/* Card content */}
</div>

// Compact card — for grids with many items
<div className="bg-bg-surface-elevated border border-border rounded-lg p-4">
  {/* Tighter padding, smaller text sizes */}
</div>

// Interactive card — clickable
<div className="bg-bg-surface-elevated border border-border rounded-lg p-6
                hover:border-border-strong hover:shadow-md transition-all cursor-pointer">
  {/* Same as standard but with hover treatment */}
</div>
```

**Card anti-patterns:**
- NEVER use `bg-white`. Use `bg-bg-surface-elevated`.
- NEVER mix card padding values on the same page.
- NEVER put a shadow on a card that also has a visible border in the resting state (pick one).

### Data Tables

```tsx
// Table container
<div className="border border-border rounded-lg overflow-hidden">
  <table className="w-full">
    <thead>
      <tr className="bg-bg-surface-sunken border-b border-border">
        <th className="text-left text-xs font-medium text-text-secondary uppercase tracking-wider px-4 py-3">
          Column Header
        </th>
      </tr>
    </thead>
    <tbody className="divide-y divide-border-subtle">
      <tr className="hover:bg-bg-surface transition-colors">
        <td className="px-4 py-3 text-sm text-text-primary">Cell content</td>
      </tr>
    </tbody>
  </table>
</div>
```

**Table rules:**
- Header text: `text-xs uppercase tracking-wider font-medium text-text-secondary`
- Cell text: `text-sm text-text-primary`
- Cell padding: `px-4 py-3` — consistent across all cells.
- Row dividers: `divide-border-subtle`, not full `border-border`.
- Hover: `hover:bg-bg-surface` on `<tr>` for interactive tables.

### Forms & Inputs

```tsx
// Standard input pattern
<div className="space-y-1.5">
  <label className="text-sm font-medium text-text-primary">Label</label>
  <input
    className="w-full px-3 py-2 text-base text-text-primary bg-bg-base
               border border-border rounded-md
               focus:outline-none focus:ring-2 focus:ring-accent-primary/20 focus:border-border-accent
               placeholder:text-text-tertiary"
    placeholder="Placeholder text"
  />
  <p className="text-xs text-text-secondary">Helper text if needed</p>
</div>
```

**Form rules:**
- Label and input gap: `space-y-1.5` (6px).
- Between form fields: `space-y-4` (16px).
- Input height: let padding define it (`py-2` = ~40px total). Never set explicit heights.
- Focus ring: always `ring-accent-primary` with opacity. Never browser default.
- Error state: `border-semantic-error` + error message below in `text-semantic-error text-xs`.

### Buttons

```tsx
// Primary
<button className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium
                   bg-accent-primary text-text-inverse rounded-md
                   hover:bg-accent-primary-hover transition-colors">
  Button Label
</button>

// Secondary
<button className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium
                   bg-bg-base text-text-primary border border-border rounded-md
                   hover:bg-bg-surface transition-colors">
  Button Label
</button>

// Ghost
<button className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium
                   text-text-secondary rounded-md
                   hover:bg-bg-surface hover:text-text-primary transition-colors">
  Button Label
</button>
```

**Button rules:**
- All buttons: `text-sm font-medium`. Never `text-base` for buttons.
- Icon + text gap: `gap-2`. Icon size: 16px (`w-4 h-4`).
- Only ONE primary button per visible area/section.
- Consistent padding: `px-4 py-2` standard, `px-3 py-1.5` compact.

### Page Layout

```tsx
// Standard page template
<div className="min-h-screen bg-bg-base">
  {/* Top nav or sidebar — defined by project layout */}
  <main className="max-w-7xl mx-auto px-6 py-8">
    {/* Page header */}
    <div className="mb-8">
      <h1 className="text-3xl font-semibold text-text-primary">Page Title</h1>
      <p className="text-text-secondary mt-1">Page description</p>
    </div>

    {/* Page content */}
    <div className="space-y-8">
      {/* Sections separated by space-y-8 */}
    </div>
  </main>
</div>
```

---

## Layout Patterns

### Sidebar + Content

```tsx
<div className="flex h-screen">
  <aside className="w-60 border-r border-border bg-bg-surface flex-shrink-0">
    {/* Sidebar nav */}
  </aside>
  <main className="flex-1 overflow-auto">
    {/* Page content */}
  </main>
</div>
```

- Sidebar width: `w-60` (240px) standard. `w-64` (256px) if sidebar has dense content.
- Sidebar background: `bg-bg-surface`, NOT the same as main content.
- Border between sidebar and content: `border-r border-border`.

### Card Grid

```tsx
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  {/* Cards */}
</div>
```

- Always define responsive breakpoints. Never a fixed column count.
- Gap matches card padding: if cards use `p-6`, grid uses `gap-6`.

---

## Interaction Patterns

### Hover States
- Interactive cards: `hover:border-border-strong` + optional `hover:shadow-md`
- Table rows: `hover:bg-bg-surface`
- Buttons: defined per variant above
- Links: `hover:text-accent-primary-hover` + underline on hover (or remove underline on hover if always underlined)
- All hover transitions: `transition-colors` or `transition-all` with default duration

### Focus States
- Inputs: `focus:ring-2 focus:ring-accent-primary/20 focus:border-border-accent`
- Buttons: same ring treatment
- Never rely on browser defaults for focus indicators

### Active/Selected States
- Selected nav item: `bg-accent-primary-subtle text-accent-primary font-medium`
- Selected table row: `bg-accent-primary-subtle`
- Active tab: bottom border `border-b-2 border-accent-primary`

---

## Anti-Patterns — HARD RULES

1. **NO raw Tailwind colors.** Never `bg-blue-500`, `text-gray-600`, etc. Only semantic tokens.
2. **NO mixing spacing systems.** If a section uses `gap-6`, every card in it uses `p-6`. No exceptions.
3. **NO inconsistent border radii.** All cards on a page use the same radius.
4. **NO `text-black` or `text-white`.** Use `text-text-primary` and `text-text-inverse`.
5. **NO shadows on components that also have borders** (pick one elevation strategy).
6. **NO font sizes outside the type scale.** If you need a size not in the scale, ask first.
7. **NO color for decoration.** Every use of color must carry meaning (status, emphasis, interactivity).
8. **NO layout shifts between loading and loaded states.** Skeletons must match the dimensions of real content.
9. **NO orphaned styles.** If you add a new visual treatment, it must be documented here first.
10. **NO "close enough."** If the design system says `p-4`, it's `p-4`, not `p-[18px]`.

---

## Ingesting a New Reference UI

<!--
WORKFLOW: When you have a screenshot, Figma export, or URL you want Claude to match:

1. Save the screenshot to the repo: `docs/design/reference-[name].png`
2. Open Claude Code and paste this prompt:

   "Look at docs/design/reference-[name].png. Extract the following and format
   them as updates to design_system.md:
   - Color palette (sample every distinct color, assign semantic names)
   - Typography (identify fonts, sizes, weights used for each text level)
   - Spacing rhythm (measure padding and gaps between elements)
   - Border radii
   - Shadow treatment
   - Any distinctive patterns (how are cards styled? tables? nav items?)
   
   Output the updates as replacement sections for design_system.md, keeping
   the existing structure. I will review before applying."

3. Review Claude's extracted tokens against the screenshot.
4. Update this file with the approved values.
5. Update tailwind.config.ts to match.

This is a ONE-TIME process per project. Once the tokens are set, they don't change
without explicit approval.
-->
