# 📋 Development Instructions

GitHub Copilot Agent Mode instructions for maintaining coding standards and best practices across projects.

## Usage

Put these instruction files in the `.github/instructions/` directory of your repository. They will be automatically applied by GitHub Copilot Agent Mode based on file patterns and project structure. No manual setup required.

## Available Instructions

| File                                                             | Scope     | Description                       |
| ---------------------------------------------------------------- | --------- | --------------------------------- |
| [`general.instructions.md`](./general.instructions.md)           | `**`      | General development guidelines    |
| [`go-cli-large.instructions.md`](./go-cli-large.instructions.md) | `**/*.go` | Large CLI application development |
| [`go-lib.instrcutions.md`](./go-lib.instrcutions.md)             | `**/*.go` | Go library/SDK development        |
| [`markdown.instructions.md`](./markdown.instructions.md)         | `**/*.md` | Markdown documentation standards  |
| [`scripts.instructions.md`](./scripts.instructions.md)           | `**/*.sh` | Bash shell scripting guidelines   |
