# Tagging Reusable Workflow

A reusable GitHub Actions workflow for automated Git tag creation based on version files.

## Features

- Automated tag creation from version files
- Configurable version file paths
- Customizable tag prefixes
- Duplicate tag detection and handling
- Flexible Git configuration options
- Error handling and validation

## Prerequisites

### Version File

Your repository must contain a version file (default: `VERSION`) with the version number:

```text
1.2.3
```

### Repository Permissions

The workflow requires write access to the repository to create and push tags. This is automatically provided when using `GITHUB_TOKEN`.

## Usage

### Basic Usage

Create a workflow that triggers on changes to your version file:

```yaml
name: Auto Tag

on:
  push:
    branches:
      - main
    paths:
      - VERSION

jobs:
  tag:
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
```

### Advanced Usage

```yaml
name: Auto Tag

on:
  push:
    branches:
      - main
    paths:
      - package.json

jobs:
  tag:
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
    with:
      version_file: "package.json"
      tag_prefix: "release-"
      runs_on: "ubuntu-latest"
      git_user_name: "release-bot"
      git_user_email: "release-bot@example.com"
```

## Input Parameters

| Parameter        | Description                                   | Default                                        |
| ---------------- | --------------------------------------------- | ---------------------------------------------- |
| `version_file`   | Path to the version file                      | `VERSION`                                      |
| `tag_prefix`     | Prefix for the git tag (e.g., 'v' for v1.0.0) | `v`                                            |
| `runs_on`        | Runner to use for the job                     | `ubuntu-24.04`                                 |
| `git_user_name`  | Git user name for commits                     | `github-actions[bot]`                          |
| `git_user_email` | Git user email for commits                    | `github-actions[bot]@users.noreply.github.com` |

## Use Cases

### 1. Semantic Versioning with VERSION File

```yaml
# VERSION file contains: 1.2.3
# Creates tag: v1.2.3

jobs:
  tag:
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
```

### 2. Custom Version File

```yaml
# For Node.js projects using package.json
jobs:
  tag:
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
    with:
      version_file: "package.json"
```

### 3. Custom Tag Prefix

```yaml
# Creates tags like: release-1.2.3
jobs:
  tag:
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
    with:
      tag_prefix: "release-"
```

### 4. No Prefix Tags

```yaml
# Creates tags like: 1.2.3 (no prefix)
jobs:
  tag:
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
    with:
      tag_prefix: ""
```

### 5. Custom Git User

```yaml
jobs:
  tag:
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
    with:
      git_user_name: "Release Manager"
      git_user_email: "release@company.com"
```

## Version File Formats

### Simple VERSION File

```text
1.2.3
```

### Package.json (for Node.js)

Note: For JSON files, you might need additional processing to extract the version:

```json
{
  "version": "1.2.3"
}
```

### Custom Processing

For complex version files, you might need to preprocess them or create a custom version of this workflow.

## Workflow Behavior

### What Happens

1. **Checkout**: Retrieves the repository code
2. **Read Version**: Reads the version from the specified file
3. **Validate**: Checks if the version file exists
4. **Check Duplicates**: Verifies the tag doesn't already exist
5. **Create Tag**: Creates an annotated Git tag
6. **Push Tag**: Pushes the tag to the remote repository

### Tag Format

- **With prefix**: `v1.2.3` (default)
- **Custom prefix**: `release-1.2.3`
- **No prefix**: `1.2.3`

### Tag Message

The workflow creates annotated tags with the message: `Release version X.Y.Z`

## Error Handling

The workflow handles several error conditions:

### Version File Not Found

```text
Error: Version file 'VERSION' not found
```

The workflow will exit with an error if the specified version file doesn't exist.

### Duplicate Tags

```text
Warning: Tag v1.2.3 already exists, skipping
```

If a tag already exists, the workflow will log a warning and exit successfully (no error).

### Git Configuration Issues

The workflow automatically configures Git with the provided user name and email.

## Integration Examples

### Complete Release Pipeline

```yaml
name: Release Pipeline

on:
  push:
    branches:
      - main
    paths:
      - VERSION

jobs:
  tag:
    uses: umatare5/common/.github/workflows/tagging-action.yml@main

  release:
    needs: tag
    uses: umatare5/common/.github/workflows/goreleaser.yml@main
    permissions:
      contents: write
      packages: write
      id-token: write
```

### Multi-Environment Tagging

```yaml
jobs:
  dev-tag:
    if: github.ref == 'refs/heads/develop'
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
    with:
      tag_prefix: "dev-"

  prod-tag:
    if: github.ref == 'refs/heads/main'
    uses: umatare5/common/.github/workflows/tagging-action.yml@main
    with:
      tag_prefix: "v"
```

## Best Practices

### 1. Version File Management

- Keep version files simple and contain only the version number
- Use semantic versioning (X.Y.Z format)
- Update version files through pull requests for review

### 2. Branch Protection

- Consider protecting your main branch to require PR reviews for version changes
- Use branch protection rules to ensure quality control

### 3. Automation Integration

- Combine with release workflows for complete automation
- Use conditional logic to handle different branches differently

## Troubleshooting

### Common Issues

1. **Permission Denied**

   ```text
   Error: Permission denied (publickey)
   ```

   → Ensure the workflow has proper repository permissions

2. **Invalid Version Format**

   ```text
   Warning: Version contains invalid characters
   ```

   → Check your version file format and content

3. **Git Configuration Issues**

   ```text
   Error: Please tell me who you are
   ```

   → The workflow automatically configures Git, but ensure parameters are correct

## Related Links

- [Git Tagging Documentation](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
- [Semantic Versioning](https://semver.org/)
- [GitHub Actions Workflows](https://docs.github.com/en/actions/using-workflows)
