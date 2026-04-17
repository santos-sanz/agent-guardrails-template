# Agent Guardrails Template

Private starter template for repos that want reliable coding-agent behavior:

- `AGENTS.md` as the primary agent contract
- minimal-diff / verify-to-green workflow
- one-command quality gate
- CI that runs the same checks as local development
- script hooks so agents actually execute verification instead of just claiming success

## What this gives you

- a universal `AGENTS.md` you can adapt to any language
- a short `.github/copilot-instructions.md` that points agents back to the contract
- `scripts/quality_gate.sh` as the single verification entrypoint
- `scripts/run_required_checks.sh` to ensure the required scripts really run
- a GitHub Actions workflow that executes the same gate in CI
- a `Makefile` with `make quality`

## Core idea

Agents perform better when the repository defines:

1. mission
2. non-negotiable workflow
3. scope discipline
4. exact verification command
5. output expectations
6. stop condition

## Quick start

```bash
make quality
```

or

```bash
./scripts/quality_gate.sh
```

## Files

- `AGENTS.md` — source of truth for agent behavior
- `.github/copilot-instructions.md` — small adapter that forces Copilot back to `AGENTS.md`
- `scripts/quality_gate.sh` — one command to verify formatting/lint/tests
- `scripts/run_required_checks.sh` — helper that records and enforces script execution
- `.github/workflows/quality.yml` — CI quality gate
- `docs/adapting-this-template.md` — how to port this to any stack
- `docs/example-prompts.md` — prompts that force agent compliance

## How to adapt to another language

Replace the commands inside `scripts/quality_gate.sh` with your stack equivalents, for example:

- Python: `ruff check . && ruff format --check . && pytest`
- TypeScript: `npm run lint && npm run typecheck && npm test`
- Rust: `cargo fmt --check && cargo clippy -- -D warnings && cargo test`
- Go: `gofmt -l . && go vet ./... && go test ./...`

Keep the same shape even if the toolchain changes.

## Why the extra script launcher exists

A common failure mode with agents is: they say they ran checks but did not.

This template addresses that by routing verification through:

- `scripts/run_required_checks.sh`
- `scripts/quality_gate.sh`

The launcher writes a run marker and the gate fails hard if the required checks are missing or a command fails.
