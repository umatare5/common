# GitHub Copilot Agent Mode – Repo Instructions (for `umatare5/common`)

### Scope & Metadata

- **Last Updated**: 2025-08-10
- **Precedence**: Highest in this repository (see §2)
- **Goals**:

  - **Primary Goal**: Maintain and evolve **reusable GitHub Actions workflows**, **instructions**, and **shared configs** under this repository so downstream repos can consume them reliably.
  - Keep interfaces (**workflow inputs/outputs**, **secrets**, **permissions**, and **contracts**) **clear, small, and stable**; maximize **readability/maintainability**.
  - Prefer **minimal diffs** (avoid unnecessary churn). Favor incremental, well-scoped changes.
  - Defaults are secure (no secret logging; least‑privilege `permissions`; pinned actions policy; safe TLS and script practices by default).

- **Non‑Goals**:

  - Creating product‑specific workflows that don’t generalize across repositories unless explicitly requested.
  - Adding ad‑hoc, editor‑external lint rules or formatting styles not configured in this repo.
  - Emitting, persisting, or printing secrets/test credentials.

---

## 0. Normative Keywords

- NK-001 (**MUST**) Interpret **MUST / MUST NOT / SHOULD / SHOULD NOT / MAY** per RFC 2119 / RFC 8174.

## 1. Repository Purpose & Scope

- GP-001 (**MUST**) Treat this repository as a **central hub** for:

  - **Reusable GitHub Actions workflows** under `.github/workflows/` (consumed by other repos via `workflow_call`).
  - **Copilot Agent Mode instructions** under `.github/instructions/`.
  - **Scaffolding/config files** under `configs/` used across repos.
  - **Renovate configuration** under `renovate/`.

- GP-002 (**MUST**) Optimize for **cross‑repository reuse** and **backward compatibility**. Breaking changes to workflow **inputs/outputs**, **required secrets**, or **permissions** **MUST** follow the versioning policy in §11 and §13.

## 2. Precedence & Applicability

- GA-001 (**MUST**) When editing or generating content in this repository, Copilot **must follow** this document.
- GA-002 (**MUST**) **This file has the highest precedence** over any other instruction set in this repo. On conflict, **prioritize this file**.
- GA-003 (**MUST**) Lint/format rules follow repository settings only (see §5). Do **not** introduce inline overrides that bypass configured rules.
- GA-004 (**MUST**) This file governs both **edit** and **review** behavior.

## 3. Expert Personas (for AI edits/reviews)

- EP-001 (**MUST**) Act as a **GitHub Actions expert** (reusable workflows, composite actions, permissions, caching, matrices, expressions).
- EP-002 (**MUST**) Act as a **YAML & Bash reviewer** (shell safety, quoting, `set -Eeuo pipefail`, trap on ERR where needed).
- EP-003 (**SHOULD**) Be familiar with **Renovate** configuration and schema validation.
- EP-004 (**SHOULD**) Be comfortable with **Markdown documentation** standards and linting.

## 4. Security & Privacy

- SP-001 (**MUST NOT**) Log tokens or credentials. Redact secrets in any output (`***`). Avoid `set -x` when secrets might echo.
- SP-002 (**MUST**) Default workflows to **least‑privilege `permissions`** at the top level (e.g., `contents: read`) and **escalate per‑job** only when required.
- SP-003 (**MUST**) **Pin actions**. Prefer official actions pinned by **major tag** (e.g., `actions/checkout@v4`) and **third‑party actions pinned to a full commit SHA**. Document the policy in the workflow header.
- SP-004 (**MUST**) Prefer **OIDC** over long‑lived cloud keys when authorizing deployments or CI access.
- SP-005 (**MUST**) Validate untrusted inputs before use (`matrix` values, user input, or `env`). Disallow command injection (quote variables; avoid word splitting; prefer arrays).

## 5. Editor‑Driven Tooling (single source of truth)

- ED-001 (**MUST**) Follow repository configs (e.g., `actionlint`, `markdownlint`, `shellcheck`, `yamllint`, `.editorconfig`).
- ED-002 (**MUST NOT**) Add flags/rules or inline disables that are not configured. If a rule is too strict or missing, propose a **minimal config PR** rather than local workarounds.
- ED-003 (**SHOULD**) Keep formatting/lint passes **idempotent**. Do not shuffle keys or rewrap YAML unless the repo’s formatter does so.

## 6. Coding Principles (Basics)

- GC-001 (**MUST**) Apply **KISS/DRY**. Prefer clarity over cleverness in YAML and shell.
- GC-002 (**MUST**) Avoid magic values. Use **inputs with sane defaults**, named environment variables, or reusable snippets.
- GC-003 (**MUST**) Prefer **composable jobs** and **reusable workflows** over copy‑paste.
- GC-004 (**SHOULD**) Favor **matrix strategies** for multi‑env testing instead of manual duplication.

## 7. Coding Principles (Conditionals)

- CF-001 (**MUST**) Keep conditions explicit using `if:` at the **job/step** level; avoid embedding complex branching inside `run:` when a native conditional would be clearer.
- CF-002 (**MUST**) Prefer **early exit** patterns (guard conditions) to reduce nested logic in shell.

## 8. Coding Principles (Loops)

- LP-001 (**MUST**) For shell loops, enable `set -Eeuo pipefail` and handle errors explicitly. Use `continue`/`break` for clarity; avoid deeply nested loops.

## 9. Working Directory / Temp Files

- WD-001 (**MUST**) Place all temporary artifacts (local validation outputs, coverage/temp files, caches for trial runs) **under `./tmp`**.
- WD-002 (**MUST**) Before completion, delete **zero‑byte files** (exception: keep `.keep`).

## 10. Model‑Aware Execution Workflow (when shell execution is available)

- WF-001 (**MUST**) Use `bash` exclusively (no auto shell detection). Begin scripts with `#!/usr/bin/env bash` and `set -Eeuo pipefail`.
- WF-002 (**MUST**) After editing workflows/actions, run **`actionlint`** and fix all findings.
- WF-003 (**SHOULD**) Run **`yamllint`** if configured.
- WF-004 (**MUST**) After editing shell scripts under `./scripts/` or embedded `run:` blocks, run **`shellcheck`** and fix issues (or justify minimal, documented ignores).
- WF-005 (**SHOULD**) After documentation changes, run **`markdownlint`**.
- WF-006 (**SHOULD**) For Renovate changes, validate via **Renovate config validator**.
- WF-007 (**MUST**) On completion, summarize actions/results into `./.copilot_reports/<prompt_title>_<YYYY-MM-DD_HH-mm-ss>.md`.

## 11. Tests / Quality Gate (for AI reviewers)

- QG-001 (**MUST**) **No lint errors** (actionlint, shellcheck, markdownlint, yamllint as applicable). Keep CI green.
- QG-002 (**MUST**) Ensure **reusable workflow contracts** remain **backward compatible** unless performing a **versioned breaking change** (see §13). Contracts include:

  - `on.workflow_call.inputs` (name, type, required/default)
  - `on.workflow_call.secrets` (name, required)
  - top‑level and job‑level `permissions`
  - outputs and their names/types

- QG-003 (**SHOULD**) Provide/update **usage examples** for each reusable workflow and composite action.

## 12. Change Scope & Tone (for AI reviewers)

- CS-001 (**MUST**) Focus on the **diff**. Propose repo‑wide refactors only with an explicit label (e.g., `allow-wide`).
- CS-002 (**SHOULD**) Tag comments with **\[BLOCKER] / \[MAJOR] / \[MINOR (Nit)] / \[QUESTION] / \[PRAISE]**.
- CS-003 (**SHOULD**) Use: **TL;DR → Evidence (rule/proof) → Minimal‑diff proposal**. Cite the rule from this file or tool output.

## 13. Versioning, Releases & Compatibility

- VR-001 (**MUST**) Version **reusable workflows** so callers can pin stable references. Use annotated tags (e.g., `v1`, `v1.2.0`). Update release notes describing inputs/outputs/permissions.
- VR-002 (**MUST**) Any **breaking change** to inputs/outputs/secrets/permissions requires a **new major version** and **migration notes**. Do **not** silently break callers.
- VR-003 (**SHOULD**) For third‑party actions, prefer pinning by commit SHA; for official `actions/*`, major tags are acceptable.
- VR-004 (**SHOULD**) Document **minimum runner** images and required tools per workflow (e.g., `ubuntu-24.04`).

## 14. Workflow Style & Conventions

- WS-001 (**MUST**) Put reusable workflows under `.github/workflows/` and ensure `on: workflow_call:` is present.
- WS-002 (**MUST**) Include a header comment block with: **name**, **purpose**, **inputs** (name/type/default/required), **secrets**, **permissions**, **outputs**, **examples**.
- WS-003 (**MUST**) Default `permissions:` to least privilege. Grant only what is required at **job** scope when possible.
- WS-004 (**MUST**) Use `shell: bash` explicitly for `run:` steps. Quote variable expansions; prefer arrays to avoid word splitting.
- WS-005 (**SHOULD**) Prefer `checkout` early; pin action versions; avoid unnecessary network calls; cache effectively with distinct keys and restore‑keys.
- WS-006 (**SHOULD**) Prefer `fail-fast: false` in large matrices to see all failures in a single run when appropriate.
- WS-007 (**SHOULD**) Keep environment and path mutations local to jobs/steps; avoid global side effects.

## 15. Documentation & Examples

- DX-001 (**MUST**) Keep **directory READMEs** up to date:

  - `.github/workflows/README.md` — lists available reusable workflows, inputs, and usage examples.
  - `.github/instructions/README.md` — outlines available instruction files and precedence.
  - `configs/README.md` — describes available config files and intended usage.
  - `renovate/README.md` — explains the shared Renovate presets and how to extend them.

- DX-002 (**SHOULD**) Provide **copy‑paste examples** showing `uses: <owner>/<repo>/.github/workflows/<file>@<version>` with representative inputs.

## 16. Operational Policies

- OP-001 (**MUST**) Keep **secrets surface area minimal**. Prefer `secrets: inherit` only when safe and documented; otherwise define explicit secrets in `workflow_call`.
- OP-002 (**MUST**) Document and audit **`permissions`** for each workflow. Avoid `write-all`.
- OP-003 (**SHOULD**) Add `concurrency` and sensible `cancel-in-progress` where idempotency allows.
- OP-004 (**SHOULD**) Use `timeout-minutes` on long‑running jobs. Avoid unbounded steps.
- OP-005 (**SHOULD**) Prefer **SARIF** outputs for security tools where applicable and document the path.

## 17. Quick Checklist (before completion)

- QC-001 (**MUST**) Contracts are stable: inputs/outputs/secrets/permissions unchanged unless bumping **major**.
- QC-002 (**MUST**) Directory READMEs updated (see §15) when workflows/configs change.
- QC-003 (**MUST**) All configured linters are clean (actionlint/shellcheck/markdownlint/yamllint).
- QC-004 (**MUST**) Actions pinned per policy (official: major tag; third‑party: full SHA).
- QC-005 (**MUST**) Temp artifacts under `./tmp`, zero‑byte files removed, and a **report** written to `./.copilot_reports/`.
- QC-006 (**SHOULD**) Example usage blocks verified and included in docs.
- QC-007 (**SHOULD**) Release notes updated when tags change; note any migration guidance for consumers.
