{% if var("attribution_warehouse_ad_sources") %}
{% if 'snapchat_ads' in var("attribution_warehouse_ad_sources") %}

with report as (

    select *
    from {{ ref('stg_snapchat_ads__ad_hourly_report') }}

), creatives as (

    select *
    from {{ ref('stg_snapchat_ads__creative_history') }}

), accounts as (

    select *
    from {{ ref('stg_snapchat_ads__ad_account_history') }}
    where is_most_recent_record = true

), ads as (

    select *
    from {{ ref('stg_snapchat_ads__ad_history') }}
    where is_most_recent_record = true

), ad_squads as (

    select *
    from {{ ref('stg_snapchat_ads__ad_squad_history') }}
    where is_most_recent_record = true

), campaigns as (

    select *
    from {{ ref('stg_snapchat_ads__campaign_history') }}
    where is_most_recent_record = true

), currency_rates as (

    select *
    from {{ ref('stg_currency_rates') }}

), joined as (

    select
        cast(report.date_hour as date) as date_day,
        accounts.ad_account_id,
        accounts.ad_account_name,
        accounts.local_currency,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_squads.ad_squad_id,
        ad_squads.ad_squad_name,
        ads.ad_id,
        ads.ad_name,
        creatives.creative_id,
        creatives.creative_name,
        creatives.base_url,
        creatives.url_host,
        creatives.url_path,
        creatives.utm_source,
        creatives.utm_medium,
        creatives.utm_campaign,
        creatives.utm_content,
        creatives.utm_term,
        sum(stats.spend) as spend_local_currency,
        sum({{ convert_amount_to_global_currency('stats.spend', 'accounts.local_currency', 'currency_rates.currency_rate') }}) as spend_global_currency,
        sum(report.impressions) as impressions,
        sum(report.swipes) as swipes
    from report
    left join ads 
        on report.ad_id = ads.ad_id
    left join creatives
        on ads.creative_id = creatives.creative_id
    left join ad_squads
        on ads.ad_squad_id = ad_squads.ad_squad_id
    left join campaigns
        on ad_squads.campaign_id = campaigns.campaign_id
    left join accounts
        on campaigns.ad_account_id = accounts.ad_account_id
    left join currency_rates
        on accounts.local_currency = currency_rates.base_currency_code
        and currency_rates.quote_currency_code = '{{ var('attribution_global_currency') }}'
        and cast(report.date_hour as date) = currency_rates.currency_rate_date
    {{ dbt_utils.group_by(20) }}

)

select *
from joined

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
