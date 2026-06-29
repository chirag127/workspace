---
type: decision
title: "AdSense apex application; Ezoic / Mediavine fallback"
description: 'Single AdSense for oriz.in apex. Fallback: Ezoic, Mediavine'
tags: [monetisation, adsense, ads, services]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - infrastructure/subdomains-under-oriz-in
  - monetisation/no-subscriptions-anywhere
---

# AdSense apex application; Ezoic / Mediavine fallback

## Decision

The family files ONE Google AdSense application for the `oriz.in`
apex domain. Per AdSense 2026 rules, all `*.oriz.in` subdomains
inherit the approval — no per-subdomain application option exists
or is needed. If AdSense rejects or terminates, the fallback order
is Ezoic ? Mediavine ? other reputable networks.

## Why

Splitting ad approval across subdomains is impossible (AdSense
doesn't support it in 2026), and concentrating one application at
the apex gives every site in the family monetisation simultaneously.
Ezoic and Mediavine accept smaller / younger sites than AdSense and
support per-subdomain monetisation — they're the realistic backup
when AdSense rejects.

## Implications

- AdSense application uses `oriz.in` apex as the property; all `*.oriz.in` subdomains automatically covered.
- NO ad slot divs in markup (per family rule) — AdSense / Ezoic / Mediavine inject ads at runtime when the script loads. Sites have organic content layout that ads fill around.
- One `<script>` snippet from the chosen ad network gets included via the shared chrome (header / footer) of `@chirag127/oriz-kit` — sites don't manage ad code individually.
- Subscription users (per [one-subscription-unlocks-all](./one-subscription-unlocks-all.md)) see ads suppressed via the entitlement check before the ad script loads.
- GitHub Pages mirrors (the fallback host) also allow AdSense for content/utility/portfolio sites — so the survival layer keeps monetisation if Cloudflare dies.
- Failed AdSense ? switch the script tag in the shared kit, no per-site changes needed.

## Cross-refs

- [Subdomains under oriz.in](../infrastructure/subdomains-under-oriz-in.md)
- [No subscriptions anywhere (our cost side)](./no-subscriptions-anywhere.md)
- [GitHub Pages mirror per site](../infrastructure/github-pages-mirror-per-site.md)
