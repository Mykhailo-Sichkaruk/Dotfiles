#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Detach Claude runtime state from the dotfiles repo while keeping selected
configuration files managed in the repo.

Default behavior is a dry run.

Usage:
  scripts/claude-detach-state.sh [--apply] [--repo-root PATH] [--home PATH]

Options:
  --apply           Perform the changes. Without this flag the script only
                    prints what it would do.
  --repo-root PATH  Override the repo root. Defaults to the parent directory of
                    this script.
  --home PATH       Override the home directory. Defaults to $HOME.
  -h, --help        Show this help text.

What it does in apply mode:
  1. Copies the current ~/.claude contents to a temporary real directory.
  2. Removes the kept config files from that temporary runtime copy.
  3. Replaces ~/.claude with the real runtime directory.
  4. Prunes non-kept state from the repo's home/.claude directory.
  5. Symlinks the kept repo-managed files back into ~/.claude.

The keep list is defined in KEEP_PATHS below. Adjust it before running if your
curated Claude setup lives elsewhere.
EOF
}

say() {
  printf '%s\n' "$*"
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

realpath_compat() {
  if command -v realpath >/dev/null 2>&1; then
    realpath "$1"
  else
    readlink -f "$1"
  fi
}

cleanup_trap() {
  if [[ -n "${TMP_RUNTIME_DIR:-}" && -d "${TMP_RUNTIME_DIR:-}" ]]; then
    rm -rf "${TMP_RUNTIME_DIR}"
  fi
}

DRY_RUN=1
REPO_ROOT=""
HOME_DIR="${HOME}"

while (($# > 0)); do
  case "$1" in
    --apply)
      DRY_RUN=0
      shift
      ;;
    --repo-root)
      REPO_ROOT="$2"
      shift 2
      ;;
    --home)
      HOME_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

if [[ -z "${REPO_ROOT}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
else
  REPO_ROOT="$(realpath_compat "${REPO_ROOT}")"
fi

REPO_CLAUDE_DIR="${REPO_ROOT}/home/.claude"
HOME_CLAUDE_DIR="${HOME_DIR}/.claude"
TMP_RUNTIME_DIR=""

# Curated Claude files that should stay repo-managed.
KEEP_PATHS=(
  "settings.json"
  "mcp.json"
  "commands"
  "skills"
  "statusline-command.sh"
  "starship.toml"
  "plugins/blocklist.json"
  "plugins/installed_plugins.json"
)

[[ -d "${REPO_CLAUDE_DIR}" ]] || fail "repo Claude directory not found: ${REPO_CLAUDE_DIR}"
[[ -d "${HOME_DIR}" ]] || fail "home directory not found: ${HOME_DIR}"

for rel in "${KEEP_PATHS[@]}"; do
  [[ -e "${REPO_CLAUDE_DIR}/${rel}" ]] || fail "kept path missing from repo: ${rel}"
done

declare -A KEEP_TOP_LEVEL=()
for rel in "${KEEP_PATHS[@]}"; do
  top="${rel%%/*}"
  KEEP_TOP_LEVEL["${top}"]=1
done

CURRENT_TARGET=""
if [[ -L "${HOME_CLAUDE_DIR}" ]]; then
  CURRENT_TARGET="$(realpath_compat "${HOME_CLAUDE_DIR}")"
fi

say "Repo Claude dir: ${REPO_CLAUDE_DIR}"
say "Home Claude dir: ${HOME_CLAUDE_DIR}"
say "Mode: $([[ ${DRY_RUN} -eq 1 ]] && echo dry-run || echo apply)"
say ""
say "Keep list:"
for rel in "${KEEP_PATHS[@]}"; do
  say "  - ${rel}"
done
say ""

if [[ -L "${HOME_CLAUDE_DIR}" && "${CURRENT_TARGET}" != "${REPO_CLAUDE_DIR}" ]]; then
  fail "~/.claude is a symlink, but not to the repo Claude dir: ${CURRENT_TARGET}"
fi

if [[ ${DRY_RUN} -eq 1 ]]; then
  if [[ -L "${HOME_CLAUDE_DIR}" ]]; then
    say "Would replace symlinked ~/.claude with a real directory."
  elif [[ -d "${HOME_CLAUDE_DIR}" ]]; then
    say "Would merge repo-kept files into the existing real ~/.claude directory."
  else
    say "Would create ~/.claude as a real directory."
  fi

  say "Would remove non-kept state from ${REPO_CLAUDE_DIR}."
  say "Would symlink the kept files from the repo back into ${HOME_CLAUDE_DIR}."
  exit 0
fi

trap cleanup_trap EXIT

TMP_RUNTIME_DIR="$(mktemp -d "${HOME_DIR}/.claude.runtime.XXXXXX")"

if [[ -e "${HOME_CLAUDE_DIR}" ]]; then
  cp -a "${HOME_CLAUDE_DIR}/." "${TMP_RUNTIME_DIR}/"
fi

for rel in "${KEEP_PATHS[@]}"; do
  rm -rf "${TMP_RUNTIME_DIR:?}/${rel}"
done

if [[ -L "${HOME_CLAUDE_DIR}" || -f "${HOME_CLAUDE_DIR}" ]]; then
  rm -f "${HOME_CLAUDE_DIR}"
elif [[ -d "${HOME_CLAUDE_DIR}" ]]; then
  rm -rf "${HOME_CLAUDE_DIR}"
fi

mkdir -p "${HOME_CLAUDE_DIR}"
cp -a "${TMP_RUNTIME_DIR}/." "${HOME_CLAUDE_DIR}/"

for entry in "${REPO_CLAUDE_DIR}"/* "${REPO_CLAUDE_DIR}"/.*; do
  name="$(basename "${entry}")"
  [[ "${name}" == "." || "${name}" == ".." ]] && continue
  [[ -n "${KEEP_TOP_LEVEL[${name}]:-}" ]] || rm -rf "${entry}"
done

# Clean nested state inside kept parent directories.

for top in "${!KEEP_TOP_LEVEL[@]}"; do
  top_path="${REPO_CLAUDE_DIR}/${top}"
  [[ -d "${top_path}" ]] || continue

  while IFS= read -r path; do
    rel="${path#${REPO_CLAUDE_DIR}/}"
    keep_match=0
    for keep in "${KEEP_PATHS[@]}"; do
      if [[ "${rel}" == "${keep}" || "${rel}" == "${keep}/"* ]]; then
        keep_match=1
        break
      fi
    done

    if [[ ${keep_match} -eq 0 ]]; then
      rm -rf "${path}"
    fi
  done < <(find "${top_path}" -mindepth 1 -depth)
done

find "${REPO_CLAUDE_DIR}" -depth -type d -empty -delete

for rel in "${KEEP_PATHS[@]}"; do
  src="${REPO_CLAUDE_DIR}/${rel}"
  dst="${HOME_CLAUDE_DIR}/${rel}"

  mkdir -p "$(dirname "${dst}")"
  rm -rf "${dst}"
  ln -s "${src}" "${dst}"
done

rm -rf "${TMP_RUNTIME_DIR}"
TMP_RUNTIME_DIR=""
trap - EXIT

say "Detached Claude runtime state from the repo."
say "Repo-managed files remain under ${REPO_CLAUDE_DIR}."
say "Live runtime state now lives in ${HOME_CLAUDE_DIR}."
