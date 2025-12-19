-- ============================================
-- KPI: Orders by Region
-- ============================================
-- Description: Order volume distribution across regions
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: Identify market penetration and regional growth opportunities

WITH regional_orders AS (
    SELECT
        order_id,
        region,
        DATE(order_date) AS order_day,
        strftime('%Y-W%W', order_date) AS order_week,
        strftime('%Y-%m', order_date) AS order_month
    FROM fact_orders
)
SELECT
    region,
    order_day AS period,
    'daily' AS grain,
    COUNT(DISTINCT order_id) AS order_count
FROM regional_orders
GROUP BY region, order_day

UNION ALL

SELECT
    region,
    order_week AS period,
    'weekly' AS grain,
    COUNT(DISTINCT order_id) AS order_count
FROM regional_orders
GROUP BY region, order_week

UNION ALL

SELECT
    region,
    order_month AS period,
    'monthly' AS grain,
    COUNT(DISTINCT order_id) AS order_count
FROM regional_orders
GROUP BY region, order_month
ORDER BY grain, period, order_count DESC;

