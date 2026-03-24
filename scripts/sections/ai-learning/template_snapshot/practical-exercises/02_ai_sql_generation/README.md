# AI SQL Generation

## Goal

Learn how to use AI to draft SQL while keeping control over grain, correctness, and validation.

## Read Before

- `../../comparisons/ai-tools-by-task.md`
- `../../workflows/ai-pair-programming.md`
- `../../tools/chatgpt.md`

## Read After

- `../05_ai_research_and_tool_comparison/README.md`
- `../../personal-operating-model/note-capture.md`
- `../../personal-operating-model/mistakes-log.md`

## Scenario

You need a query for an analytical or transformation task, but the biggest risk is not syntax.

The biggest risk is wrong business logic, wrong grain, or silent duplication.

## Tasks

1. Define the exact metric or output table grain.
2. Ask AI to draft the SQL.
3. Ask AI to state assumptions explicitly.
4. Review joins, filters, deduplication, and aggregation logic yourself.
5. Define at least two checks that would catch incorrect results.
6. Rewrite the query or prompt if the first draft is logically weak.

## Deliverables

- the prompt used
- the generated SQL
- your reviewed version
- validation checks
- a note about where the first draft was risky

## What This Exercise Trains

- SQL reasoning beyond syntax
- explicit assumption handling
- AI-assisted validation thinking

## Failure Mode To Avoid

Do not accept a query just because it looks syntactically clean.

## Evaluation Sheet

Score the final SQL outcome from 1 to 5:

- grain clarity: is the target output grain explicit and preserved
- logic quality: are joins, filters, deduplication, and aggregation coherent
- assumption visibility: are business and data assumptions stated clearly
- validation strength: do the checks meaningfully test for wrong results
- rewrite discipline: did you improve the weak draft instead of trusting it blindly

Use this interpretation:

- 1-2: SQL looks plausible but logic is weak or unchecked
- 3: acceptable query with partial validation
- 4: strong SQL reasoning with clear checks
- 5: disciplined analytical SQL work with explicit assumptions and robust validation

## Worksheet Template

### Task Definition

Metric or output table:

Required grain:

Key business rules:

### AI Draft

Prompt used:

Generated SQL summary:

### Review Notes

Join review:

Filter review:

Deduplication review:

Aggregation review:

### Final Query Decision

What changed from the first draft:

Why those changes were necessary:

### Validation Checks

- check 1:
- check 2:

Risk in the first draft:

### Personal System Capture

Decision journal entry:

Mistake to log:

### Scorecard

- grain clarity: __/5
- logic quality: __/5
- assumption visibility: __/5
- validation strength: __/5
- rewrite discipline: __/5

Lowest score and why:

Evidence for the score:

### Reflection

- what the first draft got wrong:
- what AI helped with:
- what still required your own SQL reasoning:

## Filled Example

### Task Definition

Metric or output table:

Daily paid orders by customer.

Required grain:

One row per `customer_id` per `order_date`.

Key business rules:

- count only paid orders
- ignore duplicate payment events for the same order

### AI Draft

Prompt used:

Write SQL for daily paid orders by customer using orders and payments tables.

Generated SQL summary:

The AI draft joined orders to payments and counted rows grouped by customer and date.

### Review Notes

Join review:

The draft joined directly to payments without handling multiple payment rows per order.

Filter review:

The draft filtered for successful payments but did not define which payment state was final.

Deduplication review:

The draft needed a deduplicated payment subquery at the order grain before aggregation.

Aggregation review:

Counting joined rows would overcount paid orders if one order had multiple payment events.

### Final Query Decision

What changed from the first draft:

Added a payment-deduplication step before joining to orders and then aggregated at customer-date grain.

Why those changes were necessary:

Without deduplication, the metric would silently inflate.

### Validation Checks

- compare the final result with a fixture where one order has two successful payment events
- verify that the output contains one row per customer per day, not per payment event

Risk in the first draft:

It looked correct syntactically but would have overcounted orders.

### Personal System Capture

Decision journal entry:

Always force analytical SQL drafts to state grain, duplicate assumptions, and one validation query before accepting the first version.

Mistake to log:

The first AI draft looked correct syntactically but hid grain assumptions that could have changed the metric silently.

### Example Scorecard

- grain clarity: 5/5
- logic quality: 4/5
- assumption visibility: 4/5
- validation strength: 5/5
- rewrite discipline: 5/5

Lowest score and why:

Assumption visibility is not 5 because the final note still does not define every edge-case around payment reversals.

Evidence for the score:

The core business rule is explicit, but reversal and refund handling remains an open semantic boundary.

### Example Reflection

- what the first draft got wrong: it confused payment-event grain with order grain
- what AI helped with: fast first-pass SQL structure
- what still required your own SQL reasoning: deduplication logic and metric semantics