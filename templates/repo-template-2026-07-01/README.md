# repo-template-2026-07-01

Canonical oriz repo template. New repos scaffold from here.

## Bootstrap

```bash
cp -r C:/D/oriz/templates/repo-template-2026-07-01/. C:/D/oriz/repos/own/<category>/<name>/
cd C:/D/oriz/repos/own/<category>/<name>/
# Edit package.json — set "name": "@oriz/<name>"
git init && git add . && git commit -m "chore: scaffold from repo-template-2026-07-01"
```

## Layers

Three layers, thin adapters on top of a hermetic core:

| Layer | Purpose | Runs |
|---|---|---|
| **MegaLinter** | 100+ linters in one container | `pnpm lint` / `pnpm lint:fix` |
| **Dagger** | Hermetic pipelines, same on laptop and CI | `dagger call ci --source=.` |
| **CI adapters** | Thin YAML per host — GHA / GitLab / Woodpecker | Auto on push/PR |

Everything runs in Docker. No host toolchain drift.

## Run locally

```bash
pnpm install
pnpm ci                    # lint + test + build (host node)
dagger call ci --source=.  # same, hermetic in containers
```

`pnpm ci` is fast (host). `dagger call ci` is reproducible (matches CI byte-for-byte).

## Add tasks

- **Lint config:** `.mega-linter.yml` — enable/disable linters, set `APPLY_FIXES`
- **Pipeline:** `dagger/main.ts` — add `@func()` methods for new stages
- **CI hosts:** `.github/workflows/ci.yml`, `.gitlab-ci.yml`, `.woodpecker.yml` — all call the same Dagger pipeline

## Repo-type overrides

Adjust these per repo type:

- **Astro site:** replace `test`/`build` scripts with `astro check && astro build`; add `dev` script
- **CF Worker:** add `wrangler` to devDeps; `build` → `wrangler deploy --dry-run`; add `.dev.vars.example`
- **VS Code extension:** add `vscode:prepublish` script; `@types/vscode`; `.vscodeignore`

## Files

- `package.json` — pnpm 11, node 22, ES modules
- `.mega-linter.yml` — linter config (JSCPD disabled by default)
- `dagger/main.ts` — TS pipeline: `test`, `lint`, `ci` functions
- `.github/workflows/ci.yml` — GHA thin adapter
- `.gitlab-ci.yml` — GitLab thin adapter
- `.woodpecker.yml` — Codeberg/Woodpecker thin adapter
- `tsconfig.json` — ES2022, NodeNext, strict
