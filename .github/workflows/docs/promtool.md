# promtool Reusable Workflow

A reusable GitHub Actions workflow for validating Prometheus alerting and recording rules with promtool.

## 🚀 Usage

### Basic Usage

```yaml
name: Rules
on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

permissions:
  contents: read

jobs:
  promtool:
    uses: umatare5/common/.github/workflows/promtool.yml@main
    with:
      rule_files: |
        examples/prometheus_alert_rules.yml
      test_files: |
        examples/prometheus_alert_rules_test.yml
```

> [!Note]
>
> The workflow fails on a lint finding, because `promtool` prints `FAILED` and still exits `0` unless `--lint-fatal` is passed. Set `lint: "none"` to keep the syntax check while adopting the lint checks gradually.

## ⚙️ Input Parameters

| Parameter          | Type   | Description                                             | Default        |
| ------------------ | ------ | ------------------------------------------------------- | -------------- |
| `promtool_version` | string | Prometheus release to take promtool from                | `3.13.2`       |
| `rule_files`       | string | Rule files to check (newline-separated)                 | required       |
| `test_files`       | string | Rule unit test files to run (newline-separated)         | `""`           |
| `config_files`     | string | Prometheus config files to check (newline-separated)    | `""`           |
| `lint`             | string | Lint checks to apply (`all`, `duplicate-rules`, `none`) | `all`          |
| `runs_on`          | string | Runner to use for the job                               | `ubuntu-24.04` |
| `fetch_depth`      | number | Number of commits to fetch (0 = all history)            | `1`            |
| `timeout_minutes`  | number | Job timeout in minutes                                  | `10`           |

Pin `promtool_version` to the Prometheus you actually run, and raise it deliberately: a newer release can add a lint check that turns a green repository red without a local change.

## 📝 Prerequisites

At least one rule file in your repository. Every list takes literal paths, one per line — promtool does not expand a glob and fails on one.

A test file, if given, follows the [rule unit test](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/) format and resolves its own `rule_files` paths relative to itself. The workflow fails if one of those paths matches nothing, because promtool reports that as a warning and would otherwise evaluate every assertion against no rules at all.

`runs_on` must name a Linux runner with GNU coreutils: the install step fetches the `linux-amd64` or `linux-arm64` archive and verifies it with `sha256sum --ignore-missing`.

## 📖 Advanced Usage

### 1. Unit Testing the Rules

`check rules` reports malformed rules only. A rule whose expression is valid but selects the wrong series passes it, and so does a typo in a metric name. `test rules` evaluates the rules against series you supply, so it is the check that holds an expression to its intended result.

```yaml
jobs:
  promtool:
    uses: umatare5/common/.github/workflows/promtool.yml@main
    with:
      rule_files: |
        examples/alert_rules.yml
        examples/recording_rules.yml
      test_files: |
        examples/alert_rules_test.yml
```

### 2. Checking the Scrape Configuration

`check config` validates each rule file its `rule_files` sections name, not only the path, so a malformed rule there fails this step too. A `rule_files` pattern that matches nothing passes silently, which is the normal state for a config shipped with those entries commented out.

```yaml
jobs:
  promtool:
    uses: umatare5/common/.github/workflows/promtool.yml@main
    with:
      rule_files: |
        examples/alert_rules.yml
      config_files: |
        examples/prometheus.yml
```

### 3. Pinning promtool

```yaml
jobs:
  promtool:
    uses: umatare5/common/.github/workflows/promtool.yml@main
    with:
      promtool_version: "3.13.2"
      rule_files: |
        examples/alert_rules.yml
```

## Related Links

- [promtool Documentation](https://prometheus.io/docs/prometheus/latest/command-line/promtool/)
- [Recording and Alerting Rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/)
- [Unit Testing for Rules](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/)
- [Prometheus Releases](https://github.com/prometheus/prometheus/releases)
