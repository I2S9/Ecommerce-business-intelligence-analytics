-- Duplicate deliveries for same order
SELECT order_id, COUNT(*)
FROM fact_deliveries
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Missing dates
SELECT *
FROM fact_deliveries
WHERE promised_delivery_date IS NULL 
   OR actual_delivery_date IS NULL;

-- Invalid delivery_status
SELECT DISTINCT delivery_status
FROM fact_deliveries
WHERE delivery_status NOT IN ('on_time', 'late');

-- Orders without deliveries (for completed orders)
SELECT o.order_id, o.order_status
FROM fact_orders o
WHERE o.order_status = 'completed'
  AND NOT EXISTS (
    SELECT 1 
    FROM fact_deliveries d 
    WHERE d.order_id = o.order_id
  );

-- Deliveries for non-existent orders
SELECT d.order_id
FROM fact_deliveries d
WHERE NOT EXISTS (
  SELECT 1 
  FROM fact_orders o 
  WHERE o.order_id = d.order_id
);

-- Logical inconsistencies (actual before promised)
SELECT *
FROM fact_deliveries
WHERE actual_delivery_date < promised_delivery_date
  AND delivery_status = 'late';

