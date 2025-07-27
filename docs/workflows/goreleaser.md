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
  contents: write
  packages: write
  id-token: write

jobs:
  release:
    uses: umatare5/common/workflows/goreleaser.yml@main
    with:
      go_version: "1.24.5"
      setup_docker: true
      registry_login: true
    secrets:
      registry_username: ${{ secrets.DOCKER_USERNAME }}
      registry_password: ${{ secrets.DOCKER_PASSWORD }}
```

## ⚙️ Input Parameters

| Parameter            | Description                     | Default           |
| -------------------- | ------------------------------- | ----------------- |
| `go_version`         | Go version to use               | `1.24.5`          |
| `goreleaser_version` | GoReleaser version to use       | `latest`          |
| `goreleaser_args`    | Arguments to pass to GoReleaser | `release --clean` |
| `runs_on`            | Runner to use for the job       | `ubuntu-24.04`    |
| `setup_docker`       | Enable Docker Buildx setup      | `true`            |
| `registry_login`     | Enable container registry login | `false`           |

## 📋 Prerequisites

Create an optional `.goreleaser.yml` file in your repository root.

## 📖 Advanced Usage

### 1. Using Different Container Registry

```yaml
jobs:
  release:
    uses: umatare5/common/workflows/goreleaser.yml@main
    with:
      registry: "docker.io"
      # Additional authentication may be required for Docker Hub
```

### 2. Development Testing

```yaml
jobs:
  test-release:
    uses: umatare5/common/workflows/goreleaser.yml@main
    with:
      goreleaser_args: "release --snapshot --clean --skip=publish"
      enable_docker: false
```

### 3. Debug Mode

For detailed logs:

```yaml
jobs:
  release:
    uses: umatare5/common/workflows/goreleaser.yml@main
    with:
      goreleaser_args: "release --clean --debug"
```

## Related Links

- [GoReleaser Documentation](https://goreleaser.com/)
- [GitHub Actions Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [GitHub Packages Documentation](https://docs.github.com/en/packages)
