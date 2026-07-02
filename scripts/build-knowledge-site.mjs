#!/usr/bin/env node
/**
 * Build knowledge site — Astro-free minimal builder for knowledge.oriz.in.
 *
 * Consumes: knowledge/**\/*.md (OKF concept files)
 * Outputs:  dist/knowledge/
 *   - index.html + <slug>.html per concept
 *   - llms.txt (concat of all concept bodies, LLM-friendly)
 *   - sitemap.xml
 *   - feed.xml (RSS 2.0), atom.xml (Atom 1.0)
 *   - schema.json (OKF version + custom fields)
 *   - related.json (precomputed graph)
 *   - style.css
 *
 * Zero deps beyond Node stdlib + `marked` + `gray-matter`.
 *
 * This is intentionally minimal — a fuller Astro-based site can replace it later.
 * Priority: ship SOMETHING at knowledge.oriz.in before over-engineering.
 *
 * Related: knowledge/decisions/agent-tooling/cloud-publish-knowledge-2026-07-03.md
 *          knowledge/decisions/agent-tooling/okf-build-engine-astro-2026-07-03.md
 */
import { readFileSync, writeFileSync, mkdirSync, readdirSync, statSync } from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

// Deps loaded via pnpm install of workspace root
const matter = (await import('gray-matter')).default
const { marked } = await import('marked')

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const REPO_ROOT = path.resolve(__dirname, '..')
const KNOWLEDGE = path.join(REPO_ROOT, 'knowledge')
const OUT = path.join(REPO_ROOT, 'dist', 'knowledge')
const SITE_URL = process.env.SITE_URL || 'https://knowledge.oriz.in'

mkdirSync(OUT, { recursive: true })

// Walk knowledge/ for all .md
function walk(dir, files = []) {
  for (const entry of readdirSync(dir)) {
    if (entry.startsWith('_') || entry.startsWith('.')) continue
    const full = path.join(dir, entry)
    const st = statSync(full)
    if (st.isDirectory()) walk(full, files)
    else if (entry.endsWith('.md')) files.push(full)
  }
  return files
}

const files = walk(KNOWLEDGE)
console.log(`build: found ${files.length} concept files`)

const concepts = []
for (const f of files) {
  const raw = readFileSync(f, 'utf8')
  let parsed
  try {
    parsed = matter(raw)
  } catch (err) {
    console.error(`build: PARSE FAILED for ${f}`)
    console.error(err.message.split('\n').slice(0, 3).join('\n'))
    continue
  }
  const rel = path.relative(KNOWLEDGE, f).replace(/\\/g, '/')
  const slug = rel.replace(/\.md$/, '')
  concepts.push({
    slug,
    rel,
    file: f,
    frontmatter: parsed.data,
    body: parsed.content,
  })
}

// Sort by timestamp desc (defensive — timestamp may be Date or string)
concepts.sort((a, b) => {
  const at = String(a.frontmatter.timestamp || '')
  const bt = String(b.frontmatter.timestamp || '')
  return bt.localeCompare(at)
})

// Emit page per concept
const layout = (c) => `<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<title>${c.frontmatter.title || c.slug} — knowledge.oriz.in</title>
<meta name="description" content="${escapeHtml(c.frontmatter.description || '')}">
<link rel="stylesheet" href="/style.css">
<link rel="alternate" type="application/rss+xml" href="/feed.xml">
<link rel="alternate" type="application/atom+xml" href="/atom.xml">
</head><body>
<header><a href="/">← knowledge.oriz.in</a></header>
<main>
<h1>${c.frontmatter.title || c.slug}</h1>
<p class="meta">
  <span class="type">${c.frontmatter.type || 'concept'}</span>
  ${c.frontmatter.timestamp ? `<time>${c.frontmatter.timestamp}</time>` : ''}
  ${c.frontmatter.tags ? `<span class="tags">${c.frontmatter.tags.map(t => `<span>${t}</span>`).join('')}</span>` : ''}
</p>
${marked.parse(c.body)}
<footer><a href="https://github.com/chirag127/workspace/blob/main/knowledge/${c.rel}">Edit on GitHub</a></footer>
</main></body></html>`

function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]))
}

for (const c of concepts) {
  const outPath = path.join(OUT, `${c.slug}.html`)
  mkdirSync(path.dirname(outPath), { recursive: true })
  writeFileSync(outPath, layout(c))
}

// index.html — grouped by type
const byType = {}
for (const c of concepts) {
  const t = c.frontmatter.type || 'other'
  byType[t] = byType[t] || []
  byType[t].push(c)
}

writeFileSync(path.join(OUT, 'index.html'), `<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<title>knowledge.oriz.in — Chirag's OKF bundle</title>
<meta name="description" content="Open Knowledge Format bundle: ${concepts.length} concept files covering decisions, rules, runbooks, services.">
<link rel="stylesheet" href="/style.css">
<link rel="alternate" type="application/rss+xml" href="/feed.xml">
</head><body>
<main>
<h1>knowledge.oriz.in</h1>
<p>Open Knowledge Format bundle. ${concepts.length} concept files. <a href="https://github.com/chirag127/workspace">source</a> · <a href="/feed.xml">RSS</a> · <a href="/llms.txt">llms.txt</a></p>
${Object.entries(byType).map(([t, cs]) => `<h2>${t} (${cs.length})</h2><ul>${cs.map(c => `<li><a href="/${c.slug}.html">${c.frontmatter.title || c.slug}</a> — ${escapeHtml(c.frontmatter.description || '')}</li>`).join('')}</ul>`).join('')}
</main></body></html>`)

// llms.txt
writeFileSync(path.join(OUT, 'llms.txt'), `# knowledge.oriz.in — ${concepts.length} concept files

${concepts.map(c => `## ${c.frontmatter.title || c.slug}\n\n${c.frontmatter.description || ''}\n\nURL: ${SITE_URL}/${c.slug}.html\nType: ${c.frontmatter.type}\nTags: ${(c.frontmatter.tags || []).join(', ')}\n`).join('\n')}
`)

// sitemap.xml
writeFileSync(path.join(OUT, 'sitemap.xml'), `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${concepts.map(c => `<url><loc>${SITE_URL}/${c.slug}.html</loc>${c.frontmatter.timestamp ? `<lastmod>${c.frontmatter.timestamp}</lastmod>` : ''}</url>`).join('\n')}
</urlset>`)

// feed.xml (RSS)
const recent = concepts.slice(0, 50)
writeFileSync(path.join(OUT, 'feed.xml'), `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"><channel>
<title>knowledge.oriz.in</title>
<link>${SITE_URL}</link>
<description>Chirag's OKF bundle — decisions, rules, runbooks</description>
${recent.map(c => `<item><title>${escapeHtml(c.frontmatter.title || c.slug)}</title><link>${SITE_URL}/${c.slug}.html</link><description>${escapeHtml(c.frontmatter.description || '')}</description>${c.frontmatter.timestamp ? `<pubDate>${new Date(c.frontmatter.timestamp).toUTCString()}</pubDate>` : ''}<guid>${SITE_URL}/${c.slug}.html</guid></item>`).join('\n')}
</channel></rss>`)

// schema.json
writeFileSync(path.join(OUT, 'schema.json'), JSON.stringify({
  format_version: 'okf-v0.2',
  spec_url: 'https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md',
  custom_fields: {
    confidence: { type: 'enum', values: ['high', 'medium', 'low'], optional: true },
    durability: { type: 'enum', values: ['durable', 'volatile'], optional: true },
  },
  concept_count: concepts.length,
  bundle_url: SITE_URL,
}, null, 2))

// related.json — precomputed graph
const related = {}
for (const c of concepts) {
  related[c.slug] = c.frontmatter.related || []
}
writeFileSync(path.join(OUT, 'related.json'), JSON.stringify(related, null, 2))

// style.css — minimal, works
writeFileSync(path.join(OUT, 'style.css'), `body{max-width:720px;margin:2rem auto;padding:0 1rem;font:16px/1.5 system-ui,-apple-system,sans-serif;color:#222;background:#fafafa}h1,h2,h3{line-height:1.2}h1{border-bottom:2px solid #333;padding-bottom:.3em}a{color:#0366d6}pre{background:#f4f4f4;padding:1em;overflow-x:auto;border-radius:4px}code{background:#f4f4f4;padding:.15em .3em;border-radius:3px}.meta{color:#666;font-size:.9em}.meta .type{background:#333;color:#fff;padding:.15em .4em;border-radius:3px;text-transform:uppercase;font-size:.75em;margin-right:.5em}.tags span{background:#eee;padding:.1em .35em;margin-right:.25em;border-radius:3px;font-size:.85em}header{padding:.5em 0;border-bottom:1px solid #ddd}footer{margin-top:3em;padding-top:1em;border-top:1px solid #ddd;color:#666;font-size:.85em}table{border-collapse:collapse;width:100%}th,td{border:1px solid #ddd;padding:.4em .6em;text-align:left}`)

console.log(`build: emitted ${concepts.length} pages + llms.txt + sitemap.xml + feed.xml + schema.json + related.json`)
