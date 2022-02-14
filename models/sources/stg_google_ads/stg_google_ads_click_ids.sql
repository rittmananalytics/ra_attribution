{% if target.type == 'bigquery' or target.type == 'snowflake' or target.type == 'redshift' %}
{% if var("attribution_warehouse_click_id_sources") %}
{% if 'google_ads' in var("attribution_warehouse_click_id_sources") %}
{% if var("stg_google_ads_api_source") == 'google_ads' %}


/* this model creates a lookup list of GCLIDs with their corresponding ad_group and campaign IDs,
for use later in the pipeline to tag incoming Snowplow events with ad_group and campaign ID values,
which we then use to match to ad spend and reported stats data from the ad networks for marketing optimization and
revenue/cost attribution models */

with source as (
  select
    *
  from
    {{ source('adwords','click_performance') }}
),
renamed as (
  select
    gcl_id as gclid,
    cast (ad_group_id as varchar) as ad_group_id,
    cast (campaign_id as varchar) as campaign_id,
    customer_id,
    external_customer_id
  from
    source
group by 1,2,3,4,5
)
select
  *
from
  renamed

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
