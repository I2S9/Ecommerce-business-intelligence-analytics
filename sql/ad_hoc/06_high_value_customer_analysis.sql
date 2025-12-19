-- ============================================
-- Analysis: High Value Customer Analysis
-- ============================================
-- Question: Who are our high-value customers and what are their characteristics?
-- Purpose: Identify customer segments for retention and upselling

WITH customer_lifetime_value AS (
    SELECT
        o.customer_id,
        c.customer_segment,
        c.signup_date,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN o.order_status = 'completed' THEN o.order_id END) AS completed_orders,
        SUM(CASE WHEN o.order_status = 'completed' THEN o.total_amount ELSE 0 END) AS lifetime_revenue,
        AVG(CASE WHEN o.order_status = 'completed' THEN o.total_amount END) AS avg_order_value,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date,
        (JULIANDAY(MAX(o.order_date)) - JULIANDAY(MIN(o.order_date))) AS customer_lifetime_days
    FROM fact_orders o
    INNER JOIN dim_customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_segment, c.signup_date
),
customer_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY lifetime_revenue DESC) AS revenue_quartile
    FROM customer_lifetime_value
)
SELECT
    revenue_quartile,
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(lifetime_revenue), 2) AS avg_lifetime_revenue,
    ROUND(AVG(total_orders), 2) AS avg_orders,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value,
    ROUND(AVG(customer_lifetime_days), 2) AS avg_lifetime_days,
    ROUND(AVG(completed_orders * 100.0 / total_orders), 2) AS avg_completion_rate_pct
FROM customer_quartiles
GROUP BY revenue_quartile, customer_segment
ORDER BY revenue_quartile, avg_lifetime_revenue DESC;

