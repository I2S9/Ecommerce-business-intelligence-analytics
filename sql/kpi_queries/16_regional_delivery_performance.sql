-- ============================================
-- KPI: Delivery SLA Compliance by Region
-- ============================================
-- Description: Delivery performance by region
-- Temporal Grain: Weekly, Monthly
-- Business Target: Identify regional logistics challenges and operational efficiency gaps

WITH delivery_with_region AS (
    SELECT
        d.order_id,
        d.delivery_status,
        o.region,
        strftime('%Y-W%W', d.actual_delivery_date) AS delivery_week,
        strftime('%Y-%m', d.actual_delivery_date) AS delivery_month
    FROM fact_deliveries d
    INNER JOIN fact_orders o ON d.order_id = o.order_id
),
regional_delivery_counts AS (
    SELECT
        region,
        delivery_week AS period,
        'weekly' AS grain,
        SUM(CASE WHEN delivery_status = 'on_time' THEN 1 ELSE 0 END) AS on_time_count,
        COUNT(*) AS total_deliveries
    FROM delivery_with_region
    GROUP BY region, delivery_week
    
    UNION ALL
    
    SELECT
        region,
        delivery_month AS period,
        'monthly' AS grain,
        SUM(CASE WHEN delivery_status = 'on_time' THEN 1 ELSE 0 END) AS on_time_count,
        COUNT(*) AS total_deliveries
    FROM delivery_with_region
    GROUP BY region, delivery_month
)
SELECT
    region,
    period,
    grain,
    on_time_count,
    total_deliveries,
    ROUND(on_time_count * 100.0 / total_deliveries, 2) AS sla_compliance_rate_pct
FROM regional_delivery_counts
WHERE total_deliveries > 0
ORDER BY grain, period, sla_compliance_rate_pct DESC;

