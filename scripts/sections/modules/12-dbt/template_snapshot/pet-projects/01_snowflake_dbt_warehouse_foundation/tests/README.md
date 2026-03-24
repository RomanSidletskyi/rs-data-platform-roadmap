# Tests

Use this directory for singular tests that protect rules not covered cleanly by generic YAML tests.

Good examples:

- no negative order amounts in the fact table
- no future order timestamps
- no duplicate current customer record if you model current-state logic

Keep these tests focused on business correctness, not just schema mechanics.
