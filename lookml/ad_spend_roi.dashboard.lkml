- dashboard: performance_dashboard
  title: Performance Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - name: ''
    type: text
    title_text: ''
    subtitle_text: How many new accounts, orders and repeat orders did we receive?
    body_text: ''
    row: 43
    col: 0
    width: 12
    height: 2
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: How much first and repeat order revenue did we receive?
    body_text: ''
    row: 43
    col: 12
    width: 12
    height: 2
  - title: Account Openings
    name: Account Openings
    model: analytics
    explore: ad_spend_roi_fact
    type: single_value
    fields: [ad_spend_roi_fact.dynamic_account_opening_conversions]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: '0'
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Campaign Name: ad_spend_roi_fact.campaign_name
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 0
    col: 15
    width: 5
    height: 6
  - title: Accounts Openings, First and Repeat Orders
    name: Accounts Openings, First and Repeat Orders
    model: analytics
    explore: ad_spend_roi_fact
    type: looker_area
    fields: [ad_spend_roi_fact.campaign_ts_week, ad_spend_roi_fact.dynamic_account_opening_conversions,
      ad_spend_roi_fact.dynamic_first_order_conversions, ad_spend_roi_fact.dynamic_repeat_order_conversions]
    fill_fields: [ad_spend_roi_fact.campaign_ts_week]
    sorts: [ad_spend_roi_fact.campaign_ts_week desc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Campaign Name: ad_spend_roi_fact.campaign_name
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 45
    col: 0
    width: 12
    height: 7
  - title: First & Repeat Order Revenue
    name: First & Repeat Order Revenue
    model: analytics
    explore: ad_spend_roi_fact
    type: looker_area
    fields: [ad_spend_roi_fact.campaign_ts_week, ad_spend_roi_fact.dynamic_first_order_net_revenue,
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue]
    fill_fields: [ad_spend_roi_fact.campaign_ts_week]
    sorts: [ad_spend_roi_fact.campaign_ts_week desc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Campaign Name: ad_spend_roi_fact.campaign_name
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 45
    col: 12
    width: 12
    height: 7
  - name: How much did we spend and what was the overall campaign performance?
    type: text
    title_text: How much did we spend and what was the overall campaign performance?
    subtitle_text: ''
    body_text: ''
    row: 6
    col: 0
    width: 24
    height: 2
  - title: Campaign Performance
    name: Campaign Performance
    model: analytics
    explore: ad_spend_roi_fact
    type: looker_line
    fields: [ad_spend_roi_fact.campaign_ts_week, ad_spend_roi_fact.avg_actual_cpc,
      ad_spend_roi_fact.avg_reported_cpc, ad_spend_roi_fact.avg_reported_ctr, ad_spend_roi_fact.avg_actual_ctr,
      ad_spend_roi_fact.total_reported_impressions, ad_spend_roi_fact.total_actual_clicks,
      ad_spend_roi_fact.total_reported_clicks]
    fill_fields: [ad_spend_roi_fact.campaign_ts_week]
    sorts: [ad_spend_roi_fact.campaign_ts_week desc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    hidden_series: [Facebook Ads - ad_spend_roi_fact.avg_actual_ctr, Google Ads -
        ad_spend_roi_fact.avg_reported_ctr, Facebook Ads - ad_spend_roi_fact.avg_reported_cpc,
      Google Ads - ad_spend_roi_fact.avg_actual_ctr, Facebook Ads - ad_spend_roi_fact.avg_reported_ctr,
      Google Ads - ad_spend_roi_fact.avg_reported_cpc, ad_spend_roi_fact.avg_reported_ctr,
      ad_spend_roi_fact.avg_actual_ctr, ad_spend_roi_fact.total_reported_impressions,
      ad_spend_roi_fact.total_reported_clicks, ad_spend_roi_fact.total_actual_clicks]
    series_types: {}
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Campaign Name: ad_spend_roi_fact.campaign_name
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 25
    col: 12
    width: 12
    height: 8
  - title: Ad Spend
    name: Ad Spend
    model: analytics
    explore: ad_spend_roi_fact
    type: looker_line
    fields: [ad_spend_roi_fact.campaign_ts_week, ad_spend_roi_fact.total_reported_spend,
      ad_spend_roi_fact.platform]
    pivots: [ad_spend_roi_fact.platform]
    fill_fields: [ad_spend_roi_fact.campaign_ts_week]
    sorts: [ad_spend_roi_fact.campaign_ts_week desc, ad_spend_roi_fact.platform]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Campaign Name: ad_spend_roi_fact.campaign_name
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 15
    col: 0
    width: 12
    height: 8
  - title: Order Revenue by Ad Network
    name: Order Revenue by Ad Network
    model: analytics
    explore: ad_spend_roi_fact
    type: looker_column
    fields: [ad_spend_roi_fact.campaign_ts_week, ad_spend_roi_fact.dynamic_first_order_net_revenue,
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue, ad_spend_roi_fact.platform]
    pivots: [ad_spend_roi_fact.platform]
    fill_fields: [ad_spend_roi_fact.campaign_ts_week]
    sorts: [ad_spend_roi_fact.campaign_ts_week desc, ad_spend_roi_fact.platform]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${ad_spend_roi_fact.dynamic_first_order_net_revenue}+${ad_spend_roi_fact.dynamic_repeat_order_net_revenue}",
        label: Total Order Revenue, value_format: !!null '', value_format_name: gbp_0,
        _kind_hint: measure, table_calculation: total_order_revenue, _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    defaults_version: 1
    hidden_fields: [ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue]
    y_axes: []
    listen:
      Campaign Name: ad_spend_roi_fact.campaign_name
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 25
    col: 0
    width: 12
    height: 8
  - title: Return on Advertising Spend
    name: Return on Advertising Spend
    model: analytics
    explore: ad_spend_roi_fact
    type: looker_line
    fields: [ad_spend_roi_fact.campaign_ts_week, ad_spend_roi_fact.dynamic_first_order_net_revenue,
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue, ad_spend_roi_fact.platform,
      ad_spend_roi_fact.total_reported_spend]
    pivots: [ad_spend_roi_fact.platform]
    fill_fields: [ad_spend_roi_fact.campaign_ts_week]
    sorts: [ad_spend_roi_fact.campaign_ts_week desc, ad_spend_roi_fact.platform]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${ad_spend_roi_fact.dynamic_first_order_net_revenue}+${ad_spend_roi_fact.dynamic_repeat_order_net_revenue}",
        label: Total Order Revenue, value_format: !!null '', value_format_name: gbp_0,
        _kind_hint: measure, table_calculation: total_order_revenue, _type_hint: number},
      {category: table_calculation, expression: "${total_order_revenue}/${ad_spend_roi_fact.total_reported_spend}",
        label: ROAS, value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: roas, _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue,
      total_order_revenue, ad_spend_roi_fact.total_reported_spend]
    y_axes: []
    listen:
      Campaign Name: ad_spend_roi_fact.campaign_name
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 15
    col: 12
    width: 12
    height: 8
  - name: What Revenue and Return on Advertising Spend Did We Earn?
    type: text
    title_text: What Revenue and Return on Advertising Spend Did We Earn?
    subtitle_text: ''
    body_text: ''
    row: 23
    col: 0
    width: 24
    height: 2
  - name: For QA purposes what were the detailed ad performance stats?
    type: text
    title_text: For QA purposes what were the detailed ad performance stats?
    subtitle_text: ''
    body_text: ''
    row: 33
    col: 0
    width: 24
    height: 2
  - title: Ad Campaign Performance
    name: Ad Campaign Performance
    model: analytics
    explore: ad_spend_roi_fact
    type: looker_grid
    fields: [ad_spend_roi_fact.platform, ad_spend_roi_fact.campaign_name, ad_spend_roi_fact.ad_group_name,
      ad_spend_roi_fact.total_reported_spend, ad_spend_roi_fact.total_reported_impressions,
      ad_spend_roi_fact.total_reported_clicks, ad_spend_roi_fact.total_actual_clicks,
      ad_spend_roi_fact.avg_reported_ctr, ad_spend_roi_fact.avg_actual_ctr, ad_spend_roi_fact.avg_reported_cpc,
      ad_spend_roi_fact.avg_actual_cpc]
    sorts: [ad_spend_roi_fact.platform desc, ad_spend_roi_fact.campaign_name desc,
      ad_spend_roi_fact.ad_group_name desc]
    limit: 500
    total: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      ad_spend_roi_fact.total_reported_spend:
        is_active: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Campaign Name: ad_spend_roi_fact.campaign_name
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 35
    col: 0
    width: 24
    height: 8
  - title: Total Revenue
    name: Total Revenue
    model: analytics
    explore: ad_spend_roi_fact
    type: single_value
    fields: [ad_spend_roi_fact.campaign_ts_month, ad_spend_roi_fact.total_reported_spend,
      ad_spend_roi_fact.dynamic_first_order_conversions, ad_spend_roi_fact.dynamic_repeat_order_conversions,
      ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue,
      ad_spend_roi_fact.dynamic_first_order_lifetime_value]
    fill_fields: [ad_spend_roi_fact.campaign_ts_month]
    sorts: [ad_spend_roi_fact.campaign_ts_month desc]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: "${ad_spend_roi_fact.dynamic_first_order_net_revenue}+${ad_spend_roi_fact.dynamic_repeat_order_net_revenue}",
        label: Total Revenue, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: total_revenue, _type_hint: number},
      {category: table_calculation, expression: "${total_revenue}/${ad_spend_roi_fact.total_reported_spend}",
        label: ROAS, value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: roas, _type_hint: number}, {category: table_calculation,
        expression: 'sum(${total_revenue})', label: R.O.A.S., value_format: !!null '',
        value_format_name: gbp_0, _kind_hint: measure, table_calculation: roas_1,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Total Revenue
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    series_labels:
      ad_spend_roi_fact.dynamic_repeat_order_conversions: Repeat Orders
      ad_spend_roi_fact.dynamic_first_order_conversions: First Orders
      ad_spend_roi_fact.dynamic_first_order_net_revenue: First Order Revenue
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue: Repeat Order Revenue
    series_cell_visualizations:
      ad_spend_roi_fact.total_reported_spend:
        is_active: false
      roas:
        is_active: true
    series_text_format:
      total_revenue: {}
      ad_spend_roi_fact.campaign_ts_month: {}
      ad_spend_roi_fact.total_reported_spend: {}
      ad_spend_roi_fact.dynamic_first_order_net_revenue:
        fg_color: "#8f8f8f"
      roas:
        bold: true
      ad_spend_roi_fact.dynamic_first_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue:
        fg_color: "#8f8f8f"
    table_theme: white
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '9'
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    series_value_format:
      ad_spend_roi_fact.dynamic_first_order_lifetime_value: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_first_order_net_revenue: '"kr "#,##0'
      total_revenue: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
      ad_spend_roi_fact.dynamic_first_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
    series_types: {}
    hide_totals: false
    hide_row_totals: false
    defaults_version: 1
    hidden_fields: [total_revenue, roas, ad_spend_roi_fact.dynamic_first_order_conversions,
      ad_spend_roi_fact.total_reported_spend, ad_spend_roi_fact.dynamic_repeat_order_conversions,
      ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue,
      ad_spend_roi_fact.dynamic_first_order_lifetime_value]
    y_axes: []
    listen:
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 0
    col: 5
    width: 5
    height: 6
  - title: Total Spend
    name: Total Spend
    model: analytics
    explore: ad_spend_roi_fact
    type: single_value
    fields: [ad_spend_roi_fact.campaign_ts_month, ad_spend_roi_fact.total_reported_spend,
      ad_spend_roi_fact.dynamic_first_order_conversions, ad_spend_roi_fact.dynamic_repeat_order_conversions,
      ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue,
      ad_spend_roi_fact.dynamic_first_order_lifetime_value]
    fill_fields: [ad_spend_roi_fact.campaign_ts_month]
    sorts: [ad_spend_roi_fact.campaign_ts_month desc]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: "${ad_spend_roi_fact.dynamic_first_order_net_revenue}+${ad_spend_roi_fact.dynamic_repeat_order_net_revenue}",
        label: Total Revenue, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: total_revenue, _type_hint: number},
      {category: table_calculation, expression: "${total_revenue}/${ad_spend_roi_fact.total_reported_spend}",
        label: ROAS, value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: roas, _type_hint: number}, {category: table_calculation,
        expression: 'sum(${ad_spend_roi_fact.total_reported_spend})', label: Total
          Spend, value_format: '"kr "#,##0', value_format_name: !!null '', _kind_hint: measure,
        table_calculation: total_spend, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    series_labels:
      ad_spend_roi_fact.dynamic_repeat_order_conversions: Repeat Orders
      ad_spend_roi_fact.dynamic_first_order_conversions: First Orders
      ad_spend_roi_fact.dynamic_first_order_net_revenue: First Order Revenue
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue: Repeat Order Revenue
    series_cell_visualizations:
      ad_spend_roi_fact.total_reported_spend:
        is_active: false
      roas:
        is_active: true
    series_text_format:
      total_revenue: {}
      ad_spend_roi_fact.campaign_ts_month: {}
      ad_spend_roi_fact.total_reported_spend: {}
      ad_spend_roi_fact.dynamic_first_order_net_revenue:
        fg_color: "#8f8f8f"
      roas:
        bold: true
      ad_spend_roi_fact.dynamic_first_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue:
        fg_color: "#8f8f8f"
    table_theme: white
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '9'
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    series_value_format:
      ad_spend_roi_fact.dynamic_first_order_lifetime_value: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_first_order_net_revenue: '"kr "#,##0'
      total_revenue: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
      ad_spend_roi_fact.dynamic_first_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
    series_types: {}
    hide_totals: false
    hide_row_totals: false
    defaults_version: 1
    hidden_fields: [ad_spend_roi_fact.dynamic_first_order_lifetime_value, ad_spend_roi_fact.total_reported_spend,
      ad_spend_roi_fact.dynamic_first_order_conversions, ad_spend_roi_fact.dynamic_repeat_order_conversions,
      ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue,
      total_revenue, roas]
    y_axes: []
    listen:
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 0
    col: 0
    width: 5
    height: 6
  - title: Performance by Month
    name: Performance by Month
    model: analytics
    explore: ad_spend_roi_fact
    type: looker_grid
    fields: [ad_spend_roi_fact.campaign_ts_month, ad_spend_roi_fact.total_reported_spend,
      ad_spend_roi_fact.dynamic_first_order_conversions, ad_spend_roi_fact.dynamic_repeat_order_conversions,
      ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue,
      ad_spend_roi_fact.dynamic_first_order_lifetime_value, ad_spend_roi_fact.dynamic_account_opening_conversions]
    fill_fields: [ad_spend_roi_fact.campaign_ts_month]
    sorts: [ad_spend_roi_fact.campaign_ts_month desc]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: "${ad_spend_roi_fact.dynamic_first_order_net_revenue}+${ad_spend_roi_fact.dynamic_repeat_order_net_revenue}",
        label: Total Revenue, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: total_revenue, _type_hint: number},
      {category: table_calculation, expression: "${total_revenue}/${ad_spend_roi_fact.total_reported_spend}",
        label: ROAS, value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: roas, _type_hint: number}, {category: table_calculation,
        expression: 'sum(${total_revenue})/sum(${ad_spend_roi_fact.total_reported_spend})',
        label: R.O.A.S., value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: roas_1, _type_hint: number}]
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      ad_spend_roi_fact.dynamic_repeat_order_conversions: Repeat Orders
      ad_spend_roi_fact.dynamic_first_order_conversions: First Orders
      ad_spend_roi_fact.dynamic_first_order_net_revenue: First Order Revenue
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue: Repeat Order Revenue
      ad_spend_roi_fact.dynamic_first_order_lifetime_value: Lifetime Value
      ad_spend_roi_fact.dynamic_account_opening_conversions: Account Openings
    series_cell_visualizations:
      ad_spend_roi_fact.total_reported_spend:
        is_active: false
      roas:
        is_active: true
    series_text_format:
      total_revenue: {}
      ad_spend_roi_fact.campaign_ts_month: {}
      ad_spend_roi_fact.total_reported_spend: {}
      ad_spend_roi_fact.dynamic_first_order_net_revenue:
        fg_color: "#8f8f8f"
      roas:
        bold: true
      ad_spend_roi_fact.dynamic_first_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue:
        fg_color: "#8f8f8f"
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '9'
    series_value_format:
      ad_spend_roi_fact.dynamic_first_order_lifetime_value: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_first_order_net_revenue: '"kr "#,##0'
      total_revenue: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
      ad_spend_roi_fact.dynamic_first_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
      ad_spend_roi_fact.dynamic_account_opening_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
    series_types: {}
    defaults_version: 1
    hidden_fields: [roas_1]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    y_axes: []
    listen:
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 8
    col: 0
    width: 24
    height: 7
  - title: ROAS
    name: ROAS
    model: analytics
    explore: ad_spend_roi_fact
    type: single_value
    fields: [ad_spend_roi_fact.campaign_ts_month, ad_spend_roi_fact.total_reported_spend,
      ad_spend_roi_fact.dynamic_first_order_conversions, ad_spend_roi_fact.dynamic_repeat_order_conversions,
      ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue,
      ad_spend_roi_fact.dynamic_first_order_lifetime_value]
    fill_fields: [ad_spend_roi_fact.campaign_ts_month]
    sorts: [ad_spend_roi_fact.campaign_ts_month desc]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: "${ad_spend_roi_fact.dynamic_first_order_net_revenue}+${ad_spend_roi_fact.dynamic_repeat_order_net_revenue}",
        label: Total Revenue, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: total_revenue, _type_hint: number},
      {category: table_calculation, expression: "${total_revenue}/${ad_spend_roi_fact.total_reported_spend}",
        label: ROAS, value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: roas, _type_hint: number}, {category: table_calculation,
        expression: 'sum(${total_revenue})/sum(${ad_spend_roi_fact.total_reported_spend})',
        label: R.O.A.S., value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: roas_1, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    series_labels:
      ad_spend_roi_fact.dynamic_repeat_order_conversions: Repeat Orders
      ad_spend_roi_fact.dynamic_first_order_conversions: First Orders
      ad_spend_roi_fact.dynamic_first_order_net_revenue: First Order Revenue
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue: Repeat Order Revenue
    series_cell_visualizations:
      ad_spend_roi_fact.total_reported_spend:
        is_active: false
      roas:
        is_active: true
    series_text_format:
      total_revenue: {}
      ad_spend_roi_fact.campaign_ts_month: {}
      ad_spend_roi_fact.total_reported_spend: {}
      ad_spend_roi_fact.dynamic_first_order_net_revenue:
        fg_color: "#8f8f8f"
      roas:
        bold: true
      ad_spend_roi_fact.dynamic_first_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue:
        fg_color: "#8f8f8f"
    table_theme: white
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '9'
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    series_value_format:
      ad_spend_roi_fact.dynamic_first_order_lifetime_value: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_first_order_net_revenue: '"kr "#,##0'
      total_revenue: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
      ad_spend_roi_fact.dynamic_first_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
    series_types: {}
    hide_totals: false
    hide_row_totals: false
    defaults_version: 1
    hidden_fields: [ad_spend_roi_fact.dynamic_first_order_lifetime_value, ad_spend_roi_fact.total_reported_spend,
      ad_spend_roi_fact.dynamic_first_order_conversions, ad_spend_roi_fact.dynamic_repeat_order_conversions,
      ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue,
      total_revenue, roas]
    y_axes: []
    listen:
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 0
    col: 20
    width: 4
    height: 6
  - title: Total Orders
    name: Total Orders
    model: analytics
    explore: ad_spend_roi_fact
    type: single_value
    fields: [ad_spend_roi_fact.campaign_ts_month, ad_spend_roi_fact.total_reported_spend,
      ad_spend_roi_fact.dynamic_first_order_conversions, ad_spend_roi_fact.dynamic_repeat_order_conversions,
      ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.dynamic_repeat_order_net_revenue,
      ad_spend_roi_fact.dynamic_first_order_lifetime_value]
    fill_fields: [ad_spend_roi_fact.campaign_ts_month]
    sorts: [ad_spend_roi_fact.campaign_ts_month desc]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: "${ad_spend_roi_fact.dynamic_first_order_net_revenue}+${ad_spend_roi_fact.dynamic_repeat_order_net_revenue}",
        label: Total Revenue, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: total_revenue, _type_hint: number},
      {category: table_calculation, expression: "${total_revenue}/${ad_spend_roi_fact.total_reported_spend}",
        label: ROAS, value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: roas, _type_hint: number}, {category: table_calculation,
        expression: 'sum(${ad_spend_roi_fact.dynamic_first_order_conversions})+sum(${ad_spend_roi_fact.dynamic_repeat_order_conversions})',
        label: Total Orders, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: total_orders, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    series_labels:
      ad_spend_roi_fact.dynamic_repeat_order_conversions: Repeat Orders
      ad_spend_roi_fact.dynamic_first_order_conversions: First Orders
      ad_spend_roi_fact.dynamic_first_order_net_revenue: First Order Revenue
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue: Repeat Order Revenue
    series_cell_visualizations:
      ad_spend_roi_fact.total_reported_spend:
        is_active: false
      roas:
        is_active: true
    series_text_format:
      total_revenue: {}
      ad_spend_roi_fact.campaign_ts_month: {}
      ad_spend_roi_fact.total_reported_spend: {}
      ad_spend_roi_fact.dynamic_first_order_net_revenue:
        fg_color: "#8f8f8f"
      roas:
        bold: true
      ad_spend_roi_fact.dynamic_first_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        fg_color: "#8f8f8f"
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue:
        fg_color: "#8f8f8f"
    table_theme: white
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '9'
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    series_value_format:
      ad_spend_roi_fact.dynamic_first_order_lifetime_value: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_first_order_net_revenue: '"kr "#,##0'
      total_revenue: '"kr "#,##0'
      ad_spend_roi_fact.dynamic_repeat_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
      ad_spend_roi_fact.dynamic_first_order_conversions:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
    series_types: {}
    hide_totals: false
    hide_row_totals: false
    defaults_version: 1
    hidden_fields: [total_revenue, roas, ad_spend_roi_fact.dynamic_first_order_conversions,
      ad_spend_roi_fact.dynamic_first_order_net_revenue, ad_spend_roi_fact.total_reported_spend,
      ad_spend_roi_fact.dynamic_repeat_order_net_revenue, ad_spend_roi_fact.dynamic_first_order_lifetime_value,
      ad_spend_roi_fact.dynamic_repeat_order_conversions]
    y_axes: []
    listen:
      Ad Group Name: ad_spend_roi_fact.ad_group_name
      "       Campaign  Date": ad_spend_roi_fact.campaign_ts_date
      "   Attribution Model": ad_spend_roi_fact.attribution_model
      "    Ad Network": ad_spend_roi_fact.platform
      "  LTV Days Since First Order": ad_spend_roi_fact.ltv_days_since_first_delivery
    row: 0
    col: 10
    width: 5
    height: 6
  filters:
  - name: "   Attribution Model"
    title: "   Attribution Model"
    type: field_filter
    default_value: FNDC
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: analytics
    explore: ad_spend_roi_fact
    listens_to_filters: []
    field: ad_spend_roi_fact.attribution_model
  - name: Campaign Name
    title: Campaign Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: analytics
    explore: ad_spend_roi_fact
    listens_to_filters: []
    field: ad_spend_roi_fact.campaign_name
  - name: "    Ad Network"
    title: "    Ad Network"
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: analytics
    explore: ad_spend_roi_fact
    listens_to_filters: []
    field: ad_spend_roi_fact.platform
  - name: Ad Group Name
    title: Ad Group Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: analytics
    explore: ad_spend_roi_fact
    listens_to_filters: []
    field: ad_spend_roi_fact.ad_group_name
  - name: "       Campaign  Date"
    title: "       Campaign  Date"
    type: field_filter
    default_value: 90 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: analytics
    explore: ad_spend_roi_fact
    listens_to_filters: []
    field: ad_spend_roi_fact.campaign_ts_date
  - name: "  LTV Days Since First Order"
    title: "  LTV Days Since First Order"
    type: field_filter
    default_value: 30d
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: analytics
    explore: ad_spend_roi_fact
    listens_to_filters: []
    field: ad_spend_roi_fact.ltv_days_since_first_delivery
