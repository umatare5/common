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

| Parameter            | Type   | Description                                                | Default                                                                                                                  |
| -------------------- | ------ | ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `base_url`           | string | Base URL for downloading instructions files                | `https://raw.githubusercontent.com/github/awesome-copilot/main/instructions`                                             |
| `instructions_files` | string | List of instructions files to download (newline-separated) | `go.instructions.md` `markdown.instructions.md` `github-actions-ci-cd-best-practices.instructions.md`                    |
| `prompts_files`      | string | List of prompt files to download (newline-separated)       | `ai-prompt-engineering-safety-review.prompt.md`                                                                          |
| `runs_on`            | string | Runner to use for the job                                  | `ubuntu-24.04`                                                                                                           |
| `branch_name`        | string | Branch name for the pull request                           | `chore/copilot-instructions-sync`                                                                                        |
| `pr_title`           | string | Pull request title                                         | `chore: Sync public Copilot instructions`                                                                                |
| `pr_body`            | string | Pull request body                                          | `Automated sync of public Copilot instructions. This PR updates files under .github/instructions/ and .github/prompts/.` |

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
      base_url: "https://raw.githubusercontent.com/your-org/copilot-instructions/main"
      instructions_files: |
        go.instructions.md
        typescript.instructions.md
        python.instructions.md
      prompts_files: |
        code-review.prompt.md
        security-audit.prompt.md
```

### 2. Custom Branch and PR Settings

```yaml
jobs:
  sync:
    uses: umatare5/common/.github/workflows/gh-fetch-instructions.yml@main
    with:
      branch_name: "feature/update-copilot-instructions"
      pr_title: "feat: Update Copilot instructions and prompts"
      pr_body: |
        ## 🤖 Automated Copilot Instructions Update

        This PR updates the following files:
        - Instructions files under `.github/instructions/`
        - Prompt files under `.github/prompts/`

        Please review the changes before merging.
```

### 3. Minimal Configuration (TypeScript Only)

```yaml
jobs:
  sync:
    uses: umatare5/common/.github/workflows/gh-fetch-instructions.yml@main
    with:
      instructions_files: |
        typescript.instructions.md
      prompts_files: ""
```

### 4. Combined with Other Workflows

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
3. **PR Creation**: Creates a pull request only if there are changes
4. **No-op**: Skips PR creation if no changes are detected

## Related Links

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Awesome Copilot Instructions](https://github.com/github/awesome-copilot)
- [GitHub Actions Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
