{% if var("attribution_warehouse_event_sources") %}

{{
    config(
        alias='web_sessions_fact'
    )
}}

with sessions as
  (
    SELECT
      *
    FROM (
      SELECT
        session_id,
        session_type,
        session_start_ts,
        session_end_ts,
        events,
        utm_source,
        utm_content,
        utm_medium,
        utm_campaign,
        utm_term,
        search,
        gclid,
        first_page_url,
        first_page_url_host,
        first_page_url_path,
        referrer_host,
        device,
        device_category,
        last_page_url,
        last_page_url_host,
        last_page_url_path,
        duration_in_s,
        duration_in_s_tier,
        channel,
        blended_user_id,
        sum(mins_between_sessions) over (partition by session_id) as mins_between_sessions,
        is_bounced_session
      FROM
        {{ ref('int_web_sessions') }}
      )
      {{ dbt_utils.group_by(n=27) }}
),
ad_click_ids as (
  select
    gclid,
    ad_group_id,
    campaign_id
  from
    {{ ref('int_ad_click_ids') }}
  group by
    1,2,3),

    /*  We match to the ad network data using the "clid", a concatenated combination of campaignid_adsetid_adid that we obtain

        by matching by click ID (GCLID for now) and using the campaign_id and adset_id that apply to that click ID,  or if a click ID can't be
        found we then search for "clid" in the first_page_url and parse its contents into its campaign_id, adset_id (aka ad_group_id) and ad_id elements,

        Note: as Google Ads cost and other reported stats data is only available down to Ad Group level, we only report at that level and leave "adid" out of the join
        Note : as we can't reliably use utm_source to determine the Ad network (platform) value, we infer it using the presence of "gclid" or "fbclid" in the URL, or "google"/"facebook" in utm_source */

joined as (

    SELECT {{ dbt_utils.surrogate_key(['session_id']) }} as web_session_pk,
    s.*,
    case
      when first_page_url ilike '%fbclid%' or utm_source ilike '%facebook%' then 'Facebook Ads'
      when s.gclid is not null or utm_source ilike '%google%' then 'Google Ads'
      else null end
    as platform,
    coalesce(i.campaign_id,split_part(split_part(split_part(first_page_url,'clid=',2),'&',1),'_',1)) as campaign_id,
    coalesce(i.ad_group_id,split_part(split_part(split_part(first_page_url,'clid=',2),'&',1),'_',2)) as ad_group_id,
    case when i.gclid is not null and i.campaign_id is not null and i.ad_group_id is not null then true else false end as is_click_id_matched
  from
    sessions s
  left join
    ad_click_ids i
  on s.gclid = i.gclid
)
select
  *
from
  joined
    {% else %}{{config(enabled=false)}}{% endif %}
