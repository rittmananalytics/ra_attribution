{% macro get_creative_url_tag_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "creative_id", "datatype": dbt_utils.type_string()},
    {"name": "key", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "value", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
