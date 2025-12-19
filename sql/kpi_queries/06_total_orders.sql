-- ============================================
-- KPI: Total Order Count
-- ============================================
-- Description: Total number of orders placed
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: Primary volume metric for tracking business activity and growth

WITH order_counts AS (
    SELECT
        order_id,
        DATE(order_date) AS order_day,
        strftime('%Y-W%W', order_date) AS order_week,
        strftime('%Y-%m', order_date) AS order_month
    FROM fact_orders
)
SELECT
    order_day AS period,
    'daily' AS grain,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_counts
GROUP BY order_day

UNION ALL

SELECT
    order_week AS period,
    'weekly' AS grain,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_counts
GROUP BY order_week

UNION ALL

SELECT
    order_month AS period,
    'monthly' AS grain,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_counts
GROUP BY order_month
ORDER BY grain, period;

