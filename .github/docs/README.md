# 🛠️ GitHub Actions & Development Infrastructure

This directory contains reusable GitHub Actions workflows, development instructions, and configuration files for maintaining consistent development practices across projects.

## 📁 Directory Structure

```text
.github/
├── docs/                    # Documentation for workflows
├── instructions/           # GitHub Copilot development instructions
├── workflows/              # Reusable GitHub Actions workflows
├── actionlint.yaml         # actionlint configuration
├── CODEOWNERS             # Repository code ownership
└── README.md              # This file
```

## 🚀 Reusable Workflows

### Core Workflows

| Workflow                                                         | Description                                   | Documentation                       |
| ---------------------------------------------------------------- | --------------------------------------------- | ----------------------------------- |
| [`golangci-lint-action.yml`](workflows/golangci-lint-action.yml) | Go code quality checks with golangci-lint     | [📖 Details](docs/golangci-lint.md) |
| [`goreleaser-action.yml`](workflows/goreleaser-action.yml)       | Automated Go project releases with GoReleaser | [📖 Details](docs/goreleaser.md)    |
| [`tagging-action.yml`](workflows/tagging-action.yml)             | Automated Git tag creation from version files | [📖 Details](docs/tagging.md)       |
| [`actionlint.yml`](workflows/actionlint.yml)                     | GitHub Actions workflow validation            | -                                   |

### Quick Start

To use these workflows in your project, add them to your `.github/workflows/` directory:

```yaml
# Example: .github/workflows/lint.yml
name: Lint

on:
  pull_request:
    branches: [main]

jobs:
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      go_version: "1.24.5"
```

## 📋 Development Instructions

The `instructions/` directory contains GitHub Copilot Agent Mode instructions for maintaining coding standards and best practices.

### Available Instructions

| File                                                                        | Scope                                   | Description                                     |
| --------------------------------------------------------------------------- | --------------------------------------- | ----------------------------------------------- |
| [`general.instructions.md`](instructions/general.instructions.md)           | `**`                                    | General development guidelines for all projects |
| [`go-cli-large.instructions.md`](instructions/go-cli-large.instructions.md) | `cmd/*.go,internal/**/*.go,pkg/**/*.go` | Large CLI application development               |
| [`go-lib.instrcutions.md`](instructions/go-lib.instrcutions.md)             | `**/*.go`                               | Go library/SDK development                      |
| [`markdown.instructions.md`](instructions/markdown.instructions.md)         | `**/*.md`                               | Markdown documentation standards                |
| [`scripts.instructions.md`](instructions/scripts.instructions.md)           | `**/*.sh`                               | Bash shell scripting guidelines                 |

### Key Features

- 🎯 **Project-specific guidance** for different types of Go projects
- 🔧 **Shell compatibility** with automatic detection and adaptation
- 📝 **Consistent documentation** standards across projects
- 🧪 **Testing requirements** with mandatory test execution
- 📊 **Automated reporting** to `.copilot_reports/`
- 💾 **Commit conventions** following Conventional Commits

## ⚙️ Configuration Files

### actionlint.yaml

Configuration for [actionlint](https://github.com/rhysd/actionlint) to validate GitHub Actions workflows:

- Ignores shellcheck SC2086 warnings in workflow files
- Configures self-hosted runner labels (currently empty)
- Supports configuration variables validation

### CODEOWNERS

Defines code ownership for automated pull request reviews:

```plaintext
* @umatare5
```

All files are owned by `@umatare5` for review requirements.

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

## 📚 Documentation

Each workflow has detailed documentation in the `docs/` directory:

- **Setup requirements** and prerequisites
- **Input parameters** with defaults and descriptions
- **Use cases** and examples
- **Troubleshooting** guides
- **Integration patterns**

## 🛡️ Quality Assurance

All workflows and configurations are validated using:

- **actionlint** for GitHub Actions workflow validation
- **shellcheck** for shell script quality (with configured ignores)
- **markdownlint** for documentation consistency
- **Conventional Commits** for standardized commit messages

## 🤝 Contributing

When contributing to these workflows or instructions:

1. **Follow the instruction files** in the `instructions/` directory
2. **Update documentation** in the `docs/` directory for workflow changes
3. **Test workflows** in a separate repository before merging
4. **Use meaningful commits** following Conventional Commits format
5. **Respect .gitignore** rules (especially `.copilot_reports/`)

## 📞 Support

For questions or issues with these workflows:

1. Check the relevant documentation in `docs/`
2. Review the workflow source code for configuration options
3. Consult the instruction files for development guidelines
4. Open an issue in the repository for bugs or feature requests

---

_This infrastructure is designed to maintain consistent quality and development practices across all projects while providing flexible, reusable components for common development workflows._
