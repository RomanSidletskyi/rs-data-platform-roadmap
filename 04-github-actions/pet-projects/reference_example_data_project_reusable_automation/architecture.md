# Architecture

This solved example uses a two-layer automation model:

1. local workflow defines the trigger and repository entry point
2. reusable workflow owns the repeated validation logic

The reusable workflow also emits a small artifact so that cross-job output handling remains visible rather than implicit.