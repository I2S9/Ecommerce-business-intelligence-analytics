-- Indexes for fact_orders
CREATE INDEX idx_orders_customer_id ON fact_orders(customer_id);
CREATE INDEX idx_orders_order_date ON fact_orders(order_date);
CREATE INDEX idx_orders_region ON fact_orders(region);
CREATE INDEX idx_orders_status ON fact_orders(order_status);

-- Indexes for fact_deliveries
CREATE INDEX idx_deliveries_order_id ON fact_deliveries(order_id);
CREATE INDEX idx_deliveries_status ON fact_deliveries(delivery_status);

-- Indexes for dim_customers
CREATE INDEX idx_customers_segment ON dim_customers(customer_segment);

