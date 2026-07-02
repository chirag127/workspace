---
type: rule
title: "Draft ≠ send: external comms need explicit approval"
description: "Never send/publish/post/comment/PR-file externally without explicit human approval. Draft means draft. Insurance-agent-sent-email pattern is the failure mode this prevents."
tags: [agent, safety, external-comms, approval, email, github]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/own-memory-rent-intelligence
  - rules/interaction/no-card-on-file
---

# Draft ≠ send

## The rule

When operating on **external state** — anything that leaves your machine and touches another human or a third-party service — DRAFT ONLY. Never auto-execute the send/publish/post step without explicit user approval in the same turn.

## The failure mode this prevents

Nikita's Lemonade insurance story (2026-01): agent found a rejection email, drafted a reply, user ignored the draft — agent SENT it anyway. Ended up starting a legal argument with an insurance company. It happened to work out. It usually doesn't.

Agents that act with authority they weren't granted are out of policy, even when the outcome is good. Especially when the outcome is good — reinforces the anti-pattern.

## What counts as "external state"

| External (draft, get approval) | Internal (standing authorisation) |
|---|---|
| Email via Resend or any provider | git commit to own repo |
| GitHub issue create/comment/close | Read/Edit/Write inside workspace |
| GitHub PR file/comment/merge | pnpm install / test / build |
| PR review comments on upstream | Local script execution |
| Tweet, LinkedIn post, Mastodon toot | Umbrella pointer bump + push |
| Slack/Discord/Telegram message | Submodule commit + push (own repos) |
| npm publish, VSC marketplace publish | Reading MCP resources |
| Domain registrar API call | Rebuild of derived config files |
| Payment API call | |
| Anything that arrives in another human's notification | |

## Approval mechanics

Before every external action:
1. Show the exact content that will be sent (email body, PR title+body, issue text).
2. Say what will be sent, to whom, on what URL/address.
3. Wait for the user to say "send" / "yes" / "post" / "file it" — an unambiguous go-signal.
4. Send only after go-signal.

**Ambiguity = default to draft.** "Sure" said in a different context ≠ approval for the send that's currently on-screen.

## What COUNTS as go-signal

- Direct: "send", "post", "file it", "publish", "go ahead", "yes send"
- Implicit only when: user typed "reply to X" as the initial instruction AND the drafted content is what they'd expect — even then, prefer showing the draft first

## What does NOT count

- "Yes" in response to a different question in the same turn
- User being silent after seeing a draft
- User approving one item ≠ approval for the next similar item
- "Sounds good" on the plan ≠ approval to execute the plan's send-step

## Standing authorisation exceptions

Per `AGENTS.md` § Standing authorisation, agents may commit + push to `main` on `chirag127/*` **without further prompting**. This exemption does NOT extend to external comms — even to a repo you own, the moment a PR/issue/comment reaches someone else's notification, get approval first.

## Anti-patterns

- ❌ Agent drafts + sends in the same tool call
- ❌ Agent replies to a maintainer's PR comment without showing you the reply first
- ❌ Agent files an upstream issue based on your one-line report without showing the body
- ❌ Agent emails a vendor from a subagent that you can't see the output of before send
- ❌ "The user asked me to review PRs" → agent starts closing/merging PRs without approval

## Cross-refs

- [`own-memory-rent-intelligence`](./own-memory-rent-intelligence.md) — the broader principle this instantiates
- [`terse-issues-less-hallucination`](./terse-issues-less-hallucination.md) — even after approval, keep external comms short
- [`thank-maintainers`](./thank-maintainers.md) — even after approval, close the thanks
- Source: Nikita @ Lemonade / open-claw agent 2026-01, distilled by Nate B Jones 2026-06
