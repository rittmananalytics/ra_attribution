{% if var("attribution_warehouse_ad_sources") %}
{% if 'snapchat_ads' in var("attribution_warehouse_ad_sources") %}

select * from {{ source('snapchat_ads','creative_url_tag_history') }}

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
