# 🛠️ GitHub Actions & Development Infrastructure

This directory contains reusable GitHub Actions workflows, development instructions, and configuration files for maintaining consistent development practices across projects.

## 🚀 Reusable Workflows

| Workflow                                                         | Description                                   | Documentation                       |
| ---------------------------------------------------------------- | --------------------------------------------- | ----------------------------------- |
| [`golangci-lint-action.yml`](workflows/golangci-lint-action.yml) | Go code quality checks with golangci-lint     | [📖 Details](docs/golangci-lint.md) |
| [`goreleaser-action.yml`](workflows/goreleaser-action.yml)       | Automated Go project releases with GoReleaser | [📖 Details](docs/goreleaser.md)    |
| [`tagging-action.yml`](workflows/tagging-action.yml)             | Automated Git tag creation from version files | [📖 Details](docs/tagging.md)       |
| [`actionlint.yml`](workflows/actionlint.yml)                     | GitHub Actions workflow validation            | -                                   |

### Quick Start

```yaml
# Example: .github/workflows/lint.yml
name: Lint
on: [pull_request]
jobs:
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      go_version: "1.24.5"
```

## 📋 Development Instructions

GitHub Copilot Agent Mode instructions for maintaining coding standards:

| File                                                                        | Scope                                   | Description                       |
| --------------------------------------------------------------------------- | --------------------------------------- | --------------------------------- |
| [`general.instructions.md`](instructions/general.instructions.md)           | `**`                                    | General development guidelines    |
| [`go-cli-large.instructions.md`](instructions/go-cli-large.instructions.md) | `cmd/*.go,internal/**/*.go,pkg/**/*.go` | Large CLI application development |
| [`go-lib.instrcutions.md`](instructions/go-lib.instrcutions.md)             | `**/*.go`                               | Go library/SDK development        |
| [`markdown.instructions.md`](instructions/markdown.instructions.md)         | `**/*.md`                               | Markdown documentation standards  |
| [`scripts.instructions.md`](instructions/scripts.instructions.md)           | `**/*.sh`                               | Bash shell scripting guidelines   |

## 🔄 Workflow Integration Examples

### Complete CI/CD Pipeline

```yaml
# .github/workflows/ci.yml
name: CI/CD

on:
  push:
    branches: [main]
    tags: ["v*"]
  pull_request:
    branches: [main]

permissions:
  contents: write
  packages: write
  id-token: write

jobs:
  # Code quality checks
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      go_version: "1.24.5"
      golangci_lint_version: "v1.64.8"

  # Release on tag push
  release:
    if: startsWith(github.ref, 'refs/tags/')
    needs: lint
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
    with:
      go_version: "1.24.5"
      enable_docker: true
```

### Automated Tagging

```yaml
# .github/workflows/tag.yml
name: Auto Tag

on:
  push:
    branches: [main]
    paths: [VERSION]

jobs:
  tag:
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
    with:
      version_file: "VERSION"
      tag_prefix: "v"
```
