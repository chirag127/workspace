---
type: rule
title: "Read the file, not just the grep, before claiming a gap"
description: Claims about external project gap must be backed by Read of source file — not grep alone
tags: [external-issues, verification, anti-hallucination]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/always-search-twice-before-deciding.md
  - rules/agent/preferences/edit-mode-prefs.md
---

## The rule

Before claiming "project X has/doesn't have feature Y" in an externally-published artefact (GitHub issue, PR description, comment on a maintainer's tracker), every assertion must be backed by a **Read of the actual source file** — not by a `grep` alone.

`grep` shows you what matches a pattern. It doesn't show you what's *equivalent under a different name*, what's in a sibling directory you didn't list, what's been refactored into an abstraction, what's gated behind a feature flag. A negative `grep` result is necessary but not sufficient evidence that a thing doesn't exist.

## Why this rule exists

2026-06-29: filed 3 OmniRoute issues claiming functional gaps. After publishing, deeper reads found:

- "**No DB driver abstraction**" — wrong. `src/lib/db/adapters/{betterSqliteAdapter,nodeSqliteAdapter,sqljsAdapter,driverFactory,types}.ts` already define a 3-driver `SqliteAdapter` interface. I'd grepped only `src/lib/db/*.ts` (top-level), missed the `adapters/` subdir.
- "**No bulk import endpoint**" — wrong. `src/app/api/providers/{bulk,bulk-web-session,*-auth/import-bulk}/route.ts` exist. I'd grepped `src/app/api/keys/` only.
- "**No tombstones / capability-override layer**" — wrong. `ModelCompatOverrides` with `isHidden`/`isDeleted` + `mergeModelCompatOverride()` actively used at `src/app/api/provider-models/route.ts:423`. I'd grepped for freellmapi's specific table names (`deleted_seed_models`, `capability_overrides`) instead of the functional shape.

Two of the three issues needed terse revisions ("here's what I missed, here's the narrowed real gap"); one closed entirely.

Public retraction is cheap. Public hallucination poisons the well — the next time you file an issue, maintainer reads "this user claims X" with skepticism. The cost of one ungrounded claim is paid across every future interaction.

## Protocol

When the deliverable is an external issue / PR / comment claiming a project's behaviour:

1. **Find candidates** — `grep` for the obvious keywords. Don't trust an empty result yet.
2. **Read the referenced files** — open the actual `route.ts` / `service.ts` / `*.ts` your claim is about. Read the imports. Read what's exported. Read what's used.
3. **Cross-check by behaviour, not name** — if you're claiming "no X", search for what X *would do* (functional shape) not what X *is called* (specific identifier). Different projects name the same thing differently.
4. **List sibling dirs** — `ls <parent-of-grepped-dir>` to catch the `adapters/` you'd miss.
5. **Cite file:line in the public artefact** — anchors every claim to verifiable evidence. If you can't cite, you didn't verify.

If a Read disproves the grep-result claim, revise / retract the artefact in the same turn that the contradiction surfaces. Do not let a wrong claim live publicly while you "decide what to do".

## Exceptions

- **Internal-only** artefacts (chat, internal docs, this knowledge tree): grep alone is fine. Audience is single-user, retraction is cheap.
- **Quick lookups** (e.g. "where is function Foo defined?"): grep + read the one matching file is sufficient.
- **Time-critical** outage response: hallucination cost is lower than delay cost. Still cite what you found.

## Cross-refs

- [`always-search-twice-before-deciding`](./preferences/always-search-twice-before-deciding.md) — same shape, applied to recommendation-making (not issue-filing).
- [`grep-is-not-enough-for-external-claims`](#) (this file, alternate slug if linked) — anti-pattern this rule codifies.
