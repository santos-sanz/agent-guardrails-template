#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="$ROOT_DIR/.agent-state"
MARKER_FILE="$STATE_DIR/required-checks-ran"
mkdir -p "$STATE_DIR"

printf "[agent-checks] starting required checks\n"

"$ROOT_DIR/scripts/quality_gate.sh"

date -u +"%Y-%m-%dT%H:%M:%SZ" > "$MARKER_FILE"
printf "[agent-checks] marker written to %s\n" "$MARKER_FILE"
printf "[agent-checks] PASS\n"
