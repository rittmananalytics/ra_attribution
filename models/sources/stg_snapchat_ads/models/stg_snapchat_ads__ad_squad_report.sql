{% if var("attribution_warehouse_ad_sources") %}
{% if 'snapchat_ads' in var("attribution_warehouse_ad_sources") %}

with adapter as (

    select *
    from {{ ref('stg_snapchat_ads__ad_adapter') }}

), aggregated as (

    select
        date_day,
        ad_account_id,
        ad_account_name,
        campaign_id,
        campaign_name,
        ad_squad_id,
        ad_squad_name,
        sum(swipes) as swipes,
        sum(impressions) as impressions,
        sum(spend) as spend
    from adapter
    {{ dbt_utils.group_by(7) }}

)

select *
from aggregated

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
