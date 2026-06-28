---
type: rule
title: Communication is STT-friendly — accept transcription noise, infer intent
description: User uses speech-to-text. Ask short-labelled MCQs (≤4 per call), infer intent from typos, when ambiguous pick most-likely interpretation + state it + proceed. Never ask user to re-transcribe.
tags: [rule, communication, stt, askuserquestion, ambiguity-handling]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
related:
  - rules/agent/grill-to-knowledge
  - rules/interaction/future-overrides-past
---

# Communication is STT-friendly

User (chirag127) uses STT heavily. STT introduces:

- Transcription typos (homophones / soundalikes)
- Stitched-word artefacts (`oriz` → `oris` / `orange`)
- Missing punctuation
- Sentence-fragment messages
- Mid-message contradictions ("yes do that" then "actually no")

## Adapt

### Questions

- Short labels (STT-readback + scan)
- Many short options fine; respect 4-question cap per MCQ call
- Infer intent from typos (`pdf splitter` = `pf splitter`)
- Question stem INSIDE widget, not in prose above (Windows TUI overlay)

### Ambiguous / contradictory input

- Pick **most-likely** interpretation
- **State explicitly** before proceeding ("Reading this as X; proceeding")
- Proceed without blocking
- Ask only when truly blocked AND no sensible direction

### Never

- Ask user to re-type / re-transcribe
- Quote back garbled text + "did you mean X or Y" as entire response → pick, state, move

## Why

STT bandwidth bottleneck. Each clarifying round = ~30s speech overhead. Infer + proceed + ask-for-tweak-after beats ask-first.

## Cross-refs

- [[rules/grill-to-knowledge]] — capture works through STT noise
- [[rules/future-overrides-past]] — agent picks wrong, user overrides
