{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_event_sources") %}
{% if 'custom_events_registration' in var("attribution_warehouse_event_sources") %}

with
  customers as (
    {% if var("attribution_demo_mode")  %}
    select
      user_id, user_created_date
    from
      {{ ref("orders") }}
    group by 1,2
    {% else %}
    select
      *
    from
      {{ source('custom_events', 'users') }}
    {% endif %}
  ),
  attribution_registrations as (
    select
      cast(user_id as varchar) as event_id,
      cast(null as {{ dbt_utils.type_string() }}) as session_id,
      cast(null as {{ dbt_utils.type_string() }}) as session_type,
      '{{ var('attribution_create_account_event_type') }}' as event_type,
      user_created_date as event_ts,
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
      'CUSTOM' as site,
      cast(null as {{ dbt_utils.type_string() }}) as DEVICE_CATEGORY
    from
      customers c
  )
  select
    *
  from
   attribution_registrations

 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
