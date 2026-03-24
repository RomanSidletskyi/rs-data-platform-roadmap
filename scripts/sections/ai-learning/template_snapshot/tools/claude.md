# Claude

Claude-style assistants are strongest when you need patient long-form reasoning, structured comparison, and careful architecture writing.

## What It Is

Use Claude-style tools when the answer needs depth, explicit trade-offs, and stronger structure than quick ideation alone.

## Best For

- architecture exploration
- trade-off analysis
- ADR review
- long-form technical writing

## Not Good For

- exact repository edits
- final technical decisions without evidence
- quick code completions inside an editor

## Strengths

- strong long-form reasoning
- good at surfacing assumptions and rejected options
- useful for deliberate architecture and writing workflows

## Weaknesses

- can still overstate confidence
- slower than lighter tools for quick drafting
- lacks exact local codebase awareness

## Best Use Cases

- comparing system design options
- rewriting design notes clearly
- reviewing trade-offs and assumptions
- reasoning through complex architectural choices

## Main Risks

- using elegant prose as a proxy for strong design
- skipping validation once the reasoning sounds coherent

## How To Use It Well

- provide the scenario, constraints, and non-goals
- ask for several options and why each could fail
- force explicit comparison between chosen and rejected options

## How Not To Use It

- do not ask for one universal best design
- do not use it as if it knows local system behavior automatically

## Who Benefits Most

- engineers moving into design and architecture work
- writers of ADRs, system notes, and review prep documents

## Primary Modes

- research
- writing
- review

## Example Workflow

1. write the scenario yourself
2. ask for two to four architecture options
3. ask for trade-offs, risks, and failure recovery implications
4. choose one option deliberately
5. convert it into an ADR or design note

## Rule

Ask for alternatives and failure modes, not only a single recommendation.