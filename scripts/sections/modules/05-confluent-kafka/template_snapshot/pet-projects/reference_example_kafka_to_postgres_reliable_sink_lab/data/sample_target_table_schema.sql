CREATE TABLE order_event_sink (
    event_id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    customer_id TEXT NOT NULL,
    event_time TIMESTAMPTZ NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    currency TEXT NOT NULL
);