-- Q1 : volume
SELECT COUNT(*) AS nb_orders FROM orders;
SELECT COUNT(DISTINCT customer_id) AS nb_customers FROM orders;

-- Q2 : CA total
SELECT SUM(price) AS total_revenue
FROM order_items;

-- Q3 : CA par mois
SELECT
  DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
  SUM(oi.price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Q4 : Top 10 produits par CA
SELECT
  p.product_id,
  SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY revenue DESC
LIMIT 10;

-- Q5 : CA par catégories

SELECT
  COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
  SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN category_translation ct
  ON ct.product_category_name = p.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 15;

-- Q6 : nombre d'orders par Etat (clients)

SELECT
  c.customer_state,
  COUNT(DISTINCT o.order_id) AS nb_orders
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY nb_orders DESC;

-- Q7 : Panier moyen (AOV) par mois

WITH monthly AS (
  SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue,
    COUNT(DISTINCT o.order_id) AS nb_orders
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  GROUP BY month
)
SELECT
  month,
  revenue,
  nb_orders,
  revenue / NULLIF(nb_orders, 0) AS avg_order_value
FROM monthly
ORDER BY month;

-- Q8 : Délai de livraison (jours) + statistiques

SELECT
  COUNT(*) AS n,
  AVG((order_delivered_customer_date - order_purchase_timestamp)) AS avg_delivery_time,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (order_delivered_customer_date - order_purchase_timestamp)) AS median_delivery_time,
  PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY (order_delivered_customer_date - order_purchase_timestamp)) AS p90_delivery_time
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;

-- Q9 — Part de CA par catégorie (et cumul %)

WITH cat AS (
  SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
    SUM(oi.price) AS revenue
  FROM order_items oi
  JOIN products p ON p.product_id = oi.product_id
  LEFT JOIN category_translation ct
    ON ct.product_category_name = p.product_category_name
  GROUP BY 1
),
ranked AS (
  SELECT
    category,
    revenue,
    revenue / SUM(revenue) OVER () AS revenue_share,
    SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER () AS cumulative_share
  FROM cat
)
SELECT
  category,
  revenue,
  ROUND(100 * revenue_share, 2) AS revenue_share_pct,
  ROUND(100 * cumulative_share, 2) AS cumulative_share_pct
FROM ranked
ORDER BY revenue DESC
LIMIT 20;

-- Q10 — Variation MoM du CA (Month-over-Month %)

WITH monthly AS (
  SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  GROUP BY 1
),
with_prev AS (
  SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_revenue
  FROM monthly
)
SELECT
  month,
  revenue,
  prev_revenue,
  ROUND(100 * (revenue - prev_revenue) / NULLIF(prev_revenue, 0), 2) AS mom_growth_pct
FROM with_prev
ORDER BY month;

