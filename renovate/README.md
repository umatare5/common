# Renovate Configuration Files

Common Renovate configuration files for automated dependency management across projects.

## Usage

Extend a profile from your `renovate.json`. A profile already pulls in the components it needs, so a repository normally references one profile plus any add-on that applies to it.

```json
// Example: renovate.json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["github>umatare5/common//renovate/go.json"]
}
```

Keep a rule here once two or more repositories share it. A rule used by a single repository belongs in that repository's `renovate.json`.

## Available configurations

| File                                                 | Type      | Description                                    |
| :--------------------------------------------------- | :-------- | :--------------------------------------------- |
| [`go.json`](./go.json)                               | Profile   | Go repositories. Extends every component       |
| [`default.json`](./default.json)                     | Component | Schedule, automerge, cooldown and labels       |
| [`github-actions.json`](./github-actions.json)       | Component | Rules for GitHub Actions workflow updates      |
| [`workflow-versions.json`](./workflow-versions.json) | Component | Tool versions passed to the reusable workflows |
| [`wnc-library.json`](./wnc-library.json)             | Add-on    | Holds WNC SDK bumps for manual review          |

## Update policy

| Item                | Value                                         |
| :------------------ | :-------------------------------------------- |
| PR creation         | Monday, 12:00-21:00 JST                       |
| Automerge           | Thursday, 12:00-21:00 JST, minor and below    |
| Major updates       | Manual merge                                  |
| Cooldown            | 7 days after release                          |
| Batching            | One PR for all minor, one for all patch       |
| Security fixes      | Bypass both the schedule and the cooldown     |
| Indirect Go modules | Updated only when a vulnerability is reported |

## Validation

Pin the validator to the major version the Renovate app runs. The `npx` default resolves to a release that rejects `managerFilePatterns`.

```bash
npx --yes --package renovate@44 -- renovate-config-validator --strict renovate/*.json
```
