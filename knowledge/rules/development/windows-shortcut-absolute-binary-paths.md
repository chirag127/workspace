---
type: rule
title: "Windows shortcuts/wt-spawned shells: use absolute paths to .cmd/.exe binaries"
description: "Windows Terminal tabs launched via wt new-tab + a -Command string don't reliably inherit the User PATH. Always use the absolute path to npm.cmd / pnpm.cmd / python.exe etc. when constructing startup scripts."
tags: [windows, powershell, startup-scripts, path, gotcha]
timestamp: 2026-06-30
format_version: okf-v0.1
status: active
related:
  - decisions/agent-tooling/omniroute-dev-server-from-source-2026-06-30
  - decisions/agent-tooling/freellmapi-dev-server-from-source-2026-06-30
---

# Use absolute paths to binaries in Windows shortcuts and wt-spawned shells

## The rule

In any script that launches a child PowerShell via `wt new-tab ... powershell -Command "..."` or from `shell:startup`, hard-code the **absolute path** to every binary the inner command calls. Don't rely on PATH lookup for `pnpm`, `npm`, `python`, `git`, `pip`, `code`, etc.

### Right

```powershell
$pnpm = 'C:\Program Files\nodejs\pnpm.cmd'
$inner = "& '$pnpm' dev"
Start-Process wt -ArgumentList "new-tab ... powershell -Command `"$inner`""
```

### Wrong

```powershell
$inner = "pnpm dev"  # ← will fail with 'command not found' in the spawned tab
Start-Process wt -ArgumentList "new-tab ... powershell -Command `"$inner`""
```

## Why this fails

Symptom seen 2026-06-30 with OmniRoute startup:

> `[error 2147942402 (0x80070002) when launching `" pnpm dev"']`
> `The system cannot find the file specified.`

The spawned PowerShell tab inherits **Machine PATH** but NOT the **User PATH** that contains `C:\Program Files\nodejs` (or `AppData\Roaming\npm`, or the Python user-scripts dir). The exact subset of PATH that gets inherited depends on:

- Whether `wt` launched from a user-context (vs system-context) parent
- Whether the user's persistent User PATH update has propagated (the `[Environment]::SetEnvironmentVariable("PATH", ..., "User")` call only affects NEW shells launched after the broadcast, not in-flight wt children)
- Whether the shortcut's `WindowStyle Hidden` affects environment propagation (it does in some cases)

The same pattern bit us on:
- `pnpm dev` in the OmniRoute startup tab (2026-06-30)
- `gptme`, `sgpt`, `oterm`, `vibe` in tabs spawned before the User PATH update propagated (2026-06-30)
- `pwsh` in the initial Windows Terminal tab batch (pwsh isn't installed; `powershell.exe` works)

## How to write a script that doesn't break

1. **Resolve the binary path once** at script start:
   ```powershell
   $pnpm = (Get-Command pnpm).Source  # works at script-author time
   # OR hard-code from `where.exe pnpm` output:
   $pnpm = 'C:\Program Files\nodejs\pnpm.cmd'
   ```

2. **Quote with single-quotes** around the absolute path so PowerShell doesn't try to expand `$` inside the path:
   ```powershell
   $inner = "& '$pnpm' dev"
   ```

3. **Use `-EncodedCommand` instead of `-Command`** when launching via `wt new-tab ... pwsh ...`. The `-Command` arg goes through wt's tokenizer plus PowerShell's argument parsing — nested quotes + spaces in paths (`Program Files`) routinely break. `-EncodedCommand` accepts a base64-encoded UTF-16LE blob that wt passes verbatim. Escape-proof.

   ```powershell
   # The pattern that actually works:
   $bytes   = [System.Text.Encoding]::Unicode.GetBytes($inner)
   $encoded = [Convert]::ToBase64String($bytes)
   $wtArgs  = "new-tab --title `"X`" -d `"$dir`" `"$psPath`" -NoExit -EncodedCommand $encoded"
   Start-Process wt -ArgumentList $wtArgs
   ```

   Failure mode without `-EncodedCommand`:
   > `[error 2147942402 (0x80070002) when launching `" & 'C:\Program Files\nodejs\pnpm.cmd' dev"']`
   > `The system cannot find the file specified.`

   Windows interprets the entire quoted `& '...' dev` string as the binary name. Encoded-command bypasses the parser entirely.

4. **For binaries with no fixed install path** (user-scoped pip CLIs, npm globals), pre-resolve and check existence:
   ```powershell
   $tool = "$env:APPDATA\npm\my-tool.cmd"
   if (-not (Test-Path $tool)) { throw "Tool not installed at expected path" }
   ```

## When PATH-lookup DOES work

- Direct invocation in the running session (`pnpm dev` typed by you in this terminal)
- Scripts invoked by your interactive shell (not by `wt new-tab ... -Command "..."`)
- Background tasks spawned by Task Scheduler with the right user-context flag

For everything that goes through `wt`'s argument-string command spawning, use absolute paths.

## Anti-patterns to flag in code review

- `wt new-tab ... powershell -Command "<bareword-binary> ..."` → flag immediately, use full path
- `Start-Process -FilePath "<bareword-binary>"` from a script meant to run pre-login → flag
- Shortcut `.lnk` files where the Target is `cmd.exe` or `powershell.exe` and the Arguments call binaries by short name → flag

## See also

- [`globals-derived-from-workspace`](../agent/globals-derived-from-workspace.md) — related; covers the User PATH side
- [`junctions-on-windows`](../agent/junctions-on-windows.md) — sibling Windows gotcha rule
- Failure mode reproduced + fixed: [`decisions/agent-tooling/omniroute-dev-server-from-source-2026-06-30`](../../decisions/agent-tooling/omniroute-dev-server-from-source-2026-06-30.md) §"Path note for shell:startup"
