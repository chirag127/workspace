---
type: decision
title: "Pipeline stack lock 2026-07-01 — pnpm + MegaLinter + Dagger TS"
description: "The five-layer canonical stack for every oriz repo: pnpm 11 (package + tasks), MegaLinter (lint), Dagger TS (CI pipelines), TypeScript everywhere. No mise, no super-linter, no Earthly, no Python for new scripts."
tags: [stack, pnpm, dagger, megalinter, typescript, ci, pipelines]
timestamp: 2026-07-01
format_version: okf-v0.1
status: active
supersedes:
  - decisions/stack/tools-shape-and-priority
related:
  - rules/development/use-pnpm
  - decisions/stack/javascript-typescript
  - decisions/ops/mirror-to-9-popular-alternatives-2026-06-28
---

# Pipeline stack lock 2026-07-01

## The 5-layer stack

| Layer | Tool | Why |
|---|---|---|
| Package manager | **pnpm 11** | Locked; 2-3× faster than npm, 70% less disk, monorepo-native |
| Task runner | **pnpm scripts** | Already in `package.json`, no extra tool |
| Linter | **MegaLinter** (oxsecurity/megalinter) | 7.6× more active than super-linter, 134 linters vs ~50, auto-fix commits, first-class GitLab/Azure/Jenkins docs |
| CI pipeline | **Dagger TS** | Type-safe, portable across GHA/GitLab/Codeberg, same code as app repos |
| Scripts | **TypeScript** (`tsx` or `bun` runner) | Single-language codebase; Python scripts migrate to TS |

## Rejected alternatives

| Tool | Why rejected |
|---|---|
| npm | 2-3× slower, 3× more disk |
| yarn v1 | Deprecated 2024 |
| yarn 4 (Berry PnP) | Breaks Astro Integration + CF Workers tooling |
| bun | node-gyp addons broken (better-sqlite3 fails); Astro adapter community-only |
| mise | pnpm already covers task-running for Node-only stack |
| super-linter | 89 commits/90d vs MegaLinter 680; auto-fix only prints to console |
| Earthly | Dead — Cloud shut down 2025-07 |
| Nix Flakes | Windows requires WSL |
| Bazel/Buck2 | Over-engineered for 100 polyrepos |

## Adoption policy

- **New repos**: start with the 5-layer stack from day 1 via a scaffolding template
- **Existing repos**: opportunistic migration — no blanket sweep
- **Python scripts in workspace**: convert to TypeScript (`.ts`) run via `tsx`

## Migration plan for existing 5 Python scripts

| Script | New file | Notes |
|---|---|---|
| `scripts/okf-prompt-lookup.py` | `scripts/okf-prompt-lookup.ts` | UserPromptSubmit hook target — must keep same stdin/stdout contract |
| `scripts/okf-index-lookup.py` | `scripts/okf-index-lookup.ts` | CLI, stdlib-only Python → node:fs + path |
| `scripts/fix_broken_links.py` | `scripts/fix-broken-links.ts` | Rename kebab-case per repo convention |
| `scripts/restructure_knowledge.py` | delete (one-time script, already ran) | Historical |
| `scripts/rename-agent-rules-to-rules-agent.py` | delete (one-time) | Historical |

## Every new repo template

```
├── package.json          # pnpm 11
├── pnpm-lock.yaml
├── .mise.toml            # OPTIONAL — only if this repo needs non-Node toolchain
├── .mega-linter.yml      # MegaLinter config (or leave empty for defaults)
├── dagger/
│   └── main.ts           # Dagger TS pipeline
├── .github/workflows/
│   └── ci.yml            # 5-line thin adapter: `dagger call ci`
└── tsconfig.json
```

## Thin CI adapter (works on GHA, GitLab, Codeberg, self-host)

```yaml
# .github/workflows/ci.yml
on: [push, pull_request]
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dagger/dagger-for-github@8.0.0
        with:
          call: ci --source=.
```

Swap the `uses:` line to switch CI providers. `dagger call` runs identically everywhere.

## Cross-refs

- [`use-pnpm`](../../rules/development/use-pnpm.md)
- [`javascript-typescript`](./javascript-typescript.md)
- [`mirror-to-9-popular-alternatives-2026-06-28`](../ops/mirror-to-9-popular-alternatives-2026-06-28.md) — Codeberg CI hedge stays valid; Dagger runs identically there
