---
type: service
title: "Firefox Add-ons (AMO)"
description: "Mozilla add-on store — free unlimited submissions, no reg fee, CI via web-ext + AMO"
tags: [services, extension-store, firefox, mozilla, distribution, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: ext-store-firefox
provider: mozilla
free_tier: "Free unlimited submissions, free unlimited published versions, no developer fee, no card"
swap_cost: low
related:
  - services/business/extension-store/chrome-web-store
  - services/business/extension-store/edge-add-ons
  - services/business/extension-store/index
  - decisions/architecture/distribution-and-queues-locked
  - branding/repo-naming-suffixes
  - infrastructure/extensions-cross-store-publish
  - rules/no-card-on-file
---

# Firefox Add-ons (AMO)

## Role

Distribution channel for every browser extension in the
`oriz-*-ext` family on Firefox + Firefox-derivatives (LibreWolf,
Waterfox, Tor Browser via the Tor Project's curated subset).
Every extension publishes here on the same release as
[Chrome](./chrome-web-store.md) and [Edge](./edge-add-ons.md) per
[`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md).

## Free tier

- Unlimited submissions, unlimited extensions per developer.
- No developer-registration fee.
- No review fee, no per-install fee, no recurring charge.
- AMO signs the `.xpi` automatically once review passes; signed
  versions can also be self-distributed off-store.

## Card / subscription required?

**NO.** AMO requires only an email-verified Mozilla account. No
payment method on file at any stage.

## CI auto-publish

The packaged `.zip` is converted to `.xpi`, signed, and submitted
via Mozilla's
[`web-ext`](https://github.com/mozilla/web-ext) CLI from inside
GitHub Actions:

```yaml
- name: Build + submit to AMO
  run: |
    pnpm exec web-ext build --source-dir=dist
    pnpm exec web-ext sign \
      --api-key="$AMO_JWT_ISSUER" \
      --api-secret="$AMO_JWT_SECRET" \
      --channel=listed
  env:
    AMO_JWT_ISSUER: ${{ secrets.AMO_JWT_ISSUER }}
    AMO_JWT_SECRET: ${{ secrets.AMO_JWT_SECRET }}
```

`web-ext` doubles as the cross-browser packaging tool — the same
build is also used for the [Edge submission](./edge-add-ons.md).
Credentials in [Doppler](../secrets/doppler.md) →
[GitHub Secrets](../secrets/github-secrets.md).

## Alternatives

- [Chrome Web Store](./chrome-web-store.md) — sibling, $5 one-time.
- [Microsoft Edge Add-ons](./edge-add-ons.md) — sibling, free.
- Self-distributed signed `.xpi` via [GitHub Releases](../storage/github-releases.md)
  — secondary channel for users who prefer side-loading.

## Swap cost

Low — `web-ext`'s output is a standard `.xpi`. Switching off AMO
would only drop the sign step; everything else (manifest, build)
stays.

## Why this is our pick

Firefox's user base is small relative to Chromium but its users
skew toward power-users who install extensions. Skipping AMO means
losing the most engaged third of any extension's potential
audience. Free + no card means there's no friction to adding it.

## Cross-refs

- [Browser-extension three-store + VS Code dual + PWA + queue decision](../../decisions/architecture/distribution-and-queues-locked.md)
- [Earlier cross-store publish decision (Batch 1)](../../infrastructure/extensions-cross-store-publish.md)
- [Repo naming suffixes (`-ext`)](../../branding/repo-naming-suffixes.md)
- [Chrome Web Store](./chrome-web-store.md)
- [Microsoft Edge Add-ons](./edge-add-ons.md)
- [Extension-store bucket index](./index.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
