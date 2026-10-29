# Solution: Task Set 01

## Task 1

The role is the authorization context; the warehouse supplies execution compute; the qualified path identifies database, schema, and object; Snowflake's storage layer holds the table data. Cloud services coordinate authentication, authorization, compilation, and metadata. Warehouses do not own table copies.

## Task 2

(a) Permanent is the conservative default for durable curated data. (b) Transient may fit an intermediate that is safely reproducible and does not need the same recovery guarantees. (c) Temporary fits a session-only debugging result. Confirm retention and recovery behavior for the target edition/configuration; do not choose a weaker lifecycle unless rebuild and loss are acceptable.

## Task 3

```sql
USE ROLE BI_READER;
USE WAREHOUSE BI_WH;
SELECT * FROM PROD_DB.REPORTING.DAILY_SALES;
```

Fully qualified names prevent hidden current-database or current-schema state from selecting the wrong object, especially in scripts and deployments.

## Task 4

Check active role and role hierarchy; `USAGE` on database and schema; `SELECT` on the view; view ownership and underlying access semantics; managed-access behavior; masking or row policies; and whether the grant was made to a role the user actually has. Test as the consumer role.

## Task 5

One reasonable design separates dev and prod accounts, with environment-specific roles, warehouses, and databases. A smaller organization might use schemas inside one account with stronger role controls. Risks differ: fewer accounts simplify operations but increase blast radius; more accounts increase promotion and configuration work. Document the constraint that determines the choice.