# Secondary Indexes

## GSI

Global Secondary Index lets you query on alternative key shapes.

## LSI

Local Secondary Index changes sort-key style access inside same partition key.

## Rule

Add indexes only for real access patterns, not speculative ones.

## Example

Base table:
- PK = customer_id
- SK = order_timestamp

GSI1:
- GSI1PK = product_id
- GSI1SK = order_timestamp
