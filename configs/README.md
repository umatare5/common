# 🔧 Configuration Files

Common configuration files for maintaining consistent development standards across projects.

## Usage

Copy the relevant configuration files to your project root directory to ensure consistent code quality and build processes.

## Available Configurations

| File                                           | Tool          | Description                         |
| ---------------------------------------------- | ------------- | ----------------------------------- |
| [`.golangci.yml`](./.golangci.yml)             | golangci-lint | Go code linting and static analysis |
| [`.goreleaser-bin.yml`](./.goreleaser-bin.yml) | GoReleaser    | Binary release configuration        |
| [`.goreleaser-lib.yml`](./.goreleaser-lib.yml) | GoReleaser    | Library release configuration       |
| [`.markdownlint.json`](./.markdownlint.json)   | markdownlint  | Markdown linting rules              |
| [`.markdownlintignore`](./.markdownlintignore) | markdownlint  | Markdown linting ignore patterns    |
| [`Dockerfile`](./Dockerfile)                   | Docker        | Container build configuration       |
| [`taplo.toml`](./taplo.toml)                   | Taplo         | TOML file formatting configuration  |
