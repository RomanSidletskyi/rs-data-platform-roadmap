
cat <<'EOF' > "$MODULE/pet-projects/02_mongodb_event_store/document_model.md" <<'EOF'
# Document Model

## Option 1 — Event Per Document

### Description

Each event is stored as one document.

### Benefits

- simple write path
- flexible filtering
- easy indexing on event fields
- natural fit for event streams

### Risks

- many small documents
- session reconstruction requires grouping or multiple reads

---

## Option 2 — Session Document

### Description

Store a session with embedded events.

### Benefits

- read-many events together
- session-level reconstruction is easy

### Risks

- unbounded growth
- harder partial updates
- harder indexing on all event-level fields
- less flexible for large sessions

## Recommendation

For most operational event logging workloads, event-per-document is the safer and simpler starting point.
