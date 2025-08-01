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
    uses: umatare5/common/.github/workflows/golangci-lint.yml@main
    with:
      go_version: "1.24.5"
```

## Available Workflows

| Workflow                                   | Description                                   | Documentation                       |
| ------------------------------------------ | --------------------------------------------- | ----------------------------------- |
| [`go-test.yml`](./go-test.yml)             | Go testing, coverage checks, and binary build | [📖 Guide](./docs/go-test.md)       |
| [`golangci-lint.yml`](./golangci-lint.yml) | Go code quality checks with golangci-lint     | [📖 Guide](./docs/golangci-lint.md) |
| [`goreleaser.yml`](./goreleaser.yml)       | Automated Go project releases with GoReleaser | [📖 Guide](./docs/goreleaser.md)    |
| [`tagging.yml`](./tagging.yml)             | Automated Git tag creation from version files | [📖 Guide](./docs/tagging.md)       |

> [!Note]
>
> `internal-` workflows are only for internal use and not intended for public use.
