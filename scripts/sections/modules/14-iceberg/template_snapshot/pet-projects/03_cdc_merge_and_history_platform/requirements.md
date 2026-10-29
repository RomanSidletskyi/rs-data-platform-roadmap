# Requirements

## Functional Requirements

- preserve raw CDC history
- expose one current-state table
- expose one historical customer table
- define one maintenance workflow for mutation aftermath

## Non-Functional Requirements

- make grain and contract boundaries explicit
- avoid ambiguous delete semantics
- explain expected operational cost of mutation-heavy tables