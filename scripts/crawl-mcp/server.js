#!/usr/bin/env node
// crawl-md MCP server — no-key BFS crawler that emits markdown.
// Usage: stdio MCP server. Tool: crawl({ url, max_pages?, same_origin? })

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import TurndownService from "turndown";

const MAX_PAGES_CAP = 200;
const DEFAULT_MAX_PAGES = 50;
const REQUEST_TIMEOUT_MS = 15_000;
const USER_AGENT =
  "oriz-crawl-md/0.1 (+https://github.com/oriz-org/workspace)";

const turndown = new TurndownService({
  headingStyle: "atx",
  codeBlockStyle: "fenced",
  bulletListMarker: "-",
});
// Strip noise tags so the markdown stays agent-readable.
turndown.remove(["script", "style", "noscript", "iframe", "svg"]);

function sameOrigin(a, b) {
  try {
    return new URL(a).origin === new URL(b).origin;
  } catch {
    return false;
  }
}

function normalizeUrl(href, base) {
  try {
    const u = new URL(href, base);
    u.hash = "";
    return u.toString();
  } catch {
    return null;
  }
}

function extractLinks(html, baseUrl) {
  const out = [];
  const re = /<a\s+[^>]*href\s*=\s*(?:"([^"]+)"|'([^']+)'|([^\s>]+))/gi;
  let m;
  while ((m = re.exec(html)) !== null) {
    const href = m[1] ?? m[2] ?? m[3];
    if (!href) continue;
    if (/^(javascript:|mailto:|tel:|#)/i.test(href)) continue;
    const norm = normalizeUrl(href, baseUrl);
    if (norm) out.push(norm);
  }
  return out;
}

function extractTitle(html) {
  const m = /<title[^>]*>([^<]*)<\/title>/i.exec(html);
  return m ? m[1].trim() : "";
}

async function fetchHtml(url) {
  const ac = new AbortController();
  const t = setTimeout(() => ac.abort(), REQUEST_TIMEOUT_MS);
  try {
    const res = await fetch(url, {
      headers: { "user-agent": USER_AGENT, accept: "text/html,*/*;q=0.5" },
      redirect: "follow",
      signal: ac.signal,
    });
    if (!res.ok) return { ok: false, status: res.status, html: "" };
    const ct = res.headers.get("content-type") || "";
    if (!ct.includes("text/html") && !ct.includes("application/xhtml")) {
      return { ok: false, status: res.status, html: "", reason: "non-html" };
    }
    const html = await res.text();
    return { ok: true, status: res.status, html };
  } catch (err) {
    return { ok: false, status: 0, html: "", reason: String(err?.message || err) };
  } finally {
    clearTimeout(t);
  }
}

async function crawl({ url, max_pages = DEFAULT_MAX_PAGES, same_origin = true }) {
  const limit = Math.min(Math.max(1, Number(max_pages) || DEFAULT_MAX_PAGES), MAX_PAGES_CAP);
  const visited = new Set();
  const queue = [url];
  const pages = [];
  const errors = [];

  while (queue.length && visited.size < limit) {
    const u = queue.shift();
    if (visited.has(u)) continue;
    if (same_origin && !sameOrigin(u, url)) continue;
    visited.add(u);

    const { ok, status, html, reason } = await fetchHtml(u);
    if (!ok) {
      errors.push({ url: u, status, reason: reason || `http ${status}` });
      continue;
    }

    const title = extractTitle(html);
    const md = turndown.turndown(html);
    pages.push(
      `# ${title || u}\n\n_source: ${u}_\n\n${md}`
    );

    if (visited.size < limit) {
      for (const link of extractLinks(html, u)) {
        if (!visited.has(link)) queue.push(link);
      }
    }
  }

  const header = [
    `<!-- crawl-md: ${pages.length} page(s), ${errors.length} error(s), start=${url} -->`,
    errors.length
      ? `<!-- errors: ${errors.map((e) => `${e.url} (${e.reason})`).join("; ")} -->`
      : "",
  ]
    .filter(Boolean)
    .join("\n");

  return `${header}\n\n${pages.join("\n\n---\n\n")}`;
}

const server = new Server(
  { name: "crawl-md", version: "0.1.0" },
  { capabilities: { tools: {} } }
);

const TOOL = {
  name: "crawl",
  description:
    "BFS-crawl a URL and return the pages as concatenated markdown. Same-origin by default, capped at 200 pages.",
  inputSchema: {
    type: "object",
    properties: {
      url: { type: "string", description: "Seed URL to crawl." },
      max_pages: {
        type: "integer",
        minimum: 1,
        maximum: MAX_PAGES_CAP,
        default: DEFAULT_MAX_PAGES,
        description: `Max pages to fetch (default ${DEFAULT_MAX_PAGES}, cap ${MAX_PAGES_CAP}).`,
      },
      same_origin: {
        type: "boolean",
        default: true,
        description: "Restrict crawl to the seed URL's origin.",
      },
    },
    required: ["url"],
  },
};

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: [TOOL] }));

server.setRequestHandler(CallToolRequestSchema, async (req) => {
  if (req.params.name !== "crawl") {
    throw new Error(`Unknown tool: ${req.params.name}`);
  }
  const args = req.params.arguments || {};
  if (!args.url || typeof args.url !== "string") {
    throw new Error("`url` is required and must be a string.");
  }
  const text = await crawl({
    url: args.url,
    max_pages: args.max_pages,
    same_origin: args.same_origin,
  });
  return { content: [{ type: "text", text }] };
});

const transport = new StdioServerTransport();
await server.connect(transport);
