---
type: service
title: "GitHub Secrets"
description: "Runtime secret store for GitHub Actions — written by Doppler, read by workflows. Free unlimited."
tags: [secrets, github, ci, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: secrets-ci-runtime
provider: github
free_tier: "Unlimited org / repo / environment secrets; included with GitHub free"
swap_cost: low
---

# GitHub Secrets

## Role

Runtime secret store for everything that runs inside GitHub
Actions — `npm publish`, `wrangler deploy`, `gh release`, the
omnipost cron, every CI workflow. **Doppler writes; Actions
reads.** GitHub Secrets is the runtime mirror, never the source
of truth.

## Free tier

- **Unlimited** secrets at org / repo / environment scope.
- Included with every GitHub repo, no add-on.
- Encrypted at rest; redacted from logs by GitHub automatically.

## Card / subscription required?

**NO.** Included with free GitHub.

## Scoping rules

The family always picks the **narrowest** scope that lets the workflow run:

| Scope | When to use | Example |
|---|---|---|
| **Environment** (per-repo, per-env) | Production deploy keys; secrets a workflow only needs in `prod` | `CLOUDFLARE_API_TOKEN` in `oriz` repo's `prod` environment |
| **Repo** | Secrets used across multiple workflows in one repo, all environments | `OMNIPOST_DEVTO_TOKEN` in the `oriz-omnipost` repo |
| **Organization** | Secrets shared by 3+ repos | `NPM_TOKEN` for `@chirag127/` package publishes; `DOPPLER_SERVICE_TOKEN` |

Org-level secrets carry an explicit allow-list of repos. **Never**
use "all repositories" — it leaks the secret to forks and to repos
that don't need it.

## Alternatives

- [Doppler](./doppler.md) — source of truth, syncs INTO GH Secrets
- HashiCorp Vault Action (over-engineered for our size)
- AWS Secrets Manager (rejected — AWS card requirement)

## Swap cost

Low — secret values are short strings written via `gh secret set` or
the Doppler integration. Swap to another CI runtime would mean
moving the same values into the new runtime's secret store.

## Why this is our pick (as runtime mirror)

It's already there — every Action reads from it natively, no
plumbing. Pairing it with Doppler-as-source-of-truth gets us:

- Audit + rotation centralised at Doppler.
- Workflow-side simplicity — `${{ secrets.RAZORPAY_KEY_ID }}` just works.
- No secret value ever pasted by a human into the GitHub UI — Doppler's GitHub App writes them.

## Implementation notes

- Install Doppler's GitHub App on the user's account and the `chirag127` org.
- For each Doppler project, configure the GH Actions integration with the target repo / org / environment.
- Workflows reference secrets the standard way (`${{ secrets.NAME }}`); they don't know Doppler exists.
- **Never** `gh secret set` by hand for production secrets — that bypasses the audit log. The exception is bootstrapping (`DOPPLER_SERVICE_TOKEN` itself), which Doppler can't sync into GH because it's the credential that does the syncing.
- Per-repo settings → "Allow GitHub Actions to create and approve PRs" stays **off**.
- Workflow log redaction is automatic but never trust it for binary blobs — secrets in JSON / multiline values can leak through indirect outputs. The [secrets-handling policy](../../decisions/policy/secrets-handling.md) covers the don'ts.

## Cross-refs

- [Doppler — source of truth](./doppler.md)
- [Secrets management decision](../../decisions/security/secrets-management-doppler.md)
- [GitHub Actions service entry](../compute/github-actions.md)
- [No hardcoded secrets rule](../../rules/security/no-hardcoded-secrets.md)
- [Rotate leaked secret runbook](../../runbooks/security/rotate-leaked-secret.md)
