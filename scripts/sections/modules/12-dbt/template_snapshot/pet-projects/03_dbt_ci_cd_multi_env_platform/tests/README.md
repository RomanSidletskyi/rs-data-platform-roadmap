# Tests

Focus here on the small set of tests that should genuinely block a deploy.

Good examples:

- high-value mart business rules
- timestamp sanity checks
- uniqueness assumptions for publish-critical outputs

Treat this directory as the last operational safety net, not as a dumping ground for every possible query.
