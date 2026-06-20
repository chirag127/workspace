---
type: service
title: "Microsoft Edge Add-ons"
description: "Microsoft's add-on store via Partner Center. Free unlimited, no developer fee, no card. CI flow uses the Edge Add-ons partner-center API."
tags: [services, extension-store, edge, microsoft, distribution, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: ext-store-edge
provider: microsoft
free_tier: "Free unlimited submissions and published versions, no developer fee for the Edge Add-ons program, no card"
swap_cost: low
related:
  - services/extension-store/chrome-web-store
  - services/extension-store/firefox-add-ons
  - services/extension-store/index
  - decisions/architecture/distribution-and-queues-locked
  - decisions/branding/repo-naming-suffixes
  - decisions/infrastructure/extensions-cross-store-publish
  - rules/no-card-on-file
---

# Microsoft Edge Add-ons

## Role

Distribution channel for every `oriz-*-ext` extension on Microsoft
Edge — separate listing from the Chrome Web Store even though Edge
will side-install extensions sourced from CWS. The native Edge
listing is what shows up in Edge's in-browser add-ons surface and
what Microsoft promotes to its user base.

## Free tier

- Unlimited submissions and unlimited published versions.
- **No developer-registration fee** for the Edge Add-ons program
  specifically (distinct from the Microsoft Store / Windows Store
  $19 individual / $99 company fee — those apply to packaged
  Win32/UWP apps, not browser extensions).
- No review fee, no per-install fee.

## Card / subscription required?

**NO.** Microsoft Partner Center for Edge Add-ons requires only a
Microsoft account; no payment method on file at any stage.

## CI auto-publish

The same `.zip` produced by `web-ext` for [AMO](./firefox-add-ons.md)
is submitted to the Edge Add-ons partner-center API from GitHub
Actions:

```yaml
- name: Submit to Edge Add-ons
  uses: wdzeng/edge-addon@v2
  with:
    product-id: ${{ secrets.EDGE_PRODUCT_ID }}
    zip-path: dist/extension.zip
    client-id: ${{ secrets.EDGE_CLIENT_ID }}
    api-key: ${{ secrets.EDGE_API_KEY }}
```

The action wraps Microsoft's
[Edge Add-ons API](https://learn.microsoft.com/microsoft-edge/extensions-chromium/publish/api/using-addons-api).
Credentials in [Doppler](../secrets/doppler.md) →
[GitHub Secrets](../secrets/github-secrets.md).

## Alternatives

- [Chrome Web Store](./chrome-web-store.md) — sibling, covers Edge
  via cross-browser install. This native Edge listing is
  complementary, not redundant.
- [Firefox Add-ons (AMO)](./firefox-add-ons.md) — sibling, free.

## Swap cost

Low — the action is per-store. Dropping the Edge step removes one
job; the artifact and manifest stay untouched.

## Why this is our pick

Edge ships pre-installed on every modern Windows machine. Even
though most users will install our extensions via the Chrome Web
Store on Edge, a native Edge Add-ons listing is what surfaces in
Edge's promoted-extensions UI, in Microsoft's editorial picks, and
in Bing search. Free + no card means the cost is purely the CI
step.

## Cross-refs

- [Browser-extension three-store + VS Code dual + PWA + queue decision](../../decisions/architecture/distribution-and-queues-locked.md)
- [Earlier cross-store publish decision (Batch 1)](../../decisions/infrastructure/extensions-cross-store-publish.md)
- [Repo naming suffixes (`-ext`)](../../decisions/branding/repo-naming-suffixes.md)
- [Chrome Web Store](./chrome-web-store.md)
- [Firefox Add-ons](./firefox-add-ons.md)
- [Extension-store bucket index](./index.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
