- dashboard: revenue_attribution
  title: Revenue Attribution
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Account Openings
    name: Account Openings
    model: analytics
    explore: attribution_fact
    type: single_value
    fields: [attribution_fact.dynamic_account_opening_conversions, attribution_fact.dynamic_first_order_conversions,
      attribution_fact.dynamic_repeat_order_conversions, attribution_fact.dynamic_first_order_net_revenue,
      attribution_fact.dynamic_repeat_order_net_revenue, attribution_fact.dynamic_first_order_lifetime_value]
    limit: 500
    query_timezone: Europe/Oslo
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 0
    col: 0
    width: 4
    height: 4
  - title: Repeat Order Net Revenue
    name: Repeat Order Net Revenue
    model: analytics
    explore: attribution_fact
    type: single_value
    fields: [attribution_fact.dynamic_repeat_order_net_revenue]
    limit: 500
    query_timezone: Europe/Oslo
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: ''
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
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 0
    col: 12
    width: 4
    height: 4
  - title: Lifetime Value
    name: Lifetime Value
    model: analytics
    explore: attribution_fact
    type: single_value
    fields: [attribution_fact.dynamic_first_order_lifetime_value]
    limit: 500
    query_timezone: Europe/Oslo
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: ''
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
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 0
    col: 20
    width: 4
    height: 4
  - title: First Orders
    name: First Orders
    model: analytics
    explore: attribution_fact
    type: single_value
    fields: [attribution_fact.dynamic_account_opening_conversions, attribution_fact.dynamic_first_order_conversions,
      attribution_fact.dynamic_repeat_order_conversions, attribution_fact.dynamic_first_order_net_revenue,
      attribution_fact.dynamic_repeat_order_net_revenue, attribution_fact.dynamic_first_order_lifetime_value]
    limit: 500
    query_timezone: Europe/Oslo
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: [attribution_fact.dynamic_account_opening_conversions]
    y_axes: []
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 0
    col: 8
    width: 4
    height: 4
  - title: First Order Net Revenue
    name: First Order Net Revenue
    model: analytics
    explore: attribution_fact
    type: single_value
    fields: [attribution_fact.dynamic_first_order_net_revenue]
    limit: 500
    query_timezone: Europe/Oslo
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: ''
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
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 0
    col: 4
    width: 4
    height: 4
  - title: Repeat Orders
    name: Repeat Orders
    model: analytics
    explore: attribution_fact
    type: single_value
    fields: [attribution_fact.dynamic_repeat_order_conversions]
    limit: 500
    query_timezone: Europe/Oslo
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 0
    col: 16
    width: 4
    height: 4
  - title: Accounts Openings, First and Repeat Orders
    name: Accounts Openings, First and Repeat Orders
    model: analytics
    explore: attribution_fact
    type: looker_column
    fields: [attribution_fact.dynamic_account_opening_conversions, attribution_fact.dynamic_first_order_conversions,
      attribution_fact.dynamic_repeat_order_conversions, attribution_fact.converted_ts_week]
    fill_fields: [attribution_fact.converted_ts_week]
    sorts: [attribution_fact.converted_ts_week desc]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    series_types: {}
    series_labels:
      attribution_fact.dynamic_account_opening_conversions: Account Openings
      attribution_fact.dynamic_first_order_conversions: First Orders
      attribution_fact.dynamic_repeat_order_conversions: Repeat Orders
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 6
    col: 0
    width: 12
    height: 7
  - title: First and Repeat Order Revenue
    name: First and Repeat Order Revenue
    model: analytics
    explore: attribution_fact
    type: looker_column
    fields: [attribution_fact.converted_ts_week, attribution_fact.dynamic_first_order_net_revenue,
      attribution_fact.dynamic_repeat_order_net_revenue]
    fill_fields: [attribution_fact.converted_ts_week]
    sorts: [attribution_fact.converted_ts_week desc]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    series_types: {}
    series_labels:
      attribution_fact.dynamic_first_order_net_revenue: First Order Net Revenue
      attribution_fact.dynamic_repeat_order_net_revenue: Repeat Order Net Revenue
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 6
    col: 12
    width: 12
    height: 7
  - title: Account Openings by Channel
    name: Account Openings by Channel
    model: analytics
    explore: attribution_fact
    type: looker_pie
    fields: [attribution_fact.dynamic_account_opening_conversions, attribution_fact.channel]
    sorts: [attribution_fact.channel]
    limit: 500
    value_labels: legend
    label_type: labPer
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
    series_types: {}
    point_style: none
    series_labels:
      attribution_fact.dynamic_account_opening_conversions: Account Openings
      attribution_fact.dynamic_first_order_conversions: First Orders
      attribution_fact.dynamic_repeat_order_conversions: Repeat Orders
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 22
    col: 0
    width: 6
    height: 7
  - title: Total Order Revenue
    name: Total Order Revenue
    model: analytics
    explore: attribution_fact
    type: looker_pie
    fields: [attribution_fact.channel, attribution_fact.dynamic_first_order_net_revenue,
      attribution_fact.dynamic_repeat_order_net_revenue]
    sorts: [attribution_fact.channel]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${attribution_fact.dynamic_first_order_net_revenue}+${attribution_fact.dynamic_repeat_order_net_revenue}",
        label: Total Revenue, value_format: !!null '', value_format_name: gbp_0, _kind_hint: measure,
        table_calculation: total_revenue, _type_hint: number}]
    value_labels: legend
    label_type: labPer
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
    series_types: {}
    point_style: none
    series_labels:
      attribution_fact.dynamic_account_opening_conversions: Account Openings
      attribution_fact.dynamic_first_order_conversions: First Orders
      attribution_fact.dynamic_repeat_order_conversions: Repeat Orders
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [attribution_fact.dynamic_first_order_net_revenue, attribution_fact.dynamic_repeat_order_net_revenue]
    y_axes: []
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 22
    col: 12
    width: 6
    height: 7
  - title: Total Orders by Channel
    name: Total Orders by Channel
    model: analytics
    explore: attribution_fact
    type: looker_pie
    fields: [attribution_fact.channel, attribution_fact.dynamic_first_order_conversions,
      attribution_fact.dynamic_repeat_order_conversions]
    filters: {}
    sorts: [attribution_fact.channel]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${attribution_fact.dynamic_first_order_conversions}+${attribution_fact.dynamic_repeat_order_conversions}",
        label: Total Orders, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: total_orders, _type_hint: number}]
    value_labels: legend
    label_type: labPer
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
    series_types: {}
    point_style: none
    series_labels:
      attribution_fact.dynamic_account_opening_conversions: Account Openings
      attribution_fact.dynamic_first_order_conversions: First Orders
      attribution_fact.dynamic_repeat_order_conversions: Repeat Orders
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [attribution_fact.dynamic_first_order_conversions, attribution_fact.dynamic_repeat_order_conversions]
    y_axes: []
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 22
    col: 6
    width: 6
    height: 7
  - title: Lifetime Value
    name: Lifetime Value (2)
    model: analytics
    explore: attribution_fact
    type: looker_pie
    fields: [attribution_fact.channel, attribution_fact.dynamic_first_order_lifetime_value]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${attribution_fact.dynamic_first_order_net_revenue}+${attribution_fact.dynamic_repeat_order_net_revenue}",
        label: Total Revenue, value_format: !!null '', value_format_name: gbp_0, _kind_hint: measure,
        table_calculation: total_revenue, _type_hint: number, is_disabled: true},
      {category: table_calculation, expression: 'if(is_null(${attribution_fact.channel}),"direct",${attribution_fact.channel})',
        label: Marketing Channel, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, table_calculation: marketing_channel, _type_hint: string,
        is_disabled: true}]
    value_labels: legend
    label_type: labPer
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
    series_types: {}
    point_style: none
    series_labels:
      attribution_fact.dynamic_account_opening_conversions: Account Openings
      attribution_fact.dynamic_first_order_conversions: First Orders
      attribution_fact.dynamic_repeat_order_conversions: Repeat Orders
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 22
    col: 18
    width: 6
    height: 7
  - title: Account Openings by Channel
    name: Account Openings by Channel (2)
    model: analytics
    explore: attribution_fact
    type: looker_grid
    fields: [attribution_fact.dynamic_account_opening_conversions, attribution_fact.channel]
    sorts: [attribution_fact.channel]
    limit: 500
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
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    legend_position: center
    series_types: {}
    point_style: none
    series_labels:
      attribution_fact.dynamic_account_opening_conversions: Account Openings
      attribution_fact.dynamic_first_order_conversions: First Orders
      attribution_fact.dynamic_repeat_order_conversions: Repeat Orders
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    value_labels: legend
    label_type: labPer
    hidden_fields: []
    y_axes: []
    title_hidden: true
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 29
    col: 0
    width: 6
    height: 7
  - title: Total Orders by Channel
    name: Total Orders by Channel (2)
    model: analytics
    explore: attribution_fact
    type: looker_grid
    fields: [attribution_fact.channel, attribution_fact.dynamic_first_order_conversions,
      attribution_fact.dynamic_repeat_order_conversions]
    filters: {}
    sorts: [attribution_fact.channel]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${attribution_fact.dynamic_first_order_conversions}+${attribution_fact.dynamic_repeat_order_conversions}",
        label: Total Orders, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: total_orders, _type_hint: number}]
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
    series_labels:
      attribution_fact.dynamic_account_opening_conversions: Account Openings
      attribution_fact.dynamic_first_order_conversions: First Orders
      attribution_fact.dynamic_repeat_order_conversions: Repeat Orders
    series_cell_visualizations:
      total_orders:
        is_active: true
    value_labels: legend
    label_type: labPer
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
    stacking: normal
    legend_position: center
    series_types: {}
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [attribution_fact.dynamic_first_order_conversions, attribution_fact.dynamic_repeat_order_conversions]
    y_axes: []
    title_hidden: true
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 29
    col: 6
    width: 6
    height: 7
  - title: Lifetime Value
    name: Lifetime Value (3)
    model: analytics
    explore: attribution_fact
    type: looker_grid
    fields: [attribution_fact.channel, attribution_fact.dynamic_first_order_lifetime_value]
    sorts: [attribution_fact.channel]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${attribution_fact.dynamic_first_order_net_revenue}+${attribution_fact.dynamic_repeat_order_net_revenue}",
        label: Total Revenue, value_format: !!null '', value_format_name: gbp_0, _kind_hint: measure,
        table_calculation: total_revenue, _type_hint: number, is_disabled: true},
      {category: table_calculation, expression: 'if(is_null(${attribution_fact.channel}),"direct",${attribution_fact.channel})',
        label: Marketing Channel, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, table_calculation: marketing_channel, _type_hint: string,
        is_disabled: true}]
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
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    legend_position: center
    series_types: {}
    point_style: none
    series_labels:
      attribution_fact.dynamic_account_opening_conversions: Account Openings
      attribution_fact.dynamic_first_order_conversions: First Orders
      attribution_fact.dynamic_repeat_order_conversions: Repeat Orders
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    value_labels: legend
    label_type: labPer
    hidden_fields: []
    y_axes: []
    title_hidden: true
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 29
    col: 18
    width: 6
    height: 7
  - title: Total Order Revenue
    name: Total Order Revenue (2)
    model: analytics
    explore: attribution_fact
    type: looker_grid
    fields: [attribution_fact.channel, attribution_fact.dynamic_first_order_net_revenue,
      attribution_fact.dynamic_repeat_order_net_revenue]
    sorts: [attribution_fact.channel]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${attribution_fact.dynamic_first_order_net_revenue}+${attribution_fact.dynamic_repeat_order_net_revenue}",
        label: Total Revenue, value_format: !!null '', value_format_name: gbp_0, _kind_hint: measure,
        table_calculation: total_revenue, _type_hint: number}]
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
    series_labels:
      attribution_fact.dynamic_account_opening_conversions: Account Openings
      attribution_fact.dynamic_first_order_conversions: First Orders
      attribution_fact.dynamic_repeat_order_conversions: Repeat Orders
    series_cell_visualizations:
      total_revenue:
        is_active: true
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
    stacking: normal
    legend_position: center
    series_types: {}
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    value_labels: legend
    label_type: labPer
    hidden_fields: [attribution_fact.dynamic_first_order_net_revenue, attribution_fact.dynamic_repeat_order_net_revenue]
    y_axes: []
    title_hidden: true
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 29
    col: 12
    width: 6
    height: 7
  - title: User Registrations by Attribution Model
    name: User Registrations by Attribution Model
    model: analytics
    explore: attribution_fact
    type: looker_grid
    fields: [attribution_fact.user_registration_first_click_attrib_conversions, attribution_fact.user_registration_first_non_direct_click_attrib_conversions,
      attribution_fact.user_registration_first_paid_click_attrib_conversions, attribution_fact.user_registration_even_click_attrib_conversions,
      attribution_fact.user_registration_last_click_attrib_conversions, attribution_fact.user_registration_last_non_direct_click_attrib_conversions,
      attribution_fact.user_registration_last_paid_click_attrib_conversions, attribution_fact.user_registration_time_decay_attrib_conversions,
      attribution_fact.channel]
    sorts: [attribution_fact.user_registration_first_click_attrib_conversions desc]
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
      attribution_fact.user_registration_first_click_attrib_conversions:
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
      Attribution Model: attribution_fact.attribution_model
    row: 38
    col: 0
    width: 24
    height: 8
  - title: First Orders by Attribution Model
    name: First Orders by Attribution Model
    model: analytics
    explore: attribution_fact
    type: looker_grid
    fields: [attribution_fact.channel, attribution_fact.first_order_first_click_attrib_conversions,
      attribution_fact.first_order_first_non_direct_click_attrib_conversions, attribution_fact.first_order_first_paid_click_attrib_conversions,
      attribution_fact.first_order_even_click_attrib_conversions, attribution_fact.first_order_last_click_attrib_conversions,
      attribution_fact.first_order_last_non_direct_click_attrib_conversions, attribution_fact.first_order_last_paid_click_attrib_conversions,
      attribution_fact.first_order_time_decay_attrib_conversions]
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
      attribution_fact.user_registration_first_click_attrib_conversions:
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
      Attribution Model: attribution_fact.attribution_model
    row: 48
    col: 0
    width: 24
    height: 7
  - name: ''
    type: text
    title_text: ''
    subtitle_text: How was that order revenue attributed by channel?
    body_text: ''
    row: 13
    col: 12
    width: 12
    height: 2
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: How many new accounts, orders and repeat orders did we receive?
    body_text: ''
    row: 4
    col: 0
    width: 12
    height: 2
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: How were those new accounts and orders attributed by channel?
    body_text: ''
    row: 13
    col: 0
    width: 12
    height: 2
  - name: " (4)"
    type: text
    title_text: ''
    subtitle_text: How much first and repeat order revenue did we receive?
    body_text: ''
    row: 4
    col: 12
    width: 12
    height: 2
  - name: " (5)"
    type: text
    title_text: ''
    subtitle_text: For QA Purposes, how did each model attribute new account openings
      by channel?
    body_text: ''
    row: 36
    col: 0
    width: 24
    height: 2
  - name: " (6)"
    type: text
    title_text: ''
    subtitle_text: And also for QA Purposes, how did each model attribute first orders?
    body_text: ''
    row: 46
    col: 0
    width: 24
    height: 2
  - title: Account Openings by Channel
    name: Account Openings by Channel (3)
    model: analytics
    explore: attribution_fact
    type: looker_column
    fields: [attribution_fact.converted_ts_week, attribution_fact.dynamic_account_opening_conversions,
      attribution_fact.channel]
    pivots: [attribution_fact.channel]
    fill_fields: [attribution_fact.converted_ts_week]
    sorts: [attribution_fact.converted_ts_week desc]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    series_types: {}
    series_labels:
      attribution_fact.dynamic_first_order_net_revenue: First Order Net Revenue
      attribution_fact.dynamic_repeat_order_net_revenue: Repeat Order Net Revenue
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 15
    col: 0
    width: 12
    height: 7
  - title: Total Order Revenue by Channel
    name: Total Order Revenue by Channel
    model: analytics
    explore: attribution_fact
    type: looker_column
    fields: [attribution_fact.converted_ts_week, attribution_fact.channel, attribution_fact.dynamic_repeat_order_net_revenue,
      attribution_fact.dynamic_first_order_net_revenue]
    pivots: [attribution_fact.channel]
    fill_fields: [attribution_fact.converted_ts_week]
    sorts: [attribution_fact.converted_ts_week desc, attribution_fact.channel]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${attribution_fact.dynamic_first_order_net_revenue}+${attribution_fact.dynamic_repeat_order_net_revenue}",
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
    show_null_points: true
    interpolation: linear
    series_types: {}
    series_labels:
      attribution_fact.dynamic_first_order_net_revenue: First Order Net Revenue
      attribution_fact.dynamic_repeat_order_net_revenue: Repeat Order Net Revenue
    defaults_version: 1
    hidden_fields: [attribution_fact.dynamic_repeat_order_net_revenue, attribution_fact.dynamic_first_order_net_revenue]
    y_axes: []
    listen:
      Marketing Channel: attribution_fact.channel
      Referrer Domain: attribution_fact.referrer_domain
      Conversion Date: attribution_fact.converted_ts_date
      Attribution Model: attribution_fact.attribution_model
    row: 15
    col: 12
    width: 12
    height: 7
  filters:
  - name: Conversion Date
    title: Conversion Date
    type: field_filter
    default_value: 90 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: analytics
    explore: attribution_fact
    listens_to_filters: []
    field: attribution_fact.converted_ts_date
  - name: Attribution Model
    title: Attribution Model
    type: field_filter
    default_value: FNDC
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: analytics
    explore: attribution_fact
    listens_to_filters: []
    field: attribution_fact.attribution_model
  - name: Marketing Channel
    title: Marketing Channel
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: analytics
    explore: attribution_fact
    listens_to_filters: []
    field: attribution_fact.channel
  - name: Ltv Days Since First Delivery
    title: Ltv Days Since First Delivery
    type: field_filter
    default_value: 30d
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: analytics
    explore: attribution_fact
    listens_to_filters: []
    field: attribution_fact.ltv_days_since_first_delivery
  - name: Referrer Domain
    title: Referrer Domain
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: analytics
    explore: attribution_fact
    listens_to_filters: []
    field: attribution_fact.referrer_domain
