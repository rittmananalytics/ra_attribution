{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_ltv_sources") %}
{% if 'custom_ltv_customer' in var("attribution_warehouse_ltv_sources") %}

with source as (
      select
        *
      from
        {{ source('custom_ltv', 'user_ltv') }}
    ),
renamed as (
  select
    user_id as user_id,
    customer_value_30_days_since_first_delivery_local_currency as ltv_30d_local_currency,
    customer_value_30_days_since_first_delivery_global_currency as ltv_30d_global_currency,
    customer_value_60_days_since_first_delivery_local_currency as ltv_60d_local_currency,
    customer_value_60_days_since_first_delivery_global_currency as ltv_60d_global_currency,
    customer_value_90_days_since_first_delivery_local_currency as ltv_90d_local_currency,
    customer_value_90_days_since_first_delivery_global_currency as ltv_90d_global_currency,
    customer_value_180_days_since_first_delivery_local_currency as ltv_180d_local_currency,
    customer_value_180_days_since_first_delivery_global_currency as ltv_180d_global_currency,
    customer_value_365_days_since_first_delivery_local_currency as ltv_365d_local_currency,
    customer_value_365_days_since_first_delivery_global_currency as ltv_365d_global_currency
  from source
)
select
  *
from
  renamed

  {% else %} {{config(enabled=false)}} {% endif %}
  {% else %} {{config(enabled=false)}} {% endif %}
  {% else %} {{config(enabled=false)}} {% endif %}
