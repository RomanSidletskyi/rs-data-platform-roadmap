# MongoDB Data Modeling

## Main Rules

- embed when data is read together
- reference when data is large, shared, or independent
- design documents around application access patterns
- avoid modeling everything like normalized SQL

## Good Fit

- product catalogs
- event payloads
- order documents
- session documents

## Common Risks

- giant documents
- too much duplication
- lookup-heavy data access
