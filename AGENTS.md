# AGENTS.md — Universal Guardrails Template

## Mission

Make the smallest safe change that solves the requested task, then prove quality with repository tooling before stopping.

## Non-negotiable workflow

For every code or config change request:

1. Restate the task in one sentence.
2. Identify the smallest possible in-scope diff.
3. Add or update tests when behavior changes or bugfixes are involved.
4. Apply the change.
5. Run the required verification command:
   - `./scripts/run_required_checks.sh`
6. If verification fails, inspect the failure, make the minimal correction, and rerun verification.
7. Stop only when verification passes.

## Scope discipline

- Do not refactor unrelated code unless explicitly requested.
- Do not rename files, move modules, or reorganize architecture unless explicitly requested.
- Do not add dependencies unless they are required for the task and called out.
- Do not silently change public behavior outside the task scope.
- Prefer local fixes over sweeping rewrites.

## Design constraints

- Prefer standard-library or built-in tooling where reasonable.
- Keep functions focused and readable.
- Prefer meaningful names over short clever ones.
- Preserve deterministic behavior in tests, examples, and outputs.
- Make side effects explicit.
- Keep code testable by isolating boundaries and dependencies.

## Verification contract

The repository must expose exactly one primary verification command:

- `./scripts/run_required_checks.sh`

That command may call other scripts internally, but the agent must treat this command as the authority.

## Output expectations

When done, report:

- what changed
- which verification command was run
- final status: `PASS` or `FAIL`
- any remaining risk, assumption, or follow-up

## Failure handling

If the verification command cannot run because tooling is missing, say exactly which command is missing and stop.
Do not claim success without a real verification run.

## Repo maintainer note

Keep this file short, stable, and high-signal. Put stack-specific details in scripts and docs, not as scattered prompt fragments.
