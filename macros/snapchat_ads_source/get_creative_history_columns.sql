{% macro get_creative_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_account_id", "datatype": dbt_utils.type_string()},
    {"name": "ad_product", "datatype": dbt_utils.type_string()},
    {"name": "app_install_android_app_url", "datatype": dbt_utils.type_string()},
    {"name": "app_install_app_name", "datatype": dbt_utils.type_string()},
    {"name": "app_install_icon_media_id", "datatype": dbt_utils.type_string()},
    {"name": "app_install_ios_app_id", "datatype": dbt_utils.type_string()},
    {"name": "attachment_type", "datatype": dbt_utils.type_string()},
    {"name": "brand_name", "datatype": dbt_utils.type_string()},
    {"name": "call_to_action", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "deep_link_android_app_url", "datatype": dbt_utils.type_string()},
    {"name": "deep_link_app_name", "datatype": dbt_utils.type_string()},
    {"name": "deep_link_icon_media_id", "datatype": dbt_utils.type_string()},
    {"name": "deep_link_ios_app_id", "datatype": dbt_utils.type_string()},
    {"name": "deep_link_uri", "datatype": dbt_utils.type_string()},
    {"name": "headline", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string()},
    {"name": "longform_video_media_id", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "packaging_status", "datatype": dbt_utils.type_string()},
    {"name": "playback_type", "datatype": dbt_utils.type_string()},
    {"name": "preview_creative_id", "datatype": dbt_utils.type_string()},
    {"name": "review_status", "datatype": dbt_utils.type_string()},
    {"name": "shareable", "datatype": "boolean"},
    {"name": "top_snap_crop_position", "datatype": dbt_utils.type_string()},
    {"name": "top_snap_media_id", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "web_view_allow_snap_javascript_sdk", "datatype": "boolean"},
    {"name": "web_view_block_preload", "datatype": "boolean"},
    {"name": "web_view_url", "datatype": dbt_utils.type_string()},
    {"name": "web_view_use_immersive_mode", "datatype": "boolean"}
] %}

{{ return(columns) }}

{% endmacro %}
