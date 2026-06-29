---
type: decision
title: "Personal notes in public repo — discipline-only"
description: Obsidian vault in public repo, discipline not tooling
tags: [decision, security, pkm, obsidian, public-repo, discipline]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/development/obsidian-vault-plugins-minimal
  - rules/agent/kepano-obsidian-skills-global
---

# Personal notes in public repo — discipline-only

## Decision

The Obsidian vault for personal PKM lives inside the public `oriz` monorepo, alongside code. There is no private mirror, no `.gitignore` wall around `vault/`, no encryption layer. Confidentiality is enforced by the author choosing what to commit — secrets, credentials, and personal-private content never get typed in the first place.

## Why

User locked this on 2026-06-27 (Q5). A separate private repo doubles the clone/sync surface and breaks the single-clone fleet promise. A `.gitignore` wall creates a private-by-accident pattern that drifts. Discipline at write-time is the only durable boundary.

## How to apply

- Treat every keystroke in `vault/` as if it will be public within the hour. If it can't be, don't type it.
- Credentials, tokens, API keys, and personal-private content (medical, financial, relationship) go to a separate non-git store — never the vault.
- No `.gitignore` patterns inside `vault/` to "hide" subfolders — public means public.
- When a sibling agent reads vault files, treat them as public content; do not redact in agent output.
- If a secret leaks in, treat as a credential rotation incident, not a "remove from git history" patch — assume already-public.

## Captured

2026-06-27 session, Q5 of the rules-lock grill round.

## Related

- [`obsidian-vault-plugins-minimal`](../../../rules/development/obsidian-vault-plugins-minimal.md)
- [`kepano-obsidian-skills-global`](../../../rules/agent/kepano-obsidian-skills-global.md)
