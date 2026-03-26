# Idempotency, Exactly-Once, And Retries

## Why This Topic Matters

Teams often overestimate what Delta Lake guarantees.

Delta Lake improves write reliability, but it does not remove the need for idempotent pipeline design.

## Idempotency

A workload is idempotent when rerunning the same slice does not corrupt the table state.

This matters for:

- retries
- backfills
- late-arriving corrections

In practical terms, idempotency means the same slice can be applied again without creating duplicate or contradictory state.

That is often harder than it looks once merges, deletes, and late updates appear.

## Exactly-Once Mental Model

Delta can help support exactly-once style outcomes at the table level, especially with structured streaming patterns.

But that outcome still depends on:

- source semantics
- checkpointing
- write design
- deduplication rules

Exactly-once is therefore not a magical property that Delta simply turns on.

It is the outcome of multiple layers behaving coherently.

## Example

An idempotent slice-oriented write often looks more like this:

```python
(daily_df.write
	.format("delta")
	.mode("overwrite")
	.option("replaceWhere", "order_date = '2026-03-24'")
	.saveAsTable("silver.orders"))
```

That can be safer for reruns than a broad append if the table semantics are day-bounded.

## Good Vs Bad Retry Design

Healthy design:

- replay of the same slice preserves the intended final state
- duplicate source records are handled explicitly
- retry behavior is aligned with table mutation logic

Weak design:

- retries create duplicate rows or contradictory state
- exactly-once is assumed without examining source guarantees
- recovery depends on not rerunning the same input twice

## Practical Questions

1. What slice of data is safe to rerun?
2. Does retrying create duplicates or overwrite the wrong scope?
3. Are keys and deduplication rules explicit?
4. Is the table append-only, latest-state, or history-preserving?
5. Which layer actually guarantees what part of the exactly-once story?

## Key Architectural Takeaway

Delta Lake reduces failure risk, but pipeline idempotency is still a design responsibility.
