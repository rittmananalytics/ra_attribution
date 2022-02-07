{% if 'snapchat_ads' in var("attribution_warehouse_ad_sources") %}

with base as (

    select *
    from {{ ref('stg_snapchat_ads__ad_adapter')}}

), fields as (

    select
        cast(date_day as date) as date_day,
        account_name,
        cast(account_id as {{ dbt_utils.type_string() }}) as account_id,
        local_currency,
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        fbclid as click_id,
        cast(campaign_id as {{ dbt_utils.type_string() }}) as campaign_id,
        campaign_name,
        cast(ad_set_id as {{ dbt_utils.type_string() }}) as ad_group_id,
        ad_set_name as ad_group_name,
        'Snapchat Ads' as platform,
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend_local_currency, 0)) as spend_local_currency,
        sum(coalesce(spend_global_currency, 0)) as spend_global_currency
    from base
    {{ dbt_utils.group_by(17) }}


)

select *
from fields

{% else %} {{config(enabled=false)}} {% endif %}
