# Tests

Use this directory for singular tests that defend the event-processing assumptions.

Strong examples:

- no duplicate `event_id` in an event mart
- no duplicate latest record per `order_id` in a current-state mart
- no negative amount
- no impossible future event timestamps

These tests should prove the incremental design is still trustworthy after late-arrival handling.
