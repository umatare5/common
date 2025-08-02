# go-release Reusable Workflow

A reusable GitHub Actions workflow for automating Go project releases.

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
    uses: umatare5/common/.github/workflows/go-release.yml@main
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
    uses: umatare5/common/.github/workflows/go-release.yml@main
    with:
      runs_on: "ubuntu-latest"
      fetch_depth: 0
      goreleaser_version: "v2.11.1"
```

### 2. Custom Configuration

```yaml
jobs:
  release:
    uses: umatare5/common/.github/workflows/go-release.yml@main
    with:
      goreleaser_args: "release --clean --skip=validate"
      enable_docker: false
      registry: "docker.io"
```

### 3. Combined with Testing

```yaml
jobs:
  test-build:
    uses: umatare5/common/.github/workflows/go-test-build.yml@main

  coverage:
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main

  lint:
    uses: umatare5/common/.github/workflows/go-test-lint.yml@main

  release:
    needs: [test-build, coverage, lint]
    uses: umatare5/common/.github/workflows/go-release.yml@main
    with:
      goreleaser_version: "v2.11.1"
```

## Related Links

- [GoReleaser Documentation](https://goreleaser.com/)
- [GoReleaser Configuration](https://goreleaser.com/customization/)
- [GitHub Releases Documentation](https://docs.github.com/en/repositories/releasing-projects-on-github)
