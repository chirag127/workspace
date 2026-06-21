---
type: decision
title: "Family deploy architecture — DNS, gating, releases, dashboards"
description: "Per-app GH Actions workflow: main → prod, PR → preview subdomain, tags → APK + EXE. DNS auto-provisioned on first deploy. Single Sentry project tagged by site. Per-app sitemaps + apex sitemap-of-sitemaps. Allow-all robots.txt with /admin disallow. Single aggregate dashboard at home-app/admin. PostHog feature flags. Giscus comments with GH-native moderation. AdSense Auto Ads everywhere except me + home."
tags: [architecture, deploy, ci, dns, sentry, sitemap, robots, dashboard, posthog, comments, monetization]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
related: [decisions/branding/naming-policy-v5, decisions/architecture/multi-target-build, decisions/architecture/analytics-five-tier-stack, decisions/monetisation/adsense-apex-application]
---

# Family deploy architecture

## DNS auto-provisioning (Q33 lock)

Each `-app` repo's GH Actions workflow checks Cloudflare on first push:
if `<subdomain>.oriz.in` CNAME doesn't exist, the workflow creates it
pointing at `<repo>.pages.dev`. Uses `CLOUDFLARE_API_TOKEN` org secret.
Self-healing — missing DNS records get auto-provisioned.

```yaml
# .github/workflows/deploy.yml (per app)
- name: Ensure DNS record
  run: |
    curl -X POST "https://api.cloudflare.com/client/v4/zones/${{ secrets.CF_ZONE_ID }}/dns_records" \
      -H "Authorization: Bearer ${{ secrets.CLOUDFLARE_API_TOKEN }}" \
      -H "Content-Type: application/json" \
      -d '{"type":"CNAME","name":"${{ inputs.subdomain }}","content":"${{ inputs.repo }}.pages.dev","proxied":true}' \
      || echo "DNS record exists or create failed (idempotent)"
```

## Deploy gating (Q32 lock)

| Branch / event | Target | Subdomain |
|---|---|---|
| Push to `main` | Cloudflare Pages production | `<subdomain>.oriz.in` |
| PR opened | Cloudflare Pages preview | `<pr-num>.<subdomain>.oriz.in` |
| Tag `v*.*.*` | Production + APK + EXE | `<subdomain>.oriz.in` + GH release artifacts |

Tag protection via GitHub branch ruleset: only the org owner can push
tags matching `v*.*.*`.

## Family-wide package updates (Q34 lock)

When any npm package bumps version, workspace umbrella's cron runs
`pnpm update --recursive` and opens ONE PR per consumer submodule
(~24 PRs). Manual merge per app.

Trigger: weekly cron OR npm publish webhook.

## npm publish automation (Q35 lock)

Changesets-based:
1. PR includes `pnpm changeset` declaring version bumps + changelogs.
2. On main merge, `changesets/action` publishes any bumped packages to
   npm + creates GH releases.
3. Uses `NPM_TOKEN` org secret.

Family-wide one workflow at the workspace umbrella covers all 25
npm-pkg repos.

## Sentry single project (Q37 lock)

ONE Sentry project covers the entire family. All apps share
`PUBLIC_SENTRY_DSN`. Each error tagged by `site_name` from
`src/config/site.ts`. Free plan: 5K errors/month total across family.

Spike Protection ON to cap at 5K/mo.

## Sitemaps (Q38 lock)

- Each app emits its own `/sitemap.xml` via `@astrojs/sitemap`.
- The apex (`home-app`) emits `/sitemap-of-sitemaps.xml` listing every
  subdomain's sitemap.
- Submit only the apex sitemap-of-sitemaps to Google Search Console +
  Bing Webmaster.

## Robots.txt (Q39 lock)

Per-app `/robots.txt`:

```
User-agent: *
Allow: /
Disallow: /admin
Disallow: /api
Disallow: /signin
Disallow: /preview

Sitemap: https://<subdomain>.oriz.in/sitemap.xml
```

Apex robots.txt additionally references `/sitemap-of-sitemaps.xml`.

## Image CDN (Q40 reaffirm)

Per existing `decisions/architecture/image-cdn-fallback-chain.md`:
Cloudflare Images → wsrv.nl → ImageKit fallback. astro-chrome's
`<Image>` wraps this. App icons + screenshots committed to repo are
served as-is from CF Pages (no CDN chain needed for repo assets).

## Push notifications (Q41 lock)

Per `decisions/architecture/notifications-fcm-plus-knock.md`:
Knock orchestrates, FCM transports web push. Each app has its own
Firebase Messaging registration. Per-app trigger via Knock workflow.

## AdSense placement (Q42 lock)

AdSense Auto Ads enabled on every app EXCEPT `me-app` + `home-app`.
Google decides placement at runtime; no ad-slot divs in markup per
`rules/no-ad-slots-in-markup.md`. Banner ads above the fold disabled.

## A/B testing (Q43 lock)

PostHog feature flags + experiments. Variants in code via
`useFeatureFlag('experiment-name')`. PostHog dashboard for results.
Free tier covers solo dev usage.

## Comment moderation (Q44 lock)

Giscus backed by GitHub Discussions on chirag127/<repo>. Spam filter =
GitHub's. Moderation = `gh discussion close` or block user. No third-
party spam service.

## Analytics dashboard (Q45 lock)

Single aggregate dashboard at `home-app/admin` (auth-gated, only the
owner can view). Reads from all 5 analytics tools' APIs + shows
per-app and family-wide cards. Built once in astro-chrome, available
on every app's `/admin` route as a small embedded widget.

## Cross-refs

- [decisions/architecture/multi-target-build](./multi-target-build.md)
- [decisions/branding/naming-policy-v5](../branding/naming-policy-v5.md)
- [decisions/architecture/analytics-five-tier-stack](./analytics-five-tier-stack.md)
- [decisions/monetisation/adsense-apex-application](../monetisation/adsense-apex-application.md)
- [decisions/architecture/notifications-fcm-plus-knock](./notifications-fcm-plus-knock.md)
- [rules/keep-knowledge-fresh](../../rules/keep-knowledge-fresh.md)
