-- ============================================
-- Analysis: Order Cancellation Root Cause
-- ============================================
-- Question: Why are orders being cancelled? What patterns exist?
-- Purpose: Identify root causes of cancellations to reduce cancellation rate

WITH cancelled_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.region,
        o.total_amount,
        o.order_date,
        c.customer_segment,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM fact_deliveries d 
                WHERE d.order_id = o.order_id 
                AND d.delivery_status = 'late'
            ) THEN 'late_delivery_history'
            WHEN EXISTS (
                SELECT 1 FROM fact_deliveries d 
                WHERE d.order_id = o.order_id
            ) THEN 'has_delivery'
            ELSE 'no_delivery'
        END AS delivery_status
    FROM fact_orders o
    INNER JOIN dim_customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'cancelled'
),
customer_order_history AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN o.order_status = 'cancelled' THEN o.order_id END) AS cancelled_count,
        AVG(CASE WHEN o.order_status = 'completed' THEN o.total_amount END) AS avg_order_value
    FROM fact_orders o
    GROUP BY o.customer_id
)
SELECT
    co.region,
    co.customer_segment,
    co.delivery_status,
    COUNT(*) AS cancellation_count,
    ROUND(AVG(co.total_amount), 2) AS avg_cancelled_order_value,
    ROUND(AVG(coh.total_orders), 2) AS avg_customer_total_orders,
    ROUND(AVG(coh.cancelled_count), 2) AS avg_customer_cancellations,
    ROUND(AVG(coh.avg_order_value), 2) AS avg_completed_order_value
FROM cancelled_orders co
LEFT JOIN customer_order_history coh ON co.customer_id = coh.customer_id
GROUP BY co.region, co.customer_segment, co.delivery_status
ORDER BY cancellation_count DESC;

