{% macro get_campaign_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_account_id", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "daily_budget_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "end_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_string()},
    {"name": "lifetime_spend_cap_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "objective", "datatype": dbt_utils.type_string()},
    {"name": "start_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
