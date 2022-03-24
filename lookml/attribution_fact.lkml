view: attribution_fact {
  sql_table_name: "ANALYTICS_ATTRIBUTION"."ATTRIBUTION_FACT";;

  parameter: attribution_model {
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
    type: unquoted
    allowed_value: {label: "365 Days" value: "365d"}
    default_value: "30d"
  }

  parameter: display_currency {
    type: unquoted
    allowed_value: {label: "Global (NOK)" value: "global_currency"}
    allowed_value: {label: "Local" value: "local_currency"}
    default_value: "global_currency"

  }

  dimension: blended_user_id {
    group_label: "Audience"
    label: "User ID"
    type: string
    sql: ${TABLE}."BLENDED_USER_ID";
  }

  dimension: channel {
    group_label: "Acquisition"
    label: "Marketing Channel"
    type: string
    sql: ${TABLE}."CHANNEL" ;;
  }

  dimension: conversion_session {
    group_label: "Conversion"
    hidden: no
    label: "Conversion Session"
    type: yesno
    sql: ${TABLE}."CONVERSION_SESSION" ;;
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

    measure: dynamic_unatttributed_first_order_lifetime_value {
      group_label: "     Dynamic Attribution Totals"
      group_item_label: " Non-Attributed First Orders Lifetime Value"
      label: "Non-Attributed First Order Lifetime Value"
      hidden: yes
      type: sum
      value_format_name: decimal_0

      sql:
      ${TABLE}.first_order_total_lifetime_value_{% parameter ltv_days_since_first_delivery %}_{% parameter display_currency %};;
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


    dimension: currency_code {
      group_label: "Conversion"

      type: string
      sql: ${TABLE}."LOCAL_CURRENCY" ;;
    }

    dimension: days_before_conversion {
      hidden: yes
      type: number
      sql: ${TABLE}."DAYS_BEFORE_CONVERSION" ;;
    }

    # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
    # measures for this dimension, but you can also add measures of many different aggregates.
    # Click on the type parameter to see all the options in the Quick Help panel on the right.

    measure: total_days_before_conversion {
      hidden: yes
      type: sum
      sql: ${days_before_conversion} ;;
    }

    measure: total_users {
      group_label: "     Non-Attributed Totals"
      hidden: yes
      type: count_distinct
      sql: ${TABLE}."BLENDED_USER_ID";;
    }

    measure: total_sessions {
      group_label: "     Non-Attributed Totals"
      hidden: yes

      type: count_distinct
      sql: ${TABLE}."SESSION_ID";;
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


    dimension: is_non_direct_channel {
      group_label: "Acquisition"

      hidden: yes
      type: yesno
      sql: ${TABLE}."IS_NON_DIRECT_CHANNEL" ;;
    }

    dimension: is_paid_channel {
      hidden: yes
      type: yesno
      sql: ${TABLE}."IS_PAID_CHANNEL" ;;
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


    dimension: referrer_domain {
      group_label: "Acquisition"

      type: string
      sql: ${TABLE}."REFERRER_DOMAIN" ;;
    }

    dimension: referrer_host {
      group_label: "Acquisition"

      type: string
      sql: ${TABLE}."REFERRER_HOST" ;;
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

    # Dates and timestamps can be represented in Looker using a dimension group of type: time.
    # Looker converts dates and timestamps to the specified timeframes within the dimension group.

    dimension_group: session_end_ts {
      hidden: yes
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: CAST(${TABLE}."SESSION_END_TS" AS TIMESTAMP_NTZ) ;;
    }

    dimension: session_id {
      group_label: "Behavior"
      label: "  Session ID"
      primary_key: no
      type: string
      sql: ${TABLE}."SESSION_ID" ;;
    }

  dimension: web_session_pk {
    group_label: "Behavior"
    label: "  Web Session PK"
    primary_key: yes
    type: string
    sql: ${TABLE}."WEB_SESSION_PK" ;;
  }

    dimension: session_seq {
      group_label: "Behavior"

      type: number
      sql: ${TABLE}."SESSION_SEQ" ;;
    }

    dimension_group: session_start_ts {
      group_label: "Behavior"
      label: "Session"
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: CAST(${TABLE}."SESSION_START_TS" AS TIMESTAMP_NTZ) ;;
    }

    dimension_group: converted_ts {
      group_label: "Conversion"
      label: "Conversion"
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}."CONVERTED_TS"  ;;
    }


    dimension: sessions_within_day_to_conversion {
      hidden: yes
      type: number
      sql: ${TABLE}."SESSIONS_WITHIN_DAY_TO_CONVERSION" ;;
    }


    dimension: user_conversion_cycle {
      group_label: "Conversion"
      label: "Overall Conversion Cycle"

      type: number
      sql: ${TABLE}."USER_CONVERSION_CYCLE" ;;
    }

    dimension: user_first_order_conversion_cycle {
      group_label: "Conversion"
      label: "  First Order Conversion Cycle"
      type: number
      sql: ${TABLE}."USER_FIRST_ORDER_CONVERSION_CYCLE" ;;
    }

    dimension: user_registration_conversion_cycle {
      group_label: "Conversion"
      label: "   Account Opening Conversion Cycle"
      type: number
      sql: ${TABLE}."USER_REGISTRATION_CONVERSION_CYCLE" ;;
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

    dimension: user_repeat_order_conversion_cycle {
      group_label: "Conversion"
      label: "Repeat Order Conversion Cycle"
      type: number
      sql: ${TABLE}."USER_REPEAT_ORDER_CONVERSION_CYCLE" ;;
    }

    dimension: utm_campaign {
      group_label: "Acquisition"
      label: "Campaign"
      type: string
      sql: ${TABLE}."UTM_CAMPAIGN" ;;
    }

    dimension: utm_content {
      group_label: "Acquisition"
      label: "Content"
      type: string
      sql: ${TABLE}."UTM_CONTENT" ;;
    }

    dimension: utm_medium {
      group_label: "Acquisition"
      label: "Medium"
      type: string
      sql: ${TABLE}."UTM_MEDIUM" ;;
    }

    dimension: utm_source {
      group_label: "Acquisition"
      label: "Source"
      type: string
      sql: ${TABLE}."UTM_SOURCE" ;;
    }
  }
