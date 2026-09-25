USE olist_ecommerce;

SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';

SELECT COUNT(*) AS canceled_orders
FROM orders
WHERE order_status = 'canceled';

-- Calculation: Delivered Order Rate (%)
SELECT 
    ROUND(
        COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) * 100.0
        / COUNT(*), 
        2
    ) AS delivered_order_rate
FROM orders;

-- Calculation: Cancellation Rate (%)
SELECT 
    ROUND(
        COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders;

-- Calculation: Non-Delivered Orders
SELECT COUNT(*) AS non_delivered_orders
FROM orders
WHERE order_status <> 'delivered';

-- Calculation: Non-Delivered Order Rate (%)
SELECT 
    ROUND(
        COUNT(CASE WHEN order_status <> 'delivered' THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS non_delivered_order_rate
FROM orders;

-- Calculation: Orders by Status (Highest to Lowest)
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Calculation: Top 3 Order Statuses
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC
LIMIT 3;

-- Calculation: Order Date Range
SELECT 
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date
FROM orders;

-- Calculation: Orders by Year
SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;

-- Calculation: Orders by Month
SELECT 
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY MONTH(order_purchase_timestamp)
ORDER BY order_month;

-- Calculation: Average Items per Order
SELECT 
    ROUND(
        COUNT(*) / COUNT(DISTINCT order_id),
        2
    ) AS average_items_per_order
FROM order_items;

-- Calculation: Average Order Value
SELECT 
    ROUND(
        SUM(price) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;

-- Calculation: Orders per Customer
SELECT 
    customer_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- Calculation: Customer Order Frequency
SELECT 
    total_orders,
    COUNT(*) AS number_of_customers
FROM (
    SELECT 
        customer_id,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY customer_id
) AS customer_orders
GROUP BY total_orders
ORDER BY total_orders;

-- Calculation: Orders by Day of Week
SELECT 
    DAYNAME(order_purchase_timestamp) AS day_of_week,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DAYNAME(order_purchase_timestamp)
ORDER BY total_orders DESC;