# Data Quality Validation

This directory contains SQL scripts for comprehensive data quality validation.

## Files

- `orders_checks.sql` - Validation checks for fact_orders table
- `customers_checks.sql` - Validation checks for dim_customers table
- `deliveries_checks.sql` - Validation checks for fact_deliveries table
- `run_all_checks.sql` - Comprehensive validation script (runs all checks)

## Validation Categories

### 1. Duplicate Detection
- Identifies duplicate primary keys
- Expected result: 0 rows

### 2. Value Validation
- Checks for invalid enum values
- Checks for NULL values in required fields
- Checks for impossible numeric values (negative amounts, etc.)
- Expected result: 0 rows

### 3. Temporal Inconsistencies
- Future dates (data entry errors)
- Dates before business start
- Logical time ordering (e.g., delivery before order)
- Cross-table temporal validation
- Expected result: 0 rows

### 4. Referential Integrity
- Foreign key violations
- Orphaned records
- Expected result: 0 rows

### 5. Business Logic Validation
- Status inconsistencies
- Missing required records
- Expected result: 0 rows (or investigate business rules)

## Usage

### Run Individual Checks

```bash
# SQLite
sqlite3 data/ecommerce.db < sql/validation/orders_checks.sql

# PostgreSQL
psql -d ecommerce_db -f sql/validation/orders_checks.sql
```

### Run All Checks

```bash
# SQLite
sqlite3 data/ecommerce.db < sql/validation/run_all_checks.sql

# PostgreSQL
psql -d ecommerce_db -f sql/validation/run_all_checks.sql
```

## Expected Results

**All validation queries should return 0 rows.**

If any query returns rows:
1. Document the issue
2. Investigate the root cause
3. Fix the data or update the validation logic
4. Re-run the checks to verify

## Interpretation

- **0 rows returned**: Data quality check passed ✓
- **> 0 rows returned**: Data quality issue detected ✗
  - Review the returned records
  - Determine if it's a data issue or validation logic issue
  - Take appropriate action

