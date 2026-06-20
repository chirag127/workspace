---
type: policy
title: "Secrets — envpact only, never in chat"
description: "Every secret comes from envpact. If a secret is ever pasted into chat, treat it as compromised: revoke, rotate, re-store, redeploy."
tags: [policy, secrets, security, envpact]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
annual_review: false
related:
  - policy/ingester-contract
  - runbooks/auth-setup
  - rules/no-card-on-file
---

# Secrets — envpact only, never in chat

## The policy

Every credential the family uses is fetched from envpact at deploy
time or build time; secrets never appear in source code, in chat
transcripts, or in commit messages, and any leak triggers immediate
revoke + rotate.

## Scope

- All API keys, tokens, webhook signing secrets, service-account JSON,
  SMTP credentials, Razorpay keys, reCAPTCHA secret keys.
- All sites, extensions, packages, and the `apps/api` Worker.
- All GitHub Actions workflows (read via `chirag127/envpact-action@v0`).
- Local dev (read via `npx envpact-cli@latest` populating `.env`).

## Rules

- **Pull from envpact at runtime / buildtime.**
  ```bash
  npx envpact-cli@latest   # populates .env for the current project
  ```
  CI uses the `envpact-action` with the `ENVPACT_VAULT_TOKEN` repo
  secret.
- **Never hardcode.** No literal tokens, keys, or secrets in any
  `.ts`, `.js`, `.astro`, `.json`, `.yml`, `.toml`, `.md`, or
  `.example` file checked into git.
- **Server-only vs public.** `FIREBASE_SERVICE_ACCOUNT_KEY` is
  server-only — never expose it to a client bundle. `PUBLIC_FIREBASE_*`
  keys are safe in the client (they are not secrets, they are public
  config).
- **Never paste a secret into chat.** Not into Claude Code, not into
  the assistant transcript, not into a GitHub issue, not into Discord.
  If the agent asks for a secret value, the user gives it the env-var
  name, not the value.
- **On leak: revoke first, ask questions later.** If a secret enters
  chat or any other untrusted surface:
  1. Revoke at the relevant dashboard immediately.
  2. Reissue a new credential.
  3. Re-store under the same name in envpact.
  4. Trigger a redeploy of every consumer.
  5. Audit recent logs for unauthorised use of the leaked credential.
- **No card-on-file constraint.** Per the
  [no-card-on-file rule](../rules/no-card-on-file.md), credentials
  granting billing-attached access (e.g. a Cloudflare API token tied
  to a paid account) are out-of-scope by construction — the family
  has no such accounts.

## Exceptions

- **`PUBLIC_*` env vars.** Public Firebase config keys, public
  reCAPTCHA site keys, public AdSense pub IDs are not secrets and may
  be hardcoded into client bundles. They follow the `PUBLIC_` prefix
  convention so the distinction is visible at the call site.
- **`.env.example` files.** May contain placeholder values
  (`FIREBASE_SERVICE_ACCOUNT_KEY=replace-me`) but never real ones.

## Annual review

Not on the annual cycle — secret rotation is event-driven (on leak,
on credential expiry, on team change). The
[`auth-setup` runbook](../runbooks/auth-setup.md) carries the rotation
procedure.

## Cross-refs

- [`../runbooks/auth-setup.md`](../runbooks/auth-setup.md) — rotation runbook with every dashboard URL
- [`../rules/no-card-on-file.md`](../rules/no-card-on-file.md) — the upstream rule that limits the secret blast radius
- [`./ingester-contract.md`](./ingester-contract.md) — property (6) extends this rule into ingester code
