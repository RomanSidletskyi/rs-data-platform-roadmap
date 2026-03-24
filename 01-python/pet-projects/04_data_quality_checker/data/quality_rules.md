# Suggested Quality Rules

## Structural Rules

- `order_id` must be present
- `customer_id` must be present
- `order_date` must be parseable as date
- `status` must be one of `paid`, `cancelled`, `pending`
- `amount` must be numeric

## Business Rules

- `order_id` should be unique in this dataset version
- `amount` must be non-negative for non-refund rows
- cancelled orders may exist, but their status must still be valid

## Reporting Expectation

The report should show both summary counts and concrete failing row examples.