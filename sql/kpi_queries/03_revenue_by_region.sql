-- ============================================
-- KPI: Revenue by Region
-- ============================================
-- Description: Revenue breakdown by geographic region
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: Identify top-performing markets and expansion opportunities

WITH completed_orders AS (
    SELECT
        order_id,
        total_amount,
        region,
        order_date,
        DATE(order_date) AS order_day,
        strftime('%Y-W%W', order_date) AS order_week,
        strftime('%Y-%m', order_date) AS order_month
    FROM fact_orders
    WHERE order_status = 'completed'
)
SELECT
    region,
    order_day AS period,
    'daily' AS grain,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS order_count
FROM completed_orders
GROUP BY region, order_day

UNION ALL

SELECT
    region,
    order_week AS period,
    'weekly' AS grain,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS order_count
FROM completed_orders
GROUP BY region, order_week

UNION ALL

SELECT
    region,
    order_month AS period,
    'monthly' AS grain,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS order_count
FROM completed_orders
GROUP BY region, order_month
ORDER BY grain, period, total_revenue DESC;

