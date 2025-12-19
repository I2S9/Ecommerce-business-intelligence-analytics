-- Duplicate customers
SELECT customer_id, COUNT(*)
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Missing signup_date
SELECT *
FROM dim_customers
WHERE signup_date IS NULL;

-- Invalid customer_segment
SELECT DISTINCT customer_segment
FROM dim_customers
WHERE customer_segment NOT IN ('VIP', 'Regular', 'New');

-- Future signup dates
SELECT *
FROM dim_customers
WHERE signup_date > CURRENT_TIMESTAMP;

