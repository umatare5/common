.PHONY: help lint lint-workflows lint-docs lint-renovate pre-commit-install pre-commit-test pre-commit-uninstall

# Pin the validator to the major version the Renovate app runs; the npx default
# resolves to a release that rejects managerFilePatterns
RENOVATE_VERSION := renovate@44

# Default target
.DEFAULT_GOAL := help

# Show available targets
help:
	@echo "Available targets:"
	@echo "  lint                 - Run every linter"
	@echo "  lint-workflows       - Check the workflows with actionlint and shellcheck"
	@echo "  lint-docs            - Check Markdown and the links it carries"
	@echo "  lint-renovate        - Validate the Renovate presets"
	@echo "  pre-commit-install   - Install the pre-commit hooks"
	@echo "  pre-commit-test      - Run every hook across the whole tree"
	@echo "  pre-commit-uninstall - Remove the pre-commit hooks"
	@echo ""
	@echo "Requirements:"
	@echo "  - actionlint: https://github.com/rhysd/actionlint#installation"
	@echo "  - shellcheck: https://github.com/koalaman/shellcheck#installing"
	@echo "  - lychee: https://github.com/lycheeverse/lychee#installation"
	@echo "  - pre-commit: https://pre-commit.com/#install"
	@echo "  - gitleaks: https://github.com/gitleaks/gitleaks#installing"

lint: lint-workflows lint-docs lint-renovate

# actionlint reads the embedded shell through shellcheck, which no other linter reaches
lint-workflows:
	actionlint -shellcheck=shellcheck .github/workflows/*.yml

lint-docs:
	markdownlint-cli2
	lychee --config lychee.toml --no-progress .

lint-renovate:
	npx --yes --package $(RENOVATE_VERSION) -- renovate-config-validator --strict renovate/*.json

# Pre-commit targets
# Install the hooks declared in .pre-commit-config.yaml
pre-commit-install:
	@command -v pre-commit >/dev/null 2>&1 || { echo "Error: pre-commit is not installed. See: https://pre-commit.com/#install"; exit 1; }
	@pre-commit install --allow-missing-config

# Run every hook across the whole tree without committing
pre-commit-test:
	@pre-commit run --all-files

# Remove the hooks
pre-commit-uninstall:
	@pre-commit uninstall
