# AI Data Tools

This note covers how to use AI well in data engineering tasks where SQL, contracts, schemas, and pipeline assumptions can fail silently.

## What It Is

Data work benefits from AI when the task is ambiguous, repetitive, or review-heavy.

It suffers when AI output is accepted without checking schemas, contracts, grain, and edge cases.

## Best For

- draft SQL or transformation logic
- review pipeline design alternatives
- identify missing data quality checks
- translate business questions into candidate metrics or models
- review data contracts and schema-change risks

## Not Good For

- unvalidated analytical SQL
- guessed schema assumptions
- architecture choices made without system constraints

## Strengths

- useful at translating vague business requests into technical candidates
- helps surface missing checks and edge cases
- valuable in review-heavy data workflows

## Weaknesses

- can invent fields or tables
- can miss grain, late-arrival, replay, and schema-evolution concerns
- may speak confidently about incorrect platform assumptions

## Main Risks

- invalid joins or aggregation logic
- fake or mismatched columns
- missing partition or replay reasoning
- hidden contract instability downstream

## How To Use It Well

- ask for expected grain explicitly
- ask for duplicate, late-arrival, and schema assumptions
- require one or more validation checks
- compare generated logic against real data shape

## How Not To Use It

- do not ask for SQL without context
- do not publish pipeline logic before checking real contracts and sample outputs

## Primary Modes

- learning
- coding
- research
- review

## Example Prompt

```text
Write SQL to calculate monthly net revenue by customer.
Assume refunds should reduce revenue in the month they were issued.
State the expected grain of the result, the assumptions about duplicates, and one test I should run to validate correctness.
```

## Rule

Treat AI output as a draft that must be checked against real data shape and system constraints.
