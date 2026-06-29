---
type: policy
title: "Monetisation channel matrix — per-channel revenue + ethics rules"
description: 'Canonical matrix: monetisation per publish channel'
tags: [policy, monetisation, channel-matrix, affiliate, ethics, public-health]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/revenue-channels-2026
  - decisions/architecture/blog-cross-post-strategy
  - decisions/architecture/janaushdhi-app-scope
  - decisions/architecture/newsletter-substack
  - monetisation/no-subscriptions-anywhere
---

# Monetisation channel matrix

Single source of truth for what monetisation is allowed where. If a channel-app pairing is missing here, the conservative default is **free + opt-in sponsor footer, no ads, no affiliate**.

## Per-channel matrix

| Channel | Affiliate links | Sponsor links | Native platform revenue | Notes |
|---|---|---|---|---|
| **dev.to** | YES (post-end + inline CTAs to oriz packages) | YES (post-end sponsor block) | YES (native tips, dev.to listings) | Long-form technical |
| **Hashnode** | YES (book affiliate end of long-form, service CTAs inline) | YES | YES (native programs + newsletter capture) | Long-form technical |
| **Medium** | YES (book affiliate at long-form end) | YES (service CTAs inline) | YES (Medium Partner Program) | Manual via GH Issues drafts |
| **Bluesky** | NO | Bio-only support links | None | Organic-only; no commerce in posts; no tracking |
| **Mastodon** | NO | Bio-only support links | None | Organic-only; same rules as Bluesky |
| **Threads** | NO | Bio-only support links | None | Organic-only |
| **X (Twitter)** | NO auto (paid API) | Bio-only | None | Manual post via GH Issues drafts |
| **Reddit** | NO (subreddit rules forbid affiliate) | NO (subreddit rules) | None | Manual post via GH Issues drafts; follow subreddit rules |
| **LinkedIn** | NO | Bio-only | None | Weekly digest only, professional tone, manual via GH Issues drafts |
| **Substack newsletter** | YES (sparingly, in long-form digests) | YES | YES (free tier; 10% if paid tier ever) | Single newsletter for the family |

## Per-app matrix (where it differs from defaults)

| App | Ads | Affiliate | Sponsor | Notes |
|---|---|---|---|---|
| **janaushdhi-app** | NO | NO | Footer only | Public-health ethics; no exceptions |
| **vitals-health tool** | NO | NO | Footer only | Health-adjacent — same ethics |
| **ncert-app** | NO | NO | Footer only | Education resource for students |
| **scribe-text tool** | NO | YES (Amazon book affiliate OK on writing tool) | Footer | Affiliate ethically clean here |
| **paisa-finance tool** | NO | YES (where disclosed; bank/card affiliate networks) | Footer | Disclosure mandatory |
| **All other apps** | NO | YES (case-by-case, must be disclosed) | Footer | Anonymous-first auth (per family default); free + opt-in sponsor |

## Hard rules

- **No ads on health/data sites.** janaushdhi + vitals-health + ncert never run AdSense/Ezoic/Mediavine.
- **No affiliate where subreddit rules / platform TOS forbid.** Reddit and the organic-only social channels (Bluesky, Mastodon, Threads) are organic-only.
- **Anonymous-first auth** is the family default — no monetisation may gate functionality behind sign-in unless the user opts in.
- **No card-on-file required for any monetised feature on the user side** (orthogonal to merchant card — that's [[monetisation/max-payment-methods]]).
- **Disclosure mandatory** on every affiliate link (FTC + Indian ASCI requirements).

## Newsletter — single, Substack

One newsletter at `chirag127.substack.com` (or brand-aligned name). Free tier (Substack takes 10% on any future paid tier — accepted vs the marginal cost of running our own ESM stack). Daily blog feed + weekly digest + book drop announcements. One newsletter for the whole family, NOT per-app. Embed signup form on home-app + every content app footer. See [[decisions/stack/newsletter-substack]].

## Cross-refs

- Full channel API status 2026 ? [[monetisation/revenue-channels-2026]]
- Drafts queue (manual channels) ? [[decisions/compute/drafts-queue-host]]
- No-subscriptions rule ? [[monetisation/no-subscriptions-anywhere]]
