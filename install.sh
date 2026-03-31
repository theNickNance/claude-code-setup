#!/bin/bash
# install.sh — Copy CLAUDE.md and skills to ~/.claude/
# Run from the repo root: ./install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Prompt before overwriting an existing file. Skips if user declines.
safe_copy() {
  local src="$1"
  local dest="$2"
  local label="$3"

  if [[ -f "$dest" ]]; then
    read -r -p "⚠ $label already exists. Overwrite? [y/N] " answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      echo "  Skipped $label"
      return
    fi
  fi

  cp "$src" "$dest"
  echo "✓ Copied $label"
}

# Create ~/.claude/ if it doesn't exist
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/templates"

# Copy global CLAUDE.md
safe_copy "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" "~/.claude/CLAUDE.md"

# Copy each skill
skill_count=0
shopt -s nullglob
for skill_dir in "$SCRIPT_DIR"/skills/*/; do
  skill_name=$(basename "$skill_dir")
  mkdir -p "$CLAUDE_DIR/skills/$skill_name"
  safe_copy "$skill_dir/SKILL.md" "$CLAUDE_DIR/skills/$skill_name/SKILL.md" "skill: $skill_name"
  skill_count=$((skill_count + 1))
done
shopt -u nullglob

# Copy templates
safe_copy "$SCRIPT_DIR/templates/design_system.md" "$CLAUDE_DIR/templates/design_system.md" "~/.claude/templates/design_system.md"

if [[ "$skill_count" -eq 0 ]]; then
  echo ""
  echo "No skills found in $SCRIPT_DIR/skills/."
else
  echo ""
  echo "Done. $skill_count skill(s) processed."
fi

echo ""
echo "To verify: ls ~/.claude/skills/"
