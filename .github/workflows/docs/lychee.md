# lychee Reusable Workflow

A reusable GitHub Actions workflow for checking links in Markdown and HTML documents with lychee.

## Usage

### Basic usage

```yaml
name: Link Check
on:
  push:
    paths:
      - "**/*.md"
      - "lychee.toml"
  pull_request:
    paths:
      - "**/*.md"
      - "lychee.toml"

permissions:
  contents: read

jobs:
  lychee:
    uses: umatare5/common/.github/workflows/lychee.yml@main
```

> [!NOTE]
>
> The defaults run `lychee .` in the calling repository. Passing the repository root rather than a glob is what keeps `.gitignore` and hidden directories excluded, so agent instruction files and vendored trees are left out without listing them.

## Input parameters

| Parameter         | Type   | Description                                  | Default        |
| :---------------- | :----- | :------------------------------------------- | :------------- |
| `lychee_version`  | string | lychee release to run                        | `v0.24.2`      |
| `paths`           | string | Inputs to check (newline-separated)          | `.`            |
| `config_file`     | string | lychee config file path (empty: discover)    | `""`           |
| `lychee_args`     | string | Additional arguments for lychee              | `""`           |
| `runs_on`         | string | Runner to use for the job                    | `ubuntu-24.04` |
| `fetch_depth`     | number | Number of commits to fetch (0 = all history) | `1`            |
| `timeout_minutes` | number | Job timeout in minutes                       | `10`           |

Pin `lychee_version` to the release you run locally, and raise it deliberately — a newer release can add a check that turns a green repository red without a local change.

## Prerequisites

A document in one of the extensions lychee reads by default: `md`, `mkd`, `mdx`, `mdown`, `mdwn`, `mkdn`, `mkdown`, `markdown`, `html`, `htm`, `css`, `txt` and `xml`. An extensionless file such as `NOTICE` or `LICENSE` is never read, so a link that lives only there goes unchecked.

The workflow leaves `--config` off unless `config_file` names a file, because lychee discovers `lychee.toml` on its own and rejects an explicit path it cannot read. A repository that keeps the file under any other name, `.lychee.toml` included, must name it — discovery covers `lychee.toml` alone.

`runs_on` must name a Linux runner: the install step fetches the `x86_64` or `aarch64` GNU archive and verifies it with `sha256sum` against the checksum published beside it.

The job passes its own `GITHUB_TOKEN` to lychee, which raises the github.com rate limit. An anonymous run reaches that limit as `429` on a repository that links to GitHub often, so the token is what keeps such a run from failing on its own links.

## Advanced usage

### 1. Naming a config file

Discovery covers `lychee.toml` only. A repository that prefers the dot-prefixed name has to say so, otherwise every setting in the file is silently ignored.

```yaml
jobs:
  lychee:
    uses: umatare5/common/.github/workflows/lychee.yml@main
    with:
      config_file: ".lychee.toml"
```

### 2. Narrowing the inputs

`paths` takes one input per line and accepts a file, a directory or a glob. A glob is matched by lychee itself and therefore bypasses the `.gitignore` and hidden-directory exclusions that a directory input honours.

```yaml
jobs:
  lychee:
    uses: umatare5/common/.github/workflows/lychee.yml@main
    with:
      paths: |
        README.md
        docs
```

### 3. Passing further flags

`lychee_args` is split on whitespace, so one string can carry several flags. Use it for a run-time concern such as caching or accepted status codes, and keep policy in the config file where every local run reads it too.

```yaml
jobs:
  lychee:
    uses: umatare5/common/.github/workflows/lychee.yml@main
    with:
      lychee_args: "--cache --max-cache-age 1d"
```

## Related links

- [lychee Documentation](https://lychee.cli.rs/)
- [lychee Commandline Parameters](https://github.com/lycheeverse/lychee#commandline-parameters)
- [lychee Configuration File](https://github.com/lycheeverse/lychee/blob/master/lychee.example.toml)
- [lychee Releases](https://github.com/lycheeverse/lychee/releases)
