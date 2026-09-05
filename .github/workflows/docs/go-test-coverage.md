# go-test-coverage Reusable Workflow

A reusable GitHub Actions workflow for automated Go coverage testing with configurable thresholds.

## Usage

### Basic usage

```yaml
name: Coverage
on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

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

## Input parameters

| Parameter                  | Type    | Description                                         | Default          |
| :------------------------- | :------ | :-------------------------------------------------- | :--------------- |
| `go_version`               | string  | Go version to use                                   | `1.24.5`         |
| `coverage_threshold`       | number  | Minimum coverage percentage required                | `80`             |
| `coverage_file`            | string  | Coverage output file path                           | `./coverage.out` |
| `runs_on`                  | string  | Runner to use for the job                           | `ubuntu-24.04`   |
| `fetch_depth`              | number  | Number of commits to fetch (0 = all history)        | `1`              |
| `test_packages`            | string  | Test packages pattern                               | `./...`          |
| `gotestsum_format`         | string  | gotestsum output format                             | `testname`       |
| `enable_race_detection`    | boolean | Enable race detection in tests                      | `true`           |
| `coverage_exclude_pattern` | string  | Regular expression pattern to exclude from coverage | `""`             |

## Prerequisites

- Go project with valid `go.mod` file and test files

## Advanced usage

### 1. High coverage requirements

```yaml
jobs:
  coverage:
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main
    with:
      coverage_threshold: 95
      test_packages: "./internal/... ./pkg/..."
```

### 2. Performance optimization

```yaml
jobs:
  coverage:
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main
    with:
      enable_race_detection: false
      gotestsum_format: "short"
```

### 3. Excluding files/Directories from coverage

```yaml
jobs:
  coverage:
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main
    with:
      coverage_threshold: 80
      coverage_exclude_pattern: "(vendor/|_test\\.go:|mock.*\\.go:|.*\\.pb\\.go:)"
```

### 4. Parallel with other workflows

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

## Coverage exclusion patterns

The `coverage_exclude_pattern` parameter accepts regular expressions to exclude specific files or directories from coverage calculation. This is useful for excluding generated code, vendor dependencies, or test files.

### Common exclusion examples

#### Exclude test files and vendor directory

```yaml
coverage_exclude_pattern: "(vendor/|_test\\.go:)"
```

#### Exclude generated and mock files

```yaml
coverage_exclude_pattern: "(.*\\.pb\\.go:|mock.*\\.go:)"
```

#### Exclude specific directories

```yaml
coverage_exclude_pattern: "(cmd/|scripts/|examples/|docs/)"
```

#### Complex exclusion pattern

```yaml
coverage_exclude_pattern: "(vendor/|_test\\.go:|mock.*\\.go:|.*\\.pb\\.go:|cmd/|examples/|internal/testdata/)"
```

### How coverage exclusion works

1. **Test execution**: Tests run with full coverage profiling.
2. **Pattern filtering**: The workflow keeps the profile header, drops the lines the regular expression matches, and passes the remainder on. The header names the coverage mode, so a filter that removed it would leave the profile unreadable.
3. **Threshold check**: The percentage is calculated from the filtered data rather than from the original profile.

## Related links

- [Go Testing Documentation](https://go.dev/doc/tutorial/add-a-test)
- [gotestsum Documentation](https://github.com/gotestyourself/gotestsum)
- [Go Coverage Documentation](https://go.dev/blog/cover)
