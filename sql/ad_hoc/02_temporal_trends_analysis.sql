-- ============================================
-- Analysis: Temporal Trends Analysis
-- ============================================
-- Question: How do key metrics evolve over time?
-- Purpose: Identify growth trends, seasonality, and performance patterns

WITH monthly_metrics AS (
    SELECT
        strftime('%Y-%m', o.order_date) AS month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN o.order_status = 'completed' THEN o.order_id END) AS completed_orders,
        SUM(CASE WHEN o.order_status = 'completed' THEN o.total_amount ELSE 0 END) AS revenue,
        COUNT(DISTINCT o.customer_id) AS active_customers,
        COUNT(DISTINCT CASE WHEN c.signup_date >= date(o.order_date, 'start of month') 
                           AND c.signup_date < date(o.order_date, 'start of month', '+1 month')
                      THEN c.customer_id END) AS new_customers
    FROM fact_orders o
    LEFT JOIN dim_customers c ON o.customer_id = c.customer_id
    GROUP BY strftime('%Y-%m', o.order_date)
),
monthly_delivery AS (
    SELECT
        strftime('%Y-%m', d.actual_delivery_date) AS month,
        COUNT(DISTINCT d.order_id) AS deliveries,
        SUM(CASE WHEN d.delivery_status = 'on_time' THEN 1 ELSE 0 END) AS on_time_deliveries
    FROM fact_deliveries d
    GROUP BY strftime('%Y-%m', d.actual_delivery_date)
)
SELECT
    mm.month,
    mm.total_orders,
    mm.completed_orders,
    ROUND(mm.completed_orders * 100.0 / mm.total_orders, 2) AS completion_rate_pct,
    ROUND(mm.revenue, 2) AS revenue,
    ROUND(mm.revenue / mm.completed_orders, 2) AS avg_order_value,
    mm.active_customers,
    mm.new_customers,
    ROUND(mm.revenue / mm.active_customers, 2) AS revenue_per_customer,
    md.deliveries,
    ROUND(md.on_time_deliveries * 100.0 / md.deliveries, 2) AS on_time_delivery_rate_pct,
    -- Calculate month-over-month growth
    LAG(mm.revenue) OVER (ORDER BY mm.month) AS prev_month_revenue,
    ROUND((mm.revenue - LAG(mm.revenue) OVER (ORDER BY mm.month)) * 100.0 / 
          LAG(mm.revenue) OVER (ORDER BY mm.month), 2) AS revenue_growth_pct
FROM monthly_metrics mm
LEFT JOIN monthly_delivery md ON mm.month = md.month
ORDER BY mm.month;

