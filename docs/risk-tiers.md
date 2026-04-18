# Risk Tiers

Use this document to classify the change before editing. The goal is not bureaucracy; it is to match review depth to blast radius.

## Low Risk

Typical examples:

- README, docs, comments, and examples
- small refactors with no behavioral change
- local shell or helper script cleanup with no new side effects

Minimum checks:

- `./scripts/run_required_checks.sh`

Review posture:

- normal review is enough
- `scripts/agent_postprocess.sh` is optional unless the diff touches risky paths

## Medium Risk

Typical examples:

- behavior changes in existing code paths
- changes that span multiple files but stay within one subsystem
- new tests, eval cases, or helper scripts that affect how the repo is verified

Minimum checks:

- `./scripts/run_required_checks.sh`
- `./scripts/run_evals.sh` when the change affects agent behavior, safety, or task completion

Review posture:

- use `scripts/agent_postprocess.sh` in normal mode before finalizing
- ask for explicit human review if the change is still hard to reason about

## High Risk

Typical examples:

- authentication, authorization, or secret-handling code
- workflow files, branch protection, release automation, or dependency updates
- changes that can leak data, widen tool access, or alter verification policy

Minimum checks:

- `./scripts/run_required_checks.sh`
- `./scripts/run_evals.sh`
- `./scripts/agent_postprocess.sh --strict`

Review posture:

- require explicit human review before merge
- keep the diff as small as possible
- avoid combining high-risk edits with unrelated cleanup

## Practical rule

If you are not sure which tier applies, choose the higher tier.

When a repo downstream wants more automation, this document can be paired with labels, CODEOWNERS, or a policy file, but those are intentionally left out of the template itself.
