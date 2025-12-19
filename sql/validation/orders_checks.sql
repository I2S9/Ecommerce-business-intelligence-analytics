-- ============================================
-- DATA QUALITY CHECKS: fact_orders
-- ============================================
-- Expected result: 0 rows for all checks
-- If any check returns rows, investigate data quality issues

-- Check 1: Duplicate orders
-- Issue: Multiple records with same order_id (should be unique)
-- Expected: 0 rows
SELECT order_id, COUNT(*) as duplicate_count
FROM fact_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check 2: Negative or zero amounts
-- Issue: Invalid order amounts (should be > 0)
-- Expected: 0 rows
SELECT order_id, total_amount
FROM fact_orders
WHERE total_amount <= 0;

-- Check 3: Missing customer_id
-- Issue: Orders without customer reference (data integrity)
-- Expected: 0 rows
SELECT order_id, customer_id
FROM fact_orders
WHERE customer_id IS NULL;

-- Check 4: Invalid order_status values
-- Issue: Status values not in allowed set
-- Expected: 0 rows
SELECT DISTINCT order_status
FROM fact_orders
WHERE order_status NOT IN ('completed', 'cancelled');

-- Check 5: Invalid region values
-- Issue: Region codes not in allowed set
-- Expected: 0 rows
SELECT DISTINCT region
FROM fact_orders
WHERE region NOT IN ('UK', 'DE', 'FR', 'ES');

-- Check 6: Future order dates (temporal inconsistency)
-- Issue: Orders dated in the future (data entry error)
-- Expected: 0 rows
SELECT order_id, order_date
FROM fact_orders
WHERE order_date > CURRENT_TIMESTAMP;

-- Check 7: Orders before business start date (temporal inconsistency)
-- Issue: Orders dated before business operations started
-- Expected: 0 rows (adjust date as needed)
SELECT order_id, order_date
FROM fact_orders
WHERE order_date < '2020-01-01';

-- Check 8: Orders with customer_id not in dim_customers (referential integrity)
-- Issue: Foreign key constraint violation
-- Expected: 0 rows
SELECT o.order_id, o.customer_id
FROM fact_orders o
WHERE NOT EXISTS (
    SELECT 1 
    FROM dim_customers c 
    WHERE c.customer_id = o.customer_id
);
