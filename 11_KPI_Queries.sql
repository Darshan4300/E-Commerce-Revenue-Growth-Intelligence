USE olist_ecommerce;

-- Query 1: Total Customers
SELECT 
    COUNT(*) AS total_customers
FROM customers;

-- Query 2: Total Orders
SELECT 
    COUNT(*) AS total_orders
FROM orders;

-- Query 3: Total Products
SELECT 
    COUNT(*) AS total_products
FROM products;

-- Query 4: Total Sellers
SELECT 
    COUNT(*) AS total_sellers
FROM sellers;

-- Query 5: Total Items Sold
SELECT 
    COUNT(*) AS total_items_sold
FROM order_items;

-- Query 6: Total Product Revenue
SELECT 
    ROUND(SUM(price), 2) AS total_product_revenue
FROM order_items;

-- Query 7: Total Freight Value
SELECT 
    ROUND(SUM(freight_value), 2) AS total_freight
FROM order_items;

-- Query 8: Total Sales Value Including Freight
SELECT 
    ROUND(SUM(price + freight_value), 2) AS total_sales_value
FROM order_items;

-- Query 9: Average Order Value
SELECT 
    ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM order_items;

-- Query 10: Average Item Price
SELECT 
    ROUND(AVG(price), 2) AS average_item_price
FROM order_items;

-- Query 11: Delivered Orders
SELECT 
    COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';

-- Query 12: Delivered Order Rate
SELECT 
    ROUND(
        COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) 
        * 100.0 / COUNT(*),
        2
    ) AS delivered_order_rate
FROM orders;

-- Query 13: Canceled Orders
SELECT 
    COUNT(*) AS canceled_orders
FROM orders
WHERE order_status = 'canceled';

-- Query 14: Cancellation Rate
SELECT 
    ROUND(
        COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) 
        * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders;

-- Query 15: Positive Review Rate
SELECT 
    ROUND(
        COUNT(CASE WHEN review_score IN (4, 5) THEN 1 END)
        * 100.0 / COUNT(*),
        2
    ) AS positive_review_rate
FROM reviews;

-- Query 16: Average Review Score
SELECT 
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;

-- Query 17: Average Items per Order
SELECT 
    ROUND(
        COUNT(*) * 1.0 / COUNT(DISTINCT order_id),
        2
    ) AS average_items_per_order
FROM order_items;

-- Query 18: Total Payment Value
SELECT 
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments;

-- Query 19: Average Payment Value
SELECT 
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments;

-- Query 20: Average Payment Installments
SELECT 
    ROUND(AVG(payment_installments), 2) AS average_payment_installments
FROM payments;

-- Query 21: Geolocation Coverage Rate
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

-- Query 22: Top Customer State by Customer Count
SELECT 
    customer_state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 1;

-- Query 23: Top Customer State by Revenue
SELECT 
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 1;

-- Query 24: Top Product Category by Revenue
SELECT 
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 1;

-- Query 25: Top Seller by Revenue
SELECT 
    seller_id,
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 1;