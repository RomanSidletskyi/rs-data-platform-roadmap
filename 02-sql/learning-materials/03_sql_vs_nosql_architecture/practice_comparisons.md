# Practice Comparisons

## Example 1: Customer Orders

### SQL
Use normalized tables and joins.

### MongoDB
Embed order items inside order documents.

### DynamoDB
Store orders under customer partition.

### CosmosDB
Use customer_id as partition key and model orders as JSON documents.

## Example 2: Product Catalog

### SQL
Good for structured product relationships.

### MongoDB
Good for flexible product attributes.

### DynamoDB
Good if access patterns are simple and key-based.

### CosmosDB
Good for distributed microservice catalog APIs.

## Exercise

For each use case, decide:

- dominant read pattern
- write pattern
- scaling requirement
- consistency need
- best storage fit
