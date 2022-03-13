{% if var('attribution_warehouse_event_sources') %}

{{config(
  materialized='incremental'
  ,unique_key='event_id'
  )}}


with events_merge_list as
  (
    {% set relations_list = [] %}
    {% for source in var('attribution_warehouse_event_sources') %}
      {% do relations_list.append(ref('stg_' ~ source ~ '_events')) %}
    {% endfor %}

    {{ incremental_union(
      relations=relations_list, incremental_filter='event_ts')
    }}
  ),
events_with_conversions as (
select
  event_id,
  event_type,
  event_ts,
  row_number() over (partition by user_id order by event_ts) as event_seq,
  row_number() over (partition by user_id, session_id order by event_ts) as event_in_session_seq,
  event_details,
  page_title,
  page_url_path,
  referrer_host,
  search,
  page_url,
  page_url_host,
  gclid,
  utm_term,
  utm_content,
  utm_medium,
  utm_campaign,
  utm_source,
  channel,
  ip,
  visitor_id,
  user_id,
  device,
  device_category,
  session_id,
  session_type,
  site,
  order_id,
  revenue_global_currency as total_revenue_global_currency,
  revenue_local_currency as total_revenue_local_currency,
  local_currency
from events_merge_list e)
,
id_stitching as (

    select distinct

        visitor_id as visitor_id,

        last_value(user_id ignore nulls) over (
            partition by visitor_id
            order by event_ts
            rows between unbounded preceding and unbounded following
        ) as user_id,

        min(event_ts) over (
            partition by visitor_id
        ) as first_seen_at,

        max(event_ts) over (
            partition by visitor_id
        ) as last_seen_at

    from events_with_conversions
),
numbered as (

    select

        *,

        row_number() over (
            partition by visitor_id
            order by event_ts
          ) as event_number

    from events_with_conversions

),
lagged as (

    select

        *,

        lag(event_ts) over (
            partition by visitor_id
            order by event_number
          ) as previous_event_ts

    from numbered

),

diffed as (

    select
        *,
        {{ dbt_utils.datediff('event_ts','previous_event_ts','second') }} as period_of_inactivity

    from lagged

),

new_sessions as (


    select
        *,
        case
            when period_of_inactivity <= {{var('web_inactivity_cutoff')}} then 0
            else 1
        end as new_session
    from diffed

),

session_numbers as (


    select

        *,

        sum(new_session) over (
            partition by visitor_id
            order by event_number
            rows between unbounded preceding and current row
            ) as session_number

    from new_sessions

),

session_ids AS (

  SELECT
  event_id,
  event_type,
  event_ts,
  event_number as event_seq,
  event_details,
  page_title,
  page_url_path,
  referrer_host,
  search,
  page_url,
  page_url_host,
  gclid,
  utm_term,
  utm_content,
  utm_medium,
  utm_campaign,
  utm_source,
  channel,
  ip,
  visitor_id,
  user_id,
  device,
  device_category,
  site,
    coalesce(session_id,md5(CONCAT(CONCAT(visitor_id::varchar,'-'),coalesce(session_number::varchar,''::varchar)))) as session_id,
    coalesce(session_type,'SESSIONIZED') as session_type,
  order_id,
  total_revenue_global_currency,
  total_revenue_local_currency,
  local_currency
  FROM
    session_numbers ),


joined as (

    select

        session_ids.*,

        coalesce(id_stitching.user_id, session_ids.visitor_id)
            as blended_user_id

    from session_ids
    left join id_stitching on id_stitching.visitor_id = session_ids.visitor_id

),
ordered as (
  select *,
         row_number() over (partition by blended_user_id, session_id order by event_ts) as event_in_session_seq,

         case when event_type = 'Page View'
         and session_id = lead(session_id,1) over (partition by visitor_id order by event_seq)
         then {{ dbt_utils.datediff('lead(event_ts,1) over (partition by visitor_id order by event_seq)','event_ts','SECOND') }} end time_on_page_secs
  from joined

)
select *
from ordered


{% else %}

{{config(enabled=false)}}

{% endif %}
