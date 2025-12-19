-- ============================================
-- Analysis: Regional Performance Comparison
-- ============================================
-- Question: Which regions perform best across key metrics?
-- Purpose: Identify top-performing markets and opportunities for improvement

WITH regional_metrics AS (
    SELECT
        o.region,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN o.order_status = 'completed' THEN o.order_id END) AS completed_orders,
        SUM(CASE WHEN o.order_status = 'completed' THEN o.total_amount ELSE 0 END) AS total_revenue,
        AVG(CASE WHEN o.order_status = 'completed' THEN o.total_amount END) AS avg_order_value,
        COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM fact_orders o
    GROUP BY o.region
),
delivery_metrics AS (
    SELECT
        o.region,
        COUNT(DISTINCT d.order_id) AS total_deliveries,
        SUM(CASE WHEN d.delivery_status = 'on_time' THEN 1 ELSE 0 END) AS on_time_deliveries,
        AVG(CASE 
            WHEN d.delivery_status = 'late' 
            THEN JULIANDAY(d.actual_delivery_date) - JULIANDAY(d.promised_delivery_date)
            ELSE NULL 
        END) AS avg_delay_days
    FROM fact_deliveries d
    INNER JOIN fact_orders o ON d.order_id = o.order_id
    GROUP BY o.region
)
SELECT
    rm.region,
    rm.total_orders,
    rm.completed_orders,
    ROUND(rm.completed_orders * 100.0 / rm.total_orders, 2) AS completion_rate_pct,
    ROUND(rm.total_revenue, 2) AS total_revenue,
    ROUND(rm.avg_order_value, 2) AS avg_order_value,
    rm.unique_customers,
    ROUND(rm.total_revenue / rm.unique_customers, 2) AS revenue_per_customer,
    dm.total_deliveries,
    ROUND(dm.on_time_deliveries * 100.0 / dm.total_deliveries, 2) AS on_time_delivery_rate_pct,
    ROUND(dm.avg_delay_days, 2) AS avg_delay_days
FROM regional_metrics rm
LEFT JOIN delivery_metrics dm ON rm.region = dm.region
ORDER BY rm.total_revenue DESC;

