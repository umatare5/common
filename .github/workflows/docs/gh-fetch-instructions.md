# gh-fetch-instructions Reusable Workflow

A reusable GitHub Actions workflow for syncing GitHub Copilot instructions and prompt files from public repositories.

## 🚀 Usage

### Basic Usage

```yaml
name: Sync Copilot Instructions
on:
  workflow_dispatch:
  schedule:
    - cron: "0 13 * * 0" # Weekly on Sunday at 13:00 UTC

permissions:
  contents: write # For creating commits and branches
  pull-requests: write # For creating pull requests

jobs:
  sync:
    uses: umatare5/common/.github/workflows/gh-fetch-instructions.yml@main
    with:
      runs_on: "ubuntu-24.04"
```

## ⚙️ Input Parameters

| Parameter            | Type   | Description                                                               | Default                                                                                                                  |
| -------------------- | ------ | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `source_repo`        | string | Source repository for downloading instructions files (format: owner/repo) | `github/awesome-copilot`                                                                                                 |
| `source_branch_name` | string | Source branch name for downloading instructions files                     | `main`                                                                                                                   |
| `instructions_files` | string | List of instructions files to download (newline-separated)                | `go.instructions.md` `markdown.instructions.md` `github-actions-ci-cd-best-practices.instructions.md`                    |
| `prompts_files`      | string | List of prompt files to download (newline-separated)                      | `ai-prompt-engineering-safety-review.prompt.md`                                                                          |
| `runs_on`            | string | Runner to use for the job                                                 | `ubuntu-24.04`                                                                                                           |
| `pr_branch_name`     | string | Branch name for the pull request                                          | `chore/copilot-instructions-sync`                                                                                        |
| `pr_title`           | string | Pull request title                                                        | `[Auto-generated] Sync public Copilot instructions`                                                                      |

## 📝 Prerequisites

### Repository Settings

**⚠️ Important**: This workflow requires write permissions to create branches and pull requests. You need to configure the following repository setting:

1. Navigate to **Settings** > **Actions** > **General** in your repository
2. Under **Workflow permissions**, select **"Read and write permissions"**
3. Ensure **"Allow GitHub Actions to create and approve pull requests"** is checked

Without these permissions, the workflow will fail when attempting to create branches or pull requests.

### Files and Directories

No additional configuration files are required. The workflow will automatically create `.github/instructions/` and `.github/prompts/` directories as needed.

## 📖 Advanced Usage

### 1. Custom Instructions Source

```yaml
jobs:
  sync:
    uses: umatare5/common/.github/workflows/gh-fetch-instructions.yml@main
    with:
      source_repo: "your-org/copilot-instructions"
      source_branch_name: "develop"
      instructions_files: |
        go.instructions.md
        typescript.instructions.md
        python.instructions.md
      prompts_files: |
        code-review.prompt.md
        security-audit.prompt.md
```

### 2. Different Branch from Default Repository

```yaml
jobs:
  sync:
    uses: umatare5/common/.github/workflows/gh-fetch-instructions.yml@main
    with:
      source_repo: "github/awesome-copilot"
      source_branch_name: "beta"
      instructions_files: |
        go.instructions.md
        typescript.instructions.md
```

### 3. Custom Branch and PR Settings

```yaml
jobs:
  sync:
    uses: umatare5/common/.github/workflows/gh-fetch-instructions.yml@main
    with:
      source_repo: "your-org/custom-instructions"
      source_branch_name: "main"
      pr_branch_name: "feature/update-copilot-instructions"
      pr_title: "feat: Update Copilot instructions and prompts"
      pr_body: |
        ## 🤖 Automated Copilot Instructions Update

        This PR updates the following files:
        - Instructions files under `.github/instructions/`
        - Prompt files under `.github/prompts/`

        Please review the changes before merging.
```

### 4. Minimal Configuration (TypeScript Only)

```yaml
jobs:
  sync:
    uses: umatare5/common/.github/workflows/gh-fetch-instructions.yml@main
    with:
      instructions_files: |
        typescript.instructions.md
      prompts_files: ""
```

### 5. Combined with Other Workflows

```yaml
jobs:
  sync-instructions:
    uses: umatare5/common/.github/workflows/gh-fetch-instructions.yml@main

  test:
    needs: sync-instructions
    uses: umatare5/common/.github/workflows/go-test-build.yml@main

  lint:
    needs: sync-instructions
    uses: umatare5/common/.github/workflows/go-test-fmt.yml@main
```

## 📁 Output Structure

The workflow will create/update the following directory structure:

```text
.github/
├── instructions/
│   ├── go.instructions.md
│   ├── markdown.instructions.md
│   └── github-actions-ci-cd-best-practices.instructions.md
└── prompts/
    └── ai-prompt-engineering-safety-review.prompt.md
```

## 🔄 Workflow Behavior

1. **Download**: Fetches specified instruction and prompt files from the configured source
2. **Detection**: Checks for changes compared to existing files
3. **Branch Creation**: Creates a branch with the format `{pr_branch_name}-YYYY-MM-DD` (e.g., `chore/copilot-instructions-sync-2025-08-10`)
4. **PR Body Generation**: Dynamically generates PR body with source repository link and file lists
5. **PR Creation**: Creates a pull request only if there are changes
6. **No-op**: Skips PR creation if no changes are detected

## 📋 Generated PR Content

The workflow automatically generates a pull request body with the following format:

```markdown
This PR sync of public Copilot instructions.

### Source

https://github.com/github/awesome-copilot

### New Instructions

- go.instructions.md
- markdown.instructions.md
- github-actions-ci-cd-best-practices.instructions.md

### New Prompts

- ai-prompt-engineering-safety-review.prompt.md
```

## Related Links

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Awesome Copilot Instructions](https://github.com/github/awesome-copilot)
- [GitHub Actions Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
