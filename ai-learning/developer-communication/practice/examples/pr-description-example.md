# PR Description Example

## Scenario

The pipeline was refactored to separate validation from transformation and tests were added.

## Weak Version

### Title

Refactor pipeline and add tests

### Body

This PR cleans up the pipeline and adds tests.

Please review the changes.

## Why This Is Weak

- it says almost nothing about intent
- there is no risk statement
- the reviewer gets no guidance on where judgment matters
- validation is mentioned but not described

## Strong Version

### Title

Separate schema validation from transformation in customer events pipeline

### Body

What changed:

- moved required-field and schema checks into a dedicated validation step
- kept transformation logic focused on normalized record construction
- added unit tests for missing required fields and unknown optional fields

Why:

Previously, validation failures surfaced inside transformation code, which made errors harder to diagnose and mixed two responsibilities in one stage.

This change makes failure mode clearer and reduces reviewer and operator guesswork when a batch stops early.

Risk:

- the pipeline now fails earlier for invalid inputs
- any downstream logic that assumed partial transformation before failure will no longer run
- there is a moderate risk that an overly strict validation rule blocks valid files

Validation:

- ran unit tests covering required-field failures and safe handling of optional unknown fields
- exercised the local fixture with both valid and invalid samples
- confirmed that valid records still reach the transformation stage unchanged

Review focus:

- check whether the validation boundary is in the right place
- verify that the failure mode is strict where it should be strict and tolerant where it should be tolerant
- review the new tests for edge-case coverage rather than only happy-path behavior

## Why This Is Strong

- it explains intent, not only changed files
- it exposes the new risk created by earlier failure
- it tells the reviewer exactly where judgment is required