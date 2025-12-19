# KPI Definitions

Official list of Key Performance Indicators for the e-commerce business intelligence project.

## Revenue Metrics

### Total Revenue (GMV)
- **Name**: Total Revenue (Gross Merchandise Value)
- **Formula**: `SUM(total_amount) WHERE order_status = 'completed'`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Total value of completed orders. Represents the gross sales volume before any deductions. Critical for tracking business growth and financial performance.

### Average Order Value (AOV)
- **Name**: Average Order Value
- **Formula**: `SUM(total_amount) / COUNT(DISTINCT order_id) WHERE order_status = 'completed'`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Average amount spent per completed order. Higher AOV indicates better customer spending behavior or effective upselling strategies. Target: increase over time.

### Revenue by Region
- **Name**: Regional Revenue Distribution
- **Formula**: `SUM(total_amount) GROUP BY region WHERE order_status = 'completed'`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Revenue breakdown by geographic region. Identifies top-performing markets and opportunities for regional expansion or optimization.

## Order Metrics

### Order Completion Rate
- **Name**: Order Completion Rate
- **Formula**: `COUNT(*) WHERE order_status = 'completed' / COUNT(*) * 100`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Percentage of orders that reach completion status. Lower rates indicate potential issues in checkout process, payment, or customer satisfaction. Target: >90%.

### Order Cancellation Rate
- **Name**: Order Cancellation Rate
- **Formula**: `COUNT(*) WHERE order_status = 'cancelled' / COUNT(*) * 100`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Percentage of orders cancelled. High cancellation rates may indicate pricing issues, delivery concerns, or customer experience problems. Target: <10%.

### Total Orders
- **Name**: Total Order Count
- **Formula**: `COUNT(DISTINCT order_id)`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Total number of orders placed. Primary volume metric for tracking business activity and growth trends.

## Customer Metrics

### New Customer Acquisition
- **Name**: New Customer Count
- **Formula**: `COUNT(DISTINCT customer_id) WHERE signup_date BETWEEN start_date AND end_date`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Number of new customers acquired in the period. Essential for tracking marketing effectiveness and business growth. Target: steady growth month-over-month.

### Customer Segment Distribution
- **Name**: Customer Segment Mix
- **Formula**: `COUNT(DISTINCT customer_id) GROUP BY customer_segment`
- **Temporal Grain**: Snapshot (current state)
- **Business Interpretation**: Distribution of customers across segments (VIP, Regular, New). Helps understand customer base composition and prioritize retention strategies.

### Customer Lifetime Value (CLV) - First Order
- **Name**: Average First Order Value by Segment
- **Formula**: `AVG(total_amount) GROUP BY customer_segment WHERE order_status = 'completed' AND order_date = MIN(order_date)`
- **Temporal Grain**: Monthly
- **Business Interpretation**: Average first order value by customer segment. Indicates initial customer engagement level and potential for upselling.

## Delivery Metrics

### Delivery SLA Compliance
- **Name**: Delivery SLA Compliance Rate
- **Formula**: `COUNT(*) WHERE delivery_status = 'on_time' / COUNT(*) * 100`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Percentage of orders delivered within promised delivery time. Critical customer satisfaction metric. Target: >95%.

### Average Delivery Delay
- **Name**: Average Delivery Delay (Days)
- **Formula**: `AVG(JULIANDAY(actual_delivery_date) - JULIANDAY(promised_delivery_date)) WHERE delivery_status = 'late'`
- **Temporal Grain**: Weekly, Monthly
- **Business Interpretation**: Average number of days late for delayed deliveries. Helps identify delivery performance issues and set realistic expectations. Target: minimize delay days.

### On-Time Delivery Rate
- **Name**: On-Time Delivery Rate
- **Formula**: `COUNT(*) WHERE actual_delivery_date <= promised_delivery_date / COUNT(*) * 100`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Percentage of deliveries completed on or before promised date. Directly impacts customer satisfaction and retention. Target: >95%.

### Late Delivery Rate
- **Name**: Late Delivery Rate
- **Formula**: `COUNT(*) WHERE delivery_status = 'late' / COUNT(*) * 100`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Percentage of deliveries that arrive after promised date. High rates indicate operational issues requiring logistics optimization. Target: <5%.

## Regional Performance Metrics

### Regional Order Distribution
- **Name**: Orders by Region
- **Formula**: `COUNT(DISTINCT order_id) GROUP BY region`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Order volume distribution across regions. Identifies market penetration and regional growth opportunities.

### Regional AOV
- **Name**: Average Order Value by Region
- **Formula**: `AVG(total_amount) GROUP BY region WHERE order_status = 'completed'`
- **Temporal Grain**: Weekly, Monthly
- **Business Interpretation**: Average order value per region. Highlights regional purchasing power differences and pricing strategy effectiveness.

### Regional Delivery Performance
- **Name**: Delivery SLA Compliance by Region
- **Formula**: `COUNT(*) WHERE delivery_status = 'on_time' / COUNT(*) * 100 GROUP BY region`
- **Temporal Grain**: Weekly, Monthly
- **Business Interpretation**: Delivery performance by region. Identifies regional logistics challenges and operational efficiency gaps.

## Operational Metrics

### Order Status Distribution
- **Name**: Order Status Breakdown
- **Formula**: `COUNT(*) GROUP BY order_status`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Distribution of orders across statuses. Monitors order flow and identifies bottlenecks in order processing pipeline.

### Delivery Status Distribution
- **Name**: Delivery Status Breakdown
- **Formula**: `COUNT(*) GROUP BY delivery_status`
- **Temporal Grain**: Daily, Weekly, Monthly
- **Business Interpretation**: Distribution of deliveries across statuses. Tracks delivery performance and identifies areas for improvement.

## Notes

- All monetary values are in the base currency (adjust as needed)
- All date calculations use the database timestamp fields
- Percentages are calculated as decimals (multiply by 100 for display)
- KPIs should be calculated excluding test/void orders if applicable
- Temporal grains can be aggregated (e.g., daily can be rolled up to weekly/monthly)

