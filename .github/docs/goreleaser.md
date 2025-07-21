# GoReleaser Reusable Workflow

A reusable GitHub Actions workflow for automating Go project releases using GoReleaser.

## Features

- Go environment setup with configurable version
- Optional Docker Buildx setup for container builds
- Container registry login (configurable)
- Automated binary and Docker image building/publishing
- Flexible configuration options

## Prerequisites

### Required Permissions

The calling workflow must set the following permissions:

```yaml
permissions:
  contents: write # For creating releases
  packages: write # For pushing to container registries
  id-token: write # For OIDC authentication
```

### GoReleaser Configuration

Your project must have a `.goreleaser.yml` or `.goreleaser.yaml` file in the repository root.

### Go Project Structure

Standard Go project structure is expected:

```text
your-project/
├── .goreleaser.yml
├── go.mod
├── go.sum
├── main.go
└── ...
```

## Usage

### Basic Usage

```yaml
name: Release

on:
  push:
    tags:
      - "v*"

permissions:
  contents: write
  packages: write
  id-token: write

jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
```

### Advanced Usage

```yaml
name: Release

on:
  workflow_dispatch:

permissions:
  contents: write
  packages: write
  id-token: write

jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
    with:
      go_version: "1.24.5"
      goreleaser_version: "latest"
      goreleaser_args: "release --clean --timeout 60m"
      runs_on: "ubuntu-latest"
      fetch_depth: 0
      enable_docker: true
      registry: "ghcr.io"
      goreleaser_distribution: "goreleaser"
```

## Input Parameters

| Parameter                 | Description                                  | Default           |
| ------------------------- | -------------------------------------------- | ----------------- |
| `go_version`              | Go version to use                            | `1.24.5`          |
| `goreleaser_version`      | GoReleaser version to use                    | `latest`          |
| `goreleaser_args`         | Arguments to pass to GoReleaser              | `release --clean` |
| `runs_on`                 | Runner to use for the job                    | `ubuntu-24.04`    |
| `fetch_depth`             | Git history depth to fetch (0 = all history) | `0`               |
| `enable_docker`           | Enable Docker Buildx setup                   | `true`            |
| `registry`                | Container registry to use                    | `ghcr.io`         |
| `goreleaser_distribution` | GoReleaser distribution                      | `goreleaser`      |

## Use Cases

### 1. Release without Docker

```yaml
jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
    with:
      enable_docker: false
      goreleaser_args: "release --clean --skip=docker"
```

### 2. Using Different Container Registry

```yaml
jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
    with:
      registry: "docker.io"
      # Additional authentication may be required for Docker Hub
```

### 3. Self-hosted Runner

```yaml
jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
    with:
      runs_on: "self-hosted"
```

### 4. GoReleaser Pro

```yaml
jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
    with:
      goreleaser_distribution: "goreleaser-pro"
      goreleaser_version: "latest"
```

### 5. Development Testing

```yaml
jobs:
  test-release:
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
    with:
      goreleaser_args: "release --snapshot --clean --skip=publish"
      enable_docker: false
```

## Troubleshooting

### Common Issues

1. **Permission Errors**

   ```text
   Error: Resource not accessible by integration
   ```

   → Ensure proper `permissions` are set in the calling workflow

2. **GoReleaser Configuration Errors**

   ```text
   Error: failed to parse config
   ```

   → Check your `.goreleaser.yml` file syntax

3. **Docker-related Errors**

   ```text
   Error: failed to build docker image
   ```

   → Set `enable_docker: false` to disable Docker builds or check your Dockerfile

### Debug Mode

For detailed logs:

```yaml
jobs:
  release:
    uses: umatare5/common/.github/workflows/goreleaser-action.yml@main
    with:
      goreleaser_args: "release --clean --debug"
```

## Related Links

- [GoReleaser Documentation](https://goreleaser.com/)
- [GitHub Actions Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [GitHub Packages Documentation](https://docs.github.com/en/packages)
