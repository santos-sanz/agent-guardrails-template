#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
EVALS_DIR="${EVALS_DIR:-$ROOT_DIR/evals}"

printf '[agent-evals] scanning %s\n' "$EVALS_DIR"

if [[ ! -d "$EVALS_DIR" ]]; then
  printf '[agent-evals] no evals directory found; skipping\n'
  exit 0
fi

suite_scripts=()
while IFS= read -r suite_script; do
  [[ -n "$suite_script" ]] || continue
  suite_scripts+=("$suite_script")
done < <(find "$EVALS_DIR" -type f -name 'run.sh' | LC_ALL=C sort)

if [[ ${#suite_scripts[@]} -eq 0 ]]; then
  printf '[agent-evals] no runnable suites found; skipping\n'
  exit 0
fi

for suite_script in "${suite_scripts[@]}"; do
  suite_dir="$(dirname -- "$suite_script")"
  suite_name="$(basename -- "$suite_dir")"
  printf '[agent-evals] running %s\n' "$suite_name"
  bash "$suite_script"
done

printf '[agent-evals] PASS\n'
