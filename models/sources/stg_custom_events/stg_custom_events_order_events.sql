{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_event_sources") %}
{% if 'custom_events_order' in var("attribution_warehouse_event_sources") %}

with
  order_lines as (
    select
      order_id, sum(revenue_local_currency) as revenue_local_currency, sum(revenue_global_currency) as revenue_global_currency
    from
    {% if var("attribution_demo_mode")  %}
      {{ ref("orders") }}
    {% else %}
      {{ source('custom_events', 'order_lines') }}
    {% endif %}
    group by
      1
  ),
  orders as (
    select
      order_id, user_id, order_date, local_currency, global_currency
    from
    {% if var("attribution_demo_mode")  %}
      {{ ref("orders") }}
    {% else %}
      {{ source('custom_events', 'orders') }}
    {% endif %}
    group by
      1,2,3,4,5
  ),
  agg_attribution_order_lines as (
    select
        o.order_id,
        o.user_id,
        o.order_date,
        o.local_currency,
        o.global_currency,
        sum(ol.revenue_global_currency) as revenue_global_currency,
        sum(ol.revenue_local_currency) as revenue_local_currency
    from
      orders o
    join
      order_lines ol
    on
      o.order_id = ol.order_id
    group by 1,2,3,4,5
  ),
  events as (
    select
      cast(order_id as {{ dbt_utils.type_string() }}) as event_id,
      cast(null as {{ dbt_utils.type_string() }}) as session_id,
      cast(null as {{ dbt_utils.type_string() }}) as session_type,
      '{{ var('attribution_conversion_event_type') }}'  as event_type,
      order_date as event_ts,
      cast(null as {{ dbt_utils.type_string() }}) as event_details,
      cast(null as {{ dbt_utils.type_string() }}) as page_title,
      cast(null as {{ dbt_utils.type_string() }}) as page_url_path,
      cast(null as {{ dbt_utils.type_string() }}) as referrer_host,
      cast(null as {{ dbt_utils.type_string() }}) as search,
      cast(null as {{ dbt_utils.type_string() }}) as page_url,
      cast(null as {{ dbt_utils.type_string() }}) as page_url_host,
      cast(null as {{ dbt_utils.type_string() }}) as gclid,
      cast(null as {{ dbt_utils.type_string() }}) as utm_term,
      cast(null as {{ dbt_utils.type_string() }}) as utm_content,
      cast(null as {{ dbt_utils.type_string() }}) as utm_medium,
      cast(null as {{ dbt_utils.type_string() }}) as utm_campaign,
      cast(null as {{ dbt_utils.type_string() }}) as utm_source,
      'direct' as channel,
    	cast(null as {{ dbt_utils.type_string() }}) as ip ,
      cast(user_id as {{ dbt_utils.type_string() }}) as visitor_id,
    	cast(user_id as {{ dbt_utils.type_string() }}) as user_id,
    	cast(null as {{ dbt_utils.type_string() }}) as device ,
    	'CUSTOM_OFFLINE' as site,
  	  cast(null as {{ dbt_utils.type_string() }}) as device_category,
      local_currency as local_currency,
      revenue_global_currency as revenue_global_currency,
      revenue_local_currency as revenue_local_currency
    from
      agg_attribution_order_lines
  )
  select
    *
  from
   events

 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
