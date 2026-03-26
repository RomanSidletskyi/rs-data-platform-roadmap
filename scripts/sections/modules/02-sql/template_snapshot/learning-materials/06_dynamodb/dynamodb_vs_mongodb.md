# DynamoDB vs MongoDB

| Feature | DynamoDB | MongoDB |
|---|---|---|
| Main model | key-value / access-pattern | document-oriented |
| Query style | PK/SK and indexes | flexible document queries |
| Joins | no | limited through lookup |
| Main strength | scale and latency | flexible document reads |
| Main risk | hard schema design | document/index misuse |

## Main Difference

DynamoDB is stricter and more access-pattern-driven.

MongoDB is more flexible in querying but still requires good modeling.
