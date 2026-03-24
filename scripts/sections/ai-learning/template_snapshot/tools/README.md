# AI Tools

This directory is a practical catalog for choosing AI and adjacent tools by task, not by hype.

The goal is not to collect product names.

The goal is to understand which tool category fits which problem, what each tool does well, where it breaks down, and how to use a small stack deliberately.

## Tool Categories

### General AI Assistants

Use for:

- explanation
- reframing vague problems
- structured comparison
- first-pass architecture and learning questions

Files:

- `chatgpt.md`
- `claude.md`
- `gemini.md`

### Coding Assistants

Use for:

- repository-aware implementation
- refactoring
- code review support
- test expansion and edge-case checks

Files:

- `github-copilot.md`
- `cursor-ide.md`
- `codeium.md`

### Search And Research Tools

Use for:

- fast landscape scanning
- documentation discovery
- comparing options before deeper validation

Files:

- `perplexity.md`
- `notebooklm.md`
- `ai-data-tools.md`

### Note-Taking And Knowledge Tools

Use for:

- capturing reusable insights
- synthesizing a bounded set of materials
- keeping one source of truth for decisions and notes

Files:

- `notebooklm.md`
- `obsidian-ai.md`
- `raycast-ai.md`

### Writing And Editing Tools

Use for:

- rewriting for structure and clarity
- grammar and tone cleanup
- polishing issues, PR notes, summaries, and architecture notes

Files:

- `deepl.md`
- `deepl-write.md`
- `grammarly.md`

### Meeting, Transcript, And Summarization Tools

Use for:

- transcribing technical audio
- turning spoken material into searchable notes
- extracting follow-up tasks from recordings

Files:

- `whisper-tools.md`
- `notebooklm.md`

### Translation And Language Tools

Use for:

- precise translation
- phrase interpretation in context
- assisted technical reading

Files:

- `reverso-context.md`
- `readlang.md`
- `lingq.md`
- `language-reactor.md`

### Pronunciation And Speaking Tools

Use for:

- pronunciation correction
- low-friction speaking practice
- explaining technical ideas aloud

Files:

- `elsa-speak.md`
- `speechling.md`
- `chatgpt-voice.md`
- `youglish.md`

### Vocabulary And Spaced Repetition Tools

Use for:

- long-term phrase retention
- recurring review of high-value technical language
- active recall instead of passive rereading

Files:

- `anki.md`
- `mochi.md`
- `quizlet.md`
- `duolingo.md`
- `clozemaster.md`

## Tool Note Standard

Every tool note in this directory should answer the same questions:

- what it is
- what it is best for
- what it is not good for
- strengths
- weaknesses
- best use cases
- risks
- how to use it well
- how not to use it
- who benefits most
- which modes it serves most: learning, coding, research, writing, speaking, or review

## Selection Heuristic

Choose tools by the dominant uncertainty:

- vague problem or comparison need -> general assistant
- exact code change in real files -> coding assistant
- need to scan a landscape quickly -> research tool
- need to preserve insights over time -> knowledge tool
- need to tighten prose without changing substance -> writing tool
- need to improve reading, listening, speaking, or retention -> language tool stack

## Rule

Do not optimize for the number of tools.

Optimize for the smallest stack that repeatedly helps you think better, decide faster, and validate more reliably.

## Where To Practice

Use this directory together with `../practical-exercises/`.

Suggested mapping:

- coding assistants plus general AI assistants -> `../practical-exercises/01_ai_python_refactor/README.md`
- general AI assistants for SQL drafting and validation thinking -> `../practical-exercises/02_ai_sql_generation/README.md`
- research and knowledge tools -> `../practical-exercises/03_ai_pipeline_design/README.md`
- coding assistants for review support -> `../practical-exercises/04_ai_code_review/README.md`
- research and comparison tools -> `../practical-exercises/05_ai_research_and_tool_comparison/README.md`
- writing and editing tools -> `../practical-exercises/06_ai_technical_writing/README.md`
- language tools -> `../practical-exercises/07_ai_english_for_developers/README.md`

## Suggested Baseline Stacks

### Minimal Learning And Development Stack

- `chatgpt.md`
- `github-copilot.md`
- `perplexity.md`
- `deepl.md`

### Architecture And Research Stack

- `claude.md`
- `chatgpt.md`
- `perplexity.md`
- `notebooklm.md`
- `obsidian-ai.md`

### English For Developers Stack

- `deepl.md`
- `reverso-context.md`
- `language-reactor.md`
- `anki.md`
- `chatgpt-voice.md`

### Communication And Writing Stack

- `chatgpt.md`
- `deepl-write.md`
- `grammarly.md`
- `obsidian-ai.md`