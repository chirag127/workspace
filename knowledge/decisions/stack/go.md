---
type: architecture
title: Go Minimalist & Modern Stack
description: Minimalist stack for Go
  and dev tools for Go.
tags:
- go
- stack
- architecture
- minimalist
- tooling
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
---


# Go Minimalist & Modern Stack

The definitive, modern toolchain and library stack for Go development, optimized for speed, simplicity, minimal runtime overhead, and strict type safety.

- **Runtime Environment:** Go 1.21+
  - *Chosen over older versions* for the inclusion of the structured logging package `slog` in the standard library, built-in functions `min`, `max`, and `clear`, and toolchain management improvements that automatically download the requested Go version, along with continuous compiler optimizations (such as Profile-Guided Optimization).

- **Package Manager:** `go mod` (Go Modules)
  - Go's native dependency management system. Guarantees zero third-party dependency resolution overhead, reproducibility via `go.sum` hashes, and native integration into the standard Go toolchain without requiring external tool dependencies.

- **Formatter:** `gofmt`
  - The standard Go formatting tool. Zero configuration, zero formatting arguments. Guarantees 100% consistent styling across all Go codebases globally, eliminating formatting bikeshedding entirely.

- **Linter:** [golangci-lint](https://golangci-lint.run/)
  - *Chosen over standard go vet:* `golangci-lint` runs dozens of linters in parallel (using caching and Go AST reuse) to catch concurrency bugs, code smells, performance issues, and security vulnerabilities that standard `go vet` completely misses. It aggregates multiple popular linters (such as staticcheck, errcheck, goimports, and revive) into a single, unified, and highly configurable runner.

- **Test Runner:** `go test` with [testify](https://github.com/stretchr/testify)
  - Go's native testing tool is lightweight, extremely fast, and supports running tests in parallel. `testify` is added to provide clean, readable assertion helper methods (e.g., `assert.Equal`, `assert.NoError`) without introducing bloated framework abstractions, maintaining full compatibility with the native `testing.T` struct.

- **Web/API Router:** [Chi](https://github.com/go-chi/chi)
  - *Chosen over Gin:* Gin uses a custom context and custom handler signatures, breaking compatibility with the standard library's `http.Handler` and standard middleware. Gin also has a larger memory footprint and does not support standard routing patterns as cleanly.
  - *Chosen over Fiber:* Fiber is built on `fasthttp`, which is not fully HTTP/1.1 or HTTP/2 compliant, breaks standard `net/http` compatibility, uses unsafe memory practices that can lead to bugs, and does not run on platforms that require standard network interfaces.
  - *Chosen over Echo:* Echo is a full-featured framework with its own custom context type, which adds runtime overhead and makes it harder to share middleware with standard library routers.
  - *Chi's benefits:* Chi is a lightweight, 100% stdlib-compatible router with zero external dependencies. It compiles to zero allocations per route match, supports sub-routers for clean modular code, and allows seamless integration of standard HTTP middleware.

- **SQL Generator / ORM:** [sqlc](https://sqlc.dev/)
  - *Chosen over GORM:* GORM is a heavy ORM that uses runtime reflection, leading to slow queries, high CPU usage, and type-unsafe code (e.g., passing strings for column/table names). It abstracts the SQL database, which can lead to inefficient queries and N+1 query problems.
  - *Chosen over standard database/sql:* Writing raw SQL with standard `database/sql` requires manual scanning of rows into structs, which is repetitive, error-prone if columns change, and lacks type safety.
  - *sqlc's benefits:* `sqlc` takes raw SQL queries and schemas, parses them, and compiles them into completely type-safe Go code. It provides compile-time query validation, zero runtime reflection overhead, and extremely fast execution times since it generates standard Go code that uses the native database driver directly.
