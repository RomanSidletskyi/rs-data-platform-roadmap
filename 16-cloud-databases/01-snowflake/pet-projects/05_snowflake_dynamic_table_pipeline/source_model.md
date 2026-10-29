# Source Model

Suggested starting tables:

- `raw.orders_raw`
- `raw.order_status_events`
- `raw.payments_raw`

Document for each source:

- grain
- business key
- event time or business time column
- common quality problems such as duplicates or late arrival

Questions to answer:

- which table should feed the first dynamic staging layer?
- which source should stay outside the low-lag path because it is too noisy or too heavy?