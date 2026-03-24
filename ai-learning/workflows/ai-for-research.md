# AI For Research

## Goal

Use AI to discover, compare, and structure information before making technical decisions.

## Scenario

You need to compare technologies, platform choices, practices, or tool stacks.

The risk is ending the research at the summary layer instead of converting it into defensible judgment.

## Workflow

1. Define the exact question.
2. Ask for the landscape first, not the final answer.
3. Narrow the options.
4. Compare trade-offs explicitly.
5. Validate the strongest claims against documentation or real examples.
6. Convert the result into a short decision note.

## Example Prompt

```text
Compare Delta Lake and Apache Iceberg for a team that expects Spark first today but may need multi-engine reads later. Focus on operational complexity, table maintenance, and data contract implications.
```

## Validation

Before trusting the research outcome, check:

- which claims came from primary documentation versus summary
- whether the comparison criteria match the actual scenario
- whether at least one real example or architecture pattern supports the conclusion
- whether the final note explains why rejected options lost

## Failure Modes

- asking for one universal winner
- confusing fast discovery with verified evidence
- skipping the step where research becomes a written decision

## Why This Works

This workflow separates discovery from judgment.

AI speeds up landscape scanning, but the final value comes from explicit comparison plus validation.

## Real Example

Question:

Should a small data platform standardize on Delta Lake or keep raw Parquet plus custom recovery logic?

Architecture-heavy criteria:

- replay and recovery complexity
- schema change handling
- downstream contract stability
- engine compatibility now versus later

Code-backed case:

```sql
MERGE INTO curated.customer_orders AS target
USING staging.customer_orders AS source
ON target.order_id = source.order_id
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *
```

The SQL alone is not the decision.

The research question is whether the surrounding table format and metadata model make this kind of workflow operationally trustworthy.

## Failure Mode To Avoid

Do not let the research stop at AI-generated summaries.

Use them to focus the investigation, not to finish it prematurely.