# Machine Setup

Full sequence to stand up a new machine, from bare OS to a working workspace.

## 1. GitHub CLI

Install `gh` (e.g. `brew install gh`), then authenticate:

```bash
gh auth login
```

Credentials must cover `theNickNance` and `BenaliHQ` private repos.

## 2. Agent config

```bash
gh repo clone theNickNance/claude-code-setup ~/Projects/Personal/Tooling/claude-code-setup
cd ~/Projects/Personal/Tooling/claude-code-setup
./install.sh all
```

This installs Claude Code, Codex, and OpenCode globals.

## 3. Benali workspace

```bash
./install.sh workspace
```

Clones `theNickNance/benali-workspace` into `~/Projects/Benali` and runs its
`bootstrap.sh`, which clones every leaf repo in the workspace manifest. Both
layers are idempotent — safe to re-run.

## 4. Secrets

Never in git. Copy by hand from the old machine or a password manager:

- `Products/benali-agent/.env`
- `Products/ops-map/.env.local`
- `Products/orchestrator/site/.env.local`
- `~/.config/benali/vercel.env`
- `gh auth login` (done in step 1) and `vercel login`

Bootstrap prints the current checklist at the end of its run — trust that
output over this list if they differ.

## 5. Workspace root context

`~/Projects/AGENTS.md` (with its `CLAUDE.md` symlink and `MAP.md`) sits outside
any repo — copy it manually. Its content can be recreated from
[[workspace-context-setup-prompt]] if the old machine is gone.
