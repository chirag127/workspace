---
type: glossary
title: "auth domain"
description: auth.oriz.in: custom domain, one Firebase project serves all *.oriz.in sites
tags: [glossary, firebase, auth, domain]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# auth domain

## Definition

The auth domain is `auth.oriz.in` — the Firebase custom auth domain
configured on the single `oriz-app` project, which lets every
`*.oriz.in` subdomain (and every Chrome extension) share one Firebase
user across the family.

## Expanded

Without a custom auth domain, OAuth redirects bounce through the
default `oriz-app.firebaseapp.com`, which fragments cookies and
pop-ups across sites. With `auth.oriz.in`, every site sees the same
session, and Chrome extensions use
`chrome.identity.launchWebAuthFlow()` to bounce through this domain
and store the resulting ID token in `chrome.storage.local`.

This is the single piece of Firebase config that makes "one
subscription unlocks everything" architecturally feasible.

## See also

- [firestore-spark](../d-h/firestore-spark.md)
- [oriz](../o-r/oriz.md)
