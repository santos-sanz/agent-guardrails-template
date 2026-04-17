SHELL := /usr/bin/env bash

.PHONY: quality verify test lint format-check

quality verify:
	./scripts/run_required_checks.sh

test:
	@echo "Replace this target with your stack's test command"

lint:
	@echo "Replace this target with your stack's lint command"

format-check:
	@echo "Replace this target with your stack's format check command"
