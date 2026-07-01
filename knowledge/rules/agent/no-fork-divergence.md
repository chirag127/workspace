---
type: rule
title: "No fork divergence — upstream PRs only"
description: "Local forks in repos/frk/* stay byte-identical to upstream main. Every local change files as an upstream PR immediately."
tags: [rules, agent, forks, upstream, pr]
timestamp: 2026-07-01
format_version: okf-v0.1
status: active
related:
  - rules/development/fork-discipline
  - rules/development/mcp-fork-pattern-in-frk
  - rules/agent/self-update-rule
---

# No fork divergence — upstream PRs only

## Rule

Every fork under `repos/frk/*` MUST stay byte-identical to `upstream/main`. Any local change — bug fix, missing dep, patch — must be filed as an **upstream PR** in the same turn as the edit. No exceptions for "just this once" or "we'll upstream it later."

## Why

Divergence rots silently. The failure mode is:

1. Local edits accumulate in the fork's `main`
2. Upstream releases new versions
3. `git pull upstream/main` produces merge conflicts
4. The team "fixes" the conflict by reverting local changes and losing the work
5. Or worse: keeps both, ships broken hybrid, blames the upstream

We hit this today (2026-07-01): our fork's `package.json` had two runtime deps (`@toon-format/toon`, `safe-regex`) that upstream imports but didn't declare. We ADDED them locally without filing. That's divergence for a fix that helps upstream too.

## How

When you spot a bug in fork source and reach for `Edit`:

1. **STOP.** Do not edit fork's `main`.
2. `git -C <fork> checkout -b <slug>` from `upstream/main`.
3. Make the fix on the branch.
4. `git push origin <slug>` (push to `oriz-org/<repo>`, our fork).
5. `gh pr create --repo <upstream-owner>/<upstream-repo> --head "oriz-org:<slug>" --base main --title "..." --body-file <path>` — file the PR against upstream.
6. Switch fork back to `main`. Fork's `main` stays clean.
7. Fetch/pull happens against `upstream/main` only.

## Exception (narrow)

Local `main` may carry:
- Non-code artifacts that CANNOT be upstreamed (e.g. `.source/` regenerated locally, `.env` decrypted locally, `pnpm-lock.yaml` if upstream ships `package-lock.json`).
- These must be gitignored where possible; where impossible, documented in the fork's per-agent stub.

Runtime source code, dependency declarations, config in `package.json`, scripts, docs, tests — all upstream-only.

## Enforcement

Before ending any session that touched a fork:

```bash
git -C repos/frk/<name> diff upstream/main -- package.json 'src/**' 'open-sse/**' 'bin/**' 'scripts/**' '*.md'
```

Non-empty output = divergence rule violation. File the PR before committing to fork main.

## Cross-refs

- [`fork-discipline`](../development/fork-discipline.md) — forks live in `repos/frk/<upstream-name>` with upstream wired as remote
- [`mcp-fork-pattern-in-frk`](../development/mcp-fork-pattern-in-frk.md) — MCP fork narrower case
- [`self-update-rule`](./self-update-rule.md) — same-turn write discipline
- Real incident this rule was born from: OmniRoute fork's `@toon-format/toon` + `safe-regex` runtime deps added locally 2026-07-01, later filed upstream as [PR #5766](https://github.com/diegosouzapw/OmniRoute/pull/5766)
