# Expected Structured Event Contract

Recommended fields for parsed output:

- `event_time`
- `severity`
- `service_name`
- `message`
- `status_code`
- `path`
- `duration_ms`
- `order_id`
- `error_code`
- `is_malformed`

## Notes

- not every field must be populated on every row
- malformed lines should not disappear silently
- summary output should at least count events by severity and malformed-line count