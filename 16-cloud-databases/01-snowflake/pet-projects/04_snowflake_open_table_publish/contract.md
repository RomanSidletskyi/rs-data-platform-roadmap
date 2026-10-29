# Publish Contract

Define the contract for the curated published dataset.

Suggested contract:

- one order-level fact table for daily finance and customer analytics

Suggested columns:

- `order_id`
- `customer_id`
- `order_date`
- `order_status`
- `gross_amount`
- `refund_amount`
- `net_amount`
- `shipment_status`
- `load_ts`

Questions to answer:

- which of these columns are safe for long-term consumer dependence?
- which internal helper columns should stay out of the publish contract?
- what freshness promise is realistic for this table?

Rule:

- if a field changes often because internal modeling is still evolving, it should probably not be in the publish contract yet.