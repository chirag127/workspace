## ⚠️ Issue revised 2026-06-29

**Original framing was wrong.** I claimed `grep libsql|litestream|turso` returns zero hits, implying no driver abstraction. That was incorrect — I only grepped `src/lib/db/*.ts` (top level) and missed `src/lib/db/adapters/`. OmniRoute already has a `SqliteAdapter` interface at `src/lib/db/adapters/types.ts` and a `driverFactory.ts` that selects between **three drivers**: `better-sqlite3`, `node:sqlite` (built-in), and `sql.js` (pure-WASM browser-compatible).

Apologies for the noise. Below is the narrowed-scope ask, after reading the existing abstraction.

---

## Narrowed gap: remote / networked driver for ephemeral PaaS

The existing `SqliteAdapter` covers three local drivers. None of them is a **remote / networked** driver, which is what ephemeral-disk PaaS hosts (Render free, Fly free, Railway free, Heroku-style) need — the local-disk drivers all assume the file survives across container restarts.

For an operator without card-on-file (paid persistent disks blocked), OmniRoute today still cannot run on these hosts without standing up a separate VPS.

### Three shapes that would close the gap

#### A. Litestream sidecar (zero TypeScript change)

The existing `SqliteAdapter` keeps its `better-sqlite3` path. A Litestream sidecar streams the SQLite WAL to S3-compatible storage (Backblaze B2 free, Cloudflare R2 free, MinIO). On container restart, Litestream restores the DB from the remote before the app starts.

- **Pros**: no `SqliteAdapter` change needed — the file is just there when the app boots. Keeps the existing 3-driver abstraction untouched.
- **Cons**: requires a sidecar in the Docker image; restore-on-boot adds ~5 s cold start.
- **Reference**: [litestream.io](https://litestream.io) — single-writer single-reader, mature, used in production by Fly.io.

#### B. Turso remote driver (4th `SqliteAdapter` impl)

Add `tursoRemoteAdapter.ts` next to the existing three. Implements the same `SqliteAdapter` interface but writes to Turso Cloud over HTTP. Trade-off: Turso's API is `await`-based — every `prepare().run()` call is async. The current adapter interface is **synchronous** (`PreparedStatement.run()` returns `RunResult` directly, not a Promise). Adapting this means either:
- Wrapping Turso in `child_process.execSync` (ugly but no caller changes), or
- Making the adapter interface async (invasive — touches every db module).

#### C. Postgres / `DATABASE_URL` path

Add a `DATABASE_URL=postgres://...` env path. Requires Drizzle ORM or hand-written SQL translation; more permanent maintenance overhead. Standard PaaS shape (Neon, Supabase, Render's own Postgres).

### Recommendation

**Option A (Litestream sidecar)** — minimal-invasive. The existing `SqliteAdapter` abstraction is exactly the right surface to keep stable; Litestream operates *underneath* the driver layer, not at it. A Dockerfile addition + a `LITESTREAM_REPLICA_URL` env var would unblock Render / Fly / Railway free tiers with zero code change.

If owning a sidecar is out of scope, documenting the constraint in README under "Hosting" (or `docs/ops/FLY_IO_DEPLOYMENT_GUIDE.md` if there's a hosting matrix) so operators don't discover it the hard way would also be valuable.

### Reference

Same gap exists in `tashfeenahmed/freellmapi`; I filed the analogous issue there as [freellmapi#399](https://github.com/tashfeenahmed/freellmapi/issues/399). Both projects share the local-disk SQLite baseline.

Happy to PR a Litestream Dockerfile + restore-on-boot script if you confirm Option A is the right shape.
