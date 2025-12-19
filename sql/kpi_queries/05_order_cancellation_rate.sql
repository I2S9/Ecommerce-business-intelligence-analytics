-- ============================================
-- KPI: Order Cancellation Rate
-- ============================================
-- Description: Percentage of orders cancelled
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: <10% (high rates indicate pricing/delivery/customer experience issues)

WITH order_status_counts AS (
    SELECT
        DATE(order_date) AS order_day,
        strftime('%Y-W%W', order_date) AS order_week,
        strftime('%Y-%m', order_date) AS order_month,
        order_status,
        COUNT(*) AS status_count
    FROM fact_orders
    GROUP BY 
        DATE(order_date),
        strftime('%Y-W%W', order_date),
        strftime('%Y-%m', order_date),
        order_status
),
aggregated_metrics AS (
    SELECT
        order_day AS period,
        'daily' AS grain,
        SUM(CASE WHEN order_status = 'cancelled' THEN status_count ELSE 0 END) AS cancelled_orders,
        SUM(status_count) AS total_orders
    FROM order_status_counts
    GROUP BY order_day
    
    UNION ALL
    
    SELECT
        order_week AS period,
        'weekly' AS grain,
        SUM(CASE WHEN order_status = 'cancelled' THEN status_count ELSE 0 END) AS cancelled_orders,
        SUM(status_count) AS total_orders
    FROM order_status_counts
    GROUP BY order_week
    
    UNION ALL
    
    SELECT
        order_month AS period,
        'monthly' AS grain,
        SUM(CASE WHEN order_status = 'cancelled' THEN status_count ELSE 0 END) AS cancelled_orders,
        SUM(status_count) AS total_orders
    FROM order_status_counts
    GROUP BY order_month
)
SELECT
    period,
    grain,
    cancelled_orders,
    total_orders,
    ROUND(cancelled_orders * 100.0 / total_orders, 2) AS cancellation_rate_pct
FROM aggregated_metrics
ORDER BY grain, period;

