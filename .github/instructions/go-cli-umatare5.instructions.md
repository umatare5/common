---
description: Go Large CLI Application Development Instructions
applyTo: "**/*.go"
---

# GitHub Copilot Agent Mode – Go Large CLI Application Development Instructions

Copilot **MUST** comply with all instructions described in this document when editing or creating any Go code in this repository.

However, when there are conflicts between this document and `general.instructions.md`, **ALWAYS** prioritize the instructions in `general.instructions.md`.

---

## 🎯 Primary Goal

Develop and maintain production-ready CLI applications with clean architecture and excellent user experience. Focus on building robust command-line tools that follow Go best practices.

---

## 🧭 Architecture & Design Principles

- **Clean Architecture with Clear Separation:**

  ```
  cli/         → CLI layer (commands, flags, UI)
  framework/   → Framework layer (controller logic, data formatting)
  application/ → Application layer (business logic, use cases)
  infrastructure/ → Infrastructure layer (data access, external APIs)
  config/      → Configuration layer (global config management)
  ```

  - Diagram of the architecture:

    ```plaintext
    +----------------------+    +----------------------+    +----------------------+    +---------------------+
    |        cli/          | -> |      framework/      | -> |     application/     | -> |   infrastructure/   |
    |   (CLI & UI Layer)   |    |  (Validation Layer)  |    |   (Business Logic)   |    |    (Data Access)    |
    +--------+-------------+    +--------+-------------+    +--------+-------------+    +--------+------------+
             |                           |                           |                           |
             v                           v                           v                           v
    +---------------------------------------------------------------------------------------------------------+
    |                                                  config/                                                |
    |                                           (Configuration Layer)                                         |
    +---------------------------------------------------------------------------------------------------------+
    ```

- **Dependency Injection Pattern:**
  Always inject dependencies through constructors. Each layer should receive its dependencies explicitly:

  ```go
  // Example pattern used throughout the codebase
  c := config.New()
  r := infrastructure.New(&c)
  u := application.New(&c, &r)
  f := framework.NewCli(&c, &r, &u)
  ```

- **Package-per-Command Structure:**
  Organize CLI commands into separate packages (`show/`, `generate/`) with clear responsibilities.

- **Avoid Global State:**
  Pass configuration and state through struct fields and function parameters, never use global variables.

---

## 🛠️ CLI Development Practices

- **Follow Go CLI Best Practices:**
  Conform to [Go CLI best practices](https://go.dev/doc/effective_go) and CLI design principles from the Unix philosophy.

- **Command Structure:**

  ```go
  // Each command should follow this pattern
  func RegisterXxxSubCommand() []*cli.Command {
      return []*cli.Command{
          {
              Name:      "command-name",
              Usage:     "Brief description",
              UsageText: "app command-name [options...]",
              Aliases:   []string{"alias"},
              Flags:     registerXxxCmdFlags(),
              Action:    commandAction,
          },
      }
  }
  ```

- **Flag Organization:**
  Group related flags in separate functions. Reuse common flags across commands:

  ```go
  // Reusable flag patterns
  flags = append(flags, registerTargetsFlag()...)
  flags = append(flags, registerInsecureFlag()...)
  flags = append(flags, registerOutputFormatFlag()...)
  ```

- **Error Handling for CLI:**
  - Use `log.Fatal()` only for CLI-specific fatal errors (configuration validation, startup issues)
  - Return errors from action functions to be handled by the CLI framework
  - Provide clear, actionable error messages to users

---

## 🏗️ Layer-Specific Guidelines

### CLI Layer (`internal/cli/`)

- **Purpose:** Handle command registration, flag parsing, and user interaction
- **Responsibilities:**

  - Register commands and subcommands
  - Define and validate CLI flags
  - Coordinate dependency injection
  - Handle CLI-specific error cases

- **Key Patterns:**

  ```go
  // Action pattern for commands
  Action: func(ctx context.Context, cmd *cli.Command) error {
      c := config.New()
      r := infrastructure.New(&c)
      u := application.New(&c, &r)
      f := framework.NewCli(&c, &r, &u)

      c.SetCmdConfig(cmd)
      f.InvokeXxxCli().DoSomething()
      return nil
  }
  ```

### Framework Layer (`internal/framework/`)

- **Purpose:** Handle presentation logic and data formatting
- **Responsibilities:**

  - Format data for display (table, JSON)
  - Sort and filter results
  - Convert raw API responses to user-friendly output
  - Handle output format switching

- **Key Patterns:**
  ```go
  // Display logic with format support
  if isJSONFormat(tc.Config.CmdConfig.OutputFormat) {
      tc.renderAsJSON(data)
  } else {
      tc.renderAsTable(data)
  }
  ```

### Application Layer (`internal/application/`)

- **Purpose:** Implement business logic and use cases
- **Responsibilities:**
  - Coordinate multiple data sources
  - Apply business rules
  - Merge data from multiple controllers
  - Transform data for presentation

### Infrastructure Layer (`internal/infrastructure/`)

- **Purpose:** Handle external API calls and data access
- **Responsibilities:**
  - Create and manage HTTP/API clients
  - Handle authentication and authorization
  - Process API responses
  - Log communication-related errors

### Configuration Layer (`internal/config/`)

- **Purpose:** Manage application configuration
- **Responsibilities:**
  - Parse and validate CLI flags
  - Manage target service configurations
  - Handle environment variables
  - Validate user inputs

---

## 🎨 User Experience Guidelines

- **Shell-Friendly Design:**

  - Support piping and shell scripting
  - Provide both table and JSON output formats
  - Use appropriate exit codes
  - Support common shell conventions

- **Multiple Target Support:**

  - Handle multiple targets/services gracefully
  - Continue processing if one target fails
  - Clearly indicate which target data comes from

- **Error Messages:**

  - Provide clear, actionable error messages
  - Include troubleshooting hints for common issues
  - Use consistent error formatting

- **Output Consistency:**
  - Maintain consistent column headers across commands
  - Use consistent sorting and filtering patterns
  - Support common sorting options (asc/desc)

---

## 🔧 Configuration and Flag Management

- **Flag Validation:**

  ```go
  // Validate flags before processing
  func (c *Config) validateCmdFlags(cli *cli.Command) error {
      if err := c.validateTargetsFormat(cli.String(TargetsFlagName)); err != nil {
          log.Fatal(err)
      }
      return nil
  }
  ```

- **Target Format:**
  Support flexible target specification: `https://api1.example.com:token,api2.example.com:token`

- **Environment Variable Support:**
  Use `cli.EnvVars("APP_TARGETS")` for common flags to support automation

---

## 🎭 Data Presentation Standards

- **Table Output:**

  - Use consistent column alignment
  - Implement sorting by user-specified fields
  - Include visual indicators (✅❌) for status information
  - Keep table headers descriptive but concise

- **JSON Output:**

  - Preserve full data structure
  - Use consistent field names
  - Support programmatic processing

- **Data Conversion:**
  - Convert API enums to human-readable strings
  - Reference official API documentation in comments
  - Handle missing or null data gracefully

---

## 🧪 CLI Testing Guidelines

- **Integration Testing:**

  - Test with real API endpoints when possible
  - Use environment variables for test configuration
  - Skip integration tests if services are unavailable

- **Flag Testing:**

  - Test flag parsing and validation
  - Verify error handling for invalid inputs
  - Test environment variable integration

- **Output Testing:**
  - Test both table and JSON output formats
  - Verify sorting and filtering functionality
  - Test error message clarity

---

## 📊 Performance Considerations

- **Concurrent Target Access:**

  - Process multiple targets concurrently when beneficial
  - Handle timeouts gracefully
  - Implement proper context cancellation

- **Data Processing:**

  - Stream large datasets when possible
  - Minimize memory usage for large responses
  - Implement efficient sorting algorithms

- **Network Optimization:**
  - Reuse HTTP clients when possible
  - Implement appropriate timeouts
  - Support connection pooling

---

## 🔒 Security Guidelines

- **Credential Handling:**

  - Never log authentication tokens
  - Support environment variables for automation
  - Warn about insecure certificate usage

- **Network Security:**
  - Default to secure connections
  - Provide `--insecure` flag only when necessary
  - Validate target hostnames and certificates

---

## 📚 Documentation Standards

- **Command Help:**

  - Provide clear usage examples
  - Document all flags with examples
  - Include troubleshooting information

- **Code Comments:**

  - Reference API documentation for data conversions
  - Document complex business logic
  - Explain non-obvious CLI patterns

- **Error Documentation:**
  - Document common error scenarios
  - Provide resolution steps
  - Link to relevant API documentation

---

## 🚀 Command Development Workflow

When adding new commands:

1. **Create CLI registration** in `internal/cli/[category]/`
2. **Add flag definitions** following existing patterns
3. **Implement framework layer** for data presentation
4. **Develop application layer** for business logic
5. **Create infrastructure layer** for data access
6. **Add configuration support** in `internal/config/`
7. **Write comprehensive tests** for all layers
8. **Update documentation** with examples

---

## 🔄 Maintenance Guidelines

- **Consistency First:**
  Follow existing patterns and conventions throughout the codebase

- **Error Resilience:**
  Handle partial failures gracefully, especially with multiple targets

- **User Feedback:**
  Provide progress indicators for long-running operations

- **Backward Compatibility:**
  Maintain CLI interface compatibility across versions

---

## 📦 Package Management Rules

### Third-Party Library Integration

**MANDATORY**: All third-party libraries MUST be wrapped in `pkg/` layer before use in any internal layer.

- **Rule**: External dependencies MUST NOT be imported directly in `internal/` layers
- **Purpose**: Provides abstraction, easier testing, and dependency management
- **Pattern**: `pkg/[library-name]/[library-name].go`

#### Required Package Structure:

```
pkg/
├── logger/              # Wraps github.com/sirupsen/logrus
│   └── logger.go
├── tablewriter/         # Wraps github.com/olekukonko/tablewriter
│   └── tablewriter.go
└── client/              # Wraps HTTP/API client libraries
    ├── client.go        # Client creation and management
    ├── auth.go          # Authentication operations
    ├── request.go       # Request handling
    └── types.go         # Common types and structures
```

#### Implementation Pattern:

```go
// pkg/client/api.go
package client

import (
    "context"
    "net/http"
)

// GetData wraps the external library call
func GetData(client *http.Client, ctx context.Context, endpoint string) (*ApiResponse, error) {
    return makeAPICall(client, ctx, endpoint)
}
```

#### Usage in Infrastructure Layer:

```go
// internal/infrastructure/api.go
import (
    "github.com/yourorg/yourapp/pkg/client"  // ✅ Correct: Use pkg wrapper
    // "some/external/api/library"  // ❌ Wrong: Direct import
)

func (r *ApiRepository) GetData(endpoint, apikey string, isSecure *bool) *ApiResponse {
    client, err := client.NewClient(endpoint, apikey, isSecure)
    if err != nil {
        return nil
    }

    return client.GetData(client, context.Background(), endpoint)
}
```

### Import Rules

1. **Standard library**: Direct imports allowed everywhere
2. **Internal packages**: Use relative imports within the project
3. **Third-party libraries**: MUST go through `pkg/` wrapper layer
4. **API/HTTP libraries**: MUST use `pkg/client/` wrapper functions

### Dependency Flow

```
internal/cli/ → internal/framework/ → internal/application/ → internal/infrastructure/
                                                                      ↓
                                                                  pkg/ (wrappers)
                                                                      ↓
                                                              third-party libraries
```

### Benefits of pkg/ Wrapper Pattern

- **Abstraction**: Hide complex external APIs behind simple interfaces
- **Testing**: Easy to mock external dependencies
- **Consistency**: Unified error handling and logging
- **Maintainability**: Changes to external libraries isolated to pkg layer
- **Documentation**: Clear interfaces with application-specific documentation

---
