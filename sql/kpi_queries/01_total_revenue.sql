-- ============================================
-- KPI: Total Revenue (GMV)
-- ============================================
-- Description: Total value of completed orders
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: Track business growth and financial performance

WITH completed_orders AS (
    SELECT
        order_id,
        total_amount,
        order_date,
        DATE(order_date) AS order_day,
        strftime('%Y-W%W', order_date) AS order_week,
        strftime('%Y-%m', order_date) AS order_month
    FROM fact_orders
    WHERE order_status = 'completed'
)
SELECT
    order_day AS period,
    'daily' AS grain,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS order_count
FROM completed_orders
GROUP BY order_day

UNION ALL

SELECT
    order_week AS period,
    'weekly' AS grain,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS order_count
FROM completed_orders
GROUP BY order_week

UNION ALL

SELECT
    order_month AS period,
    'monthly' AS grain,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS order_count
FROM completed_orders
GROUP BY order_month
ORDER BY grain, period;

