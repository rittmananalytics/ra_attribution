{% if target.type == 'snowflake' %}
{% if var("attribution_warehouse_ad_sources") %}
{% if 'facebook_ads' in var("attribution_warehouse_ad_sources") %}

with base as (

    select *
    from {{ ref('int__facebook_ads__carousel_media_prep') }}

), fields as (

    select
        _fivetran_id,
        creative_id,
        caption,
        description,
        message,
        link,
        index
    from base

)

select *
from fields

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
