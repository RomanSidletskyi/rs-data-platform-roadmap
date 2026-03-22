
cat <<'EOF' > "$MODULE/learning-materials/03_sql_vs_nosql_architecture/architecture.md" <<'EOF'
# Architecture

## Relational Architecture

Typical structure:

Application
-> SQL engine
-> tables
-> indexes
-> transactional storage

### Strong Sides

- transactions
- joins
- integrity constraints
- strong consistency

## NoSQL Architecture

Typical structure:

Application
-> API / query layer
-> distributed partitions
-> document or key-value storage

### Strong Sides

- horizontal scaling
- flexible schema
- workload-specific design
- very high throughput in some systems

## Key Difference

SQL centers around relational structure.

NoSQL often centers around:

- documents
- keys
- partitions
- access patterns
