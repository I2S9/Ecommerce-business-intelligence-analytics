-- ============================================
-- KPI: New Customer Acquisition
-- ============================================
-- Description: Number of new customers acquired in the period
-- Temporal Grain: Daily, Weekly, Monthly
-- Business Target: Steady growth month-over-month (tracks marketing effectiveness)

WITH customer_signups AS (
    SELECT
        customer_id,
        signup_date,
        DATE(signup_date) AS signup_day,
        strftime('%Y-W%W', signup_date) AS signup_week,
        strftime('%Y-%m', signup_date) AS signup_month
    FROM dim_customers
)
SELECT
    signup_day AS period,
    'daily' AS grain,
    COUNT(DISTINCT customer_id) AS new_customers
FROM customer_signups
GROUP BY signup_day

UNION ALL

SELECT
    signup_week AS period,
    'weekly' AS grain,
    COUNT(DISTINCT customer_id) AS new_customers
FROM customer_signups
GROUP BY signup_week

UNION ALL

SELECT
    signup_month AS period,
    'monthly' AS grain,
    COUNT(DISTINCT customer_id) AS new_customers
FROM customer_signups
GROUP BY signup_month
ORDER BY grain, period;

