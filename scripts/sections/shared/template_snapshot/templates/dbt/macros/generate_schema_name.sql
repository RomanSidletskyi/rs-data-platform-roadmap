{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}

    {%- if target.name == 'prod' -%}
        {{ custom_schema_name if custom_schema_name is not none else default_schema }}
    {%- else -%}
        {{ default_schema if custom_schema_name is none else default_schema ~ '_' ~ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}