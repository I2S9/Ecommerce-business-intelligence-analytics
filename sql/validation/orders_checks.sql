-- Duplicate orders
SELECT order_id, COUNT(*)
FROM fact_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Negative amounts
SELECT *
FROM fact_orders
WHERE total_amount <= 0;

-- Missing customer_id
SELECT *
FROM fact_orders
WHERE customer_id IS NULL;

-- Invalid order_status
SELECT DISTINCT order_status
FROM fact_orders
WHERE order_status NOT IN ('completed', 'cancelled');

-- Invalid region
SELECT DISTINCT region
FROM fact_orders
WHERE region NOT IN ('UK', 'DE', 'FR', 'ES');

-- Future order dates
SELECT *
FROM fact_orders
WHERE order_date > CURRENT_TIMESTAMP;

