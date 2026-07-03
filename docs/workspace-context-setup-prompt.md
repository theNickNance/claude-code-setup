# Workspace Context Setup — Shareable Prompt

A reusable prompt that walks someone from scattered project files to a nested, context-aware
workspace (the `AGENTS.md` + `CLAUDE.md` symlink + `MAP.md` pattern at every level, plus
scope-knowledge files and live-context connectors).

**Origin:** distilled from the `~/Projects` setup (Benali / Personal / Archive tree). The value is
in the discovery *dialogue* — the prompt extracts groupings and judgment calls from the user rather
than guessing a taxonomy.

**How to use:** hand the section below to a friend to paste into Claude Code (or any capable agent).
They can run it from anywhere — Phase 0 sets up the root folder first. Scales down (2–3 levels,
right-sized). Stack/domain-agnostic.

---

**Goal:** My projects are scattered across my machine — Desktop, Documents, Downloads, loose
folders. I want you to help me (1) establish a single root workspace folder and gather my work into
it, then (2) turn that into a nested, context-aware workspace so an AI agent working *anywhere* in
the tree automatically has the right context — what each thing is, how it relates to everything
else, and how I want work done there. Don't do it all at once; work through it with me.

**Phase 0 — Establish the home and gather into it.**
1. I don't have a single place for my projects yet. **Be opinionated:** recommend creating one root
   workspace folder (default: `~/Projects`) and consolidating my real work under it. Explain briefly
   why a single root beats scattered folders (one place for agents to orient, clean nesting, no
   stuff lost on the Desktop).
2. Scan the likely scatter spots — `~/Desktop`, `~/Documents`, `~/Downloads`, and any other folder I
   name — and list every candidate project or work folder you find, with where it currently lives.
3. For each, ask me: **move it, leave it, or ignore it?** Don't sweep up personal/non-project files.
   Propose `mv` (not copy) for things I confirm, so I don't end up with duplicates — but show me the
   moves and wait for approval before running any. Preserve each project's `.git` exactly as-is when
   moving.
4. Flag anything risky: a folder that's actually a git repo with uncommitted changes, something
   currently open/in use, symlinks, or huge directories. Surface these before moving.

**Phase 1 — Discover (don't write anything yet).** Once things are gathered under the root:
1. List every folder and loose file at the root. For each project, infer: what it is, whether it's
   active / paused / reference, its tech or medium, and whether it's a git repo.
2. Ask me to confirm or correct your inferences, and to tell you the *groupings* that make sense to
   me (e.g. by venture, by client, work vs. personal, active vs. archived). Don't guess the
   taxonomy — the grouping is mine to decide.
3. Surface anything ambiguous: overloaded names, things that look dead, projects that seem to belong
   to two groups.

**Phase 2 — Propose a structure.** Based on my groupings, propose a folder hierarchy with 2–3 levels
(workspace root → group → sub-arm → leaf project). Show it to me as a tree and wait for approval
before moving any files. Note which folders are "umbrella" folders (organizational only) vs. real
git repos — **never run `git init` on an umbrella folder, and never move a project's `.git`.**

**Phase 3 — Lay down the context files.** At *every* level of the tree (root and each group/arm),
create three files. Keep them short — declarative statements, no filler. Match this pattern:

- **`AGENTS.md`** — *the real file.* States: what this scope is (1–2 lines), how to navigate down
  into it, the read-order for someone starting work here, and any conventions/guardrails specific to
  this scope. At the root, it explains the whole structure convention so an agent landing cold can
  orient.
- **`CLAUDE.md`** — a *symlink* to `AGENTS.md` in the same folder (`ln -s AGENTS.md CLAUDE.md`).
  Why: one source of truth, and both Claude Code and other agent tools resolve their expected
  filename.
- **`MAP.md`** — a one-line-per-child overview of what's directly inside this folder. For groups with
  many leaf projects, use a table with `Project | What | Status` columns. For archived/paused
  folders, add a `Why archived` column.

**Phase 4 — Add scope-knowledge files where there's real context to capture.** Beyond the navigation
files, create topic files at the level where they're true — only where they earn their place.
Examples of the *kinds* of things worth a dedicated file (adapt to my actual work):
- An **overview** of the main entity (what it is, its core offering, its glossary of overloaded
  terms).
- **People / roles**, **clients / pipeline**, **canonical links & accounts** — facts an agent
  shouldn't fabricate.
- **Stacks / tech-per-project**, **how we build** (workflow), or **voice/style** for writing-heavy
  work.

Apply these rules to every context file:
- **Confirmed vs. inferred.** State only confirmed facts plainly; explicitly mark anything you
  inferred or guessed.
- **Recency-bias guard.** If something is the *core* of the work vs. a *side bet/experiment*, say so
  loudly — so recent activity on a side project doesn't get mistaken for the main thing.
- **Disambiguate overloaded names** in a glossary (two different things sharing a name, etc.).
- **Convert relative dates to absolute** ("last month" → the actual month/year).
- **Cross-link related files** with `[[wiki-link]]` syntax.
- **No duplication.** Context that belongs to one leaf repo stays in that repo's own `CLAUDE.md`;
  don't copy it upward. Higher levels point down, leaf repos hold their own detail.
- End each file with a one-line note on **how to keep it from going stale** (update here + the
  affected leaf when direction changes).

**Phase 5 — Suggest live-context connectors.** Static notes go stale; some context is better pulled
from the source. Look at what I actually work on and recommend external tools worth connecting so an
agent can pull live context — and, importantly, *which scope* each one serves and what it should and
shouldn't touch. Consider:
- **Gmail** — client threads, vendor comms, decisions buried in email. (Which senders/labels matter?
  Anything off-limits?)
- **Calendar** — meetings, deadlines, who I'm talking to and when.
- **Drive / Docs / Notion / Sheets** — proposals, specs, knowledge bases that live outside the repos.
- **Issue trackers / project tools** (GitHub, Linear, Jira) and **messaging** (Slack) if I use them.

For each one you recommend: tell me *why* it helps given my projects, *where* it's relevant (which
group/arm), and how to wire it up (e.g. Claude Code MCP connectors — say `/mcp` to manage them, or
point me at the relevant setup). Then, in the `AGENTS.md` for the scopes that benefit, add a short
**"Live context"** section noting which connector to use for what (e.g. "client facts: check
`clients.md` first, then Gmail thread with the client; never fabricate"). Don't connect anything
yourself or assume access — recommend, explain, and let me authorize. Flag any privacy/scope
concerns (a personal inbox feeding a work agent, etc.).

**Phase 6 — Verify.** Walk the final tree back to me: confirm everything I chose to move actually
landed under the root (nothing left stranded, no duplicates), every level has `AGENTS.md` +
`CLAUDE.md` symlink + `MAP.md`, every symlink resolves, no `.git` was moved or created in an umbrella
folder, and the read-order in each `AGENTS.md` actually points to files that exist. List the
connectors you recommended and their status (suggested / connected / declined). Tell me what you
deliberately left out or deferred.

**Working style throughout:** Respect what's already there before imposing structure. Pause and check
with me before big moves (moving files, deleting anything, creating the hierarchy, connecting
external accounts). Moves are reversible only if I know about them — always show the `mv` commands
before running them. When you're unsure how I think about something, ask — don't invent a taxonomy
and run with it.
