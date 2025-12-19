-- ============================================
-- KPI: Average Order Value (AOV)
-- ============================================
-- Description: Average amount spent per completed order
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: Increase over time (indicates better customer spending)

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
),
revenue_metrics AS (
    SELECT
        order_day AS period,
        'daily' AS grain,
        SUM(total_amount) AS total_revenue,
        COUNT(DISTINCT order_id) AS order_count
    FROM completed_orders
    GROUP BY order_day
    
    UNION ALL
    
    SELECT
        order_week AS period,
        'weekly' AS grain,
        SUM(total_amount) AS total_revenue,
        COUNT(DISTINCT order_id) AS order_count
    FROM completed_orders
    GROUP BY order_week
    
    UNION ALL
    
    SELECT
        order_month AS period,
        'monthly' AS grain,
        SUM(total_amount) AS total_revenue,
        COUNT(DISTINCT order_id) AS order_count
    FROM completed_orders
    GROUP BY order_month
)
SELECT
    period,
    grain,
    total_revenue,
    order_count,
    ROUND(total_revenue / order_count, 2) AS average_order_value
FROM revenue_metrics
ORDER BY grain, period;

