ALTER TABLE orders RENAME TO orders_old;
ALTER TABLE order_item RENAME TO order_item_old;

CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL,
    order_date TIMESTAMP,
    seller_id INT REFERENCES seller(seller_id),
    status VARCHAR(20),
    total_amount DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id, order_date)
) PARTITION BY RANGE (order_date);

CREATE TABLE order_8_2025 PARTITION OF orders FOR VALUES FROM ('2025-08-01') TO ('2025-09-01');
CREATE TABLE order_9_2025 PARTITION OF orders FOR VALUES FROM ('2025-09-01') TO ('2025-10-01');
CREATE TABLE order_10_2025  PARTITION OF orders FOR VALUES FROM ('2025-10-01') TO ('2025-11-01');
CREATE TABLE order_default PARTITION OF orders DEFAULT;

CREATE TABLE IF NOT EXISTS order_item (
    order_item_id SERIAL,
    order_id INT,
    product_id INT REFERENCES product(product_id),
    order_date TIMESTAMP,
    quantity INT,
    unit_price DECIMAL(12,2),
    subtotal DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   
    PRIMARY KEY (order_item_id, order_date),
    CONSTRAINT order_item_orders_fkey FOREIGN KEY (order_id, order_date) REFERENCES orders (order_id, order_date)
) PARTITION BY RANGE (order_date);

CREATE TABLE order_item_8_2025 PARTITION OF order_item FOR VALUES FROM ('2025-08-01') TO ('2025-09-01');
CREATE TABLE order_item_9_2025 PARTITION OF order_item FOR VALUES FROM ('2025-09-01') TO ('2025-10-01');
CREATE TABLE order_item_10_2025 PARTITION OF order_item FOR VALUES FROM ('2025-10-01') TO ('2025-11-01');
CREATE TABLE order_item_default PARTITION OF order_item DEFAULT;

-- Đổ dữ liệu bảng order 
INSERT INTO orders (order_id, order_date, seller_id, status, total_amount, created_at)
SELECT order_id, order_date, seller_id, status, total_amount, created_at 
FROM orders_old;

-- Đổ dữ liệu bảng order_item
INSERT INTO order_item (order_item_id, order_id, product_id, order_date, quantity, unit_price, subtotal, created_at)
SELECT order_item_id, order_id, product_id, order_date, quantity, unit_price, subtotal, created_at 
FROM order_item_old;

-- Tạo index cho cột product_id bảng order_item
CREATE INDEX idx_order_item_product_id ON order_item (product_id);

-- Reset sequence cho bảng order
SELECT setval(pg_get_serial_sequence('orders', 'order_id'), COALESCE(MAX(order_id), 1)) FROM orders;

-- Reset sequence cho bảng order_item
SELECT setval(pg_get_serial_sequence('order_item', 'order_item_id'), COALESCE(MAX(order_item_id), 1)) FROM order_item;

SELECT * FROM orders o 
SELECT * FROM order_item o 
