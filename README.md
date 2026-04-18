# Agent Guardrails Template

Private starter template for repos that want reliable coding-agent behavior.

This template was extended from [neovasili/2026-copilot-dev-day](https://github.com/neovasili/2026-copilot-dev-day). The source repo is a workshop-specific Go project; this repository keeps the transferable guardrail patterns and removes the language-specific parts.

## What this template gives you

- a universal `AGENTS.md` you can adapt to any language
- a short `.github/copilot-instructions.md` that points agents back to the contract
- `scripts/run_required_checks.sh` as the public verification entrypoint
- `scripts/quality_gate.sh` as the internal gate that downstream stacks replace
- `scripts/run_evals.sh` and `scripts/agent_postprocess.sh` as reusable guardrail hooks
- `docs/risk-tiers.md` and `docs/agent-architecture.md` for higher-signal operating rules
- a GitHub Actions workflow that runs the same verification in CI
- a `Makefile` with `make quality`, plus optional helper targets

## Sources and inspiration

This template is based on [neovasili/2026-copilot-dev-day](https://github.com/neovasili/2026-copilot-dev-day) and extends it with guardrail patterns from the articles that directly informed the implementation:

- [TeamDay.ai: Complete Guide to Agentic Coding 2026](https://www.teamday.ai/blog/complete-guide-agentic-coding-2026) — sandboxing, approval gates, and test-driven validation for agents
- [Marmelab: Agent Experience](https://marmelab.com/blog/2026/01/21/agent-experience.html) — postprocess hooks, diff inspection, and guardrails for agent outputs
- [Propel: Agentic Engineering Code Review Guardrails](https://www.propelcode.ai/blog/agentic-engineering-code-review-guardrails) — risk tiers, policy checks, and review escalation
- [Andrii Furmanets: AI Agents in 2026](https://andriifurmanets.com/blogs/ai-agents-2026-practical-architecture-tools-memory-evals-guardrails) — capability gating, stateful architecture, tracing, and security boundaries
- [Allerin: Agentic AI Systems: Guardrails, Evals, and Human-in-the-Loop](https://www.allerin.com/resources/agentic-ai-guardrails-evals-hitl) — minimal eval suites and runtime guardrails

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
./scripts/run_required_checks.sh
```

or

```bash
make quality
```

If you are adapting the template to another stack, keep `./scripts/run_required_checks.sh` as the single public entrypoint and update only the checks behind it.

## Files

- `AGENTS.md` — source of truth for agent behavior
- `.github/copilot-instructions.md` — small adapter that forces Copilot back to `AGENTS.md`
- `scripts/quality_gate.sh` — internal gate for formatting/lint/tests and repo-specific checks
- `scripts/run_required_checks.sh` — helper that records and enforces script execution
- `scripts/run_evals.sh` — optional eval dispatcher for accuracy and safety suites
- `scripts/agent_postprocess.sh` — reusable diff hook for risky or agent-generated changes
- `.github/workflows/quality.yml` — CI quality gate
- `docs/adapting-this-template.md` — how to port this to any stack
- `docs/risk-tiers.md` — low / medium / high change classification
- `docs/agent-architecture.md` — portable runtime, trace, and guardrail model
- `docs/example-prompts.md` — prompts that force agent compliance
- `evals/` — starter structure for downstream accuracy and safety suites

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
