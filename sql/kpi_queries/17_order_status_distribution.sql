-- ============================================
-- KPI: Order Status Breakdown
-- ============================================
-- Description: Distribution of orders across statuses
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: Monitor order flow and identify bottlenecks in order processing pipeline

WITH order_status_breakdown AS (
    SELECT
        order_status,
        DATE(order_date) AS order_day,
        strftime('%Y-W%W', order_date) AS order_week,
        strftime('%Y-%m', order_date) AS order_month,
        COUNT(*) AS status_count
    FROM fact_orders
    GROUP BY 
        order_status,
        DATE(order_date),
        strftime('%Y-W%W', order_date),
        strftime('%Y-%m', order_date)
),
daily_totals AS (
    SELECT
        order_day AS period,
        'daily' AS grain,
        SUM(status_count) AS total_orders
    FROM order_status_breakdown
    GROUP BY order_day
),
weekly_totals AS (
    SELECT
        order_week AS period,
        'weekly' AS grain,
        SUM(status_count) AS total_orders
    FROM order_status_breakdown
    GROUP BY order_week
),
monthly_totals AS (
    SELECT
        order_month AS period,
        'monthly' AS grain,
        SUM(status_count) AS total_orders
    FROM order_status_breakdown
    GROUP BY order_month
)
SELECT
    osb.order_status,
    osb.order_day AS period,
    'daily' AS grain,
    osb.status_count,
    dt.total_orders,
    ROUND(osb.status_count * 100.0 / dt.total_orders, 2) AS percentage
FROM order_status_breakdown osb
INNER JOIN daily_totals dt ON osb.order_day = dt.period

UNION ALL

SELECT
    osb.order_status,
    osb.order_week AS period,
    'weekly' AS grain,
    osb.status_count,
    wt.total_orders,
    ROUND(osb.status_count * 100.0 / wt.total_orders, 2) AS percentage
FROM order_status_breakdown osb
INNER JOIN weekly_totals wt ON osb.order_week = wt.period

UNION ALL

SELECT
    osb.order_status,
    osb.order_month AS period,
    'monthly' AS grain,
    osb.status_count,
    mt.total_orders,
    ROUND(osb.status_count * 100.0 / mt.total_orders, 2) AS percentage
FROM order_status_breakdown osb
INNER JOIN monthly_totals mt ON osb.order_month = mt.period
ORDER BY grain, period, status_count DESC;

