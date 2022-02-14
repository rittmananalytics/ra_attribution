{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_ad_sources") %}
{% if 'google_ads' in var("attribution_warehouse_ad_sources") %}
{% if var("stg_google_ads_api_source") == 'adwords' %}


select *
from {{ source('adwords','click_performance') }}

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
