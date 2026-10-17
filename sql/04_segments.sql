WITH base AS (
  SELECT 'device' AS dimension, device AS segment,
         viewed_item, added_to_cart, began_checkout, added_payment, purchased
  FROM `funnel_analysis.sessions`
  UNION ALL
  SELECT 'medium', medium,
         viewed_item, added_to_cart, began_checkout, added_payment, purchased
  FROM `funnel_analysis.sessions`
  UNION ALL
  SELECT 'user_type', user_type,
         viewed_item, added_to_cart, began_checkout, added_payment, purchased
  FROM `funnel_analysis.sessions`
),
f AS (
  SELECT
    dimension,
    segment,
    COUNT(*)                                                                      AS sessions,
    SUM(viewed_item * added_to_cart)                                              AS s2_add_to_cart,
    SUM(viewed_item * added_to_cart * began_checkout)                             AS s3_begin_checkout,
    SUM(viewed_item * added_to_cart * began_checkout * added_payment)             AS s4_add_payment,
    SUM(viewed_item * added_to_cart * began_checkout * added_payment * purchased) AS s5_purchase
  FROM base
  GROUP BY dimension, segment
)
SELECT
  *,
  ROUND(100 * SAFE_DIVIDE(s5_purchase, sessions), 2)              AS session_conversion_pct,
  ROUND(100 * SAFE_DIVIDE(s4_add_payment, s3_begin_checkout), 1)  AS checkout_to_payment_pct
FROM f
WHERE sessions >= 1000
ORDER BY dimension, sessions DESC;