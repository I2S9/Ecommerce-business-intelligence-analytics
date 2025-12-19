-- ============================================
-- KPI: Late Delivery Rate
-- ============================================
-- Description: Percentage of deliveries that arrive after promised date
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: <5% (high rates indicate operational issues requiring logistics optimization)

WITH delivery_status_counts AS (
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
aggregated_metrics AS (
    SELECT
        delivery_day AS period,
        'daily' AS grain,
        SUM(CASE WHEN delivery_status = 'late' THEN status_count ELSE 0 END) AS late_deliveries,
        SUM(status_count) AS total_deliveries
    FROM delivery_status_counts
    GROUP BY delivery_day
    
    UNION ALL
    
    SELECT
        delivery_week AS period,
        'weekly' AS grain,
        SUM(CASE WHEN delivery_status = 'late' THEN status_count ELSE 0 END) AS late_deliveries,
        SUM(status_count) AS total_deliveries
    FROM delivery_status_counts
    GROUP BY delivery_week
    
    UNION ALL
    
    SELECT
        delivery_month AS period,
        'monthly' AS grain,
        SUM(CASE WHEN delivery_status = 'late' THEN status_count ELSE 0 END) AS late_deliveries,
        SUM(status_count) AS total_deliveries
    FROM delivery_status_counts
    GROUP BY delivery_month
)
SELECT
    period,
    grain,
    late_deliveries,
    total_deliveries,
    ROUND(late_deliveries * 100.0 / total_deliveries, 2) AS late_delivery_rate_pct
FROM aggregated_metrics
WHERE total_deliveries > 0
ORDER BY grain, period;

