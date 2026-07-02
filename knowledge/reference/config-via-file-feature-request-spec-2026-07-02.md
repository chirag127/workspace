# Feature request spec: config-via-file for GUI apps

Reusable spec attached to every feature-request filed 2026-07-02 during the VDI-apps campaign. Keeps requests consistent + gives maintainers a concrete design to say yes to.

## The ask (one paragraph)

Allow every GUI setting to also be configurable via a config file (JSON, YAML, or TOML — maintainer's choice). Enables scripted setup, reproducible environments, and version-controlled preferences. Critical for teams, dotfile users, and anyone using the app in more than one location.

## Suggested design

### Config file location precedence

Load in this order, later overrides earlier:

1. **System** — `/etc/<app>/config.json` (Linux) or `C:\ProgramData\<App>\config.json` (Windows) or `/Library/Application Support/<App>/config.json` (Mac)
2. **User** — `~/.config/<app>/config.json` (Linux/Mac) or `%APPDATA%\<App>\config.json` (Windows)
3. **Project** — `<cwd>/.<app>rc.json` or `<cwd>/<app>.config.json`
4. **CLI override** — `--config /path/to/config.json` flag
5. **GUI** — settings changed in the running GUI (persist to user-config on exit, if user opts in)

### File format

Prefer **JSON** for simplicity + validation ecosystem. YAML acceptable. TOML acceptable. Pick ONE and document.

### JSON Schema

Ship a JSON Schema (draft 2020-12) alongside the app. Enables IDE autocomplete + validation. Publish to schemastore.org.

### Precedence rule

CLI flag > project config > user config > system config > GUI-editable defaults.

### Hot reload (optional)

Watch config file for changes; apply without restart. Nice-to-have, not required for v1.

### Fields

**Every** GUI-exposed setting has a corresponding key in the schema. Zero exceptions — otherwise config-driven setup can't fully replace GUI setup.

Nested keys mirror menu hierarchy: `File > Preferences > Appearance > Theme` → `preferences.appearance.theme`.

### Deprecation

Config keys are stable — deprecating a key requires:
- Console warning on load
- Auto-migration if possible
- One major version between deprecation warning + removal

## Why this matters (the pitch)

- **Teams**: onboarding = clone dotfiles repo, app is configured identically.
- **Reproducible environments**: bug reports include exact config file. Maintainer reproduces.
- **CI / headless setup**: config file drops into container images; no GUI-click needed.
- **Version control**: `git log` on config file shows preference evolution.
- **Backup + restore**: single file, not registry + AppData scattered state.
- **Multi-machine sync**: symlinked config file across machines.

## Existing reference implementations (cite these)

- **VS Code**: `~/.config/Code/User/settings.json` + CLI `--user-data-dir` — gold standard.
- **Neovim**: `~/.config/nvim/init.lua` — code-configured editor.
- **Sublime Text**: `Preferences.sublime-settings` per-scope.
- **git**: `~/.gitconfig` + `--file` flag.
- **kitty terminal**: `~/.config/kitty/kitty.conf`.
- **Alacritty**: `~/.config/alacritty/alacritty.toml`.
- **VLC**: has `vlcrc` (INI style) — partial precedent, needs JSON modernization.

## Template body (for issues / emails)

```
Hi <maintainer>,

Feature request: expose all GUI settings via a config file (JSON/YAML/TOML).

Why it matters:
- Teams can commit dotfiles for consistent onboarding.
- Bug reports become reproducible (config file attached).
- CI / headless setup becomes possible.
- Version-controlled preferences.

Suggested shape (attached spec): <link to this doc or paste inline>

Reference implementations: VS Code (settings.json), Alacritty (alacritty.toml), git (--file). VLC has partial precedent via vlcrc.

Not asking for the full spec on day one — even a partial (only the most-used 20 settings via config) is a huge win.

Happy to help with schema design or provide sample config files if useful.

Thanks for the great work on <app>!
```

Word count: ~120 words body + spec attachment. Fits [`terse-issues-less-hallucination`](../rules/agent/terse-issues-less-hallucination.md) cap on feature requests (≤100 words body). Body condenses; spec attaches as a separate section or linked file.

## Cross-refs

- Campaign: 2026-07-02 VDI-apps feature-request sweep
- [`terse-issues-less-hallucination`](../rules/agent/terse-issues-less-hallucination.md)
- [`thank-maintainers`](../rules/agent/thank-maintainers.md)
- [`draft-not-send`](../rules/agent/draft-not-send.md) — user reviews each drafted issue before send
