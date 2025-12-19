# KPI SQL Queries

This directory contains SQL queries implementing all defined KPIs.

## Structure

Each KPI has its own SQL file with:
- Comprehensive comments explaining the KPI
- CTEs (Common Table Expressions) for readability
- Window functions where appropriate
- Support for multiple temporal grains (daily, weekly, monthly)

## Files

### Revenue Metrics
- `01_total_revenue.sql` - Total Revenue (GMV)
- `02_average_order_value.sql` - Average Order Value (AOV)
- `03_revenue_by_region.sql` - Revenue by Region

### Order Metrics
- `04_order_completion_rate.sql` - Order Completion Rate
- `05_order_cancellation_rate.sql` - Order Cancellation Rate
- `06_total_orders.sql` - Total Order Count

### Customer Metrics
- `07_new_customer_acquisition.sql` - New Customer Count
- `08_customer_segment_distribution.sql` - Customer Segment Mix
- `09_first_order_value_by_segment.sql` - Average First Order Value by Segment

### Delivery Metrics
- `10_delivery_sla_compliance.sql` - Delivery SLA Compliance Rate
- `11_average_delivery_delay.sql` - Average Delivery Delay (Days)
- `12_on_time_delivery_rate.sql` - On-Time Delivery Rate
- `13_late_delivery_rate.sql` - Late Delivery Rate

### Regional Performance Metrics
- `14_regional_order_distribution.sql` - Orders by Region
- `15_regional_aov.sql` - Average Order Value by Region
- `16_regional_delivery_performance.sql` - Delivery SLA Compliance by Region

### Operational Metrics
- `17_order_status_distribution.sql` - Order Status Breakdown
- `18_delivery_status_distribution.sql` - Delivery Status Breakdown

## Usage

### SQLite

```bash
sqlite3 data/ecommerce.db < sql/kpi_queries/01_total_revenue.sql
```

### PostgreSQL

```bash
psql -d ecommerce_db -f sql/kpi_queries/01_total_revenue.sql
```

### Python/Pandas

```python
import pandas as pd
import sqlite3

conn = sqlite3.connect("data/ecommerce.db")

with open("sql/kpi_queries/01_total_revenue.sql", "r") as f:
    query = f.read()

df = pd.read_sql_query(query, conn)
```

## Features

- **CTEs**: All queries use Common Table Expressions for clarity
- **Window Functions**: Used where appropriate (ROW_NUMBER, etc.)
- **Temporal Grains**: Most queries support daily, weekly, and monthly aggregation
- **Commented**: Each query includes header comments explaining the KPI
- **Reusable**: Queries can be easily adapted for different date ranges

## Notes

- All queries are optimized for SQLite syntax
- Date functions use SQLite's `strftime()` and `DATE()` functions
- For PostgreSQL, replace `strftime()` with `TO_CHAR()` or `DATE_TRUNC()`
- Percentages are calculated as decimals (multiply by 100 for display)

