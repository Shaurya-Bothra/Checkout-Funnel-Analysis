CREATE OR REPLACE TABLE `funnel_analysis.daily_summary` AS
SELECT
  session_date, device, medium, user_type,
  COUNT(*)                                                               AS sessions,
  SUM(viewed_item)                                                       AS s1_view_item,
  SUM(viewed_item * added_to_cart)                                       AS s2_add_to_cart,
  SUM(viewed_item * added_to_cart * began_checkout)                      AS s3_begin_checkout,
  SUM(viewed_item * added_to_cart * began_checkout * added_payment)      AS s4_add_payment,
  SUM(viewed_item * added_to_cart * began_checkout * added_payment * purchased) AS s5_purchase
FROM `funnel_analysis.sessions`
GROUP BY 1, 2, 3, 4;

CREATE OR REPLACE TABLE `funnel_analysis.funnel_stages` AS
SELECT '1. View item' AS stage, 1 AS stage_order, SUM(viewed_item) AS sessions
FROM `funnel_analysis.sessions`
UNION ALL
SELECT '2. Add to cart', 2, SUM(viewed_item * added_to_cart)
FROM `funnel_analysis.sessions`
UNION ALL
SELECT '3. Begin checkout', 3, SUM(viewed_item * added_to_cart * began_checkout)
FROM `funnel_analysis.sessions`
UNION ALL
SELECT '4. Add payment', 4, SUM(viewed_item * added_to_cart * began_checkout * added_payment)
FROM `funnel_analysis.sessions`
UNION ALL
SELECT '5. Purchase', 5, SUM(viewed_item * added_to_cart * began_checkout * added_payment * purchased)
FROM `funnel_analysis.sessions`;