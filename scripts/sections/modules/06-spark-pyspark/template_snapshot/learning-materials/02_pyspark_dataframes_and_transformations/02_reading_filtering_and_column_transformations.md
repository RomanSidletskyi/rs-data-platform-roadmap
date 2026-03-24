# Reading, Filtering, And Column Transformations

## Why This Topic Matters

Most real Spark pipelines start with a familiar pattern:

- read raw data
- filter it to the relevant slice
- derive or standardize columns

These steps look basic, but they shape everything that follows.

Done well, they reduce data volume early and make downstream joins and aggregations cheaper.

Done poorly, they leave the job carrying unnecessary data through expensive stages.

## Common Pattern

Typical pipeline skeleton:

```python
raw_df = spark.read.json("data/orders.json")

filtered_df = raw_df.filter("event_date >= '2026-03-01'")

clean_df = filtered_df.withColumn("amount_eur", col("amount_cents") / 100)
```

This is a simple pattern, but it already raises important questions:

- are filters being applied early enough?
- are derived columns explicit and readable?
- is the schema already trustworthy?

In other words, even the "easy" beginning of a pipeline already contains architecture choices.

## Why Early Filtering Matters

Filtering early can reduce:

- input volume
- downstream shuffle size
- memory pressure
- overall job runtime

This is not only code cleanliness.

It is execution-shape design.

It also affects trust.

If the pipeline reads more history or more columns than needed, later debugging becomes harder because too much irrelevant data remains in motion.

## Column Transformations And Semantics

Column derivations often represent business meaning.

Examples:

- converting cents to currency units
- normalizing status values
- extracting event date from timestamp
- computing flags used by downstream analytics

This means column logic is not only syntactic manipulation. It is part of the platform's semantic layer.

That is why vague transformations are dangerous.

If a derived column exists but no one can explain its business meaning, the pipeline may already be creating semantic debt.

## Real Example

Suppose a raw event feed contains inconsistent country codes:

- `de`
- `DE`
- `Germany`

A healthy Spark transformation layer should normalize this into a stable representation before downstream models consume it.

If not, every later aggregation or join becomes harder to trust.

Another realistic example:

- raw events contain both `event_time` and `ingestion_time`
- a pipeline quietly filters on the wrong one
- the code still runs, but the business window is no longer what stakeholders think it is

This is why even early filter logic deserves explicit review.

## Practical Review Questions

1. Are we reading only the needed slice of data?
2. Are filters applied on the correct business time field?
3. Are derived columns semantically named and understandable?
4. Are we carrying only the columns needed for later stages?
5. Are source inconsistencies being normalized before downstream joins depend on them?

## Common Mistakes

### Mistake 1: Carrying Too Many Columns Too Far

If only 8 columns are needed later, carrying 60 columns through the whole pipeline may waste memory and shuffle bandwidth.

### Mistake 2: Encoding Business Logic In Vague One-Off Expressions

That makes pipelines harder to maintain and review.

### Mistake 3: Assuming Raw Input Is Already Clean

Real raw data is usually not that kind.

### Mistake 4: Treating Early Transforms As Low-Risk Boilerplate

Many expensive and semantically wrong pipelines were shaped by weak decisions in the first few transformations.

## Good Strategy

- filter and project early when it is safe to do so
- make derived columns explicit and semantically clear
- treat read and clean steps as architecture, not just boilerplate
- review early transformations as the foundation of the whole pipeline, not as throwaway setup

## Key Architectural Takeaway

The first read/filter/transform steps shape the whole Spark pipeline, so they should be designed with both correctness and execution cost in mind.