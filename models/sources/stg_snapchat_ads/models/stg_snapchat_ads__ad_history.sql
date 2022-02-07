{% if var("attribution_warehouse_ad_sources") %}
{% if 'snapchat_ads' in var("attribution_warehouse_ad_sources") %}

with base as (

    select * 
    from {{ ref('stg_snapchat_ads__ad_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_snapchat_ads__ad_history_tmp')),
                staging_columns=get_ad_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as ad_id,
        ad_squad_id,
        creative_id,
        name as ad_name,
        _fivetran_synced
    from fields
),

most_recent as (

    select 
        *,
        row_number() over (partition by ad_id order by _fivetran_synced desc) = 1 as is_most_recent_record
    from final

)

select * from most_recent

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
