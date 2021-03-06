{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_ad_sources") %}
{% if 'google_ads' in var("attribution_warehouse_ad_sources") %}
{% if var("stg_google_ads_api_source") == 'adwords' %}

with base as (

    select *
    from {{ ref('stg_google_ads__criteria_performance') }}

), fields as (

    select
        date_day,
        account_name,
        external_customer_id,
        campaign_name,
        campaign_id,
        ad_group_name,
        ad_group_id,
        criteria,
        criteria_type,
        sum(spend) as spend,
        sum(clicks) as clicks,
        sum(impressions) as impressions

        {% for metric in var('stg_google_ads_criteria_passthrough_metrics') %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from base
    {{ dbt_utils.group_by(9) }}

)

select *
from fields

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
