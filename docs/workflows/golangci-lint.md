# golangci-lint Reusable Workflow

A reusable GitHub Actions workflow for automated Go code quality checks using golangci-lint.

## 🚀 Usage

### Basic Usage

```yaml
name: Lint
on: [pull_request]

permissions:
  contents: read

jobs:
  lint:
    uses: umatare5/common/workflows/golangci-lint.yml@main
    with:
      go_version: "1.24.5"
      golangci_lint_version: "v1.64.8"
      golangci_lint_config: ".golangci.yml"
```

## ⚙️ Input Parameters

| Parameter               | Description                    | Default         |
| ----------------------- | ------------------------------ | --------------- |
| `go_version`            | Go version to use              | `1.24.5`        |
| `golangci_lint_version` | golangci-lint version to use   | `v1.64.8`       |
| `golangci_lint_config`  | golangci-lint config file path | `.golangci.yml` |

## 📝 Prerequisites

Create an optional `.golangci.yml` file in your repository root.

## 📖 Advanced Usage

### 1. Combined with Testing

```yaml
jobs:
  lint:
    uses: umatare5/common/workflows/golangci-lint.yml@main

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

### 2. Matrix Strategy

```yaml
jobs:
  lint:
    strategy:
      matrix:
        go-version: ["1.23.0", "1.24.5"]
    uses: umatare5/common/workflows/golangci-lint.yml@main
    with:
      go_version: ${{ matrix.go-version }}
```

## Related Links

- [golangci-lint Documentation](https://golangci-lint.run/)
- [golangci-lint Configuration](https://golangci-lint.run/usage/configuration/)
- [Go Modules Documentation](https://go.dev/doc/modules/)
