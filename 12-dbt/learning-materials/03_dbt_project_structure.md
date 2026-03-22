# DBT Project Structure

## Recommended structure

    12-dbt/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

Example real dbt project structure:

    dbt_project/
        dbt_project.yml
        packages.yml
        models/
            sources/
            staging/
            intermediate/
            marts/
        macros/
        tests/
        seeds/
        snapshots/
        analyses/

--------------------------------------------------

## Why layered models matter

Recommended warehouse transformation flow:

    raw
        ↓
    staging
        ↓
    intermediate
        ↓
    marts

Responsibilities:

staging:
- parse
- cast
- rename
- minimal cleanup

intermediate:
- joins
- dedup
- enrichment
- business rules
- reusable transformation steps

marts:
- dimensions
- facts
- reporting datasets
- BI-facing tables

--------------------------------------------------

## Example folder structure for domains

    models/
        staging/
            sales/
            crm/
            finance/
        intermediate/
            sales/
            crm/
            finance/
        marts/
            dimensions/
                crm/
                product/
                finance/
            facts/
                sales/
                finance/

This works well when models belong to different business domains and may target different databases and schemas.

--------------------------------------------------

## Where logic should live

Good separation:

- source parsing and standardization → staging
- cross-source business transformations → intermediate
- end-user datasets → marts

Bad separation:

- giant SQL directly from raw to marts
- hidden business logic in macros everywhere
- orchestration logic inside models

