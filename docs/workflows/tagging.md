# Tagging Reusable Workflow

A reusable GitHub Actions workflow for automated Git tag creation based on version files.

## 🚀 Usage

### Basic Usage

```yaml
name: Auto Tag

on:
  push:
    branches: [main]
    paths: [VERSION]

permissions:
  contents: write

jobs:
  tag:
    uses: umatare5/common/workflows/tagging.yml@main
    with:
      version_file: "VERSION"
      tag_prefix: "v"
```

## ⚙️ Input Parameters

| Parameter        | Description                | Default                                        |
| ---------------- | -------------------------- | ---------------------------------------------- |
| `version_file`   | Path to the version file   | `VERSION`                                      |
| `tag_prefix`     | Prefix for the git tag     | `v`                                            |
| `runs_on`        | Runner to use for the job  | `ubuntu-24.04`                                 |
| `git_user_name`  | Git user name for commits  | `github-actions[bot]`                          |
| `git_user_email` | Git user email for commits | `github-actions[bot]@users.noreply.github.com` |

## 📋 Prerequisites

Create a version file (default: `VERSION`) in your repository root with the version number:

```text
1.2.3
```

## 📖 Advanced Usage

### 1. Custom Version File

```yaml
jobs:
  tag:
    uses: umatare5/common/workflows/tagging.yml@main
    with:
      version_file: "package.json"
```

### 2. Custom Tag Prefix

```yaml
jobs:
  tag:
    uses: umatare5/common/workflows/tagging.yml@main
    with:
      tag_prefix: "release-"
```

### 3. No Prefix Tags

```yaml
jobs:
  tag:
    uses: umatare5/common/workflows/tagging.yml@main
    with:
      tag_prefix: ""
```

## Related Links

- [Git Tagging Documentation](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
- [Semantic Versioning](https://semver.org/)
- [GitHub Actions Workflows](https://docs.github.com/en/actions/using-workflows)
