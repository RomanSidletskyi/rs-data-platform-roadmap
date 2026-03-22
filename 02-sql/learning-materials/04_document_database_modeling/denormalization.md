
cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/schema_design.md" <<'EOF'
# Schema Design

## Main Questions

- what is the document boundary
- what grows unbounded
- which fields are queried often
- which fields need indexes
- which fields define partition placement

## Example

For an order document:

- embed order items
- maybe embed payment summary
- reference very large audit history
