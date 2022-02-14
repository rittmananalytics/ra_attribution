{% if var("attribution_warehouse_ad_sources") %}
{% if 'facebook_ads' in var("attribution_warehouse_ad_sources") %}

with adapter as (

    select *
    from {{ ref('stg_facebook_ads__ad_adapter') }}

), aggregated as (

    select
        date_day,
        account_id,
        account_name,
        local_currency,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend_local_currency) as spend_local_currency,
        sum(spend_global_currency) as spend_global_currency
    from adapter
    {{ dbt_utils.group_by(4) }}

)

select *
from aggregated

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
