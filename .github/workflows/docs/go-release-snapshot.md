# go-release-snapshot Reusable Workflow

A reusable GitHub Actions workflow for validating the GoReleaser configuration and every cross-compilation target without publishing.

## Usage

### Basic usage

```yaml
name: Release Snapshot
on:
  schedule:
    - cron: "0 2 * * 1" # every Monday at 2:00

permissions:
  contents: read

jobs:
  snapshot:
    uses: umatare5/common/.github/workflows/go-release-snapshot.yml@main
    with:
      go_version: "1.27.0"
      goreleaser_version: "v2.18.0"
```

> [!NOTE]
>
> The workflow produces no tag, no release and no container image. It runs `goreleaser check` followed by `goreleaser build --snapshot --clean`.

## Input parameters

| Parameter                 | Type   | Description                                  | Default        |
| :------------------------ | :----- | :------------------------------------------- | :------------- |
| `go_version`              | string | Go version to use                            | `1.24.5`       |
| `goreleaser_version`      | string | GoReleaser version to use                    | `latest`       |
| `goreleaser_distribution` | string | GoReleaser distribution                      | `goreleaser`   |
| `runs_on`                 | string | Runner to use for the job                    | `ubuntu-24.04` |
| `fetch_depth`             | number | Number of commits to fetch (0 = all history) | `0`            |
| `timeout_minutes`         | number | Job timeout in minutes                       | `20`           |

Pin `goreleaser_version` to the release used by `go-release.yml`. A snapshot built with a different version validates a configuration the release run never sees.

## Prerequisites

A `.goreleaser.yml` or `.goreleaser.yaml` in the repository root, with at least one entry under `builds`. A configuration that sets `builds: [{skip: true}]` has no target to compile, so the snapshot step succeeds without covering anything.

## Advanced usage

### 1. Pairing with the release workflow

Regular CI compiles for the runner platform only. This workflow covers the remaining targets, so a break in a platform nobody builds locally surfaces on a schedule rather than during a release.

```yaml
jobs:
  snapshot:
    uses: umatare5/common/.github/workflows/go-release-snapshot.yml@main
    with:
      go_version: "1.27.0"
      goreleaser_version: "v2.18.0"
```

### 2. Running it on a pull request

Cross-compiling every target costs far more than a single build, so keep this on a schedule unless a pull request changes the release configuration.

```yaml
on:
  pull_request:
    paths: [".goreleaser.yml"]
```

## Related links

- [GoReleaser build command](https://goreleaser.com/cmd/goreleaser_build/)
- [GoReleaser check command](https://goreleaser.com/cmd/goreleaser_check/)
