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
  )
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
  user_id,
  device,
  device_category,
  session_id,
  session_type,
  site,
  case when event_type = '{{ var('attribution_conversion_event_type') }}'
    then cast(event_id as varchar) end as order_id,
  case when event_type = '{{ var('attribution_conversion_event_type') }}'
      then cast(revenue_global_currency as varchar) end as total_revenue_global_currency,
  case when event_type = '{{ var('attribution_conversion_event_type') }}'
      then cast(revenue_local_currency as varchar) end as total_revenue_local_currency,
  case when event_type = '{{ var('attribution_conversion_event_type') }}'
      then cast(local_currency as varchar) end as local_currency
from events_merge_list e
where event_ts <= current_timestamp() --filtering out data from the future


{% else %}

{{config(enabled=false)}}

{% endif %}
