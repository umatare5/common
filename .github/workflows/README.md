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
    uses: umatare5/common/.github/workflows/go-test-fmt.yml@main
    with:
      go_version: "1.24.5"
```

## Available Workflows

| Workflow                                         | Description                                          | Documentation                          |
| ------------------------------------------------ | ---------------------------------------------------- | -------------------------------------- |
| [`codeql.yml`](./codeql.yml)                     | CodeQL security analysis and vulnerability detection | [📖 Guide](./docs/codeql.md)           |
| [`go-test-build.yml`](./go-test-build.yml)       | Go testing and binary build                          | [📖 Guide](./docs/go-test-build.md)    |
| [`go-test-coverage.yml`](./go-test-coverage.yml) | Go coverage testing with thresholds                  | [📖 Guide](./docs/go-test-coverage.md) |
| [`go-test-fmt.yml`](./go-test-fmt.yml)           | Go code formatting and quality checks                | [📖 Guide](./docs/go-test-fmt.md)      |
| [`go-release.yml`](./go-release.yml)             | Automated Go project releases                        | [📖 Guide](./docs/go-release.md)       |
| [`scorecard.yml`](./scorecard.yml)               | OSSF Scorecard security practices evaluation         | [📖 Guide](./docs/scorecard.md)        |
| [`tagging.yml`](./tagging.yml)                   | Automated Git tag creation from version files        | [📖 Guide](./docs/tagging.md)          |

> [!Note]
>
> `internal-` workflows are only for internal use and not intended for public use.
