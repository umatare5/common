# Examples

This directory contains example code and sample projects that demonstrate various programming patterns and serve as test cases for the CI/CD workflows.

## Available examples

[`go-server/`](go-server/) is a Go HTTP server with basic endpoints. The Go workflows build and test against it, so a change to one of them is exercised here before it reaches a consuming repository.
