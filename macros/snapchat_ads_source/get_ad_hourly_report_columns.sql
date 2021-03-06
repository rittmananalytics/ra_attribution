{% macro get_ad_hourly_report_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_id", "datatype": dbt_utils.type_string()},
    {"name": "android_installs", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_avg_view_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_frequency", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_quartile_1", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_quartile_2", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_quartile_3", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_total_view_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_uniques", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_view_completion", "datatype": dbt_utils.type_numeric()},
    {"name": "avg_screen_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "avg_view_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_add_billing", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_add_cart", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_app_opens", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_level_completes", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_page_views", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_purchases", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_purchases_value", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_save", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_searches", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_sign_ups", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_start_checkout", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_view_content", "datatype": dbt_utils.type_numeric()},
    {"name": "date", "datatype": dbt_utils.type_timestamp()},
    {"name": "frequency", "datatype": dbt_utils.type_numeric()},
    {"name": "impressions", "datatype": dbt_utils.type_numeric()},
    {"name": "ios_installs", "datatype": dbt_utils.type_numeric()},
    {"name": "quartile_1", "datatype": dbt_utils.type_numeric()},
    {"name": "quartile_2", "datatype": dbt_utils.type_numeric()},
    {"name": "quartile_3", "datatype": dbt_utils.type_numeric()},
    {"name": "saves", "datatype": dbt_utils.type_numeric()},
    {"name": "screen_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "shares", "datatype": dbt_utils.type_numeric()},
    {"name": "spend", "datatype": dbt_utils.type_numeric()},
    {"name": "story_completes", "datatype": dbt_utils.type_numeric()},
    {"name": "story_opens", "datatype": dbt_utils.type_numeric()},
    {"name": "swipe_up_percent", "datatype": dbt_utils.type_numeric()},
    {"name": "swipes", "datatype": dbt_utils.type_numeric()},
    {"name": "total_installs", "datatype": dbt_utils.type_numeric()},
    {"name": "uniques", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views", "datatype": dbt_utils.type_numeric()},
    {"name": "view_completion", "datatype": dbt_utils.type_numeric()},
    {"name": "view_time_millis", "datatype": dbt_utils.type_numeric()}
] %}

{{ return(columns) }}

{% endmacro %}
