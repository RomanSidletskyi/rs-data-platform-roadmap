# AI Tools By Task

Use this guide to choose tools by workload rather than by brand popularity.

## Quick Selection Matrix

| Task | Usually Strongest Fit | Good Alternatives | Common Mistake |
| --- | --- | --- | --- |
| Repository-aware code changes | GitHub Copilot, Cursor-style IDE workflows | Codeium-like assistants for smaller scope | Using a general chat tool as if it knows your exact files |
| Broad exploration and topic framing | ChatGPT, Claude-style chat assistants | Gemini-style general assistants | Using IDE code completion for research |
| Fast web-style research | Perplexity-style research tools | Chat assistants plus manual validation | Treating fast summaries as verified fact |
| Architecture comparison | ChatGPT, Claude-style reasoning assistants | Notebook-style synthesis tools | Asking for one answer instead of several trade-off options |
| Code review and risk finding | Copilot plus explicit review prompts | Chat assistants with pasted code | Asking only for generic feedback |
| Writing and rewriting | ChatGPT, DeepL Write, Grammarly-style tools | Editor-based assistants | Letting style polishing erase technical precision |
| Technical summarization | ChatGPT, Notebook-style synthesis tools | Copilot chat for repository context | Summarizing before understanding source material |

## Detailed Comparison Criteria

Use this scale:

- High: strong fit for the criterion
- Medium: useful but context-dependent
- Low: weak fit for the criterion

### Repository-Aware Code Changes

| Tool Class | Best For | Weakest For | Speed | Depth | Context Awareness | Reliability | Effort To Use Well | Cost Sensitivity | Privacy Sensitivity | Beginner Friendliness | Advanced-User Leverage |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| GitHub Copilot / editor-native coding assistant | scoped implementation, review, tests | broad external research | High | Medium | High | Medium | Medium | Medium | Medium | High | High |
| Cursor-style IDE workflows | iterative edits plus navigation | high-level architecture strategy | High | Medium | High | Medium | Medium | Medium | Medium | Medium | High |
| Codeium-like completion-first tools | quick drafting of known patterns | deep refactors or review | High | Low | Medium | Low | Medium | High | Medium | High | Medium |
| General chat assistant | framing change before coding | exact local edits | Low | Medium | Low | Low | Medium | High | Medium | High | Medium |

### Architecture Exploration

| Tool Class | Best For | Weakest For | Speed | Depth | Context Awareness | Reliability | Effort To Use Well | Cost Sensitivity | Privacy Sensitivity | Beginner Friendliness | Advanced-User Leverage |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ChatGPT-style general assistant | trade-off framing, option comparison | exact repository edits | High | Medium | Medium | Medium | Medium | High | Medium | High | High |
| Claude-style reasoning assistant | long-form architecture analysis | quick code drafting | Medium | High | Medium | Medium | Medium | Medium | Medium | Medium | High |
| NotebookLM-style synthesis tool | bounded-source synthesis | landscape discovery | Medium | High | Medium | Medium | Medium | Medium | Medium | Medium | High |
| Perplexity-style research tool | landscape scan and source discovery | final architecture judgment | High | Low | Low | Low | Medium | Medium | Medium | High | Medium |

### Research And Discovery

| Tool Class | Best For | Weakest For | Speed | Depth | Context Awareness | Reliability | Effort To Use Well | Cost Sensitivity | Privacy Sensitivity | Beginner Friendliness | Advanced-User Leverage |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Perplexity-style research tool | breadth-first discovery | final decision notes | High | Low | Low | Low | Medium | Medium | Medium | High | Medium |
| ChatGPT-style assistant | structured synthesis after discovery | direct source discovery | Medium | Medium | Medium | Medium | Medium | High | Medium | High | High |
| NotebookLM-style tool | synthesis across selected sources | open web exploration | Medium | High | Medium | Medium | Medium | Medium | Medium | Medium | High |

### Writing And Rewriting

| Tool Class | Best For | Weakest For | Speed | Depth | Context Awareness | Reliability | Effort To Use Well | Cost Sensitivity | Privacy Sensitivity | Beginner Friendliness | Advanced-User Leverage |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ChatGPT-style assistant | structure, rewrite, alternative phrasings | final grammar-only polish | Medium | High | Medium | Medium | Medium | High | Medium | High | High |
| DeepL Write / Grammarly-style tools | final language polish | missing technical logic | High | Low | Low | Medium | Low | Medium | Medium | High | Medium |
| Coding assistant chat in editor | rewrite with repository context | broad communication work | Medium | Low | High | Medium | Medium | Medium | Medium | Medium | Medium |

## Tool Categories

### General Chat Assistants

Typical strengths:

- explanation
- comparison
- brainstorming
- reframing a vague task into a clearer one

Typical weaknesses:

- exact local file awareness
- safe automation of large code changes without review
- reliable source citation unless you verify externally

Best for:

- understanding
- research framing
- architecture alternatives
- writing support

### Coding Assistants

Typical strengths:

- working directly in the codebase
- editing files with context
- generating tests and refactors
- code review in concrete files

Typical weaknesses:

- broad market or tool research
- high-level strategic comparison without context

Best for:

- implementation
- refactoring
- tests
- repository-aware review

### Research Tools

Typical strengths:

- speed of discovery
- finding sources quickly
- summarizing multiple pages or viewpoints

Typical weaknesses:

- shallow acceptance of claims
- overconfidence in source quality

Best for:

- topic scanning
- first-pass research
- fast comparison before deeper validation

## Decision Heuristics

Choose a coding assistant when:

- the task depends on exact repository context
- the output is code that must be applied to files
- tests, imports, naming, or local conventions matter

Choose a general chat assistant when:

- the problem is still vague
- the goal is understanding, framing, or comparing options
- you need help forming better questions before implementation

Choose a research tool when:

- you need breadth first
- you are discovering the landscape of a topic
- you will validate the findings afterward

Choose a bounded-source synthesis tool when:

- you already have the source pack
- you need recurring themes, contradictions, or a digestible summary
- the problem is no longer discovery but synthesis

## Anti-Pattern

Do not use one tool for every stage.

A strong workflow often looks like this:

1. research tool or general assistant for discovery
2. chat assistant for decision framing
3. coding assistant for implementation
4. chat or coding assistant for review