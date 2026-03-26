# ChatGPT

ChatGPT is a general AI assistant that is strongest at explanation, structured comparison, reframing vague problems, and supporting communication-heavy work.

## What It Is

Use ChatGPT when the task is still partly conceptual and you need better reasoning before you need exact file-aware execution.

## Best For

- learning support
- architecture comparison
- research framing
- writing support
- speaking practice

## Not Good For

- exact repository edits without local context
- trusted factual output without validation
- large code changes that need file-accurate execution

## Strengths

- flexible reasoning across many domains
- strong at clarifying vague questions
- good for trade-off analysis and structured rewriting

## Weaknesses

- can sound more certain than it should
- may miss repository-specific constraints
- can generate convincing but unverified technical claims

## Best Use Cases

- compare technologies before implementation starts
- summarize a difficult concept from study notes
- brainstorm trade-offs for architecture decisions
- turn a vague problem into a clearer plan
- rewrite technical writing for clarity
- practice English explanations of technical topics

## Main Risks

- accepting fluent text as correct reasoning
- asking broad questions and getting generic answers
- using it as if it can safely edit local code by itself

## How To Use It Well

- define the task clearly
- ask for several options, not one answer
- ask for trade-offs, failure modes, and assumptions
- convert the result into your own note or decision

## How Not To Use It

- do not outsource first-principles thinking
- do not stop at the first polished answer
- do not treat it as a repository-aware editor

## Who Benefits Most

- learners moving from confusion to structure
- developers exploring design choices
- engineers improving technical writing and speaking

## Primary Modes

- learning
- research
- writing
- speaking
- review

## Example Workflow

1. define the topic or problem
2. ask for alternatives, not only one answer
3. ask for trade-offs and failure modes
4. convert the result into your own decision note
5. move to repository-aware tooling for code changes

## Example Prompt

```text
Compare Spark on raw Parquet files versus Delta Lake tables for a team that expects late-arriving data and recovery after partial failures. Focus on operational complexity, correctness, and downstream contract stability.
```

## Rule

Use ChatGPT to improve thinking quality.

Move to repository-aware tooling when the task depends on actual files and exact context.
