-- ============================================
-- DATA QUALITY CHECKS: fact_deliveries
-- ============================================
-- Expected result: 0 rows for all checks
-- If any check returns rows, investigate data quality issues

-- Check 1: Duplicate deliveries for same order
-- Issue: Multiple delivery records for same order_id (should be unique)
-- Expected: 0 rows
SELECT order_id, COUNT(*) as duplicate_count
FROM fact_deliveries
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check 2: Missing dates
-- Issue: Missing promised or actual delivery dates (required fields)
-- Expected: 0 rows
SELECT order_id, promised_delivery_date, actual_delivery_date
FROM fact_deliveries
WHERE promised_delivery_date IS NULL 
   OR actual_delivery_date IS NULL;

-- Check 3: Invalid delivery_status values
-- Issue: Status values not in allowed set
-- Expected: 0 rows
SELECT DISTINCT delivery_status
FROM fact_deliveries
WHERE delivery_status NOT IN ('on_time', 'late');

-- Check 4: Orders without deliveries (for completed orders)
-- Issue: Completed orders missing delivery records (data completeness)
-- Expected: 0 rows (or investigate business logic)
SELECT o.order_id, o.order_status, o.order_date
FROM fact_orders o
WHERE o.order_status = 'completed'
  AND NOT EXISTS (
    SELECT 1 
    FROM fact_deliveries d 
    WHERE d.order_id = o.order_id
  );

-- Check 5: Deliveries for non-existent orders (referential integrity)
-- Issue: Delivery records referencing orders that don't exist
-- Expected: 0 rows
SELECT d.order_id, d.promised_delivery_date
FROM fact_deliveries d
WHERE NOT EXISTS (
  SELECT 1 
  FROM fact_orders o 
  WHERE o.order_id = d.order_id
);

-- Check 6: Deliveries for cancelled orders (business logic)
-- Issue: Delivery records for orders that were cancelled
-- Expected: 0 rows (or investigate business logic)
SELECT d.order_id, o.order_status
FROM fact_deliveries d
INNER JOIN fact_orders o ON d.order_id = o.order_id
WHERE o.order_status = 'cancelled';

-- Check 7: Actual delivery before promised date but marked as late (logical inconsistency)
-- Issue: Status doesn't match actual delivery timing
-- Expected: 0 rows
SELECT order_id, promised_delivery_date, actual_delivery_date, delivery_status
FROM fact_deliveries
WHERE actual_delivery_date <= promised_delivery_date
  AND delivery_status = 'late';

-- Check 8: Actual delivery after promised date but marked as on_time (logical inconsistency)
-- Issue: Status doesn't match actual delivery timing
-- Expected: 0 rows
SELECT order_id, promised_delivery_date, actual_delivery_date, delivery_status
FROM fact_deliveries
WHERE actual_delivery_date > promised_delivery_date
  AND delivery_status = 'on_time';

-- Check 9: Delivery dates before order date (temporal inconsistency)
-- Issue: Delivery promised/actual before order was placed (logical error)
-- Expected: 0 rows
SELECT d.order_id, o.order_date, d.promised_delivery_date, d.actual_delivery_date
FROM fact_deliveries d
INNER JOIN fact_orders o ON d.order_id = o.order_id
WHERE d.promised_delivery_date < o.order_date
   OR d.actual_delivery_date < o.order_date;

-- Check 10: Promised delivery before actual delivery but actual is earlier (temporal inconsistency)
-- Issue: Actual delivery happened before promised date (rare but possible, verify)
-- Note: This might be valid if delivery was early, but worth investigating
SELECT order_id, promised_delivery_date, actual_delivery_date
FROM fact_deliveries
WHERE actual_delivery_date < promised_delivery_date;
