# Go Server Example

A simple HTTP server that demonstrates basic Go web development patterns.

## Features

- Basic HTTP handlers
- Query parameter handling
- Health check endpoint
- Environment variable configuration
- Unit tests with httptest

## Usage

```bash
# Navigate to the example directory
cd examples/go-server

# Run the server
go run main.go

# Run tests
go test ./...

# Build the application
go build -o server main.go
```

## Endpoints

- `GET /hello?name=<name>` - Returns a greeting message
- `GET /health` - Health check endpoint

## Example Requests

```bash
# Basic hello
curl http://localhost:8080/hello
# Response: Hello, World!

# Hello with name
curl http://localhost:8080/hello?name=Alice
# Response: Hello, Alice!

# Health check
curl http://localhost:8080/health
# Response: OK
```

This example serves as sample code for CodeQL analysis and demonstrates common web application patterns in Go.
