## Problem

OmniRoute uses `better-sqlite3` writing to a local SQLite file under `DATA_DIR`. This is great for:
- Local dev (laptop, desktop)
- Long-lived VPS (DigitalOcean, AWS EC2, Azure VM)
- Self-hosted home server / NAS

It is a **hard blocker** for:
- **Render free tier** — Web Service ephemeral disk wipes on every deploy, free tier has no persistent-disk option.
- **Fly.io free tier without persistent volume** — same shape.
- **Railway free tier** — same.
- **Heroku-style PaaS** — ephemeral filesystem.
- **Serverless / edge** runtimes (Cloudflare Workers, Vercel Functions) — no local FS at all.

For operators without card-on-file (paid persistent disks blocked), OmniRoute simply cannot run on these hosts today.

## Current state in OmniRoute

`grep libsql|litestream|turso|DATABASE_URL` in `src/lib/db/` returns **zero hits**. The DB layer is `better-sqlite3`-only across all ~80 db modules.

`docs/ops/FLY_IO_DEPLOYMENT_GUIDE.md` (line 913 of README) exists but assumes persistent storage, not free-tier ephemeral.

## Proposed shapes

A **driver-shaped abstraction** so the DB layer can target one of:

| Driver | When to use | Sync API? |
|---|---|---|
| `better-sqlite3` (current) | Persistent local disk available | ✅ |
| `libsql` / Turso embedded replica | Local read-cache + cloud sync | ✅ |
| `libsql` / Turso remote (HTTP) | Ephemeral container, free tier covers ~5 GB | ❌ async |
| Neon (Postgres serverless) | Existing Postgres infra | ❌ async |
| Litestream sidecar | Stream SQLite WAL to S3/B2 | ✅ (transparent) |

### Option A: Litestream sidecar (zero TypeScript change)

Run a Litestream sidecar that streams the SQLite WAL to S3-compatible storage (Backblaze B2 free, Cloudflare R2 free, MinIO). On container restart, Litestream restores the DB from the remote before the app starts.

- **Pros**: zero TypeScript change, keeps `better-sqlite3` sync API, fits the current architecture (80+ db modules all keep their `.run()`/`.get()`/`.all()` calls).
- **Cons**: requires a sidecar in the Docker image; restore-on-boot adds ~5 s cold start.
- **Reference**: [litestream.io](https://litestream.io) — single-writer single-reader, mature, used in production by Fly.io.

### Option B: Turso embedded replica

Switch `src/lib/db/core.ts` from `better-sqlite3` to `@tursodatabase/sync`. Embedded replica syncs to Turso Cloud on push/pull. Reads stay local + sync; writes go to cloud.

- **Pros**: real persistence across container restarts, no sidecar.
- **Cons**: Turso APIs are `await`-based — every call site (`db.prepare().run()`, `.get()`, `.all()`) needs `await`. That's far more than 43 files in OmniRoute's case (the 80-module DB layer).

### Option C: Postgres driver

Add a `DATABASE_URL=postgres://...` env path. Uses Drizzle ORM with `node-postgres`. Matches what Render / Railway / Fly / Heroku users expect by default.

- **Pros**: standard PaaS shape; free tiers everywhere (Neon, Supabase, Render's own Postgres).
- **Cons**: full rewrite of the data layer; permanent maintenance overhead.

## Ask

1. Acknowledge the gap (free-tier PaaS hosts cannot run OmniRoute today without paid persistent disk).
2. Pick a strategy. **Recommended: Litestream sidecar** (Option A) — preserves the entire codebase as-is and unblocks Render / Fly / Railway with a Dockerfile change.
3. If you'd rather not own the sidecar, document the limitation in README under "Hosting" with a clear "use a long-lived VPS, not free-tier PaaS" note so users aren't surprised.

## Reference

Same gap exists in `tashfeenahmed/freellmapi`; I filed the analogous issue there as [freellmapi#399](https://github.com/tashfeenahmed/freellmapi/issues/399) on 2026-06-27 with the same shape. Both projects share the `better-sqlite3` baseline; whichever approach OmniRoute prefers, the freellmapi discussion thread may be useful prior art.

Happy to PR Option A (Litestream sidecar) if you confirm the strategy.
