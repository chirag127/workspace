---
type: decision
title: "LangChain ecosystem — deferred, revisit 2026-10-02"
description: "LangChain / LangGraph / LangSmith / integrations. Not adopted, not rejected. Current MCP + skills + AGENTS.md stack covers the same surface. Revisit in 3 months if real gaps surface."
tags: [stack, ai, orchestration, langchain, langsmith, langgraph, deferred]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/own-memory-rent-intelligence
  - rules/agent/mcp-config-single-source-of-truth
  - rules/development/no-rebuilding-free-software
---

# LangChain — deferred

## Decision

**Not adopting** LangChain, LangGraph, LangSmith, or integrations layer. **Not rejecting** either — set a review checkpoint 2026-10-02.

## Why deferred (not rejected outright)

The pitch — chains + tools + memory + tracing — maps 1:1 to what MCP + skills + `knowledge/` + Claude Code's built-in traces already deliver. But:

1. Multi-agent orchestration is evolving fast. LangGraph's graph-based branching MIGHT become useful when subagent orchestration outgrows what `Agent` tool + `pipeline()` primitives cover.
2. LangSmith's structured eval framework has no direct MCP equivalent yet. If eval discipline matures, it may fill a real gap.
3. The [`no-rebuilding-free-software`](../../rules/development/no-rebuilding-free-software.md) rule cuts both ways: adopting LangChain is renting a rebuild of your stack; but skipping observability tools is rebuilding LangSmith yourself with grep-through-transcripts.

## Why not adopt now

- **Duplicates current stack.** Chains ≈ skills. Tools ≈ MCP. Memory ≈ `knowledge/`. Tracing ≈ CC's transcript + `showThinkingSummaries`. Integrations ≈ MCP servers via toolbox.
- **Framework tax.** LangChain-Python conflicts with the TypeScript-first pipeline stack ([`pipeline-stack-2026-07-01`](../stack/pipeline-stack-2026-07-01.md)). LangChain-JS exists but the ecosystem is Python-heavy.
- **No hit limit.** Zero MCP + skills workflows have failed for lack of graph-based branching or LangSmith-style tracing (2026-07-02).
- **Platform absorption in progress.** Cursor 3.9, Antigravity 2.0, and OpenCode are shipping equivalents natively. Waiting = less lock-in.

## Review checkpoint

**Revisit 2026-10-02.** Trigger a re-evaluation if:

- ≥3 concrete workflows fail because MCP + skills can't handle branch/loop/merge cleanly
- LangSmith adds an integration OR public consumer that makes cost/benefit clear
- Anthropic / OpenAI / Google ship first-party equivalents that are portable

If none of those, extend deferral another 3 months.

## Cross-refs

- [`own-memory-rent-intelligence`](../../rules/agent/own-memory-rent-intelligence.md) — the reason MCP + skills is our orchestration layer
- [`mcp-config-single-source-of-truth`](../../rules/agent/mcp-config-single-source-of-truth.md) — the mechanism
- [`no-rebuilding-free-software`](../../rules/development/no-rebuilding-free-software.md) — the constraint
- Source: user Q 2026-07-02 after Cracking the Cryptic-style LangChain marketing video
