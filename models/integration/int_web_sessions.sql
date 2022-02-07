{% if var('attribution_warehouse_event_sources') %}

{{config(
  materialized='table'
  )}}

{% set partition_by = "partition by session_id" %}

{% set window_clause = "
    partition by session_id
    order by event_seq
    rows between unbounded preceding and unbounded following
    " %}

{% set first_values = {
    'utm_source' : 'utm_source',
    'utm_content' : 'utm_content',
    'utm_medium' : 'utm_medium',
    'utm_campaign' : 'utm_campaign',
    'utm_term' : 'utm_term',
    'search' : 'search',
    'gclid' : 'gclid',
    'page_url' : 'first_page_url',
    'page_url_host' : 'first_page_url_host',
    'page_url_path' : 'first_page_url_path',
    'referrer_host' : 'referrer_host',
    'device' : 'device',
    'device_category' : 'device_category',
    'channel' : 'channel'
    } %}

{% set last_values = {
    'page_url' : 'last_page_url',
    'page_url_host' : 'last_page_url_host',
    'page_url_path' : 'last_page_url_path',
    } %}

with events_sessionized as (

    select * from {{ref('int_web_events')}}

),
agg as (

    select distinct
        session_id,
        session_type,
        user_id,

        site,
        min(event_ts) over ( {{partition_by}} ) as session_start_ts,
        max(event_ts) over ( {{partition_by}} ) as session_end_ts,
        count(*) over ( {{partition_by}} ) as events,

        {% for (key, value) in first_values.items() %}
        first_value({{key}}) over ({{window_clause}}) as {{value}},
        {% endfor %}

        {% for (key, value) in last_values.items() %}
        last_value({{key}}) over ({{window_clause}}) as {{value}}{% if not loop.last %},{% endif %}
        {% endfor %}

    from events_sessionized

),

diffs as (

    select

        *,

        {{dbt_utils.datediff(
        'session_start_ts',
        'session_end_ts',
        'SECOND') }}

 as duration_in_s

    from agg

),

tiers as (

    select

        *,

        case
            when duration_in_s between 0 and 9 then '0s to 9s'
            when duration_in_s between 10 and 29 then '10s to 29s'
            when duration_in_s between 30 and 59 then '30s to 59s'
            when duration_in_s > 59 then '60s or more'
            else null
        end as duration_in_s_tier

    from diffs

)
select *,
      {{ dbt_utils.datediff('lead(session_start_ts, 1) OVER (PARTITION BY user_id ORDER BY session_start_ts DESC)','session_start_ts','MINUTE') }} AS mins_between_sessions,
      case when events = 1 then true else false end as is_bounced_session
from tiers

{% else %}

  {{config(enabled=false)}}

{% endif %}
