
view: ad_spend_roi_fact {

  parameter: attribution_model {
    label: "   Attribution Model"
    allowed_value: {label: "First Click" value: "FC"}
    allowed_value: {label: "First Non-Direct Click" value: "FNDC"}
    allowed_value: {label: "First Paid Click" value: "FPC"}
    allowed_value: {label: "Even Click" value: "EC"}
    allowed_value: {label: "Last Click" value: "LC"}
    allowed_value: {label: "Last Non-Direct Click" value: "LNDC"}
    allowed_value: {label: "Last Paid Click" value: "LPC"}
    allowed_value: {label: "Time Decay" value: "TD"}
    default_value: "FNDC"
  }


  parameter: ltv_days_since_first_delivery {
    label: "  LTV Days"

    type: unquoted
    allowed_value: {label: "365 Days" value: "365d"}
    default_value: "365d"
  }

    dimension: ad_spend_roi_pk {
      primary_key: yes
      hidden: yes
      sql: md5(concat(coalesce(${TABLE}.campaign_ts,''), coalesce(${TABLE}.platform,''), coalesce(${TABLE}.campaign_id::varchar,''), coalesce(${TABLE}.ad_group_id::varchar,'') )) ;;
      }

    dimension: ad_group_id {
      group_label: "  Ad Groups"
      group_item_label: "  ID"
      type: string
      sql: ${TABLE}."AD_GROUP_ID" ;;
    }

    dimension: ad_group_name {
      group_label: "  Ad Groups"
      group_item_label: "   Name"
      type: string
      sql: ${TABLE}."AD_GROUP_NAME" ;;
    }

    dimension: campaign_id {
      group_label: "   Ad Campaigns"
      group_item_label: " ID"
      type: string
      sql: ${TABLE}."CAMPAIGN_ID" ;;
    }

    dimension: campaign_name {
      group_label: "   Ad Campaigns"
      group_item_label: "   Name"
      type: string
      sql: ${TABLE}."CAMPAIGN_NAME" ;;
    }

    dimension_group: campaign_ts {
      type: time
      label: "       Campaign "
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}."CAMPAIGN_TS" ;;
    }

    dimension: days_since_ad_group_start_ts {
      group_label: "  Ad Groups"
      group_item_label: "Day Number"
      type: number
      sql: ${TABLE}."DAYS_SINCE_AD_GROUP_START_TS" ;;
    }

    dimension: days_since_campaign_start_ts {
      group_label: "   Ad Campaigns"
      group_item_label: "Day Number"
      type: number
      sql: ${TABLE}."DAYS_SINCE_CAMPAIGN_START_TS" ;;
    }

    dimension: platform {
      group_label: "     Ad Networks"
      label: "    Ad Network Name"
      type: string
      sql: ${TABLE}."PLATFORM" ;;
    }

    dimension: reported_clicks {
      hidden: yes
      type: number
      sql: ${TABLE}."REPORTED_CLICKS" ;;
    }

    dimension: actual_clicks {
      hidden: yes
      type: number
      sql: ${TABLE}."ACTUAL_CLICKS" ;;
    }

    dimension: reported_ctr {
      hidden: yes
      type: number
      sql: ${TABLE}."REPORTED_CTR" ;;
    }

    dimension: actual_ctr {
      hidden: yes
      type: number
      sql: ${TABLE}."ACTUAL_CTR" ;;
    }

    dimension: reported_cpc {
      hidden: yes
      type: number
      sql: ${TABLE}.reported_cpc_{% parameter display_currency %} ;;
    }

    dimension: actual_cpc {
      hidden: yes
        sql: ${TABLE}.actual_cpc_{% parameter display_currency %} ;;
    }

  dimension: reported_impressions {
    hidden: yes

    type: number
    sql: ${TABLE}."REPORTED_IMPRESSIONS" ;;
  }

    # All of the Ad Spend and Performance measures have to be aggregated using sum_distinct() and avg_distinct
    # rather than sum() or avg() aggregation, as the join the underlying fact table uses (ad spend at day level,
    # to attributed conversion at the more granular session level, would cause double-counting of the ad spend
    # data if we don't include a distinct against the primary key

    measure: avg_reported_cpc {
      group_label: "Ad Spend"
      type: average_distinct
      sql_distinct_key: ${ad_spend_roi_pk} ;;
      sql: ${reported_cpc} ;;
    }

    measure: avg_reported_ctr {
      group_label: "Ad Spend"

      type: average_distinct
      sql_distinct_key: ${ad_spend_roi_pk} ;;
      value_format_name: percent_2
      sql: ${reported_ctr} ;;
    }

    measure: avg_actual_cpc {
      group_label: "Ad Spend"

      type: average_distinct
      sql_distinct_key: ${ad_spend_roi_pk} ;;
      sql: ${actual_cpc} ;;
    }

    measure: avg_actual_ctr {
      group_label: "Ad Spend"

      type: average_distinct
      sql_distinct_key: ${ad_spend_roi_pk} ;;
      value_format_name: percent_2
      sql: ${actual_ctr} ;;
    }



    measure: total_reported_impressions {
      group_label: "Ad Spend"

      type: sum_distinct
      sql_distinct_key: ${ad_spend_roi_pk} ;;

      sql: ${reported_impressions} ;;
    }

    measure: total_reported_clicks {
      group_label: "Ad Spend"

       type: sum_distinct
      sql_distinct_key: ${ad_spend_roi_pk} ;;
      sql: ${reported_clicks} ;;
    }

    measure: total_actual_clicks {
      group_label: "Ad Spend"

       type: sum_distinct
      sql_distinct_key: ${ad_spend_roi_pk} ;;
      sql: ${actual_clicks} ;;
    }

    measure: total_reported_spend {
      group_label: "Ad Spend"

       type: sum_distinct
      sql_distinct_key: ${ad_spend_roi_pk} ;;

      sql: ${reported_spend} ;;
    }

    measure: total_campaigns {
      group_label: "Ad Spend"
      type: count_distinct
      sql: ${campaign_id} ;;
    }

    measure: total_ad_groups {
      group_label: "Ad Spend"
      type: count_distinct
      sql: ${ad_group_id} ;;
      }

    measure: total_ad_networks {
      group_label: "Ad Spend"
      type: count_distinct
      sql: ${platform} ;;
    }



    dimension: reported_spend {
      hidden: yes
        type: number
      sql: ${TABLE}.reported_spend_{% parameter display_currency %} ;;
    }



  dimension: channel {
    group_label: "Acquisition"
    label: "Marketing Channel"
    type: string
    sql: ${TABLE}."CHANNEL" ;;
  }

  measure: dynamic_first_order_conversions {
    group_label: "     Dynamic Attribution Totals"
    group_item_label: " First Orders"
    label: "Attributed First Orders"

    type: sum
    value_format_name: decimal_2
    sql:
     CASE
      WHEN {% parameter attribution_model %} = 'FC'
        THEN ${TABLE}.first_order_first_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'FNDC'
        THEN ${TABLE}.first_order_first_non_direct_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'FPC'
        THEN ${TABLE}.first_order_first_paid_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'EC'
        THEN ${TABLE}.first_order_even_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'LC'
        THEN ${TABLE}.first_order_last_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'LNDC'
        THEN ${TABLE}.first_order_last_non_direct_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'LPC'
        THEN ${TABLE}.first_order_last_paid_click_attrib_conversions
       WHEN {% parameter attribution_model %} = 'TD'
        THEN ${TABLE}.first_order_time_decay_attrib_conversions
      ELSE NULL
    END ;;
  }

   measure: dynamic_account_opening_conversions {
    group_label: "     Dynamic Attribution Totals"
    group_item_label: " Account Openings"
    label: "Attributed Account Openings"
    value_format_name: decimal_2

    type: sum
    sql:
     CASE
      WHEN {% parameter attribution_model %} = 'FC'
        THEN ${TABLE}.user_registration_first_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'FNDC'
        THEN ${TABLE}.user_registration_first_non_direct_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'FPC'
        THEN ${TABLE}.user_registration_first_paid_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'EC'
        THEN ${TABLE}.user_registration_even_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'LC'
        THEN ${TABLE}.user_registration_last_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'LNDC'
        THEN ${TABLE}.user_registration_last_non_direct_click_attrib_conversions
      WHEN {% parameter attribution_model %} = 'LPC'
        THEN ${TABLE}.user_registration_last_paid_click_attrib_conversions
       WHEN {% parameter attribution_model %} = 'TD'
        THEN ${TABLE}.user_registration_time_decay_attrib_conversions
      ELSE NULL
    END ;;
  }

    measure: dynamic_repeat_order_conversions {
      group_label: "     Dynamic Attribution Totals"
      group_item_label: " Repeat Orders"
      label: "Attributed Repeat Orders"
      type: sum
      value_format_name: decimal_2

      sql:
           CASE
            WHEN {% parameter attribution_model %} = 'FC'
              THEN ${TABLE}.repeat_order_first_click_attrib_conversions
            WHEN {% parameter attribution_model %} = 'FNDC'
              THEN ${TABLE}.repeat_order_first_non_direct_click_attrib_conversions
            WHEN {% parameter attribution_model %} = 'FPC'
              THEN ${TABLE}.repeat_order_first_paid_click_attrib_conversions
            WHEN {% parameter attribution_model %} = 'EC'
              THEN ${TABLE}.repeat_order_even_click_attrib_conversions
            WHEN {% parameter attribution_model %} = 'LC'
              THEN ${TABLE}.repeat_order_last_click_attrib_conversions
            WHEN {% parameter attribution_model %} = 'LNDC'
              THEN ${TABLE}.repeat_order_last_non_direct_click_attrib_conversions
            WHEN {% parameter attribution_model %} = 'LPC'
              THEN ${TABLE}.repeat_order_last_paid_click_attrib_conversions
             WHEN {% parameter attribution_model %} = 'TD'
              THEN ${TABLE}.repeat_order_time_decay_attrib_conversions
            ELSE NULL
          END ;;
    }


    measure: dynamic_first_order_net_revenue {
      group_label: "     Dynamic Attribution Totals"
      group_item_label: " First Orders Net Revenue"
      label: "Attributed First Order Net Revenue"
      type: sum
      value_format_name: decimal_0

      sql:
           CASE
            WHEN {% parameter attribution_model %} = 'FC'
              THEN ${TABLE}.first_order_first_click_attrib_revenue_{% parameter display_currency %}
            WHEN {% parameter attribution_model %} = 'FNDC'
              THEN ${TABLE}.first_order_first_non_direct_click_attrib_revenue_{% parameter display_currency %}
            WHEN {% parameter attribution_model %} = 'FPC'
              THEN ${TABLE}.first_order_first_paid_click_attrib_revenue_{% parameter display_currency %}
            WHEN {% parameter attribution_model %} = 'EC'
              THEN ${TABLE}.first_order_even_click_attrib_revenue_{% parameter display_currency %}
            WHEN {% parameter attribution_model %} = 'LC'
              THEN ${TABLE}.first_order_last_click_attrib_revenue_{% parameter display_currency %}
            WHEN {% parameter attribution_model %} = 'LNDC'
              THEN ${TABLE}.first_order_last_non_direct_click_attrib_revenue_{% parameter display_currency %}
            WHEN {% parameter attribution_model %} = 'LPC'
              THEN ${TABLE}.first_order_last_paid_click_attrib_revenue_{% parameter display_currency %}
             WHEN {% parameter attribution_model %} = 'TD'
              THEN ${TABLE}.first_order_time_decay_attrib_revenue_{% parameter display_currency %}
            ELSE NULL
          END ;;
    }

    measure: dynamic_first_order_lifetime_value {
      group_label: "     Dynamic Attribution Totals"
      group_item_label: " First Orders Lifetime Value"
      label: "Attributed First Order Lifetime Value"
      type: sum
      value_format_name: decimal_0

      sql:
      CASE
        WHEN {% parameter attribution_model %} = 'FC'
        THEN ${TABLE}.first_order_first_click_total_lifetime_value_{% parameter ltv_days_since_first_delivery %}_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'FNDC'
        THEN ${TABLE}.first_order_first_non_direct_click_total_lifetime_value_{% parameter ltv_days_since_first_delivery %}_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'FPC'
        THEN ${TABLE}.first_order_last_click_total_lifetime_value_{% parameter ltv_days_since_first_delivery %}_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'EC'
        THEN ${TABLE}.first_order_even_click_total_lifetime_value_{% parameter ltv_days_since_first_delivery %}_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'LC'
        THEN ${TABLE}.first_order_even_click_total_lifetime_value_{% parameter ltv_days_since_first_delivery %}_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'LNDC'
        THEN ${TABLE}.first_order_last_non_direct_click_total_lifetime_value_{% parameter ltv_days_since_first_delivery %}_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'LPC'
        THEN ${TABLE}.first_order_last_paid_click_total_lifetime_value_{% parameter ltv_days_since_first_delivery %}_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'TD'
        THEN ${TABLE}.first_order_time_decay_total_lifetime_value_{% parameter ltv_days_since_first_delivery %}_{% parameter display_currency %}
        ELSE NULL
      END ;;



      }


     measure: dynamic_repeat_order_net_revenue {
      group_label: "     Dynamic Attribution Totals"
      group_item_label: " Repeat Orders Net Revenue"
      label: "Attributed Repeat Order Net Revenue"

      type: sum

      sql:
      CASE
        WHEN {% parameter attribution_model %} = 'FC'
        THEN ${TABLE}.repeat_order_first_click_attrib_revenue_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'FNDC'
        THEN ${TABLE}.repeat_order_first_non_direct_click_attrib_revenue_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'FPC'
        THEN ${TABLE}.repeat_order_first_paid_click_attrib_revenue_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'EC'
        THEN ${TABLE}.repeat_order_even_click_attrib_revenue_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'LC'
        THEN ${TABLE}.repeat_order_last_click_attrib_revenue_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'LNDC'
        THEN ${TABLE}.repeat_order_last_non_direct_click_attrib_revenue_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'LPC'
        THEN ${TABLE}.repeat_order_last_paid_click_attrib_revenue_{% parameter display_currency %}
        WHEN {% parameter attribution_model %} = 'TD'
        THEN ${TABLE}.repeat_order_time_decay_attrib_revenue_{% parameter display_currency %}
        ELSE NULL
      END ;;
    }





    # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
    # measures for this dimension, but you can also add measures of many different aggregates.
    # Click on the type parameter to see all the options in the Quick Help panel on the right.

















    # Dates and timestamps can be represented in Looker using a dimension group of type: time.
    # Looker converts dates and timestamps to the specified timeframes within the dimension group.



    dimension: session_id {
      group_label: "Attributed Conversions"
      label: "    Session ID"
      hidden: no
      type: string
      sql: ${TABLE}."SESSION_ID" ;;
    }

  dimension: web_session_pk {
    group_label: "Attributed Conversions"
    label: "    Web Session PK"
    hidden: no
    type: string
    sql: ${TABLE}."WEB_SESSION_PK" ;;
  }



    dimension_group: session_start_ts {
      group_label: "Attributed Conversions"
      label: "        Session"
      type: time
      timeframes: [
        raw,
        time,
        week,
        month,
        year
      ]
      sql: CAST(${TABLE}."SESSION_START_TS" AS TIMESTAMP_NTZ) ;;
    }



  measure: first_order_even_click_attrib_conversions {
    group_label: "First Order"
    group_item_label: "Even-Click Orders"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_EVEN_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: first_order_even_click_attrib_revenue_local_currency {
    group_label: "First Order"
    group_item_label: "Even-Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."FIRST_ORDER_EVEN_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: first_order_even_click_attrib_revenue_global_currency {
    group_label: "First Order"
    group_item_label: "Even-Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_EVEN_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: first_order_first_click_attrib_conversions {
    group_label: "First Order"
    group_item_label: "First Click Orders"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_FIRST_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: first_order_first_click_attrib_revenue_local_currency {
    group_label: "First Order"
    group_item_label: "First Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."FIRST_ORDER_FIRST_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: first_order_first_click_attrib_revenue_global_currency {
    group_label: "First Order"
    group_item_label: "First Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_FIRST_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: first_order_first_non_direct_click_attrib_conversions {
    group_label: "First Order"
    group_item_label: "First Non-Direct Click Orders"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_FIRST_NON_DIRECT_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: first_order_first_non_direct_click_attrib_revenue_local_currency {
    group_label: "First Order"
    group_item_label: "First Non-Direct Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."FIRST_ORDER_FIRST_NON_DIRECT_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: first_order_first_non_direct_click_attrib_revenue_global_currency {
    group_label: "First Order"
    group_item_label: "First Non-Direct Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_FIRST_NON_DIRECT_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: first_order_first_paid_click_attrib_conversions {
    group_label: "First Order"
    group_item_label: "First Paid Click Orders"

    type: sum
    sql: ${TABLE}."FIRST_ORDER_FIRST_PAID_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: first_order_first_paid_click_attrib_revenue_local_currency {
    group_label: "First Order"
    group_item_label: "First Paid Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."FIRST_ORDER_FIRST_PAID_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: first_order_first_paid_click_attrib_revenue_global_currency {
    group_label: "First Order"
    group_item_label: "First Paid Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_FIRST_PAID_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: first_order_last_click_attrib_conversions {
    group_label: "First Order"
    group_item_label: "Last Click Orders"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_LAST_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: first_order_last_click_attrib_revenue_local_currency {
    group_label: "First Order"
    group_item_label: "Last Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."FIRST_ORDER_LAST_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: first_order_last_click_attrib_revenue_global_currency {
    group_label: "First Order"
    group_item_label: "Last Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_LAST_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: first_order_last_non_direct_click_attrib_conversions {
    group_label: "First Order"
    group_item_label: "Last Non-Direct Click Orders"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_LAST_NON_DIRECT_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: first_order_last_non_direct_click_attrib_revenue_local_currency {
    group_label: "First Order"
    group_item_label: "Last Non-Direct Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."FIRST_ORDER_LAST_NON_DIRECT_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: first_order_last_non_direct_click_attrib_revenue_global_currency {
    group_label: "First Order"
    group_item_label: "Last Non-Direct Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_LAST_NON_DIRECT_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: first_order_last_paid_click_attrib_conversions {
    group_label: "First Order"
    group_item_label: "Last Paid Click Orders"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_LAST_PAID_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: first_order_last_paid_click_attrib_revenue_local_currency {
    group_label: "First Order"
    group_item_label: "Last Paid Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."FIRST_ORDER_LAST_PAID_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: first_order_last_paid_click_attrib_revenue_global_currency {
    group_label: "First Order"
    group_item_label: "Last Paid Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_LAST_PAID_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: first_order_time_decay_attrib_conversions {
    group_label: "First Order"
    group_item_label: "Time Decay Orders"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}."FIRST_ORDER_TIME_DECAY_ATTRIB_CONVERSIONS" ;;
  }

  measure: first_order_time_decay_attrib_revenue_local_currency {
    group_label: "First Order"
    group_item_label: "Time Decay Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."FIRST_ORDER_TIME_DECAY_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: first_order_time_decay_attrib_revenue_global_currency {
    group_label: "First Order"
    group_item_label: "Time Decay Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_TIME_DECAY_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }


  measure: first_order_total_revenue_local_currency {
    group_label: "First Order"
    group_item_label: "Total Net Revenue Local Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_TOTAL_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: first_order_total_revenue_global_currency {
    group_label: "First Order"
    group_item_label: "Total Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."FIRST_ORDER_TOTAL_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: first_order_total_lifetime_value_365d_local_currency {
    group_label: "First Order"
    group_item_label: "Total Lifetime Value 365 Days Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.first_order_total_lifetime_value_365d_local_currency ;;
  }

  measure: first_order_total_lifetime_value_365d_global_currency {
    group_label: "First Order"
    group_item_label: "Total Lifetime Value 365 Days Global Currency"
    type: sum
    sql: ${TABLE}.first_order_total_lifetime_value_365d_global_currency ;;
  }

  dimension: is_within_attribution_lookback_window {
    hidden: yes
    type: yesno
    sql: ${TABLE}."IS_WITHIN_ATTRIBUTION_LOOKBACK_WINDOW" ;;
  }

  dimension: is_within_attribution_time_decay_days_window {
    hidden: yes
    type: yesno
    sql: ${TABLE}."IS_WITHIN_ATTRIBUTION_TIME_DECAY_DAYS_WINDOW" ;;
  }

  measure: repeat_order_even_click_attrib_conversions {
    group_label: "Repeat Orders"
    group_item_label: "Even Click Orders"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_EVEN_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: repeat_order_even_click_attrib_revenue_local_currency {
    group_label: "Repeat Orders"
    group_item_label: "Even Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_EVEN_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: repeat_order_even_click_attrib_revenue_global_currency {
    group_label: "Repeat Orders"
    group_item_label: "Even Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_EVEN_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: repeat_order_first_click_attrib_conversions {
    group_label: "Repeat Orders"
    group_item_label: "First Click Orders"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_FIRST_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: repeat_order_first_click_attrib_revenue_local_currency {
    group_label: "Repeat Orders"
    group_item_label: "First Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_FIRST_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: repeat_order_first_click_attrib_revenue_global_currency {
    group_label: "Repeat Orders"
    group_item_label: "First Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_FIRST_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: repeat_order_first_non_direct_click_attrib_conversions {
    group_label: "Repeat Orders"
    group_item_label: "First Non-Direct Click Orders"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_FIRST_NON_DIRECT_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: repeat_order_first_non_direct_click_attrib_revenue_local_currency {
    group_label: "Repeat Orders"
    group_item_label: "First Non-Direct Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_FIRST_NON_DIRECT_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: repeat_order_first_non_direct_click_attrib_revenue_global_currency {
    group_label: "Repeat Orders"

    group_item_label: "First Non-Direct Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_FIRST_NON_DIRECT_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: repeat_order_first_paid_click_attrib_conversions {
    group_label: "Repeat Orders"
    group_item_label: "First Paid Click Orders"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_FIRST_PAID_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: repeat_order_first_paid_click_attrib_revenue_local_currency {
    group_label: "Repeat Orders"
    group_item_label: "First Paid Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_FIRST_PAID_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: repeat_order_first_paid_click_attrib_revenue_global_currency {
    group_label: "Repeat Orders"
    group_item_label: "First Paid Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_FIRST_PAID_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: repeat_order_last_click_attrib_conversions {
    group_label: "Repeat Orders"
    group_item_label: "Last Click Net Orders"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_LAST_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: repeat_order_last_click_attrib_revenue_local_currency {
    group_label: "Repeat Orders"
    group_item_label: "Last Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_LAST_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: repeat_order_last_click_attrib_revenue_global_currency {
    group_label: "Repeat Orders"
    group_item_label: "Last Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_LAST_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: repeat_order_last_non_direct_click_attrib_conversions {
    group_label: "Repeat Orders"
    group_item_label: "Last Non-Direct Click Orders"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_LAST_NON_DIRECT_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: repeat_order_last_non_direct_click_attrib_revenue_local_currency {
    group_label: "Repeat Orders"
    group_item_label: "Last Non-Direct Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_LAST_NON_DIRECT_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: repeat_order_last_non_direct_click_attrib_revenue_global_currency {
    group_label: "Repeat Orders"
    group_item_label: "Last Non-Direct Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_LAST_NON_DIRECT_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: repeat_order_last_paid_click_attrib_conversions {
    group_label: "Repeat Orders"
    group_item_label: "Last Paid Click Orders"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_LAST_PAID_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: repeat_order_last_paid_click_attrib_revenue_local_currency {
    group_label: "Repeat Orders"
    group_item_label: "Last Paid Click Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_LAST_PAID_CLICK_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: repeat_order_last_paid_click_attrib_revenue_global_currency {
    group_label: "Repeat Orders"
    group_item_label: "Last Paid Click Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_LAST_PAID_CLICK_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: repeat_order_time_decay_attrib_conversions {
    group_label: "Repeat Orders"
    group_item_label: "Time Decay Orders"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_TIME_DECAY_ATTRIB_CONVERSIONS" ;;
  }

  measure: repeat_order_time_decay_attrib_revenue_local_currency {
    group_label: "Repeat Orders"
    group_item_label: "Time Decay Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_TIME_DECAY_ATTRIB_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: repeat_order_time_decay_attrib_revenue_global_currency {
    group_label: "Repeat Orders"
    group_item_label: "Time Decay Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_TIME_DECAY_ATTRIB_REVENUE_GLOBAL_CURRENCY" ;;
  }

  measure: repeat_order_total_revenue_local_currency {
    group_label: "Repeat Orders"
    group_item_label: "Total Net Revenue Local Currency"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_TOTAL_REVENUE_LOCAL_CURRENCY" ;;
  }

  measure: repeat_order_total_revenue_global_currency {
    group_label: "Repeat Orders"
    group_item_label: "Total Net Revenue Global Currency"
    type: sum
    sql: ${TABLE}."REPEAT_ORDER_TOTAL_REVENUE_GLOBAL_CURRENCY" ;;
  }


  measure: user_registration_even_click_attrib_conversions {
    group_label: "    Account Opening"
    group_item_label: "Even Click Conversions"
    value_format_name: decimal_0

    type: sum
    sql: ${TABLE}."USER_REGISTRATION_EVEN_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: user_registration_first_click_attrib_conversions {
    group_label: "    Account Opening"
    group_item_label: "First Click Conversions"
    value_format_name: decimal_0

    type: sum
    sql: ${TABLE}."USER_REGISTRATION_FIRST_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: user_registration_first_non_direct_click_attrib_conversions {
    group_label: "    Account Opening"
    group_item_label: "First Non-Direct Click Conversions"
    value_format_name: decimal_0


    type: sum
    sql: ${TABLE}."USER_REGISTRATION_FIRST_NON_DIRECT_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: user_registration_first_paid_click_attrib_conversions {
    group_label: "    Account Opening"
    group_item_label: "First Paid Click Conversions"
    value_format_name: decimal_0

    type: sum
    sql: ${TABLE}."USER_REGISTRATION_FIRST_PAID_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: user_registration_last_click_attrib_conversions {
    group_label: "    Account Opening"
    group_item_label: "Last Click Conversions"
    value_format_name: decimal_0

    type: sum
    sql: ${TABLE}."USER_REGISTRATION_LAST_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: user_registration_last_non_direct_click_attrib_conversions {
    group_label: "    Account Opening"
    group_item_label: "Last Non-Direct Click Conversions"
    value_format_name: decimal_0

    type: sum
    sql: ${TABLE}."USER_REGISTRATION_LAST_NON_DIRECT_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: user_registration_last_paid_click_attrib_conversions {
    group_label: "    Account Opening"
    group_item_label: "Last Paid Click Conversions"
    value_format_name: decimal_0

    type: sum
    sql: ${TABLE}."USER_REGISTRATION_LAST_PAID_CLICK_ATTRIB_CONVERSIONS" ;;
  }

  measure: user_registration_time_decay_attrib_conversions {
    group_label: "    Account Opening"
    group_item_label: "Time Decay Conversions"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}."USER_REGISTRATION_TIME_DECAY_ATTRIB_CONVERSIONS" ;;
  }

}
