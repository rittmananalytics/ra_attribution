{{ config(severity = 'warn') }}

WITH
  layers AS (
  SELECT
    'demo orders source' AS source,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(revenue_global_currency) AS total_global_revenue,
    COUNT(DISTINCT user_id) AS total_orderers
  FROM
    {{ ref('orders')}}
  GROUP BY
    1
  UNION ALL
  SELECT
    'segment source' AS source,
    COUNT(DISTINCT
      CASE
        WHEN event_type = 'confirmed_order' THEN event_id
    END
      ) AS total_order,
    coalesce(SUM(0),
      0) AS total_global_revenue,
    COUNT(DISTINCT
      CASE
        WHEN event_type = 'confirmed_order' THEN user_id
    END
      ) AS total_orderers
  FROM
    {{ ref('stg_segment_events_track_events') }}
  UNION ALL
  SELECT
    'rudderstack source' AS source,
    COUNT(DISTINCT
      CASE
        WHEN event_type = 'confirmed_order' THEN event_id
    END
      ) AS total_order,
    SUM(0) AS total_global_revenue,
    COUNT(DISTINCT
      CASE
        WHEN event_type = 'confirmed_order' THEN user_id
    END
      ) AS total_orderers
  FROM
    {{ ref('stg_rudderstack_events_track_events') }}
  UNION ALL
  SELECT
    'snowplow source' AS source,
    COUNT(DISTINCT
      CASE
        WHEN event_type = 'confirmed_order' THEN event_id
    END
      ) AS total_order,
    coalesce(SUM(0),
      0) AS total_global_revenue,
    COUNT(DISTINCT
      CASE
        WHEN event_type = 'confirmed_order' THEN user_id
    END
      ) AS total_orderers
  FROM
    {{ ref('stg_snowplow_events_all_events') }}
  UNION ALL
  SELECT
    'warehouse' AS source,
    (SUM(count_first_order_conversions)+SUM(count_repeat_order_conversions))*-1 AS total_orders,
    (SUM(first_order_total_revenue_global_currency+repeat_order_total_revenue_global_currency))*-1 AS total_global_revenue,
    COUNT(DISTINCT blended_user_id)*-1 AS total_orderers
  FROM
    {{ ref('wh_attribution_fact') }}
  GROUP BY
    1 ),
  variances AS (
  SELECT
    SUM(total_orders) AS total_orders_variance,
    SUM(total_global_revenue) AS total_global_revenue_variance,
    SUM(total_orderers) AS total_orderers_variance
  FROM
    layers )
SELECT
  *
FROM
  variances
WHERE
  total_orders_variance <> 0
  OR total_global_revenue_variance <> 0
  OR total_orderers_variance <> 0
