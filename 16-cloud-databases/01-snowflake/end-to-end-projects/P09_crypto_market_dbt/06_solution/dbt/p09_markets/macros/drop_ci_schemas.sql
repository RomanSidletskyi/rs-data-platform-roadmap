{#
  Drop every schema of one CI run. Called at the end of the pull request workflow:
  dbt run-operation drop_ci_schemas --args '{prefix: CI_PR_12}' --target ci
#}
{% macro drop_ci_schemas(prefix) %}
    {% if not prefix.upper().startswith('CI_') %}
        {{ exceptions.raise_compiler_error("drop_ci_schemas only drops schemas starting with CI_") }}
    {% endif %}
    {% set schemas = run_query(
        "select schema_name from " ~ target.database ~ ".information_schema.schemata where schema_name like '"
        ~ prefix.upper() ~ "%'"
    ) %}
    {% for row in schemas %}
        {% do run_query("drop schema if exists " ~ target.database ~ "." ~ row[0] ~ " cascade") %}
        {{ log("dropped " ~ row[0], info=true) }}
    {% endfor %}
{% endmacro %}
