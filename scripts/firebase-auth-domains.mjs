#!/usr/bin/env node
// Update Firebase Auth authorized domains via Identity Toolkit Admin API.
// Uses the service account JSON from .env. No external deps — built-in crypto only.

import fs from 'node:fs'
import crypto from 'node:crypto'

const ENV_PATH = process.argv[2] || 'c:/D/oriz/.env'

// --- 1. Parse .env to extract FIREBASE_SERVICE_ACCOUNT_JSON ---
const envText = fs.readFileSync(ENV_PATH, 'utf8')
const m = envText.match(/^FIREBASE_SERVICE_ACCOUNT_JSON\s*=\s*'(\{.*\})'\s*$/m)
if (!m) {
  console.error('Could not find FIREBASE_SERVICE_ACCOUNT_JSON in .env')
  process.exit(1)
}
const sa = JSON.parse(m[1])
const projectId = sa.project_id
const clientEmail = sa.client_email
const privateKey = sa.private_key

// --- 2. Mint an OAuth2 access token via JWT bearer flow ---
function b64url(buf) {
  return Buffer.from(buf).toString('base64').replace(/=+$/, '').replace(/\+/g, '-').replace(/\//g, '_')
}

async function getAccessToken() {
  const now = Math.floor(Date.now() / 1000)
  const header = { alg: 'RS256', typ: 'JWT' }
  const claim = {
    iss: clientEmail,
    scope: 'https://www.googleapis.com/auth/cloud-platform https://www.googleapis.com/auth/firebase',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
  }
  const unsigned = `${b64url(JSON.stringify(header))}.${b64url(JSON.stringify(claim))}`
  const sig = crypto.createSign('RSA-SHA256').update(unsigned).sign(privateKey)
  const jwt = `${unsigned}.${b64url(sig)}`

  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  })
  if (!res.ok) {
    console.error('Token request failed:', res.status, await res.text())
    process.exit(1)
  }
  const data = await res.json()
  return data.access_token
}

async function getConfig(token) {
  const r = await fetch(
    `https://identitytoolkit.googleapis.com/admin/v2/repos/${projectId}/config`,
    { headers: { Authorization: `Bearer ${token}` } }
  )
  if (!r.ok) {
    console.error('GET config failed:', r.status, await r.text())
    process.exit(1)
  }
  return r.json()
}

async function patchAuthorizedDomains(token, domains) {
  const url = `https://identitytoolkit.googleapis.com/admin/v2/repos/${projectId}/config?updateMask=authorizedDomains`
  const r = await fetch(url, {
    method: 'PATCH',
    headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ authorizedDomains: domains }),
  })
  if (!r.ok) {
    console.error('PATCH failed:', r.status, await r.text())
    process.exit(1)
  }
  return r.json()
}

const token = await getAccessToken()
console.log('Got access token')

const before = await getConfig(token)
console.log('Current authorizedDomains:', before.authorizedDomains)

const required = [
  'localhost',
  'oriz-app.firebaseapp.com',
  'oriz-app.web.app',
  'account.oriz.in',
  'auth.oriz.in',
  'oriz-auth-app.pages.dev',
  'oriz.in',
]
const merged = Array.from(new Set([...(before.authorizedDomains || []), ...required]))

if (JSON.stringify(merged.sort()) === JSON.stringify((before.authorizedDomains || []).slice().sort())) {
  console.log('No changes needed — all required domains already present.')
  process.exit(0)
}

const after = await patchAuthorizedDomains(token, merged)
console.log('Updated authorizedDomains:', after.authorizedDomains)
