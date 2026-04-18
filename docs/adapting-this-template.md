# Adapting This Template

## Goal

Keep the agent contract stable while swapping the stack-specific verification internals.

## Minimal migration checklist

1. Keep `AGENTS.md` and `.github/copilot-instructions.md`
2. Keep `scripts/run_required_checks.sh` as the single public verification entrypoint
3. Edit only `scripts/quality_gate.sh` to call the real checks for your stack
4. Keep `make quality` pointing at `./scripts/run_required_checks.sh`
5. Mirror the same command in CI
6. If you need deeper guardrails, add `docs/risk-tiers.md`, `docs/agent-architecture.md`, `scripts/run_evals.sh`, and `scripts/agent_postprocess.sh` rather than inventing one-off ad hoc checks

## Example stack mappings

### Python
```bash
ruff format --check .
ruff check .
pytest
```

### TypeScript / Node
```bash
npm ci
npm run format:check
npm run lint
npm test
```

### Rust
```bash
cargo fmt --check
cargo clippy -- -D warnings
cargo test
```

### Go
```bash
gofmt -l .
go vet ./...
go test ./...
```

## Strong recommendation

Do not expose five different "official" commands to the agent.
Expose one command and let that command orchestrate the rest.

## Portable guardrail layers

If your downstream repo needs more than formatting, linting, and tests, add the layers in this order:

1. document the contract in `AGENTS.md`
2. keep the public verification entrypoint stable
3. classify change risk with `docs/risk-tiers.md`
4. add `scripts/run_evals.sh` for accuracy and safety suites
5. add `scripts/agent_postprocess.sh` for risky diffs and high-blast-radius changes
6. mirror the same checks in CI
