# notify-failure Reusable Workflow

A reusable GitHub Actions workflow for recording a failed scheduled run as an issue.

## 🚀 Usage

### Basic Usage

```yaml
name: Notify Failure
on:
  workflow_run:
    workflows: ["Coverage", "Test and Build"]
    types: ["completed"]

permissions:
  contents: read

jobs:
  notify:
    if: github.event.workflow_run.event == 'schedule' && github.event.workflow_run.conclusion == 'failure'
    permissions:
      issues: write
    uses: umatare5/common/.github/workflows/notify-failure.yml@main
    with:
      workflow_name: ${{ github.event.workflow_run.name }}
      run_url: ${{ github.event.workflow_run.html_url }}
```

> [!Note]
>
> `workflows` matches the `name` of a workflow, not its file name. Listing a name the repository does not define is harmless, so the same caller can be copied across repositories.

## ⚙️ Input Parameters

| Parameter         | Type   | Description                      | Default        |
| ----------------- | ------ | -------------------------------- | -------------- |
| `workflow_name`   | string | Name of the workflow that failed | required       |
| `run_url`         | string | URL of the failed run            | required       |
| `runs_on`         | string | Runner to use for the job        | `ubuntu-24.04` |
| `timeout_minutes` | number | Job timeout in minutes           | `10`           |

## 📝 Prerequisites

The calling job needs `issues: write`. Issues must be enabled on the repository.

The workflow reuses one issue per `workflow_name`, matching on the exact title `Scheduled run failed: <workflow_name>`. Renaming the issue makes the next failure open a new one.

## 📖 Advanced Usage

### 1. Covering Every Scheduled Workflow

A `workflow_run` trigger accepts several names, so one caller covers every scheduled workflow in the repository.

```yaml
on:
  workflow_run:
    workflows:
      [
        "CodeQL Analysis",
        "Coverage",
        "Test and Build",
        "govulncheck",
        "Release Snapshot",
      ]
    types: ["completed"]
```

### 2. Notifying on Any Failure

Drop the event check to include failures from `push` and `pull_request` runs. Those already surface on the pull request, so this trades a redundant notification for wider coverage.

```yaml
jobs:
  notify:
    if: github.event.workflow_run.conclusion == 'failure'
```

## Related Links

- [workflow_run event](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#workflow_run)
- [GitHub CLI issue commands](https://cli.github.com/manual/gh_issue)
