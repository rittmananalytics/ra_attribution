{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_ad_sources") %}
{% if 'custom_currency_rates' in var("attribution_warehouse_currency_rate_sources") %}

with
  currency_rates as (
    select
      *
    from
      {{ source('custom', 'currency_rates') }}
  )
  select
    currency_rate_id,
    currency_rate_date,
    base_currency_code,
    quote_currency_code,
    currency_rate,

  from currency_rates

 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
