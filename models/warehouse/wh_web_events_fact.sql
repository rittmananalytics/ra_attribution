{% if var("attribution_warehouse_event_sources") %}

{{
    config(
        alias='web_events_fact'
    )
}}

with events as
  (
    SELECT {{ dbt_utils.surrogate_key(['event_id']) }} as web_event_pk,
    *
    FROM   {{ ref('int_web_events') }}
  )
SELECT
  *
FROM
  events

{% else %}{{config(enabled=false)}}{% endif %}
