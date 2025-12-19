-- ============================================
-- KPI: Delivery Status Breakdown
-- ============================================
-- Description: Distribution of deliveries across statuses
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: Track delivery performance and identify areas for improvement

WITH delivery_status_breakdown AS (
    SELECT
        delivery_status,
        DATE(actual_delivery_date) AS delivery_day,
        strftime('%Y-W%W', actual_delivery_date) AS delivery_week,
        strftime('%Y-%m', actual_delivery_date) AS delivery_month,
        COUNT(*) AS status_count
    FROM fact_deliveries
    GROUP BY 
        delivery_status,
        DATE(actual_delivery_date),
        strftime('%Y-W%W', actual_delivery_date),
        strftime('%Y-%m', actual_delivery_date)
),
daily_totals AS (
    SELECT
        delivery_day AS period,
        'daily' AS grain,
        SUM(status_count) AS total_deliveries
    FROM delivery_status_breakdown
    GROUP BY delivery_day
),
weekly_totals AS (
    SELECT
        delivery_week AS period,
        'weekly' AS grain,
        SUM(status_count) AS total_deliveries
    FROM delivery_status_breakdown
    GROUP BY delivery_week
),
monthly_totals AS (
    SELECT
        delivery_month AS period,
        'monthly' AS grain,
        SUM(status_count) AS total_deliveries
    FROM delivery_status_breakdown
    GROUP BY delivery_month
)
SELECT
    dsb.delivery_status,
    dsb.delivery_day AS period,
    'daily' AS grain,
    dsb.status_count,
    dt.total_deliveries,
    ROUND(dsb.status_count * 100.0 / dt.total_deliveries, 2) AS percentage
FROM delivery_status_breakdown dsb
INNER JOIN daily_totals dt ON dsb.delivery_day = dt.period

UNION ALL

SELECT
    dsb.delivery_status,
    dsb.delivery_week AS period,
    'weekly' AS grain,
    dsb.status_count,
    wt.total_deliveries,
    ROUND(dsb.status_count * 100.0 / wt.total_deliveries, 2) AS percentage
FROM delivery_status_breakdown dsb
INNER JOIN weekly_totals wt ON dsb.delivery_week = wt.period

UNION ALL

SELECT
    dsb.delivery_status,
    dsb.delivery_month AS period,
    'monthly' AS grain,
    dsb.status_count,
    mt.total_deliveries,
    ROUND(dsb.status_count * 100.0 / mt.total_deliveries, 2) AS percentage
FROM delivery_status_breakdown dsb
INNER JOIN monthly_totals mt ON dsb.delivery_month = mt.period
ORDER BY grain, period, status_count DESC;

