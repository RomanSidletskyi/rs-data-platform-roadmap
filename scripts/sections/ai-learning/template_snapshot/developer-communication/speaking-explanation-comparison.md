# Speaking Explanation Comparison

This guide compares weak, acceptable, and strong spoken explanations of systems.

## Weak Pattern

```text
We built a pipeline and it works well.
```

Why it fails:

- no problem statement
- no system shape
- no trade-off

## Acceptable Pattern

```text
We built a pipeline that ingests files, transforms them, and publishes them for analytics.
```

Why it is only acceptable:

- basic flow is visible
- but there is still no architectural reasoning

## Strong Pattern

```text
This pipeline ingests raw events into bronze, standardizes them in silver, and publishes analytics-facing outputs in gold.
The main trade-off is between fast ingestion and strict schema control.
We chose fail-fast validation for required fields because downstream data quality mattered more than partial acceptance.
If the platform later needs more flexible multi-consumer publishing, we would likely revisit the publish contract boundary.
```

## Rule

The strongest spoken explanation usually answers five questions:

1. what problem does the system solve
2. what are the main components
3. how does the flow work
4. what trade-off was made
5. what might change later