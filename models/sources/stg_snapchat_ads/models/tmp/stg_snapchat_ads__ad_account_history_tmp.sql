{% if var("attribution_warehouse_ad_sources") %}
{% if 'snapchat_ads' in var("attribution_warehouse_ad_sources") %}

select * from {{ source('snapchat_ads','ad_account_history') }}

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
