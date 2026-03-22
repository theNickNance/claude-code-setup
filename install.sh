#!/bin/bash
# install.sh — Copy CLAUDE.md and skills to ~/.claude/
# Run from the repo root: ./install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Create ~/.claude/ if it doesn't exist
mkdir -p "$CLAUDE_DIR/skills"

# Copy global CLAUDE.md
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "✓ Copied CLAUDE.md → ~/.claude/CLAUDE.md"

# Copy each skill
for skill_dir in "$SCRIPT_DIR"/skills/*/; do
  skill_name=$(basename "$skill_dir")
  mkdir -p "$CLAUDE_DIR/skills/$skill_name"
  cp "$skill_dir/SKILL.md" "$CLAUDE_DIR/skills/$skill_name/SKILL.md"
  echo "✓ Copied $skill_name skill → ~/.claude/skills/$skill_name/"
done

echo ""
echo "Done. $(ls -d "$SCRIPT_DIR"/skills/*/ | wc -l | tr -d ' ') skills installed."
echo ""
echo "To verify: ls ~/.claude/skills/"
