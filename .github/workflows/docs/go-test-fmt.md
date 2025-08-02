# go-test-fmt Reusable Workflow

A reusable GitHub Actions workflow for automated Go code formatting and quality checks.

## 🚀 Usage

### Basic Usage

```yaml
name: Format and Lint
on: [pull_request]

permissions:
  contents: read

jobs:
  fmt:
    uses: umatare5/common/.github/workflows/go-test-fmt.yml@main
    with:
      runs_on: "ubuntu-24.04"
      go_version: "1.24.5"
      golangci_lint_version: "v1.64.8"
```

## ⚙️ Input Parameters

| Parameter               | Type    | Description                                  | Default                             |
| ----------------------- | ------- | -------------------------------------------- | ----------------------------------- |
| `go_version`            | string  | Go version to use                            | `1.24.5`                            |
| `golangci_lint_version` | string  | golangci-lint version to use                 | `v1.64.8`                           |
| `golangci_lint_config`  | string  | golangci-lint config file path               | `.golangci.yml`                     |
| `runs_on`               | string  | Runner to use for the job                    | `ubuntu-24.04`                      |
| `fetch_depth`           | number  | Number of commits to fetch (0 = all history) | `1`                                 |
| `timeout`               | string  | Timeout for golangci-lint execution          | `5m`                                |
| `golangci_lint_args`    | string  | Additional arguments for golangci-lint       | `--verbose --print-resources-usage` |
| `enable_cache`          | boolean | Enable golangci-lint cache                   | `true`                              |
| `cache_key_suffix`      | string  | Additional suffix for cache key              | `""`                                |

## 📝 Prerequisites

Create an optional `.golangci.yml` file in your repository root.

## 📖 Advanced Usage

### 1. Custom Configuration

```yaml
jobs:
  fmt:
    uses: umatare5/common/.github/workflows/go-test-fmt.yml@main
    with:
      golangci_lint_config: "configs/lint.yml"
      golangci_lint_args: "--verbose --print-resources-usage --issues-exit-code=0"
      timeout: "15m"
```

### 2. Combined with Testing

```yaml
jobs:
  fmt:
    uses: umatare5/common/.github/workflows/go-test-fmt.yml@main

  test-build:
    needs: fmt
    uses: umatare5/common/.github/workflows/go-test-build.yml@main

  coverage:
    needs: fmt
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main
```

### 3. Performance Optimization

```yaml
jobs:
  fmt:
    uses: umatare5/common/.github/workflows/go-test-fmt.yml@main
    with:
      runs_on: "ubuntu-latest"
      fetch_depth: 0 # Full history for comprehensive analysis
      timeout: "10m"
      enable_cache: true
      cache_key_suffix: "-custom"
```

## Related Links

- [golangci-lint Documentation](https://golangci-lint.run/)
- [golangci-lint Configuration](https://golangci-lint.run/usage/configuration/)
- [Go Modules Documentation](https://go.dev/doc/modules/)
