#!/usr/bin/env bash
set -Eeuo pipefail

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

trap fail ERR

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
  "$ROOT_DIR/.github/workflows/quality.yml"
  "$ROOT_DIR/.vscode/settings.json"
  "$ROOT_DIR/Makefile"
  "$ROOT_DIR/scripts/run_required_checks.sh"
  "$ROOT_DIR/scripts/quality_gate.sh"
  "$ROOT_DIR/scripts/run_evals.sh"
  "$ROOT_DIR/scripts/agent_postprocess.sh"
  "$ROOT_DIR/README.md"
  "$ROOT_DIR/docs/adapting-this-template.md"
  "$ROOT_DIR/docs/example-prompts.md"
  "$ROOT_DIR/docs/risk-tiers.md"
  "$ROOT_DIR/docs/agent-architecture.md"
  "$ROOT_DIR/evals/README.md"
  "$ROOT_DIR/evals/accuracy/README.md"
  "$ROOT_DIR/evals/safety/README.md"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || { printf "${RED}Missing required file: %s${RESET}\n" "$file" >&2; fail; }
done

run_step "shell syntax check: run_required_checks.sh" bash -n "$ROOT_DIR/scripts/run_required_checks.sh"
run_step "shell syntax check: quality_gate.sh" bash -n "$ROOT_DIR/scripts/quality_gate.sh"
run_step "shell syntax check: run_evals.sh" bash -n "$ROOT_DIR/scripts/run_evals.sh"
run_step "shell syntax check: agent_postprocess.sh" bash -n "$ROOT_DIR/scripts/agent_postprocess.sh"

if command -v shellcheck >/dev/null 2>&1; then
  run_step "shellcheck" shellcheck \
    "$ROOT_DIR/scripts/run_required_checks.sh" \
    "$ROOT_DIR/scripts/quality_gate.sh" \
    "$ROOT_DIR/scripts/run_evals.sh" \
    "$ROOT_DIR/scripts/agent_postprocess.sh"
else
  printf '%b\n' "${YELLOW}shellcheck not installed; skipping${RESET}"
fi

run_step "workflow sanity" grep -Fq 'chmod +x scripts/*.sh' "$ROOT_DIR/.github/workflows/quality.yml"

validate_json() {
  python3 -m json.tool "$1" >/dev/null
}

if command -v python3 >/dev/null 2>&1; then
  run_step "json validation" validate_json "$ROOT_DIR/.vscode/settings.json"
else
  printf '%b\n' "${YELLOW}python3 not installed; skipping JSON validation${RESET}"
fi

run_step "eval suites" "$ROOT_DIR/scripts/run_evals.sh"

pass
