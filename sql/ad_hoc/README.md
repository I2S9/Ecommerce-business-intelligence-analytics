# Ad Hoc Analysis Queries

This directory contains exploratory SQL queries for targeted business analysis beyond standard KPIs.

## Files

### 01_regional_performance_comparison.sql
**Question**: Which regions perform best across key metrics?
**Purpose**: Identify top-performing markets and opportunities for improvement
**Key Metrics**: Orders, revenue, AOV, delivery performance by region

### 02_temporal_trends_analysis.sql
**Question**: How do key metrics evolve over time?
**Purpose**: Identify growth trends, seasonality, and performance patterns
**Key Metrics**: Monthly trends with month-over-month growth calculations

### 03_cancellation_root_cause.sql
**Question**: Why are orders being cancelled? What patterns exist?
**Purpose**: Identify root causes of cancellations to reduce cancellation rate
**Key Metrics**: Cancellation patterns by region, segment, and delivery status

### 04_delivery_delay_analysis.sql
**Question**: What causes delivery delays? Are there regional or temporal patterns?
**Purpose**: Identify factors contributing to late deliveries
**Key Metrics**: Delay patterns by region, month, and day type

### 05_customer_segment_performance.sql
**Question**: How do different customer segments perform?
**Purpose**: Understand segment value and optimize targeting strategies
**Key Metrics**: Revenue, orders, AOV by customer segment

### 06_high_value_customer_analysis.sql
**Question**: Who are our high-value customers and what are their characteristics?
**Purpose**: Identify customer segments for retention and upselling
**Key Metrics**: Customer lifetime value quartiles and segment characteristics

## Usage

```bash
# SQLite
sqlite3 data/ecommerce.db < sql/ad_hoc/01_regional_performance_comparison.sql

# PostgreSQL
psql -d ecommerce_db -f sql/ad_hoc/01_regional_performance_comparison.sql
```

## Analysis Types

- **Comparisons**: Regional, segment, temporal comparisons
- **Root Cause Analysis**: Cancellation and delivery delay investigations
- **Trend Analysis**: Time-series analysis with growth calculations
- **Customer Analysis**: Segmentation and lifetime value analysis

