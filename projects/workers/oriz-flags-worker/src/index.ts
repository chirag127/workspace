// oriz-flags-worker
//
// Single CF Worker fronting CF KV (read cache) + CF D1 (source-of-truth).
// Three responsibilities:
//   1. GET  /tree        — return the resolved flag tree from KV (cached at edge)
//   2. POST /admin/*     — admin endpoints (auth via Firebase custom claim 'admin')
//   3. cron 02:30 UTC    — dump D1 state to private GitHub gist for DR
//
// Deploy with: wrangler deploy
// Config in wrangler.toml: D1 binding `DB`, KV binding `FLAGS`, secrets
// `ADMIN_ALLOWLIST_UIDS` (csv) and `SNAPSHOT_GIST_PAT`.

interface Env {
  DB: D1Database
  FLAGS: KVNamespace
  ADMIN_ALLOWLIST_UIDS: string
  SNAPSHOT_GIST_ID: string
  SNAPSHOT_GIST_PAT: string
}

interface FlagRow {
  key: string
  variant_type: 'bool' | 'string' | 'number'
  default_variant: string
  updated_at: number
  updated_by: string
}

interface RuleRow {
  flag_key: string
  priority: number
  segment_key: string
  variant: string
}

const TREE_KEY = 'flags:tree:v1'

/** Build the resolved tree from D1 and project it into KV. Called on every admin write. */
async function rebuildTree(env: Env): Promise<unknown> {
  const flags = await env.DB.prepare('SELECT * FROM flags').all<FlagRow>()
  const rules = await env.DB.prepare('SELECT * FROM flag_rules ORDER BY priority ASC').all<RuleRow>()
  const tree = {
    v: 1,
    ts: Date.now(),
    flags: Object.fromEntries(
      (flags.results ?? []).map((f) => [
        f.key,
        {
          type: f.variant_type,
          default: coerce(f.default_variant, f.variant_type),
          rules: (rules.results ?? [])
            .filter((r) => r.flag_key === f.key)
            .map((r) => ({
              priority: r.priority,
              segment: r.segment_key,
              variant: coerce(r.variant, f.variant_type),
            })),
        },
      ]),
    ),
  }
  await env.FLAGS.put(TREE_KEY, JSON.stringify(tree), {
    // expirationTtl is set by the GET handler's Cache-Control header instead;
    // here we just write the value.
  })
  return tree
}

function coerce(v: string, type: 'bool' | 'string' | 'number'): boolean | string | number {
  if (type === 'bool') return v === 'true' || v === '1'
  if (type === 'number') return Number(v)
  return v
}

async function verifyAdmin(req: Request, env: Env): Promise<{ uid: string } | null> {
  const authz = req.headers.get('authorization')
  if (!authz?.startsWith('Bearer ')) return null
  const idToken = authz.slice(7)
  // Verify Firebase ID token by hitting Google's tokeninfo endpoint.
  // (Avoids bundling firebase-admin; same shape as account-delete.ts.)
  const r = await fetch(
    `https://oauth2.googleapis.com/tokeninfo?id_token=${encodeURIComponent(idToken)}`,
  )
  if (!r.ok) return null
  const info = (await r.json()) as { sub?: string }
  const uid = info.sub
  if (!uid) return null
  const allowed = (env.ADMIN_ALLOWLIST_UIDS ?? '').split(',').map((s) => s.trim()).filter(Boolean)
  if (!allowed.includes(uid)) return null
  return { uid }
}

function json(data: unknown, init: ResponseInit = {}): Response {
  return new Response(JSON.stringify(data), {
    ...init,
    headers: {
      'content-type': 'application/json',
      'access-control-allow-origin': 'https://account.oriz.in',
      'access-control-allow-credentials': 'true',
      'access-control-allow-headers': 'authorization, content-type',
      'access-control-allow-methods': 'GET, POST, PUT, DELETE, OPTIONS',
      ...init.headers,
    },
  })
}

export default {
  async fetch(req: Request, env: Env): Promise<Response> {
    const url = new URL(req.url)
    const path = url.pathname

    if (req.method === 'OPTIONS') return json({}, { status: 204 })

    // Hot path — served from KV with 60s edge cache.
    if (path === '/tree' && req.method === 'GET') {
      const tree = await env.FLAGS.get(TREE_KEY)
      if (!tree) {
        // Cold cache (just deployed or KV cleared) — rebuild on demand.
        const fresh = await rebuildTree(env)
        return new Response(JSON.stringify(fresh), {
          headers: {
            'content-type': 'application/json',
            'cache-control': 'public, max-age=60, s-maxage=60',
            'access-control-allow-origin': '*',
          },
        })
      }
      return new Response(tree, {
        headers: {
          'content-type': 'application/json',
          'cache-control': 'public, max-age=60, s-maxage=60',
          'access-control-allow-origin': '*',
        },
      })
    }

    // Admin endpoints — all require Firebase admin claim.
    if (path.startsWith('/admin/')) {
      const admin = await verifyAdmin(req, env)
      if (!admin) return json({ error: 'unauthorized' }, { status: 401 })

      if (path === '/admin/list' && req.method === 'GET') {
        const flags = await env.DB.prepare('SELECT * FROM flags ORDER BY key').all<FlagRow>()
        const rules = await env.DB.prepare(
          'SELECT * FROM flag_rules ORDER BY flag_key, priority',
        ).all<RuleRow>()
        return json({ flags: flags.results, rules: rules.results })
      }

      if (path === '/admin/upsert' && req.method === 'POST') {
        const body = (await req.json()) as {
          key: string
          type: 'bool' | 'string' | 'number'
          default: string | boolean | number
          rules: Array<{ priority: number; segment: string; variant: string | boolean | number }>
        }
        if (!body.key) return json({ error: 'key required' }, { status: 400 })
        const now = Date.now()
        await env.DB.batch([
          env.DB.prepare(
            'INSERT INTO flags(key, variant_type, default_variant, updated_at, updated_by) VALUES (?,?,?,?,?) ON CONFLICT(key) DO UPDATE SET variant_type=excluded.variant_type, default_variant=excluded.default_variant, updated_at=excluded.updated_at, updated_by=excluded.updated_by',
          ).bind(body.key, body.type, String(body.default), now, admin.uid),
          env.DB.prepare('DELETE FROM flag_rules WHERE flag_key=?').bind(body.key),
          ...body.rules.map((r) =>
            env.DB.prepare(
              'INSERT INTO flag_rules(flag_key, priority, segment_key, variant) VALUES (?,?,?,?)',
            ).bind(body.key, r.priority, r.segment, String(r.variant)),
          ),
        ])
        await env.DB.prepare(
          'INSERT INTO flag_changes(flag_key, before_json, after_json, changed_by, changed_at) VALUES (?,?,?,?,?)',
        )
          .bind(body.key, '', JSON.stringify(body), admin.uid, now)
          .run()
        await rebuildTree(env)
        return json({ ok: true })
      }

      if (path === '/admin/rebuild-kv' && req.method === 'POST') {
        const tree = await rebuildTree(env)
        return json({ ok: true, tree })
      }
    }

    return new Response('Not found', { status: 404 })
  },

  /** Cron handler — nightly DR snapshot to private gist. */
  async scheduled(_evt: ScheduledEvent, env: Env): Promise<void> {
    const flags = await env.DB.prepare('SELECT * FROM flags').all<FlagRow>()
    const rules = await env.DB.prepare('SELECT * FROM flag_rules').all<RuleRow>()
    const changes = await env.DB.prepare(
      'SELECT * FROM flag_changes ORDER BY changed_at DESC LIMIT 1000',
    ).all()
    const snapshot = {
      exported_at: new Date().toISOString(),
      flags: flags.results,
      rules: rules.results,
      recent_changes: changes.results,
    }
    if (env.SNAPSHOT_GIST_ID && env.SNAPSHOT_GIST_PAT) {
      await fetch(`https://api.github.com/gists/${env.SNAPSHOT_GIST_ID}`, {
        method: 'PATCH',
        headers: {
          authorization: `token ${env.SNAPSHOT_GIST_PAT}`,
          accept: 'application/vnd.github+json',
          'user-agent': 'oriz-flags-worker',
        },
        body: JSON.stringify({
          files: { 'flags-latest.json': { content: JSON.stringify(snapshot, null, 2) } },
        }),
      })
    }
  },
}
