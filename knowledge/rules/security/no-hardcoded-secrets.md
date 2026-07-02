---
type: rule
title: "No hardcoded secrets \u2014 everything via envpact"
description: "No hardcoded secrets, envpact provides at runtime"
tags:
- rules
- secrets
- security
- envpact
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
- services/business/tooling/envpact
- runbooks/security/auth-setup
---



# No hardcoded secrets — everything via envpact

No secret value (API key, service-account JSON, signing key, OAuth
client secret, webhook secret, DB token, etc.) is ever hardcoded in
source — not in `.env`, not in TypeScript constants, not in JSON
fixtures, not in README examples.

All secrets come from [envpact](https://github.com/chirag127/envpact-secrets):

```bash
npx envpact-cli@latest   # pulls vault → .env for the current project
```

CI uses `chirag127/envpact-action@v0` with the `ENVPACT_VAULT_TOKEN`
secret.

## Why

Hardcoded secrets in public repos get scraped by bots within minutes
and used. The bill-shock examples on
[`no-card-on-file.md`](../interaction/no-card-on-file.md) include the €54K Gemini
API key leak — that's the model.

Even in private repos, hardcoded secrets compromise the principle of
least surprise: any future contributor (or future agent) reading the
file might leak it on accident.

envpact gives one source of truth, scoped per project, rotatable
without a code change.

## Server vs client secrets

- `FIREBASE_SERVICE_ACCOUNT_KEY` is **server-only** — never bundle
  into a client build, never expose via `import.meta.env.PUBLIC_*`.
- `PUBLIC_FIREBASE_*` keys (apiKey, authDomain, projectId, etc.) are
  safe in the client by Firebase design — they identify, they don't
  authorize. Still pulled via envpact for consistency.
- Worker secrets in Cloudflare Secrets Store (per
  [`apps/api`](../../decisions/compute/api-umbrella-hono-worker.md)) — the
  Worker reads from the binding at runtime; envpact populates the
  binding at deploy time.

## If a secret is ever pasted into chat

Treat it as compromised. Chats may be used for model training. The runbook:

1. Revoke + rotate at the relevant dashboard.
2. Re-store in envpact.
3. Update any consumer.
4. Full procedure at [`../runbooks/security/auth-setup.md`](../../runbooks/security/auth-setup.md).

## Debug via screenshot, not paste

When a bug involves an error message or state you can show instead of describe: SCREENSHOT + drop the image into chat. Do NOT paste log output that may contain tokens, session cookies, or credentials.

## Pre-publish security check

Before making anything public (git push to public repo, deploy, publish npm package, list extension on store):

1. Run the security-review skill or manual review.
2. ALSO ask "is there anything else I should be aware of before making this live?" — surfaces non-security issues (browser compat, mobile touch, missing edge cases).

Both are cheap. Skipping is what generates the "leaked-secret" horror stories.

## .env.local + .gitignore verification

For any project that uses secrets at build/dev time:

- Secrets live in `.env.local` (or environment-specific equivalent).
- `.env.local` MUST appear in `.gitignore`.
- Verify with: `git check-ignore .env.local` → should return the path (means ignored). If empty output, ignore is broken.
- `.env.enc` (sops-encrypted) MAY be committed. Never plaintext.

## Exceptions

None.

## See also

- AGENTS.md "Secrets" section
- [`../services/business/tooling/envpact.md`](../../services/business/tooling/envpact.md)
- [`../runbooks/security/auth-setup.md`](../../runbooks/security/auth-setup.md)
- Source of debug-screenshot + pre-publish-check additions: Nate Herk Claude Code walkthrough 2026-07
