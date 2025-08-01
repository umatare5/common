# go-test Reusable Workflow

A reusable GitHub Actions workflow for automated Go testing, coverage checks, and binary build verification.

## 🚀 Usage

### Basic Usage

```yaml
name: Test
on: [push, pull_request]

permissions:
  contents: read
  pull-requests: write

jobs:
  test:
    uses: umatare5/common/.github/workflows/go-test.yml@main
    with:
      go_version: "1.24.5"
      coverage_threshold: 80
      build_cmd_path: "./cmd"
      build_output_path: "./tmp/app"
```

## ⚙️ Input Parameters

| Parameter               | Type    | Description                                  | Default          |
| ----------------------- | ------- | -------------------------------------------- | ---------------- |
| `go_version`            | string  | Go version to use                            | `1.24.5`         |
| `coverage_threshold`    | number  | Minimum coverage percentage required         | `80`             |
| `coverage_file`         | string  | Coverage output file path                    | `./coverage.out` |
| `runs_on`               | string  | Runner to use for the job                    | `ubuntu-24.04`   |
| `fetch_depth`           | number  | Number of commits to fetch (0 = all history) | `1`              |
| `build_cmd_path`        | string  | Path to the command to build                 | `./cmd`          |
| `build_output_path`     | string  | Output path for the built binary             | `./tmp/app`      |
| `test_packages`         | string  | Test packages pattern                        | `./...`          |
| `gotestsum_format`      | string  | gotestsum output format                      | `testname`       |
| `enable_race_detection` | boolean | Enable race detection in tests               | `true`           |

## 📝 Prerequisites

- Go project with valid `go.mod` file and test files
- Built binary should support `--version` and `--help` flags

## 📖 Advanced Usage

### 1. Custom Build Configuration

```yaml
jobs:
  test:
    uses: umatare5/common/.github/workflows/go-test.yml@main
    with:
      build_cmd_path: "./cmd/myapp"
      build_output_path: "./bin/myapp"
      coverage_threshold: 90
      test_packages: "./internal/... ./pkg/..."
```

### 2. Performance Optimization

```yaml
jobs:
  test:
    uses: umatare5/common/.github/workflows/go-test.yml@main
    with:
      enable_race_detection: false
      gotestsum_format: "short"
      runs_on: "ubuntu-latest"
```

### 3. Combined with Linting

```yaml
jobs:
  lint:
    uses: umatare5/common/.github/workflows/golangci-lint.yml@main

  test:
    needs: lint
    uses: umatare5/common/.github/workflows/go-test.yml@main
    with:
      coverage_threshold: 85
```

## Related Links

- [Go Testing Documentation](https://go.dev/doc/tutorial/add-a-test)
- [gotestsum Documentation](https://github.com/gotestyourself/gotestsum)
- [Go Coverage Documentation](https://go.dev/blog/cover)
