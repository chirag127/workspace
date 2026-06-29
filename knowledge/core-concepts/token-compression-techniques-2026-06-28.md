---
type: concept
title: 'Token-compression techniques catalogue — researched 2026-06-28'
description: Survey of context-compression tools, techniques, agent levers
tags: [compression, tokens, headroom, rtk, caveman, mcp, performance, research, agent-tooling]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - core-concepts/headroom-internals-2026-06-27
  - rules/agent/caveman
  - rules/agent/ponytail
---

# Token-compression techniques catalogue

## How agent token budget splits per turn

Per [computingforgeeks benchmark](https://computingforgeeks.com/reduce-claude-code-token-usage-tools/):

| Category | Typical share | Lever |
|---|---|---|
| Cached system prompt + skills + MCP manifest | 30-50% | Cut MCPs, defer tools, slim skills |
| Tool call inputs + outputs (Read/Grep/Bash) | 30-45% | **The big lever** — RTK, codebase-memory, token-savior |
| Extended thinking (reasoning) | 10-30% | `MAX_THINKING_TOKENS=8000` cap |
| Visible output | 1-10% | Caveman, Hr output-shaper |

**Auto-compaction trap:** at ~93% of context window, agent summarises and restarts. Each compaction reads everything at full token rate, then pays again for the summary. Can fire 3-4× per long session at 100K+ tokens each. Compact deliberately at 60-70%, not blind at 93%.

## Tools we currently run

| Tool | Layer | Status | Source |
|---|---|---|---|
| **Headroom (Hr 0.27)** | Input proxy (`localhost:8787`) compressing chat + file context | ? Active. Memory + Code-Aware + Output-Shaper + --learn min-evidence=10 + budget $20/day | [chopratejas/headroom](https://github.com/chopratejas/headroom) |
| **RTK (Rust Token Killer)** | Shell-output compression (Bash hook rewrites `git status` ? `rtk git status`) | ? Installed (see speed-stack.cmd) | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) v0.28.2 |
| **Caveman** | Prose-style discipline (system prompt rule) | ? Active as `knowledge/rules/agent/caveman.md` (adapted, full level) | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) 77K? |
| **Ponytail** | Code-gen discipline (lazy senior dev ladder) | ? Active as `knowledge/rules/agent/ponytail.md` | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| **codebase-memory MCP** | Knowledge graph index (121K nodes / 214K edges over the umbrella) | ? Indexed; `.codebase-memory/graph.db.zst` 21MB, gitignored | Local |

## Tools evaluated, ranked by independent benchmark

Numbers from [computingforgeeks](https://computingforgeeks.com/reduce-claude-code-token-usage-tools/) — Ubuntu 24.04 VM, Claude Code 2.1.116, Sonnet 4.5, sindresorhus/ky repo (52 TS files). Baseline: 284,473 tokens / $0.2666 / 18 turns.

| Rank | Tool | Saved | Mechanism | Verdict for our setup |
|---|---|---|---|---|
| 1 | [Mibayy/token-savior](https://github.com/Mibayy/token-savior) | **-43%** | Symbol-navigation MCP (90+ tools) — replaces `Read file.ts` with `find_symbol Ky.timeout`. Tree-sitter AST. Persistent session memory. | **Try.** Highest savings. Use `core` profile (not `full` — 106 tools = 11K tokens of manifest tax). Best on typed langs (TS, Go, Rust). |
| 2 | [drona23/claude-token-efficient](https://github.com/drona23/claude-token-efficient) | **-40%** | 11 rules in a 619-byte CLAUDE.md. No code. Skip sycophantic openers, edit-not-rewrite, don't re-read unchanged files, stop when task done. | **Adopt the rule patterns.** Don't import the file (we have caveman). Cherry-pick "don't re-read unchanged files" + "stop when task done" — add to ponytail. |
| 3 | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) ultra | **-38%** | Output-prose compression: drop articles/pleasantries/hedging. 4 levels: lite, full, ultra, wenyan-ultra. | ? Active (full). **Consider ultra** for -1-5% more on top. Wenyan = classical Chinese, more aggressive but readability risk. |
| 4 | [ooples/token-optimizer-mcp](https://github.com/ooples/token-optimizer-mcp) | **-23%** | 65-tool MCP. Brotli-compressed SQLite cache. `smart_read`/`smart_grep`/`smart_glob` replace native. 7-phase hook lifecycle. | Heavier than Hr. Mostly overlaps Hr (cache + compress). **Skip — redundant with Hr.** |
| 5 | [alexgreensh/token-optimizer](https://github.com/alexgreensh/token-optimizer) | **-18%** | Plugin + hooks bundle | Skip. Lower savings than caveman alone. |
| 6 | [tirth8205/code-review-graph](https://github.com/tirth8205/code-review-graph) | **-5%** small / **-8.2× avg / -49× monorepo** | AST graph (tree-sitter). On PR review, computes minimal file set needed. | **Try on the umbrella.** 20 submodules = monorepo behaviour. Worth testing on a real PR. |
| 7 | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) | 0% on the test task / **-60-90% on noisy shell** | CLI proxy compressing terminal output. Bash hook auto-rewrites. | ? Installed. Shines on `cargo test` (-90%), `npm install` (-92%), `git diff` (-75%). Doesn't help on agent tasks that don't shell out heavily. |

**Smaller / specialty:**
- [mksglu/context-mode](https://github.com/mksglu/context-mode) — Playwright + log compression
- [zilliztech/claude-context](https://github.com/zilliztech/claude-context) — vector RAG, but paid Milvus/Zilliz cloud deps — **rejected** (card rule)
- [musistudio/claude-code-router](https://github.com/musistudio/claude-code-router) — model routing per task (Haiku for cheap turns)
- [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) — persistent session memory; overlaps Hr `--memory`

## Built-in Claude Code levers (cost-free, often higher impact than tools)

1. **Cap reasoning:** `MAX_THINKING_TOKENS=8000` — saves 20-40% on simple tasks
2. **Plan mode** (Shift+Tab) — explore before writing; saves wrong-path cost (often 50K tokens)
3. **`/effort none|low|medium|high|max`** — pin per task; mechanical work = `none`/`low`
4. **`/compact` with preservation hints:** `/compact Keep: file X, decision Y, error Z` — run at 60-70%, not 93%
5. **Statusline `ctx %` gauge** — visible context-burn meter
6. **Subagent dispatch** — Read/Grep fan-out in subagent's fresh context; only summary returns. 40-70% main-thread savings
7. **Skills over CLAUDE.md** — skills' frontmatter loads (~100 tokens each); body only when activated. Move anything >2KB out of CLAUDE.md
8. **MCP tool deferral** — `ENABLE_TOOL_SEARCH=auto` keeps MCP manifests out of cache prefix

## Compression mechanics (academic survey)

| Technique | What it does | Tool example |
|---|---|---|
| **Cache alignment** | Stabilize prompt prefix; move dynamic content to suffix; hit provider prefix-cache (30× cheaper reads) | Hr CacheAligner |
| **Structural compression** | tree-sitter AST drops comments/docstrings/unused imports | Hr CodeCompressor; RTK `rtk read -l aggressive` |
| **Selective context (LLMLingua, Selective-Context)** | Score each token/sentence importance via small model; drop low-value tokens | Hr Kompress-base (HF model) |
| **Recurrent context compression** | Compress old turns into summaries, keep recent verbatim | Claude Code `/compact`; Hr stale-read compression |
| **Retrieval-augmented (RAG)** | Don't put file in context; put a retrievable handle; fetch on demand | Hr CCR (`headroom_retrieve` tool); codebase-memory MCP |
| **Symbol navigation** | Replace file reads with symbol lookups (find_class, find_method) | Token Savior; LSP-based MCPs (Serena) |
| **Output shaping** | Trim verbose output via system-prompt rule | Caveman, Hr `--output-shaper` |
| **Cross-session memory** | SQLite/vector store of prior turns; recall on relevance | Hr `--memory`; claude-mem |
| **Deduplication / aggregation** | Group similar items (errors by type, files by dir) | RTK; Hr SmartCrusher |

## Anti-patterns

- ? `/model` switching mid-task — full cache rebuild
- ? `/effort` switching mid-task — full cache rebuild
- ? `/compact` blind at 93% — auto-compaction trap; do it deliberately at 60-70%
- ? Toggling `/fast` repeatedly — first toggle invalidates cache
- ? Adding MCP servers mid-session without `ENABLE_TOOL_SEARCH=auto` — invalidates prefix
- ? Letting Read/Grep run blindly on big files — use symbol navigation or Read with offset/limit
- ? Stacking multiple input-compression proxies (Hr + token-optimizer-mcp) — they overlap and cancel cache

## Cross-refs

- [[core-concepts/headroom-internals-2026-06-27]] — Hr internals
- [[rules/agent/caveman]] — Caveman discipline
- [[rules/agent/ponytail]] — Ponytail discipline
- [[rules/agent/preferences/never-recreate-headroom-without-entrypoint-check]] — Hr ops safety

---

# Round 2 — extended web research (2026-06-28)

Additional findings from keenable + linkup searches across academic compression papers, vendor blogs, and 2026-vintage benchmarks. Sources cited inline.

## Anthropic prompt cache mechanics (cache-alignment deep-dive)

Per [The Stack Stories — 84% bill cut](https://thestackstories.com/blog/prompt-caching-claude-cost-cuts-2026), [Brandon Wie](https://brandonwie.dev/posts/anthropic-prompt-cache-ttl), [dev.to — 90% cuts](https://dev.to/cursuri-ai/prompt-caching-with-claude-how-we-cut-ai-api-costs-by-90-in-production-2026-guide-35lo), and [Alex Spinov](https://dev.to/alex_spinov/prompt-cache-break-hit-rate-fell-100-to-40-in-40-lines-21mm):

| Fact | Implication for us |
|---|---|
| Cache reads = $0.30/M vs $3.00/M fresh = **10× cheaper** | Hr's CacheAligner is real money |
| Cache writes pay **+25% surcharge** over base price | Don't put a cache marker on unstable content |
| Default TTL = **5 min** (Anthropic silently cut from 1hr in March 2026) | Idle gaps =5 min evaporate cache. Long human pauses cost more than you think. |
| 1-hour TTL available via `"cache_control": {"type": "ephemeral", "ttl": "1h"}` | Worth setting only when hit rate is high enough to amortize the write |
| Cache key = **byte-for-byte prefix match** | Any timestamp/request-id/session-id baked into system prompt drops hit rate to ~0% |
| Processing order: **tools ? system ? messages (oldest ? newest)** | Cache breakpoints must respect this order |
| `/compact` reuses prefix cache (same system prompt + tools + CLAUDE.md) | Only the messages portion is paid afresh. So `/compact` is cheaper than `/clear` |

## LLMLingua family — Microsoft's prompt compressor stack

Sources: [LLMLingua 2026 — TokenMix](https://tokenmix.ai/blog/llmlingua-prompt-compression-2026), [CallSphere LLMLingua guide](https://callsphere.ai/blog/vw9g-prompt-compression-llmlingua-microsoft-2026), [arxiv "Prompt Compression in the Wild"](https://arxiv.org/pdf/2604.02985), [Microsoft LLMLingua github](https://github.com/microsoft/LLMLingua).

| Variant | Method | Compression | Quality drop |
|---|---|---|---|
| LLMLingua | Small LM scores tokens, drops low-importance | 4-20× | ~1.5pt accuracy |
| LongLLMLingua | Adds query-aware re-ranking for long-context QA | 4× tokens at +21.4% accuracy on NQ | actually improves perf |
| LLMLingua-2 | BERT-classifier (distilled) — faster | 20× | ~1.5pt |
| SCBench | KV-cache-centric benchmark | n/a | n/a (eval tool) |
| SecurityLingua | Compression-based jailbreak defense | n/a | guardrail |

**Hr already uses Kompress-base** (HF model) as its prose compressor — same idea as LLMLingua but trained on agentic traces. Hr is essentially "LLMLingua-on-a-proxy + cache-alignment + retrieval".

## Morphllm — 7 compression methods, benchmarked

Per [morphllm.com/context-compression](https://morphllm.com/context-compression) and [morphllm.com/flashcompact](https://morphllm.com/flashcompact). Factory.ai ran a 36,611-message benchmark on real coding sessions:

| Method | Score | Notes |
|---|---|---|
| Anchored summary (Factory.ai) | **3.70 / 5** | Best overall. Verbatim accuracy 98%, 50-70% compression |
| FlashCompact (Morph) | n/a | 3-4× longer sessions, 0% hallucination |
| ACON | 26-54% reduction at 95%+ accuracy | |
| LLMLingua | 20× max | 1.5pt accuracy drop |
| RTK | **89% avg** | Measured across git/test/build commands |

Key insight: **Cognition measured coding agents spend 60% of their time on search operations.** Most tokens wasted in search. Search-compress-apply is the production pattern.

## MCP server token tax

Per [MCP context bloat fix 2026](https://mcp.directory/blog/mcp-context-bloat-fix-2026-tool-search-code-mode-progressive-disclosure), [getunblocked MCP autopsy](https://getunblocked.com/blog/mcp-token-budget-autopsy), [getunblocked GitHub MCP 42K](https://getunblocked.com/blog/github-mcp-token-cost):

| MCP server | Tool definitions token cost |
|---|---|
| GitHub MCP (91 tools) | **~42,000 tokens** — biggest single offender |
| Playwright MCP | ~13,600 tokens |
| Speakeasy Dynamic Toolsets (400 tools) | ~410,000 ? ~8,000 with deferral (**96% savings**) |
| Atlassian mcp-compressor | 70-97% savings |
| Average MCP tool | 500-2,000 tokens each |

**Tool Search** (`ENABLE_TOOL_SEARCH=auto`) defers MCP tool definitions OUT of cache prefix. Joe Njenga measured **46.9% main-thread bloat reduction** with Claude Code 2.0's tool-search subagent. **Already enabled in our settings.json.**

**Action:** audit our 25+ MCP servers. The GitHub MCP alone is ~42K tokens. If we don't use 60% of its tools, that's pure waste.

## Model routing — 50-60% savings

Per [Most agents don't need Sonnet](https://dev.to/edwardkubiak/most-of-your-claude-code-agents-dont-need-sonnet-4587), [Reducing fleet costs](https://claudecodeguides.com/reducing-agent-fleet-costs-model-routing), [Claude Code Router](https://github.com/musistudio/claude-code-router):

- 70% of agent tasks are extraction/formatting/classification ? Haiku ($5/M) instead of Opus ($25/M)
- **5× cost difference**; quality often equivalent
- Pin subagent model in `.claude/agents/<name>.yaml`:
  ```yaml
  model: haiku  # or sonnet
  tools: [Read, Grep, Glob, WebFetch]
  ```
- Per-task: `--model haiku` on dispatch

Our setup uses Sonnet 4.6 as default per memory rule. **Action:** define a `researcher` subagent pinned to Haiku for read-heavy fan-outs.

## Skills — progressive disclosure (3-tier loading)

Per [claudecodeguides progressive disclosure](https://claudecodeguides.com/progressive-disclosure-claude-md-load-only-needed), [hatchworks Claude Skills](https://hatchworks.com/blog/claude/claude-skills), [duet.so complete guide](https://duet.so/en/en/guides/claude-code-skills-complete-guide):

| Tier | What loads | Cost | When |
|---|---|---|---|
| 1 — Metadata | YAML frontmatter only (name, description) | ~100-200 tokens per skill | Always, every session |
| 2 — SKILL.md body | The instructions | Variable | When model invokes the skill |
| 3 — Resources | Scripts, refs, templates referenced in SKILL.md | Variable | On-demand within skill execution |

**Math:** A 5,000-line CLAUDE.md costs 5K tokens × every API call. A 50-skill library costs ~5K tokens total at tier 1 (skills frontmatter), with only the activated skill's body loaded at tier 2.

**Action for us:** anything in CLAUDE.md/AGENTS.md/knowledge over 2KB should be a skill instead. Specifically:
- The `agent-minimum-context.md` rule (8.1KB) — convert to skill
- The compression catalogue I'm writing (8KB+) — convert to skill
- The long decision files — leave in knowledge but cite by skill description summary

## code-review-graph — specifics for monorepo PR review

Per [tirth8205/code-review-graph](https://github.com/tirth8205/code-review-graph), [Starlog deep-dive](https://starlog.is/articles/data-knowledge/tirth8205-code-review-graph), [Callsphere 87% reduction](https://callsphere.ai/blog/code-review-graph-87-percent-claude-bill-reduction):

- Tree-sitter AST ? SQLite graph (functions/classes/imports as nodes; calls/inheritance/test-coverage as edges)
- Single file at `.code-review-graph/graph.db` — no external DB
- Incremental updates via SHA-256 diff per file
- "Blast radius" engine: given changed file X, compute every caller, dependent, test affected
- Benchmarks: Flask 9.1×, Gin 16.4×, Next.js monorepo **49×** (27,732 files ? ~15)
- **Overlaps codebase-memory MCP we already have.** Different impl but same goal.

**Verdict:** Skip per earlier grill. Our codebase-memory MCP does AST + graph + query already (121K nodes / 214K edges). Adding code-review-graph would be 2nd impl, cache cancellation risk.

## drona23/claude-token-efficient — 40% from 11 rules

Per [computingforgeeks rank 2](https://computingforgeeks.com/reduce-claude-code-token-usage-tools/). Their 619-byte CLAUDE.md has these patterns. **Cherry-picked for our ponytail:**

1. Skip sycophantic openers
2. Prefer Edit over Write
3. **Don't re-read unchanged files** (NEW addition to ponytail)
4. **Stop once the task is done** (no "let me also..." wandering)
5. Reuse existing helpers before writing new ones (already in ponytail)
6. No speculative abstractions (already in ponytail)
7. Match surrounding style (already a rule)
8. Quote errors exactly (already in caveman)
9. Code blocks unchanged (already in caveman)
10. **Cap explanation at 3 lines for trivial fixes**
11. **No status updates** ("running grep..." — already in caveman)

**Action:** add #3, #4, #10 to ponytail. Cheap wins.

## Caveman ultra confirmed

Per [JuliusBrussee/caveman README](https://github.com/JuliusBrussee/caveman):
- lite = drop only filler ? ~25% savings
- **full = drop articles + filler + pleasantries ? ~38%** (was our setting)
- **ultra = telegraphic + drop hedging + transitions ? 40-43%** ? (current, locked 2026-06-28)
- wenyan-ultra = classical Chinese ? most aggressive, readability hit

## Final stack picture (our installed compression layers, top to bottom)

1. **Input proxy:** Headroom 0.27 on `:8787` — cache-align + Kompress + code-aware + output-shaper + memory + learn
2. **Knowledge index:** codebase-memory MCP — 121K nodes / 214K edges, AST graph
3. **Symbol navigation:** Serena MCP — LSP-based, language-server queries
4. **Shell output:** RTK 0.42.4 — 48.5% savings on 329 commands measured
5. **Prose discipline:** Caveman ULTRA — 40-43% output reduction
6. **Code discipline:** Ponytail — 7-rung lazy ladder
7. **Cache key hygiene:** No timestamps/IDs in system prompt; prefix-stable
8. **Tool deferral:** `ENABLE_TOOL_SEARCH=auto` — MCP manifests out of cache prefix
9. **Reasoning cap:** `MAX_THINKING_TOKENS=8000`
10. **Compaction discipline:** Manual `/compact Keep: …` at 60-70% (not auto at 93%)
11. **Subagent dispatch:** for fan-out Read/Grep (40-70% main-thread savings) — **not yet using**

## Web sources cited

- thestackstories.com/blog/prompt-caching-claude-cost-cuts-2026
- brandonwie.dev/posts/anthropic-prompt-cache-ttl
- dev.to/cursuri-ai prompt-caching 90% guide
- dev.to/alex_spinov prompt-cache-break
- dev.to/gabrielanhaia prompt-caching-90-caveat
- tokenmix.ai/blog/llmlingua-prompt-compression-2026
- callsphere.ai/blog/vw9g-prompt-compression-llmlingua-microsoft-2026
- arxiv.org/pdf/2604.02985 (Prompt Compression in the Wild)
- arxiv.org/pdf/2511.12281 (Cmprsr token-level compression)
- morphllm.com — context-compression / flashcompact / context-engineering
- mcp.directory/blog/mcp-context-bloat-fix-2026
- getunblocked.com — MCP token autopsy / GitHub MCP 42K
- atcyrus.com tool-search-claude-code
- claudecodeguides.com — many
- computingforgeeks.com/reduce-claude-code-token-usage-tools
- starlog.is — code-review-graph
- dev.to/stevengonsalvez code-review-graph
- shipyard.build/blog/reduce-claude-code-token-usage
- hatchworks.com Claude Skills
- duet.so/en/en/guides/claude-code-skills-complete-guide
- microsoft/LLMLingua github
