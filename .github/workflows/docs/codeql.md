# codeql Reusable Workflow

A reusable GitHub Actions workflow for automated CodeQL security analysis and vulnerability detection.

## 🚀 Usage

### Basic Usage

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
      languages: "actions,go"
      runs_on: "ubuntu-latest"
```

## ⚙️ Input Parameters

| Parameter        | Type   | Description                                                                   | Default         |
| ---------------- | ------ | ----------------------------------------------------------------------------- | --------------- |
| `languages`      | string | Languages to analyze (comma-separated: actions,go,javascript-typescript,etc.) | `actions,go`    |
| `runs_on`        | string | Runner to use for the job                                                     | `ubuntu-latest` |
| `fetch_depth`    | number | Number of commits to fetch (0 = all history)                                  | `1`             |
| `codeql_queries` | string | Custom CodeQL queries (e.g., security-extended,security-and-quality)          | `""`            |
| `build_commands` | string | Custom build commands for manual build mode (multiline string)                | `""`            |

## 🔍 Supported Languages

CodeQL supports the following languages with their respective build modes:

| Language                | Build Mode  | Description                         |
| ----------------------- | ----------- | ----------------------------------- |
| `actions`               | `none`      | GitHub Actions workflows            |
| `javascript-typescript` | `none`      | JavaScript and TypeScript           |
| `python`                | `none`      | Python                              |
| `ruby`                  | `none`      | Ruby                                |
| `go`                    | `autobuild` | Go (automatically built)            |
| `java-kotlin`           | `autobuild` | Java and Kotlin                     |
| `csharp`                | `autobuild` | C#                                  |
| `rust`                  | `autobuild` | Rust                                |
| `c-cpp`                 | `manual`    | C and C++ (requires build commands) |
| `swift`                 | `manual`    | Swift (runs on macOS)               |

## 📝 Prerequisites

- Repository with source code in supported languages
- For manual build languages (C/C++, Swift), provide custom build commands
- Appropriate permissions configured for security events

## 📖 Advanced Usage

### 1. Multiple Languages Analysis

```yaml
jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: "actions,go,javascript-typescript,python"
      codeql_queries: "security-extended,security-and-quality"
```

### 2. Custom Build Commands for Manual Build

```yaml
jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: "c-cpp"
      build_commands: |
        make clean
        make bootstrap
        make release
```

### 3. Extended Security Analysis

```yaml
jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: "go,javascript-typescript"
      codeql_queries: "security-extended,security-and-quality"
      fetch_depth: 0 # Full history for better analysis
```

### 4. Performance Optimization

```yaml
jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: "go"
      runs_on: "ubuntu-latest-4-cores" # Use larger runner for faster analysis
```

### 5. Scheduled Security Scans

```yaml
name: Weekly Security Scan
on:
  schedule:
    - cron: "0 2 * * 1" # Every Monday at 2 AM

jobs:
  codeql:
    uses: umatare5/common/.github/workflows/codeql.yml@main
    with:
      languages: "actions,go"
      codeql_queries: "security-extended,security-and-quality"
```

## 🔧 Query Packs

Available CodeQL query packs for enhanced security analysis:

- `security-extended`: Extended security queries beyond the default set
- `security-and-quality`: Comprehensive security and code quality queries
- Custom query packs: Specify your own query pack URLs

## 🛡️ Required Permissions

The calling workflow must include these permissions:

```yaml
permissions:
  security-events: write # Required for all workflows
  packages: read # Required to fetch internal or private CodeQL packs
  actions: read # Only required for workflows in private repositories
  contents: read # Only required for workflows in private repositories
```

## 📊 Analysis Results

- Results are automatically uploaded to GitHub Security tab
- Alerts are created for discovered vulnerabilities
- SARIF files are generated for detailed analysis
- Integration with GitHub Advanced Security features

## Related Links

- [CodeQL Documentation](https://codeql.github.com/docs/)
- [GitHub Code Scanning](https://docs.github.com/en/code-security/code-scanning)
- [CodeQL Query Packs](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-code-scanning#using-queries-in-ql-packs)
- [Supported Languages and Frameworks](https://codeql.github.com/docs/codeql-overview/supported-languages-and-frameworks/)
