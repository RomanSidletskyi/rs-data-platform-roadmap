
cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/access_patterns.md" <<'EOF'
# Access Patterns

Document schema design should start with access patterns.

## Examples

- get order by order_id
- get all recent orders for customer
- get product details
- get latest session events for user

## Main Rule

Model around what the application reads and writes most often.

Not around a normalized ER diagram.
