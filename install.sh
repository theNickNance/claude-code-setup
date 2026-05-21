#!/bin/bash
# install.sh — Install Claude Code setup
#
# Usage:
#   ./install.sh                              Install global config to ~/.claude/
#   ./install.sh global                       Same as above (explicit)
#   ./install.sh profile <name> [target-dir]  Install a project profile
#                                             target-dir defaults to current directory
#   ./install.sh list                         List available profiles
#
# Examples:
#   ./install.sh                              # global CLAUDE.md + skills
#   ./install.sh profile nextjs-webapp        # writes ./CLAUDE.md (+ design_system.md)
#   ./install.sh profile generic ../my-app    # writes ../my-app/CLAUDE.md

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

list_profiles() {
  shopt -s nullglob
  local found=0
  for d in "$SCRIPT_DIR"/profiles/*/; do
    echo "  - $(basename "$d")"
    found=1
  done
  shopt -u nullglob
  if [[ "$found" -eq 0 ]]; then
    echo "  (none found in $SCRIPT_DIR/profiles/)"
  fi
}

install_global() {
  mkdir -p "$CLAUDE_DIR/skills"

  safe_copy "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" "~/.claude/CLAUDE.md"

  local skill_count=0
  shopt -s nullglob
  for skill_dir in "$SCRIPT_DIR"/skills/*/; do
    local skill_name
    skill_name=$(basename "$skill_dir")
    mkdir -p "$CLAUDE_DIR/skills/$skill_name"
    safe_copy "$skill_dir/SKILL.md" "$CLAUDE_DIR/skills/$skill_name/SKILL.md" "skill: $skill_name"
    skill_count=$((skill_count + 1))
  done
  shopt -u nullglob

  echo
  if [[ "$skill_count" -eq 0 ]]; then
    echo "No skills found in $SCRIPT_DIR/skills/."
  else
    echo "Done. $skill_count skill(s) processed."
  fi
  echo
  echo "To verify: ls ~/.claude/skills/"
}

install_profile() {
  local profile_name="$1"
  local target_dir="${2:-.}"

  if [[ -z "$profile_name" ]]; then
    echo "Error: profile name is required."
    echo "Usage: $0 profile <name> [target-dir]"
    echo
    echo "Available profiles:"
    list_profiles
    exit 1
  fi

  local profile_dir="$SCRIPT_DIR/profiles/$profile_name"
  if [[ ! -d "$profile_dir" ]]; then
    echo "Error: profile '$profile_name' not found at $profile_dir"
    echo
    echo "Available profiles:"
    list_profiles
    exit 1
  fi

  if [[ ! -d "$target_dir" ]]; then
    echo "Error: target directory '$target_dir' does not exist."
    exit 1
  fi

  target_dir="$(cd "$target_dir" && pwd)"

  echo "Installing profile '$profile_name' to $target_dir"
  echo

  shopt -s nullglob
  local copied=0
  for f in "$profile_dir"/*; do
    if [[ -f "$f" ]]; then
      local fname
      fname=$(basename "$f")
      safe_copy "$f" "$target_dir/$fname" "$target_dir/$fname"
      copied=$((copied + 1))
    fi
  done
  shopt -u nullglob

  if [[ "$copied" -eq 0 ]]; then
    echo "Warning: profile '$profile_name' is empty."
  fi

  echo
  echo "Done. Profile '$profile_name' installed to $target_dir."
}

case "${1:-global}" in
  global)
    install_global
    ;;
  profile)
    install_profile "$2" "$3"
    ;;
  list)
    echo "Available profiles:"
    list_profiles
    ;;
  -h|--help|help)
    sed -n '2,15p' "$0"
    ;;
  *)
    echo "Unknown command: $1"
    echo
    echo "Usage:"
    echo "  $0 [global]                       Install global config to ~/.claude/"
    echo "  $0 profile <name> [target-dir]    Install a project profile"
    echo "  $0 list                           List available profiles"
    echo
    echo "Available profiles:"
    list_profiles
    exit 1
    ;;
esac
