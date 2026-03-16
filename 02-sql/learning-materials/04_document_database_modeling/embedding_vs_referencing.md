# Embedding vs Referencing

## Embedding

Use embedding when:

- child data is read together with parent
- child data is bounded in size
- updates happen together
- document growth is predictable

### Example

Order with order items embedded.

## Referencing

Use referencing when:

- child data is large or unbounded
- child data is reused by many parents
- update frequency differs
- independent lifecycle matters

### Example

Product catalog referenced from order items.

## Rule of Thumb

Embed for locality.
Reference for independence.
