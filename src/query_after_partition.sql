SET enable_partitionwise_join = on;
SET enable_partitionwise_aggregate = on;

--1. Total revenue per month
SELECT TO_CHAR(o.order_date, 'MM-YYYY') AS "month",
	SUM(o.total_amount) AS total_revenue
FROM orders o 
WHERE o.status NOT IN ('CANCELLED', 'RETURNED')
GROUP BY "month" 
ORDER BY "month";

--2. Orders filtered by seller and date
SELECT * 
FROM orders o 
WHERE o.seller_id IN (1, 2, 3, 4, 5)
	AND o.order_date BETWEEN '2025-10-01' AND '2025-10-31'

--3. Filter data in `order_item` by product_id
SELECT *
FROM order_item oi
WHERE oi.product_id IN (1,2);

--4. Find order with highest total_amount
SELECT *
FROM orders o 
ORDER BY total_amount DESC
LIMIT 1;
--5. List products with highest quantity sold
EXPLAIN ANALYZE	
SELECT oi.product_id, SUM(oi.quantity) AS quantity_sold
FROM order_item oi 
	INNER JOIN orders o ON oi.order_id = o.order_id AND oi.order_date = o.order_date
WHERE o.status NOT IN ('CANCELLED', 'RETURNED')
GROUP BY oi.product_id 
ORDER BY quantity_sold DESC
LIMIT 10;

--6. Orders by Seller in October
SELECT *
FROM orders o 
WHERE o.seller_id IN (1, 2, 3, 4, 5)
	AND order_date >= '2025-10-01' AND order_date < '2025-11-01'

--7. Revenue per Product per Month
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS "month",
    product_id,
    SUM(subtotal) AS product_revenue
FROM order_item
GROUP BY "month", product_id
ORDER BY product_revenue DESC;

--8. Products Sold per Seller
SELECT 
    o.seller_id,
    COUNT(DISTINCT oi.product_id) AS unique_products_sold, -- Tổng số loạt mặt hàng bán được
    SUM(oi.quantity) AS total_products_sold -- Tổng số lượng hàng bán được
FROM orders o
	INNER JOIN order_item oi ON o.order_id = oi.order_id AND oi.order_date = o.order_date
WHERE o.status NOT IN ('CANCELLED', 'RETURNED')
GROUP BY o.seller_id
ORDER BY total_products_sold DESC;





















