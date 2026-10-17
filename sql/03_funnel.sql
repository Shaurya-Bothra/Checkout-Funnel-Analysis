WITH f AS (
  SELECT
    COUNT(*)                                                               AS sessions,
    SUM(viewed_item)                                                       AS s1_view_item,
    SUM(viewed_item * added_to_cart)                                       AS s2_add_to_cart,
    SUM(viewed_item * added_to_cart * began_checkout)                      AS s3_begin_checkout,
    SUM(viewed_item * added_to_cart * began_checkout * added_payment)      AS s4_add_payment,
    SUM(viewed_item * added_to_cart * began_checkout * added_payment * purchased) AS s5_purchase
  FROM `funnel_analysis.sessions`
)
SELECT
  *,
  ROUND(100 * SAFE_DIVIDE(s2_add_to_cart,    s1_view_item),      1) AS view_to_cart_pct,
  ROUND(100 * SAFE_DIVIDE(s3_begin_checkout, s2_add_to_cart),    1) AS cart_to_checkout_pct,
  ROUND(100 * SAFE_DIVIDE(s4_add_payment,    s3_begin_checkout), 1) AS checkout_to_payment_pct,
  ROUND(100 * SAFE_DIVIDE(s5_purchase,       s4_add_payment),    1) AS payment_to_purchase_pct,
  ROUND(100 * SAFE_DIVIDE(s5_purchase,       sessions),          2) AS session_conversion_pct
FROM f;

SELECT SUM(viewed_item) AS view_item, SUM(added_to_cart) AS add_to_cart,
       SUM(began_checkout) AS begin_checkout, SUM(added_payment) AS add_payment,
       SUM(purchased) AS purchase
FROM `funnel_analysis.sessions`;