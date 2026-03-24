MERGE INTO silver.customer_current_state AS target
USING staged_customer_events AS source
ON target.customer_id = source.customer_id
WHEN MATCHED AND source.op = 'delete' THEN DELETE
WHEN MATCHED AND source.event_ts >= target.event_ts THEN
  UPDATE SET
    event_ts = source.event_ts,
    email = source.email,
    loyalty_tier = source.loyalty_tier
WHEN NOT MATCHED AND source.op <> 'delete' THEN
  INSERT (customer_id, event_ts, email, loyalty_tier)
  VALUES (source.customer_id, source.event_ts, source.email, source.loyalty_tier);
