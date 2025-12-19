-- ============================================
-- KPI: Average Delivery Delay (Days)
-- ============================================
-- Description: Average number of days late for delayed deliveries
-- Temporal Grain: Weekly, Monthly
-- Business Target: Minimize delay days (identify delivery performance issues)

WITH late_deliveries AS (
    SELECT
        order_id,
        promised_delivery_date,
        actual_delivery_date,
        (JULIANDAY(actual_delivery_date) - JULIANDAY(promised_delivery_date)) AS delay_days,
        strftime('%Y-W%W', actual_delivery_date) AS delivery_week,
        strftime('%Y-%m', actual_delivery_date) AS delivery_month
    FROM fact_deliveries
    WHERE delivery_status = 'late'
)
SELECT
    delivery_week AS period,
    'weekly' AS grain,
    COUNT(*) AS late_delivery_count,
    ROUND(AVG(delay_days), 2) AS avg_delay_days,
    ROUND(MAX(delay_days), 2) AS max_delay_days
FROM late_deliveries
GROUP BY delivery_week

UNION ALL

SELECT
    delivery_month AS period,
    'monthly' AS grain,
    COUNT(*) AS late_delivery_count,
    ROUND(AVG(delay_days), 2) AS avg_delay_days,
    ROUND(MAX(delay_days), 2) AS max_delay_days
FROM late_deliveries
GROUP BY delivery_month
ORDER BY grain, period;

