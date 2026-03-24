# 01-python Learning Materials Index

This learning block should be treated as the conceptual and architectural foundation for the rest of the roadmap.

The goal is not to repeat a generic Python course.

The goal is to explain Python in the specific context of data engineering work.

That means the materials should help the learner understand:

- how Python moves data between systems
- how Python workflows fail in practice
- what makes a script evolve into a maintainable pipeline component
- where Python fits relative to SQL, Spark, Kafka, and orchestration tools

## Recommended Reading Path

### Phase 1 - Core Mental Model

Start here:

- `fundamentals/01_python_runtime_and_data_flow.md`
- `fundamentals/02_functions_modules_and_project_boundaries.md`
- `python-cookbook/01_core_python_collections_cookbook.md`
- `python-cookbook/02_functions_exceptions_files_datetime_cookbook.md`
- `python-cookbook/03_practical_python_libraries_for_data_work.md`
- `python-cookbook/04_stdlib_vs_external_libs_when_to_use_what.md`
- `python-cookbook/05_recommended_stack_by_project_size.md`
- `python-cookbook/06_decorators_closures_and_classes.md`
- `python-cookbook/07_functions_vs_classes_methodology.md`
- `python-cookbook/08_oop_patterns_for_data_engineering.md`
- `python-cookbook/09_typing_and_data_contracts.md`
- `python-cookbook/10_generators_streaming_and_memory_patterns.md`

### Phase 2 - Files And Ingestion Shapes

Continue with:

- `files-and-json/01_file_formats_and_data_shapes.md`
- `files-and-json/02_batch_file_processing_patterns.md`
- `api-work/01_http_api_ingestion_patterns.md`

### Phase 3 - Reliability And Runtime Hygiene

Then study:

- `api-work/03_async_api_patterns.md`
- `api-work/02_pagination_retries_and_rate_limits.md`
- `testing-and-logging/01_logging_error_handling_and_observability.md`
- `testing-and-logging/02_testing_data_pipelines_in_python.md`

### Phase 4 - Project Shape And Platform Thinking

Finish with:

- `packaging-and-env/01_environments_dependencies_and_config.md`
- `packaging-and-env/02_cli_project_structure_and_reproducibility.md`
- `packaging-and-env/03_step_by_step_local_project_setup.md`
- `data-engineering-focus/01_python_in_data_platform_architecture.md`
- `data-engineering-focus/02_idempotency_incremental_processing_and_data_quality.md`

## Reading Strategy

Use this loop:

1. read one concept or architecture file
2. complete the matching simple tasks
3. build a small script using the same idea
4. revisit the material after seeing where the code gets messy

## Additional Cookbook Block

The `python-cookbook/` block is intentionally more practical than architectural.

Its role is to make the learner comfortable with the Python building blocks that appear everywhere later:

- dictionaries
- lists
- tuples
- sets
- string helpers
- iteration patterns
- functions and return shapes
- exceptions and failure handling
- file and pathlib patterns
- datetime handling
- small helper modules from the standard library
- practical external libraries worth learning next
- a decision framework for stdlib vs external packages
- a staged view of how the Python stack grows with project complexity
- decorators, closures, and class-based patterns
- methodology for choosing functions-first or class-based design
- practical object-oriented patterns that are actually useful in data engineering
- typing and data contracts for safer pipeline code
- generators and memory-aware streaming patterns

The goal is to reduce friction before the learner enters ingestion-heavy and validation-heavy data engineering code.