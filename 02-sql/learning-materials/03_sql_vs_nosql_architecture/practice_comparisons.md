
cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/README.md" <<'EOF'
# 04 Document Database Modeling

This section focuses on document-oriented schema design.

## Why This Matters

SQL engineers often know normalization deeply, but document stores require a different design mindset.

In document databases, the critical questions are:

- what gets read together
- what changes together
- what should be embedded
- what should be referenced
- what should be partitioned together

## Files

- embedding_vs_referencing.md
- access_patterns.md
- denormalization.md
- schema_design.md
- anti_patterns.md
- modeling_exercises.md
