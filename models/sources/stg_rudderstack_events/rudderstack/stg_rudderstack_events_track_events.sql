{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_event_sources") %}
{% if 'rudderstack_events_track' in var("attribution_warehouse_event_sources") %}

{{
    config(
        materialized="table"
    )
}}
with source AS (

    SELECT * FROM {{ source('rudderstack', 'tracks') }}

),

renamed AS (

    SELECT
        id                          AS event_id,
        cast(null as {{ dbt_utils.type_string() }}) as session_id,
        cast(null as {{ dbt_utils.type_string() }}) as session_type,
        event                       AS event_type,
        received_at                 AS event_ts,
        event_text                  AS event_details,
        CAST(null AS string )       AS page_title,
        context_page_path           AS page_url_path,
        replace(
            {{ dbt_utils.get_url_host('context_page_referrer') }},
            'www.',
            ''
        )                           AS referrer_host,
        context_page_search         AS search,
        context_page_url            AS page_url,
        {{ dbt_utils.get_url_host('context_page_url') }} AS page_url_host,
        {{ dbt_utils.get_url_parameter('context_page_url', 'gclid') }} AS gclid,
        CAST(null AS {{ dbt_utils.type_string() }})        AS utm_term,
        CAST(null AS {{ dbt_utils.type_string() }})     AS utm_content,
        CAST(null AS {{ dbt_utils.type_string() }})      AS utm_medium,
        CAST(null AS {{ dbt_utils.type_string() }})        AS utm_campaign,
        CAST(null AS {{ dbt_utils.type_string() }})      AS utm_source,
        context_ip                  AS ip,
        anonymous_id                AS visitor_id,
        user_id                     AS user_id,
        case
            when lower(context_user_agent) like '%android%' then 'Android'
            else replace(
              {{ dbt_utils.split_part("context_user_agent","'('","1") }},
                ';', '')
        end  AS device,
        concat(CAST('{{ var('stg_rudderstack_events_site') }}' AS {{ dbt_utils.type_string() }}),'/Rudderstack') as site,
        cast(null as {{ dbt_utils.type_string() }}) as order_id, -- amend this line and the following three more as appropriate
        cast(null as {{ dbt_utils.type_string() }}) as local_currency,
        cast(null as {{ dbt_utils.type_numeric() }}) as revenue_global_currency,
        cast(null as {{ dbt_utils.type_numeric() }}) as revenue_local_currency
    FROM source

)
,
final AS (

    SELECT
        *,
        case
            when device = 'iPhone' then 'iPhone'
            when device = 'Android' then 'Android'
            when device in ('iPad', 'iPod') then 'Tablet'
            when device in ('Windows', 'Macintosh', 'X11') then 'Desktop'
            else 'Uncategorized'
        end AS device_category
    FROM renamed

)
SELECT * FROM final

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
