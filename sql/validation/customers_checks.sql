-- ============================================
-- DATA QUALITY CHECKS: dim_customers
-- ============================================
-- Expected result: 0 rows for all checks
-- If any check returns rows, investigate data quality issues

-- Check 1: Duplicate customers
-- Issue: Multiple records with same customer_id (should be unique)
-- Expected: 0 rows
SELECT customer_id, COUNT(*) as duplicate_count
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check 2: Missing signup_date
-- Issue: Customers without signup date (required field)
-- Expected: 0 rows
SELECT customer_id, signup_date
FROM dim_customers
WHERE signup_date IS NULL;

-- Check 3: Invalid customer_segment values
-- Issue: Segment values not in allowed set
-- Expected: 0 rows
SELECT DISTINCT customer_segment
FROM dim_customers
WHERE customer_segment NOT IN ('VIP', 'Regular', 'New');

-- Check 4: Future signup dates (temporal inconsistency)
-- Issue: Signup dates in the future (data entry error)
-- Expected: 0 rows
SELECT customer_id, signup_date
FROM dim_customers
WHERE signup_date > CURRENT_TIMESTAMP;

-- Check 5: Signup dates before business start (temporal inconsistency)
-- Issue: Customers signed up before business operations started
-- Expected: 0 rows (adjust date as needed)
SELECT customer_id, signup_date
FROM dim_customers
WHERE signup_date < '2020-01-01';

-- Check 6: Customers with orders before signup (temporal inconsistency)
-- Issue: Orders placed before customer signup date (logical error)
-- Expected: 0 rows
SELECT DISTINCT c.customer_id, c.signup_date, MIN(o.order_date) as first_order_date
FROM dim_customers c
INNER JOIN fact_orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.signup_date
HAVING MIN(o.order_date) < c.signup_date;
