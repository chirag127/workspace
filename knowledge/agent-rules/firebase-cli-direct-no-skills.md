---
type: rule
title: 'Firebase: use the CLI directly, never install Firebase skills'
description: Firebase CLI + agent context enough. No skill wrappers. Saves context, kills doc rot
tags: [firebase, skills, scope, hard-rule]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - agent-rules/workspace-scoped-agents
---

# Firebase: CLI direct, no skill wrappers

## Rule

NEVER install Firebase-themed skills (e.g. `firebase-firestore`,
`firebase-auth-basics`, `firebase-hosting-basics`, `firebase-crashlytics`,
`firebase-app-hosting-basics`, `firebase-data-connect`, `firebase-basics`,
`firebase-ai-logic-basics`, `firebase-remote-config-basics`,
`firebase-security-rules-auditor`).

The agent has:
- `firebase` CLI on PATH (or installs it on demand: `npm i -g firebase-tools`)
- Direct knowledge of Firestore security rules, Auth, Hosting, Crashlytics,
  Data Connect, Remote Config, App Hosting, AI Logic, Storage
- The `firebase-security-rules-auditor` job is already covered by
  `chirag127/security-review` skill (general audit, includes Firestore rules)

A skill wrapper for any of these adds nothing the CLI doesn't already give,
costs context every session, and inevitably rots when the underlying CLI
updates.

## What to do instead

Direct CLI invocations:
```bash
firebase login
firebase init firestore
firebase deploy --only firestore:rules
firebase firestore:indexes
firebase auth:export users.json
```

Audit Firestore rules: invoke `/security-review` (the general skill).

## Cross-refs

- `workspace-scoped-agents` — keep skill/agent surface minimal
- The CLAUDE.md inventory listed 10 fictional firebase-* skills that never
  existed as `chirag127/skill-firebase-*`. Documentation rot was caught
  2026-06-27 when an audit returned 36/36 not-found.
