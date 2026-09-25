USE olist_ecommerce;


-- Query 1: Total Geolocation Records
SELECT 
    COUNT(*) AS total_geolocation_records
FROM geolocation;

-- Query 2: Unique Geolocation ZIP Codes
SELECT 
    COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_codes
FROM geolocation;

-- Query 3: Customers by State
SELECT 
    customer_state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC;

-- Query 4: Top 10 Customer States
SELECT 
    customer_state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 10;

-- Query 5: Top 10 Customer Cities
SELECT 
    customer_city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_city
ORDER BY customer_count DESC
LIMIT 10;

-- Query 6: Sellers by State
SELECT 
    seller_state,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_state
ORDER BY seller_count DESC;

-- Query 7: Top 10 Seller States
SELECT 
    seller_state,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_state
ORDER BY seller_count DESC
LIMIT 10;

-- Query 8: Top 10 Seller Cities
SELECT 
    seller_city,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_city
ORDER BY seller_count DESC
LIMIT 10;

-- Query 9: Orders by Customer State
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;

-- Query 10: Revenue by Customer State
SELECT 
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- Query 11: Top 10 Customer States by Revenue
SELECT 
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;


-- Query 12: Average Order Value by Customer State
SELECT 
    c.customer_state,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY average_order_value DESC;

-- Query 13: Orders by Seller State
SELECT 
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
ORDER BY total_orders DESC;

-- Query 14: Revenue by Seller State
SELECT 
    s.seller_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
ORDER BY total_revenue DESC;

-- Query 15: Top 10 Seller States by Revenue
SELECT 
    s.seller_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;


-- Query 16: Customer and Seller State Comparison
SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT s.seller_id) AS sellers
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY c.customer_state
ORDER BY customers DESC;

-- Query 17: Customers with Geolocation Data
SELECT 
    COUNT(DISTINCT c.customer_id) AS customers_with_geolocation
FROM customers c
JOIN geolocation g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;


-- Query 18: Customers without Geolocation Data
SELECT 
    COUNT(DISTINCT c.customer_id) AS customers_without_geolocation
FROM customers c
LEFT JOIN geolocation g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE g.geolocation_zip_code_prefix IS NULL;


-- Query 19: Customer Geolocation Coverage Rate
SELECT 
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN g.geolocation_zip_code_prefix IS NOT NULL 
            THEN c.customer_id 
        END) * 100.0
        / COUNT(DISTINCT c.customer_id),
        2
    ) AS geolocation_coverage_rate
FROM customers c
LEFT JOIN geolocation g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;

-- Query 20: Geographic Data Quality Check
SELECT 
    SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) 
        AS missing_zip_code,
    SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) 
        AS missing_latitude,
    SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) 
        AS missing_longitude,
    SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) 
        AS missing_city,
    SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) 
        AS missing_state
FROM geolocation;