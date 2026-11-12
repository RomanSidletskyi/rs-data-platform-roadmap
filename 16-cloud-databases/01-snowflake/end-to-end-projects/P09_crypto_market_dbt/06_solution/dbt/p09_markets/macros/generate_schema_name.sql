{#
  prod: custom schemas are used as they are (STAGING, MARTS, ...), so consumers see stable names.
  dev and ci: everything goes under the target schema as a prefix (DEV_ME_MARTS, CI_PR_12_MARTS),
  so parallel developers and pull requests never overwrite each other or production.
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- elif target.name == 'prod' -%}
        {{ custom_schema_name | trim | upper }}
    {%- else -%}
        {{ target.schema }}_{{ custom_schema_name | trim | upper }}
    {%- endif -%}
{%- endmacro %}
