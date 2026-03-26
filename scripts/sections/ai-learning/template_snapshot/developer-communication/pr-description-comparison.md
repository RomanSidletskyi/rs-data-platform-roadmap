# PR Description Comparison

This guide compares weak, acceptable, and strong PR description patterns.

## Weak Pattern

```text
Refactor pipeline and improve logic.
```

Why it fails:

- unclear change scope
- unclear motivation
- no risk framing
- no validation information

## Acceptable Pattern

```text
This refactor separates validation from transformation in the ingestion flow.
It should make the pipeline easier to test.
```

Why it is only acceptable:

- the intent is visible
- but risk and validation are still unclear

## Strong Pattern

```text
This change separates schema validation from record transformation in the ingestion path.

Why:
- the previous implementation mixed parsing and validation
- failures were harder to diagnose
- tests could not isolate validation behaviour cleanly

Risk:
- validation now fails earlier for missing required fields

Validation:
- updated parser and transformer unit tests
- reran the local sample pipeline

Review focus:
- confirm fail-fast behaviour is correct
- confirm no downstream interface expectations changed
```

## Rule

Good PR descriptions reduce reviewer guesswork.