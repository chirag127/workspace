---
type: rule
title: 'PowerShell: native commands writing to stderr trip strict mode'
description: Cargo, winget, npm, gcc all print progress + info to stderr. PS 5.1 with $ErrorActionPreference=Stop wraps any stderr line in RemoteException and aborts. Always pipe through `cmd /c "... 2>&1"` and locally relax EAP.
tags: [powershell, stderr, automation, hard-rule]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/powershell-ascii-only
  - rules/agent/automate-never-runbook
---

# PowerShell: native commands + stderr = silent abort

## Why this rule exists

`cargo install --git ...` prints `Updating git repository ...` to STDERR
as progress info, not an error. PowerShell with `$ErrorActionPreference = 'Stop'`
treats every stderr line as a `RemoteException` and aborts the script.
Same problem with `winget`, `npm install`, `gcc`, `apt`, `pip`.

Observed 2026-06-27 in install-speed-stack.ps1 line 61:
  `cargo.exe :     Updating git repository `https://github.com/rtk-ai/rtk``
  → `NativeCommandError` → script died mid-RTK-build despite the build
    actually succeeding (it had compiled to 100%).

## Rule

When invoking ANY native command that prints progress or info to stderr:

1. Pipe through `cmd /c "<cmd> 2>&1"` to merge streams BEFORE PS sees them.
2. Locally set `$ErrorActionPreference = 'Continue'` around the call:

```powershell
$prev = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
  & cmd /c "cargo install --locked rtk 2>&1" | Out-Host
  $rc = $LASTEXITCODE
} finally {
  $ErrorActionPreference = $prev
}
if ($rc -ne 0) { throw "...real failure..." }
```

Or use the `Invoke-Native` helper in `install-agents.ps1` that wraps this.

## Anti-patterns

- ❌ `& cargo install ... 2>&1 | Out-Host` — the `2>&1` redirect happens
  AFTER PS has already wrapped the stderr in RemoteException. Doesn't work.
- ❌ Setting `$ErrorActionPreference = 'Continue'` globally — masks real
  PS errors elsewhere. Always local + try/finally.
- ❌ `cargo install ... | Out-Null` — same trap, silent failure.

## When the stderr is actually an error

Check `$LASTEXITCODE` after the call. That's the only reliable signal for
native commands; stream content is not.

## Cross-refs

- `powershell-ascii-only` — companion rule for the OTHER PS-on-Windows
  gotcha (em-dashes + Windows-1252 codepage)
- `automate-never-runbook` — scripts must run end-to-end without manual
  intervention; one silent stderr-trap = whole automation broken
