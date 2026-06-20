---
type: index
title: "Ad network services"
description: "Ad networks. Both fallback — primary is AdSense at apex domain (see decisions)."
tags: [services, ads, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Ad network services

Primary is Google AdSense applied for at the `oriz.in` apex (see [decisions/adsense-apex-application.md](../../decisions/adsense-apex-application.md)) — there's no AdSense file in services/ because AdSense is the apex case, not a swappable per-site decision. These two are fallback choices if AdSense doesn't approve or stops paying.

| Service | Status | One-line role |
|---|---|---|
| [ezoic.md](./ezoic.md) | fallback | Ad-management network for low-traffic sites |
| [mediavine.md](./mediavine.md) | fallback | Higher-traffic ad network (50K sessions/mo entry) |

## Cross-refs

- [decisions/adsense-apex-application](../../decisions/adsense-apex-application.md)
- [rules/no-ad-slots-in-markup](../../rules/no-ad-slots-in-markup.md)
