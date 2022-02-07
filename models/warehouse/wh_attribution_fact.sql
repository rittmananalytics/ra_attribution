{% if var("attribution_warehouse_ad_campaign_sources") and var("attribution_warehouse_event_sources") %}
{% if target.type == 'snowflake' %}

{{
    config(
      alias='attribution_fact',
      materialized='table'
    )
}}



with

/* start with the subset of all events that were either first order, last order or first account opening events */

events_filtered as
  (select
    *
  from (
    select
      *,
      first_value(case when event_type = '{{ var('attribution_create_account_event_type') }}' then event_id end ignore nulls) over (partition by user_id order by event_ts rows between unbounded preceding and unbounded following) as first_registration_event_id,
      first_value(case when event_type = '{{ var('attribution_conversion_event_type') }}' then event_id end ignore nulls) over (partition by user_id order by event_ts rows between unbounded preceding and unbounded following) as first_order_event_id
    from
      {{ ref ('wh_web_events_fact') }})
  where
    ((event_type = '{{ var('attribution_conversion_event_type') }}'
    or (event_type = '{{ var('attribution_create_account_event_type') }}' and event_id = first_registration_event_id)) and user_id not in ('-2','-1'))
  ),

/* get the pre-calculated user LTVs over 30,60,90,180 and 365 days, with LTV = lifetime customer spend */

  user_ltvs as
    (
    select
      *
    from
      {{ ref('int_user_ltv') }}
    ),

  /* Now add columns to this subset of events for the nunber of each type of conversion and revenue amounts for first and repeat orders
  we use these later on to calculate conversion cycles and for attributing conversions and revenue */

  converting_events as
    (
    select
      e.user_id,
      session_id,
      event_type,
      order_id,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then total_revenue_local_currency else 0 end as first_order_total_revenue_local_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then total_revenue_global_currency else 0 end as first_order_total_revenue_global_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_30d_local_currency else 0 end as first_order_total_lifetime_value_30d_local_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_30d_global_currency else 0 end as first_order_total_lifetime_value_30d_global_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_60d_local_currency else 0 end as first_order_total_lifetime_value_60d_local_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_60d_global_currency else 0 end as first_order_total_lifetime_value_60d_global_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_90d_local_currency else 0 end as first_order_total_lifetime_value_90d_local_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_90d_global_currency else 0 end as first_order_total_lifetime_value_90d_global_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_180d_local_currency else 0 end as first_order_total_lifetime_value_180d_local_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_180d_global_currency else 0 end as first_order_total_lifetime_value_180d_global_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_365d_local_currency else 0 end as first_order_total_lifetime_value_365d_local_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then l.ltv_365d_global_currency else 0 end as first_order_total_lifetime_value_365d_global_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id != first_order_event_id then total_revenue_local_currency else 0 end as repeat_order_total_revenue_local_currency,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id != first_order_event_id then total_revenue_global_currency else 0 end as repeat_order_total_revenue_global_currency,
      e.local_currency,
      case when event_type in ('{{ var('attribution_conversion_event_type') }}','{{ var('attribution_create_account_event_type') }}') then 1 else 0 end as count_conversions,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id = first_order_event_id then 1 else 0 end as count_first_order_conversions,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' and event_id != first_order_event_id then 1 else 0 end as count_repeat_order_conversions,
      case when event_type = '{{ var('attribution_conversion_event_type') }}' then 1 else 0 end as count_order_conversions,
      case when event_type = '{{ var('attribution_create_account_event_type') }}' and event_id = first_registration_event_id then 1 else 0 end as count_registration_conversions,
      event_ts as converted_ts
    from
     events_filtered e
    left join
      user_ltvs l
    on
      e.user_id = l.user_id
  ),

  /* Now we aggregate those events into sessions (and per-user sub sessions, see above note about web_session_pk), with session_id sourced from either the Snowplow session_id (domain_session_id)
  or the order_id/user_id as session id substitute when the order/account opening happened outside a Snowplow session.
  See the stg_custom_events_order_events.sql and stg_custom_events_registration_events.sql models for the logic for those "dbt_generated" sessions */

converting_sessions_deduped as
  (
  select
    session_id as session_id,
    max(user_id) as user_id,

 /* note that because a session could in-theory contain account opening, first order and multiple repeat order events (conversions) within the same session, we have to aggregate the
 value of those conversions when working at the session level */

    sum(first_order_total_revenue_local_currency) as first_order_total_revenue_local_currency,
    sum(first_order_total_revenue_global_currency) as first_order_total_revenue_global_currency,
    sum(first_order_total_lifetime_value_30d_local_currency) as first_order_total_lifetime_value_30d_local_currency,
    sum(first_order_total_lifetime_value_30d_global_currency) as first_order_total_lifetime_value_30d_global_currency,
    sum(first_order_total_lifetime_value_60d_local_currency) as first_order_total_lifetime_value_60d_local_currency,
    sum(first_order_total_lifetime_value_60d_global_currency) as first_order_total_lifetime_value_60d_global_currency,
    sum(first_order_total_lifetime_value_90d_local_currency) as first_order_total_lifetime_value_90d_local_currency,
    sum(first_order_total_lifetime_value_90d_global_currency) as first_order_total_lifetime_value_90d_global_currency,
    sum(first_order_total_lifetime_value_180d_local_currency) as first_order_total_lifetime_value_180d_local_currency,
    sum(first_order_total_lifetime_value_180d_global_currency) as first_order_total_lifetime_value_180d_global_currency,
    sum(first_order_total_lifetime_value_365d_local_currency) as first_order_total_lifetime_value_365d_local_currency,
    sum(first_order_total_lifetime_value_365d_global_currency) as first_order_total_lifetime_value_365d_global_currency,
    sum(repeat_order_total_revenue_local_currency) as repeat_order_total_revenue_local_currency,
    sum(repeat_order_total_revenue_global_currency) as repeat_order_total_revenue_global_currency,
    max(local_currency) as local_currency,
    sum(count_first_order_conversions) as count_first_order_conversions,
    sum(count_repeat_order_conversions) as count_repeat_order_conversions,
    sum(count_order_conversions) as count_order_conversions,
    sum(count_registration_conversions) as count_registration_conversions,
    sum(count_registration_conversions)
    + sum(count_first_order_conversions)
    + sum(count_repeat_order_conversions) as count_conversions,
    max(converted_ts) as converted_ts, -- actually the max_converted_ts
    min(converted_ts) as min_converted_ts
  from
    converting_events
  group by
    1
),

  /* Combine (join) those conversion sessions with all of the sessions that led-up to those conversions */

  touchpoint_and_converting_sessions_labelled as
    (
      select
        *
        from (
          select
            *,
            first_value(converted_ts ignore nulls)
              over (partition by user_id order by session_start_ts rows between current row and unbounded following)
            as conversion_cycle_conversion_ts, -- used later on to calculate days to conversion
            row_number()
              over (partition by user_id order by session_start_ts)
            as session_seq
          FROM (
            SELECT
              s.user_id as user_id,
              s.web_session_pk as web_session_pk,
              s.session_start_ts as session_start_ts,
              s.session_end_ts as session_end_ts,
              c.converted_ts as converted_ts,
              c.min_converted_ts as min_converted_ts,
              coalesce(case when c.count_conversions >0 then true else false end,false) as conversion_session,
              coalesce(case when c.count_conversions >0 then 1 else 0 end,0) as conversion_event,  --used when calculating the conversion cycle number
              coalesce(case when c.count_order_conversions>0 then 1 else 0 end ,0) as order_conversion_event, --used when calculating the order converion cycle number
              coalesce(case when c.count_registration_conversions>0 then 1 else 0 end,0) as registration_conversion_event, -- see above
              coalesce(case when c.count_first_order_conversions>0 then 1 else 0 end,0) as first_order_conversion_event, -- ditto
              coalesce(case when c.count_repeat_order_conversions>0 then 1 else 0 end,0) as repeat_order_conversion_event, -- ditto
              utm_source as utm_source,
              utm_content as utm_content,
              utm_medium as utm_medium,
              utm_campaign as utm_campaign,
              platform,
              campaign_id,
              ad_group_id,
              referrer_host as referrer_host,
              first_page_url_host as first_page_url_host,
              null as referrer_domain ,
              channel as channel,
              case when lower(channel) = 'direct' then false else true end as is_non_direct_channel,
              case when lower(channel) like '%paid%' then true else false end as is_paid_channel,
              events as events,
              c.first_order_total_revenue_local_currency as first_order_total_revenue_local_currency,
              c.first_order_total_revenue_global_currency as first_order_total_revenue_global_currency,
              c.repeat_order_total_revenue_local_currency as repeat_order_total_revenue_local_currency,
              c.repeat_order_total_revenue_global_currency as repeat_order_total_revenue_global_currency,
              c.first_order_total_lifetime_value_30d_local_currency as first_order_total_lifetime_value_30d_local_currency,
              c.first_order_total_lifetime_value_30d_global_currency as first_order_total_lifetime_value_30d_global_currency,
              c.first_order_total_lifetime_value_60d_local_currency as first_order_total_lifetime_value_60d_local_currency,
              c.first_order_total_lifetime_value_60d_global_currency as first_order_total_lifetime_value_60d_global_currency,
              c.first_order_total_lifetime_value_90d_local_currency as first_order_total_lifetime_value_90d_local_currency,
              c.first_order_total_lifetime_value_90d_global_currency as first_order_total_lifetime_value_90d_global_currency,
              c.first_order_total_lifetime_value_180d_local_currency as first_order_total_lifetime_value_180d_local_currency,
              c.first_order_total_lifetime_value_180d_global_currency as first_order_total_lifetime_value_180d_global_currency,
              c.first_order_total_lifetime_value_365d_local_currency as first_order_total_lifetime_value_365d_local_currency,
              c.first_order_total_lifetime_value_365d_global_currency as first_order_total_lifetime_value_365d_global_currency,
              c.local_currency as local_currency,
              sum(c.count_conversions) as count_conversions,
              sum(c.count_order_conversions) as count_order_conversions,
              sum(c.count_first_order_conversions) as count_first_order_conversions,
              sum(c.count_repeat_order_conversions) as count_repeat_order_conversions,
              sum(c.count_registration_conversions) as count_registration_conversions
            from
              {{ ref('wh_web_sessions_fact') }} s
            left join
              converting_sessions_deduped c
            on
              s.session_id = c.session_id
            left join
              user_ltvs l
            on
              s.user_id = l.user_id
            {{ dbt_utils.group_by(42) }}
        )
    )
    WHERE
    conversion_cycle_conversion_ts >= session_start_ts
),

/* This is a multi-cycle attribution model which means that we attribute the value of each order placed by a user to the sessions that led to that order, starting with the session after the last order
   We therefore need to split each users' sessions into "conversion cycles", the sessions leading-up to and potentially including the session in which the conversion happened. This next CTE starts this
   process of calculating those conversion cycles by first calculating, for each session for each user, how many conversions of each type have been recorded for that user at the time the session started
   by summing the number of conversions recorded in the rows (sessions) up to and including the current row (session) */

touchpoint_and_converting_sessions_labelled_with_conversion_number AS
  (
    select
      *,
      sum(conversion_event) over (partition by user_id order by session_start_ts rows between unbounded preceding and current row) as user_total_conversions,
      sum(count_order_conversions) over (partition by user_id order by session_start_ts rows between unbounded preceding and current row) as user_total_order_conversions,
      sum(count_registration_conversions) over (partition by user_id order by session_start_ts rows between unbounded preceding and current row) as user_total_registration_conversions,
      sum(count_first_order_conversions) over (partition by user_id order by session_start_ts rows between unbounded preceding and current row) as user_total_first_order_conversions,
      sum(count_repeat_order_conversions) over (partition by user_id order by session_start_ts rows between unbounded preceding and current row) as user_total_repeat_order_conversions
    from
        touchpoint_and_converting_sessions_labelled

/* A conversion cycle is defined as all sessions (rows) leading up-to and including the conversion session (conversion cycle #1), with the conversion cycle then incrementing to conversion cycle #2 for the rows
   leading up to the next conversion, then we're on to conversion cycle #3, and so on.
   There can only be one conversion cycle for user registration conversions, and the same is true for first order conversions. Repeat order conversions start at conversion cycle #1 (if the user has made their second order)
   and then increment to #2 for the users' third order, etc. This block of code calculates which conversion cycle each row (session) is within for each of the conversion cycle types */

),
touchpoint_and_converting_sessions_labelled_with_conversion_number_and_conversion_cycles as (
    select
      * ,
      case when registration_conversion_event = 0 then max(coalesce(user_total_registration_conversions,0)) over (partition by user_id
        order by session_start_ts rows between unbounded preceding and current row) + 1
      else max(user_total_registration_conversions) over (partition by user_id
        order by session_start_ts rows between unbounded preceding and current row)
      end as user_registration_conversion_cycle,

      case when conversion_event = 0 then max(coalesce(user_total_conversions,0))              over (partition by user_id
        order by session_start_ts rows between unbounded preceding and current row) + 1
      else max(user_total_conversions) over (partition by user_id
        order by session_start_ts rows between unbounded preceding and current row)
      end as user_conversion_cycle,

      case when first_order_conversion_event = 0 then max(coalesce(user_total_first_order_conversions,0))     over (partition by user_id
          order by session_start_ts rows between unbounded preceding and current row) + 1
        else max(user_total_first_order_conversions) over (partition by user_id
          order by session_start_ts rows between unbounded preceding and current row)
      end as user_first_order_conversion_cycle,

      case when repeat_order_conversion_event = 0 then max(coalesce(user_total_repeat_order_conversions,0)) over (partition by user_id
            order by session_start_ts rows between unbounded preceding and current row) + 1
          else max(user_total_repeat_order_conversions) over (partition by user_id
            order by session_start_ts rows between unbounded preceding and current row)
          end as user_repeat_order_conversion_cycle
    from touchpoint_and_converting_sessions_labelled_with_conversion_number
),

/* As we only consider rows (sessions) within a certain number of days before each conversion happened (the "lookback window") we first have to calculate a day number for each row.
   We do this by reference to a set starting date, arbitrarily chosen (2018-01-01) with the assumption that it's earlier than any conversion we need to attribute value for;
   we could also achieve the same result (turning date into a number) via the Unix date or a similar date>integer transformation */

touchpoint_and_converting_sessions_labelled_with_conversion_number_and_conversion_cycles_and_day_number as (
  select
    *,
    datediff(day,'2018-01-01',session_start_ts) as session_day_number
  from
    touchpoint_and_converting_sessions_labelled_with_conversion_number_and_conversion_cycles
),

/* now we calculate how many days before the next conversion each row (session) is,
   and then determine, based on a variable set in the dbt_project.yml file, whether the row (session) is within
   the regular attribution, and time decay attribution, look-back windows */

days_to_each_conversion as
(
  select
    *,
    session_day_number - max(session_day_number) over (partition by user_id, user_conversion_cycle)  as days_before_conversion,
    (session_day_number - max(session_day_number) over (partition by user_id, user_conversion_cycle))*-1 <= {{ var('attribution_lookback_days_window') }} as is_within_attribution_lookback_window,
    (session_day_number - max(session_day_number) over (partition by user_id, user_conversion_cycle))*-1 <= {{ var('attribution_time_decay_days_window') }} as is_within_attribution_time_decay_days_window
  from
    touchpoint_and_converting_sessions_labelled_with_conversion_number_and_conversion_cycles_and_day_number
),

/* Time-decay attribution is a multi-touch attribution model that gives some credit to all the channels that led to your customer converting,
   with that amount of credit being less (decaying) the further back in time the channel was interacted with.
   This CTE calculates the various numbers we need as inputs to the time decay calculation */

add_time_decay_score as (
  select
    *,
    {{ iff() }} (is_within_attribution_time_decay_days_window,{{ safe_divide('pow(2,days_before_conversion-1)',var('attribution_time_decay_days_window')  ) }} ,null) as time_decay_score,
    {{ iff() }} (conversion_session and not true,0,pow(2, (days_before_conversion - 1))) as weighting,
    {{ iff() }} (conversion_session and not true,0,(count(case when not conversion_session or true then web_session_pk end) over (partition by user_id,date_trunc('day', cast(session_start_ts as date))))) as sessions_within_day_to_conversion,
    {{ iff() }} (conversion_session and not true,0,div0 (pow(2, (days_before_conversion - 1)), count(case when not conversion_session or true then web_session_pk end) over (partition by user_id, date_trunc('day', cast(session_start_ts as date))))) as weighting_split_by_days_sessions
  from
    days_to_each_conversion
),
/* Because time-decay attribution adjusts the attributed value of the conversion by looking at the DAYS before the conversion happened and not the rows (sessions) before the conversion,
   the time decay attribution score calculated in the CTE above will end-up assigning the value of that days attributed conversions to all of the rows (sessions) recorded for that day,
   of which there may well be more than one for each day. So we then split the value of that day's conversion across the sessions within that day, equally, so we don't end-up over-counting time decay conversions */

split_time_decay_score_across_days_sessions as (
  select
    *,
    {{safe_divide('time_decay_score','sessions_within_day_to_conversion') }} as apportioned_time_decay_score
  from
    add_time_decay_score
),

/* Calculate the first/last non-direct/paid sessions in each conversion cycle
    and all conversion cycles that include non-direct and paid channel sessions.
    These flags are used in the actual session attribution calculations in the next CTE */

/* "and not {{ var('attribution_include_conversion_session') }}" excludes the session from any attribution of the conversion.
    Option is set via the "attribution_include_conversion_session: true" variable definition in the dbt_project.yml config file.
    Default value of "true" has the effect of including the actual session that the conversion happened in within the set of sessions eligable for attribution.
    Reason for including this option is because for sessions generated by dbt (for the custom transactions and account openings that couldn't be linked to a session)
    you might want to exclude these from having conversions all or partly attributed to them as they couldn't possibly have marketing channel information recorded for them.
    However the option to exclude them (setting this variable to "false") has not been enabled, so they are included in-scope for attribution (unless subsequently it's set to "false")  */

attrib_calc_flags as (

  select
    *,
    {{ iff() }} (first_value(case when is_within_attribution_lookback_window and (not conversion_session or {{ var('attribution_include_conversion_session') }}) and is_non_direct_channel = true then web_session_pk end) ignore nulls over (partition by user_id, user_conversion_cycle
      order by session_start_ts)=web_session_pk,true,false) as is_first_non_direct_channel_in_conversion_cycle,

    {{ iff() }} (last_value(case when is_within_attribution_lookback_window and (not conversion_session or {{ var('attribution_include_conversion_session') }}) and is_non_direct_channel = true then web_session_pk end) ignore nulls over (partition by user_id, user_conversion_cycle
      order by session_start_ts)=web_session_pk,true,false) as is_last_non_direct_channel_in_conversion_cycle,

    {{ iff() }} (sum(case when is_within_attribution_lookback_window and (not conversion_session or {{ var('attribution_include_conversion_session') }}) and is_non_direct_channel = true then 1 end) over (partition by user_id, user_conversion_cycle
      order by session_start_ts rows between unbounded preceding and unbounded following)>0,true,false) as is_conversion_cycle_with_non_direct,

    {{ iff() }} (first_value(case when is_within_attribution_lookback_window and (not conversion_session or {{ var('attribution_include_conversion_session') }}) and is_paid_channel = true then web_session_pk end) ignore nulls over (partition by user_id, user_conversion_cycle
      order by session_start_ts)=web_session_pk,true,false)  as is_first_paid_channel_in_conversion_cycle,

    {{ iff() }} (last_value(case when is_within_attribution_lookback_window and (not conversion_session or {{ var('attribution_include_conversion_session') }}) and is_paid_channel = true then web_session_pk end) ignore nulls over (partition by user_id, user_conversion_cycle
      order by session_start_ts)=web_session_pk,true,false)  as is_last_paid_channel_in_conversion_cycle,

    {{ iff() }} (sum(case when is_within_attribution_lookback_window and (not conversion_session or {{ var('attribution_include_conversion_session') }}) and is_paid_channel = true then 1 end) over (partition by user_id, user_conversion_cycle
      order by session_start_ts rows between unbounded preceding and unbounded following)>0,true,false) as is_conversion_cycle_with_paid
  from
    split_time_decay_score_across_days_sessions
),

session_attrib_pct as (
  select
    *,

    {{ iff() }}(conversion_session and not {{ var('attribution_include_conversion_session') }},0,
      case
        when web_session_pk = last_value({{ iff() }}(is_within_attribution_lookback_window and (not conversion_session or {{ var('attribution_include_conversion_session') }}),web_session_pk,null)  ignore nulls) over (partition by user_id, user_conversion_cycle order by session_start_ts rows between unbounded preceding and unbounded following) then 1
        else 0
      end)
    as last_click_attrib_pct,

    {{ iff() }}(conversion_session and not {{ var('attribution_include_conversion_session') }},0,
      case
        when is_last_non_direct_channel_in_conversion_cycle then 1 -- if the session is the last qualifying session in the conversion cycle, i.e. last non-direct session, then allocate 100% of conversion to it
        when {{ iff() }}(not is_conversion_cycle_with_non_direct
          and web_session_pk = last_value({{ iff() }}(is_within_attribution_lookback_window,web_session_pk,null) ignore nulls) over (partition by user_id, user_conversion_cycle order by session_start_ts rows between unbounded preceding and unbounded following),true,false) = true
          then 1 -- else if there are no non-direct channel sessions in the conversion cycle AND this the last session in that conversion cycle, allocate 100% of the conversion to it
        else 0 -- else allocate 0%
      end)
    as last_non_direct_click_attrib_pct,

    {{ iff() }}(conversion_session and not {{ var('attribution_include_conversion_session') }},0,
      case
        when is_last_paid_channel_in_conversion_cycle then 1 -- if the session is the last qualifying session in the conversion cycle, i.e. last paid session, then allocate 100% of conversion to it
        when {{ iff() }}(not is_conversion_cycle_with_paid
          and web_session_pk = last_value({{ iff() }}(is_within_attribution_lookback_window,web_session_pk,null) ignore nulls) over (partition by user_id, user_conversion_cycle order by session_start_ts rows between unbounded preceding and unbounded following),true,false) = true
          then 1 -- else if there are no paid channel sessions in the conversion cycle AND this the last session in that conversion cycle, allocate 100% of the conversion to it
        else 0 -- else allocate 0%
      end)
    as last_paid_click_attrib_pct,

    {{ iff() }}(conversion_session and not {{ var('attribution_include_conversion_session') }},0,
      case
        when web_session_pk = first_value({{ iff() }}(is_within_attribution_lookback_window,web_session_pk,null) ignore nulls) over (partition by user_id, user_conversion_cycle order by session_start_ts rows between unbounded preceding and unbounded following) then 1
        else 0
      end)
    as first_click_attrib_pct,

    {{ iff() }}(conversion_session and not {{ var('attribution_include_conversion_session') }},0,
      case
        when is_first_non_direct_channel_in_conversion_cycle then 1 -- if the session is the first qualifying session in the conversion cycle, i.e. first non-direct session, then allocate 100% of conversion to it
        when {{ iff() }}(not is_conversion_cycle_with_non_direct
          and web_session_pk = first_value({{ iff() }}(is_within_attribution_lookback_window,web_session_pk,null) ignore nulls) over (partition by user_id, user_conversion_cycle order by session_start_ts rows between unbounded preceding and unbounded following),true,false) = true
          then 1 -- else if there are no non-direct channel sessions in the conversion cycle AND this the first session in that conversion cycle, allocate 100% of the conversion to it
        else 0 -- else allocate 0%
      end)
    as first_non_direct_click_attrib_pct,

    {{ iff() }}(conversion_session and not {{ var('attribution_include_conversion_session') }},0,
      case
        when is_first_paid_channel_in_conversion_cycle then 1 -- if the session is the first qualifying session in the conversion cycle, i.e. first paid session, then allocate 100% of conversion to it
        when {{ iff() }}(not is_conversion_cycle_with_paid
          and web_session_pk = first_value({{ iff() }}(is_within_attribution_lookback_window,web_session_pk,null) ignore nulls) over (partition by user_id, user_conversion_cycle order by session_start_ts rows between unbounded preceding and unbounded following),true,false) = true
          then 1 -- else if there are no paid channel sessions in the conversion cycle AND this the first session in that conversion cycle, allocate 100% of the conversion to it
        else 0 -- else allocate 0%
      end)
    as first_paid_click_attrib_pct,

    {{ iff() }} (conversion_session and not true,0,
      {{ iff() }} (is_within_attribution_lookback_window,(div0 (1,(count({{ iff() }}(is_within_attribution_lookback_window,web_session_pk,null)) over (partition by user_id,user_conversion_cycle order by session_start_ts rows between unbounded preceding and unbounded following) + 0))),0)
      ) as even_click_attrib_pct,

    {{ iff() }} (conversion_session and not true,0,case when is_within_attribution_time_decay_days_window then apportioned_time_decay_score / nullif((sum(apportioned_time_decay_score) over (partition by user_id, user_conversion_cycle)),0) end
      ) as time_decay_attrib_pct

  from
    attrib_calc_flags
),

/* Now calculate the actual account opening, first order, repeat order and LTV conversion numbers based on the attribution percentages calculated for the session */
/* Note - the Max() aggregations may no longer be needed, they are there from when we did a further join to campaigns but that's since been removed from the code */

final as (
  select
    a.*,
    (max(count_registration_conversions) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as user_registration_first_click_attrib_conversions,
    (max(count_registration_conversions) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as user_registration_first_non_direct_click_attrib_conversions,
    (max(count_registration_conversions) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as user_registration_first_paid_click_attrib_conversions,
    (max(count_registration_conversions) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as user_registration_last_click_attrib_conversions,
    (max(count_registration_conversions) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as user_registration_last_non_direct_click_attrib_conversions,
    (max(count_registration_conversions) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as user_registration_last_paid_click_attrib_conversions,
    (max(count_registration_conversions) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as user_registration_even_click_attrib_conversions,
    (max(count_registration_conversions) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as user_registration_time_decay_attrib_conversions,

    (max(count_first_order_conversions) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_attrib_conversions,
    (max(count_first_order_conversions) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_attrib_conversions,
    (max(count_first_order_conversions) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_attrib_conversions,
    (max(count_first_order_conversions) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_attrib_conversions,
    (max(count_first_order_conversions) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_attrib_conversions,
    (max(count_first_order_conversions) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_attrib_conversions,
    (max(count_first_order_conversions) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_attrib_conversions,
    (max(count_first_order_conversions) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_attrib_conversions,

    (max(first_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_attrib_revenue_local_currency,
    (max(first_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_attrib_revenue_global_currency,
    (max(first_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_attrib_revenue_local_currency,
    (max(first_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_attrib_revenue_global_currency,
    (max(first_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_attrib_revenue_local_currency,
    (max(first_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_attrib_revenue_global_currency,
    (max(first_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_attrib_revenue_local_currency,
    (max(first_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_attrib_revenue_global_currency,
    (max(first_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_attrib_revenue_local_currency,
    (max(first_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_attrib_revenue_global_currency,
    (max(first_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_attrib_revenue_local_currency,
    (max(first_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_attrib_revenue_global_currency,
    (max(first_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_attrib_revenue_local_currency,
    (max(first_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_attrib_revenue_global_currency,
    (max(first_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_attrib_revenue_local_currency,
    (max(first_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_attrib_revenue_global_currency,

    (max(first_order_total_lifetime_value_30d_local_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_30d_local_currency,
    (max(first_order_total_lifetime_value_30d_global_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_30d_global_currency,
    (max(first_order_total_lifetime_value_30d_local_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_30d_local_currency,
    (max(first_order_total_lifetime_value_30d_global_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_30d_global_currency,
    (max(first_order_total_lifetime_value_30d_local_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_30d_local_currency,
    (max(first_order_total_lifetime_value_30d_global_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_30d_global_currency,
    (max(first_order_total_lifetime_value_30d_local_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_30d_local_currency,
    (max(first_order_total_lifetime_value_30d_global_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_30d_global_currency,
    (max(first_order_total_lifetime_value_30d_local_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_30d_local_currency,
    (max(first_order_total_lifetime_value_30d_global_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_30d_global_currency,
    (max(first_order_total_lifetime_value_30d_local_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_30d_local_currency,
    (max(first_order_total_lifetime_value_30d_global_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_30d_global_currency,
    (max(first_order_total_lifetime_value_30d_local_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_30d_local_currency,
    (max(first_order_total_lifetime_value_30d_global_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_30d_global_currency,
    (max(first_order_total_lifetime_value_30d_local_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_30d_local_currency,
    (max(first_order_total_lifetime_value_30d_global_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_30d_global_currency,

    (max(first_order_total_lifetime_value_60d_local_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_60d_local_currency,
    (max(first_order_total_lifetime_value_60d_global_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_60d_global_currency,
    (max(first_order_total_lifetime_value_60d_local_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_60d_local_currency,
    (max(first_order_total_lifetime_value_60d_global_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_60d_global_currency,
    (max(first_order_total_lifetime_value_60d_local_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_60d_local_currency,
    (max(first_order_total_lifetime_value_60d_global_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_60d_global_currency,
    (max(first_order_total_lifetime_value_60d_local_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_60d_local_currency,
    (max(first_order_total_lifetime_value_60d_global_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_60d_global_currency,
    (max(first_order_total_lifetime_value_60d_local_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_60d_local_currency,
    (max(first_order_total_lifetime_value_60d_global_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_60d_global_currency,
    (max(first_order_total_lifetime_value_60d_local_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_60d_local_currency,
    (max(first_order_total_lifetime_value_60d_global_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_60d_global_currency,
    (max(first_order_total_lifetime_value_60d_local_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_60d_local_currency,
    (max(first_order_total_lifetime_value_60d_global_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_60d_global_currency,
    (max(first_order_total_lifetime_value_60d_local_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_60d_local_currency,
    (max(first_order_total_lifetime_value_60d_global_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_60d_global_currency,

    (max(first_order_total_lifetime_value_90d_local_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_90d_local_currency,
    (max(first_order_total_lifetime_value_90d_global_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_90d_global_currency,
    (max(first_order_total_lifetime_value_90d_local_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_90d_local_currency,
    (max(first_order_total_lifetime_value_90d_global_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_90d_global_currency,
    (max(first_order_total_lifetime_value_90d_local_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_90d_local_currency,
    (max(first_order_total_lifetime_value_90d_global_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_90d_global_currency,
    (max(first_order_total_lifetime_value_90d_local_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_90d_local_currency,
    (max(first_order_total_lifetime_value_90d_global_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_90d_global_currency,
    (max(first_order_total_lifetime_value_90d_local_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_90d_local_currency,
    (max(first_order_total_lifetime_value_90d_global_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_90d_global_currency,
    (max(first_order_total_lifetime_value_90d_local_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_90d_local_currency,
    (max(first_order_total_lifetime_value_90d_global_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_90d_global_currency,
    (max(first_order_total_lifetime_value_90d_local_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_90d_local_currency,
    (max(first_order_total_lifetime_value_90d_global_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_90d_global_currency,
    (max(first_order_total_lifetime_value_90d_local_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_90d_local_currency,
    (max(first_order_total_lifetime_value_90d_global_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_90d_global_currency,

    (max(first_order_total_lifetime_value_180d_local_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_180d_local_currency,
    (max(first_order_total_lifetime_value_180d_global_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_180d_global_currency,
    (max(first_order_total_lifetime_value_180d_local_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_180d_local_currency,
    (max(first_order_total_lifetime_value_180d_global_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_180d_global_currency,
    (max(first_order_total_lifetime_value_180d_local_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_180d_local_currency,
    (max(first_order_total_lifetime_value_180d_global_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_180d_global_currency,
    (max(first_order_total_lifetime_value_180d_local_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_180d_local_currency,
    (max(first_order_total_lifetime_value_180d_global_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_180d_global_currency,
    (max(first_order_total_lifetime_value_180d_local_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_180d_local_currency,
    (max(first_order_total_lifetime_value_180d_global_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_180d_global_currency,
    (max(first_order_total_lifetime_value_180d_local_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_180d_local_currency,
    (max(first_order_total_lifetime_value_180d_global_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_180d_global_currency,
    (max(first_order_total_lifetime_value_180d_local_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_180d_local_currency,
    (max(first_order_total_lifetime_value_180d_global_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_180d_global_currency,
    (max(first_order_total_lifetime_value_180d_local_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_180d_local_currency,
    (max(first_order_total_lifetime_value_180d_global_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_180d_global_currency,

    (max(first_order_total_lifetime_value_365d_local_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_365d_local_currency,
    (max(first_order_total_lifetime_value_365d_global_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as first_order_first_click_total_lifetime_value_365d_global_currency,
    (max(first_order_total_lifetime_value_365d_local_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_365d_local_currency,
    (max(first_order_total_lifetime_value_365d_global_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as first_order_first_non_direct_click_total_lifetime_value_365d_global_currency,
    (max(first_order_total_lifetime_value_365d_local_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_365d_local_currency,
    (max(first_order_total_lifetime_value_365d_global_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as first_order_first_paid_click_total_lifetime_value_365d_global_currency,
    (max(first_order_total_lifetime_value_365d_local_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_365d_local_currency,
    (max(first_order_total_lifetime_value_365d_global_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as first_order_last_click_total_lifetime_value_365d_global_currency,
    (max(first_order_total_lifetime_value_365d_local_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_365d_local_currency,
    (max(first_order_total_lifetime_value_365d_global_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as first_order_last_non_direct_click_total_lifetime_value_365d_global_currency,
    (max(first_order_total_lifetime_value_365d_local_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_365d_local_currency,
    (max(first_order_total_lifetime_value_365d_global_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as first_order_last_paid_click_total_lifetime_value_365d_global_currency,
    (max(first_order_total_lifetime_value_365d_local_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_365d_local_currency,
    (max(first_order_total_lifetime_value_365d_global_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as first_order_even_click_total_lifetime_value_365d_global_currency,
    (max(first_order_total_lifetime_value_365d_local_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_365d_local_currency,
    (max(first_order_total_lifetime_value_365d_global_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as first_order_time_decay_total_lifetime_value_365d_global_currency,

    (max(count_repeat_order_conversions) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as repeat_order_first_click_attrib_conversions,
    (max(count_repeat_order_conversions) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as repeat_order_first_non_direct_click_attrib_conversions,
    (max(count_repeat_order_conversions) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as repeat_order_first_paid_click_attrib_conversions,
    (max(count_repeat_order_conversions) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as repeat_order_last_click_attrib_conversions,
    (max(count_repeat_order_conversions) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as repeat_order_last_non_direct_click_attrib_conversions,
    (max(count_repeat_order_conversions) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as repeat_order_last_paid_click_attrib_conversions,
    (max(count_repeat_order_conversions) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as repeat_order_even_click_attrib_conversions,
    (max(count_repeat_order_conversions) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as repeat_order_time_decay_attrib_conversions,
    (max(repeat_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as repeat_order_first_click_attrib_revenue_local_currency,
    (max(repeat_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * first_click_attrib_pct) as repeat_order_first_click_attrib_revenue_global_currency,
    (max(repeat_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as repeat_order_first_non_direct_click_attrib_revenue_local_currency,
    (max(repeat_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * first_non_direct_click_attrib_pct) as repeat_order_first_non_direct_click_attrib_revenue_global_currency,
    (max(repeat_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as repeat_order_first_paid_click_attrib_revenue_local_currency,
    (max(repeat_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * first_paid_click_attrib_pct) as repeat_order_first_paid_click_attrib_revenue_global_currency,
    (max(repeat_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as repeat_order_last_click_attrib_revenue_local_currency,
    (max(repeat_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * last_click_attrib_pct) as repeat_order_last_click_attrib_revenue_global_currency,
    (max(repeat_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as repeat_order_last_non_direct_click_attrib_revenue_local_currency,
    (max(repeat_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * last_non_direct_click_attrib_pct) as repeat_order_last_non_direct_click_attrib_revenue_global_currency,
    (max(repeat_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as repeat_order_last_paid_click_attrib_revenue_local_currency,
    (max(repeat_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * last_paid_click_attrib_pct) as repeat_order_last_paid_click_attrib_revenue_global_currency,
    (max(repeat_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as repeat_order_even_click_attrib_revenue_local_currency,
    (max(repeat_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * even_click_attrib_pct) as repeat_order_even_click_attrib_revenue_global_currency,
    (max(repeat_order_total_revenue_local_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as repeat_order_time_decay_attrib_revenue_local_currency,
    (max(repeat_order_total_revenue_global_currency) over (partition by user_id, user_conversion_cycle) * time_decay_attrib_pct) as repeat_order_time_decay_attrib_revenue_global_currency
  from
    session_attrib_pct a
  {{ dbt_utils.group_by(82) }}
)

/* output all of the attribution model numbers and dimension attributes, plus all the columns and intermediate calculation values that might be useful for later debugging */

SELECT
  user_id,
  session_start_ts,
  session_end_ts,
  session_id,
  web_session_pk,
  is_excluded_user_session,
  session_seq,
  conversion_session,
  utm_source,
  utm_content,
  utm_medium,
  utm_campaign,
  platform,
  campaign_id,
  ad_group_id,
  referrer_host,
  referrer_domain,
  channel,
  first_order_total_revenue_local_currency,
  first_order_total_revenue_global_currency,
  first_order_total_lifetime_value_30d_local_currency,
  first_order_total_lifetime_value_30d_global_currency,
  first_order_total_lifetime_value_60d_local_currency,
  first_order_total_lifetime_value_60d_global_currency,
  first_order_total_lifetime_value_90d_local_currency,
  first_order_total_lifetime_value_90d_global_currency,
  first_order_total_lifetime_value_180d_local_currency,
  first_order_total_lifetime_value_180d_global_currency,
  first_order_total_lifetime_value_365d_local_currency,
  first_order_total_lifetime_value_365d_global_currency,
  repeat_order_total_revenue_local_currency,
  repeat_order_total_revenue_global_currency,
  local_currency,
  user_conversion_cycle,
  converted_ts,
  min_converted_ts,
  user_registration_conversion_cycle,
  user_first_order_conversion_cycle,
  user_repeat_order_conversion_cycle,
  is_within_attribution_lookback_window,
  is_within_attribution_time_decay_days_window,
  is_non_direct_channel,
  is_paid_channel,
  sessions_within_day_to_conversion,
  time_decay_score,
  apportioned_time_decay_score,
  days_before_conversion,
  weighting AS time_decay_score_weighting,
  weighting_split_by_days_sessions AS time_decay_weighting_split_by_days_sessions,
  count_conversions,
  count_order_conversions,
  count_first_order_conversions,
  count_repeat_order_conversions,
  count_registration_conversions,
  first_click_attrib_pct,
  first_non_direct_click_attrib_pct,
  first_paid_click_attrib_pct,
  last_click_attrib_pct,
  last_non_direct_click_attrib_pct,
  last_paid_click_attrib_pct,
  even_click_attrib_pct,
  time_decay_attrib_pct,
  user_registration_first_click_attrib_conversions,
  user_registration_first_non_direct_click_attrib_conversions,
  user_registration_first_paid_click_attrib_conversions,
  user_registration_last_click_attrib_conversions,
  user_registration_last_non_direct_click_attrib_conversions,
  user_registration_last_paid_click_attrib_conversions,
  user_registration_even_click_attrib_conversions,
  user_registration_time_decay_attrib_conversions,
  first_order_first_click_attrib_conversions,
  first_order_first_non_direct_click_attrib_conversions,
  first_order_first_paid_click_attrib_conversions,
  first_order_last_click_attrib_conversions,
  first_order_last_non_direct_click_attrib_conversions,
  first_order_last_paid_click_attrib_conversions,
  first_order_even_click_attrib_conversions,
  first_order_time_decay_attrib_conversions,
  first_order_first_click_attrib_revenue_local_currency,
  first_order_first_click_attrib_revenue_global_currency,
  first_order_first_non_direct_click_attrib_revenue_local_currency,
  first_order_first_non_direct_click_attrib_revenue_global_currency,
  first_order_first_paid_click_attrib_revenue_local_currency,
  first_order_first_paid_click_attrib_revenue_global_currency,
  first_order_last_click_attrib_revenue_local_currency,
  first_order_last_click_attrib_revenue_global_currency,
  first_order_last_non_direct_click_attrib_revenue_local_currency,
  first_order_last_non_direct_click_attrib_revenue_global_currency,
  first_order_last_paid_click_attrib_revenue_local_currency,
  first_order_last_paid_click_attrib_revenue_global_currency,
  first_order_even_click_attrib_revenue_local_currency,
  first_order_even_click_attrib_revenue_global_currency,
  first_order_time_decay_attrib_revenue_local_currency,
  first_order_time_decay_attrib_revenue_global_currency,
  first_order_first_click_total_lifetime_value_30d_local_currency,
  first_order_first_click_total_lifetime_value_30d_global_currency,
  first_order_first_non_direct_click_total_lifetime_value_30d_local_currency,
  first_order_first_non_direct_click_total_lifetime_value_30d_global_currency,
  first_order_last_click_total_lifetime_value_30d_local_currency,
  first_order_last_click_total_lifetime_value_30d_global_currency,
  first_order_last_non_direct_click_total_lifetime_value_30d_local_currency,
  first_order_last_non_direct_click_total_lifetime_value_30d_global_currency,
  first_order_last_paid_click_total_lifetime_value_30d_local_currency,
  first_order_last_paid_click_total_lifetime_value_30d_global_currency,
  first_order_even_click_total_lifetime_value_30d_local_currency,
  first_order_even_click_total_lifetime_value_30d_global_currency,
  first_order_time_decay_total_lifetime_value_30d_local_currency,
  first_order_time_decay_total_lifetime_value_30d_global_currency,
  first_order_first_click_total_lifetime_value_60d_local_currency,
  first_order_first_click_total_lifetime_value_60d_global_currency,
  first_order_first_non_direct_click_total_lifetime_value_60d_local_currency,
  first_order_first_non_direct_click_total_lifetime_value_60d_global_currency,
  first_order_last_click_total_lifetime_value_60d_local_currency,
  first_order_last_click_total_lifetime_value_60d_global_currency,
  first_order_last_non_direct_click_total_lifetime_value_60d_local_currency,
  first_order_last_non_direct_click_total_lifetime_value_60d_global_currency,
  first_order_last_paid_click_total_lifetime_value_60d_local_currency,
  first_order_last_paid_click_total_lifetime_value_60d_global_currency,
  first_order_even_click_total_lifetime_value_60d_local_currency,
  first_order_even_click_total_lifetime_value_60d_global_currency,
  first_order_time_decay_total_lifetime_value_60d_local_currency,
  first_order_time_decay_total_lifetime_value_60d_global_currency,
  first_order_first_click_total_lifetime_value_90d_local_currency,
  first_order_first_click_total_lifetime_value_90d_global_currency,
  first_order_first_non_direct_click_total_lifetime_value_90d_local_currency,
  first_order_first_non_direct_click_total_lifetime_value_90d_global_currency,
  first_order_last_click_total_lifetime_value_90d_local_currency,
  first_order_last_click_total_lifetime_value_90d_global_currency,
  first_order_last_non_direct_click_total_lifetime_value_90d_local_currency,
  first_order_last_non_direct_click_total_lifetime_value_90d_global_currency,
  first_order_last_paid_click_total_lifetime_value_90d_local_currency,
  first_order_last_paid_click_total_lifetime_value_90d_global_currency,
  first_order_even_click_total_lifetime_value_90d_local_currency,
  first_order_even_click_total_lifetime_value_90d_global_currency,
  first_order_time_decay_total_lifetime_value_90d_local_currency,
  first_order_time_decay_total_lifetime_value_90d_global_currency,
  first_order_first_click_total_lifetime_value_180d_local_currency,
  first_order_first_click_total_lifetime_value_180d_global_currency,
  first_order_first_non_direct_click_total_lifetime_value_180d_local_currency,
  first_order_first_non_direct_click_total_lifetime_value_180d_global_currency,
  first_order_last_click_total_lifetime_value_180d_local_currency,
  first_order_last_click_total_lifetime_value_180d_global_currency,
  first_order_last_non_direct_click_total_lifetime_value_180d_local_currency,
  first_order_last_non_direct_click_total_lifetime_value_180d_global_currency,
  first_order_last_paid_click_total_lifetime_value_180d_local_currency,
  first_order_last_paid_click_total_lifetime_value_180d_global_currency,
  first_order_even_click_total_lifetime_value_180d_local_currency,
  first_order_even_click_total_lifetime_value_180d_global_currency,
  first_order_time_decay_total_lifetime_value_180d_local_currency,
  first_order_time_decay_total_lifetime_value_180d_global_currency,
  first_order_first_click_total_lifetime_value_365d_local_currency,
  first_order_first_click_total_lifetime_value_365d_global_currency,
  first_order_first_non_direct_click_total_lifetime_value_365d_local_currency,
  first_order_first_non_direct_click_total_lifetime_value_365d_global_currency,
  first_order_last_click_total_lifetime_value_365d_local_currency,
  first_order_last_click_total_lifetime_value_365d_global_currency,
  first_order_last_non_direct_click_total_lifetime_value_365d_local_currency,
  first_order_last_non_direct_click_total_lifetime_value_365d_global_currency,
  first_order_last_paid_click_total_lifetime_value_365d_local_currency,
  first_order_last_paid_click_total_lifetime_value_365d_global_currency,
  first_order_even_click_total_lifetime_value_365d_local_currency,
  first_order_even_click_total_lifetime_value_365d_global_currency,
  first_order_time_decay_total_lifetime_value_365d_local_currency,
  first_order_time_decay_total_lifetime_value_365d_global_currency,
  repeat_order_first_click_attrib_conversions,
  repeat_order_first_non_direct_click_attrib_conversions,
  repeat_order_first_paid_click_attrib_conversions,
  repeat_order_last_click_attrib_conversions,
  repeat_order_last_non_direct_click_attrib_conversions,
  repeat_order_last_paid_click_attrib_conversions,
  repeat_order_even_click_attrib_conversions,
  repeat_order_time_decay_attrib_conversions,
  repeat_order_first_click_attrib_revenue_local_currency,
  repeat_order_first_click_attrib_revenue_global_currency,
  repeat_order_first_non_direct_click_attrib_revenue_local_currency,
  repeat_order_first_non_direct_click_attrib_revenue_global_currency,
  repeat_order_first_paid_click_attrib_revenue_local_currency,
  repeat_order_first_paid_click_attrib_revenue_global_currency,
  repeat_order_last_click_attrib_revenue_local_currency,
  repeat_order_last_click_attrib_revenue_global_currency,
  repeat_order_last_non_direct_click_attrib_revenue_local_currency,
  repeat_order_last_non_direct_click_attrib_revenue_global_currency,
  repeat_order_last_paid_click_attrib_revenue_local_currency,
  repeat_order_last_paid_click_attrib_revenue_global_currency,
  repeat_order_even_click_attrib_revenue_local_currency,
  repeat_order_even_click_attrib_revenue_global_currency,
  repeat_order_time_decay_attrib_revenue_local_currency,
  repeat_order_time_decay_attrib_revenue_global_currency
FROM
  final

{% endif %}
{% endif %}
