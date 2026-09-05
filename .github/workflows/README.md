# GitHub Actions Reusable Workflows

GitHub Actions reusable workflows for automating common tasks such as code quality checks, releases, and versioning.

## Usage

Import these workflows into your repository by referencing them in your `.github/workflows/` directory. They can be used to automate tasks like code linting, releases, and more.

```yaml
# Example: .github/workflows/lint.yml
name: Lint
on: [pull_request]
jobs:
  lint:
    uses: umatare5/common/.github/workflows/go-test-fmt.yml@main
    with:
      go_version: "1.24.5"
```

## Available workflows

| Workflow                                                       | Description                       | Documentation                              |
| :------------------------------------------------------------- | :-------------------------------- | :----------------------------------------- |
| [`codeql.yml`](./codeql.yml)                                   | CodeQL security analysis          | [Guide](./docs/codeql.md)                  |
| [`go-test-build.yml`](./go-test-build.yml)                     | Go testing and binary build       | [Guide](./docs/go-test-build.md)           |
| [`go-test-coverage.yml`](./go-test-coverage.yml)               | Go coverage with a threshold      | [Guide](./docs/go-test-coverage.md)        |
| [`go-test-fmt.yml`](./go-test-fmt.yml)                         | Go formatting and lint            | [Guide](./docs/go-test-fmt.md)             |
| [`go-release.yml`](./go-release.yml)                           | Go release via GoReleaser         | [Guide](./docs/go-release.md)              |
| [`go-release-snapshot.yml`](./go-release-snapshot.yml)         | GoReleaser config and build check | [Guide](./docs/go-release-snapshot.md)     |
| [`go-vulncheck.yml`](./go-vulncheck.yml)                       | Go vulnerability scan             | [Guide](./docs/go-vulncheck.md)            |
| [`markdownlint.yml`](./markdownlint.yml)                       | Markdown style checks             | [Guide](./docs/markdownlint.md)            |
| [`lychee.yml`](./lychee.yml)                                   | Link check for Markdown and HTML  | [Guide](./docs/lychee.md)                  |
| [`promtool.yml`](./promtool.yml)                               | Prometheus rule validation        | [Guide](./docs/promtool.md)                |
| [`notify-workflow-failure.yml`](./notify-workflow-failure.yml) | Issue for a failed run            | [Guide](./docs/notify-workflow-failure.md) |
| [`tagging.yml`](./tagging.yml)                                 | Git tag from the version file     | [Guide](./docs/tagging.md)                 |

> [!NOTE]
>
> `internal-` workflows are only for internal use and not intended for public use.
