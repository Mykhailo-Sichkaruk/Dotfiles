#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Detach live Stow symlink directories now managed by Home Manager.

Usage:
  scripts/detach-home-manager-stow-targets.sh          # dry run
  scripts/detach-home-manager-stow-targets.sh --apply  # make changes

This only removes live symlink directories in $HOME that point back to this
repo's home/ tree. It does not delete repo files.
USAGE
}

apply=false
if [[ "${1:-}" == "--apply" ]]; then
  apply=true
elif [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
elif [[ $# -gt 0 ]]; then
  usage >&2
  exit 2
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
repo_home="$repo_root/home"
backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-stow-detach/$(date +%Y%m%d-%H%M%S)"

managed_dirs=(
  ".config/alacritty"
  ".config/btop"
  ".config/dunst"
  ".config/fish"
  ".config/flameshot"
  ".config/gtk-3.0"
  ".config/mpv"
  ".config/rofi"
  ".config/zathura"
  ".newsboat"
)

preserve_files=(
  ".config/fish/fish_variables"
  ".config/gtk-3.0/bookmarks"
  ".newsboat/history.cmdline"
  ".newsboat/history.search"
)

say() {
  printf '%s\n' "$*"
}

run() {
  if "$apply"; then
    "$@"
  else
    printf 'DRY-RUN:'
    printf ' %q' "$@"
    printf '\n'
  fi
}

for rel in "${managed_dirs[@]}"; do
  live="$HOME/$rel"
  expected="$repo_home/$rel"

  if [[ ! -L "$live" ]]; then
    continue
  fi

  resolved="$(readlink -f "$live")"
  if [[ "$resolved" != "$expected" ]]; then
    say "skip $live: points to $resolved, not $expected"
    continue
  fi

  backup="$backup_root/$rel.symlink"
  say "detach $live -> $resolved"
  run mkdir -p "$(dirname "$backup")"
  run mv "$live" "$backup"
  run mkdir -p "$live"
done

for rel in "${preserve_files[@]}"; do
  src="$repo_home/$rel"
  dst="$HOME/$rel"

  if [[ ! -e "$src" || -e "$dst" ]]; then
    continue
  fi

  say "preserve $dst"
  run mkdir -p "$(dirname "$dst")"
  run cp -a "$src" "$dst"
done

if "$apply"; then
  say "Detached symlink directories. Backups are under $backup_root"
else
  say "Dry run only. Re-run with --apply to detach these symlinks."
fi
