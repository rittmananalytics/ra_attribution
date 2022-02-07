{% if target.type == 'redshift' %}
{% if var("attribution_warehouse_ad_sources") %}
{% if 'facebook_ads' in var("attribution_warehouse_ad_sources") %}

{{ dbt_utils.generate_series(upper_bound=1000) }}

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
