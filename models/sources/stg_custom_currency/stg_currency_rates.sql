{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_ad_sources") %}
{% if 'custom_currency_rates' in var("attribution_warehouse_currency_rate_sources") %}

with
  currency_rates as (
    select
      *
    from
    {% if var("attribution_demo_mode")  %}
      {{ ref("currency_rates") }}
    {% else %}
      {{ source('custom_currency', 'currency_rates') }}
    {% endif %}

  )
  select
    currency_rate_id as currency_rate_id,
    currency_rate_date as currency_rate_date,
    base_currency_code as base_currency_code,
    quote_currency_code as quote_currency_code,
    currency_rate as currency_rate

  from currency_rates

 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
