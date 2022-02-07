with source_users as (
  select
    date_trunc('month', joined_time) as months,
    count(distinct user_id) as source_users
  from
    {{ source('custom', 'users') }}
  group by
    1
),
source_orders as (
  select
    date_trunc('month', created_time) as months,
    count(distinct order_id) as source_orders
  from
    {{ source('custom', 'orders') }}
  group by
    1
),
source_revenue as (
  select
    date_trunc('month', o.created_time) as months,
    sum(ol.revenue_global_currency) as source_revenue
  from
    {{ source('custom', 'order_lines') }} ol
  join
    {{ source('custom', 'orders') }} o
  on
    o.order_id = ol.order_id
  group by
    1
),
source_snowplow_sessions as (
  select
    date_trunc('month',event_time) as months,
    count(distinct domain_session_id) as source_snowplow_sessions
  from
    {{ source('snowplow', 'events') }}
  where
    domain_session_id is not null
  group by
    1
),
source_google_ad_measures as (
  select
    date_trunc('month',date) as months,
    sum(clicks) as source_google_ad_clicks,
    sum(impressions) as source_google_ad_impressions,
    sum(cost) as source_google_ad_spend
  from
    {{ source('adwords','ad_stats') }}
  group by
    1
),
source_facebook_ad_measures as (
  select
    date_trunc('month',date) as months,
    sum(inline_link_clicks) as source_fb_ad_clicks,
    sum(impressions) as source_fb_ad_impressions,
    sum(spend) as source_fb_ad_spend
  from
    {{ source('facebook_ads','basic_ad') }}
  group by
    1
),
staging_custom_generated_order_sessions as (
  select
    date_trunc('month', event_ts) as months,
    count(distinct session_id) as staging_custom_generated_order_sessions
  from
    {{ ref('stg_custom_events_order_events') }}
  where
    session_type = 'dbt Generated'
  group by
    1
),
staging_custom_generated_user_registration_sessions as (
  select
    date_trunc('month', event_ts) as months,
    count(distinct session_id) as staging_custom_generated_user_registration_sessions
  from
    {{ ref('stg_custom_events_registration_events') }}
  where
    session_type = 'dbt Generated'
  group by
    1
),
staging_snowplow_sessions as (
  select
    date_trunc('month', event_ts) as months,
    count(distinct session_id) as staging_snowplow_sessions
  from
    {{ ref('stg_snowplow_events_all_events')}}
  group by
    1
),
staging_users as (
  select
    date_trunc('month', event_ts) as months,
    count(distinct user_id) as staging_users
  from
    {{ ref('stg_custom_events_registration_events') }}
  group by
    1
),
staging_orders as (
  select
    date_trunc('month', event_ts) as months,
    count(distinct event_id) as staging_orders,
    sum(revenue_global_currency) as staging_revenue
  from
    {{ ref('stg_custom_events_order_events') }}
  group by
    1
),
staging_google_ad_measures as (
  select
    date_trunc('month',date_day) as months,
    sum(clicks) as staging_google_ad_clicks,
    sum(impressions) as staging_google_ad_impressions,
    sum(spend_local_currency) as staging_google_ad_spend
  from
    {{ ref('google_ads__url_ad_adapter') }}
  group by
    1
),
staging_facebook_ad_measures as (
  select
    date_trunc('month',date_day) as months,
    sum(clicks) as staging_fb_ad_clicks,
    sum(impressions) as staging_fb_ad_impressions,
    sum(spend_local_currency) as staging_fb_ad_spend
  from
    {{ ref('stg_facebook_ads__ad_adapter') }}
  group by
    1
),
int_users_orders as (
  select
    date_trunc('month',event_ts) as months,
    count(distinct case when event_type = '{{ var('attribution_create_account_event_type') }}' then event_id end ) as int_users,
    count(distinct case when event_type = 'confirmed_order' then event_id end ) as int_orders,
    sum(case when event_type = 'confirmed_order' then total_revenue_global_currency end) as int_revenue
  from
    {{ ref('int_web_events') }}
  group by
    1
),
int_sessions as (
  select
    date_trunc('month',session_start_ts) as months,
    count(distinct session_id) as int_sessions
  from
    {{ ref('int_web_sessions') }}
  group by
    1
),
int_ad_measures as (
  select
    date_trunc('month',campaign_ts) as months,
    sum(reported_clicks) as int_ad_clicks,
    sum(reported_impressions) as int_ad_impressions,
    sum(reported_spend_local_currency) as int_ad_spend
  from
    {{ ref('int_ad_campaign_performance') }}
  group by
    1
),
warehouse_sessions as (
  select
    date_trunc('month',session_start_ts) as months,
    count(distinct session_id) as warehouse_sessions
  from
    {{ ref('wh_web_sessions_fact') }}
  group by
    1
),
warehouse_users_orders as (
  select
    date_trunc('month',event_ts) as months,
    count(distinct case when event_type = '{{ var('attribution_create_account_event_type') }}' then event_id end ) as warehouse_users,
    count(distinct case when event_type = 'confirmed_order' then event_id end ) as warehouse_orders,
    sum(case when event_type = 'confirmed_order' then total_revenue_global_currency end ) as warehouse_revenue
  from
    {{ ref('wh_web_events_fact') }}
  group by
    1
),
warehouse_ad_measures as (
  select
    date_trunc('month',campaign_ts) as months,
    sum(reported_clicks) as wh_ad_clicks,
    sum(reported_impressions) as wh_ad_impressions,
    sum(reported_spend_local_currency) as wh_ad_spend
  from
    {{ ref('wh_ad_campaign_performance_fact') }}
  group by
    1
),
attribution_users_orders as (
  select
    date_trunc('month',converted_ts) as months,
    sum(count_registration_conversions) as attribution_users,
    sum(count_first_order_conversions)+sum(count_repeat_order_conversions) as attribution_orders,
    sum(first_order_total_revenue_global_currency) + sum(repeat_order_total_revenue_global_currency) as attribution_revenue
  from
    {{ ref("wh_attribution_fact")}}
  group by
    1
)
select
  o.months,
  o.source_users,
  s.staging_users,
  i.int_users,
  w.warehouse_users,
  a.attribution_users,

  so.source_orders,
  sor.staging_orders,
  i.int_orders,
  w.warehouse_orders,
  a.attribution_orders,

  sr.source_revenue,
  sor.staging_revenue,
  i.int_revenue,
  w.warehouse_revenue,
  a.attribution_revenue,

  sss.source_snowplow_sessions,
  ogo.staging_custom_generated_order_sessions,
  ogs.staging_custom_generated_user_registration_sessions,
  stss.staging_snowplow_sessions,
  iss.int_sessions,
  ws.warehouse_sessions,

  sfb.source_fb_ad_clicks,
  stfb.staging_fb_ad_clicks,
  sg.source_google_ad_clicks,
  stg.staging_google_ad_clicks,
  ia.int_ad_clicks,
  wha.wh_ad_clicks,

  sfb.source_fb_ad_impressions,
  stfb.staging_fb_ad_impressions,
  sg.source_google_ad_impressions,
  stg.staging_google_ad_impressions,
  ia.int_ad_impressions,
  wha.wh_ad_impressions,

  sfb.source_fb_ad_spend,
  stfb.staging_fb_ad_spend,
  sg.source_google_ad_spend,
  stg.staging_google_ad_spend,
  ia.int_ad_spend,
  wha.wh_ad_spend

from source_users o
left join source_orders so
  on o.months = so.months
left join source_revenue sr
  on o.months = sr.months
left join source_snowplow_sessions sss
  on o.months = sss.months
left join source_facebook_ad_measures sfb
  on o.months = sfb.months
left join source_google_ad_measures sg
  on o.months = sg.months
left join staging_users s
  on o.months=s.months
left join staging_orders sor
  on o.months = sor.months
left join staging_custom_generated_order_sessions ogo
  on o.months = ogo.months
left join staging_custom_generated_user_registration_sessions ogs
  on o.months = ogs.months
left join staging_snowplow_sessions stss
  on o.months = stss.months
left join staging_facebook_ad_measures stfb
  on o.months = stfb.months
left join staging_google_ad_measures stg
  on o.months = stg.months
left join int_users_orders i
  on o.months = i.months
left join int_sessions iss
  on o.months = iss.months
left join int_ad_measures ia
  on o.months = ia.months
left join warehouse_sessions ws
  on o.months = ws.months
left join warehouse_users_orders w
  on o.months = w.months
left join warehouse_ad_measures wha
  on o.months = wha.months
left join attribution_users_orders a
  on o.months = a.months
order by 1 desc
