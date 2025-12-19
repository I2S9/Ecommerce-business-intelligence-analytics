-- ============================================
-- KPI: Customer Segment Distribution
-- ============================================
-- Description: Distribution of customers across segments (VIP, Regular, New)
-- Temporal Grain: Snapshot (current state)
-- Business Target: Understand customer base composition and prioritize retention

WITH segment_counts AS (
    SELECT
        customer_segment,
        COUNT(DISTINCT customer_id) AS customer_count
    FROM dim_customers
    GROUP BY customer_segment
),
total_customers AS (
    SELECT SUM(customer_count) AS total
    FROM segment_counts
)
SELECT
    sc.customer_segment,
    sc.customer_count,
    ROUND(sc.customer_count * 100.0 / tc.total, 2) AS percentage
FROM segment_counts sc
CROSS JOIN total_customers tc
ORDER BY sc.customer_count DESC;

