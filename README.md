# umatare5/common

A collection of reusable GitHub Actions workflows and custom actions for common development tasks.

> [!NOTE]
> For detailed information about GitHub Actions workflows, development instructions, and configuration files, see [.github/README.md](.github/README.md).

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🚀 Quick Start

### Complete CI/CD Pipeline Example

```yaml
name: Complete Pipeline

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
  # Code quality check for PRs
  lint:
    if: github.event_name == 'pull_request'
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main

  # Auto-tagging when VERSION file changes
  tag:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    uses: umatare5/common/.github/workflows/tagging-action.yml@main

  # Release when tags are pushed
  release:
    if: startsWith(github.ref, 'refs/tags/v')
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
```

For more examples and detailed configuration options, see [📖 .github/README.md](.github/README.md).

## 🤝 Contributing

Feel free to submit issues and enhancement requests. These workflows are designed to be flexible and reusable across different Go projects.

## 🙏 Acknowledgments

This code was developed with the assistance of **GitHub Copilot Agent Mode**. I extend our heartfelt gratitude to the global developer community who have contributed their knowledge, code, and expertise to open source projects and public repositories.

## 📄 License

Please see the [LICENSE](./LICENSE) file for details.
