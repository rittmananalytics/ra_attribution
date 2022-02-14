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
  events as (
    select
      *
    from
      {{ ref('stg_snowplow_events_all_events') }}
  ),
  attribution_registrations as (
    select
      cast(user_id as varchar) as event_id,
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
    	cast(user_id as {{ dbt_utils.type_string() }}) as user_id,
    	cast(null as {{ dbt_utils.type_string() }}) as device ,
      'CUSTOM' as site,
      cast(null as {{ dbt_utils.type_string() }}) as DEVICE_CATEGORY
    from
      customers c
  ),
  attribution_sessions as (
      select
        user_id ,
        session_id,
        session_type,
        MIN(event_ts) as session_start_ts,
        {{ dbt_utils.dateadd('MINUTE','30','max(event_ts)') }} as session_end_ts_plus_30_mins
      from
        events
      group by
        1,2,3
  ),
  sessions_to_next_session as (
    select
      user_id,
      session_id,
      session_type,
      session_start_ts,
      case
        when lead(session_start_ts,1) over (partition by user_id order by session_start_ts) < session_end_ts_plus_30_mins
        then {{ dbt_utils.dateadd('SECOND','-1','lead(session_start_ts,1) over (partition by user_id order by session_start_ts)') }}
        else session_end_ts_plus_30_mins
      end as session_end_ts_plus_30_mins
    from
      attribution_sessions
  ),
  events_with_session_ids as (
    select
      e.event_id,
      case
        when s.session_id is null then {{ dbt_utils.surrogate_key(['e.event_id','e.user_id']) }}
        else s.session_id
        end as session_id,
      case
        when s.session_type is null then 'dbt Generated'
        else s.session_type
      end as session_type,
      e.event_type,
      e.event_ts,
      e.event_details,
      e.page_title,
      e.page_url_path,
      e.referrer_host,
      e.search,
      e.page_url ,
      e.page_url_host ,
    	e.gclid ,
    	e.utm_term ,
    	e.utm_content ,
    	e.utm_medium ,
    	e.utm_campaign ,
    	e.utm_source ,
      e.channel,
    	e.ip ,
    	e.user_id,
      e.device,
      e.site,
      e.device_category
    from
      attribution_registrations e
    left join
      sessions_to_next_session s
    on

    {% if var("attribution_match_offline_conversions_to_sessions") %}

      e.user_id = s.user_id
    and
      e.event_ts between s.session_start_ts and s.session_end_ts_plus_30_mins
    and
      {{dbt_utils.datediff("session_start_ts","session_end_ts_plus_30_mins","'HOUR'") }} <= {{ var("attribution_max_session_hours") }}

    {% else %}

      1=0 -- i.e. don't match conversions to an existing session

    {% endif %}

    )
  select
    *
  from
   events_with_session_ids

 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
 {% else %} {{config(enabled=false)}} {% endif %}
