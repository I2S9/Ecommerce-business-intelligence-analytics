-- ============================================
-- Analysis: Delivery Delay Root Cause Analysis
-- ============================================
-- Question: What causes delivery delays? Are there regional or temporal patterns?
-- Purpose: Identify factors contributing to late deliveries

WITH delivery_analysis AS (
    SELECT
        d.order_id,
        o.region,
        o.order_date,
        d.promised_delivery_date,
        d.actual_delivery_date,
        d.delivery_status,
        (JULIANDAY(d.actual_delivery_date) - JULIANDAY(d.promised_delivery_date)) AS delay_days,
        (JULIANDAY(d.promised_delivery_date) - JULIANDAY(o.order_date)) AS promised_lead_time_days,
        strftime('%Y-%m', d.actual_delivery_date) AS delivery_month,
        CASE 
            WHEN strftime('%w', d.actual_delivery_date) IN ('0', '6') THEN 'weekend'
            ELSE 'weekday'
        END AS delivery_day_type
    FROM fact_deliveries d
    INNER JOIN fact_orders o ON d.order_id = o.order_id
)
SELECT
    region,
    delivery_month,
    delivery_day_type,
    COUNT(*) AS total_deliveries,
    SUM(CASE WHEN delivery_status = 'late' THEN 1 ELSE 0 END) AS late_deliveries,
    ROUND(AVG(promised_lead_time_days), 2) AS avg_promised_lead_time,
    ROUND(AVG(CASE WHEN delivery_status = 'late' THEN delay_days END), 2) AS avg_delay_days,
    ROUND(MAX(CASE WHEN delivery_status = 'late' THEN delay_days END), 2) AS max_delay_days,
    ROUND(AVG(CASE WHEN delivery_status = 'late' THEN delay_days END) * 100.0 / 
          AVG(promised_lead_time_days), 2) AS delay_as_pct_of_lead_time
FROM delivery_analysis
GROUP BY region, delivery_month, delivery_day_type
HAVING late_deliveries > 0
ORDER BY late_deliveries DESC, avg_delay_days DESC;

