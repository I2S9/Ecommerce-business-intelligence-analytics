# SQL Scripts

This directory contains SQL scripts for the e-commerce analytics project.

## Structure

- `01_create_tables.sql` - Creates all database tables (fact and dimension tables)
- `validation/` - Data quality validation queries

## Usage

### SQLite

```bash
sqlite3 data/ecommerce.db < sql/01_create_tables.sql
```

### PostgreSQL

```bash
psql -d ecommerce_db -f sql/01_create_tables.sql
```

## Tables

- `fact_orders` - Order transactions
- `dim_customers` - Customer dimension
- `fact_deliveries` - Delivery information

