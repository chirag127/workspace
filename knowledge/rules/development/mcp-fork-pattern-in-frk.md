---
type: rule
title: 'MCP forks live in repos/frk/<name>-mcp/; fixes go upstream via PR'
description: "Fork MCP servers to frk/ and PR upstream"
tags: [mcp, fork, frk, upstream, pr, hard-rule]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/development/fork-discipline
  - rules/development/mcp-repo-naming-suffix
  - rules/agent/agent-fleet-parity
---

# MCP forks in `repos/frk/`

## Rule

When the fleet uses an MCP server that requires modification or version-locking:

1. **Fork** the upstream repo to `oriz-org/<name>-mcp` (preserves [`mcp-repo-naming-suffix`](../development/mcp-repo-naming-suffix.md)).
2. **Add as submodule** at `repos/frk/<name>-mcp/`.
3. **Work on the fork** for local fixes.
4. **PR upstream** when the fix is generally useful.
5. **Sync** fork with upstream regularly per [`fork-discipline`](../development/fork-discipline.md).
6. **Smithery uploads** point at the fork URL, not upstream.

## When to fork vs use upstream

| Situation | Action |
|---|---|
| Server works as-is on Smithery | **Don't fork.** Add to your Smithery toolbox. Lazy. |
| Server not on Smithery; works as-is from npm/PyPI | **Don't fork.** Use upstream package in `.mcp.json`. |
| Server broken / needs config knobs not exposed | **Fork to `repos/frk/`**, fix, PR upstream |
| Server abandoned / unresponsive maintainer | **Fork to `repos/frk/`**, maintain ourselves, don't bother with PR |
| Need to lock to a specific version for safety | **Fork to `repos/frk/`**, pin tag, don't auto-pull |

## Forking flow

```cmd
gh repo fork <upstream>/<name>-mcp --org oriz-org --clone=false
cd C:\D\oriz
git submodule add https://github.com/oriz-org/<name>-mcp repos/frk/<name>-mcp
```

After cloning, set the upstream remote:

```cmd
cd repos/frk/<name>-mcp
git remote add upstream https://github.com/<upstream>/<name>-mcp
git fetch upstream
```

## PR-upstream flow

When you fix a real bug:

```cmd
cd repos/frk/<name>-mcp
git checkout -b fix/<short-slug>
# make changes, commit
git push origin fix/<short-slug>
gh pr create --repo <upstream>/<name>-mcp --base main --head oriz-org:fix/<short-slug>
```

This satisfies both [`no-branches-on-own-repos`](../agent/preferences/no-branches-on-own-repos.md) (forks aren't "own repos") and the upstream-contribution norm.

## Smithery uploads use fork URL

When uploading to Smithery toolbox `@chirag127/toolbox`:

- Upload **fork URL** (`https://github.com/oriz-org/<name>-mcp`), not upstream.
- Smithery proxies HTTP MCPs and builds stdio MCPs in its container — pointing at our fork means Smithery rebuilds when we push to fork, not when upstream pushes.

## Lazy gate

Per ponytail: don't fork preemptively. Only fork when:

1. You actually want to use the MCP, AND
2. It's NOT already on Smithery in working state, OR
3. It IS on Smithery but you need a modification.

If both conditions fail, use Smithery's hosted version of upstream. No fork needed.

## Cross-refs

- [`fork-discipline`](../development/fork-discipline.md) — general fork rules
- [`mcp-repo-naming-suffix`](../development/mcp-repo-naming-suffix.md) — naming
- [`agent-fleet-parity`](./agent-fleet-parity.md) — Smithery toolbox role
- Runbook: [`upload-mcp-to-smithery-toolbox`](../../runbooks/workflow/upload-mcp-to-smithery-toolbox.md)
