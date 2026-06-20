---
type: service
title: "Chrome Web Store"
description: "Browser-extension distribution channel for Chrome / Edge / Brave / Opera / Vivaldi / Arc / Zen. $5 one-time developer fee (sunk cost — NOT a subscription, still meets free-forever rule). chrome-webstore-upload via GitHub Actions for CI auto-publish."
tags: [services, extension-store, chrome, distribution, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: ext-store-chrome
provider: google
free_tier: "Free unlimited extension submissions after a $5 one-time developer registration fee (sunk cost, no recurring charge); auto-publish via chrome-webstore-upload GitHub Action"
swap_cost: low
related:
  - services/extension-store/firefox-add-ons
  - services/extension-store/edge-add-ons
  - services/extension-store/index
  - decisions/architecture/distribution-and-queues-locked
  - decisions/branding/repo-naming-suffixes
  - decisions/infrastructure/extensions-cross-store-publish
  - rules/no-card-on-file
---

# Chrome Web Store

## Role

Primary distribution channel for every browser extension in the
`oriz-*-ext` family. Covers Chrome plus every Chromium browser that
trusts the Chrome Web Store as a source — Edge (via cross-browser
install), Brave, Opera, Vivaldi, Arc, Zen. The Edge variant is
also published natively to [Edge Add-ons](./edge-add-ons.md), but
the Chrome listing is what most Chromium users land on first. Per
[`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md),
every browser extension publishes to all three stores: Chrome,
Firefox, Edge.

## Free tier

- Unlimited submissions after the **$5 one-time** developer
  registration fee.
- Unlimited extensions per developer account.
- Unlimited published versions per extension.
- No recurring fees, no per-install fees, no review fees.

## Card / subscription required?

**NO** for ongoing usage. The $5 registration is a **one-time sunk
cost** — paid once at developer-account creation, never billed
again. This is **not** a subscription and **does not** create a
card-on-file relationship — the family's
[`rules/no-card-on-file.md`](../../rules/no-card-on-file.md) and
[`decisions/monetisation/no-subscriptions-anywhere.md`](../../decisions/monetisation/no-subscriptions-anywhere.md)
both still hold. (One-time fees for permanent capabilities are the
documented exception class — same shape as a domain registration.)

## CI auto-publish

Each extension repo's `.github/workflows/publish.yml` pushes the
packaged `.zip` to the Chrome Web Store via the
[`chrome-webstore-upload`](https://github.com/fregante/chrome-webstore-upload-keys)
flow:

```yaml
- name: Upload to Chrome Web Store
  uses: mnao305/chrome-extension-upload@v5
  with:
    file-path: dist/extension.zip
    extension-id: ${{ secrets.CHROME_EXTENSION_ID }}
    client-id: ${{ secrets.CHROME_CLIENT_ID }}
    client-secret: ${{ secrets.CHROME_CLIENT_SECRET }}
    refresh-token: ${{ secrets.CHROME_REFRESH_TOKEN }}
    publish: true
```

Credentials originate in [Doppler](../secrets/doppler.md) and
mirror to [GitHub Secrets](../secrets/github-secrets.md) per
[`decisions/security/secrets-management-doppler.md`](../../decisions/security/secrets-management-doppler.md).
The action wraps Google's `chromewebstore.googleapis.com` upload +
publish endpoints — same surface used by the
[`chrome-webstore-upload-cli`](https://github.com/fregante/chrome-webstore-upload-cli)
package on npm.

## Alternatives

- [Firefox Add-ons (AMO)](./firefox-add-ons.md) — sibling, free.
- [Microsoft Edge Add-ons](./edge-add-ons.md) — sibling, free.
- Side-loading via `.crx` from [GitHub Releases](../storage/github-releases.md)
  — supported as a secondary channel for advanced users; never the
  primary install path.

## Swap cost

Low — the publish workflow is per-store; dropping Chrome would only
remove the `chrome-extension-upload` step. Manifest authoring,
build, signing, and the artifact itself are unchanged.

## Why this is our pick

The Chrome Web Store is non-negotiable: the addressable Chromium
user base dwarfs every other store combined, and skipping it would
defeat any extension's reach. The one-time $5 fee is a sunk cost
the family already pays.

## Cross-refs

- [Three-store browser-extension distribution + dual VS Code marketplace + PWA + queue decision](../../decisions/architecture/distribution-and-queues-locked.md)
- [Earlier cross-store publish decision (Batch 1)](../../decisions/infrastructure/extensions-cross-store-publish.md)
- [Repo naming suffixes (`-ext`)](../../decisions/branding/repo-naming-suffixes.md)
- [Firefox Add-ons](./firefox-add-ons.md)
- [Microsoft Edge Add-ons](./edge-add-ons.md)
- [Extension-store bucket index](./index.md)
- [Per-extension privacy policy](../../decisions/content/per-extension-privacy-policy.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
