## fact_orders
- order_id (int, PK)
- customer_id (int, FK)
- order_date (timestamp)
- order_status (string)
- total_amount (float)
- region (string)

## fact_deliveries
- order_id (int, FK)
- promised_delivery_date (timestamp)
- actual_delivery_date (timestamp)
- delivery_status (string)

## dim_customers
- customer_id (int, PK)
- signup_date (timestamp)
- customer_segment (string)

