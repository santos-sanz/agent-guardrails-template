# Evals

This directory is a portable home for downstream agent eval suites.

## Intended shape

- `accuracy/` for functional correctness and task completion
- `safety/` for prompt injection, jailbreak, and secret-handling checks

## How to run

The template ships with `scripts/run_evals.sh`, which discovers runnable suites and skips cleanly when none exist yet.

Downstream repositories can add their own executable suite entrypoints without changing the contract at the top of the repo.
