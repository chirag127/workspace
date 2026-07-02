#!/usr/bin/env node
/**
 * Build skills site — Astro-free minimal builder for skills.oriz.in.
 *
 * Consumes: repos/own/infra/agent-skills/<slug>/SKILL.md
 * Outputs:  dist/skills/
 *   - index.html
 *   - <slug>.html per skill
 *   - llms.txt, sitemap.xml, feed.xml, atom.xml, schema.json
 *   - style.css
 *
 * Same pattern as build-knowledge-site.mjs.
 *
 * Related: knowledge/decisions/agent-tooling/cloud-publish-skills-2026-07-03.md
 */
import { readFileSync, writeFileSync, mkdirSync, readdirSync, statSync } from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const matter = (await import('gray-matter')).default
const { marked } = await import('marked')

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const REPO_ROOT = path.resolve(__dirname, '..')
const SKILLS_DIR = path.join(REPO_ROOT, 'repos', 'own', 'infra', 'agent-skills')
const OUT = path.join(REPO_ROOT, 'dist', 'skills')
const SITE_URL = process.env.SITE_URL || 'https://skills.oriz.in'

mkdirSync(OUT, { recursive: true })

const skillDirs = readdirSync(SKILLS_DIR).filter(d => {
  const full = path.join(SKILLS_DIR, d)
  return statSync(full).isDirectory() && !d.startsWith('.') && !d.startsWith('_') && d !== 'scripts' && d !== 'node_modules'
})

const skills = []
for (const d of skillDirs) {
  const skillMd = path.join(SKILLS_DIR, d, 'SKILL.md')
  try {
    const raw = readFileSync(skillMd, 'utf8')
    const parsed = matter(raw)
    skills.push({
      slug: parsed.data.name || d,
      dir: d,
      frontmatter: parsed.data,
      body: parsed.content,
    })
  } catch (err) {
    console.error(`build-skills: ${d} — ${err.message.split('\n')[0]}`)
  }
}

skills.sort((a, b) => a.slug.localeCompare(b.slug))
console.log(`build-skills: found ${skills.length} skills`)

function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]))
}

for (const s of skills) {
  const outPath = path.join(OUT, `${s.slug}.html`)
  writeFileSync(outPath, `<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<title>${s.slug} — skills.oriz.in</title>
<meta name="description" content="${escapeHtml(s.frontmatter.description || '')}">
<link rel="stylesheet" href="/style.css">
<link rel="alternate" type="application/rss+xml" href="/feed.xml">
</head><body>
<header><a href="/">← skills.oriz.in</a></header>
<main>
<h1>${s.slug}</h1>
<p class="meta">${escapeHtml(s.frontmatter.description || '')}</p>
${marked.parse(s.body)}
<footer><a href="https://github.com/chirag127/agent-skills/blob/main/${s.dir}/SKILL.md">Edit on GitHub</a></footer>
</main></body></html>`)
}

writeFileSync(path.join(OUT, 'index.html'), `<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<title>skills.oriz.in — Chirag's agent skills</title>
<meta name="description" content="${skills.length} agent skills for Claude Code and any AGENTS.md-reading tool.">
<link rel="stylesheet" href="/style.css">
<link rel="alternate" type="application/rss+xml" href="/feed.xml">
</head><body>
<main>
<h1>skills.oriz.in</h1>
<p>${skills.length} agent skills. Junction into <code>~/.claude/skills/</code> via <a href="https://github.com/chirag127/agent-skills">agent-skills submodule</a>. <a href="/feed.xml">RSS</a> · <a href="/llms.txt">llms.txt</a></p>
<ul>${skills.map(s => `<li><a href="/${s.slug}.html">${s.slug}</a> — ${escapeHtml(s.frontmatter.description || '')}</li>`).join('')}</ul>
</main></body></html>`)

writeFileSync(path.join(OUT, 'llms.txt'), `# skills.oriz.in — ${skills.length} agent skills

${skills.map(s => `## ${s.slug}\n\n${s.frontmatter.description || ''}\n\nURL: ${SITE_URL}/${s.slug}.html\n`).join('\n')}`)

writeFileSync(path.join(OUT, 'sitemap.xml'), `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${skills.map(s => `<url><loc>${SITE_URL}/${s.slug}.html</loc></url>`).join('\n')}
</urlset>`)

writeFileSync(path.join(OUT, 'feed.xml'), `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"><channel>
<title>skills.oriz.in</title>
<link>${SITE_URL}</link>
<description>Chirag's agent skills</description>
${skills.map(s => `<item><title>${escapeHtml(s.slug)}</title><link>${SITE_URL}/${s.slug}.html</link><description>${escapeHtml(s.frontmatter.description || '')}</description><guid>${SITE_URL}/${s.slug}.html</guid></item>`).join('\n')}
</channel></rss>`)

writeFileSync(path.join(OUT, 'schema.json'), JSON.stringify({
  format: 'agent-skills-bundle',
  count: skills.length,
  bundle_url: SITE_URL,
  source: 'https://github.com/chirag127/agent-skills',
}, null, 2))

writeFileSync(path.join(OUT, 'style.css'), readFileSync(path.join(REPO_ROOT, 'dist', 'knowledge', 'style.css'), 'utf8'))

console.log(`build-skills: emitted ${skills.length} pages + llms.txt + sitemap + feed.xml`)
