---
type: service
title: "GitHub Actions schedule (cron)"
description: "Build- and publish-shaped scheduled jobs on GitHub Actions — free unlimited minutes for public repos (the family runs 100% public)."
tags: [cron, github, actions, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: cron-build-publish
provider: github
free_tier: "Unlimited minutes for public repos; 2,000 min/mo for private (the family runs 100% public)"
swap_cost: low
---

# GitHub Actions schedule (cron)

## Role

Scheduled jobs that need a **build environment** — Node + pnpm,
secrets, repo checkout, the ability to commit results back to a repo
or publish to npm / a registry / a deploy target.

This is the sister substrate to
[Cloudflare Cron Triggers](./cloudflare-cron-triggers.md). The two
together implement the
[cron split](../../decisions/architecture/cron-split-cf-vs-gh.md).

## Free tier

- **Unlimited minutes** on public repos (every family repo is public — see [one-branch-only rule](../../decisions/process/one-branch-only-rule.md) and [cloudflare-pages-for-all-sites.md](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md)).
- 2,000 min/mo on private repos (we don't use private).
- Schedule precision: roughly 5–15 min jitter per the GH Actions schedule contract — fine for the jobs we run here, NOT fine for sub-minute latency (use CF Cron for those).

## Card / subscription required?

**NO.** Free for personal accounts on public repos with no payment
method on file.

## What we run on it

| Job | Repo | Cadence | Why GH Actions |
|---|---|---|---|
| `oriz-omnipost` RSS cross-post run | `oriz-omnipost` | every 30 min | Commits `state.json` back to repo; needs `pnpm` + adapters' fetch tokens |
| Master deploy matrix on pointer-bump | `oriz` | on push (not strictly cron, sibling workflow) | Needs `wrangler` + each site's secrets |
| Dependabot security update sweep | every repo | daily | GitHub-native |
| `npm publish` of `@chirag127/oriz-kit` etc. on tag | `oriz` | on tag (sibling workflow) | Needs `pnpm` + npm token |
| Per-site GitHub Pages mirror build | each `oriz-*-site` | nightly + on push | Needs `pnpm build` |
| Lifestream JSONL ingest (push window) | `oriz-me-data` | hourly | Needs `gh` CLI + repo write |

## Alternatives

- [Cloudflare Cron Triggers](./cloudflare-cron-triggers.md) — sister substrate
- GitLab CI scheduled pipelines
- Self-hosted runner (rejected — adds infra to maintain)

## Swap cost

Low — workflow YAML is mostly portable. `cron:` triggers move to
`schedule:` on most runners. Repo write commits would need a
different bot identity off-platform.

## Why this is our pick

For build / publish / "commit results back" jobs, GH Actions has the
toolchain, the secrets, and the repo write access already wired
together. Free at our scale on public repos. Failures show up in a
dashboard humans already watch.

## Cross-refs

- [Cron split decision](../../decisions/architecture/cron-split-cf-vs-gh.md)
- [Cloudflare Cron Triggers](./cloudflare-cron-triggers.md) — sister cron
- [GitHub Actions full service entry](../compute/github-actions.md)
- [Per-repo CI workflows](../../decisions/process/per-repo-ci-workflows.md)
- [Cross-post engine](../../decisions/architecture/cross-post-engine.md)
