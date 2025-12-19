-- ============================================
-- KPI: On-Time Delivery Rate
-- ============================================
-- Description: Percentage of deliveries completed on or before promised date
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: >95% (directly impacts customer satisfaction and retention)

WITH delivery_performance AS (
    SELECT
        d.order_id,
        d.promised_delivery_date,
        d.actual_delivery_date,
        CASE 
            WHEN d.actual_delivery_date <= d.promised_delivery_date THEN 1 
            ELSE 0 
        END AS is_on_time,
        DATE(d.actual_delivery_date) AS delivery_day,
        strftime('%Y-W%W', d.actual_delivery_date) AS delivery_week,
        strftime('%Y-%m', d.actual_delivery_date) AS delivery_month
    FROM fact_deliveries d
)
SELECT
    delivery_day AS period,
    'daily' AS grain,
    SUM(is_on_time) AS on_time_count,
    COUNT(*) AS total_deliveries,
    ROUND(SUM(is_on_time) * 100.0 / COUNT(*), 2) AS on_time_rate_pct
FROM delivery_performance
GROUP BY delivery_day

UNION ALL

SELECT
    delivery_week AS period,
    'weekly' AS grain,
    SUM(is_on_time) AS on_time_count,
    COUNT(*) AS total_deliveries,
    ROUND(SUM(is_on_time) * 100.0 / COUNT(*), 2) AS on_time_rate_pct
FROM delivery_performance
GROUP BY delivery_week

UNION ALL

SELECT
    delivery_month AS period,
    'monthly' AS grain,
    SUM(is_on_time) AS on_time_count,
    COUNT(*) AS total_deliveries,
    ROUND(SUM(is_on_time) * 100.0 / COUNT(*), 2) AS on_time_rate_pct
FROM delivery_performance
GROUP BY delivery_month
ORDER BY grain, period;

