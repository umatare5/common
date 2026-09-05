# codeql Reusable Workflow

A reusable GitHub Actions workflow for automated CodeQL security analysis and vulnerability detection.

## Usage

### Basic usage

```yaml
name: CodeQL Analysis
on: [push, pull_request]

permissions:
  security-events: write
  packages: read
  actions: read
  contents: read

jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: '["javascript", "python"]'
      runs_on: "ubuntu-latest"
```

## Input parameters

| Parameter       | Type   | Description                                  | Default            |
| :-------------- | :----- | :------------------------------------------- | :----------------- |
| `languages`     | string | Languages to analyze as JSON array           | `'["go"]'`         |
| `runs_on`       | string | Runner to use for the job                    | `ubuntu-latest`    |
| `fetch_depth`   | number | Number of commits to fetch (0 = all history) | `1`                |
| `codeql_config` | string | Path to CodeQL configuration file            | `""` (auto-detect) |

## Supported languages

CodeQL supports analysis for the following languages:

| Language      | Description     |
| :------------ | :-------------- |
| `javascript`  | JavaScript      |
| `python`      | Python          |
| `cpp`         | C and C++       |
| `java-kotlin` | Java and Kotlin |
| `csharp`      | C#              |
| `go`          | Go              |
| `ruby`        | Ruby            |
| `rust`        | Rust            |
| `swift`       | Swift           |

**Note:** Languages are specified as a JSON array in the `languages` parameter.

## Prerequisites

- Repository with source code in supported languages
- Appropriate permissions configured for security events
- Optional: Create `.github/codeql-config.yml` for advanced configuration (automatically detected)

## Advanced usage

### 1. Multiple languages analysis

```yaml
jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: '["javascript", "python", "go"]'
```

### 2. Custom configuration file

```yaml
jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: '["go"]'
      codeql_config: ".github/custom-codeql-config.yml"
```

### 3. Full history analysis

```yaml
jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: '["go"]'
      fetch_depth: 0 # Full history for better analysis
```

### 4. Performance optimization

```yaml
jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: '["go"]'
      runs_on: "ubuntu-latest-4-cores" # Use larger runner for faster analysis
```

### 5. Scheduled security scans

```yaml
name: Weekly Security Scan
on:
  schedule:
    - cron: "0 2 * * 1" # Every Monday at 2 AM

jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: '["go"]'
```

## Auto-Detection features

### Configuration files

- **Default**: CodeQL uses built-in configuration for standard analysis
- **Auto-detect**: Automatically detects `.github/codeql-config.yml` if present
- **Custom**: Specify alternative config file paths when needed

## Configuration file

You can create a `.github/codeql-config.yml` file to customize CodeQL analysis:

```yaml
name: "Custom CodeQL Config"

disable-default-rules: false

queries:
  - uses: security-extended
  - uses: security-and-quality

paths-ignore:
  - node_modules
  - vendor
  - "**/*.test.js"

paths:
  - src
  - lib
```

## Required permissions

The calling workflow must include these permissions:

```yaml
permissions:
  security-events: write # Required for all workflows
  packages: read # Required to fetch internal or private CodeQL packs
  actions: read # Only required for workflows in private repositories
  contents: read # Only required for workflows in private repositories
```

## Analysis results

- Results are automatically uploaded to GitHub Security tab
- Alerts are created for discovered vulnerabilities
- SARIF files are generated for detailed analysis
- Integration with GitHub Advanced Security features

## Related links

- [CodeQL Documentation](https://codeql.github.com/docs/)
- [GitHub Code Scanning](https://docs.github.com/en/code-security/code-scanning)
- [CodeQL Configuration](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-code-scanning)
- [Supported Languages and Frameworks](https://codeql.github.com/docs/codeql-overview/supported-languages-and-frameworks/)
