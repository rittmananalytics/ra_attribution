{% macro get_ad_squad_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "audience_size_maximum", "datatype": dbt_utils.type_numeric()},
    {"name": "audience_size_minimum", "datatype": dbt_utils.type_numeric()},
    {"name": "auto_bid", "datatype": "boolean"},
    {"name": "bid_estimate_maximum", "datatype": dbt_utils.type_numeric()},
    {"name": "bid_estimate_minimum", "datatype": dbt_utils.type_numeric()},
    {"name": "bid_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "billing_event", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "daily_budget_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "end_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_string()},
    {"name": "lifetime_budget_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "lifetime_spend_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "optimization_goal", "datatype": dbt_utils.type_string()},
    {"name": "placement", "datatype": dbt_utils.type_string()},
    {"name": "start_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "targeting_regulated_content", "datatype": "boolean"},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
