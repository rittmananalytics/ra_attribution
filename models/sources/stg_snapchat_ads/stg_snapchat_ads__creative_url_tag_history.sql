{% if var("attribution_warehouse_ad_sources") %}
{% if 'snapchat_ads' in var("attribution_warehouse_ad_sources") %}

with base as (

    select * 
    from {{ ref('stg_snapchat_ads__creative_url_tag_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_snapchat_ads__creative_url_tag_history_tmp')),
                staging_columns=get_creative_url_tag_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select  
        creative_id,
        key as param_key,
        value as param_value,
        updated_at
    from fields
),

most_recent as (

    select 
        *,
        row_number() over (partition by creative_id, param_key order by updated_at desc) =1 as is_most_recent_record
    from final

)

select * from most_recent

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
