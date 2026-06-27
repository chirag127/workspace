---
type: runbook
title: "Sign up for ORIZ fleet analytics + observability services (5 services, ~25 min)"
description: "Step-by-step: create accounts on Google Analytics 4, Microsoft Clarity, PostHog, Sentry, Cloudflare Web Analytics. Copy IDs/DSN/tokens into workspace .env and oriz-org GitHub org-level secrets. Required before any oriz API site can deploy with analytics."
tags: [analytics, observability, signup, runbook, oriz-fleet]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/infrastructure/hosting-github-pages-with-analytics-everywhere-2026-06-28
  - rules/security/github-org-level-secrets
  - rules/development/env-example-mirrors-env-with-steps
---

# Sign up for ORIZ fleet analytics + observability

5 free services. No card on any of them. ~25 minutes end-to-end.

After signing up, paste each value into the matching env var in `c:/D/oriz/.env`, then mirror them into `oriz-org` GitHub org-level Actions secrets (build-time injection per the hosting decision).

---

## Env var name mapping

Long descriptive names per 2026-06-28 user preference. Keys in `.env`:

| Service | Env var |
|---|---|
| Google Analytics 4 | `ORIZ_FLEET_GOOGLE_ANALYTICS_MEASUREMENT_ID` |
| Microsoft Clarity | `ORIZ_FLEET_MICROSOFT_CLARITY_PROJECT_ID` |
| PostHog (key + host) | `ORIZ_FLEET_POSTHOG_PROJECT_API_KEY` + `ORIZ_FLEET_POSTHOG_API_HOST` |
| Sentry | `ORIZ_FLEET_SENTRY_DSN_BROWSER_SDK` |
| Cloudflare Web Analytics | `ORIZ_FLEET_CLOUDFLARE_WEB_ANALYTICS_TOKEN` |

---

## 1. Google Analytics 4 — `ORIZ_FLEET_GOOGLE_ANALYTICS_MEASUREMENT_ID`

1. Go to https://analytics.google.com — sign in with your existing Google account (the same one as `chirag.singhal2002@gmail.com` or whichever you use for oriz).
2. Click **Admin** (gear icon, bottom-left).
3. Under **Account** column → **Create** → **Account**. Name: `oriz-org`. Accept defaults (data sharing settings as you prefer).
4. Under **Property** column → **Create** → **Property**. Name: `oriz fleet APIs`. Time zone: `(GMT+05:30) India Standard Time`. Currency: `Indian Rupee (₹)`. Click **Next**.
5. **Business details** → category: `Technology`, size: `Small`. Click **Next**.
6. **Business objectives** → tick whatever fits (e.g. "Get baseline reports"). Click **Create**.
7. **Choose a platform** → **Web**. URL: `https://api.oriz.in` (or `https://oriz.in` — doesn't matter; you can add streams for each subdomain later). Stream name: `oriz fleet`. Click **Create stream**.
8. **Web stream details** appears. The big string at the top labelled **Measurement ID** is what you want. Format: `G-XXXXXXXXXX` (10 alphanumeric chars after `G-`).
9. Copy it. Paste into `.env`:
   ```
   ORIZ_FLEET_GOOGLE_ANALYTICS_MEASUREMENT_ID=G-XXXXXXXXXX
   ```

**Time**: ~5 min.

---

## 2. Microsoft Clarity — `ORIZ_FLEET_MICROSOFT_CLARITY_PROJECT_ID`

1. Go to https://clarity.microsoft.com — sign in with your Microsoft / GitHub / Google account.
2. **Add new project**. Name: `oriz fleet`. Website URL: `https://api.oriz.in`. Category: `Technology / Internet`. Click **Create**.
3. **Setup** tab → look for the install snippet. It looks like:
   ```html
   <script>
   (function(c,l,a,r,i,t,y){...})(window, document, "clarity", "script", "XXXXXXXXXX");
   </script>
   ```
4. The 10-char string in the last argument (e.g. `"abc123xyz9"`) is the project ID. Copy it.
5. Paste into `.env`:
   ```
   ORIZ_FLEET_MICROSOFT_CLARITY_PROJECT_ID=XXXXXXXXXX
   ```

**Time**: ~3 min.

---

## 3. PostHog — `ORIZ_FLEET_POSTHOG_PROJECT_API_KEY` + `ORIZ_FLEET_POSTHOG_API_HOST`

1. Go to https://posthog.com → **Get started — free**.
2. Sign up (email + password, or GitHub OAuth). Pick the **US Cloud** OR **EU Cloud** region. EU is privacy-friendlier; US has bigger free tier (1M events/month).
3. After login, you're in a default project. Settings → **Project** → **Project API Key**. Copy the `phc_...` string.
4. Note which host you picked:
   - US: `https://us.i.posthog.com`
   - EU: `https://eu.i.posthog.com`
5. Paste into `.env`:
   ```
   ORIZ_FLEET_POSTHOG_PROJECT_API_KEY=phc_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ORIZ_FLEET_POSTHOG_API_HOST=https://us.i.posthog.com
   ```

**Time**: ~5 min.

---

## 4. Sentry — `ORIZ_FLEET_SENTRY_DSN_BROWSER_SDK`

1. Go to https://sentry.io → **Get started — Sign up**.
2. Sign up (email or GitHub). On the welcome flow, **skip** the team-size question if you can, or pick the smallest.
3. **Select a platform** → **Browser JavaScript** (NOT a framework — just plain Browser JS). Click **Continue**.
4. Skip the install instructions; you just need the DSN.
5. **Project Settings** → **Client Keys (DSN)**. Copy the **DSN** field. Format: `https://abc123@o123456.ingest.us.sentry.io/1234567`.
6. Paste into `.env`:
   ```
   ORIZ_FLEET_SENTRY_DSN_BROWSER_SDK=https://abc123@o123456.ingest.us.sentry.io/1234567
   ```

**Time**: ~5 min.

---

## 5. Cloudflare Web Analytics — `ORIZ_FLEET_CLOUDFLARE_WEB_ANALYTICS_TOKEN`

1. Go to https://dash.cloudflare.com — sign in with your existing CF account (the one running `oriz.in` DNS).
2. Left sidebar → **Analytics & Logs** → **Web Analytics**.
3. **Add a site** → **Site URL**: `api.oriz.in`. Toggle **Automatic Setup** OFF (you want the manual JS snippet, not the orange-cloud auto-injection).
4. Click **Done**.
5. The dashboard shows a `<script>` tag like:
   ```html
   <script defer src='https://static.cloudflareinsights.com/beacon.min.js'
           data-cf-beacon='{"token": "abcdef1234567890..."}'></script>
   ```
6. Copy ONLY the value inside `"token": "..."`. Paste into `.env`:
   ```
   ORIZ_FLEET_CLOUDFLARE_WEB_ANALYTICS_TOKEN=abcdef1234567890abcdef1234567890
   ```

**Time**: ~3 min.

---

## After signup: mirror to GitHub org secrets

The local `.env` is for local builds. Production builds happen in GitHub Actions, which can't read your local `.env`. Mirror each value to org-level secrets so every repo under `oriz-org` can read them at build time.

```bash
# From any directory, gh CLI authed as you
gh secret set ORIZ_FLEET_GOOGLE_ANALYTICS_MEASUREMENT_ID --org oriz-org --visibility all --body "G-XXXXXXXXXX"
gh secret set ORIZ_FLEET_MICROSOFT_CLARITY_PROJECT_ID --org oriz-org --visibility all --body "XXXXXXXXXX"
gh secret set ORIZ_FLEET_POSTHOG_PROJECT_API_KEY --org oriz-org --visibility all --body "phc_..."
gh secret set ORIZ_FLEET_POSTHOG_API_HOST --org oriz-org --visibility all --body "https://us.i.posthog.com"
gh secret set ORIZ_FLEET_SENTRY_DSN_BROWSER_SDK --org oriz-org --visibility all --body "https://...@o....ingest.us.sentry.io/..."
gh secret set ORIZ_FLEET_CLOUDFLARE_WEB_ANALYTICS_TOKEN --org oriz-org --visibility all --body "abc..."
```

I can run those for you once your `.env` is filled. Just say "mirror env to org secrets".

---

## Verification

After all 5 are in `.env`:

```bash
cd c:/D/oriz
grep '^ORIZ_FLEET_' .env | wc -l   # should print 6 (5 services, PostHog has 2)
```

After org secrets are mirrored:

```bash
gh secret list --org oriz-org | grep ORIZ_FLEET_   # should list 6 entries
```

---

## What gets done next

Once all 6 env vars are populated AND mirrored to org secrets, I'll:

1. Pilot `rto-api` migration: GitHub Actions workflow that builds with analytics injected → deploys to GitHub Pages → DNS flip from CF Pages to `oriz-org.github.io`. Verify live.
2. Parallel sub-agents for the other 4 APIs (constants/ragas/dynasties/countries-plus).
3. Rebuild `api-fleet-landing` on GitHub Pages.
4. Delete the 5 (and the failed landing-page) Cloudflare Pages projects.
