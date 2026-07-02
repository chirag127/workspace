---
type: runbook
title: "Start screenpipe dev GUI on corp VDI"
description: "Run the full screenpipe desktop GUI in dev mode (free, no build needed) on Windows 11 corp VDI using the chirag127/screenpipe fork."
tags: [screenpipe, gui, dev, windows, fork]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
---

# Start screenpipe dev GUI

## One-time prerequisites (already done)

All installed:
- Rust (`%USERPROFILE%\.cargo\bin\cargo`)
- Node 24, Bun (`%USERPROFILE%\.bun\bin\bun.exe`)
- LLVM/Clang (`C:\Program Files\LLVM\bin`)
- CMake, ffmpeg, 7-Zip (`%LOCALAPPDATA%\Programs\7-Zip\7z.exe`)
- Fork at: `C:/D/oriz/repos/frk/screenpipe` (chirag127/screenpipe)

## Start dev GUI

```powershell
$env:LIBCLANG_PATH = "C:\Program Files\LLVM\bin"
$env:Path = "$env:USERPROFILE\.cargo\bin;C:\Users\C5420321\.bun\bin;" + $env:Path
$bun = "C:\Users\C5420321\.bun\bin\bun.exe"
Set-Location C:\D\oriz\repos\frk\screenpipe\apps\screenpipe-app-tauri
& $bun run tauri dev
```

First run: ~5-10 min (Rust incremental compile). Subsequent: ~30s.

Opens native window with full GUI: Timeline, Search, Chat, Settings, Pipes.

## Why dev, not build

`bun tauri build` blocked by CyberArk EPM (build scripts can't execute from user dirs). Dev mode works fine.

## API key

```
sp-c1aa9d65
```

CLI always at `localhost:3030`. Auto-starts on login via Startup folder.

## MCP

Wired to all 5 agents via `.mcp.json`. Ask any agent: "what was I working on in the last hour?"
