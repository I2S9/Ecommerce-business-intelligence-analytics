-- ============================================
-- KPI: Average Order Value by Region
-- ============================================
-- Description: Average order value per region
-- Temporal Grain: Weekly, Monthly
-- Business Target: Highlights regional purchasing power and pricing strategy effectiveness

WITH completed_orders_by_region AS (
    SELECT
        order_id,
        region,
        total_amount,
        strftime('%Y-W%W', order_date) AS order_week,
        strftime('%Y-%m', order_date) AS order_month
    FROM fact_orders
    WHERE order_status = 'completed'
),
regional_revenue AS (
    SELECT
        region,
        order_week AS period,
        'weekly' AS grain,
        SUM(total_amount) AS total_revenue,
        COUNT(DISTINCT order_id) AS order_count
    FROM completed_orders_by_region
    GROUP BY region, order_week
    
    UNION ALL
    
    SELECT
        region,
        order_month AS period,
        'monthly' AS grain,
        SUM(total_amount) AS total_revenue,
        COUNT(DISTINCT order_id) AS order_count
    FROM completed_orders_by_region
    GROUP BY region, order_month
)
SELECT
    region,
    period,
    grain,
    total_revenue,
    order_count,
    ROUND(total_revenue / order_count, 2) AS avg_order_value
FROM regional_revenue
ORDER BY grain, period, avg_order_value DESC;

