# Partition Keys

Partition keys determine data placement.

## Good Partition Key

A good partition key should:

- distribute traffic evenly
- support important access patterns
- avoid concentration on one value

## Bad Partition Key Examples

- country when most traffic is one country
- status when one status dominates
- very low-cardinality fields

## Good Examples

- customer_id if traffic is well distributed
- tenant_id when tenants are balanced
- sharded synthetic keys when needed
