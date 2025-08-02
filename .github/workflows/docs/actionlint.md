# actionlint Reusable Workflow

A reusable GitHub Actions workflow for automated validation and linting of GitHub Actions workflow files using actionlint.

## 🚀 Usage

### Basic Usage

```yaml
name: Actionlint
on: [push, pull_request]

jobs:
  actionlint:
    uses: umatare5/common/.github/workflows/actionlint.yml@main
```

### Advanced Usage with Custom Configuration

```yaml
name: Actionlint
on: [push, pull_request]

jobs:
  actionlint:
    uses: umatare5/common/.github/workflows/actionlint.yml@main
    with:
      config_file: ".github/custom-actionlint.yml"
      workflow_pattern: ".github/workflows/*.yml"
```

## ⚙️ Input Parameters

| Parameter          | Type   | Description                                  | Default            |
| ------------------ | ------ | -------------------------------------------- | ------------------ |
| `checkout-ref`     | string | The branch, tag or SHA to checkout           | `""`               |
| `runs_on`          | string | Runner to use for the job                    | `"ubuntu-24.04"`   |
| `fetch_depth`      | number | Number of commits to fetch (0 = all history) | `1`                |
| `workflow_pattern` | string | Pattern for workflow files to check          | `""` (auto-detect) |
| `config_file`      | string | Path to actionlint config file               | `""` (auto-detect) |

## 📝 Prerequisites

- Repository with GitHub Actions workflow files in `.github/workflows/`
- Optional: Create `.github/actionlint.yml` for custom configuration (automatically detected)
- Optional: Specify custom workflow patterns for targeted validation

## 📖 Advanced Usage

### 1. Custom Configuration File

```yaml
jobs:
  actionlint:
    uses: umatare5/common/.github/workflows/actionlint.yml@main
    with:
      config_file: ".github/custom-actionlint.yml"
```

### 2. Specific Workflow Pattern

```yaml
jobs:
  actionlint:
    uses: umatare5/common/.github/workflows/actionlint.yml@main
    with:
      workflow_pattern: ".github/workflows/ci-*.yml"
```

### 3. Specific Branch/Tag Analysis

```yaml
jobs:
  actionlint:
    uses: umatare5/common/.github/workflows/actionlint.yml@main
    with:
      checkout-ref: "develop"
      fetch_depth: 0
```

### 4. Custom Runner

```yaml
jobs:
  actionlint:
    uses: umatare5/common/.github/workflows/actionlint.yml@main
    with:
      runs_on: "ubuntu-latest"
```

## 🔧 Configuration File

actionlint automatically detects `.github/actionlint.yml` in your repository. You can also specify a custom configuration file:

```yaml
# Configuration for actionlint
# See: https://github.com/rhysd/actionlint/blob/main/docs/config.md

# Disable specific rules
self-hosted-runner:
  # Disable checks for self-hosted runner labels
  - windows-2019
  - macos-10.15

# Configure external tools
shellcheck:
  # Disable shellcheck integration
  enable: false

pyflakes:
  # Disable pyflakes integration
  enable: false

# Ignore specific error patterns
ignore:
  # Ignore specific workflow files
  - ".github/workflows/experimental.yml"
  # Ignore specific error messages
  - "shellcheck reported issue in this script"
```

### Default Detection

actionlint automatically searches for `.github/actionlint.yml` in your repository root. No configuration is needed for the default behavior.

### Custom Configuration

```yaml
# Example: .github/custom-actionlint.yml
jobs:
  actionlint:
    uses: umatare5/common/.github/workflows/actionlint.yml@main
    with:
      config_file: ".github/custom-actionlint.yml"
```

## 🛠️ Execution Mode

actionlint runs in **warning mode** by default:

- Issues are reported but don't fail the job
- Suitable for gradual adoption and continuous feedback
- Provides actionable insights without blocking CI/CD pipelines
- Allows teams to incrementally improve workflow quality

## 🎯 Auto-Detection Features

### Workflow Files

- **Default**: Automatically scans `.github/workflows/` directory
- **Custom**: Specify patterns like `.github/workflows/ci-*.yml`

### Configuration Files

- **Default**: Automatically detects `.github/actionlint.yml`
- **Custom**: Specify alternative config file paths

## 📊 What actionlint Checks

actionlint performs comprehensive validation including:

### Syntax and Structure

- YAML syntax validation
- Workflow file structure validation
- Job and step configuration validation

### GitHub Actions Best Practices

- Action usage validation
- Runner label validation
- Expression syntax validation
- Context usage validation

### Security Checks

- Script injection vulnerabilities
- Untrusted input handling
- Permission requirements

### External Tool Integration

- **shellcheck**: Shell script validation in `run` steps
- **pyflakes**: Python script validation in `run` steps

## 🔍 Common Issues Detected

- Invalid action references
- Typos in runner labels
- Incorrect expression syntax
- Missing required permissions
- Security vulnerabilities in scripts
- Deprecated action versions
- Invalid workflow triggers

## 📈 Example Output

```text
✓ Using default config: .github/actionlint.yml
Running actionlint to check GitHub Actions workflow files...
.github/workflows/ci.yml:15:7: "ubuntu-20.04" is deprecated. use "ubuntu-latest" instead [runner-label]
.github/workflows/ci.yml:25:15: shellcheck reported issue in this script [shellcheck]
Issues found in workflow files - please review and fix manually
```

## Related Links

- [actionlint GitHub Repository](https://github.com/rhysd/actionlint)
- [actionlint Documentation](https://github.com/rhysd/actionlint/tree/main/docs)
- [actionlint Configuration Guide](https://github.com/rhysd/actionlint/blob/main/docs/config.md)
- [actionlint Checks Documentation](https://github.com/rhysd/actionlint/blob/main/docs/checks.md)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
