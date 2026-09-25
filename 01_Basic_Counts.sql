USE olist_ecommerce;

-- 1. Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 2. Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 3. Total Sellers
SELECT COUNT(*) AS total_sellers
FROM sellers;

-- 4. Total Order Items
SELECT COUNT(*) AS total_order_items
FROM order_items;

-- 5. Total Products
SELECT COUNT(*) AS total_products
FROM products;

-- 6. Total Payments
SELECT COUNT(*) AS total_payments
FROM payments;

-- 7. Total Reviews
SELECT COUNT(*) AS total_reviews
FROM reviews;

-- 8. Total Geolocation Records
SELECT COUNT(*) AS total_geolocation
FROM geolocation;


SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM orders;