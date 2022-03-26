{% if var("attribution_warehouse_ad_campaign_sources") and var("attribution_warehouse_event_sources") %}
{% if target.type == 'snowflake' %}

{{
    config(
      alias='ad_spend_roi_fact',
      materialized='table'
    )
}}

with ad_campaign_stats as (
  select
    *
  from
    {{ ref('wh_ad_campaign_performance_fact') }}
),
  revenue_attribution as (
    select

      {% for (key,value) in var('attribution_output_conversion_measures').items() %}

        {% for model in var('attribution_models')  %}

        sum({{value}}_{{model}}_conversions) {{value}}_{{model}}_conversions,

        {% endfor %}

      {% endfor %}

      {% for (key,value) in var('attribution_output_revenue_measures').items() %}

        {% for model in var('attribution_models')  %}

        sum({{value}}_{{model}}) as {{value}}_{{model}},

        {% endfor %}

      {% endfor %}

      date_trunc('DAY',converted_ts) as converted_ts,
      platform,
      campaign_id,
      ad_group_id
    from
      {{ ref('wh_attribution_fact') }}
    group by 73,74,75,76
  )
    select
      {% for (key,value) in var('attribution_output_conversion_measures').items() %}

        {% for model in var('attribution_models')  %}

        {{value}}_{{model}}_conversions,

        {% endfor %}

      {% endfor %}

      {% for (key,value) in var('attribution_output_revenue_measures').items() %}

        {% for model in var('attribution_models')  %}

        {{value}}_{{model}},

        {% endfor %}

{% endfor %}
    a.campaign_ts ,
    a.platform ,
    a.campaign_id ,
    a.campaign_name,
    a.ad_group_id ,
    a.ad_group_name,
    a.reported_clicks ,
    a.reported_impressions ,
    a.reported_spend_local_currency,
    a.reported_spend_global_currency,
    a.reported_cpc_local_currency,
    a.reported_cpc_global_currency,
    a.reported_ctr ,
    a.actual_clicks ,
    a.actual_cpc_local_currency,
    a.actual_cpc_global_currency,
    a.actual_ctr
from
  ad_campaign_stats a
left join
  revenue_attribution r
on
  a.campaign_ts = r.converted_ts
and
  a.campaign_id = r.campaign_id
and
  a.ad_group_id = r.ad_group_id
and
  a.platform = r.platform

  {% endif %}
  {% endif %}
