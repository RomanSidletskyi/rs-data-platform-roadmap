# AI Workflows

This directory contains repeatable workflows for using AI from zero-level learning to architecture-level reasoning.

Each workflow should help move from question to verified result with less waste, less confusion, and better judgment.

## Included Workflows

- `how-to-learn-faster.md`: reduce friction while preserving understanding
- `learn-a-module-with-ai.md`: use AI to move through theory, tasks, and projects without shallow learning
- `ai-pair-programming.md`: use AI as a coding partner without giving away ownership of the design
- `ai-for-debugging.md`: isolate faults, test hypotheses, and verify fixes
- `ai-for-project-design.md`: shape architecture and requirements before coding
- `ai-for-research.md`: discover and compare options before deeper validation
- `ai-for-technical-writing.md`: improve issues, PR summaries, and architecture notes
- `english-for-developers.md`: improve language skill through real developer tasks
- `issue-triage-with-ai.md`: structure bug reports, scope unknowns, and improve triage quality
- `pr-review-replies-and-followups.md`: respond to review comments clearly and turn feedback into concrete follow-up work
- `adr-writing-with-ai.md`: write architecture decision records with explicit trade-offs
- `design-review-prep.md`: prepare for design review discussions with stronger assumptions and clearer language
- `interview-speaking-practice.md`: practice explaining systems, trade-offs, and debugging stories aloud

## Workflow Standard

Good workflows in this directory should include:

- a starting situation
- a concrete sequence of actions
- examples of strong prompts or questions
- validation steps
- common failure modes
- a clear explanation of why the workflow works

## Practice Map

These workflows are strongest when paired with the matching exercise layer in `../practical-exercises/`.

For architecture-heavy work, do not stop at the workflow alone.

Use the full loop:

1. workflow for framing and research
2. `../architecture-examples/README.md`
3. `../architecture-practice/README.md`
4. `../personal-operating-model/decision-journal.md`
5. `../personal-operating-model/mistakes-log.md`
6. `design-review-prep.md`

Suggested pairings:

- `ai-pair-programming.md` -> `../practical-exercises/01_ai_python_refactor/README.md`
- `ai-pair-programming.md` -> `../practical-exercises/02_ai_sql_generation/README.md`
- `ai-for-project-design.md` -> `../architecture-examples/README.md` -> `../architecture-practice/README.md` -> `../practical-exercises/03_ai_pipeline_design/README.md`
- `ai-for-debugging.md` and `pr-review-replies-and-followups.md` -> `../practical-exercises/04_ai_code_review/README.md`
- `ai-for-research.md` -> `../architecture-examples/README.md` -> `../architecture-practice/README.md` -> `../practical-exercises/05_ai_research_and_tool_comparison/README.md`
- `ai-for-technical-writing.md` -> `../practical-exercises/06_ai_technical_writing/README.md`
- `english-for-developers.md` -> `../practical-exercises/07_ai_english_for_developers/README.md`

The workflow explains the process.

The exercise measures whether you can actually execute it with discipline.