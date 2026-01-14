--=====================TẠO INDEX========================

-- Index hỗ trợ lọc theo ngày & trạng thái bảng orders
CREATE INDEX IF NOT EXISTS idx_orders_date_status 
ON orders (order_date, status);

-- Index hỗ trợ lọc theo ngày & seller bảng orders
CREATE INDEX IF NOT EXISTS idx_orders_seller_date 
ON orders (seller_id, order_date);

-- Index hỗ trợ order_item JOIN vào bảng orders
CREATE INDEX IF NOT EXISTS idx_order_item_join_fkey 
ON order_item (order_id, order_date);

-- Index tối ưu lọc Category, Brand, Seller cho bảng Product
CREATE INDEX IF NOT EXISTS idx_products_category_id ON product(category_id);
CREATE INDEX IF NOT EXISTS idx_products_brand_id ON product(brand_id);
CREATE INDEX IF NOT EXISTS idx_products_seller_id ON product(seller_id); 

ANALYZE orders;
ANALYZE order_item;
ANALYZE product;

--=====================TẠO FUNCTION========================
-- Monthly Revenue Report
CREATE OR REPLACE FUNCTION get_monthly_revenue(p_start_date DATE, p_end_date DATE)
RETURNS TABLE("month" TEXT, total_orders BIGINT, total_quantity BIGINT, total_revenue NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT 
		TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM') AS "month", 
		COUNT(o.order_id) AS total_orders,
		COALESCE(SUM(oi.quantity), 0) AS total_quantity, 
		COALESCE(SUM(oi.subtotal), 0) AS total_revenue
	FROM orders o
		INNER JOIN order_item oi ON o.order_id = oi.order_id AND o.order_date = oi.order_date
	WHERE o.status NOT IN ('CANCELLED', 'RETURNED')
		AND o.order_date BETWEEN p_start_date AND p_end_date
	GROUP BY "month"
	ORDER BY "month";
END;
$$;

SELECT * FROM get_monthly_revenue('2025-09-01', '2025-10-31');

-- Daily Revenue Report
CREATE OR REPLACE FUNCTION get_daily_revenue(p_start_date DATE, p_end_date DATE, p_product_list TEXT)
RETURNS TABLE("date" DATE, total_orders BIGINT, total_quantity BIGINT, total_revenue NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT 
		DATE(o.order_date) AS "date", 
		COUNT(DISTINCT o.order_id) AS total_orders,
		COALESCE(SUM(oi.quantity), 0) AS total_quantity, 
		COALESCE(SUM(oi.subtotal), 0) AS total_revenue
	FROM orders o
		INNER JOIN order_item oi ON o.order_id = oi.order_id AND o.order_date = oi.order_date
	WHERE o.status NOT IN ('CANCELLED', 'RETURNED')
		AND o.order_date BETWEEN p_start_date AND p_end_date
		AND oi.product_id = ANY(string_to_array(p_product_list, ',')::int[])
	GROUP BY date
	ORDER BY date;
END;
$$;

SELECT * FROM get_daily_revenue('2025-10-01', '2025-10-15', '1,2,3,4');



-- Seller Performance Report
CREATE OR REPLACE FUNCTION get_seller_performance(
    p_start_date DATE,
    p_end_date DATE,
    p_category_id INT DEFAULT NULL,
    p_brand_id INT DEFAULT NULL
)
RETURNS TABLE (seller_id INT, seller_name TEXT, total_orders BIGINT, total_quantity BIGINT, total_revenue NUMERIC) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
	SELECT 
		o.seller_id,
		MAX(s.seller_name) AS seller_name,
		COUNT(DISTINCT o.order_id) AS total_orders,
		SUM(oi.quantity) AS total_quantity,
		SUM(oi.subtotal) AS total_revenue
	FROM orders o
		INNER JOIN order_item oi ON o.order_id = oi.order_id AND o.order_date = oi.order_date
		INNER JOIN seller s ON o.seller_id  = s.seller_id 
		LEFT OUTER JOIN product p ON oi.product_id = p.product_id 
	WHERE o.status NOT IN ('CANCELLED', 'RETURNED')
		AND o.order_date BETWEEN p_start_date AND p_end_date
		AND (p_category_id IS NULL OR p.category_id = p_category_id)
		AND (p_brand_id IS NULL OR p.brand_id = p_brand_id)
	GROUP BY o.seller_id
	ORDER BY total_revenue DESC;
	END;
$$;

SELECT * FROM get_seller_performance('2025-01-01', '2025-12-31', 5, 1);



-- Top Products per Brand
CREATE OR REPLACE FUNCTION get_top_products_per_brand(
    p_start_date DATE,
    p_end_date DATE,
    p_seller_list TEXT DEFAULT NULL 
)
RETURNS TABLE (brand_id INT, brand_name TEXT, product_id INT, product_name TEXT, total_quantity BIGINT, total_revenue NUMERIC) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.brand_id,
        MAX(b.brand_name) AS brand_name,
        p.product_id,
        MAX(p.product_name) AS product_name,
        SUM(oi.quantity) AS total_quantity,
        SUM(oi.subtotal) AS total_revenue
    FROM orders o
		INNER JOIN order_item oi ON o.order_id = oi.order_id AND o.order_date = oi.order_date
    	INNER JOIN product p ON oi.product_id = p.product_id
    	INNER JOIN brand b ON p.brand_id = b.brand_id
	WHERE o.status NOT IN ('CANCELLED', 'RETURNED')
		AND o.order_date BETWEEN p_start_date AND p_end_date
		AND (p_seller_list IS NULL OR o.seller_id = ANY(string_to_array(p_seller_list, ',')::int[]))
    GROUP BY b.brand_id, p.product_id
    ORDER BY total_quantity DESC;
END;
$$;

SELECT * FROM get_top_products_per_brand('2025-10-01', '2025-10-31', '15,12,2');



-- Orders Status Summary
CREATE OR REPLACE FUNCTION get_order_status_summary(
    p_start_date DATE,
    p_end_date DATE,
    p_seller_list TEXT DEFAULT NULL,
    p_category_list TEXT DEFAULT NULL
)
RETURNS TABLE (status VARCHAR(20), total_orders BIGINT, total_revenue NUMERIC) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.status,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.subtotal) AS total_revenue
    FROM orders o
    	INNER JOIN order_item oi ON o.order_id = oi.order_id AND o.order_date = oi.order_date
    	LEFT JOIN product p ON oi.product_id = p.product_id
    WHERE o.order_date BETWEEN p_start_date AND p_end_date
      AND (p_seller_list IS NULL OR o.seller_id = ANY(string_to_array(p_seller_list, ',')::int[]))
      AND (p_category_list IS NULL OR p.category_id = ANY(string_to_array(p_category_list, ',')::int[]))
    GROUP BY o.status
    ORDER BY total_orders DESC;
END;
$$;

SELECT * FROM get_order_status_summary('2025-10-01', '2025-10-31','22,21','5,4');

