---
description: General Instructions
applyTo: "**"
---

# GitHub Copilot Agent Mode – General Instructions

<Please describe about the general instructions for GitHub Copilot Agent Mode, which are applied to all prompts.>

---

## 💡 Expert Persona

<Please describe the expert persona that GitHub Copilot should assume when processing prompts in this repository.>

---

## 💡 Special Instructions for Claude Sonnet 4

When you using Claude Sonnet 4:

- **MUST** execute at the start of the prompt:

  - Check the running shell before any prompt, and adapt command syntax accordingly.

- **MUST** comply with the following during prompt processing:

  - Use the command format corresponding to confirmed shell at the start.
  - Use `./tmp` for all temporary files, scripts and directories, including `.test` binaries and coverage reports.

- **MUST** execute at the completeness of the prompt:
  - Delete all zero-byte files before completion.
  - **When modified go code**, run `go build` before completion. Repeat modifications until `go build` completeness.
  - **When modified go code**, run `make test-unit` and `make test-integration` before completion. Repeat modifications until all tests pass.
  - **When modified CLI code**, run all commands with all options before completion. Repeat modifications until all CLI commands work.
  - Summarize results and save to `./.copilot_reports` before completion. The name format should be `<prompt_title>_<timestamp YYYY-MM-DD_HH-mm-ss>.md`.

---

## 📣 Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

**Examples:**

- `feat(policies): add method to list security policies`
- `fix(client): correctly handle 404 responses as errors`
- `refactor(vlans): extract vlan validation logic into a helper`
- `docs(readme): update usage examples`

---

## 📝 Commit Guidelines

**MUST** follow these commit practices:

- **Meaningful Commits:** Split files into meaningful units when committing. Group related changes together and commit them as logical units rather than committing all changes at once.

- **Respect .gitignore:** Always respect `.gitignore` rules when committing. Do not include ignored files such as `.copilot_reports/`, temporary files, or build artifacts in commits.

---
