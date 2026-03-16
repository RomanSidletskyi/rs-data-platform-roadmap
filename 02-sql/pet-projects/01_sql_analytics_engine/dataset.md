# Dataset

## Recommended Tables

### users

Suggested columns:

- user_id
- email
- country
- signup_date
- user_status

### orders

Suggested columns:

- order_id
- user_id
- order_date
- status
- amount
- currency

### order_items

Suggested columns:

- order_item_id
- order_id
- product_id
- quantity
- item_price

### products

Suggested columns:

- product_id
- category_id
- product_name
- category_name

### payments

Suggested columns:

- payment_id
- order_id
- payment_date
- payment_status
- paid_amount

### events

Suggested columns:

- event_id
- user_id
- session_id
- event_name
- event_time
- page_url
- device_type

## Data Quality Notes

When preparing the project, think about:

- duplicate orders
- invalid statuses
- refunded orders
- missing timestamps
- test users
- inconsistent category naming

## Recommendation

Use realistic enough data to support:

- order analytics
- customer analytics
- funnel analysis
- retention analysis
- cohort analysis
