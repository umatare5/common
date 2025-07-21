# golangci-lint Reusable Workflow

A reusable GitHub Actions workflow for automated Go code quality checks using golangci-lint.

## Features

- Go environment setup with configurable version
- golangci-lint installation with configurable version
- Caching for faster execution
- Aggressive Go modules cleanup and verification
- Comprehensive Go environment verification
- Configurable golangci-lint configuration file

## Prerequisites

### Go Project Structure

Standard Go project structure with go.mod:

```text
your-project/
├── go.mod
├── go.sum
├── main.go
├── .golangci.yml  # Optional configuration file
└── ...
```

## golangci-lint Configuration

Optionally, create a `.golangci.yml` configuration file in your repository root. If not provided, golangci-lint will use default settings.

## Usage

### Basic Usage

```yaml
name: Lint

on:
  pull_request:

jobs:
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
```

### Advanced Usage

```yaml
name: Lint

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      go_version: "1.24.5"
      golangci_lint_version: "v1.64.8"
      golangci_lint_config: ".golangci.yml"
```

## Input Parameters

| Parameter               | Description                    | Default         |
| ----------------------- | ------------------------------ | --------------- |
| `go_version`            | Go version to use              | `1.24.5`        |
| `golangci_lint_version` | golangci-lint version to use   | `v1.64.8`       |
| `golangci_lint_config`  | golangci-lint config file path | `.golangci.yml` |

## Use Cases

### 1. Custom Go Version

```yaml
jobs:
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      go_version: "1.23.0"
```

### 2. Specific golangci-lint Version

```yaml
jobs:
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      golangci_lint_version: "v1.64.8"
```

### 3. Custom Configuration File

```yaml
jobs:
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      golangci_lint_config: "config/.golangci.yml"
```

### 4. Multiple Jobs for Different Directories

```yaml
jobs:
  lint-api:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      golangci_lint_config: "api/.golangci.yml"

  lint-web:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      golangci_lint_config: "web/.golangci.yml"
```

## What the Workflow Does

1. **Checkout**: Retrieves the source code
2. **Go Setup**: Installs the specified Go version
3. **Cache**: Sets up caching for golangci-lint binary
4. **Install golangci-lint**: Downloads and installs the specified version
5. **Clean Go Environment**: Aggressively cleans caches and modules
6. **Module Management**: Downloads, tidies, and verifies Go modules
7. **Environment Verification**: Checks Go environment and modules
8. **Lint Execution**: Runs golangci-lint with verbose output

## Configuration Examples

### Default Configuration

If no configuration file is specified, golangci-lint uses its default settings.

### Example .golangci.yml

```yaml
run:
  timeout: 5m
  modules-download-mode: readonly

linters:
  enable:
    - gofmt
    - golint
    - govet
    - ineffassign
    - misspell
    - deadcode
    - varcheck
    - structcheck

linters-settings:
  gofmt:
    simplify: true
```

## Troubleshooting

### Common Issues

1. **Go Module Issues**

   ```text
   Error: go: module not found
   ```

   → Ensure your go.mod file is properly configured

2. **golangci-lint Configuration Errors**

   ```text
   Error: can't load config
   ```

   → Check your .golangci.yml file syntax

3. **Cache Issues**

   ```text
   Error: failed to download modules
   ```

   → The workflow automatically cleans caches, but you may need to check your module dependencies

### Debug Tips

- Check the "Verify Go environment" step output for module and import information
- Review the golangci-lint verbose output for detailed linting results
- Ensure all dependencies in go.mod are accessible

## Integration with CI/CD

### Combined with Testing

```yaml
jobs:
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main

  test:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version: "1.24.5"
      - run: go test ./...
```

### Matrix Strategy

```yaml
jobs:
  lint:
    strategy:
      matrix:
        go-version: ["1.23.0", "1.24.5"]
    uses: umatare5/common/.github/workflows/golangci-lint-action.yml@main
    with:
      go_version: ${{ matrix.go-version }}
```

## Related Links

- [golangci-lint Documentation](https://golangci-lint.run/)
- [golangci-lint Configuration](https://golangci-lint.run/usage/configuration/)
- [Go Modules Documentation](https://go.dev/doc/modules/)
