# Repository Instructions

> [!IMPORTANT]
> Read [`README.md`](README.md) for what each directory publishes and how a consuming repository references it.

## Tech Stack

- GitHub Actions reusable workflows — the product of this repository
- [`actionlint`](https://github.com/rhysd/actionlint) with `shellcheck` — workflow and embedded-shell checks
- [`Renovate`](https://docs.renovatebot.com/) — shared presets under `renovate/`
- [`GoReleaser`](https://goreleaser.com/) v2 — invoked by the release workflows, configured per consumer

## Repository Structure

- `.github/workflows/` — Reusable workflows. `internal-*.yml` run against this repository and are not published
- `.github/workflows/docs/` — One guide per reusable workflow, listed in `.github/workflows/README.md`
- `configs/` — Tool configuration copied into consuming repositories
- `renovate/` — Renovate presets. `go.json` is the profile; the rest are components
- `examples/` — Minimal projects the workflows are exercised against
- `VERSION` — The tag a consumer pins. Changing it releases

## Setup and Commands

- `actionlint -shellcheck=shellcheck .github/workflows/*.yml` — Lint every workflow
- `pinact run --check` — Verify `uses:` pins and their version comments
- `markdownlint-cli2 --config configs/.markdownlint-cli2.jsonc` — Lint Markdown
- `npx --yes --package renovate@44 -- renovate-config-validator --strict renovate/*.json` — Validate the presets

## Code Style

- Follow the `my-workflow-writer` skill for anything under `.github/`, and `my-github-writer` for Markdown
- Pass an input through `env:` and read it back as `"$VAR"`; never interpolate `${{ }}` into a `run:` body
- Declare `permissions` on every workflow, starting from the narrowest set the jobs use
- Pin every `uses:` to a full-length SHA with the version in a trailing comment
- Name every step for what it does to the repository rather than for the tool it runs

## Testing Instructions

- A reusable workflow is verified by an `internal-*.yml` caller in this repository, not by a unit test
- `examples/go-server` is the fixture the Go workflows build and test against
- A change to a published workflow is exercised by pushing the branch and watching the internal caller

## Commits and PRs

- Bump `VERSION` in the same pull request that changes a published workflow; merging it creates the tag
- Consumers pin `umatare5/common/.github/workflows/x.yml@<sha> # vX.Y.Z`, so an unreleased change reaches nobody
- Follow Conventional Commits, and keep one behavioural change per commit

## Domain Knowledge

- A job calling a reusable workflow accepts nine keywords and none of them is `steps`, `runs-on` or `timeout-minutes`, so `runs_on` and `timeout_minutes` are inputs on every workflow here
- `GITHUB_TOKEN` permissions pass down and can only be reduced, so a scope the caller withheld cannot be recovered
- `actions/checkout` in a called workflow checks out the calling repository rather than this one
- Scheduled workflows in a public repository stop after sixty days without activity
