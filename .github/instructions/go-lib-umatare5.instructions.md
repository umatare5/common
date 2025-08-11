---
description: "Go Library Development Instructions"
applyTo: "**/*.go,**/go.mod,**/go.sum"
---

# Go **Library** Development Instructions

## Scope & Metadata

- **Last Updated**: 2025-08-12
- **Precedence**: 1. `copilot-instructions.md` (Global) → 2. `go.instructions.md` (Community) → 3. `go-lib-umatare5.instructions.md` (This)
- **Compatibility**: Go toolchain (cross-platform)
- **Style Base**: [Effective Go](https://go.dev/doc/effective_go) / [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments)
- **Goal**: Stable, minimal public API; Functional Options; context-aware operations; idiomatic Go; actionable error wrapping.

## 1. Architecture

- PK-001 (**MUST**) Expose **feature-scoped service accessors** from a **single root client** (e.g., `Client.ServiceA()`, `Client.ServiceB()`), and keep related operations within each service.
- PK-002 (**MUST**) Use **Functional Options** in primary constructors, e.g. `NewClient(base string, opts ...Option)`.
- PK-003 (**MUST**) Organize by **feature/cohesion** (e.g., `featurea/`, `featureb/`); place shared wire/data types at the root when broadly used; put private helpers in `internal/`.
- PK-004 (**SHOULD**) Keep **thin service structs** with small methods (e.g., `Get(ctx, ...)`, `List(ctx, ...)`) that delegate to shared helpers.
- PK-005 (**MUST NOT**) Do not embed cross-service business logic inside a single service. Share only via `internal` utilities.

## 2. Coding Style

- STY-001 (**MUST**) Prioritize **human maintainability**, especially readability.
- STY-002 (**SHOULD**) Functions are roughly **20–40 lines**; refactor those exceeding **50 lines** unless well-justified.
- STY-003 (**SHOULD**) Prefer splitting for readability over deep nesting.

## 3. Dependencies & Injection

- DI-001 (**MUST**) Inject externals via **Options** (e.g., `WithHTTPClient(*http.Client)`, `WithLogger(*slog.Logger)`, `WithTimeout(...)`, `WithTransport(...)`).
- DI-002 (**MUST NOT**) Avoid singletons/mutable globals. Hold state in the root client or receivers.
- DI-003 (**SHOULD**) Define **small interfaces** (e.g., `Clock`, `RetryPolicy`) accepted via Options to ease testing.
- DI-004 (**MUST**) Prefer the **standard library** first; justify any new dependency per global policy.

## 4. Public API

- API-001 (**MUST**) Keep the public surface **minimal and stable**, centered on service accessors and focused methods.
- API-002 (**MUST**, **v1.0.0+**) Follow **SemVer**; document migrations for breaking changes.
- API-003 (**SHOULD**) Provide **executable examples** under `examples/` that compile against the current API.

## 5. Context / Concurrency

- CTX-001 (**MUST**) Thread `context.Context` through **all operations that can block or be canceled** (I/O, long CPU tasks) and respect deadlines/cancellation.

## 6. Errors

- ERR-001 (**MUST**) Wrap with `%w` and include **actionable context** (operation, identifier, hint). Avoid leaking secrets in messages.

## 7. Logging

- LOG-001 (**SHOULD**) Use **structured logging** (e.g., `slog`) **only if injected** (via `WithLogger`). **MUST NOT** create global loggers in the library.

## 8. Configuration

- CFG-001 (**MUST**) Accept configuration via **constructor args + Functional Options**; do **not** read env/files from within the library.
- CFG-002 (**SHOULD**) Validate options at construction and **fail fast** on invalid configs.
- CFG-003 (**SHOULD**) Provide safe defaults (timeouts, headers, TLS) where applicable.

## 9. Data Formats & Wire Compatibility

- SER-001 (**MUST**) Maintain compatibility with the **declared external schema/protocol**. Keep struct tags correct (e.g., `json:"field_name,omitempty"`; adapt similarly for XML/other encodings).

## 10. I/O & Transport Hygiene (HTTP/DB/RPC — if applicable)

- NET-001 (**MUST**) Reuse a single client/connection pool on the root client and **close bodies/cursors/rows on all paths**.
- NET-002 (**MUST**) Set explicit **timeouts** and honor `context` deadlines.
- NET-003 (**SHOULD**) Provide **bounded** retries/backoff (configurable via Options). Do not retry indefinitely.
- NET-004 (**MUST**) Set required metadata (e.g., headers/options) and **never** log credentials or sensitive tokens.

## 11. Testing

- TS-001 (**MUST**) Use **table-driven tests** and `t.Run` subtests.
- TS-002 (**MUST**) Cover success/failure paths; avoid time-fragile tests.
- TS-003 (**SHOULD**) Prefer fakes/mocks via **small interfaces**; avoid heavyweight frameworks.
- TS-004 (**SHOULD**) Guard integration/system tests via build tags or env; **skip gracefully** when unset.
- TS-005 (**MUST**) Focus on critical paths; target **~95% coverage** as a guideline (quality over gambling for 100%).
- TS-006 (**SHOULD**) Ensure `examples/` compile in CI.
- TS-007 (**SHOULD**) Centralize fixtures/helpers under `internal/testutil` to reduce duplication.
