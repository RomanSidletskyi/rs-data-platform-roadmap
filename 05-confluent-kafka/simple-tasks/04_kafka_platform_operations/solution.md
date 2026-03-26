# Solution

Retention example:

- 3-day retention may help short bug recovery
- 30-day retention better supports reprocessing and delayed consumer recovery

Lag diagnosis examples:

- slow sink: consumer is alive but DB writes are slow, so lag climbs steadily
- unstable consumer group: deployments or crashes trigger repeated rebalances and progress stalls

Hot partition example:

- weak key: `country_code`
- better key: `order_id` or `device_id`, depending on the entity that needs ordering