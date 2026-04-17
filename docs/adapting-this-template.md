# Adapting This Template

## Goal

Keep the agent contract stable while swapping the stack-specific verification internals.

## Minimal migration checklist

1. Keep `AGENTS.md` and `.github/copilot-instructions.md`
2. Keep `scripts/run_required_checks.sh` as the single public verification entrypoint
3. Edit only `scripts/quality_gate.sh` to call the real checks for your stack
4. Keep `make quality` pointing at `./scripts/run_required_checks.sh`
5. Mirror the same command in CI

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
