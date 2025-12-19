-- ============================================
-- KPI: Delivery SLA Compliance Rate
-- ============================================
-- Description: Percentage of orders delivered within promised delivery time
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: >95% (critical customer satisfaction metric)

WITH delivery_times AS (
    SELECT
        d.order_id,
        d.delivery_status,
        d.promised_delivery_date,
        d.actual_delivery_date,
        DATE(d.actual_delivery_date) AS delivery_day,
        strftime('%Y-W%W', d.actual_delivery_date) AS delivery_week,
        strftime('%Y-%m', d.actual_delivery_date) AS delivery_month
    FROM fact_deliveries d
),
delivery_counts AS (
    SELECT
        delivery_day AS period,
        'daily' AS grain,
        SUM(CASE WHEN delivery_status = 'on_time' THEN 1 ELSE 0 END) AS on_time_deliveries,
        COUNT(*) AS total_deliveries
    FROM delivery_times
    GROUP BY delivery_day
    
    UNION ALL
    
    SELECT
        delivery_week AS period,
        'weekly' AS grain,
        SUM(CASE WHEN delivery_status = 'on_time' THEN 1 ELSE 0 END) AS on_time_deliveries,
        COUNT(*) AS total_deliveries
    FROM delivery_times
    GROUP BY delivery_week
    
    UNION ALL
    
    SELECT
        delivery_month AS period,
        'monthly' AS grain,
        SUM(CASE WHEN delivery_status = 'on_time' THEN 1 ELSE 0 END) AS on_time_deliveries,
        COUNT(*) AS total_deliveries
    FROM delivery_times
    GROUP BY delivery_month
)
SELECT
    period,
    grain,
    on_time_deliveries,
    total_deliveries,
    ROUND(on_time_deliveries * 100.0 / total_deliveries, 2) AS sla_compliance_rate_pct
FROM delivery_counts
WHERE total_deliveries > 0
ORDER BY grain, period;

