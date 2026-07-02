---
type: rule
title: "Everything should be in Dagger — GHA/GitLab/Codeberg are thin adapters only"
description: "All CI/CD logic lives in Dagger TS modules. GitHub Actions, GitLab CI, Woodpecker, Codeberg are 5-line wrappers that call `dagger call`. No real logic in YAML."
tags: [ci, dagger, pipeline, portable]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - decisions/stack/pipeline-stack-2026-07-01
  - decisions/stack/dagger-confirmed-2026-07-02
  - decisions/architecture/agent-tooling/reusable-workflows-layered-2026-07-02
---

# Everything should be in Dagger

## The rule

Every CI/CD pipeline must be implemented as a **Dagger TS module**. GitHub Actions, GitLab CI, Woodpecker, and Codeberg workflows are **5-line thin adapters** that invoke `dagger call`. Zero real logic lives in YAML.

## What "thin adapter" means

```yaml
# .github/workflows/ci.yml — this is the ENTIRE workflow
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

The actual lint, typecheck, test, build, deploy logic lives in `dagger/src/index.ts`.

## Why

- **Local reproducibility**: `dagger call ci --source=.` on laptop = identical to CI. No "works on my machine" gaps.
- **Provider portability**: same Dagger module runs on GHA, GitLab, Woodpecker, Codeberg, self-hosted — swap the 5-line YAML adapter, zero logic changes.
- **Testability**: Dagger functions are TypeScript — unit-testable, type-safe, refactorable.
- **No YAML sprawl**: YAML is config, not code. Business logic in YAML = untestable, untyped, duplicated.

## Anti-patterns

- ❌ 100-line GHA YAML that installs deps, runs lint, runs tests, builds, deploys — all in YAML steps
- ❌ Copying the same setup-node + pnpm-install block across 20 workflow files
- ❌ Building a `build-windows-personal.yml` that uses choco, cargo, bun directly in workflow steps instead of wrapping in Dagger
- ❌ Using `uses: actions/cache@v4` for caching — Dagger has its own layer cache via `dag.cacheVolume()`

## The screenpipe GHA workflow lesson

The `build-windows-personal.yml` created for `chirag127/screenpipe` failed because LLVM version was wrong in the YAML steps. Had this been a Dagger module, the LLVM setup would be in TypeScript with proper version detection — not brittle choco pin. Every YAML failure is a reminder to move logic to Dagger.

## Where Dagger modules live

Fleet-wide reusable modules: `chirag127/workflows/dagger/<class>/src/index.ts`

Classes:
- `astro-site` — lint + typecheck + test + build + CF deploy
- `astro-api` — lint + typecheck + build
- `astro-pwa` — full CI + PWA manifest check
- `mdbook` — mdbook build + link test
- `browser-ext` — WXT + web-ext manifest lint
- `vsc-ext` — lint + typecheck + build + vsce package
- `userscript` — syntax + metadata validation
- `npm-pkg` — lint + typecheck + test + build + publish

## Exception: GH-integrated workflows

Keep native YAML for: `ossf/scorecard`, CodeQL, `actions/deploy-pages@v4` (OIDC), Dependabot config. These integrate with GitHub Security tab dashboards — Dagger cannot replicate that.

## Cross-refs

- [`pipeline-stack-2026-07-01`](../../decisions/stack/pipeline-stack-2026-07-01.md) — the locked stack (pnpm + MegaLinter + Dagger TS)
- [`dagger-confirmed-2026-07-02`](../../decisions/stack/dagger-confirmed-2026-07-02.md) — re-grill that confirmed Dagger after debate
- [`reusable-workflows-layered-2026-07-02`](../../decisions/architecture/agent-tooling/reusable-workflows-layered-2026-07-02.md) — how Dagger + reusable GHA workflows compose
