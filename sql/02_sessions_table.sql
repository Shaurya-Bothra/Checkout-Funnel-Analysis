CREATE OR REPLACE TABLE `funnel_analysis.sessions` AS
WITH events AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) AS event_date,
    event_name,
    device.category        AS device,
    traffic_source.medium  AS medium,   -- how the user was first acquired
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')     AS session_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_number') AS session_number
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
)
SELECT
  user_pseudo_id,
  session_id,
  MIN(event_date)   AS session_date,
  ANY_VALUE(device) AS device,
  ANY_VALUE(medium) AS medium,
  CASE WHEN MIN(session_number) = 1 THEN 'New'
       WHEN MIN(session_number) > 1 THEN 'Returning'
       ELSE 'Unknown' END AS user_type,
  MAX(IF(event_name = 'view_item',        1, 0)) AS viewed_item,
  MAX(IF(event_name = 'add_to_cart',      1, 0)) AS added_to_cart,
  MAX(IF(event_name = 'begin_checkout',   1, 0)) AS began_checkout,
  MAX(IF(event_name = 'add_payment_info', 1, 0)) AS added_payment,
  MAX(IF(event_name = 'purchase',         1, 0)) AS purchased
FROM events
WHERE session_id IS NOT NULL
GROUP BY user_pseudo_id, session_id;