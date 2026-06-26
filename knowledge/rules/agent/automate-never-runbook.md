---
type: rule
title: 'Automate everything — never deliver a runbook'
description: When the user asks to set up/host/deploy/configure anything, ship one executable script (or a small set) that does it end-to-end. Manual steps are a defect.
tags: [automation, deployment, hard-rule, user-identity]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/setup-repo-as-bootstrap
  - rules/agent/preferences/scope-cut-only-shipping-survives
---

# Hard rule: automate, do not document

When the user asks to set up, deploy, host, configure, provision, or install
anything, the deliverable is a **script** (or a small set of scripts) that
executes end-to-end. NEVER a numbered list of manual steps.

## What this rules out

- ❌ "Step 1: open the portal, click Create..."
- ❌ "Run these 12 commands one by one..."
- ❌ Multi-page runbooks with copy-paste blocks the user has to babysit
- ❌ TaskCreate breakdowns that just enumerate the manual steps
- ❌ "First do X, then I'll do Y" — user is the bottleneck

## What this rules in

- ✅ Single entry point: `./deploy.sh`, `pwsh deploy.ps1`, `npm run deploy`,
  `make deploy`, or `gh workflow run deploy.yml`
- ✅ Idempotent: re-runs converge to the same state, no failures on second run
- ✅ Self-checking: script verifies preconditions, fails fast with clear errors
- ✅ Provider CLIs over portals (az, gh, fly, wrangler, vercel, cf, sops)
- ✅ Infrastructure-as-code (Bicep / Terraform / Pulumi) when state matters
- ✅ Secrets fetched at runtime (Bitwarden, Key Vault, env), never hardcoded

## The only manual step allowed

ONE interactive credential prompt at the top of the script (e.g. `az login`,
`gh auth login`, `bw unlock`). Everything after that must be non-interactive.

## When asking permission is OK

`AskUserQuestion` to lock decisions (compute size, domain, region) — yes.
`AskUserQuestion` "shall I run the next step?" — no. Lock all decisions
up front, then execute the whole thing.

## Cross-refs

- `setup-repo-as-bootstrap` — same shape: one `bootstrap.ps1` does everything
- `scope-cut-only-shipping-survives` — runbooks that humans execute don't ship
