{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_event_sources") %}
{% if 'custom_events_order' in var("attribution_warehouse_event_sources") %}

with
  order_lines as (
    select
      *
    from
    {% if var("attribution_demo_mode")  %}
      {{ ref("orders") }}
    {% else %}
      {{ source('custom_events', 'order_lines') }}
    {% endif %}
  ),
  orders as (
    select
      *
    from
    {% if var("attribution_demo_mode")  %}
      {{ ref("orders") }}
    {% else %}
      {{ source('custom_events', 'orders') }}
    {% endif %}

  ),
  agg_attribution_order_lines as (
    {% if var("attribution_demo_mode")  %}
    select
      *
    from
      {{ ref("orders") }}
    {% else %}
    select
        order_id,
        local_currency,
        sum(revenue_global_currency) as revenue_global_currency,
        sum(revenue_local_currency) as revenue_local_currency
    from
      order_lines
    group by order_id, local_currency
    {% endif %}
  ),
  attribution_orders as (
      select
        fo.*,
        null as is_excluded_order
      from
        orders fo
  ),
  joined as (
    select
      cast(fo.order_id as {{ dbt_utils.type_string() }}) as event_id,
      cast(null as {{ dbt_utils.type_string() }}) as session_id,
      cast(null as {{ dbt_utils.type_string() }}) as session_type,
      '{{ var('attribution_conversion_event_type') }}'  as event_type,
      fo.order_date as event_ts,
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
      cast(fo.user_id as {{ dbt_utils.type_string() }}) as visitor_id,
    	cast(fo.user_id as {{ dbt_utils.type_string() }}) as user_id,
    	cast(null as {{ dbt_utils.type_string() }}) as device ,
    	'custom_ltv' as site,
  	  cast(null as {{ dbt_utils.type_string() }}) as device_category,
      agg.local_currency as local_currency,
      agg.revenue_global_currency as revenue_global_currency,
      agg.revenue_local_currency as revenue_local_currency
    from
      attribution_orders as fo
    left join
      agg_attribution_order_lines as agg
    on fo.order_id = agg.order_id
  )
  select
    *
  from
   joined

 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
