# go-test-coverage Reusable Workflow

A reusable GitHub Actions workflow for automated Go coverage testing with configurable thresholds.

## 🚀 Usage

### Basic Usage

```yaml
name: Coverage
on: [push, pull_request]

permissions:
  contents: read
  pull-requests: write

jobs:
  coverage:
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main
    with:
      go_version: "1.24.5"
      coverage_threshold: 80
```

## ⚙️ Input Parameters

| Parameter               | Type    | Description                                  | Default          |
| ----------------------- | ------- | -------------------------------------------- | ---------------- |
| `go_version`            | string  | Go version to use                            | `1.24.5`         |
| `coverage_threshold`    | number  | Minimum coverage percentage required         | `80`             |
| `coverage_file`         | string  | Coverage output file path                    | `./coverage.out` |
| `runs_on`               | string  | Runner to use for the job                    | `ubuntu-24.04`   |
| `fetch_depth`           | number  | Number of commits to fetch (0 = all history) | `1`              |
| `test_packages`         | string  | Test packages pattern                        | `./...`          |
| `gotestsum_format`      | string  | gotestsum output format                      | `testname`       |
| `enable_race_detection` | boolean | Enable race detection in tests               | `true`           |

## 📝 Prerequisites

- Go project with valid `go.mod` file and test files

## 📖 Advanced Usage

### 1. High Coverage Requirements

```yaml
jobs:
  coverage:
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main
    with:
      coverage_threshold: 95
      test_packages: "./internal/... ./pkg/..."
```

### 2. Performance Optimization

```yaml
jobs:
  coverage:
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main
    with:
      enable_race_detection: false
      gotestsum_format: "short"
```

### 3. Parallel with Other Workflows

```yaml
jobs:
  test-build:
    uses: umatare5/common/.github/workflows/go-test-build.yml@main

  coverage:
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main
    with:
      coverage_threshold: 85

  fmt:
    uses: umatare5/common/.github/workflows/go-test-fmt.yml@main
```

## Related Links

- [Go Testing Documentation](https://go.dev/doc/tutorial/add-a-test)
- [gotestsum Documentation](https://github.com/gotestyourself/gotestsum)
- [Go Coverage Documentation](https://go.dev/blog/cover)
