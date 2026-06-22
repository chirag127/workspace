#!/usr/bin/env node
// Sweep 19 API repos: verify CNAME file at repo root, ensure GH Pages enabled
// for the custom domain, and enforce HTTPS. Idempotent.
//
// Usage:
//   node scripts/gh-pages-cname-and-https.mjs --env=.env

import { readFileSync, existsSync } from 'node:fs';

const OWNER = 'chirag127';
const MAP = JSON.parse(readFileSync('./scripts/.api-repo-map.json', 'utf8'));

const envArg = process.argv.find(a => a.startsWith('--env='));
if (envArg) {
  const path = envArg.slice(6);
  if (existsSync(path)) {
    for (const line of readFileSync(path, 'utf8').split(/\r?\n/)) {
      const m = line.match(/^([A-Z0-9_]+)=(.*)$/);
      if (m && !process.env[m[1]]) process.env[m[1]] = m[2].replace(/^"|"$/g, '');
    }
  }
}

const TOKEN = process.env.GITHUB_TOKEN || process.env.GH_TOKEN;
if (!TOKEN) { console.error('Missing GITHUB_TOKEN'); process.exit(1); }

const H = {
  Authorization: `Bearer ${TOKEN}`,
  Accept: 'application/vnd.github+json',
  'X-GitHub-Api-Version': '2022-11-28',
};

async function gh(path, init = {}) {
  const res = await fetch(`https://api.github.com${path}`, {
    ...init,
    headers: { ...H, ...(init.headers || {}) },
  });
  const text = await res.text();
  let json; try { json = text ? JSON.parse(text) : null; } catch { json = text; }
  return { status: res.status, json };
}

const summary = { cnameOK: 0, cnameAdded: 0, cnameWrong: 0, pagesEnabled: 0, httpsEnforced: 0, alreadyEnforced: 0, errors: [] };

for (const [sub, repo] of Object.entries(MAP)) {
  const fqdn = `${sub}.api.oriz.in`;
  console.log(`\n[${sub}] ${repo} -> ${fqdn}`);

  // 1. Check CNAME file at root of default branch
  const { status: cnameStatus, json: cnameJson } = await gh(`/repos/${OWNER}/${repo}/contents/CNAME`);
  let needCreate = false, needUpdate = false, currentSha;
  if (cnameStatus === 404) {
    needCreate = true;
    console.log('  CNAME: missing -> will create');
  } else if (cnameStatus === 200) {
    const content = Buffer.from(cnameJson.content, 'base64').toString('utf8').trim();
    currentSha = cnameJson.sha;
    if (content === fqdn) {
      console.log(`  CNAME: ok (${content})`);
      summary.cnameOK++;
    } else {
      needUpdate = true;
      console.log(`  CNAME: wrong (${content}) -> will update`);
      summary.cnameWrong++;
    }
  } else {
    console.log(`  CNAME: ERROR status=${cnameStatus} ${JSON.stringify(cnameJson).slice(0,200)}`);
    summary.errors.push(`${repo}: CNAME read ${cnameStatus}`);
    continue;
  }

  if (needCreate || needUpdate) {
    const body = {
      message: needCreate ? `chore: add CNAME for ${fqdn}` : `chore: fix CNAME to ${fqdn}`,
      content: Buffer.from(fqdn + '\n', 'utf8').toString('base64'),
    };
    if (currentSha) body.sha = currentSha;
    const { status, json } = await gh(`/repos/${OWNER}/${repo}/contents/CNAME`, {
      method: 'PUT',
      body: JSON.stringify(body),
    });
    if (status === 200 || status === 201) {
      console.log(`  CNAME: ${needCreate ? 'created' : 'updated'}`);
      summary.cnameAdded++;
    } else {
      console.log(`  CNAME: write ERROR ${status} ${JSON.stringify(json).slice(0,200)}`);
      summary.errors.push(`${repo}: CNAME write ${status}`);
      continue;
    }
  }

  // 2. Get Pages config / create if missing
  const { status: pagesStatus, json: pagesJson } = await gh(`/repos/${OWNER}/${repo}/pages`);
  if (pagesStatus === 404) {
    // Create Pages site - need to pick source. Default branch + root
    const { status: cs, json: cj } = await gh(`/repos/${OWNER}/${repo}/pages`, {
      method: 'POST',
      body: JSON.stringify({ source: { branch: 'main', path: '/' } }),
    });
    if (cs === 201 || cs === 200) {
      console.log('  Pages: created');
      summary.pagesEnabled++;
    } else {
      console.log(`  Pages: create ERROR ${cs} ${JSON.stringify(cj).slice(0,200)}`);
      summary.errors.push(`${repo}: Pages create ${cs}`);
      continue;
    }
    // Wait briefly so subsequent PUT sees the config
    await new Promise(r => setTimeout(r, 1500));
  } else if (pagesStatus !== 200) {
    console.log(`  Pages: read ERROR ${pagesStatus} ${JSON.stringify(pagesJson).slice(0,200)}`);
    summary.errors.push(`${repo}: Pages read ${pagesStatus}`);
    continue;
  } else {
    console.log(`  Pages: exists (cname=${pagesJson.cname}, https_enforced=${pagesJson.https_enforced})`);
  }

  // 3. Set custom domain + https_enforced via PUT
  // First set cname (if differs), then https_enforced (separately, in case cert isn't ready)
  const currentCname = pagesJson?.cname;
  if (currentCname !== fqdn) {
    const { status: us, json: uj } = await gh(`/repos/${OWNER}/${repo}/pages`, {
      method: 'PUT',
      body: JSON.stringify({ cname: fqdn }),
    });
    if (us === 204 || us === 200) {
      console.log(`  Pages: cname set to ${fqdn}`);
    } else {
      console.log(`  Pages: set cname ERROR ${us} ${JSON.stringify(uj).slice(0,300)}`);
      summary.errors.push(`${repo}: Pages set cname ${us}`);
    }
  }

  // Try https_enforced=true; will fail until cert is provisioned
  const { status: hs, json: hj } = await gh(`/repos/${OWNER}/${repo}/pages`, {
    method: 'PUT',
    body: JSON.stringify({ https_enforced: true }),
  });
  if (hs === 204 || hs === 200) {
    if (pagesJson?.https_enforced) {
      console.log('  HTTPS: already enforced');
      summary.alreadyEnforced++;
    } else {
      console.log('  HTTPS: enforced');
      summary.httpsEnforced++;
    }
  } else {
    console.log(`  HTTPS: enforce skipped ${hs} ${JSON.stringify(hj).slice(0,200)}`);
  }
}

console.log('\n=== SUMMARY ===');
console.log(JSON.stringify(summary, null, 2));
process.exit(summary.errors.length ? 1 : 0);
