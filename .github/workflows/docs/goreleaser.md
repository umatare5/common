# GoReleaser Reusable Workflow

A reusable GitHub Actions workflow for automating Go project releases using GoReleaser.

## 🚀 Usage

### Basic Usage

```yaml
name: Release
on:
  push:
    tags: ["v*"]

permissions:
  contents: write # For creating releases
  packages: write # For pushing to ghcr.io
  id-token: write # For OIDC authentication

jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser.yml@main
    with:
      runs_on: "ubuntu-24.04"
      go_version: "1.24.5"
      goreleaser_version: "v2.11.1"
```

## ⚙️ Input Parameters

| Parameter                 | Type    | Description                                  | Default           |
| ------------------------- | ------- | -------------------------------------------- | ----------------- |
| `go_version`              | string  | Go version to use                            | `1.24.5`          |
| `goreleaser_version`      | string  | GoReleaser version to use                    | `latest`          |
| `goreleaser_args`         | string  | Arguments to pass to GoReleaser              | `release --clean` |
| `runs_on`                 | string  | Runner to use for the job                    | `ubuntu-24.04`    |
| `fetch_depth`             | number  | Number of commits to fetch (0 = all history) | `0`               |
| `enable_docker`           | boolean | Enable Docker Buildx setup                   | `true`            |
| `registry`                | string  | Container registry to use                    | `ghcr.io`         |
| `goreleaser_distribution` | string  | GoReleaser distribution                      | `goreleaser`      |

## 📋 Prerequisites

Create an optional `.goreleaser.yml` file in your repository root.

## 📖 Advanced Usage

### 1. Performance Optimization

```yaml
jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser.yml@main
    with:
      runs_on: "ubuntu-latest"
      fetch_depth: 0 # Full history for complete release information
      goreleaser_args: "release --clean --parallelism=4"
```

### 2. Development Testing

```yaml
jobs:
  test-release:
    uses: umatare5/common/.github/workflows/goreleaser.yml@main
    with:
      goreleaser_args: "release --snapshot --clean --skip=publish"
      enable_docker: false
```

### 3. Debug Mode

```yaml
jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser.yml@main
    with:
      goreleaser_args: "release --clean --debug"
```

## Related Links

- [GoReleaser Documentation](https://goreleaser.com/)
- [GitHub Actions Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [GitHub Packages Documentation](https://docs.github.com/en/packages)
