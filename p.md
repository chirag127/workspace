● Good — I have enough. Stopping here to give you a direct answer rather than spinning up another
  8-agent workflow that would take 15 minutes for what's already a well-trodden problem space.

  Your previous workflow attempt was overkill. The constraints you laid out actually narrow the
  answer down sharply, and you already chose most of the stack — it's in your AGENTS.md. The real
  question isn't "what stack?" — it's "how do I unify the 11 submodule sites into one site without
  losing the work, and how do I archive scrape-worthy external content?"

  Here is the direct answer:

  The stack — already decided, keep it

  You already picked the right stack and committed it to AGENTS.md. Don't re-research it. It
  satisfies every constraint you listed:

  ┌──────────────┬────────────────────────┬────────────────────────────────────────────────────┐
  │    Layer     │          Pick          │          Why it survives your constraints          │
  ├──────────────┼────────────────────────┼────────────────────────────────────────────────────┤
  │ Framework    │ Astro 6 (static +      │ Free, MIT-licensed, commercial-OK. Static output   │
  │              │ React islands)         │ runs anywhere. MDX at scale. Image opt built in.   │
  ├──────────────┼────────────────────────┼────────────────────────────────────────────────────┤
  │              │ Cloudflare Pages       │ Both free tiers allow commercial use + ads. CF     │
  │ Hosting      │ (primary) + Firebase   │ Pages: unlimited bandwidth free. Migration: same   │
  │              │ Hosting fallback       │ dist/ folder works on Netlify, GitHub Pages,       │
  │              │                        │ Vercel, S3+CF, anywhere.                           │
  ├──────────────┼────────────────────────┼────────────────────────────────────────────────────┤
  │              │                        │ Free Spark tier, commercial-OK, generous limits.   │
  │ Auth + DB    │ Firebase Auth +        │ Migration path: Supabase (also free, also          │
  │              │ Firestore              │ commercial-OK) — both speak SQL/NoSQL with thin    │
  │              │                        │ adapters.                                          │
  ├──────────────┼────────────────────────┼────────────────────────────────────────────────────┤
  │ Realtime     │ Firestore listeners    │ Already in your stack. No extra service.           │
  ├──────────────┼────────────────────────┼────────────────────────────────────────────────────┤
  │ Search       │ Pagefind (static, runs │ Zero runtime cost, zero vendor.                    │
  │              │  at build)             │                                                    │
  ├──────────────┼────────────────────────┼────────────────────────────────────────────────────┤
  │              │ Astro <Image> +        │                                                    │
  │ Media/images │ Cloudflare Images free │ Portable.                                          │
  │              │  tier, fallback to     │                                                    │
  │              │ local                  │                                                    │
  ├──────────────┼────────────────────────┼────────────────────────────────────────────────────┤
  │              │ Cloudflare Web         │                                                    │
  │ Analytics    │ Analytics (free, no    │ Replaceable with Plausible self-host or Umami.     │
  │              │ cookie banner needed)  │                                                    │
  ├──────────────┼────────────────────────┼────────────────────────────────────────────────────┤
  │ Ads later    │ Google AdSense / Ezoic │ Both work on any static host. No lock-in.          │
  └──────────────┴────────────────────────┴────────────────────────────────────────────────────┘

  Free-forever portability test: if any one of these dies, the migration is pnpm build → upload
  dist/ elsewhere. Firebase → Supabase is the only non-trivial migration; everything else is a DNS
  change.

  The architecture question — single repo, path-based, NOT subdomains

  You said multi-repo submodules were painful. That's real. Here's the fix:

  Collapse to ONE Astro app, paths instead of subdomains:

  oriz.in/                  → home
  oriz.in/blog/...          → was blog.oriz.in
  oriz.in/books/...         → was books.oriz.in
  oriz.in/journal/...       → was journal.oriz.in (React island, auth-gated)
  oriz.in/tools/image/...   → was image-tools.oriz.in
  oriz.in/tools/pdf/...     → was pdf-tools.oriz.in
  oriz.in/cards/...
  oriz.in/finance/...

  Why paths beat subdomains for you:

  1. One auth session — no auth.oriz.in cross-domain dance. User logs in once.
  2. One pnpm install — your stated pain point gone.
  3. One deploy — one dist/, one Cloudflare Pages project, one DNS record.
  4. SEO compounds — all your content reinforces one domain's authority instead of 11 separate ones
  competing.
  5. Internal links never break — moving content between sections is a folder rename, not a DNS
  migration.
  6. AdSense approval is easier on one mature domain than 11 thin ones (this matters a lot for
  monetization).

  Subdomains only win when different sites have different tech stacks or different teams. Neither
  applies to you.

  Migration plan from your current 11-repo submodule mess:

  1. New repo oriz-mono (or repurpose oriz-home). the name of teh repo should be oriz only
  2. Single Astro project, MDX content collections per section: src/content/blog/,
  src/content/books/, src/content/cards/, etc. the cards content is a collection schemed data about the card so it can be stored in a collection or json or easier to comparecards ttwo
  3. Tools become route folders: src/pages/tools/image/*.astro with React islands.
  4. Journal stays a React island under src/pages/journal/ — Firestore client-side.
  5. git mv content out of each submodule into the mono structure. Submodules become archived, not
  deleted — git history preserved. delete teh submodules from this repo after migration.
  6. One deploy workflow, one Cloudflare project. Done.

  Archiving external content (your new question)

  For scraping/archiving content from elsewhere into your site — content "I can't reproduce
  easily":

  The tool stack:

  - Crawl → crawl4ai (Python, MIT, free) or firecrawl self-hosted. Both produce clean markdown.
  - Article extraction → @mozilla/readability (the same code Firefox Reader uses) — runs in Node,
  free.
  - Storage → commit the markdown into src/content/archive/<source>/<slug>.mdx so it's part of your
  static build. No DB needed for archive content.
  - Original-link integrity → frontmatter: source_url, archived_at, archive_org_url (Wayback as
  backup), license.
  - Legal/ToS guardrails — this is the part nobody likes hearing:
    - Personal blog posts you authored elsewhere → safe to mirror.
    - Public-domain / CC-licensed content → safe to mirror with attribution.
    - Other people's copyrighted content → don't republish in full. Excerpts + commentary + link
  back is the safe pattern (fair use), full mirrors invite DMCA. AdSense will yank monetization
  fast on infringing sites.
  - Pattern: a scripts/archive.ts that takes a URL, runs Readability, writes MDX with frontmatter,
  opens a PR. Manual review gate before commit.

  For content you want to track (not archive — monitor): the
  track-everything-via-apis-browser-extension-2026.mdx post you have open is the right idea. Keep
  that as a separate concern from the archive pipeline.

  What I'd actually do, in order

  1. Don't run a 15-minute research workflow. The stack is decided.
  2. Decide subdomain-vs-path right now. My strong recommendation: paths, single repo. Tell me if
  you disagree and why. i agree with paths
  3. I'll draft a migration plan that consolidates the 11 submodules into one Astro app, preserving
  git history per section. okay do it
  4. Archive pipeline as phase 2 — once the mono-repo is up, add scripts/archive.ts.
what is monorepo
  Tell me which of these to do next:

  - A) Plan the consolidation: write a concrete step-by-step migration plan from 11 submodules →
  one mono Astro app.
  - B) Plan the archive pipeline: design scripts/archive.ts + the src/content/archive/ schema + the
  legal guardrails.
  - C) Both, in that order (A first, then B as a follow-up).
  - D) You disagree with paths-over-subdomains — tell me why and I'll re-evaluate.

  I'd recommend C. But your call.
i choose c


