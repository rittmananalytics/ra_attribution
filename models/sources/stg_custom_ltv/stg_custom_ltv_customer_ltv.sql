{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_ltv_sources") %}
{% if 'custom_ltv_customer' in var("attribution_warehouse_ltv_sources") %}

with source as (
      select
        *
      from
      {% if var("attribution_demo_mode")  %}
        {{ ref("customer_ltv_ndays") }}
      {% else %}
        {{ source('custom_ltv', 'user_ltv') }}
      {% endif %}

    ),
renamed as (
  select
    user_id as user_id,
    ltv_365d_local_currency as ltv_365d_local_currency,
    ltv_365d_global_currency as ltv_365d_global_currency
  from source
)
select
  *
from
  renamed

  {% else %} {{config(enabled=false)}} {% endif %}
  {% else %} {{config(enabled=false)}} {% endif %}
  {% else %} {{config(enabled=false)}} {% endif %}
