# Writing PR Descriptions

Good PR descriptions make review faster and safer.

## A Strong PR Description Should Include

- what changed
- why it changed
- what risks exist
- what was validated
- what reviewers should focus on

## Weak Example

```text
Refactor pipeline and improve logic.
```

## Better Example

```text
This change separates schema validation from record transformation in the ingestion path.

Why:
- the previous implementation mixed parsing and validation
- this made failures harder to diagnose and tests harder to write

Risk:
- validation now fails earlier for missing required fields

Validation:
- updated unit tests for parser and transformer
- reran local sample pipeline

Review focus:
- confirm fail-fast behaviour is correct for missing required fields
- confirm no downstream interface expectations changed
```

## How AI Helps

Use AI to:

- make the structure clearer
- reduce repetition
- improve reviewer-facing focus points

Do not use AI to make the text polished while hiding risk.