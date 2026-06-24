#!/usr/bin/env node
// One-shot: bind status.oriz.in -> Pages project oriz-status, and
// status-api.oriz.in -> Worker oriz-status-api.
// Idempotent: skips if already bound.
//
// Usage:
//   set -a; . ./.env; set +a
//   node scripts/cf-status-domains.mjs

const ZONE = 'oriz.in';
const SUBS = [
  { host: 'status', kind: 'pages', target: 'oriz-status' },
  { host: 'status-api', kind: 'worker', target: 'oriz-status-api' },
];

const TOKEN = process.env.CLOUDFLARE_API_TOKEN || process.env.CLOUDFLARE_API_KEY;
const ACCT = process.env.CLOUDFLARE_ACCOUNT_ID || '6a6349fe1568743539433bf10f23ffeb';
if (!TOKEN) { console.error('Missing CLOUDFLARE_API_TOKEN'); process.exit(1); }

const API = 'https://api.cloudflare.com/client/v4';
const H = { Authorization: `Bearer ${TOKEN}`, 'Content-Type': 'application/json' };

async function cf(path, init = {}) {
  const res = await fetch(`${API}${path}`, { ...init, headers: { ...H, ...(init.headers || {}) } });
  const json = await res.json();
  if (!json.success) {
    const msg = JSON.stringify(json.errors);
    // 81057 = already exists; we treat that as ok
    if (msg.includes('81057')) return { result: null, alreadyExists: true };
    throw new Error(`${path}: ${msg}`);
  }
  return json;
}

const { result: zones } = await cf(`/zones?name=${ZONE}`);
if (!zones.length) { console.error(`zone ${ZONE} not found`); process.exit(1); }
const zoneId = zones[0].id;
console.log(`zone ${ZONE} -> ${zoneId}\n`);

for (const { host, kind, target } of SUBS) {
  const fqdn = `${host}.${ZONE}`;
  console.log(`\n=== ${fqdn} (${kind} -> ${target}) ===`);

  if (kind === 'pages') {
    // Attach custom domain to Pages project — CF auto-creates the CNAME.
    try {
      const r = await cf(`/accounts/${ACCT}/pages/repos/${target}/domains`, {
        method: 'POST',
        body: JSON.stringify({ name: fqdn }),
      });
      console.log(`  pages domain bound: ${fqdn}`, r.alreadyExists ? '(already)' : '');
    } catch (e) {
      console.log(`  pages domain error:`, e.message);
    }
  } else if (kind === 'worker') {
    // Workers custom domain — uses /workers/domains. Needs zone + service.
    try {
      const r = await cf(`/accounts/${ACCT}/workers/domains`, {
        method: 'PUT',
        body: JSON.stringify({
          environment: 'production',
          hostname: fqdn,
          service: target,
          zone_id: zoneId,
        }),
      });
      console.log(`  worker domain bound: ${fqdn}`, r.alreadyExists ? '(already)' : '');
    } catch (e) {
      console.log(`  worker domain error:`, e.message);
    }
  }
}

console.log('\nDone.');
