---
type: rule
title: 'PowerShell scripts: ASCII only (no em-dash, smart quotes, etc.)'
description: PS 5.1 without UTF-8 BOM reads as Windows-1252. Em-dashes + smart quotes break parser. Use ASCII hyphens + straight quotes in .ps1
tags: [powershell, encoding, windows, automation, hard-rule]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - agent-rules/automate-never-runbook
---

# PowerShell: ASCII-only in shipped scripts

## Why

Windows PowerShell 5.1 (the default on stock Windows 10/11) reads `.ps1`
files without a UTF-8 BOM as Windows-1252. UTF-8 multibyte sequences for
em-dash (U+2014, bytes `E2 80 94`), en-dash (U+2013), and smart quotes
get decoded as garbage characters, which the parser then rejects with
cryptic errors like:

  Unexpected token 'ready=' in expression or statement.
  The Try statement is missing its Catch or Finally block.

Reported error lines are often dozens of lines AFTER the actual offending
character, making debugging painful.

This rule is HARD. PS 5.1 is what users run from `cmd.exe` on a stock
Windows box. Our scripts must run there.

## Rule

In every `.ps1` file we ship:

- Em-dash `—` ? ASCII hyphen `-` or double-hyphen `--`
- En-dash `–` ? ASCII hyphen `-`
- Smart quotes `''` `""` ? straight `'` `"`
- Bullets `•` ? ASCII `*` or `-`
- Arrows `?` ? ASCII `->`
- Non-breaking space `U+00A0` ? regular space

The only exception: comment-only Unicode that the parser doesn't tokenize
INSIDE strings (e.g. box-drawing chars in section banners) is fine
because PS treats them as comment content. But test before shipping.

## How to check before commit

```bash
# Find any non-ASCII bytes (excluding box-drawing for banners):
grep -rnP '[^\x00-\x7f]' scripts/*.ps1

# Parse-check every script:
for f in scripts/*.ps1; do
  powershell -NoProfile -Command "\$e = \$null; \$null = [System.Management.Automation.Language.Parser]::ParseFile('$f', [ref]\$null, [ref]\$e); if (\$e) { '\$f: FAIL' } else { '\$f: clean' }"
done
```

## Better: BOM the files

`Set-Content -Encoding utf8BOM` (PS 7) or `utf8` with BOM (PS 5.1 default)
makes PS read files correctly regardless of content. But our scripts often
get edited by `Edit` tool / human / linter, which can strip the BOM. So
the ASCII-only rule is the durable fix; BOM is a backup.

## Anti-patterns

- ? Writing prose-style em-dashes in a `.ps1` heredoc that becomes a `Write-Host`
- ? Copy-pasting Markdown bullets (`•`) into PS comments — they often survive
- ? Trusting a `.ps1` because it works in pwsh 7 — pwsh 7 is UTF-8 by default,
  PS 5.1 is not. Always parse-check in `powershell.exe`.

## Cross-refs

- `automate-never-runbook` — scripts ARE the deliverable. They must parse.
