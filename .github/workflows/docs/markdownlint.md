# markdownlint Reusable Workflow

A reusable GitHub Actions workflow for checking Markdown files against a repository's own markdownlint rules with markdownlint-cli2.

## Usage

### Basic usage

```yaml
name: markdownlint
on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

permissions:
  contents: read

jobs:
  markdownlint:
    uses: umatare5/common/.github/workflows/markdownlint.yml@main
```

> [!NOTE]
>
> A `pre-commit` hook only reaches contributors who installed it, and only the files they staged. This workflow is what holds the rules for everyone else.

## Input parameters

| Parameter         | Type   | Description                                    | Default        |
| :---------------- | :----- | :--------------------------------------------- | :------------- |
| `globs`           | string | Glob expression(s) to lint (newline-separated) | `**/*.md`      |
| `runs_on`         | string | Runner to use for the job                      | `ubuntu-24.04` |
| `fetch_depth`     | number | Number of commits to fetch (0 = all history)   | `1`            |
| `timeout_minutes` | number | Job timeout in minutes                         | `10`           |

The markdownlint-cli2 release is pinned in the workflow rather than taken as an input, so every caller lints with the same rule set and Renovate tracks it in one place.

## Prerequisites

A `.markdownlint-cli2.{jsonc,yaml,cjs,mjs}` or `.markdownlint.{jsonc,json,yaml,yml,cjs,mjs}` at the repository root. Without one, every rule runs at its default and `MD013/line-length` alone will report most prose.

Rules that need a per-file exception belong in that config's `overrides`, keyed by `filter`, rather than being switched off for the whole repository. That block needs markdownlint-cli2 v0.23.0 or later, which the pinned action supplies.

> [!IMPORTANT]
>
> markdownlint-cli2 does not exclude `node_modules` from a `**/*.md` glob. Set `"gitignore": true` in the configuration so the ignore rules the repository already declares apply to the lint as well.

## Advanced usage

### 1. Narrowing the trigger

Markdown changes on their own schedule, so the path filters keep the job off pull requests that touch no documentation.

```yaml
on:
  push:
    branches: ["main"]
    paths: ["**/*.md", ".markdownlint-cli2.jsonc"]
  pull_request:
    branches: ["main"]
    paths: ["**/*.md", ".markdownlint-cli2.jsonc"]
```

### 2. Linting a subset

`globs` is newline-separated and takes negations, which is the way to keep a vendored or generated tree out of the run when the repository tracks it.

```yaml
jobs:
  markdownlint:
    uses: umatare5/common/.github/workflows/markdownlint.yml@main
    with:
      globs: |
        docs/**/*.md
        !docs/generated/**
```

### 3. Custom runner

```yaml
jobs:
  markdownlint:
    uses: umatare5/common/.github/workflows/markdownlint.yml@main
    with:
      runs_on: "ubuntu-latest"
```

## Related links

- [markdownlint-cli2 Repository](https://github.com/DavidAnson/markdownlint-cli2)
- [markdownlint Rules Reference](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)
- [markdownlint-cli2 Configuration Schema](https://github.com/DavidAnson/markdownlint-cli2/blob/main/schema/markdownlint-cli2-config-schema.json)
- [markdownlint-cli2-action Releases](https://github.com/DavidAnson/markdownlint-cli2-action/releases)
