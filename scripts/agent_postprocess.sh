#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
STRICT="${AGENT_POSTPROCESS_STRICT:-0}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict)
      STRICT=1
      shift
      ;;
    -h|--help)
      printf 'Usage: %s [--strict]\n' "${0##*/}"
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      exit 2
      ;;
  esac
done

is_secret_like_file() {
  local path="$1"
  [[ "$path" =~ (^|/)\.env($|[.]) ]] ||
    [[ "$path" =~ (^|/).*\.pem$ ]] ||
    [[ "$path" =~ (^|/).*\.key$ ]] ||
    [[ "$path" =~ (^|/).*\.p12$ ]] ||
    [[ "$path" =~ (^|/).*\.pfx$ ]] ||
    [[ "$path" =~ (^|/).*\.crt$ ]] ||
    [[ "$path" =~ (^|/).*\.cer$ ]] ||
    [[ "$path" =~ (^|/).*\.der$ ]]
}

is_high_risk_file() {
  local path="$1"
  [[ "$path" =~ (^|/)\.github/workflows/ ]] ||
    [[ "$path" =~ (^|/)(package\.json|package-lock\.json|pnpm-lock\.yaml|yarn\.lock|go\.mod|go\.sum|Cargo\.toml|Cargo\.lock|pyproject\.toml|poetry\.lock|Pipfile\.lock|uv\.lock|requirements(\.txt|-.*\.txt)?)$ ]]
}

changed_files=()
while IFS= read -r file; do
  [[ -n "$file" ]] || continue
  changed_files+=("$file")
done < <(
  {
    git -C "$ROOT_DIR" diff --name-only --cached -- .
    git -C "$ROOT_DIR" diff --name-only -- .
    git -C "$ROOT_DIR" ls-files --others --exclude-standard
  } | LC_ALL=C sort -u
)

if [[ ${#changed_files[@]} -eq 0 ]]; then
  printf '[agent-postprocess] no diff to inspect; PASS\n'
  exit 0
fi

printf '[agent-postprocess] inspecting %d changed file(s)\n' "${#changed_files[@]}"

risky_matches=0
for file in "${changed_files[@]}"; do
  if is_secret_like_file "$file"; then
    printf '[agent-postprocess] warning: secret-like path changed: %s\n' "$file"
    risky_matches=$((risky_matches + 1))
    continue
  fi

  if is_high_risk_file "$file"; then
    printf '[agent-postprocess] warning: high-risk path changed: %s\n' "$file"
    risky_matches=$((risky_matches + 1))
  fi
done

if [[ "$STRICT" -eq 1 && "$risky_matches" -gt 0 ]]; then
  printf '[agent-postprocess] strict mode rejected %d risky file(s)\n' "$risky_matches" >&2
  exit 1
fi

printf '[agent-postprocess] PASS\n'
