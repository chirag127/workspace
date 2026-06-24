#!/usr/bin/env node
// Download + extract a Chrome Web Store extension as a .zip directory.
//
// Replicates what the "CRX Extractor/Downloader" Chrome extension does
// (its popup.js was the reference). No browser dependency — pure Node.
//
// CRX format = small header + ZIP file. We download the .crx, strip the
// header bytes per the format version, write out the ZIP.
//
// Usage:
//   node scripts/download-cws-extension.mjs <EXT_ID> [<OUTPUT_DIR>]
//
// Example:
//   node scripts/download-cws-extension.mjs fmkancpjcacjodknfjcpmgkccbhedkhc ./tmp/tweeks
//
// CRX header layout (v3, common today):
//   bytes 0..3   = "Cr24" magic
//   bytes 4..7   = uint32 LE: format version (2 or 3)
//   bytes 8..11  = uint32 LE: public-key length (CRX2) OR header length (CRX3)
//   bytes 12..15 = uint32 LE: signature length (CRX2 only)
//   ...followed by the embedded ZIP payload.
//
// For CRX2: zip_start = 16 + pub_key_len + sig_len
// For CRX3: zip_start = 12 + header_len
//
// NOTE: CRX downloading is for PERSONAL STUDY only. Closed-source extensions
// (e.g. Tweeks) are licensed for end-user use under the Chrome Web Store ToS;
// redistribution / publishing the modified extension is a license violation.

import fs from 'node:fs';
import path from 'node:path';
import https from 'node:https';
import { URL } from 'node:url';
import { execSync } from 'node:child_process';

const [, , EXT_ID, OUT_DIR_RAW] = process.argv;

if (!EXT_ID || !/^[a-z]{32}$/.test(EXT_ID)) {
  console.error('Usage: download-cws-extension.mjs <EXT_ID> [<OUTPUT_DIR>]');
  console.error('EXT_ID must be 32 lowercase letters (the trailing segment of a chromewebstore.google.com/detail/ URL).');
  process.exit(2);
}

const OUT_DIR = path.resolve(OUT_DIR_RAW || `./tmp/${EXT_ID}`);

// Google's CRX-download endpoint. prodversion is a Chrome version we pretend to
// be running; acceptformat lets the server decide between crx2/crx3 (current is crx3).
const url = new URL('https://clients2.google.com/service/update2/crx');
url.searchParams.set('response', 'redirect');
url.searchParams.set('prodversion', '120.0.0.0');
url.searchParams.set('acceptformat', 'crx2,crx3');
url.searchParams.set('x', `id=${EXT_ID}&uc`);

console.error(`Fetching ${url.toString()}`);

function fetchFollowingRedirects(u, depth = 0) {
  return new Promise((resolve, reject) => {
    if (depth > 5) return reject(new Error('Too many redirects'));
    https.get(u, (res) => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        res.resume();
        resolve(fetchFollowingRedirects(res.headers.location, depth + 1));
        return;
      }
      if (res.statusCode !== 200) {
        return reject(new Error(`HTTP ${res.statusCode} on ${u}`));
      }
      const chunks = [];
      res.on('data', (c) => chunks.push(c));
      res.on('end', () => resolve(Buffer.concat(chunks)));
      res.on('error', reject);
    }).on('error', reject);
  });
}

const crxBuf = await fetchFollowingRedirects(url.toString());
console.error(`Got ${crxBuf.length} bytes of .crx`);

// Parse the CRX header to find the ZIP start offset.
if (crxBuf.slice(0, 4).toString('ascii') !== 'Cr24') {
  throw new Error(`Not a CRX file (missing "Cr24" magic). First 4 bytes: ${crxBuf.slice(0, 4).toString('hex')}`);
}
const version = crxBuf.readUInt32LE(4);
let zipStart;
if (version === 2) {
  const pubKeyLen = crxBuf.readUInt32LE(8);
  const sigLen = crxBuf.readUInt32LE(12);
  zipStart = 16 + pubKeyLen + sigLen;
  console.error(`CRX v2: pubKeyLen=${pubKeyLen}, sigLen=${sigLen}, zip starts at ${zipStart}`);
} else if (version === 3) {
  const headerLen = crxBuf.readUInt32LE(8);
  zipStart = 12 + headerLen;
  console.error(`CRX v3: headerLen=${headerLen}, zip starts at ${zipStart}`);
} else {
  throw new Error(`Unknown CRX format version ${version}`);
}

const zipBuf = crxBuf.slice(zipStart);
// Sanity: ZIP files start with "PK\x03\x04" (local file header)
if (zipBuf.slice(0, 4).toString('hex') !== '504b0304') {
  console.error(`Warning: ZIP magic missing at expected offset. First 4 bytes of stripped payload: ${zipBuf.slice(0, 4).toString('hex')}`);
}

fs.mkdirSync(OUT_DIR, { recursive: true });
const zipPath = path.join(OUT_DIR, `${EXT_ID}.zip`);
fs.writeFileSync(zipPath, zipBuf);
console.error(`Wrote ZIP: ${zipPath} (${zipBuf.length} bytes)`);

// Extract using PowerShell on Windows or unzip elsewhere.
const extractDir = path.join(OUT_DIR, 'extracted');
fs.mkdirSync(extractDir, { recursive: true });
if (process.platform === 'win32') {
  execSync(`powershell -NoProfile -Command "Expand-Archive -Force -LiteralPath '${zipPath}' -DestinationPath '${extractDir}'"`, { stdio: 'inherit' });
} else {
  execSync(`unzip -o "${zipPath}" -d "${extractDir}"`, { stdio: 'inherit' });
}

console.log(extractDir);
