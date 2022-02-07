{% if var("attribution_warehouse_ad_sources") %}
{% if 'facebook_ads' in var("attribution_warehouse_ad_sources") %}

select * from {{ source('facebook_ads','account_history') }}

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
