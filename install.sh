#!/bin/bash
# install.sh — Install unified agent setup

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODE="prompt"

usage() {
  cat <<'EOF'
Usage:
  ./install.sh [global|claude]                 Install Claude Code global config
  ./install.sh codex                           Install Codex global config
  ./install.sh opencode                        Install OpenCode global config
  ./install.sh all                             Install Claude Code, Codex, and OpenCode globals
  ./install.sh profile <name> [target] [kind]  Install a project profile
                                               kind: both|agents|claude (default: both)
  ./install.sh list                            List available profiles
  ./install.sh --verify <target>               Verify installed files
  ./install.sh --sync <target>                 Overwrite managed files without prompting
  ./install.sh --dry-run <target>              Show what would change

Targets:
  claude, codex, opencode, all

Examples:
  ./install.sh
  ./install.sh all
  ./install.sh --verify all
  ./install.sh --dry-run codex
  ./install.sh profile nextjs-webapp ~/code/my-app both
EOF
}

safe_copy() {
  local src="$1"
  local dest="$2"
  local label="$3"

  if [[ "$MODE" == "verify" ]]; then
    if [[ ! -f "$dest" ]]; then
      echo "MISSING  $label"
    elif cmp -s "$src" "$dest"; then
      echo "OK       $label"
    else
      echo "DRIFT    $label"
    fi
    return
  fi

  if [[ "$MODE" == "dry-run" ]]; then
    echo "WOULD    $label -> $dest"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" && "$MODE" == "prompt" ]]; then
    read -r -p "⚠ $label already exists. Overwrite? [y/N] " answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      echo "SKIP     $label"
      return
    fi
  fi

  cp "$src" "$dest"
  echo "COPIED   $label"
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

ensure_absent() {
  local path="$1"
  local label="$2"

  if [[ "$MODE" == "verify" ]]; then
    if [[ -e "$path" ]]; then
      echo "DRIFT    $label should not be globally installed"
    else
      echo "OK       $label absent"
    fi
    return
  fi

  if [[ "$MODE" == "dry-run" ]]; then
    echo "WOULD    remove $label if present"
    return
  fi

  if [[ -e "$path" && "$MODE" == "sync" ]]; then
    rm -rf "$path"
    echo "REMOVED  $label"
  fi
}

ensure_global_workflows_absent() {
  local platform="$1"
  local root="$2"
  local extension="$3"

  shopt -s nullglob
  for skill_dir in "$SCRIPT_DIR"/skills/*/; do
    local name
    name="$(basename "$skill_dir")"
    case "$extension" in
      skill)
        ensure_absent "$root/$name" "$platform workflow: $name"
        ;;
      command)
        ensure_absent "$root/$name.md" "$platform command: $name"
        ;;
    esac
  done
  shopt -u nullglob
}

install_claude() {
  local claude_dir="$HOME/.claude"

  safe_copy "$SCRIPT_DIR/CLAUDE.md" "$claude_dir/CLAUDE.md" "~/.claude/CLAUDE.md"
  safe_copy "$SCRIPT_DIR/templates/design_system.md" "$claude_dir/templates/design_system.md" "~/.claude/templates/design_system.md"
  ensure_global_workflows_absent "Claude" "$claude_dir/skills" "skill"
}

merge_codex_config() {
  local config_file="$HOME/.codex/config.toml"
  local desired='project_doc_fallback_filenames = ["CLAUDE.md"]'

  if [[ "$MODE" == "verify" ]]; then
    if [[ -f "$config_file" ]] && grep -Fqx "$desired" "$config_file"; then
      echo "OK       ~/.codex/config.toml fallback"
    else
      echo "DRIFT    ~/.codex/config.toml fallback"
    fi
    return
  fi

  if [[ "$MODE" == "dry-run" ]]; then
    echo "WOULD    ensure ~/.codex/config.toml contains: $desired"
    return
  fi

  mkdir -p "$(dirname "$config_file")"
  touch "$config_file"

  if grep -Eq '^project_doc_fallback_filenames[[:space:]]*=' "$config_file"; then
    if grep -Fqx "$desired" "$config_file"; then
      echo "OK       ~/.codex/config.toml fallback"
    elif [[ "$MODE" == "sync" ]]; then
      perl -0pi -e 's/^project_doc_fallback_filenames\s*=.*$/project_doc_fallback_filenames = ["CLAUDE.md"]/m' "$config_file"
      echo "UPDATED  ~/.codex/config.toml fallback"
    else
      echo "SKIP     ~/.codex/config.toml fallback differs; use --sync codex to replace it"
    fi
  else
    printf '\n%s\n' "$desired" >> "$config_file"
    echo "ADDED    ~/.codex/config.toml fallback"
  fi
}

install_codex() {
  safe_copy "$SCRIPT_DIR/AGENTS.md" "$HOME/.codex/AGENTS.md" "~/.codex/AGENTS.md"
  safe_copy "$SCRIPT_DIR/templates/design_system.md" "$HOME/.codex/templates/design_system.md" "~/.codex/templates/design_system.md"
  merge_codex_config
  ensure_global_workflows_absent "Codex" "$HOME/.agents/skills" "skill"
}

install_opencode() {
  local opencode_dir="$HOME/.config/opencode"

  safe_copy "$SCRIPT_DIR/platforms/opencode/opencode.json" "$opencode_dir/opencode.json" "~/.config/opencode/opencode.json"
  safe_copy "$SCRIPT_DIR/AGENTS.md" "$opencode_dir/AGENTS.md" "~/.config/opencode/AGENTS.md"
  safe_copy "$SCRIPT_DIR/templates/design_system.md" "$opencode_dir/templates/design_system.md" "~/.config/opencode/templates/design_system.md"
  ensure_global_workflows_absent "OpenCode" "$opencode_dir/commands" "command"
}

install_all() {
  install_claude
  install_codex
  install_opencode
}

install_profile() {
  local profile_name="$1"
  local target_dir="${2:-.}"
  local kind="${3:-both}"

  if [[ -z "$profile_name" ]]; then
    echo "Error: profile name is required."
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

  case "$kind" in
    both|agents|claude)
      ;;
    *)
      echo "Error: profile kind must be one of: both, agents, claude"
      exit 1
      ;;
  esac

  echo "Installing profile '$profile_name' to $target_dir ($kind)"

  shopt -s nullglob
  for f in "$profile_dir"/*; do
    if [[ ! -f "$f" ]]; then
      continue
    fi

    local fname
    fname="$(basename "$f")"

    case "$fname:$kind" in
      CLAUDE.md:agents|AGENTS.md:claude)
        continue
        ;;
    esac

    safe_copy "$f" "$target_dir/$fname" "$target_dir/$fname"
  done
  shopt -u nullglob
}

case "${1:-}" in
  --verify)
    MODE="verify"
    shift
    ;;
  --sync)
    MODE="sync"
    shift
    ;;
  --dry-run)
    MODE="dry-run"
    shift
    ;;
esac

COMMAND="${1:-claude}"

case "$COMMAND" in
  global|claude)
    install_claude
    ;;
  codex)
    install_codex
    ;;
  opencode)
    install_opencode
    ;;
  all)
    install_all
    ;;
  profile)
    install_profile "${2:-}" "${3:-.}" "${4:-both}"
    ;;
  list)
    echo "Available profiles:"
    list_profiles
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    echo "Unknown command: $COMMAND"
    echo
    usage
    exit 1
    ;;
esac
