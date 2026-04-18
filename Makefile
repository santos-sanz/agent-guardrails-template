SHELL := /usr/bin/env bash

.PHONY: quality verify test lint format-check evals postprocess

quality verify:
	./scripts/run_required_checks.sh

evals:
	./scripts/run_evals.sh

postprocess:
	./scripts/agent_postprocess.sh

test:
	@echo "Replace this target with your stack's test command"

lint:
	@echo "Replace this target with your stack's lint command"

format-check:
	@echo "Replace this target with your stack's format check command"
