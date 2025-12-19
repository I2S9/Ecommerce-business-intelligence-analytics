-- ============================================
-- Analysis: Customer Segment Performance
-- ============================================
-- Question: How do different customer segments perform?
-- Purpose: Understand segment value and optimize targeting strategies

WITH segment_metrics AS (
    SELECT
        c.customer_segment,
        COUNT(DISTINCT c.customer_id) AS total_customers,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN o.order_status = 'completed' THEN o.order_id END) AS completed_orders,
        SUM(CASE WHEN o.order_status = 'completed' THEN o.total_amount ELSE 0 END) AS total_revenue,
        AVG(CASE WHEN o.order_status = 'completed' THEN o.total_amount END) AS avg_order_value,
        COUNT(DISTINCT o.customer_id) AS active_customers
    FROM dim_customers c
    LEFT JOIN fact_orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_segment
),
segment_first_orders AS (
    SELECT
        c.customer_segment,
        o.customer_id,
        o.total_amount,
        ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS order_rank
    FROM fact_orders o
    INNER JOIN dim_customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'completed'
)
SELECT
    sm.customer_segment,
    sm.total_customers,
    sm.active_customers,
    ROUND(sm.active_customers * 100.0 / sm.total_customers, 2) AS activation_rate_pct,
    sm.total_orders,
    sm.completed_orders,
    ROUND(sm.completed_orders * 100.0 / sm.total_orders, 2) AS completion_rate_pct,
    ROUND(sm.total_revenue, 2) AS total_revenue,
    ROUND(sm.avg_order_value, 2) AS avg_order_value,
    ROUND(sm.total_revenue / sm.active_customers, 2) AS revenue_per_active_customer,
    ROUND(AVG(CASE WHEN sfo.order_rank = 1 THEN sfo.total_amount END), 2) AS avg_first_order_value,
    ROUND(sm.total_revenue / sm.total_customers, 2) AS revenue_per_total_customer
FROM segment_metrics sm
LEFT JOIN segment_first_orders sfo ON sm.customer_segment = sfo.customer_segment
GROUP BY 
    sm.customer_segment,
    sm.total_customers,
    sm.active_customers,
    sm.total_orders,
    sm.completed_orders,
    sm.total_revenue,
    sm.avg_order_value
ORDER BY sm.total_revenue DESC;

