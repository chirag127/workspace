---
type: decision
title: "Hybrid Dagger+GHA architecture locked — 2026-07-02"
description: "Per-class Dagger modules in chirag127/workflows. GHA = 5-line adapter. Tauri Windows = GHA host for cargo, Dagger for portable parts. Both cacheVolume() + actions/cache."
tags: [ci, dagger, gha, hybrid, caching, architecture]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
supersedes: []
related:
  - rules/development/everything-in-dagger
  - decisions/stack/dagger-confirmed-2026-07-02
  - decisions/stack/pipeline-stack-2026-07-01
---

# Hybrid Dagger+GHA architecture

## Locked decisions (2026-07-02 grill)

### Module granularity
**Per-class modules in `chirag127/workflows`.**
- `dagger/astro-site/`, `dagger/astro-api/`, `dagger/astro-pwa/`, `dagger/mdbook/`, `dagger/browser-ext/`, `dagger/vsc-ext/`, `dagger/userscript/`, `dagger/npm-pkg/`
- Each module = 1 Dagger TS file: `lint()`, `typecheck()`, `test()`, `build()`, `ci()`, `deploy*()`
- NOT per-repo (duplication) and NOT single-global (inflexible)

### screenpipe Tauri Windows build
**Dagger for portable parts, GHA host for cargo/Tauri.**

Tauri Windows builds CANNOT run in Dagger containers because:
- `windows-latest` GHA runner ships no Docker daemon
- Tauri requires MSVC toolchain, WebView2 Runtime, NSIS — all Windows-only
- Windows SDK headers used by screenpipe's capture layer

Therefore:
- `dagger/windows-build/src/index.ts` — `validateEnv()`, `getVersion()`, `buildFrontend()` (Linux-safe)
- `.github/workflows/build-windows-personal.yml` — named steps on `windows-latest` host, calls `bun run tauri build` directly

If Dagger ever ships stable Windows container support + GHA windows-latest ships Docker → revisit.

### Caching strategy
**Both Dagger `cacheVolume()` + `actions/cache@v4`.**

| What | Where |
|---|---|
| npm/bun packages inside Dagger containers | `dag.cacheVolume("bun-cache")` |
| Cargo registry on GHA Windows host | `Swatinem/rust-cache@v2` |
| bun install cache on GHA Windows host | `actions/cache@v4` |
| Next.js build cache on GHA Windows host | `actions/cache@v4` |

Keys: `v1-rust-win-<Cargo.lock hash>`, `bun-next-<runner.os>-<bun.lock hash>`

### Conversion scope
**All workflows**: chirag127/workflows (7 reusable) + screenpipe build-windows-personal.yml + umbrella deploy.yml.

## The pattern (reference)

```yaml
# .github/workflows/ci.yml — 5-line adapter (thin)
name: ci
on: [push, pull_request]
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dagger/dagger-for-github@v8.4.1
        with:
          version: latest
          call: ci --source=.
```

```typescript
// dagger/<class>/src/index.ts — all logic here
@object()
export class AstroSite {
  @func() async lint(source: Directory): Promise<string> { ... }
  @func() async typecheck(source: Directory): Promise<string> { ... }
  @func() async test(source: Directory): Promise<string> { ... }
  @func() build(source: Directory): Directory { ... }
  @func() async ci(source: Directory): Promise<string> {
    await Promise.all([this.lint(source), this.typecheck(source), this.test(source)])
    await this.build(source)
    return "ok"
  }
}
```

## Cross-refs

- [`everything-in-dagger`](../../rules/development/everything-in-dagger.md)
- [`dagger-confirmed-2026-07-02`](../stack/dagger-confirmed-2026-07-02.md)
- [`reusable-workflows-layered-2026-07-02`](./reusable-workflows-layered-2026-07-02.md)
