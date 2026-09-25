# Coverage Badge Reusable Workflow

A reusable GitHub Actions workflow that stores the coverage badge [`go-test-coverage.yml`](./go-test-coverage.md) renders on a `badges` branch, from where a README shows it.

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

jobs:
  coverage:
    uses: umatare5/common/.github/workflows/go-test-coverage.yml@main
    with:
      enable_badge: true

  badge:
    needs: coverage
    if: ${{ !cancelled() && needs.coverage.outputs.badge != '' }}
    permissions:
      contents: write
    uses: umatare5/common/.github/workflows/coverage-badge.yml@main
    with:
      badge: ${{ needs.coverage.outputs.badge }}
```

The README then shows the stored badge.

```text
<img alt="Test Coverage" src="https://raw.githubusercontent.com/OWNER/REPO/badges/coverage.svg" />
```

## Input parameters

| Parameter | Type   | Description                                                   | Default        |
| :-------- | :----- | :------------------------------------------------------------ | :------------- |
| `badge`   | string | Base64 SVG badge, the `badge` output of the coverage workflow | —              |
| `runs_on` | string | Runner to use for the job                                     | `ubuntu-24.04` |

## Behavior

Only the run for the default branch's latest commit writes, so a late or re-run job cannot roll the badge back, and a badge equal to the stored one adds no commit. Pull requests never write, because the coverage workflow renders no badge for them and the `if` above skips the job on an empty one.

Each change replaces the `badges` branch with a single root commit holding `coverage.svg`, so the branch keeps no history and nothing else belongs on it. The first run creates the branch, and a ruleset that covers it, such as one on every branch, blocks the replacement.

## Prerequisites

- **Permissions**: the calling job grants `contents: write`, because a reusable workflow cannot raise the permissions its caller passes down
- **Repository**: public, because `raw.githubusercontent.com` serves nothing from a private one
- **Runner**: one with `gh` and `jq`, which the GitHub-hosted Ubuntu images carry

## Related links

- [Git database API](https://docs.github.com/en/rest/git)
- [octocov](https://github.com/k1LoW/octocov)
