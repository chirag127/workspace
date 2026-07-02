---
type: rule
title: 'No dual-remote backup. GitHub IS the backup.'
description: Never add second remote to forks. chirag127 fork on GitHub = backup. Stop re-asking
tags: [git, backup, fleet, hard-rule, never-reask]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/dont-create-bak-folders
  - decisions/ops/backup-restic-b2-plus-windows-builtin
---

# No dual-remote backup

## Rule

Forks have ONE remote: `origin -> chirag127/<repo>` + `upstream -> <author>/<repo>` (for upstream syncing only).

NEVER propose:
- Adding `chirag127` as a second `origin`
- Adding a `backup` remote pointing at a mirror
- `git remote set-url --add --push origin <second-url>` dual-push setups
- A mirror repo under any account

## Why this rule exists

User explicitly rejected dual-remote backup on 2026-06-27 after I asked about
it twice in the same session. Decision logic: GitHub itself is the backup.
Two copies on the same provider survive together or die together (provider
outage, account ban). Real backup = different provider (restic to Backblaze
B2 — already locked in `decisions/ops/backup-restic-b2-plus-windows-builtin`).

## Anti-patterns

- multi-choice question prompt option that says "add chirag127 as second remote"
- multi-choice question prompt option that says "dual-push"
- Any "do you want to add a backup remote" question
- Any rationale about "two copies of the same data on GitHub for resilience"

## When this rule does NOT apply

- The user explicitly asks for a dual remote — then ask once with a "your previous decision was no, are you reversing it?" confirmation MCQ
- A different provider (GitLab, Codeberg, B2) — that's not GitHub-dual, that's cross-provider backup, which IS valid and IS covered by the restic rule

## Cross-refs

- `dont-create-bak-folders` — same principle, different surface
- `backup-restic-b2-plus-windows-builtin` — what real backup looks like
