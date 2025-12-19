-- ============================================
-- KPI: Average First Order Value by Segment
-- ============================================
-- Description: Average first order value by customer segment
-- Temporal Grain: Monthly
-- Business Target: Indicates initial customer engagement and upselling potential

WITH customer_first_orders AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.total_amount,
        o.order_date,
        c.customer_segment,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id 
            ORDER BY o.order_date ASC
        ) AS order_rank
    FROM fact_orders o
    INNER JOIN dim_customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'completed'
),
first_orders_only AS (
    SELECT
        customer_id,
        total_amount,
        customer_segment,
        strftime('%Y-%m', order_date) AS order_month
    FROM customer_first_orders
    WHERE order_rank = 1
)
SELECT
    order_month AS period,
    customer_segment,
    COUNT(*) AS first_order_count,
    ROUND(AVG(total_amount), 2) AS avg_first_order_value,
    ROUND(SUM(total_amount), 2) AS total_first_order_revenue
FROM first_orders_only
GROUP BY order_month, customer_segment
ORDER BY order_month, customer_segment;

