# go-vulncheck Reusable Workflow

A reusable GitHub Actions workflow for scanning a Go module against the Go vulnerability database with govulncheck.

## 🚀 Usage

### Basic Usage

```yaml
name: govulncheck
on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

permissions:
  contents: read

jobs:
  go-vulncheck:
    uses: umatare5/common/.github/workflows/go-vulncheck.yml@main
```

> [!Note]
>
> This is the only check here that covers the standard library and the toolchain. The GitHub Advisory Database carries no Go-ecosystem entry for either, so Dependabot reports neither.

## ⚙️ Input Parameters

| Parameter         | Type   | Description                                       | Default        |
| ----------------- | ------ | ------------------------------------------------- | -------------- |
| `go_version`      | string | Go version to use (empty: read `go_version_file`) | `""`           |
| `go_version_file` | string | File to read the Go toolchain from                | `go.mod`       |
| `scan_packages`   | string | Package pattern to scan                           | `./...`        |
| `runs_on`         | string | Runner to use for the job                         | `ubuntu-24.04` |
| `fetch_depth`     | number | Number of commits to fetch (0 = all history)      | `1`            |
| `timeout_minutes` | number | Job timeout in minutes                            | `10`           |

The govulncheck release is pinned in the workflow rather than taken as an input, so every caller scans with the same version and Renovate tracks it in one place.

## 📝 Prerequisites

A `go.mod` at the repository root. The default reads the toolchain from it rather than from a version string, so a standard-library finding names the Go the repository actually declares.

That declared Go must be at or above the `go` directive of the pinned govulncheck release — `v1.7.0` requires `go 1.25.0`. Below it, `GOTOOLCHAIN=auto` fetches a newer toolchain and the scan silently reports against a version the repository never declared.

A two-component directive such as `go 1.27` floats to the newest patch. An exact `go 1.25.2`, or a `toolchain` directive, pins that patch, and every later security release then shows as a finding until the directive is raised — which is the point.

## 📖 Advanced Usage

### 1. Scheduling the Scan

A new advisory affects a repository that has not changed, so the schedule is what turns the check red without a commit. The path filters keep it off the pull requests that touch no Go code.

```yaml
on:
  push:
    branches: ["main"]
    paths: ["go.mod", "go.sum", "**.go"]
  pull_request:
    branches: ["main"]
    paths: ["go.mod", "go.sum", "**.go"]
  schedule:
    - cron: "30 2 * * 1"
```

### 2. Scanning a Subset

```yaml
jobs:
  go-vulncheck:
    uses: umatare5/common/.github/workflows/go-vulncheck.yml@main
    with:
      scan_packages: "./internal/..."
```

### 3. Overriding the Toolchain

`go_version` takes precedence over `go_version_file`. Setting it scans a version other than the declared one, which is worth doing only to reproduce a finding.

```yaml
jobs:
  go-vulncheck:
    uses: umatare5/common/.github/workflows/go-vulncheck.yml@main
    with:
      go_version: "1.27.0"
```

## Related Links

- [govulncheck Documentation](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)
- [Go Vulnerability Management](https://go.dev/doc/security/vuln/)
- [Go Vulnerability Database](https://vuln.go.dev)
- [golang.org/x/vuln Releases](https://github.com/golang/vuln/releases)
