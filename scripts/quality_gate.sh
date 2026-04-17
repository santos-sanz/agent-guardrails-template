#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="$ROOT_DIR/.agent-state"
mkdir -p "$STATE_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

fail() {
  printf '%b\n' "${RED}QUALITY GATE: FAIL${RESET}" >&2
  exit 1
}

pass() {
  printf '%b\n' "${GREEN}QUALITY GATE: PASS${RESET}"
}

run_step() {
  local name="$1"
  shift
  printf "${BLUE}==> %s${RESET}\n" "$name"
  "$@"
}

# Template-safe defaults: fail only on missing required template files,
# then run lightweight shell validation on scripts.
required_files=(
  "$ROOT_DIR/AGENTS.md"
  "$ROOT_DIR/.github/copilot-instructions.md"
  "$ROOT_DIR/scripts/run_required_checks.sh"
  "$ROOT_DIR/scripts/quality_gate.sh"
  "$ROOT_DIR/README.md"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || { printf "${RED}Missing required file: %s${RESET}\n" "$file" >&2; fail; }
done

run_step "shell syntax check" bash -n "$ROOT_DIR/scripts/run_required_checks.sh"
run_step "shell syntax check" bash -n "$ROOT_DIR/scripts/quality_gate.sh"

if command -v shellcheck >/dev/null 2>&1; then
  run_step "shellcheck" shellcheck "$ROOT_DIR/scripts/run_required_checks.sh" "$ROOT_DIR/scripts/quality_gate.sh"
else
  printf '%b\n' "${YELLOW}shellcheck not installed; skipping${RESET}"
fi

pass
