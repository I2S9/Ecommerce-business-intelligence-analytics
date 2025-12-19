-- Create fact_orders table
CREATE TABLE fact_orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date TIMESTAMP,
    order_status TEXT,
    total_amount REAL,
    region TEXT
);

-- Create dim_customers table
CREATE TABLE dim_customers (
    customer_id INTEGER PRIMARY KEY,
    signup_date TIMESTAMP,
    customer_segment TEXT
);

-- Create fact_deliveries table
CREATE TABLE fact_deliveries (
    order_id INTEGER,
    promised_delivery_date TIMESTAMP,
    actual_delivery_date TIMESTAMP,
    delivery_status TEXT,
    FOREIGN KEY (order_id) REFERENCES fact_orders(order_id)
);
