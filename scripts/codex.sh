#!/usr/bin/env bash
# Run directly or source from bootstrap.sh.
setup_codex_dotfiles() (
  set -e
  local dotfiles_root codex_dir source_file destination skill
  dotfiles_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
  codex_dir="${CODEX_HOME:-$HOME/.codex}"
  mkdir -p "$codex_dir/skills"

  link_codex_file() {
    local source_file="$1" destination="$2" backup
    if [ -L "$destination" ] && [ "$(readlink -- "$destination")" = "$source_file" ]; then
      return
    fi
    if [ -e "$destination" ] || [ -L "$destination" ]; then
      backup="$(mktemp -d "${destination}.backup.XXXXXX")"
      mv -- "$destination" "$backup/original"
      printf 'Backed up %s to %s/original\n' "$destination" "$backup"
    fi
    ln -s -- "$source_file" "$destination"
  }

  for source_file in "$dotfiles_root/.codex/config.toml" "$dotfiles_root/.codex/AGENTS.md"; do
    [ -f "$source_file" ] || continue
    destination="$codex_dir/$(basename -- "$source_file")"
    link_codex_file "$source_file" "$destination"
  done

  for skill in "$dotfiles_root/.codex/skills/"*; do
    [ -d "$skill" ] && [ -f "$skill/SKILL.md" ] || continue
    link_codex_file "$skill" "$codex_dir/skills/$(basename -- "$skill")"
  done
)
setup_codex_dotfiles
