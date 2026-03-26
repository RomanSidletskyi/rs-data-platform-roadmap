# Architecture

This solved example uses a validation-first model:

1. run on pull request and manual trigger
2. validate syntax and importability through bytecode compilation
3. run tests across multiple Python versions

The workflow stays intentionally within CI boundaries. It validates repository change quality but does not mutate external systems.