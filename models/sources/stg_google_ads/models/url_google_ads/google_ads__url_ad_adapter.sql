{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_ad_sources") %}
{% if 'google_ads' in var("attribution_warehouse_ad_sources") %}
{% if var("google_ads_api_source") == 'google_ads' %}

with stats as (

    select *
    from {{ ref('stg_google_ads__ad_stats') }}

), accounts as (

    select *
    from {{ ref('stg_google_ads__account') }}

), campaigns as (

    select *
    from {{ ref('stg_google_ads__campaign_history') }}
    where is_most_recent_record = True

), ad_groups as (

    select *
    from {{ ref('stg_google_ads__ad_group_history') }}
    where is_most_recent_record = True

), ads as (

    select *
    from {{ ref('stg_google_ads__ad_history') }}
    where is_most_recent_record = True

), final_url as (

    select *
    from {{ ref('stg_google_ads__ad_final_url_history') }}
    where is_most_recent_record = True

), currency_rates as (

    select *
    from {{ ref('stg_currency_rates') }}

), fields as (

    select
        stats.date_day,
        accounts.account_name,
        accounts.account_id,
        accounts.local_currency,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        final_url.base_url,
        final_url.url_host,
        final_url.url_path,
        final_url.utm_source,
        final_url.utm_medium,
        final_url.utm_campaign,
        final_url.utm_content,
        final_url.utm_term,
        sum(stats.spend) as spend_local_currency,
        sum({{ convert_amount_to_global_currency('stats.spend', 'accounts.local_currency', 'currency_rates.currency_rate') }}) as spend_global_currency,
        sum(stats.clicks) as clicks,
        sum(stats.impressions) as impressions

        {% for metric in var('google_ads__ad_stats_passthrough_metrics') %}
        , sum(stats.{{ metric }}) as {{ metric }}
        {% endfor %}

    from stats
    left join ads
        on stats.ad_id = ads.ad_id
    left join final_url
        on ads.ad_id = final_url.ad_id
    left join ad_groups
        on ads.ad_group_id = ad_groups.ad_group_id
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id
    left join accounts
        on campaigns.account_id = accounts.account_id
    left join currency_rates
        on accounts.local_currency = currency_rates.base_currency_code
        and currency_rates.quote_currency_code = '{{ var('attribution_global_currency') }}'
        and stats.date_day = currency_rates.currency_rate_date
    {{ dbt_utils.group_by(16) }}

)

select *
from fields

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
