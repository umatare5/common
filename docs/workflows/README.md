# 🛠️ GitHub Actions Reusable Workflows

GitHub Actions reusable workflows for automating common tasks such as code quality checks, releases, and versioning.

## Usage

Import these workflows into your repository by referencing them in your `.github/workflows/` directory. They can be used to automate tasks like code linting, releases, and more.

```yml
# Example: .github/workflows/lint.yml
name: Lint
on: [pull_request]
jobs:
  lint:
    uses: umatare5/workflows/golangci-lint.yml@main
    with:
      go_version: "1.24.5"
```

## Available Workflows

| Workflow                                           | Description                                   | Documentation                    |
| -------------------------------------------------- | --------------------------------------------- | -------------------------------- |
| [`golangci-lint.yml`](workflows/golangci-lint.yml) | Go code quality checks with golangci-lint     | [📖 Details](./golangci-lint.md) |
| [`goreleaser.yml`](workflows/goreleaser.yml)       | Automated Go project releases with GoReleaser | [📖 Details](./goreleaser.md)    |
| [`tagging.yml`](workflows/tagging.yml)             | Automated Git tag creation from version files | [📖 Details](./tagging.md)       |
