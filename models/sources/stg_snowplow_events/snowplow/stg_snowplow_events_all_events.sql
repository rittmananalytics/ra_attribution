{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_event_sources") %}
{% if 'snowplow_events_all' in var("attribution_warehouse_event_sources") %}

with
  events as (
    select
      *
    from
      {% if var("attribution_demo_mode")  %}
        {{ ref("events") }}
      {% else %}
        {{ source('snowplow', 'events') }}
      {% endif %}
    where
      domain_session_id is not null
    ),
  renamed as (
    select
      cast(event_id as {{ dbt_utils.type_string() }}) as event_id,
      cast(domain_session_id as {{ dbt_utils.type_string() }}) as session_id,
      'Snowplow' as session_type,
      cast(event as {{ dbt_utils.type_string() }}) as event_type,
      event_time as event_ts,
      cast(page_title as {{ dbt_utils.type_string() }}) as event_details,
      cast(page_title as {{ dbt_utils.type_string() }}) as page_title,
      cast(page_url_path as {{ dbt_utils.type_string() }}) as page_url_path,
      cast(page_url_path as {{ dbt_utils.type_string() }}) as referrer_host,
      cast(null as {{ dbt_utils.type_string() }}) as search,
      cast(page_url as {{ dbt_utils.type_string() }}) as page_url,
      {{ dbt_utils.get_url_host('page_url') }} as page_url_host,
      {{ dbt_utils.get_url_parameter('page_url', 'gclid') }} as gclid,
      cast(marketing_term as {{ dbt_utils.type_string() }}) as utm_term,
      cast(marketing_content as {{ dbt_utils.type_string() }}) as utm_content,
      cast(marketing_medium as {{ dbt_utils.type_string() }}) as utm_medium,
      cast(marketing_campaign as {{ dbt_utils.type_string() }}) as utm_campaign,
      cast(marketing_source as {{ dbt_utils.type_string() }}) as utm_source,
      case
        -- paid search:
        when marketing_click_id is not null
            and marketing_medium is null
            and (rlike(page_url_query, '.*keyword\=[^&]*custom.*','i')
                    or rlike(page_url_path,'/[^/]+/','i')
            )
        then 'paid brand search'
        when marketing_click_id is not null
            and marketing_medium is null then 'paid generic search'

        -- organic search:
        when marketing_click_id is null
            and rlike(referer_url_host,'.*(www\.google|bing\.com|duckduckgo\.com|startsiden\.no|search\.yahoo\.com|kvasir|ecosia).*','i')
        then 'organic search'

        -- paid social:
        when page_url ilike '%fbclid%'
            and (rlike(referer_url_host,'.*(instagram|facebook).*','i') or referer_url_host is null)
        then 'paid social'
        when referer_url_host ilike '%snapchat%' or rlike(marketing_source,'.*(snap).*','i')
        then 'paid social'

        -- organic social:
        when not page_url ilike '%fbclid%'
        and rlike(referer_url_host,'.*(instagram|facebook).*','i')
        then 'organic social'

        -- email:
        when rlike(referer_url_host, '.*(mail).*','i')
            or rlike(marketing_medium,'.*(mail|newsletter).*','i')
        then 'email'

        -- display:
        when rlike( marketing_medium,'.*(cpm|display|banner|preroll|olv|direct).*','i')
        then 'paid display'

        -- other campaigns:
        when marketing_medium is not null
            or marketing_source is not null
            or marketing_campaign is not null
        then 'other paid campaigns'

        -- payment gateway referrals:
        when rlike(referer_url_host,'.*(3dsecure).*','i')
        then 'payment gateway'

        -- referrals:
        when referer_url_host is not null
            and not rlike(referer_url_host,'.*(custom\.com).*','i')
        then 'referral'
        else 'direct'
      end as channel,
      cast(user_ipaddress as {{ dbt_utils.type_string() }}) as ip,
      cast(user_id as {{ dbt_utils.type_string() }}) as user_id,
      case
        when lower(useragent) like '%android%'
          then 'Android'
          else replace({{ dbt_utils.split_part("useragent","'('","1") }},
            ';', '')
          end as device,
      cast(page_url_host as {{ dbt_utils.type_string() }}) as site
    from
      events),
  final as (
    select
      *,
      case
        when device = 'iPhone' then 'iPhone'
        when device = 'Android' then 'Android'
        when device in ('iPad', 'iPod') then 'Tablet'
        when device in ('Windows', 'Macintosh', 'X11') then 'Desktop'
        else 'Uncategorized'
      end as device_category
      from renamed
    )
select
  *
from
  final


{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
