# scorecard Reusable Workflow

A reusable GitHub Actions workflow for automated OSSF Scorecard security analysis that evaluates your repository's security practices and compliance.

## 🚀 Usage

### Basic Usage

```yaml
name: Security Scorecard
on:
  schedule:
    - cron: "29 9 * * 4"
  push:
    branches: ["main"]
  branch_protection_rule:

permissions:
  contents: read
  security-events: write
  id-token: write

jobs:
  scorecard:
    uses: umatare5/common/.github/workflows/scorecard.yml@main
    with:
      publish_results: true
      upload_artifacts: true
```

## ⚙️ Input Parameters

| Parameter                 | Type    | Description                                                        | Default         |
| ------------------------- | ------- | ------------------------------------------------------------------ | --------------- |
| `runs_on`                 | string  | Runner to use for the job                                          | `ubuntu-24.04`  |
| `fetch_depth`             | number  | Number of commits to fetch (0 = all history)                       | `1`             |
| `results_file`            | string  | Output file for Scorecard results                                  | `results.sarif` |
| `results_format`          | string  | Format for Scorecard results                                       | `sarif`         |
| `publish_results`         | boolean | Publish results to OpenSSF REST API (only works on default branch) | `true`          |
| `upload_artifacts`        | boolean | Upload results as artifacts                                        | `true`          |
| `upload_to_code_scanning` | boolean | Upload results to GitHub's code scanning dashboard                 | `true`          |
| `artifact_name`           | string  | Name for the uploaded artifact                                     | `SARIF file`    |
| `artifact_retention_days` | number  | Retention days for uploaded artifacts                              | `5`             |

## 🔐 Secrets

| Secret            | Description                                                             | Required |
| ----------------- | ----------------------------------------------------------------------- | -------- |
| `scorecard_token` | PAT token for private repositories or enhanced Branch-Protection checks | No       |

## 📝 Prerequisites

- Repository with security practices to analyze
- For private repositories: Configure `scorecard_token` secret for enhanced analysis
- For Branch-Protection checks on public repositories: Configure `scorecard_token` secret

## 📖 Advanced Usage

### 1. Private Repository Configuration

```yaml
jobs:
  scorecard:
    uses: umatare5/common/.github/workflows/scorecard.yml@main
    with:
      publish_results: false # Always false for private repos
      upload_artifacts: true
    secrets:
      scorecard_token: ${{ secrets.SCORECARD_TOKEN }}
```

### 2. Custom Output Configuration

```yaml
jobs:
  scorecard:
    uses: umatare5/common/.github/workflows/scorecard.yml@main
    with:
      results_file: "security-scorecard.sarif"
      artifact_name: "Security Scorecard Results"
      artifact_retention_days: 30
```

### 3. Minimal Configuration (Artifacts Only)

```yaml
jobs:
  scorecard:
    uses: umatare5/common/.github/workflows/scorecard.yml@main
    with:
      publish_results: false
      upload_to_code_scanning: false
      upload_artifacts: true
```

### 4. Enhanced Branch Protection Analysis

```yaml
jobs:
  scorecard:
    uses: umatare5/common/.github/workflows/scorecard.yml@main
    with:
      publish_results: true
    secrets:
      scorecard_token: ${{ secrets.SCORECARD_TOKEN }} # Enables enhanced checks
```

## 🛡️ Security Considerations

> [!IMPORTANT]
> The workflow only runs on the default branch or pull requests to ensure `publish_results` works correctly.

> [!WARNING]
> For private repositories, set `publish_results: false` as publishing is automatically disabled regardless of the input value.

> [!CAUTION]
> When using `scorecard_token`, ensure it has minimal required permissions:
>
> - `Contents: read` (for repository access)
> - `Actions: read` (for workflow analysis)

## 📊 Understanding Results

The workflow generates a SARIF file containing security scores and recommendations for:

- **Code-Review**: Checks if code changes are reviewed before merging
- **Branch-Protection**: Verifies branch protection rules are configured
- **Signed-Releases**: Checks if releases are signed
- **Dependency-Update-Tool**: Verifies automated dependency updates
- **Security-Policy**: Checks for security policy documentation
- **Vulnerabilities**: Scans for known security vulnerabilities
- And many more security best practices...

## 🔗 Related Links

- [OSSF Scorecard Documentation](https://github.com/ossf/scorecard)
- [Scorecard Action Documentation](https://github.com/ossf/scorecard-action)
- [Security Best Practices Guide](https://docs.github.com/en/code-security)
- [SARIF Format Specification](https://sarifweb.azurewebsites.net/)
