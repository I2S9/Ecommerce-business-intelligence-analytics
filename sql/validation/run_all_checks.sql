-- ============================================
-- COMPREHENSIVE DATA QUALITY VALIDATION
-- ============================================
-- This script runs all data quality checks
-- Expected: All queries should return 0 rows
-- If any query returns rows, investigate the data quality issues

-- ============================================
-- ORDERS VALIDATION
-- ============================================
.echo on
.headers on

SELECT '=== ORDERS CHECKS ===' as check_section;

-- Duplicate orders
SELECT 'Check 1: Duplicate orders' as check_name;
SELECT order_id, COUNT(*) as duplicate_count
FROM fact_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Negative amounts
SELECT 'Check 2: Negative or zero amounts' as check_name;
SELECT order_id, total_amount
FROM fact_orders
WHERE total_amount <= 0;

-- Missing customer_id
SELECT 'Check 3: Missing customer_id' as check_name;
SELECT order_id, customer_id
FROM fact_orders
WHERE customer_id IS NULL;

-- Invalid order_status
SELECT 'Check 4: Invalid order_status' as check_name;
SELECT DISTINCT order_status
FROM fact_orders
WHERE order_status NOT IN ('completed', 'cancelled');

-- Invalid region
SELECT 'Check 5: Invalid region' as check_name;
SELECT DISTINCT region
FROM fact_orders
WHERE region NOT IN ('UK', 'DE', 'FR', 'ES');

-- Future order dates
SELECT 'Check 6: Future order dates' as check_name;
SELECT order_id, order_date
FROM fact_orders
WHERE order_date > CURRENT_TIMESTAMP;

-- ============================================
-- CUSTOMERS VALIDATION
-- ============================================
SELECT '=== CUSTOMERS CHECKS ===' as check_section;

-- Duplicate customers
SELECT 'Check 1: Duplicate customers' as check_name;
SELECT customer_id, COUNT(*) as duplicate_count
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Missing signup_date
SELECT 'Check 2: Missing signup_date' as check_name;
SELECT customer_id, signup_date
FROM dim_customers
WHERE signup_date IS NULL;

-- Invalid customer_segment
SELECT 'Check 3: Invalid customer_segment' as check_name;
SELECT DISTINCT customer_segment
FROM dim_customers
WHERE customer_segment NOT IN ('VIP', 'Regular', 'New');

-- Future signup dates
SELECT 'Check 4: Future signup dates' as check_name;
SELECT customer_id, signup_date
FROM dim_customers
WHERE signup_date > CURRENT_TIMESTAMP;

-- ============================================
-- DELIVERIES VALIDATION
-- ============================================
SELECT '=== DELIVERIES CHECKS ===' as check_section;

-- Duplicate deliveries
SELECT 'Check 1: Duplicate deliveries' as check_name;
SELECT order_id, COUNT(*) as duplicate_count
FROM fact_deliveries
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Missing dates
SELECT 'Check 2: Missing dates' as check_name;
SELECT order_id, promised_delivery_date, actual_delivery_date
FROM fact_deliveries
WHERE promised_delivery_date IS NULL 
   OR actual_delivery_date IS NULL;

-- Invalid delivery_status
SELECT 'Check 3: Invalid delivery_status' as check_name;
SELECT DISTINCT delivery_status
FROM fact_deliveries
WHERE delivery_status NOT IN ('on_time', 'late');

-- ============================================
-- CROSS-TABLE VALIDATION
-- ============================================
SELECT '=== CROSS-TABLE CHECKS ===' as check_section;

-- Orders with customer_id not in dim_customers
SELECT 'Check 1: Orders with invalid customer_id' as check_name;
SELECT o.order_id, o.customer_id
FROM fact_orders o
WHERE NOT EXISTS (
    SELECT 1 
    FROM dim_customers c 
    WHERE c.customer_id = o.customer_id
);

-- Deliveries for non-existent orders
SELECT 'Check 2: Deliveries for non-existent orders' as check_name;
SELECT d.order_id
FROM fact_deliveries d
WHERE NOT EXISTS (
  SELECT 1 
  FROM fact_orders o 
  WHERE o.order_id = d.order_id
);

-- Customers with orders before signup
SELECT 'Check 3: Orders before customer signup' as check_name;
SELECT DISTINCT c.customer_id, c.signup_date, MIN(o.order_date) as first_order_date
FROM dim_customers c
INNER JOIN fact_orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.signup_date
HAVING MIN(o.order_date) < c.signup_date;

-- Delivery dates before order date
SELECT 'Check 4: Delivery dates before order date' as check_name;
SELECT d.order_id, o.order_date, d.promised_delivery_date, d.actual_delivery_date
FROM fact_deliveries d
INNER JOIN fact_orders o ON d.order_id = o.order_id
WHERE d.promised_delivery_date < o.order_date
   OR d.actual_delivery_date < o.order_date;

SELECT '=== VALIDATION COMPLETE ===' as check_section;

