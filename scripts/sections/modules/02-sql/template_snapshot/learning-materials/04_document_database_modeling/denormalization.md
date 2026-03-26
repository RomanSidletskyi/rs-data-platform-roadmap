# Denormalization

Denormalization is not a mistake in document systems. It is often intentional.

## Benefits

- fewer joins
- faster reads
- simpler document retrieval

## Risks

- duplicated data
- update fan-out
- inconsistency if not managed well

## Good Practice

Duplicate only what is needed for high-value reads.
