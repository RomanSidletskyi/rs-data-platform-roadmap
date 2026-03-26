# Query Comparison

## Business Question 1

Get one order with all items and payment information.

SQL shape:

- multiple joins
- clear normalized ownership
- easy consistency reasoning

Document shape:

- one document read
- more application-friendly response
- depends on duplicated product and customer snapshot data being acceptable

## Business Question 2

Get customer order history.

SQL shape:

- natural join from `users` to `orders`
- easy to enrich with additional reference tables

Document shape:

- direct filter on `user_id`
- easy operational read if the workload is mainly order-centric

## Business Question 3

Get product sales summary.

SQL shape:

- natural aggregation from `order_items`
- dimensions stay independent

Document shape:

- requires `unwind` and aggregation over embedded items
- good enough for operational summaries, but not always the strongest large-scale analytics pattern
