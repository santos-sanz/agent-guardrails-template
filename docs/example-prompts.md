# Example Prompts

## Small bugfix

```text
Read AGENTS.md and follow it strictly.
Fix the reported bug with the smallest possible in-scope change.
Add or update tests if behavior changes.
Run ./scripts/run_required_checks.sh and iterate until PASS.
Return what changed, what command you ran, and final PASS/FAIL.
```

## Small refactor

```text
Read AGENTS.md and follow it strictly.
Refactor one small function for readability without changing behavior.
Avoid broad refactors.
Run ./scripts/run_required_checks.sh and stop only when PASS.
```

## CI failure repair

```text
Read AGENTS.md and follow it strictly.
Identify the smallest change needed to fix the failing check.
Keep the change in scope.
Run ./scripts/run_required_checks.sh after editing and iterate until PASS.
```
