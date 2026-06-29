---
type: runbook
title: 'Fix cavemem hooks failing with "Executable not found in $PATH: sh"'
description: Claude Code wraps every command hook in `sh -c`. On Windows without Git\bin in PATH, sh.exe isn't found and every hook silently fails. Add Git\bin to user PATH + verify.
tags: [cavemem, claude-code, hooks, windows, path, troubleshooting]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - services/infra/dev-tools/cavemem
---

# Fix cavemem hooks failing with "sh not found"

## Symptom

In Claude Code, at the end of any turn:
```
● Ran N stop hooks (ctrl+o to expand)
  ⎿  Stop hook error: Failed with non-blocking status code:
     Error occurred while executing hook command:
     Executable not found in $PATH: "sh"
```
Same error fires for `SessionStart`, `UserPromptSubmit`, `PostToolUse`, `SessionEnd` if you check the logs. Hooks are silently non-blocking, so nothing breaks — but cavemem records nothing, semantic search results stay stale, and you waste a subprocess spawn every event.

## Root cause

Claude Code wraps every `type: "command"` hook in `sh -c <command>` before executing. On Windows without `C:\Program Files\Git\bin` (or another POSIX shell directory) on PATH, `sh.exe` isn't resolvable from CC's process tree, the wrapper dies, and the inner command never runs.

The native Bash tool inside CC can still see `/usr/bin/sh` because Git Bash sets up its own internal PATH — but that doesn't help hooks, which CC spawns from its parent process whose PATH is the **user-environment** PATH from `[Environment]::GetEnvironmentVariable('Path','User')`.

This machine had `C:\Program Files\Git\cmd` (contains git.exe but no shells) on user PATH but NOT `C:\Program Files\Git\bin` (contains sh.exe, bash.exe, all POSIX shims).

## Fix

Add `C:\Program Files\Git\bin` to **user** PATH (not system — single-user change):

```powershell
powershell -NoProfile -Command "
  $current = [Environment]::GetEnvironmentVariable('Path','User')
  $add = 'C:\Program Files\Git\bin'
  if ($current -notlike \"*$add*\") {
    [Environment]::SetEnvironmentVariable('Path', $current + ';' + $add, 'User')
    Write-Output 'PATH updated'
  } else {
    Write-Output 'already there'
  }
"
```

Persistent across reboots. Restart Claude Code to inherit the new PATH (existing CC processes retain the old one).

## Verify

```powershell
where.exe sh      # should resolve to C:\Program Files\Git\usr\bin\sh.exe
```

Then in a fresh CC session, run any tool call and check `Stop hook` indicator returns `ok` not error.

In cavemem itself:
```bash
cavemem status   # observation count should grow turn-over-turn
cavemem search "anything" --limit 3   # should return scored results
```

## Related fix — semantic search dead

If `cavemem search` returns `semantic disabled: Local embedding provider requires @xenova/transformers`, the peer dep is missing. Install:

```bash
npm install -g @xenova/transformers
```

~80 packages, ~100MB. FTS search keeps working without it; only vector-similarity recall is gated.

## Anti-patterns

- ❌ Edit `~/.claude/settings.json` env.PATH instead — CC reads its own settings AFTER spawning the hook subprocess wrapper, so env block doesn't help here
- ❌ Add `C:\Program Files\Git\usr\bin` instead of `\bin` — both contain sh.exe but `\bin` is the documented entry-point + has the right Windows symlink shims
- ❌ Set system PATH instead of user PATH — needs admin, no benefit for single-user machine, harder to roll back
- ❌ Try to make CC NOT wrap hooks in `sh -c` — not a setting, hard-coded harness behavior

## Why this rule lives here

Documented after hitting the bug on 2026-06-29. cavemem memory search showed memories from a prior session that mentioned "cavemem's Claude Code hooks are still wired, so it auto-restarts on next session" — meaning we'd hit and silently lived with the same problem at least once before. Captured as runbook so we don't pay the discovery cost a third time.

## Cross-refs

- [`services/infra/dev-tools/cavemem`](../../../services/infra/dev-tools/cavemem.md) — what cavemem is and how it's wired
